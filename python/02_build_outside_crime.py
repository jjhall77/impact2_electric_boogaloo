#!/usr/bin/env python3
"""
Build outdoor crime counts by hex × month from NYPD complaint data.
Outdoor classification follows MacDonald et al. methodology:
  - LOC_OF_OCCUR_DESC matches: FRONT OF, OPPOSITE OF, OUTSIDE, REAR OF, STREET, IN STREET, SIDEWALK
  - PREM_TYP_DESC matches: PARK, STREET, PUBLIC PLACE, HIGHWAY, BRIDGE, SIDEWALK,
                           VACANT LOT, PUBLIC HOUSING AREA, OUTSIDE
A complaint is "outside" if EITHER field matches.
"""

import csv
import json
import h3
from collections import defaultdict
from datetime import datetime

# ---------------------------------------------------------------------------
# Classification
# ---------------------------------------------------------------------------
VIOLENT_OFNS = {
    "MURDER & NON-NEGL. MANSLAUGHTER",
    "ROBBERY",
    "FELONY ASSAULT",
}
PROPERTY_OFNS = {
    "BURGLARY",
    "GRAND LARCENY",
    "GRAND LARCENY OF MOTOR VEHICLE",
}

OUTSIDE_LOC = {"FRONT OF", "OPPOSITE OF", "OUTSIDE", "REAR OF"}
# LOC_OF_OCCUR_DESC doesn't have STREET/SIDEWALK as values (only INSIDE, OUTSIDE, FRONT OF, etc)
# So we rely on PREM_TYP_DESC for street/sidewalk

OUTSIDE_PREM_KEYWORDS = [
    "PARK", "STREET", "PUBLIC PLACE", "HIGHWAY",
    "BRIDGE", "SIDEWALK", "VACANT LOT",
    "PUBLIC HOUSING AREA", "OUTSIDE",
]

def is_outside(loc_desc, prem_desc):
    """Check if a complaint occurred outdoors."""
    if loc_desc in OUTSIDE_LOC:
        return True
    if prem_desc:
        prem_upper = prem_desc.upper()
        for kw in OUTSIDE_PREM_KEYWORDS:
            if kw in prem_upper:
                return True
    return False

# ---------------------------------------------------------------------------
# Process complaints
# ---------------------------------------------------------------------------
INPUT = "data-raw/NYPD_Complaint_Data_Historic_20260224.csv"

# hex_id|YYYY-MM -> counts
counts = defaultdict(lambda: {
    "violent": 0, "property": 0, "total": 0,
    "violent_outside": 0, "property_outside": 0, "total_outside": 0,
})

n_total = 0
n_geocoded = 0
n_in_range = 0
n_outside = 0

print("Processing complaint data...")
with open(INPUT, "r") as f:
    reader = csv.DictReader(f)
    for row in reader:
        n_total += 1
        if n_total % 500000 == 0:
            print(f"  {n_total:,} rows processed...")

        # Parse date (RPT_DT)
        rpt_dt = row.get("RPT_DT", "")
        if not rpt_dt or rpt_dt == "(null)":
            continue
        try:
            dt = datetime.strptime(rpt_dt, "%m/%d/%Y")
        except ValueError:
            continue

        # Filter to study period
        if dt.year < 2006 or dt.year > 2016:
            continue
        n_in_range += 1

        # Geocode to H3
        lat = row.get("Latitude", "")
        lon = row.get("Longitude", "")
        if not lat or not lon or lat == "(null)" or lon == "(null)":
            continue
        try:
            lat_f = float(lat)
            lon_f = float(lon)
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

        if outside:
            n_outside += 1

        # Classify
        if ofns in VIOLENT_OFNS:
            counts[key]["violent"] += 1
            counts[key]["total"] += 1
            if outside:
                counts[key]["violent_outside"] += 1
                counts[key]["total_outside"] += 1
        elif ofns in PROPERTY_OFNS:
            counts[key]["property"] += 1
            counts[key]["total"] += 1
            if outside:
                counts[key]["property_outside"] += 1
                counts[key]["total_outside"] += 1
        else:
            counts[key]["total"] += 1
            if outside:
                counts[key]["total_outside"] += 1

print(f"\nDone: {n_total:,} total rows")
print(f"  In date range: {n_in_range:,}")
print(f"  Geocoded: {n_geocoded:,}")
print(f"  Outside: {n_outside:,} ({100*n_outside/n_geocoded:.1f}%)")
print(f"  Hex-months: {len(counts):,}")

# Save
with open("data/crime_hex_month_v2.json", "w") as f:
    json.dump(dict(counts), f)
print("Saved data/crime_hex_month_v2.json")

# ---------------------------------------------------------------------------
# Summary stats
# ---------------------------------------------------------------------------
tot_v = sum(c["violent"] for c in counts.values())
tot_vo = sum(c["violent_outside"] for c in counts.values())
tot_p = sum(c["property"] for c in counts.values())
tot_po = sum(c["property_outside"] for c in counts.values())
print(f"\nViolent: {tot_v:,} total, {tot_vo:,} outside ({100*tot_vo/tot_v:.1f}%)")
print(f"Property: {tot_p:,} total, {tot_po:,} outside ({100*tot_po/tot_p:.1f}%)")
