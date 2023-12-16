USE DW;
DROP PROCEDURE IF EXISTS fill_dim_customer;
GO
CREATE PROCEDURE fill_dim_customer
AS
BEGIN
    UPDATE DW.dbo.DimCustomer
     SET 
        Customer_ID = ra.Account_ID,
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
        Status_Persoon = rp.Status_Persoon,
        Marketing_Communicatie = rp.Marketing_Communicatie,
        Lidmaatschap_ID = rl.Lidmaatschap_ID,
        Opzeg = rl.Opzeg,
        Reden_Aangroei = rl.Reden_Aangroei,
        Reden_Verloop = rl.Reden_Verloop,
        Start_Datum = rl.Start_Datum
    FROM DW.dbo.DimCustomer dwh
    LEFT JOIN DEP2.dbo.Account ra ON dwh.Customer_ID = ra.Account_ID
    LEFT JOIN DEP2.dbo.Persoon rp ON dwh.Persoon_ID = rp.Persoon_ID
    LEFT JOIN DEP2.dbo.lidmaatschap rl ON dwh.Lidmaatschap_ID = rl.Lidmaatschap_ID
    WHERE ra.Account_ID IS NOT NULL;

    INSERT INTO DW.dbo.DimCustomer
    (Customer_ID, Geografische_regio, Geografische_subregio, Plaats, Postcode,  Industriezone_Naam_, Is_Voka_entiteit,
    Ondernemingsaard, Ondernemingstype, Oprichtingsdatum, Primaire_activiteit, Reden_van_status, Status, Voka_Nr_,
    Adres_Land, Persoon_ID, Persoonnr, Marketing_Communicatie, Lidmaatschap_ID, Opzeg, Reden_Aangroei, Reden_Verloop, Start_Datum)
    SELECT DISTINCT ra.Account_ID, ra.Adres_Geografische_regio, ra.Adres_Geografische_subregio, ra.Plaats, ra.Postcode,  ra.Industriezone_Naam_,
    ra.Is_Voka_entiteit, ra.Ondernemingsaard, ra.Ondernemingstype, ra.Oprichtingsdatum, ra.Primaire_activiteit, ra.Reden_van_status, 
    ra.Status, ra.Voka_Nr_, ra.Adres_Land, rp.Persoon_ID, rp.Persoonnr, rp.Marketing_Communicatie, rl.Lidmaatschap_ID, rl.Opzeg,
    rl.Reden_Aangroei, rl.Reden_Verloop, rl.Start_Datum
    FROM DEP2.dbo.Account ra 
    JOIN DEP2.dbo.Contactfiche rc ON ra.Account_ID = rc.Account_ID
    JOIN DEP2.dbo.Persoon rp ON rc.Persoon_ID = rp.Persoon_ID
    JOIN DEP2.dbo.Lidmaatschap rl ON rl.Onderneming_ID = ra.Account_ID
    WHERE ra.Account_ID IS NOT NULL;
END;