import glob
import pandas as pd

csv_files = glob.glob('../Data/*.csv')

merged_df = pd.DataFrame()

for csv_file in csv_files:
    df = pd.read_csv(csv_file)
    merged_df = pd.concat([merged_df, df], ignore_index=True)

merged_df.to_csv('../Data/MERGED.csv', index=False)