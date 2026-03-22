#!/usr/bin/env python3
"""
Redo area comparison excluding Pct 75 zones.
Strategy: Load NYPD precinct boundaries, assign each zone polygon a precinct
by overlap, then exclude Pct 75 polygons before computing areas.
"""

import geopandas as gpd
import h3
import numpy as np
import pandas as pd
from shapely.geometry import Polygon
from shapely.validation import make_valid
import warnings
warnings.filterwarnings("ignore")

SHP_DIR = "data-raw/Operation Impact Zones/SHP Files"
CB_PATH = "data-raw/nycb2020_26a/nycb2020.shp"
PCT_PATH = "data-raw/nypp_11b_av/nypp.shp"
TARGET_CRS = "EPSG:2263"
SQ_FT_TO_SQ_KM = 1 / 10_763_910.4

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

# ---- Load precinct boundaries ----
print("Loading precinct boundaries...")
precincts = gpd.read_file(PCT_PATH).to_crs(TARGET_CRS)
precincts.geometry = precincts.geometry.apply(make_valid)
print(f"  {len(precincts)} precincts loaded")

pct75 = precincts[precincts["Precinct"] == 75]
pct75_geom = make_valid(pct75.geometry.unary_union)
print(f"  Pct 75 area = {pct75_geom.area * SQ_FT_TO_SQ_KM:.2f} km²")

# ---- H3 setup ----
print("Setting up H3 grid...")
nyc_bounds_4326 = cb.to_crs("EPSG:4326").total_bounds
lat_min, lat_max = nyc_bounds_4326[1] - 0.01, nyc_bounds_4326[3] + 0.01
lon_min, lon_max = nyc_bounds_4326[0] - 0.01, nyc_bounds_4326[2] + 0.01

hex_ids = set()
lat = lat_min
while lat <= lat_max:
    lon = lon_min
    while lon <= lon_max:
        hex_ids.add(h3.latlng_to_cell(lat, lon, 9))
        lon += 0.003
    lat += 0.003
expanded = set()
for hx in hex_ids:
    expanded.add(hx)
    expanded.update(h3.grid_ring(hx, 1))
hex_ids = expanded

hex_data = []
for hid in hex_ids:
    lat, lon = h3.cell_to_latlng(hid)
    hex_data.append({"hex_id": hid, "lat": lat, "lon": lon})
hex_df = pd.DataFrame(hex_data)
hex_gdf = gpd.GeoDataFrame(
    hex_df, geometry=gpd.points_from_xy(hex_df.lon, hex_df.lat), crs="EPSG:4326"
).to_crs(TARGET_CRS)

hex_area_km2 = h3.cell_area(list(hex_ids)[0], unit="km^2")
hex_area_sqft = hex_area_km2 * 10_763_910.4

def hex_to_polygon_4326(hid):
    boundary = h3.cell_to_boundary(hid)
    coords = [(lon, lat) for lat, lon in boundary]
    coords.append(coords[0])
    return Polygon(coords)

# ---- Process each iteration WITH Pct 75 exclusion ----
print("\nProcessing iterations (with Pct 75 exclusion)...")
results_all = []
results_no75 = []

