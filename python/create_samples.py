import pandas as pd
from pathlib import Path

source_folder = Path(
    r"C:\Users\user\Desktop\Projekt Healthcare-Analytics\synthea\output\csv"
)

files = {
    "encounters.csv": 50000,
    "medications.csv": 50000,
    "procedures.csv": 30000
}

for filename, rows in files.items():

    print(f"Processing {filename}...")

    file_path = source_folder / filename

    df = pd.read_csv(file_path)

    sample_df = df.head(rows)

    output_file = source_folder / filename.replace(".csv", "_sample.csv")

    sample_df.to_csv(output_file, index=False)

    size_mb = output_file.stat().st_size / (1024 * 1024)

    print(f"Saved: {output_file.name}")
    print(f"Size: {size_mb:.2f} MB")
    print("-" * 50)
    
print("Done!")