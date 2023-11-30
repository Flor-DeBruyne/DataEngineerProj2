-- CREATE DATABASE DEP2;
-- USE DEP2;

-- Account Table
CREATE TABLE Account (
    Account_ID VARCHAR(255) PRIMARY KEY,
    Adres_Geografische_regio VARCHAR(255),
    Adres_Geografische_subregio VARCHAR(255),
    Plaats VARCHAR(255),
    Postcode VARCHAR(100),
    Provincie VARCHAR(255),
    Industriezone_Naam_ VARCHAR(255),
    Is_Voka_entiteit VARCHAR(10),
    Ondernemingsaard VARCHAR(255),
    Ondernemingstype VARCHAR(255),
    Oprichtingsdatum VARCHAR(255),
    Primaire_activiteit VARCHAR(255),
    Reden_van_status VARCHAR(255),
    Status VARCHAR(255),
    Voka_Nr_ INT,
    Adres_Land VARCHAR(255)
);

-- Table: Persoon
CREATE TABLE Persoon (
    Persoon_ID VARCHAR(255) PRIMARY KEY,
    Persoonnr INTEGER,
    Status_Persoon VARCHAR(255),
    Marketing_Communicatie VARCHAR(255)
);

-- Table: Contact
CREATE TABLE Contactfiche (
    Contactfiche_ID VARCHAR(255) PRIMARY KEY,
    Account_ID VARCHAR(255),
    Functie_title VARCHAR(255),
    Persoon_ID VARCHAR(255),
    Status VARCHAR(255),
    Voka_medewerker INTEGER,
    FOREIGN KEY (Persoon_ID) REFERENCES Persoon(Persoon_ID),
    FOREIGN KEY (Account_ID) REFERENCES Account(Account_ID)
);

-- Activiteitscode Table
CREATE TABLE Activiteitscode (
    Naam VARCHAR(255),
    Activiteitscode_ID VARCHAR(255) PRIMARY KEY,
    Status_Code VARCHAR(255)
);

-- Account ActiviteitsCode Table
CREATE TABLE Account_ActiviteitsCode (
    Activiteits_Code VARCHAR(255),
    Activiteitscode_ID VARCHAR(255),
    inf_account_inf_activiteitscodeId VARCHAR(255),
    FOREIGN KEY (Activiteits_Code) REFERENCES Account(Account_ID),
    FOREIGN KEY (Activiteitscode_ID) REFERENCES Activiteitscode(Activiteitscode_ID),
    PRIMARY KEY(Activiteits_Code, Activiteitscode_ID)
);


-- Account Financiele data Table
CREATE TABLE Account_Financiele_Data (
    Account_ID VARCHAR(255),
    Boekjaar INT,
    Aantal_maanden INT,
    Toegevoegde_waarde VARCHAR(255),
    FTE VARCHAR(255),
    Gewijzigd_op VARCHAR(255),
    PRIMARY KEY (Account_ID, Boekjaar),
    FOREIGN KEY (Account_ID) REFERENCES Account(Account_ID)
);

CREATE TABLE Activiteit_Vereist_Contact (
    Activity_ID VARCHAR(255) ,
    ReqAttendee VARCHAR(255),
    FOREIGN KEY (Activity_ID) REFERENCES Activiteitscode(Activiteitscode_ID),
    FOREIGN KEY (ReqAttendee) REFERENCES Contactfiche(Contactfiche_ID),
    PRIMARY KEY(Activity_ID, ReqAttendee)
);

-- Table: Afpsraak Alle
CREATE TABLE Afspraak_Alle (
    Afspraak_ID VARCHAR(255) PRIMARY KEY
);

-- Table: Afspraak account gelinkt 
CREATE TABLE Afspraak_Account_Gelinkt (
    Afspraak_ID VARCHAR(255),
    Thema VARCHAR(255),
    Subthema VARCHAR(255),
    Onderwerp VARCHAR(255),
    Eindtijd VARCHAR(255),
    Account_ID VARCHAR(255),
    KeyPrhases VARCHAR(2500),
    FOREIGN KEY (Afspraak_ID) REFERENCES Afspraak_Alle(Afspraak_ID),
    FOREIGN KEY (Account_ID) REFERENCES Account(Account_ID)
);

-- Table: Afspraak betreft contactfiche
CREATE TABLE Afspraak_Betreft_Contactfiche (
    Afspraak_ID VARCHAR(255),
    Thema VARCHAR(255),
    Subthema VARCHAR(255),
    Onderwerp VARCHAR(255),
    Contactfiche_ID VARCHAR(255),
    Eindtijd VARCHAR(255),
    KeyPrhases VARCHAR(2500),
    FOREIGN KEY (Afspraak_ID) REFERENCES Afspraak_Alle(Afspraak_ID),
    FOREIGN KEY (Contactfiche_ID) REFERENCES Contactfiche(Contactfiche_ID)
);

