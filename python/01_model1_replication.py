# 01_model1_replication.py
# Python cross-validation of Model 1 from MacDonald, Fagan & Geller (2016)
# Uses pyfixest (Python port of R fixest) for conditional FE Poisson
#
# Replicates all 20 Model 1 estimates (10 crime + 10 arrest outcomes)
# and compares to R replication coefficients and published values.
#
# Usage: python3 python/01_model1_replication.py

import pandas as pd
import pyfixest as pf
import time
import os

os.chdir(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# ---- Outcome variable definitions -------------------------------------------

CRIME_OUTCOMES = [
    "crimes1", "offenses47", "offenses15", "offenses7", "crimes10",
    "crimes7", "crimes6", "crimes5", "crimes3", "offenses"
]
CRIME_LABELS = {
    "crimes1": "Total", "offenses47": "Robbery", "offenses15": "Assault",
    "offenses7": "Burglary", "crimes10": "Weapons", "crimes7": "Misd.",
    "crimes6": "Other Felony", "crimes5": "Drugs", "crimes3": "Property Felony",
    "offenses": "Violent Felony"
}

ARREST_OUTCOMES = [
    "crimes1", "crimes3", "crimes5", "crimes6", "crimes7",
    "crimes10", "offenses8", "offenses18", "offenses57", "offenses"
]
ARREST_LABELS = {
    "offenses": "Total", "offenses57": "Robbery", "offenses18": "Assault",
    "offenses8": "Burglary", "crimes10": "Weapons", "crimes7": "Misd.",
    "crimes6": "Other Felony", "crimes5": "Drugs", "crimes3": "Property Felony",
    "crimes1": "Violent Felony"
}

# Reference coefficients from published paper (Table 1)
PAPER_CRIME = {
    "crimes1": -0.124, "offenses47": -0.157, "offenses15": -0.131,
    "offenses7": -0.611, "crimes10": 0.314, "crimes7": -0.198,
    "crimes6": 0.614, "crimes5": -0.026, "crimes3": -0.296,
    "offenses": -0.120
}
PAPER_ARREST = {
    "offenses": 0.426, "offenses57": -0.002, "offenses18": -0.017,
    "offenses8": 0.387, "crimes10": 0.279, "crimes7": 0.298,
    "crimes6": 0.533, "crimes5": -0.083, "crimes3": 1.174,
    "crimes1": 0.024
}

# Reference coefficients from R replication (output/table1_*_m1.md)
R_CRIME = {
    "crimes1": -0.122, "offenses47": -0.160, "offenses15": -0.133,
    "offenses7": -0.614, "crimes10": 0.311, "crimes7": -0.202,
    "crimes6": 0.602, "crimes5": -0.029, "crimes3": -0.302,
    "offenses": -0.128
}
R_ARREST = {
    "offenses": 0.418, "offenses57": -0.005, "offenses18": -0.018,
    "offenses8": 0.374, "crimes10": 0.277, "crimes7": 0.293,
    "crimes6": 0.518, "crimes5": -0.084, "crimes3": 1.146,
    "crimes1": 0.022
}


def load_and_prepare(filepath):
    """Load raw CSV and construct year_pct_month FE key."""
    print(f"Loading {filepath}...")
    t0 = time.time()
    df = pd.read_csv(filepath, na_values=["", "NA", "."], low_memory=False)
    print(f"  Loaded {len(df):,} rows in {time.time()-t0:.1f}s")

    df["ym"] = df["year"].astype(int) * 100 + df["month"].astype(int)
    df["pct"] = df["pct"].astype(int)
    df["year_pct_month"] = df["ym"].astype(str) + "_" + df["pct"].astype(str)

    # Ensure treatment is integer
    df["treatment"] = df["treatment"].fillna(0).astype(int)

    return df


def run_model1(df, outcomes, labels, paper_coefs, r_coefs, data_type):
    """Run Model 1 for all outcomes, return results DataFrame."""
    results = []

    for yvar in outcomes:
        label = labels[yvar]
        print(f"  Estimating {data_type} Model 1: {label} ({yvar})...", end=" ")
        t0 = time.time()

        try:
            fit = pf.fepois(
                f"{yvar} ~ treatment | year_pct_month",
                data=df,
                vcov={"CRV1": "year_pct_month"}
            )
            py_coef = fit.coef().iloc[0]
            py_se = fit.se().iloc[0]
            py_n = fit._N
            elapsed = time.time() - t0
            print(f"coef={py_coef:.4f}, SE={py_se:.4f}, N={py_n:,} ({elapsed:.1f}s)")

            results.append({
                "type": data_type,
                "variable": yvar,
                "label": label,
                "python_coef": round(py_coef, 4),
                "python_se": round(py_se, 4),
                "python_n": int(py_n),
                "r_coef": r_coefs[yvar],
                "paper_coef": paper_coefs[yvar],
                "py_vs_r_diff": round(abs(py_coef - r_coefs[yvar]), 4),
                "py_vs_paper_diff": round(abs(py_coef - paper_coefs[yvar]), 4),
            })
        except Exception as e:
            print(f"FAILED: {e}")
            results.append({
                "type": data_type,
                "variable": yvar,
                "label": label,
                "python_coef": None,
                "python_se": None,
                "python_n": None,
                "r_coef": r_coefs[yvar],
                "paper_coef": paper_coefs[yvar],
                "py_vs_r_diff": None,
                "py_vs_paper_diff": None,
            })

    return results


def print_comparison(results, data_type):
    """Print formatted comparison table."""
    print(f"\n{'='*90}")
    print(f"  {data_type.upper()} MODEL 1: Python vs R vs Paper")
    print(f"{'='*90}")
    header = f"{'Outcome':<18} {'Py Coef':>9} {'Py SE':>9} {'R Coef':>9} {'Paper':>9} {'|Py-R|':>8} {'Py N':>10}"
    print(header)
    print("-" * 90)
    for r in results:
        if r["type"] != data_type:
            continue
        if r["python_coef"] is not None:
            print(f"{r['label']:<18} {r['python_coef']:>9.4f} {r['python_se']:>9.4f} "
                  f"{r['r_coef']:>9.3f} {r['paper_coef']:>9.3f} "
                  f"{r['py_vs_r_diff']:>8.4f} {r['python_n']:>10,}")
        else:
            print(f"{r['label']:<18} {'FAILED':>9} {'':>9} "
                  f"{r['r_coef']:>9.3f} {r['paper_coef']:>9.3f}")


# ---- Main -------------------------------------------------------------------

if __name__ == "__main__":
    print("=" * 60)
    print("  Python Cross-Validation: Model 1 (FE Poisson)")
    print("  MacDonald, Fagan & Geller (2016)")
    print(f"  pyfixest version: {pf.__version__}")
    print("=" * 60)

    all_results = []

    # Crime
    print("\n--- CRIME ---")
    crime = load_and_prepare("data-raw/blocks2004_2012_crime_fid_impactzones.csv")
    crime_results = run_model1(crime, CRIME_OUTCOMES, CRIME_LABELS,
                               PAPER_CRIME, R_CRIME, "crime")
    all_results.extend(crime_results)
    del crime  # free memory before loading arrest data

    # Arrest
    print("\n--- ARREST ---")
    arrest = load_and_prepare("data-raw/blocks2004_2012_arrest_fid_impactzones 2.csv")
    arrest_results = run_model1(arrest, ARREST_OUTCOMES, ARREST_LABELS,
                                PAPER_ARREST, R_ARREST, "arrest")
    all_results.extend(arrest_results)
    del arrest

    # Print comparison tables
    print_comparison(all_results, "crime")
    print_comparison(all_results, "arrest")

    # Summary statistics
    valid = [r for r in all_results if r["python_coef"] is not None]
    py_r_diffs = [r["py_vs_r_diff"] for r in valid]
    py_paper_diffs = [r["py_vs_paper_diff"] for r in valid]

    print(f"\n{'='*60}")
    print("  SUMMARY")
    print(f"{'='*60}")
    print(f"  Models estimated: {len(valid)}/{len(all_results)}")
    print(f"  Python vs R:    mean |diff| = {sum(py_r_diffs)/len(py_r_diffs):.4f}, "
          f"max = {max(py_r_diffs):.4f}")
    print(f"  Python vs Paper: mean |diff| = {sum(py_paper_diffs)/len(py_paper_diffs):.4f}, "
          f"max = {max(py_paper_diffs):.4f}")

    # Save results
    os.makedirs("output", exist_ok=True)
    df_results = pd.DataFrame(all_results)
    df_results.to_csv("output/python_model1_comparison.csv", index=False)
    print(f"\nResults saved to output/python_model1_comparison.csv")
