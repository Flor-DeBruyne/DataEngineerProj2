import pandas as pd

# Read the CSV file into a DataFrame
csv_dir = 'C:/Users/Eli/Desktop/DEPII/CDI_sent_email_clicks.csv'
df = pd.read_csv(csv_dir)

df = df.dropna(how='all')

# Save the modified DataFrame back to the original CSV file, overwriting it
df.to_csv(csv_dir, index=False)