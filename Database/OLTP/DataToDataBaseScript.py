from dotenv import load_dotenv   #for python-dotenv method
import os
import pandas as pd
from sqlalchemy import create_engine, MetaData

load_dotenv()

csv_dir =  '/home/flor/Workspace/DEP2/DataEngineerProj2/Data' #path waar de data csv files staan
SERVER = os.environ.get('SERVER') 
DATABASE = os.environ.get('DATABASE')
UID = os.environ.get('USER') 
PWD = os.environ.get('PASSWORD') 



table_file = {
    'Account' : 'Account.csv',
    'Persoon' : 'Persoon.csv', 
    'Contactfiche' : 'Contact.csv',
    'Activiteitscode' : 'Activiteitscode.csv',
    'Account_ActiviteitsCode' : 'Account activiteitscode.csv',   
    'Account_Financiele_Data' : 'Account financiële data.csv',    
    'Afspraak_Alle' : 'Afspraak alle.csv',
    'Activiteit_Vereist_Contact' : 'Activiteit vereist contact.csv',
    'Afspraak_Account_Gelinkt' : 'Afspraak_account_gelinkt_cleaned.csv',
    'Afspraak_Betreft_Contactfiche': 'Afspraak betreft contact_cleaned.csv',
    'Afspraak_Betreft_Account' : 'Afspraak betreft account_cleaned.csv',
    'Campagne' : 'Campagnes.csv',
    'CDI_Mailing' : 'CDI mailing.csv',
    'CDI_PageView' : 'cdi pageviews.csv', 
    'CDI_Web_Content' : 'CDI web content.csv', 
    'CDI_Visits' : 'CDI visits.csv',
    'CDI_Sent_Email_Clicks' : 'CDI sent email clicks.csv',
    'Functie' : 'Functie.csv',
    'ContactFunctie' : 'Contact functie.csv', 
    'Gebruiker' : 'Gebruikers.csv',
    'Info_en_Klachten' : 'Info en klachten.csv',
    'Inschrijving' : 'Inschrijvingen.csv', 
    'Lidmaatschap' : 'Lidmaatschap.csv',
    'Sessie' : 'Sessie.csv',
    'SessieInschrijving': 'Sessie inschrijving.csv'
}

try:
    connection_string = f'mssql+pyodbc://{UID}:{PWD}@{SERVER}/{DATABASE}?driver=ODBC+Driver+17+for+SQL+Server'
    engine = create_engine(connection_string)

    metadata = MetaData()
    metadata.reflect(engine)    
    
    for table_name, file_name in table_file.items():
        table_columns = metadata.tables[table_name].columns.keys()
        file_path = os.path.join(csv_dir, file_name)

        df = pd.read_csv(file_path, on_bad_lines='skip')
        df = df.rename(columns={csv_col: sql_col for csv_col, sql_col in zip(df.columns, table_columns)})

        if df.isnull().values.any():
            df.dropna(how='all')

        print(f"Final {table_name} DataFrame shape: {df.shape}")

        df.to_sql(table_name, con=engine, schema='dbo', if_exists='append', index=False)
        print(f"{table_name} done")
    print("Uploading compleet")

except Exception as e:
    print(f"Error: {str(e)}")
