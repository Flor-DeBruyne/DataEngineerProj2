import pandas as pd                               
import os
from sqlalchemy import create_engine, MetaData
from joblib import load
import datetime
from fastapi import HTTPException, APIRouter, Query

router = APIRouter()

### Uncomment when NOT using Docker
#from dotenv import load_dotenv
#load_dotenv()

SERVER = os.environ.get('SERVER')
DATABASE = os.environ.get('DATAWAREHOUSE')
UID = os.environ.get('USER') 
PWD = os.environ.get('PASSWORD')

connection_string = f'mssql+pyodbc://{UID}:{PWD}@{SERVER}/{DATABASE}?driver=ODBC+Driver+17+for+SQL+Server'
engine = create_engine(connection_string)

metadata = MetaData()
metadata.reflect(engine)

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
                            "Campagne_ID",
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

input_para = ["Naam_Campagne", 
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
            "Duration"]

df_input["Duration"] = df_input["End_date_campagne"] - df_input["Start_date_campagne"]
df_input["Duration"] = df_input["Duration"] + datetime.timedelta(days=1)
df_input["Facturatie_bedrag"] = df_input["Facturatie_bedrag"].str.replace(",", ".").astype(float)

rfc = load("/app/Analyse/campagne_rfc.joblib")

def mailing_pressure(df_mail= df_mail):
    df_mail['Mailing_Sent_On'] = pd.to_datetime(df_mail['Mailing_Sent_On'], dayfirst=True)

    df_mail['Week_Number'] = df_mail['Mailing_Sent_On'].dt.strftime('%Y-%U')

    grouped_data = df_mail.groupby(['Contact_ID', 'Week_Number'])

    email_counts = grouped_data.size().reset_index(name='Email_Count')

    email_counts['Marketing_pressure'] = email_counts['Email_Count'].apply(lambda x: 'High' if x >= 5 else 'Low')

    return email_counts

def get_contact_list(df_input= df_input):
    df_input = df_input.drop_duplicates(["Contact_ID"]).copy()
    return df_input["Contact_ID"]

def get_campagne_list(df_input= df_input):
    df_input = df_input.drop_duplicates(["Campagne_ID"])
    return df_input["Campagne_ID"]


def generate_campagne_list(contact_id, after_date, amount: int, df_input = df_input, rfc= rfc):

    df_input = df_input[df_input["Start_date_campagne"] > after_date]
    df_input = df_input[df_input["Contact_ID"] == contact_id]
    df_input.drop_duplicates(["Naam_Campagne"], inplace=True)

    campagne_proba = rfc.predict_proba(df_input[input_para])

    campagnes = pd.DataFrame({
        'campaign': df_input["Naam_Campagne"].values,
        'probas' : campagne_proba[:, 0]
    })

    campagnes_sorted = campagnes.sort_values("probas", ascending=False)

    return campagnes_sorted[:amount]


def generate_contact_list(campagne_id, amount: int, df_input = df_input, rfc= rfc):
    
    df_input = df_input[df_input["Campagne_ID"] == campagne_id]
    df_input = df_input.drop_duplicates(["Contact_ID"])

    contact_proba = rfc.predict_proba(df_input[input_para])
    email_counts = mailing_pressure()

    contacts = pd.DataFrame({
        'Contact_ID': df_input["Contact_ID"].values,
        'probas' : contact_proba[:, 0],
    })
    
    contacts_merged = pd.merge(contacts, email_counts, on='Contact_ID')
    contacts_grouped = contacts_merged.groupby('Contact_ID').agg({'Email_Count': 'sum', 'probas': 'first', 'Marketing_pressure':'first'}).reset_index()
    contacts_sorted = contacts_grouped.sort_values('probas', ascending=False).sort_values(by='Email_Count', ascending=True)

    return contacts_sorted[['Contact_ID', 'Email_Count', 'probas']][:amount]

@router.get('/get_contacts/')
async def get_contacts():
    try:
        result = get_contact_list()
        return {'result': result.to_dict()}
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    
@router.get('/get_campagnes/')
async def get_campagnes():
    try:
        result = get_campagne_list()
        return {'result': result.to_dict()}
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get('/generate_campagnes/{contact_id}')
async def generate_campagnes(contact_id: str,
                             after_date: str = Query("2023-01-01", description="Campage after this date", ge="2010-01-01"),
                             amount: int = Query(10, description="Number of contacts to generate", ge=1)):
    try:
        # WERKT NIET MET STRING DATE -> aanpassen achter frontend
        # after_date = datetime.datetime.strftime(after_date, "%Y-%m-%d")

        result = generate_campagne_list(contact_id, after_date, amount)

        return {'result': result.to_dict(orient='records')}
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    

@router.get('/generate_contacts/{campagne_id}')
async def generate_contacts(campagne_id: str,
                            amount: int = Query(10, description="Number of contacts to generate", ge=1)):
    try:
        result = generate_contact_list(campagne_id, amount)

        return {'result': result.to_dict(orient='records')}
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))




