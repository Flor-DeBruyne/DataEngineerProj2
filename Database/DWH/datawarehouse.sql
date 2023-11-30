-- DROP DATABASE IF EXISTS DW;
-- CREATE DATABASE DW;
-- USE DW;

-- Dimension Tables
DROP TABLE IF EXISTS DimDate;
CREATE TABLE DimDate (
    date_Key INT NOT NULL PRIMARY KEY,
    date DATETIME DEFAULT NULL,
    day_num INT DEFAULT NULL,
    day_of_year INT DEFAULT NULL,
    day_of_week INT DEFAULT NULL,
    day_of_week_name varchar(20) DEFAULT NULL,
    week_num INT DEFAULT NULL,
    week_begin_date DATE DEFAULT NULL,
    week_end_date DATE DEFAULT NULL,
    last_week_begin_date DATE DEFAULT NULL,
    last_week_end_date DATE DEFAULT NULL,
    last_2_week_begin_date DATE DEFAULT NULL,
    last_2_week_end_date DATE DEFAULT NULL,
    month_num INT DEFAULT NULL,
    month_name varchar(20) DEFAULT NULL,
    yearmonth_num INT DEFAULT NULL,
    last_month_num INT DEFAULT NULL,
    last_month_name varchar(20) DEFAULT NULL,
    last_month_year INT DEFAULT NULL,
    last_yearmonth_num INT DEFAULT NULL,
    quarter_num INT DEFAULT NULL,
    year_num INT DEFAULT NULL,
    is_weekday VARCHAR(1)  DEFAULT '1'
);

-- Tables account, persoon, lidmaatschap
DROP TABLE IF EXISTS DimCustomer;
CREATE TABLE DimCustomer (
    Customer_ID VARCHAR(255),
    Geografische_regio VARCHAR(255),
    Geografische_subregio VARCHAR(255),
    Plaats VARCHAR(255),
    Postcode VARCHAR(100),
    Industriezone_Naam_ VARCHAR(255),
    Is_Voka_entiteit VARCHAR(10),
    Ondernemingsaard VARCHAR(255),
    Ondernemingstype VARCHAR(255),
    Oprichtingsdatum VARCHAR(255),
    Primaire_activiteit VARCHAR(255),
    Reden_van_status VARCHAR(255),
    Status VARCHAR(255),
    Voka_Nr_ INT,
    Adres_Land VARCHAR(255),
    Persoon_ID VARCHAR(255),
    Persoonnr INT,
    Status_Persoon VARCHAR(255),
    Marketing_Communicatie VARCHAR(255),
    Lidmaatschap_ID VARCHAR(255),
    Opzeg VARCHAR(255),
    Reden_Aangroei VARCHAR(255),
    Reden_Verloop VARCHAR(255),
    Start_Datum VARCHAR(255),
    PRIMARY KEY(Customer_ID, Persoon_ID)
);

-- Tables Functie, Contactfiche, inschrijving
DROP TABLE IF EXISTS DimContact;
CREATE TABLE DimContact (
    Contact_ID VARCHAR(255),
    Account_ID VARCHAR(255),
    Functie_title VARCHAR(255),
    Contact_status VARCHAR(255),
    Voka_medewerker INT,
    Persoon_ID VARCHAR(255),
    Inschrijving_status VARCHAR(255),
    Bron VARCHAR(255),
    Datum VARCHAR(255),
    Inschrijving_ID VARCHAR(255),
    Facturatie_bedrag VARCHAR(255),
    PRIMARY KEY(Contact_ID, Inschrijving_ID)
);

-- Tables CDI_email, CDI_visits
DROP TABLE IF EXISTS DimEmail;
CREATE TABLE DimEmail (
    Mailing_ID VARCHAR(255)  ,
    Mailing_Name VARCHAR(255),
    Mailing_Sent_On VARCHAR(255),
    Mailing_Subject VARCHAR(255),
    IP_Stad VARCHAR(255),
    IP_Land VARCHAR(255),
    IP_Adress VARCHAR(255),
    IP_Organization VARCHAR(255),
    Visit_ID VARCHAR(255),
    Campagne_ID VARCHAR(255),
    Contact_ID VARCHAR(255),
    PRIMARY KEY (Mailing_ID, Visit_ID)
);


-- Fact Tables
DROP TABLE IF EXISTS FactCampagne;
CREATE TABLE FactCampagne (
    Fact_ID INT NOT NULL IDENTITY(1,1) ,
    Customer_ID VARCHAR(255),
    Persoon_ID VARCHAR(255),
    Contact_ID VARCHAR(255),
    Inschrijving_ID VARCHAR(255),
    Campagne_ID VARCHAR(255),
    Mailing_ID VARCHAR(255),
    Visit_ID VARCHAR(255),
    Campagne_Nr VARCHAR(255),
    Eind_date_key INT,
    Naam VARCHAR(255),
    Naam_in_email VARCHAR(255),
    Reden_van_status VARCHAR(255),
    Start_date_key INT,
    Status_Camp VARCHAR(255),
    Type_campagne VARCHAR(255),
    Soort_Campagne VARCHAR(255),
    -- Duration DATETIME,
    FOREIGN KEY (Mailing_ID, Visit_ID) REFERENCES DimEmail(Mailing_ID, Visit_ID),
    FOREIGN KEY (Customer_ID, Persoon_ID) REFERENCES DimCustomer(Customer_ID, Persoon_ID),
    FOREIGN KEY (Contact_ID, Inschrijving_ID) REFERENCES DimContact(Contact_ID, Inschrijving_ID),
    FOREIGN KEY (Eind_date_key) REFERENCES DimDate(date_key),
    FOREIGN KEY (Start_date_key) REFERENCES DimDate(date_key),
    PRIMARY KEY(Fact_ID, Campagne_ID) 
);
