#!/usr/bin/env python3
"""
Build the hex replication panel for MacDonald et al. Models 1-5.
Combines: detailed crime counts, SQF, arrests, treatment, neighbor treatment.
Period: 2006-2012 (matching MacDonald minus 2004-2005 which we lack).
"""

import csv
import json
import h3
from collections import defaultdict

# ---- Load treatment map ----
print("Loading treatment map...")
with open("data/hex_treatment_map.json") as f:
    tmap = json.load(f)

treated_hexes = tmap["treated"]  # hex_id -> {first_treated, iterations: [{iter, start, end}]}
all_hexes = tmap["all_hexes"]

# ---- Load detailed crime ----
print("Loading detailed crime counts...")
with open("data/crime_hex_month_detailed.json") as f:
    crime_data = json.load(f)

# ---- Load SQF ----
print("Loading SQF counts...")
with open("data/sqf_hex_month.json") as f:
    sqf_data = json.load(f)

# ---- Load arrests ----
print("Loading arrest counts...")
with open("data/arrests_hex_month.json") as f:
    arrest_data = json.load(f)

# ---- Build treatment status for each hex × month ----
# For each hex, check if it's inside an active impact zone in that month
print("Building treatment indicators...")

from datetime import datetime

def month_in_iteration(year, month, iteration):
    """Check if year-month falls within an iteration's active period."""
    start = datetime.strptime(iteration["start"], "%Y-%m-%d")
    end = datetime.strptime(iteration["end"], "%Y-%m-%d")
    # Month is active if any day of the month overlaps
    month_start = datetime(year, month, 1)
    if month == 12:
        month_end = datetime(year + 1, 1, 1)
    else:
        month_end = datetime(year, month + 1, 1)
    return month_start < end and month_end > start

# Build per-hex treatment timeline
hex_treatment = {}  # hex_id -> set of (year, month) when treated
for hex_id, info in treated_hexes.items():
    active_months = set()
    for it in info["iterations"]:
        start = datetime.strptime(it["start"], "%Y-%m-%d")
        end = datetime.strptime(it["end"], "%Y-%m-%d")
        y, m = start.year, start.month
        while datetime(y, m, 1) < end:
            active_months.add((y, m))
            m += 1
            if m > 12:
                m = 1
                y += 1
    hex_treatment[hex_id] = active_months

# ---- Build neighbor treatment ----
# For each hex, check if any ring-1 neighbor is treated that month
print("Building neighbor treatment (H3 ring-1)...")
neighbor_cache = {}
for hex_id in all_hexes:
    try:
        neighbor_cache[hex_id] = set(h3.grid_ring(hex_id, 1))
    except Exception:
        neighbor_cache[hex_id] = set()

# ---- Determine precinct for each hex ----
# Use the precinct from panel_hex_month_v2
print("Loading precinct assignments...")
hex_precinct = {}
with open("data/panel_hex_month_v2.csv") as f:
    reader = csv.DictReader(f)
    for row in reader:
        if row["hex_id"] not in hex_precinct:
            hex_precinct[row["hex_id"]] = int(row["precinct"])

# ---- Build event study variables ----
# For each treated hex, identify the month it was first activated
# eventneg2/neg1 = 2/1 months before first activation
# eventpos1/pos2 = 1/2 months after first activation
print("Building event study variables...")
hex_first_activation = {}
for hex_id, info in treated_hexes.items():
    if info["iterations"]:
        first_start = min(datetime.strptime(it["start"], "%Y-%m-%d") for it in info["iterations"])
        hex_first_activation[hex_id] = (first_start.year, first_start.month)

# ---- Assign integer hex IDs ----
hex_to_num = {h: i + 1 for i, h in enumerate(sorted(all_hexes))}

# ---- Write panel ----
print("Writing replication panel (2006-2012)...")

CRIME_FIELDS = [
    "total", "robbery", "felony_assault", "burglary", "grand_larceny",
    "gla_mv", "murder", "petit_larceny", "assault3", "arson",
    "violent", "property", "misd",
    "total_outside", "violent_outside", "property_outside",
    "robbery_outside", "felony_assault_outside", "burglary_outside",
]

