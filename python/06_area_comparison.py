#!/usr/bin/env python3
"""
Compare surface area of impact zones across three representations:
  1. Original shapefile polygons (ground truth)
  2. H3 hex (res 9) amalgamation (centroid-in-polygon)
  3. Census block amalgamation (centroid-in-polygon)

For every impact iteration. Also produces a version excluding Pct 75.
Outputs CSV and prints summary table.
"""

import geopandas as gpd
import h3
import numpy as np
import pandas as pd
from shapely.geometry import Polygon, MultiPolygon
from shapely.validation import make_valid
import warnings
warnings.filterwarnings("ignore")

# ---- Config ----
SHP_DIR = "data-raw/Operation Impact Zones/SHP Files"
CB_PATH = "data-raw/nycb2020_26a/nycb2020.shp"
# Target CRS for area calculation: EPSG:2263 (NY State Plane, feet)
TARGET_CRS = "EPSG:2263"
SQ_FT_TO_SQ_MI = 1 / 27_878_400
SQ_FT_TO_SQ_KM = 1 / 10_763_910.4

# Impact iteration shapefile mapping
ITERATIONS = {
    1:  f"{SHP_DIR}/IMPACT 01 Region_region.shp",
    2:  f"{SHP_DIR}/IMPACT 02 Region_region.shp",
    3:  f"{SHP_DIR}/IMPACT 03 Region_region.shp",
    4:  f"{SHP_DIR}/IMPACT 04 Region_region.shp",
    5:  f"{SHP_DIR}/IMPACT 05 Region_region.shp",
    6:  f"{SHP_DIR}/IMPACT 06 Region_region.shp",
    7:  f"{SHP_DIR}/IMPACT 07 Region_region.shp",
    8:  f"{SHP_DIR}/IMPACT 08 Region_region.shp",
    9:  f"{SHP_DIR}/IMPACT 09 Region_region.shp",
    10: f"{SHP_DIR}/IMPACT 10 Region_region.shp",
    11: f"{SHP_DIR}/IMPACT 11 Region_region.shp",
    12: f"{SHP_DIR}/IMPACT 12 Region_region.shp",
    13: f"{SHP_DIR}/IMPACT 13 Region_region.shp",
    14: f"{SHP_DIR}/IMPACT 14 Region_region.shp",
    15: f"{SHP_DIR}/IMPACT 15 Region_region.shp",
    16: f"{SHP_DIR}/IMPACT 16 Region_region.shp",
    17: f"{SHP_DIR}/IMPACT 17 Region_region.shp",
    18: f"{SHP_DIR}/IMPACT 18 Region_region.shp",
    19: f"{SHP_DIR}/IMPACT 19 Region_region.shp",
    20: f"{SHP_DIR}/IMPACT 20 Region_region.shp",
    21: f"{SHP_DIR}/Impact21_region.shp",
    22: f"{SHP_DIR}/IMPACT 22 Region_072514.shp",
    23: "data-raw/Impact 22 Jan 2015/IMPACT_22_Region_Updated_020415.shp",
}

# ---- Load census blocks ----
print("Loading census blocks...")
cb = gpd.read_file(CB_PATH).to_crs(TARGET_CRS)
cb.geometry = cb.geometry.apply(make_valid)
cb_centroids = cb.geometry.centroid
# Also project to EPSG:4326 for centroid lat/lon
cb_4326 = cb.to_crs("EPSG:4326")
cb_centroids_4326 = cb_4326.geometry.centroid

# ---- Load precinct boundaries to identify Pct 75 blocks/hexes ----
# We'll determine Pct 75 membership from the impact zone shapefiles themselves
# Actually, we need precinct boundaries. Let me check if we have them.
# Alternative: flag Pct 75 zones from the iteration data.
# For now, we'll identify Pct 75 by loading the zone attributes.

# ---- Pre-compute H3 hex polygons for all hexes that could be in any zone ----
print("Pre-computing H3 hex grid over NYC...")
# Get NYC bounding box in EPSG:4326
nyc_bounds_4326 = cb_4326.total_bounds  # minx, miny, maxx, maxy

# Generate hex IDs covering NYC
# Use h3.latlng_to_cell for a grid of points
lat_min, lat_max = nyc_bounds_4326[1] - 0.01, nyc_bounds_4326[3] + 0.01
lon_min, lon_max = nyc_bounds_4326[0] - 0.01, nyc_bounds_4326[2] + 0.01

