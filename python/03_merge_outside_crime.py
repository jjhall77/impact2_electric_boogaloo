#!/usr/bin/env python3
"""Merge outside crime counts into panel_hex_month_v2 → panel_hex_month_v3."""

import csv
import json

print("Loading outside crime counts...")
with open("data/crime_hex_month_v2.json") as f:
    crime = json.load(f)

print("Merging into panel...")
with open("data/panel_hex_month_v2.csv") as fin, \
     open("data/panel_hex_month_v3.csv", "w", newline="") as fout:

    reader = csv.DictReader(fin)
    fieldnames = reader.fieldnames + [
        "violent_outside", "property_outside", "crime_total_outside"
    ]
    writer = csv.DictWriter(fout, fieldnames=fieldnames)
    writer.writeheader()

    n = 0
    n_match = 0
    for row in reader:
        key = f"{row['hex_id']}|{row['year_month']}"
        if key in crime:
            c = crime[key]
            row["violent_outside"] = c["violent_outside"]
            row["property_outside"] = c["property_outside"]
            row["crime_total_outside"] = c["total_outside"]
            n_match += 1
        else:
            row["violent_outside"] = 0
            row["property_outside"] = 0
            row["crime_total_outside"] = 0
        writer.writerow(row)
        n += 1

print(f"Done: {n:,} rows, {n_match:,} matched with crime data")

# Quick validation
import collections
with open("data/panel_hex_month_v3.csv") as f:
    reader = csv.DictReader(f)
    vo_sum = 0
    po_sum = 0
    for row in reader:
        vo_sum += int(row["violent_outside"])
        po_sum += int(row["property_outside"])
print(f"Panel totals — violent_outside: {vo_sum:,}, property_outside: {po_sum:,}")
