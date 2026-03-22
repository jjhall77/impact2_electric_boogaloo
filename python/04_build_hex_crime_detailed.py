#!/usr/bin/env python3
"""
Build disaggregated crime counts by hex × month from NYPD complaint data.
Maps OFNS_DESC to MacDonald et al. (2016) crime categories where possible.

MacDonald categories we CAN construct:
  - Total (all complaints in our data)
  - Robbery (ROBBERY)
  - Assault / Felony Assault (FELONY ASSAULT)
  - Burglary (BURGLARY)
  - Property Felony (BURGLARY + GRAND LARCENY + GRAND LARCENY OF MOTOR VEHICLE)
  - Violent Felony (MURDER + ROBBERY + FELONY ASSAULT; excl rape per research plan)
  - Misd (ASSAULT 3 + PETIT LARCENY — partial, missing other misd categories)

MacDonald categories we CANNOT construct (data not in complaint file):
  - Weapons, Drugs, Other Felony
"""

import csv
import json
import h3
from collections import defaultdict
from datetime import datetime

INPUT = "data-raw/NYPD_Complaint_Data_Historic_20260224.csv"

# Outside classification
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

# hex_id|YYYY-MM -> counts dict
counts = defaultdict(lambda: {
    "total": 0, "robbery": 0, "felony_assault": 0, "burglary": 0,
    "grand_larceny": 0, "gla_mv": 0, "murder": 0, "rape": 0,
    "petit_larceny": 0, "assault3": 0, "arson": 0,
    # Aggregates
    "violent": 0, "property": 0, "misd": 0,
    # Outside versions
    "total_outside": 0, "violent_outside": 0, "property_outside": 0,
    "robbery_outside": 0, "felony_assault_outside": 0, "burglary_outside": 0,
    "assault3_outside": 0,
})

OFNS_MAP = {
    "ROBBERY": "robbery",
    "FELONY ASSAULT": "felony_assault",
    "BURGLARY": "burglary",
    "GRAND LARCENY": "grand_larceny",
    "GRAND LARCENY OF MOTOR VEHICLE": "gla_mv",
    "MURDER & NON-NEGL. MANSLAUGHTER": "murder",
    "RAPE": "rape",
    "PETIT LARCENY": "petit_larceny",
    "ASSAULT 3 & RELATED OFFENSES": "assault3",
    "ARSON": "arson",
}

VIOLENT_OFNS = {"MURDER & NON-NEGL. MANSLAUGHTER", "ROBBERY", "FELONY ASSAULT"}
PROPERTY_OFNS = {"BURGLARY", "GRAND LARCENY", "GRAND LARCENY OF MOTOR VEHICLE"}
MISD_OFNS = {"ASSAULT 3 & RELATED OFFENSES", "PETIT LARCENY"}

n_total = 0
n_geocoded = 0

print("Processing complaint data for detailed crime types...")
with open(INPUT, "r") as f:
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

        hex_id = h3.latlng_to_cell(lat_f, lon_f, 9)
        n_geocoded += 1

        ym = f"{dt.year}-{dt.month:02d}"
        key = f"{hex_id}|{ym}"

        ofns = row.get("OFNS_DESC", "")
        loc_desc = row.get("LOC_OF_OCCUR_DESC", "").strip()
        prem_desc = row.get("PREM_TYP_DESC", "").strip()
        outside = is_outside(loc_desc, prem_desc)

        # Individual type
        if ofns in OFNS_MAP:
            counts[key][OFNS_MAP[ofns]] += 1

        # Aggregates
        counts[key]["total"] += 1
        if outside:
            counts[key]["total_outside"] += 1

        if ofns in VIOLENT_OFNS:
            counts[key]["violent"] += 1
            if outside:
                counts[key]["violent_outside"] += 1
        if ofns in PROPERTY_OFNS:
            counts[key]["property"] += 1
            if outside:
                counts[key]["property_outside"] += 1
        if ofns in MISD_OFNS:
            counts[key]["misd"] += 1
        if ofns == "ROBBERY" and outside:
            counts[key]["robbery_outside"] += 1
        if ofns == "FELONY ASSAULT" and outside:
            counts[key]["felony_assault_outside"] += 1
        if ofns == "BURGLARY" and outside:
            counts[key]["burglary_outside"] += 1
        if ofns == "ASSAULT 3 & RELATED OFFENSES" and outside:
            counts[key]["assault3_outside"] += 1

print(f"\nDone: {n_total:,} rows, {n_geocoded:,} geocoded, {len(counts):,} hex-months")

# Save
with open("data/crime_hex_month_detailed.json", "w") as f:
    json.dump(dict(counts), f)
print("Saved data/crime_hex_month_detailed.json")

# Summary
tot = {k: sum(c[k] for c in counts.values()) for k in [
    "total", "violent", "property", "robbery", "felony_assault",
    "burglary", "murder", "misd", "violent_outside", "property_outside"
]}
for k, v in tot.items():
    print(f"  {k}: {v:,}")
