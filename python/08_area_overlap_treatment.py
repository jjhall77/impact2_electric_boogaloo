#!/usr/bin/env python3
"""
ROBUSTNESS: Area-overlap treatment assignment.

Instead of centroid-in-polygon (binary), assign treatment as the fraction
of each hex's area that overlaps with active impact zone polygons.
Then threshold at 50% for a binary treatment variable.

This tests sensitivity to the spatial assignment rule.
"""

import json
import csv
import h3
import geopandas as gpd
from shapely.geometry import Polygon, MultiPolygon
from shapely.ops import unary_union
from datetime import datetime
from collections import defaultdict
from pathlib import Path

SHP_DIR = Path("data-raw/Operation Impact Zones/SHP Files")

# ---- Load impact zone shapefiles ----
print("Loading impact zone shapefiles...")

iterations = []
for i in range(1, 23):
    shp_path = SHP_DIR / f"IMPACT {i:02d} Region_region.shp"
    if not shp_path.exists():
        shp_path = SHP_DIR / f"IMPACT {i:02d} Region_region.shp"
    if shp_path.exists():
        gdf = gpd.read_file(shp_path).to_crs(epsg=4326)
        gdf.geometry = gdf.geometry.buffer(0)  # fix invalid geometries
        iterations.append((i, gdf))
        print(f"  Iter {i}: {len(gdf)} zones")

# Iteration 23 (Jan 2015 update)
shp23 = Path("data-raw/Impact 22 Jan 2015/IMPACT_22_Region_Updated_020415.shp")
if shp23.exists():
    gdf23 = gpd.read_file(shp23).to_crs(epsg=4326)
    gdf23.geometry = gdf23.geometry.buffer(0)
    iterations.append((23, gdf23))
    print(f"  Iter 23: {len(gdf23)} zones")

# ---- Iteration date ranges ----
ITER_DATES = {
    1: ("2003-01-22", "2003-07-13"),
    2: ("2004-01-12", "2004-07-12"),
    3: ("2004-07-13", "2005-01-02"),
    4: ("2005-01-03", "2005-07-17"),
    5: ("2005-07-18", "2006-01-05"),
    6: ("2006-01-06", "2006-07-09"),
    7: ("2006-07-10", "2007-01-07"),
    8: ("2007-01-08", "2007-07-08"),
    9: ("2007-07-09", "2008-01-06"),
    10: ("2008-01-07", "2008-07-06"),
    11: ("2008-07-07", "2009-01-04"),
    12: ("2009-01-05", "2009-07-12"),
    13: ("2009-07-13", "2010-01-03"),
    14: ("2010-01-04", "2010-07-11"),
    15: ("2010-07-12", "2011-01-02"),
    16: ("2011-01-03", "2011-07-10"),
    17: ("2011-07-11", "2012-01-01"),
    18: ("2012-01-02", "2012-07-08"),
    19: ("2012-07-09", "2013-01-06"),
    20: ("2013-01-07", "2013-07-07"),
    21: ("2013-07-08", "2014-07-06"),
    22: ("2014-07-07", "2015-01-04"),
    23: ("2015-01-05", "2015-07-01"),
}

def months_in_range(start_str, end_str):
    """Return set of (year, month) tuples in date range."""
    start = datetime.strptime(start_str, "%Y-%m-%d")
    end = datetime.strptime(end_str, "%Y-%m-%d")
    months = set()
    y, m = start.year, start.month
    while datetime(y, m, 1) < end:
        if 2006 <= y <= 2016:
            months.add((y, m))
        m += 1
        if m > 12:
            m = 1
            y += 1
    return months

# ---- Get all treated hexes from treatment map ----
print("\nLoading treatment map...")
with open("data/hex_treatment_map.json") as f:
    tmap = json.load(f)

all_hexes = tmap["all_hexes"]
treated_hexes = set(tmap["treated"].keys())
print(f"  {len(treated_hexes)} treated hexes, {len(all_hexes)} total")

# ---- Compute hex polygons (only for treated + neighbors) ----
print("\nComputing H3 hex polygons...")