fieldnames = [
    "hex_id", "hex_num", "year", "month", "year_month", "precinct", "pct_ym",
    "ever_treated", "treatment", "treatmentn",  # neighbor treatment
    "eventneg2", "eventneg1", "eventpos1", "eventpos2",
] + CRIME_FIELDS + [
    "sqf_total", "sqf_pc", "sqf_npc",
    "treatmentpc", "treatmentnpc",  # treatment × PC/NPC interactions
    "arrests_total", "arrests_felony", "arrests_misdemeanor", "arrests_violation",
]

n_rows = 0
n_treated = 0
n_neighbor = 0

with open("data/panel_hex_replication.csv", "w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=fieldnames)
    writer.writeheader()

    for hex_id in sorted(all_hexes):
        if hex_id not in hex_precinct:
            continue  # hex has no events at all

        pct = hex_precinct[hex_id]
        hex_num = hex_to_num[hex_id]
        ever_treated = 1 if hex_id in treated_hexes else 0
        neighbors = neighbor_cache.get(hex_id, set())

        # First activation for event study
        first_act = hex_first_activation.get(hex_id, None)

        for year in range(2006, 2013):  # 2006-2012
            for month in range(1, 13):
                ym = f"{year}-{month:02d}"
                key = f"{hex_id}|{ym}"
                pct_ym = f"{pct}_{ym}"

                # Treatment
                treat = 0
                if hex_id in hex_treatment:
                    if (year, month) in hex_treatment[hex_id]:
                        treat = 1
                        n_treated += 1

                # Neighbor treatment
                treatn = 0
                if treat == 0:  # only for non-treated hexes
                    for nb in neighbors:
                        if nb in hex_treatment and (year, month) in hex_treatment[nb]:
                            treatn = 1
                            n_neighbor += 1
                            break

                # Event study variables
                en2, en1, ep1, ep2 = 0, 0, 0, 0
                if first_act:
                    fa_y, fa_m = first_act
                    # Months relative to first activation
                    rel = (year - fa_y) * 12 + (month - fa_m)
                    if rel == -2:
                        en2 = 1
                    elif rel == -1:
                        en1 = 1
                        en2 = 1  # MacDonald: eventneg2=1 if eventneg1==1
                    elif rel == 1:
                        ep1 = 1
                        ep2 = 1  # MacDonald: eventpos2=1 if eventpos1==1
                    elif rel == 2:
                        ep2 = 1

                # Crime
                crime = crime_data.get(key, {})
                crime_row = {cf: crime.get(cf, 0) for cf in CRIME_FIELDS}

                # SQF
                sqf = sqf_data.get(key, {})
                sqf_total = sqf.get("total", 0)
                sqf_pc = sqf.get("pc", 0)
                sqf_npc = sqf.get("npc", 0)

                # Treatment × SQF interactions
                treatpc = treat * sqf_pc
                treatnpc = treat * sqf_npc

                # Arrests
                arr = arrest_data.get(key, {})

                row = {
                    "hex_id": hex_id,
                    "hex_num": hex_num,
                    "year": year,
                    "month": month,
                    "year_month": ym,
                    "precinct": pct,
                    "pct_ym": pct_ym,
                    "ever_treated": ever_treated,
                    "treatment": treat,
                    "treatmentn": treatn,
                    "eventneg2": en2,
                    "eventneg1": en1,
                    "eventpos1": ep1,
                    "eventpos2": ep2,
                    "sqf_total": sqf_total,
                    "sqf_pc": sqf_pc,
                    "sqf_npc": sqf_npc,
                    "treatmentpc": treatpc,
                    "treatmentnpc": treatnpc,
                    "arrests_total": arr.get("total", 0),
                    "arrests_felony": arr.get("felony", 0),
                    "arrests_misdemeanor": arr.get("misdemeanor", 0),
                    "arrests_violation": arr.get("violation", 0),
                }
                row.update(crime_row)
                writer.writerow(row)
                n_rows += 1

print(f"\nDone: {n_rows:,} rows")
print(f"  Treatment-ON hex-months: {n_treated:,}")
print(f"  Neighbor-treated hex-months: {n_neighbor:,}")

# Quick validation
print("\nValidation:")
with open("data/panel_hex_replication.csv") as f:
    reader = csv.DictReader(f)
    sums = defaultdict(int)
    for row in reader:
        for k in ["violent", "property", "robbery", "treatment", "treatmentn", "sqf_total"]:
            sums[k] += int(row[k])
for k, v in sums.items():
    print(f"  {k}: {v:,}")
