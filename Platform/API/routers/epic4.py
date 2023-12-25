import pandas as pd                                 
from sklearn.preprocessing import LabelEncoder, StandardScaler
from sklearn.metrics.pairwise import cosine_similarity
import os
from sqlalchemy import create_engine
from fastapi import APIRouter
from sklearn.cluster import KMeans

## Uncomment when NOT using Docker
#from dotenv import load_dotenv
#load_dotenv()

router = APIRouter()

## DW connection
SERVER = os.environ.get('SERVER')
DATABASE = os.environ.get('DATAWAREHOUSE')
UID = os.environ.get('USER')
PWD = os.environ.get('PASSWORD')
    
connection_string = f'mssql+pyodbc://{UID}:{PWD}@{SERVER}/{DATABASE}?driver=ODBC+Driver+17+for+SQL+Server'

def find_lookalikes(contact_id) :
    ## Reading data
    conn = create_engine(connection_string).connect()
    contacts = pd.read_sql_table('DimContact', conn)
    accounts = pd.read_sql_table('DimCustomer', conn)
    conn.close()

    ## Determining contacts with high number of transactions
    participation_counts = contacts.groupby('Contact_ID')['Inschrijving_ID'].count().reset_index()
    avg_participation = participation_counts['Inschrijving_ID'].mean()
    high_transaction_contacts = participation_counts[participation_counts['Inschrijving_ID'] >= avg_participation]['Contact_ID']

    ## Data manipulation
    contacts = contacts.merge(accounts, how='left', left_on='Account_ID', right_on='Customer_ID')
    contacts = contacts.sort_values(['Contact_ID', 'Contact_status'])    
    contacts = contacts.drop_duplicates('Contact_ID', keep='first')

    ## Encoding labels
    encoded_features = ['Account_encoded', 'Titel_encoded', 'Voka_employee_encoded', 'Regio_encoded', 'Subregio_encoded', 'Company_kind_encoded', 'Company_type_encoded', 'Primary_activity_encoded']
    
    account_encoder = LabelEncoder()
    title_encoder = LabelEncoder()
    voka_encoder = LabelEncoder()
    regio_encoder = LabelEncoder()
    subregio_encoder = LabelEncoder()
    company_kind_encoder = LabelEncoder()
    company_type_encoder = LabelEncoder()
    primary_activity_encoder = LabelEncoder()

    contacts['Account_encoded'] = account_encoder.fit_transform(contacts['Account_ID'])
    contacts['Titel_encoded'] = title_encoder.fit_transform(contacts['Functie_title'])
    contacts['Voka_employee_encoded'] = voka_encoder.fit_transform(contacts['Voka_medewerker'])
    contacts['Regio_encoded'] = regio_encoder.fit_transform(contacts['Geografische_regio'])
    contacts['Subregio_encoded'] = subregio_encoder.fit_transform(contacts['Geografische_subregio'])
    contacts['Company_kind_encoded'] = company_kind_encoder.fit_transform(contacts['Ondernemingsaard'])
    contacts['Company_type_encoded'] = company_type_encoder.fit_transform(contacts['Ondernemingstype'])
    contacts['Primary_activity_encoded'] = primary_activity_encoder.fit_transform(contacts['Primaire_activiteit'])
    
    ## Retrieving contact and high transaction contacts
    contact = contacts[contacts['Contact_ID'] == contact_id]
    contacts = contacts[contacts['Contact_ID'] != contact_id]
    contacts = contacts[contacts['Contact_ID'].isin(high_transaction_contacts)] # Only keep the high transaction contacts

    ## Calculating cosine similarity    
    similarity_matrix = cosine_similarity(contact[encoded_features], contacts[encoded_features])
    contacts['similarity'] = similarity_matrix[0]

    ## Returning result
    contacts = contacts.sort_values(by = 'similarity', ascending = False)    
    contacts = contacts[['Contact_ID', 'similarity']]
    contacts_list = contacts.values.tolist()
    
    return [{'Contact_ID': contact_info[0], 'Similarity': contact_info[1]} for contact_info in contacts_list]


def find_clusters():
    ## Optimal K
    K = 3

    ## Reading data
    conn = create_engine(connection_string).connect()
    contacts = pd.read_sql_table('DimContact', conn)
    accounts = pd.read_sql_table('DimCustomer', conn)
    conn.close()

    ## Data manipulation
    contacts = contacts.merge(accounts, how='left', left_on='Account_ID', right_on='Customer_ID')
    contacts = contacts.sort_values(['Contact_ID', 'Contact_status'])    
    contacts = contacts.drop_duplicates('Contact_ID', keep='first')

    ## Data encoding
    encoded_features = ['Account_encoded', 'Titel_encoded', 'Voka_employee_encoded', 'Regio_encoded', 'Subregio_encoded', 'Company_kind_encoded', 'Company_type_encoded', 'Primary_activity_encoded']
    
    account_encoder = LabelEncoder()
    title_encoder = LabelEncoder()
    voka_encoder = LabelEncoder()
    regio_encoder = LabelEncoder()
    subregio_encoder = LabelEncoder()
    company_kind_encoder = LabelEncoder()
    company_type_encoder = LabelEncoder()
    primary_activity_encoder = LabelEncoder()

    contacts['Account_encoded'] = account_encoder.fit_transform(contacts['Account_ID'])
    contacts['Titel_encoded'] = title_encoder.fit_transform(contacts['Functie_title'])
    contacts['Voka_employee_encoded'] = voka_encoder.fit_transform(contacts['Voka_medewerker'])
    contacts['Regio_encoded'] = regio_encoder.fit_transform(contacts['Geografische_regio'])
    contacts['Subregio_encoded'] = subregio_encoder.fit_transform(contacts['Geografische_subregio'])
    contacts['Company_kind_encoded'] = company_kind_encoder.fit_transform(contacts['Ondernemingsaard'])
    contacts['Company_type_encoded'] = company_type_encoder.fit_transform(contacts['Ondernemingstype'])
    contacts['Primary_activity_encoded'] = primary_activity_encoder.fit_transform(contacts['Primaire_activiteit'])

    # Standardize data
    scaler = StandardScaler()
    contacts_scaled = scaler.fit_transform(contacts[encoded_features])

    ## Apply K-Means clustering
    kmeans = KMeans(n_clusters=K, random_state=42)
    contacts['Cluster'] = kmeans.fit_predict(contacts_scaled)

    ## Return result
    contacts = contacts[['Contact_ID', 'Cluster']]
    contacts = contacts.sort_values('Cluster')
    contacts_list = contacts.values.tolist()

    return [{'Contact_ID': contact_info[0], 'Cluster': contact_info[1]} for contact_info in contacts_list] 

## Epic 4 endpoints
@router.get('/lookalikes/{contact_id}')
async def handle_lookalikes(contact_id: str):
    res = find_lookalikes(contact_id)

    return {
        'length': len(res),
        'result' : res
    }

@router.get('/clusters')
async def handle_clusters(): 
    res = find_clusters()

    return {
        'length': len(res),
        'result' : res
    }