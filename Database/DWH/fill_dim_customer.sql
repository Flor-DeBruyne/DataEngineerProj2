USE DW;
DROP PROCEDURE IF EXISTS fill_dim_customer;
GO
CREATE PROCEDURE fill_dim_customer
AS
BEGIN
    UPDATE DW.dbo.DimCustomer
     SET 
        Geografische_regio = ra.Adres_Geografische_regio,
        Geografische_subregio = ra.Adres_Geografische_subregio,
        Plaats = ra.Plaats,
        Postcode = ra.Postcode,
        Industriezone_Naam_ = ra.Industriezone_Naam_,
        Is_Voka_entiteit = ra.Is_Voka_entiteit,
        Ondernemingsaard = ra.Ondernemingsaard,
        Ondernemingstype = ra.Ondernemingstype,
        Oprichtingsdatum = ra.Oprichtingsdatum,
        Primaire_activiteit = ra.Primaire_activiteit,
        Reden_van_status = ra.Reden_van_status,
        Status = ra.Status,
        Voka_Nr_ = ra.Voka_Nr_,
        Adres_Land = ra.Adres_Land,
        Persoon_ID = rp.Persoon_ID,
        Persoonnr = rp.Persoonnr,
        Status_Persoon = rp.Reden_Status,
        Marketing_Communicatie = rp.Marketing_Communicatie
    FROM DW.dbo.DimCustomer dwh
    LEFT JOIN DEP2.dbo.Account ra ON dwh.Customer_ID = ra.Account_ID
    LEFT JOIN DEP2.dbo.Persoon rp ON dwh.Persoon_ID = rp.Persoon_ID;
    -- WHERE CLAUSE

    INSERT INTO DW.dbo.DimCustomer
    (Customer_ID, Geografische_regio, Geografische_subregio, Plaats, Postcode, Industriezone_Naam_, Is_Voka_entiteit,
    Ondernemingsaard, Ondernemingstype, Oprichtingsdatum, Primaire_activiteit, Reden_van_status, Status, Voka_Nr_,
    Adres_Land)
    SELECT ra.Account_ID, ra.Adres_Geografische_regio, ra.Adres_Geografische_subregio, ra.Plaats, ra.Postcode, ra.Provincie, ra.Industriewone_Naam_,
    ra.Is_Voka_entiteit, ra.Ondernemingsaard, ra.Ondernemingstype, ra.Oprichtingsdatum, ra.Primaire_activiteit, ra.Reden_van_status, 
    ra.Status, ra.Voka_Nr_, ra.Adres_Land
    FROM DEP2.dbo.Account ra;


    INSERT INTO DW.dbo.DimCustomer
    (Persoon_ID, Persoonnr, Status_Persoon, Marketing_Communicatie)
    SELECT rp.Persoon_ID, rp.Persoonnr, rp.Reden_Status, rp.Marketing_Communicatie
    FROM DEP2.dbo.Persoon rp;

END;