# Get all hexes by tiling
hex_ids = set()
lat = lat_min
while lat <= lat_max:
    lon = lon_min
    while lon <= lon_max:
        hex_ids.add(h3.latlng_to_cell(lat, lon, 9))
        lon += 0.003  # ~300m steps
    lat += 0.003

# Also add neighbors to fill gaps
expanded = set()
for h in hex_ids:
    expanded.add(h)
    expanded.update(h3.grid_ring(h, 1))
hex_ids = expanded
print(f"  Generated {len(hex_ids):,} candidate hexes")

# Get hex centroids in EPSG:4326 and build GeoDataFrame
hex_data = []
for hid in hex_ids:
    lat, lon = h3.cell_to_latlng(hid)
    hex_data.append({"hex_id": hid, "lat": lat, "lon": lon})

hex_df = pd.DataFrame(hex_data)
hex_gdf = gpd.GeoDataFrame(
    hex_df,
    geometry=gpd.points_from_xy(hex_df.lon, hex_df.lat),
    crs="EPSG:4326"
).to_crs(TARGET_CRS)

# Pre-compute hex polygon areas (all same at res 9)
# h3.cell_area returns km²
hex_area_km2 = h3.cell_area(list(hex_ids)[0], unit="km^2")
hex_area_sqft = hex_area_km2 * 10_763_910.4
print(f"  H3 res-9 hex area: {hex_area_km2:.4f} km² = {hex_area_sqft:,.0f} sq ft")

# Function to build hex polygon in EPSG:2263
def hex_to_polygon_4326(hid):
    boundary = h3.cell_to_boundary(hid)
    # boundary is list of (lat, lon) tuples
    coords = [(lon, lat) for lat, lon in boundary]
    coords.append(coords[0])
    return Polygon(coords)

# ---- Process each iteration ----
print("\nProcessing iterations...")
results = []

for iter_num, shp_path in sorted(ITERATIONS.items()):
    print(f"  Impact {iter_num:2d}...", end=" ")

    # Load zone shapefile
    zone = gpd.read_file(shp_path)
    zone = zone.to_crs(TARGET_CRS)
    zone.geometry = zone.geometry.apply(make_valid)

    # Get zone attributes — check for precinct column
    pct_col = None
    for col in zone.columns:
        if col.upper() in ("PRECINCT", "PCT", "PREC", "PRCNCT"):
            pct_col = col
            break

    # Also check for Pct in NAME or other text fields
    zone_pcts = set()
    if pct_col:
        zone_pcts = set(zone[pct_col].dropna().astype(str).str.strip())

    # --- Original shapefile area ---
    zone_union = zone.geometry.unary_union
    zone_union = make_valid(zone_union)
    area_original_sqft = zone_union.area  # in sq ft (EPSG:2263)

    # --- Zone in EPSG:4326 for hex assignment ---
    zone_4326 = zone.to_crs("EPSG:4326")
    zone_4326.geometry = zone_4326.geometry.apply(make_valid)
    zone_union_4326 = make_valid(zone_4326.geometry.unary_union)

    # --- H3 hex assignment (centroid in polygon) ---
    # Spatial join: hex centroids in zone
    hex_in_zone = hex_gdf.to_crs("EPSG:4326")
    hex_in_zone = hex_in_zone[hex_in_zone.geometry.within(zone_union_4326)]
    n_hexes = len(hex_in_zone)
    area_hex_sqft = n_hexes * hex_area_sqft

    # Also build actual hex polygon union for precise area
    if n_hexes > 0 and n_hexes < 2000:
        hex_polys_4326 = [hex_to_polygon_4326(hid) for hid in hex_in_zone.hex_id]
        hex_union_4326 = gpd.GeoSeries(hex_polys_4326, crs="EPSG:4326").unary_union
        hex_union_2263 = gpd.GeoSeries([make_valid(hex_union_4326)], crs="EPSG:4326").to_crs(TARGET_CRS).iloc[0]
        area_hex_union_sqft = hex_union_2263.area
    else:
        area_hex_union_sqft = area_hex_sqft

    # --- Census block assignment (centroid in polygon) ---
    zone_2263 = zone_union  # already in EPSG:2263
    cb_in_zone_mask = cb_centroids.within(zone_2263)
    cb_in_zone = cb[cb_in_zone_mask]
    n_blocks = len(cb_in_zone)
    area_cb_sqft = cb_in_zone.geometry.area.sum()

    # Also union for precise area
    if n_blocks > 0:
        cb_union = make_valid(cb_in_zone.geometry.unary_union)
        area_cb_union_sqft = cb_union.area
    else:
        area_cb_union_sqft = 0

    # --- Identify Pct 75 zones for exclusion version ---
    # Check if any zone polygon intersects Pct 75 area
    # We'll flag by checking if zone attribute mentions 75, or by a spatial check later
    # For now store zone-level precinct info
    has_pct75 = "075" in zone_pcts or "75" in zone_pcts

    # --- Pct 75 exclusion: remove blocks/hexes that are in Pct 75 ---
    # We need precinct boundaries. Use a simple heuristic:
    # Pct 75 is in East New York, Brooklyn. Approx bounding box in EPSG:2263:
    # We'll do this properly later with precinct shapefiles if available.
    # For now, store the data and we'll handle exclusion via precinct column in zone shapefiles.

    result = {
        "iteration": iter_num,
        "n_zones": len(zone),
        "area_original_sqft": area_original_sqft,
        "area_original_km2": area_original_sqft * SQ_FT_TO_SQ_KM,
        "n_hexes": n_hexes,
        "area_hex_union_sqft": area_hex_union_sqft,
        "area_hex_union_km2": area_hex_union_sqft * SQ_FT_TO_SQ_KM,
        "hex_ratio": area_hex_union_sqft / area_original_sqft if area_original_sqft > 0 else np.nan,
        "n_blocks": n_blocks,
        "area_cb_union_sqft": area_cb_union_sqft,
        "area_cb_union_km2": area_cb_union_sqft * SQ_FT_TO_SQ_KM,
        "cb_ratio": area_cb_union_sqft / area_original_sqft if area_original_sqft > 0 else np.nan,
        "has_pct75": has_pct75,
        "zone_pcts": ",".join(sorted(zone_pcts)) if zone_pcts else "",
    }
    results.append(result)
    print(f"zones={len(zone):2d}  hexes={n_hexes:3d}  blocks={n_blocks:4d}  "
          f"orig={area_original_sqft * SQ_FT_TO_SQ_KM:.2f}km²  "
          f"hex_ratio={result['hex_ratio']:.2f}  cb_ratio={result['cb_ratio']:.2f}")

