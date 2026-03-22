#!/usr/bin/env python3
"""
ROBUSTNESS: Build analysis panel at H3 resolution 8 (~0.74 km² per hex).

Same pipeline as 04 + 07 but at coarser resolution.
Re-geocodes all crime/SQF/arrest records to res-8 hexes,
re-does centroid-in-polygon treatment assignment with zone shapefiles.
"""

import csv
import json
import h3
import geopandas as gpd
from shapely.geometry import Point
from shapely.ops import unary_union
from collections import defaultdict
from datetime import datetime
from pathlib import Path

RES = 8
INPUT_CRIME = "data-raw/NYPD_Complaint_Data_Historic_20260224.csv"
SHP_DIR = Path("data-raw/Operation Impact Zones/SHP Files")

# Outside classification (same as 04)
OUTSIDE_LOC = {"FRONT OF", "OPPOSITE OF", "OUTSIDE", "REAR OF"}
OUTSIDE_PREM_KEYWORDS = [
    "PARK", "STREET", "PUBLIC PLACE", "HIGHWAY",
    "BRIDGE", "SIDEWALK", "VACANT LOT",
    "PUBLIC HOUSING AREA", "OUTSIDE",
]

def is_outside(loc_desc, prem_desc):
    if loc_desc in OUTSIDE_LOC:
        return True
    if prem_desc:
        prem_upper = prem_desc.upper()
        for kw in OUTSIDE_PREM_KEYWORDS:
            if kw in prem_upper:
                return True
    return False

VIOLENT_OFNS = {"MURDER & NON-NEGL. MANSLAUGHTER", "ROBBERY", "FELONY ASSAULT"}
PROPERTY_OFNS = {"BURGLARY", "GRAND LARCENY", "GRAND LARCENY OF MOTOR VEHICLE"}

# ---- Iteration dates ----
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

# ---- Step 1: Load zone shapefiles ----
print("Loading impact zone shapefiles...")
zone_polys = {}  # iter_num -> union polygon (EPSG:4326)
for i in range(1, 23):
    shp = SHP_DIR / f"IMPACT {i:02d} Region_region.shp"
    if shp.exists():
        gdf = gpd.read_file(shp).to_crs(epsg=4326)
        gdf.geometry = gdf.geometry.buffer(0)
        zone_polys[i] = unary_union(gdf.geometry)

shp23 = Path("data-raw/Impact 22 Jan 2015/IMPACT_22_Region_Updated_020415.shp")
if shp23.exists():
    gdf23 = gpd.read_file(shp23).to_crs(epsg=4326)
    gdf23.geometry = gdf23.geometry.buffer(0)
    zone_polys[23] = unary_union(gdf23.geometry)

print(f"  Loaded {len(zone_polys)} iteration polygons")

# ---- Step 2: Geocode crime to res-8 hexes ----
print(f"\nGeocoding crime data to H3 res-{RES}...")

crime_counts = defaultdict(lambda: {
    "violent": 0, "property": 0, "robbery": 0, "felony_assault": 0, "burglary": 0,
    "robbery_outside": 0, "felony_assault_outside": 0, "burglary_outside": 0,
})

n_total = 0
n_geo = 0
with open(INPUT_CRIME) as f:
    reader = csv.DictReader(f)
    for row in reader:
        n_total += 1
        if n_total % 500000 == 0:
            print(f"  {n_total:,} rows...")

        rpt_dt = row.get("RPT_DT", "")
        if not rpt_dt or rpt_dt == "(null)":
            continue
        try:
            dt = datetime.strptime(rpt_dt, "%m/%d/%Y")
        except ValueError:
            continue
        if dt.year < 2006 or dt.year > 2016:
            continue

        lat = row.get("Latitude", "")
        lon = row.get("Longitude", "")
        if not lat or not lon or lat == "(null)" or lon == "(null)":
            continue
        try:
            lat_f, lon_f = float(lat), float(lon)
        except ValueError:
            continue
        if lat_f == 0 or lon_f == 0:
            continue

        hex_id = h3.latlng_to_cell(lat_f, lon_f, RES)
        n_geo += 1
        ym = f"{dt.year}-{dt.month:02d}"
        key = f"{hex_id}|{ym}"

        ofns = row.get("OFNS_DESC", "")
        loc_desc = row.get("LOC_OF_OCCUR_DESC", "").strip()
        prem_desc = row.get("PREM_TYP_DESC", "").strip()
        outside = is_outside(loc_desc, prem_desc)

        if ofns in VIOLENT_OFNS:
            crime_counts[key]["violent"] += 1
        if ofns in PROPERTY_OFNS:
            crime_counts[key]["property"] += 1
        if ofns == "ROBBERY":
            crime_counts[key]["robbery"] += 1
            if outside:
                crime_counts[key]["robbery_outside"] += 1
        if ofns == "FELONY ASSAULT":
            crime_counts[key]["felony_assault"] += 1
            if outside:
                crime_counts[key]["felony_assault_outside"] += 1
        if ofns == "BURGLARY":
            crime_counts[key]["burglary"] += 1
            if outside:
                crime_counts[key]["burglary_outside"] += 1