def hex_to_polygon(hid):
    boundary = h3.cell_to_boundary(hid)
    coords = [(lon, lat) for lat, lon in boundary]
    coords.append(coords[0])
    return Polygon(coords)

# We only need overlaps for hexes that are near impact zones
# Use all hexes that are ever-treated or within 1 ring
candidate_hexes = set()
for hid in treated_hexes:
    candidate_hexes.add(hid)
    try:
        for nb in h3.grid_ring(hid, 1):
            candidate_hexes.add(nb)
    except:
        pass

# Filter to hexes in our panel
candidate_hexes = candidate_hexes.intersection(set(all_hexes))
print(f"  Computing polygons for {len(candidate_hexes)} candidate hexes...")

hex_polys = {}
for hid in candidate_hexes:
    hex_polys[hid] = hex_to_polygon(hid)

# ---- Compute area overlaps per iteration ----
print("\nComputing area overlaps per iteration...")

# hex_id -> {(year, month): overlap_fraction}
overlap_data = defaultdict(dict)

for iter_num, gdf in iterations:
    if iter_num not in ITER_DATES:
        continue
    start_str, end_str = ITER_DATES[iter_num]
    active_months = months_in_range(start_str, end_str)
    if not active_months:
        continue

    # Union of all zone polygons for this iteration (fix invalid geoms)
    valid_geoms = [g.buffer(0) if not g.is_valid else g for g in gdf.geometry]
    zone_union = unary_union(valid_geoms)
    if zone_union.is_empty:
        continue

    print(f"  Iter {iter_num} ({start_str} to {end_str}): {len(active_months)} months")

    n_overlap = 0
    for hid, hpoly in hex_polys.items():
        if not hpoly.intersects(zone_union):
            continue

        intersection = hpoly.intersection(zone_union)
        if intersection.is_empty:
            continue

        overlap_frac = intersection.area / hpoly.area
        if overlap_frac > 0.01:  # ignore tiny overlaps
            n_overlap += 1
            for ym in active_months:
                overlap_data[hid][ym] = max(overlap_data[hid].get(ym, 0), overlap_frac)

    print(f"    {n_overlap} hexes with >1% overlap")

# ---- Build area-overlap treatment panel ----
print("\nBuilding area-overlap treatment variables...")

# Load existing panel to get hex ordering
print("Loading existing panel for hex ordering...")
hex_precinct = {}
with open("data/panel_hex_analysis.csv") as f:
    reader = csv.DictReader(f)
    for row in reader:
        if row["hex_id"] not in hex_precinct:
            hex_precinct[row["hex_id"]] = int(row["precinct"])

# Write overlap fractions to a separate file, then merge in R
out_rows = []
for hex_id in sorted(all_hexes):
    if hex_id not in hex_precinct:
        continue
    for year in range(2006, 2017):
        for month in range(1, 13):
            frac = overlap_data.get(hex_id, {}).get((year, month), 0.0)
            treat_50 = 1 if frac >= 0.50 else 0
            out_rows.append({
                "hex_id": hex_id,
                "year_month": f"{year}-{month:02d}",
                "overlap_frac": round(frac, 4),
                "treatment_overlap50": treat_50,
            })

outfile = "data/hex_overlap_treatment.csv"
with open(outfile, "w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=["hex_id", "year_month", "overlap_frac", "treatment_overlap50"])
    writer.writeheader()
    writer.writerows(out_rows)

print(f"\nSaved {outfile}: {len(out_rows):,} rows")

# Summary
n_any_overlap = sum(1 for h in overlap_data if any(v > 0 for v in overlap_data[h].values()))
n_centroid_treated = len(treated_hexes)
n_overlap50 = len(set(r["hex_id"] for r in out_rows if r["treatment_overlap50"] == 1))
n_total_on = sum(1 for r in out_rows if r["treatment_overlap50"] == 1)

print(f"\nSummary:")
print(f"  Hexes with any zone overlap: {n_any_overlap}")
print(f"  Centroid-treated hexes: {n_centroid_treated}")
print(f"  50%-overlap treated hexes: {n_overlap50}")
print(f"  Treatment-ON hex-months (50%): {n_total_on:,}")
print(f"  Treatment-ON hex-months (centroid): 17,309")