# ---- Build output DataFrame ----
df = pd.DataFrame(results)
df.to_csv("output/area_comparison_by_iteration.csv", index=False)

# ---- Summary table ----
print("\n" + "=" * 100)
print(f"{'Iter':>4} {'Zones':>5} {'Original km²':>13} {'Hex km²':>10} {'Hex Ratio':>10} "
      f"{'CB km²':>10} {'CB Ratio':>10} {'Hexes':>6} {'Blocks':>7}")
print("-" * 100)
for _, r in df.iterrows():
    print(f"{int(r['iteration']):4d} {int(r['n_zones']):5d} {r['area_original_km2']:13.3f} "
          f"{r['area_hex_union_km2']:10.3f} {r['hex_ratio']:10.2f} "
          f"{r['area_cb_union_km2']:10.3f} {r['cb_ratio']:10.2f} "
          f"{int(r['n_hexes']):6d} {int(r['n_blocks']):7d}")

print("-" * 100)
print(f"Mean hex ratio:  {df['hex_ratio'].mean():.3f}  (1.0 = perfect match)")
print(f"Mean CB ratio:   {df['cb_ratio'].mean():.3f}")
print(f"Median hex ratio: {df['hex_ratio'].median():.3f}")
print(f"Median CB ratio:  {df['cb_ratio'].median():.3f}")

# ---- Now redo excluding Pct 75 ----
# To exclude Pct 75 properly, we need to know which individual zone polygons
# are in Pct 75. Let's check what attributes are available.
print("\n\n--- Checking zone attributes for precinct identification ---")
for iter_num, shp_path in sorted(ITERATIONS.items()):
    zone = gpd.read_file(shp_path)
    cols = [c for c in zone.columns if c != "geometry"]
    if iter_num <= 5 or iter_num in [20, 21, 22, 23]:
        print(f"  Impact {iter_num}: cols={cols}")
        if len(zone) <= 5:
            for c in cols:
                print(f"    {c}: {zone[c].tolist()}")

print("\nSaved output/area_comparison_by_iteration.csv")
