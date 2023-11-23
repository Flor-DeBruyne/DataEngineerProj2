USE DW;
DROP PROCEDURE IF EXISTS fill_dim_contact;
GO
CREATE PROCEDURE fill_dim_contact
AS
BEGIN
    UPDATE DW.dbo.DimContact
     SET 
        Contact_ID = rc.Contactfiche_ID,
        Account_ID = rc.Account_ID,
        Functie_title = rc.Functie_title,
        Contact_status = rc.Status,
        Voka_medewerker = rc.Voka_medewerker,
        Persoon_ID = rc.Persoon_ID,
        Inschrijving_status = ri.Status,
        Bron = ri.Bron,
        Datum = ri.Datum,
        Inschrijving_ID = ri.Inschrijving_ID,
        Facturatie_bedrag = ri.Facturatie_bedrag
    FROM DW.dbo.DimContact dwh
    LEFT JOIN DEP2.dbo.Contactfiche rc ON dwh.Contact_ID = rc.Contactfiche_ID
    LEFT JOIN DEP2.dbo.Inschrijving ri ON dwh.Inschrijving_ID = ri.Inschrijving_ID;


    INSERT INTO DW.dbo.DimContact
    (Contact_ID, Account_ID, Functie_title, Contact_status, Voka_medewerker, Persoon_ID, 
    Inschrijving_status, Bron, Datum, Inschrijving_ID, Facturatie_bedrag)
    SELECT DISTINCT rc.Contactfiche_ID, rc.Account_ID, rc.Functie_title, rc.Status, rc.Voka_medewerker,  rc.Persoon_ID,
    ri.Status, ri.Bron, ri.Datum, ri.Inschrijving_ID, ri.Facturatie_bedrag
    FROM DEP2.dbo.Contactfiche rc 
    JOIN DEP2.dbo.Inschrijving ri ON rc.Contactfiche_ID = ri.Contactfiche_ID;

END;