-- Table: Afspraak betreft account
CREATE TABLE Afspraak_Betreft_Account (
    Afspraak_ID VARCHAR(255),
    Thema VARCHAR(255),
    Subthema VARCHAR(255),
    Onderwerp VARCHAR(255),
    Account_ID VARCHAR(255),
    Eindtijd VARCHAR(255),
    KeyPrhases VARCHAR(2500),
    FOREIGN KEY (Afspraak_ID) REFERENCES Afspraak_Alle(Afspraak_ID),
    FOREIGN KEY (Account_ID) REFERENCES Account(Account_ID)
);



-- Table: Afspraak vereist contact
CREATE TABLE Afspraak_Vereist_Contact (
    Afspraak_ID VARCHAR(255),
    Contactfiche_ID VARCHAR(255),
    FOREIGN KEY (Afspraak_ID) REFERENCES Afspraak_Alle(Afspraak_ID),
    FOREIGN KEY (Contactfiche_ID) REFERENCES Contactfiche(Contactfiche_ID)
);

-- Table: Campagne
CREATE TABLE Campagne (
    Campagne_ID VARCHAR(255) PRIMARY KEY,
    Campagne_Nr VARCHAR(255),
    Einddatum DATETIME,
    Naam VARCHAR(255),
    Naam_in_email VARCHAR(255),
    Reden_van_status VARCHAR(255),
    Startdatum DATETIME,
    Status_Camp VARCHAR(255),
    Type_campagne VARCHAR(255),
    URL_voka_be VARCHAR(255),
    Soort_Campagne VARCHAR(255)
);

-- Table: CDI mailing
CREATE TABLE CDI_Mailing (
    Mailing_ID VARCHAR(255) PRIMARY KEY,
    Mailing_Name VARCHAR(255),
    Mailing_Sent_On VARCHAR(255),
    Mailing_Subject VARCHAR(255)
);

-- Table: cdi pageviews
CREATE TABLE CDI_PageView (
    Browser VARCHAR(50),
    Campagne_ID VARCHAR(255),
    Contact_ID VARCHAR(255),
    Duration VARCHAR(255),
    Operating_System VARCHAR(50),
    PageView_ID VARCHAR(500) PRIMARY KEY,
    Referrer_Type VARCHAR(255),
    PageView_Time DateTime,
    Title VARCHAR(255),
    Type VARCHAR(255),
    Viewed_On DATETIME, 
    Visit VARCHAR(255),
    Visitor_key VARCHAR(255),
    Made_On DATETIME, --
    Edited_By VARCHAR(255), -- fk
    Edited_On DATETIME, 
    Status VARCHAR(255),
    Status_Reason VARCHAR(255),
    -- FOREIGN KEY (Edited_By) REFERENCES Persoon(Persoon_ID),
    FOREIGN KEY (Campagne_ID) REFERENCES Campagne(Campagne_ID),
    FOREIGN KEY (Contact_ID) REFERENCES Contactfiche(Contactfiche_ID),
    -- FOREIGN KEY (Visit) REFERENCES CDI_Visits(Visit_ID)
);

-- Table: cdi web content
CREATE TABLE CDI_Web_Content (
    Campaign_ID VARCHAR(255),
    Campaign_Name VARCHAR(255),
    Naam VARCHAR(255),
    WebContent_ID VARCHAR(255) PRIMARY KEY,
    Made_By_Name VARCHAR(255), 
    Created_On VARCHAR(255),
    Edited_By_Name VARCHAR(255),
    Modified_On VARCHAR(255),
    Owner_ID VARCHAR(255),
    Owner_Name VARCHAR(255),
    Owning_Business_Unit VARCHAR(255) 
);

-- Table: cdi visits
CREATE TABLE CDI_Visits (
    Campagne_ID VARCHAR(255),
    IP_Stad VARCHAR(255),
    Contactfiche_ID VARCHAR(255),
    Contact_Naam VARCHAR(255),
    IP_Land VARCHAR(255),
    Duration VARCHAR(255),
    Email_Send VARCHAR(255),
    Ended_On VARCHAR(255), --datetime
    First_Visit VARCHAR(255),
    IP_Adress VARCHAR(255),
    IP_Organization VARCHAR(255),
    IP_Latitude VARCHAR(255),
    IP_Longitude VARCHAR(255),
    Operating_System VARCHAR(255),
    IP_Postcode VARCHAR(255),
    Score VARCHAR(255),
    Referrer_Type VARCHAR(255),
    Started_On DATETIME,
    IP_Status VARCHAR(255),
    Visit_Time DATETIME,
    Visit_ID VARCHAR(255) PRIMARY KEY,
    Aangemaakt_op DATETIME,
    Gewijzigd_op DATETIME,
    FOREIGN KEY (Campagne_ID) REFERENCES Campagne(Campagne_ID),
    FOREIGN KEY (Contactfiche_ID) REFERENCES Contactfiche(Contactfiche_ID),
    FOREIGN KEY (Email_send) REFERENCES CDI_Mailing(Mailing_ID)
);