for iter_num, shp_path in sorted(ITERATIONS.items()):
    print(f"  Impact {iter_num:2d}...", end=" ")

    zone = gpd.read_file(shp_path).to_crs(TARGET_CRS)
    zone.geometry = zone.geometry.apply(make_valid)

    # --- Determine which zone polygons are in Pct 75 ---
    zone["in_pct75"] = False
    if pct75_geom is not None:
        for idx in zone.index:
            # Zone is "in Pct 75" if >50% of its area overlaps Pct 75
            poly = zone.geometry[idx]
            try:
                overlap = poly.intersection(pct75_geom).area / poly.area
                if overlap > 0.5:
                    zone.loc[idx, "in_pct75"] = True
            except Exception:
                pass

    n_pct75_zones = zone["in_pct75"].sum()

    # --- Full version (all zones) ---
    zone_union = make_valid(zone.geometry.unary_union)
    area_orig = zone_union.area

    zone_4326 = zone.to_crs("EPSG:4326")
    zone_4326.geometry = zone_4326.geometry.apply(make_valid)
    zone_union_4326 = make_valid(zone_4326.geometry.unary_union)

    # Hexes
    hex_in = hex_gdf.to_crs("EPSG:4326")
    hex_in = hex_in[hex_in.geometry.within(zone_union_4326)]
    n_hex = len(hex_in)
    if n_hex > 0:
        hex_polys = [hex_to_polygon_4326(h) for h in hex_in.hex_id]
        hex_union = gpd.GeoSeries(hex_polys, crs="EPSG:4326").unary_union
        hex_union_2263 = gpd.GeoSeries([make_valid(hex_union)], crs="EPSG:4326").to_crs(TARGET_CRS).iloc[0]
        area_hex = hex_union_2263.area
    else:
        area_hex = 0

    # Census blocks
    cb_mask = cb_centroids.within(zone_union)
    n_cb = cb_mask.sum()
    area_cb = make_valid(cb[cb_mask].geometry.unary_union).area if n_cb > 0 else 0

    results_all.append({
        "iteration": iter_num, "n_zones": len(zone),
        "area_orig_km2": area_orig * SQ_FT_TO_SQ_KM,
        "n_hexes": n_hex, "area_hex_km2": area_hex * SQ_FT_TO_SQ_KM,
        "hex_ratio": area_hex / area_orig if area_orig > 0 else np.nan,
        "n_blocks": n_cb, "area_cb_km2": area_cb * SQ_FT_TO_SQ_KM,
        "cb_ratio": area_cb / area_orig if area_orig > 0 else np.nan,
        "pct75_zones": n_pct75_zones,
    })

    # --- Excluding Pct 75 ---
    zone_no75 = zone[~zone["in_pct75"]]
    if len(zone_no75) == 0:
        results_no75.append({
            "iteration": iter_num, "n_zones": 0,
            "area_orig_km2": 0, "n_hexes": 0, "area_hex_km2": 0,
            "hex_ratio": np.nan, "n_blocks": 0, "area_cb_km2": 0,
            "cb_ratio": np.nan,
        })
        print(f"ALL zones in Pct 75!")
        continue

    zone_no75_union = make_valid(zone_no75.geometry.unary_union)
    area_orig_no75 = zone_no75_union.area

    zone_no75_4326 = zone_no75.to_crs("EPSG:4326")
    zone_no75_4326.geometry = zone_no75_4326.geometry.apply(make_valid)
    zone_no75_union_4326 = make_valid(zone_no75_4326.geometry.unary_union)

    # Hexes excl 75
    hex_in_no75 = hex_gdf.to_crs("EPSG:4326")
    hex_in_no75 = hex_in_no75[hex_in_no75.geometry.within(zone_no75_union_4326)]
    n_hex_no75 = len(hex_in_no75)
    if n_hex_no75 > 0:
        hex_polys = [hex_to_polygon_4326(h) for h in hex_in_no75.hex_id]
        hex_union = gpd.GeoSeries(hex_polys, crs="EPSG:4326").unary_union
        hex_union_2263 = gpd.GeoSeries([make_valid(hex_union)], crs="EPSG:4326").to_crs(TARGET_CRS).iloc[0]
        area_hex_no75 = hex_union_2263.area
    else:
        area_hex_no75 = 0

    # CB excl 75
    cb_mask_no75 = cb_centroids.within(zone_no75_union)
    n_cb_no75 = cb_mask_no75.sum()
    area_cb_no75 = make_valid(cb[cb_mask_no75].geometry.unary_union).area if n_cb_no75 > 0 else 0

    results_no75.append({
        "iteration": iter_num, "n_zones": len(zone_no75),
        "area_orig_km2": area_orig_no75 * SQ_FT_TO_SQ_KM,
        "n_hexes": n_hex_no75, "area_hex_km2": area_hex_no75 * SQ_FT_TO_SQ_KM,
        "hex_ratio": area_hex_no75 / area_orig_no75 if area_orig_no75 > 0 else np.nan,
        "n_blocks": n_cb_no75, "area_cb_km2": area_cb_no75 * SQ_FT_TO_SQ_KM,
        "cb_ratio": area_cb_no75 / area_orig_no75 if area_orig_no75 > 0 else np.nan,
    })

    print(f"pct75_zones={n_pct75_zones}  hex_ratio={results_all[-1]['hex_ratio']:.2f}/{results_no75[-1]['hex_ratio']:.2f}  "
          f"cb_ratio={results_all[-1]['cb_ratio']:.2f}/{results_no75[-1]['cb_ratio']:.2f}")

# ---- Print both tables ----
df_all = pd.DataFrame(results_all)
df_no75 = pd.DataFrame(results_no75)

print("\n" + "=" * 105)
print("ALL ZONES (full)")
print(f"{'Iter':>4} {'Zones':>5} {'Orig km²':>9} {'Hex km²':>9} {'HexRatio':>9} "
      f"{'CB km²':>9} {'CBRatio':>9} {'Hexes':>6} {'Blocks':>7} {'Pct75':>5}")
print("-" * 105)
for _, r in df_all.iterrows():
    print(f"{int(r['iteration']):4d} {int(r['n_zones']):5d} {r['area_orig_km2']:9.3f} "
          f"{r['area_hex_km2']:9.3f} {r['hex_ratio']:9.2f} "
          f"{r['area_cb_km2']:9.3f} {r['cb_ratio']:9.2f} "
          f"{int(r['n_hexes']):6d} {int(r['n_blocks']):7d} {int(r['pct75_zones']):5d}")
print(f"\n  Mean hex ratio: {df_all['hex_ratio'].mean():.3f}   Mean CB ratio: {df_all['cb_ratio'].mean():.3f}")

print("\n" + "=" * 95)
print("EXCLUDING PCT 75 ZONES")
print(f"{'Iter':>4} {'Zones':>5} {'Orig km²':>9} {'Hex km²':>9} {'HexRatio':>9} "
      f"{'CB km²':>9} {'CBRatio':>9} {'Hexes':>6} {'Blocks':>7}")
print("-" * 95)
for _, r in df_no75.iterrows():
    hr = f"{r['hex_ratio']:.2f}" if not np.isnan(r['hex_ratio']) else "   N/A"
    cr = f"{r['cb_ratio']:.2f}" if not np.isnan(r['cb_ratio']) else "   N/A"
    print(f"{int(r['iteration']):4d} {int(r['n_zones']):5d} {r['area_orig_km2']:9.3f} "
          f"{r['area_hex_km2']:9.3f} {hr:>9} "
          f"{r['area_cb_km2']:9.3f} {cr:>9} "
          f"{int(r['n_hexes']):6d} {int(r['n_blocks']):7d}")
valid_no75 = df_no75.dropna(subset=["hex_ratio"])
print(f"\n  Mean hex ratio: {valid_no75['hex_ratio'].mean():.3f}   Mean CB ratio: {valid_no75['cb_ratio'].mean():.3f}")

# Save both
df_all.to_csv("output/area_comparison_all.csv", index=False)
df_no75.to_csv("output/area_comparison_no_pct75.csv", index=False)
print("\nSaved output/area_comparison_all.csv and output/area_comparison_no_pct75.csv")
