USE DW;
DROP PROCEDURE IF EXISTS fill_fact_campagne;
GO
CREATE PROCEDURE fill_fact_campagne
AS
BEGIN
    UPDATE DW.dbo.FactCampagne
     SET 
        Customer_ID = rcu.Customer_ID,
        Persoon_ID = rcu.Persoon_ID,
        Contact_ID = rc.Contact_ID,
        Inschrijving_ID = rc.Inschrijving_ID,
        Mailing_ID = re.Mailing_ID,
        Visit_ID = re.Visit_ID,
        Campagne_ID =  rca.Campagne_ID,
        Campagne_Nr = rca.Campagne_Nr,
        Eind_date_key = rd.[date_Key],
        Naam = rca.Naam,
        Naam_in_email = rca.Naam_in_email,
        Reden_van_status = rca.Reden_van_status,
        Start_date_key = rd.[date_Key],
        Status_Camp = rca.Status_Camp,
        Type_campagne = rca.Type_campagne,
        Soort_Campagne = rca.Soort_Campagne
    FROM DW.dbo.FactCampagne dwh
    LEFT JOIN DW.dbo.DimCustomer rcu ON dwh.Customer_ID = rcu.Customer_ID
    LEFT JOIN DW.dbo.DimContact rc ON dwh.Contact_ID = rc.Contact_ID
    LEFT JOIN DEP2.dbo.Campagne rca ON dwh.Campagne_ID = rca.Campagne_ID
    LEFT JOIN DW.dbo.DimEmail re ON dwh.Mailing_ID = re.Mailing_ID
    LEFT JOIN DW.dbo.DimDate rd ON dwh.Eind_date_key = rd.date_key;

    INSERT INTO DW.dbo.FactCampagne
    (Customer_ID, Persoon_ID, Contact_ID, Inschrijving_ID, Mailing_ID, Visit_ID,Campagne_ID, Campagne_Nr, Eind_date_key, Naam, Naam_in_email, Reden_van_status,
    Start_date_key, Status_Camp, Type_campagne, Soort_Campagne)
    SELECT DISTINCT rcu.Customer_ID, rcu.Persoon_ID, rc.Contact_ID, rc.Inschrijving_ID, re.Mailing_ID, re.Visit_ID, rca.Campagne_ID, rca.Campagne_Nr, de.date_Key, rca.Naam,
    rca.Naam_in_email, rca.Reden_van_status, ds.date_key, rca.Status_Camp, rca.Type_campagne, rca.Soort_Campagne
    FROM DEP2.dbo.Campagne rca
    JOIN DW.dbo.DimEmail re ON rca.Campagne_ID = re.Campagne_ID
    JOIN DW.dbo.DimContact rc ON  re.Contact_ID = rc.Contact_ID
    JOIN DW.dbo.DimCustomer rcu ON rc.Persoon_ID = rcu.Persoon_ID
    JOIN DW.dbo.DimDate de ON CONVERT(INT, FORMAT(rca.Einddatum, 'yyyyMMdd')) = de.date_key
    JOIN DW.dbo.DimDate ds ON CONVERT(INT, FORMAT(rca.Startdatum, 'yyyyMMdd')) = ds.date_key
    WHERE rca.Campagne_ID is not null;

    
END;