print(f"  {n_total:,} rows, {n_geo:,} geocoded, {len(crime_counts):,} hex-months")

# ---- Step 3: Get all hex IDs that have any events ----
all_hexes = set()
for key in crime_counts:
    all_hexes.add(key.split("|")[0])
print(f"\n  Unique res-{RES} hexes with events: {len(all_hexes)}")

# ---- Step 4: Treatment assignment via centroid-in-polygon ----
print("\nAssigning treatment (centroid-in-polygon)...")

hex_treatment = {}  # hex_id -> set of (year, month)
hex_ever_treated = set()

for hex_id in all_hexes:
    lat, lng = h3.cell_to_latlng(hex_id)
    pt = Point(lng, lat)

    active_months = set()
    for iter_num, poly in zone_polys.items():
        if iter_num not in ITER_DATES:
            continue
        if pt.within(poly):
            start_str, end_str = ITER_DATES[iter_num]
            start = datetime.strptime(start_str, "%Y-%m-%d")
            end = datetime.strptime(end_str, "%Y-%m-%d")
            y, m = start.year, start.month
            while datetime(y, m, 1) < end:
                if 2006 <= y <= 2016:
                    active_months.add((y, m))
                m += 1
                if m > 12:
                    m = 1
                    y += 1

    if active_months:
        hex_treatment[hex_id] = active_months
        hex_ever_treated.add(hex_id)

print(f"  Ever-treated res-{RES} hexes: {len(hex_ever_treated)}")
print(f"  Treatment-ON hex-months: {sum(len(v) for v in hex_treatment.values()):,}")

# ---- Step 5: Get precinct for each hex ----
# Use the res-9 panel's precinct assignments — map res-8 hex to the most common precinct
# of its child res-9 hexes
print("\nAssigning precincts...")
hex_precinct_9 = {}
with open("data/panel_hex_analysis.csv") as f:
    reader = csv.DictReader(f)
    for row in reader:
        if row["hex_id"] not in hex_precinct_9:
            hex_precinct_9[row["hex_id"]] = int(row["precinct"])

hex_precinct = {}
for hex8 in all_hexes:
    children = h3.cell_to_children(hex8, RES + 1)  # res 9 children
    pcts = []
    for c in children:
        if c in hex_precinct_9:
            pcts.append(hex_precinct_9[c])
    if pcts:
        # Most common precinct
        hex_precinct[hex8] = max(set(pcts), key=pcts.count)

print(f"  Precincts assigned: {len(hex_precinct)} of {len(all_hexes)}")

# ---- Step 6: Write panel ----
print(f"\nWriting res-{RES} analysis panel...")

hex_to_num = {h: i + 1 for i, h in enumerate(sorted(all_hexes))}
time_ids = {}
tid = 0
for year in range(2006, 2017):
    for month in range(1, 13):
        tid += 1
        time_ids[(year, month)] = tid

fieldnames = [
    "hex_id", "hex_num", "year", "month", "year_month", "time_id",
    "precinct", "pct_ym", "ever_treated", "treatment",
    "violent", "property", "robbery", "felony_assault", "burglary",
    "robbery_outside", "felony_assault_outside", "burglary_outside",
]

n_rows = 0
n_treated = 0

with open(f"data/panel_hex_res{RES}_analysis.csv", "w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=fieldnames)
    writer.writeheader()

    for hex_id in sorted(all_hexes):
        if hex_id not in hex_precinct:
            continue

        pct = hex_precinct[hex_id]
        hex_num = hex_to_num[hex_id]
        ever_treated = 1 if hex_id in hex_ever_treated else 0

        for year in range(2006, 2017):
            for month in range(1, 13):
                ym = f"{year}-{month:02d}"
                key = f"{hex_id}|{ym}"
                pct_ym = f"{pct}_{ym}"
                tid = time_ids[(year, month)]

                treat = 0
                if hex_id in hex_treatment:
                    if (year, month) in hex_treatment[hex_id]:
                        treat = 1
                        n_treated += 1

                crime = crime_counts.get(key, {})

                row = {
                    "hex_id": hex_id,
                    "hex_num": hex_num,
                    "year": year,
                    "month": month,
                    "year_month": ym,
                    "time_id": tid,
                    "precinct": pct,
                    "pct_ym": pct_ym,
                    "ever_treated": ever_treated,
                    "treatment": treat,
                    "violent": crime.get("violent", 0),
                    "property": crime.get("property", 0),
                    "robbery": crime.get("robbery", 0),
                    "felony_assault": crime.get("felony_assault", 0),
                    "burglary": crime.get("burglary", 0),
                    "robbery_outside": crime.get("robbery_outside", 0),
                    "felony_assault_outside": crime.get("felony_assault_outside", 0),
                    "burglary_outside": crime.get("burglary_outside", 0),
                }
                writer.writerow(row)
                n_rows += 1

print(f"\nDone: {n_rows:,} rows, {len(hex_precinct):,} hexes")
print(f"  Treatment-ON hex-months: {n_treated:,}")
print(f"  Ever-treated: {len(hex_ever_treated)}")
print(f"  Saved data/panel_hex_res{RES}_analysis.csv")
