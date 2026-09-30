"""
Script de carga del CSV limpio a BigQuery.

Nota: en el proyecto original la carga se hizo manualmente desde la consola
web de BigQuery. Este script documenta el proceso automatizable equivalente.

Uso:
    python scripts/load_to_bigquery.py

Requisitos:
    - Autenticación: gcloud auth application-default login
    - CSV limpio en data/credit_risk_clean.csv
    - Dataset `credit_risk` creado en BigQuery
"""

from pathlib import Path
import pandas as pd
from google.cloud import bigquery


# ============================================
# CONFIGURACIÓN
# ============================================

PROJECT_ID = "credit-risk-dashboard-123456"
DATASET_ID = "credit_risk"
TABLE_ID = "loans"

BASE_DIR = Path(__file__).resolve().parent.parent
CSV_PATH = BASE_DIR / "data" / "credit_risk_clean.csv"


# ============================================
# CARGA
# ============================================

def cargar_a_bigquery():
    """Carga el CSV limpio a BigQuery."""

    if not CSV_PATH.exists():
        raise FileNotFoundError(f"No se encontró el CSV: {CSV_PATH}")

    print(f"📖 Cargando CSV: {CSV_PATH}")
    df = pd.read_csv(CSV_PATH)
    print(f"   Filas: {len(df):,} | Columnas: {len(df.columns)}")

    print(f"\n🔌 Conectando a BigQuery...")
    client = bigquery.Client(project=PROJECT_ID)

    table_ref = f"{PROJECT_ID}.{DATASET_ID}.{TABLE_ID}"

    job_config = bigquery.LoadJobConfig(
        autodetect=True,
        write_disposition="WRITE_TRUNCATE",
        skip_leading_rows=1,  # Saltar la fila de encabezado
    )

    print(f"\n⬆️  Subiendo a {table_ref}...")
    job = client.load_table_from_dataframe(df, table_ref, job_config=job_config)
    job.result()

    table = client.get_table(table_ref)
    print(f"\n✅ Carga completada")
    print(f"   Filas en BigQuery: {table.num_rows:,}")
    print(f"   Columnas: {len(table.schema)}")

    if table.num_rows == len(df):
        print(f"\n✅ Verificación OK")
    else:
        print(f"\n⚠️ Discrepancia: CSV={len(df)} vs BQ={table.num_rows}")


if __name__ == "__main__":
    print("=" * 60)
    print("📦 CARGA DEL CSV LIMPIO A BIGQUERY")
    print("=" * 60)
    cargar_a_bigquery()
    print("=" * 60)
