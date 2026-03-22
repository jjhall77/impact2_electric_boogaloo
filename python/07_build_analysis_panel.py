#!/usr/bin/env python3
"""
PHASE 0: Build the definitive analysis panel (2006-2016).
Extends python/05_build_hex_replication_panel.py to full study period.

Columns:
  hex_id, hex_num, year, month, year_month, time_id, precinct, pct_ym,
  ever_treated, treatment, treatmentn,
  violent, property, robbery, felony_assault, burglary,
  robbery_outside, felony_assault_outside, burglary_outside,
  assault_total, assault_total_outside,
  sqf_total, sqf_pc, sqf_npc, treatmentpc, treatmentnpc,
  arrests_total, arrests_felony, arrests_misdemeanor, arrests_violation
"""

import csv
import json
import h3
from collections import defaultdict
from datetime import datetime

# ---- Load data sources ----
print("Loading treatment map...")
with open("data/hex_treatment_map.json") as f:
    tmap = json.load(f)
treated_hexes = tmap["treated"]
all_hexes = tmap["all_hexes"]

print("Loading detailed crime counts...")
with open("data/crime_hex_month_detailed.json") as f:
    crime_data = json.load(f)

print("Loading SQF counts...")
with open("data/sqf_hex_month.json") as f:
    sqf_data = json.load(f)

print("Loading arrest counts...")
with open("data/arrests_hex_month.json") as f:
    arrest_data = json.load(f)

# ---- Build treatment timelines ----
print("Building treatment indicators...")

hex_treatment = {}
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

# ---- Build neighbor cache ----
print("Building neighbor treatment (H3 ring-1)...")
neighbor_cache = {}
for hex_id in all_hexes:
    try:
        neighbor_cache[hex_id] = set(h3.grid_ring(hex_id, 1))
    except Exception:
        neighbor_cache[hex_id] = set()

# ---- Load precinct assignments from v2 panel ----
print("Loading precinct assignments...")
hex_precinct = {}
with open("data/panel_hex_month_v2.csv") as f:
    reader = csv.DictReader(f)
    for row in reader:
        if row["hex_id"] not in hex_precinct:
            hex_precinct[row["hex_id"]] = int(row["precinct"])

# ---- Integer hex IDs ----
hex_to_num = {h: i + 1 for i, h in enumerate(sorted(all_hexes))}

# ---- Build time_id mapping ----
time_ids = {}
tid = 0
for year in range(2006, 2017):
    for month in range(1, 13):
        tid += 1
        time_ids[(year, month)] = tid

# ---- Write panel ----
print("Writing analysis panel (2006-2016)...")

fieldnames = [
    "hex_id", "hex_num", "year", "month", "year_month", "time_id",
    "precinct", "pct_ym", "ever_treated", "treatment", "treatmentn",
    "violent", "property", "robbery", "felony_assault", "burglary",
    "robbery_outside", "felony_assault_outside", "burglary_outside",
    "assault_total", "assault_total_outside",
    "sqf_total", "sqf_pc", "sqf_npc", "treatmentpc", "treatmentnpc",
    "arrests_total", "arrests_felony", "arrests_misdemeanor", "arrests_violation",
]

n_rows = 0
n_treated = 0
n_neighbor = 0

with open("data/panel_hex_analysis.csv", "w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=fieldnames)
    writer.writeheader()

    for hex_id in sorted(all_hexes):
        if hex_id not in hex_precinct:
            continue

        pct = hex_precinct[hex_id]
        hex_num = hex_to_num[hex_id]
        ever_treated = 1 if hex_id in treated_hexes else 0
        neighbors = neighbor_cache.get(hex_id, set())

        for year in range(2006, 2017):
            for month in range(1, 13):
                ym = f"{year}-{month:02d}"
                key = f"{hex_id}|{ym}"
                pct_ym = f"{pct}_{ym}"
                tid = time_ids[(year, month)]

                # Treatment
                treat = 0
                if hex_id in hex_treatment:
                    if (year, month) in hex_treatment[hex_id]:
                        treat = 1
                        n_treated += 1

                # Neighbor treatment (only for non-treated hexes)
                treatn = 0
                if treat == 0:
                    for nb in neighbors:
                        if nb in hex_treatment and (year, month) in hex_treatment[nb]:
                            treatn = 1
                            n_neighbor += 1
                            break

                # Crime
                crime = crime_data.get(key, {})
                violent = crime.get("violent", 0)
                prop = crime.get("property", 0)
                robbery = crime.get("robbery", 0)
                felony_assault = crime.get("felony_assault", 0)
                burglary = crime.get("burglary", 0)
                robbery_out = crime.get("robbery_outside", 0)
                fa_out = crime.get("felony_assault_outside", 0)
                burg_out = crime.get("burglary_outside", 0)
                assault3 = crime.get("assault3", 0)
                assault3_out = crime.get("assault3_outside", 0)
                assault_total = felony_assault + assault3
                assault_total_out = fa_out + assault3_out

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
                    "time_id": tid,
                    "precinct": pct,
                    "pct_ym": pct_ym,
                    "ever_treated": ever_treated,
                    "treatment": treat,
                    "treatmentn": treatn,
                    "violent": violent,
                    "property": prop,
                    "robbery": robbery,
                    "felony_assault": felony_assault,
                    "burglary": burglary,
                    "robbery_outside": robbery_out,
                    "felony_assault_outside": fa_out,
                    "burglary_outside": burg_out,
                    "assault_total": assault_total,
                    "assault_total_outside": assault_total_out,
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
                writer.writerow(row)
                n_rows += 1

print(f"\nDone: {n_rows:,} rows")
print(f"  Hexes: {len(hex_precinct):,}")
print(f"  Months: {len(time_ids)}")
print(f"  Expected: {len(hex_precinct) * len(time_ids):,}")
print(f"  Treatment-ON hex-months: {n_treated:,}")
print(f"  Neighbor-treated hex-months: {n_neighbor:,}")

# Validation
print("\nValidation sums:")
with open("data/panel_hex_analysis.csv") as f:
    reader = csv.DictReader(f)
    sums = defaultdict(int)
    for row in reader:
        for k in ["violent", "property", "robbery", "felony_assault", "burglary",
                   "robbery_outside", "felony_assault_outside", "burglary_outside",
                   "assault_total", "assault_total_outside",
                   "treatment", "treatmentn", "sqf_total", "sqf_pc"]:
            sums[k] += int(row[k])
for k, v in sorted(sums.items()):
    print(f"  {k}: {v:,}")
