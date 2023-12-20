import pandas as pd                               
from dotenv import load_dotenv
import os
from sqlalchemy import create_engine, MetaData
from joblib import load
import datetime

load_dotenv()
csv_dir =  '/home/flor/Workspace/DEP2/DataEngineerProj2/Data'
SERVER = os.environ.get('SERVER')
DATABASE = os.environ.get('DATAWAREHOUSE')
UID = os.environ.get('USER') 
PWD = os.environ.get('PASSWORD')

connection_string = f'mssql+pyodbc://{UID}:{PWD}@{SERVER}/{DATABASE}?driver=ODBC+Driver+17+for+SQL+Server'
engine = create_engine(connection_string)

metadata = MetaData()
metadata.reflect(engine)

def generate_campagne_list(contact_id, after_date, amount : int):
    df_fact = pd.read_sql_table(table_name='FactCampagne', con=engine)
    df_mail = pd.read_sql_table(table_name='DimEmail', con=engine)
    df_cont = pd.read_sql_table(table_name='DimContact', con=engine)
    df_cust = pd.read_sql_table(table_name='DimCustomer', con=engine)
    df_date = pd.read_sql_table(table_name='DimDate', con=engine)

    df_final = pd.merge(df_fact, df_mail, on=["Mailing_ID", "Visit_ID", "Campagne_ID", "Contact_ID"])
    df_final = pd.merge(df_final, df_cont, on=["Contact_ID","Persoon_ID", "Inschrijving_ID"])
    df_final = pd.merge(left=df_final, right=df_cust ,on=["Customer_ID", "Persoon_ID"])

    df_final['End_date_campagne'] = df_final['Eind_date_key'].map(df_date.set_index('date_Key')['date'])
    df_final['Start_date_campagne'] = df_final['Start_date_key'].map(df_date.set_index('date_Key')['date'])

    df_input = df_final[["Naam_Campagne",
                            "Type_campagne",
                            "Soort_Campagne",
                            "Onderwerp_campagne",
                            "Contact_ID",
                            "Functie_title",
                            "Bron",
                            "Facturatie_bedrag",
                            "IP_Stad",
                            "IP_Land",
                            "Geografische_regio",
                            "Geografische_subregio",
                            "Plaats",
                            "Industriezone_Naam_",
                            "Ondernemingsaard",
                            "Ondernemingstype",
                            "Primaire_activiteit",
                            "Marketing_Communicatie",
                            "Opzeg",
                            "Reden_Aangroei",
                            "Reden_Verloop",
                            "Start_date_campagne",
                            "End_date_campagne"]]
    
    input_para = ["Naam_Campagne", "Type_campagne",
                            "Soort_Campagne",
                            "Onderwerp_campagne",
                            "Contact_ID",
                            "Functie_title",
                            "Bron",
                            "Facturatie_bedrag",
                            "IP_Stad",
                            "IP_Land",
                            "Geografische_regio",
                            "Geografische_subregio",
                            "Plaats",
                            "Industriezone_Naam_",
                            "Ondernemingsaard",
                            "Ondernemingstype",
                            "Primaire_activiteit",
                            "Marketing_Communicatie",
                            "Opzeg",
                            "Reden_Aangroei",
                            "Reden_Verloop",
                            "Duration"]

    df_input["Duration"] = df_input["End_date_campagne"] - df_input["Start_date_campagne"]
    df_input["Duration"] = df_input["Duration"] + datetime.timedelta(days=1)
    df_input["Facturatie_bedrag"] = df_input["Facturatie_bedrag"].str.replace(",", ".").astype(float)
    
    rfc = load("../../Analyse/campagne_rfc.joblib")

    df_input = df_input[df_input["Start_date_campagne"] > after_date]
    df_input = df_input[df_input["Contact_ID"] == contact_id]
    df_input.drop_duplicates(["Naam_Campagne"], inplace=True)

    print(df_input["Start_date_campagne"].value_counts())

    campagne_proba = rfc.predict_proba(df_input[input_para])


    campagnes = pd.DataFrame({
        'campaign': df_input["Naam_Campagne"].values,
        'probas' : campagne_proba[:, 0]
    })

    campagnes_sorted = campagnes.sort_values("probas", ascending=False)

    return campagnes_sorted[:amount]


# if __name__ == "__main__":
#     generate_campagne_list("C5A58825-B2FE-E811-80F9-001DD8B72B61",'2023-03-27', 5)

    