-- Table: cdi sent email clicks
CREATE TABLE CDI_Sent_Email_Clicks (
    SentEmailClicks VARCHAR(255),
    Contactfiche_ID VARCHAR(255),
    Email_versturen VARCHAR(255),
    Sent_Email VARCHAR(255),
    FOREIGN KEY (Contactfiche_ID) REFERENCES Contactfiche(Contactfiche_ID),
    FOREIGN KEY (Email_versturen) REFERENCES CDI_Mailing(Mailing_ID),
    PRIMARY KEY(Sent_Email, Contactfiche_ID)
);

-- Table: Functie
CREATE TABLE Functie(
    Functie_ID VARCHAR(255) PRIMARY KEY,
    Functie_Naam VARCHAR(255),
);

-- Table: Contact functie
CREATE TABLE ContactFunctie (
    Persoon_ID VARCHAR(255),
    Functie_ID VARCHAR(255),
    FOREIGN KEY (Functie_ID) REFERENCES Functie(Functie_ID),
    FOREIGN KEY (Persoon_ID) REFERENCES Contactfiche(Contactfiche_ID)
);


-- Table: Gebruiker
CREATE TABLE Gebruiker (
    Gebruiker_ID VARCHAR(255) PRIMARY KEY,
    Business_unit_naam VARCHAR(255)
);


-- Table: Info en klachten
CREATE TABLE Info_en_Klachten (
    Aanvraag VARCHAR(255) PRIMARY KEY,
    Account_ID VARCHAR(255),
    Datum VARCHAR(255),
    Datum_afsluiting VARCHAR(255),
    Status VARCHAR(255), -- Gesloten/actief
    Eigenaar VARCHAR(255),
    FOREIGN KEY (Eigenaar) REFERENCES Gebruiker(Gebruiker_ID),
    FOREIGN KEY (Account_ID) REFERENCES Account(Account_ID)    
);

-- Table: Inschrijving
CREATE TABLE Inschrijving (
    Status VARCHAR(255), -- Aanwezig/Afwezig
    Bron VARCHAR(255),
    Contactfiche_ID VARCHAR(255),
    Datum DATE,
    Inschrijving_ID VARCHAR(255) PRIMARY KEY,
    Facturatie_bedrag VARCHAR(255),
    Campagne_ID VARCHAR(255),
    Campagne_naam VARCHAR(255),
    FOREIGN KEY (Contactfiche_ID) REFERENCES Contactfiche(Contactfiche_ID),
    FOREIGN KEY (Campagne_ID) REFERENCES Campagne(Campagne_ID)
);


-- Table: Lidmaatschap
drop table Lidmaatschap
CREATE TABLE Lidmaatschap (
    Opzeg VARCHAR(255),
    Lidmaatschap_ID VARCHAR(255) PRIMARY KEY,
    Onderneming_ID VARCHAR(255),
    Reden_Aangroei VARCHAR(255),
    Reden_Verloop VARCHAR(255),
    Start_Datum DATE,
    FOREIGN KEY (Onderneming_ID) REFERENCES Account(Account_ID)
);


-- Table: Sessie
CREATE TABLE Sessie (
    Activiteitstype VARCHAR(255), 
    Campagne_ID VARCHAR(255),
    Einddatum DATETIME,
    Product VARCHAR(255),
    Sessie_ID VARCHAR(255) PRIMARY KEY,
    Sessie_nr VARCHAR(255),
    Startdatum DATETIME,
    Thema VARCHAR(255), 
    FOREIGN KEY (Campagne_ID) REFERENCES Campagne(Campagne_ID)
);



-- Table: Sessie inschrijving
CREATE TABLE SessieInschrijving (
    SessieInschrijving_ID VARCHAR(255) PRIMARY KEY,
    Sessie_ID VARCHAR(255),
    Inschrijving_ID VARCHAR(255),
    FOREIGN KEY (Sessie_ID) REFERENCES Sessie(Sessie_ID),
    FOREIGN KEY (Inschrijving_ID) REFERENCES Inschrijving(Inschrijving_ID)
);



