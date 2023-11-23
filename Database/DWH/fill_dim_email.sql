USE DW;
DROP PROCEDURE IF EXISTS fill_dim_email;
GO
CREATE PROCEDURE fill_dim_email
AS
BEGIN
    UPDATE DW.dbo.DimEmail
     SET 
        Mailing_ID = rm.Mailing_ID,
        Mailing_Name = rm.Mailing_Name,
        Mailing_Sent_On = rm.Mailing_Sent_On,
        Mailing_Subject = rm.Mailing_Subject,
        IP_Stad = rv.IP_Stad,
        IP_Land = rv.IP_Land,
        IP_Adress = rv.IP_Adress,
        IP_Organization = rv.IP_Organization,
        Visit_ID = rv.Visit_ID,
        Campagne_ID = rv.Campagne_ID,
        Contact_ID = rv.Contactfiche_ID
    FROM DW.dbo.DimEmail dwh
    INNER JOIN DEP2.dbo.CDI_Mailing rm ON dwh.Mailing_ID = rm.Mailing_ID
    LEFT JOIN DEP2.dbo.CDI_Visits rv ON dwh.Visit_ID = rv.Visit_ID
    WHERE rm.Mailing_ID IS NOT NULL;

    INSERT INTO DW.dbo.DimEmail
    (Mailing_ID, Mailing_Name, Mailing_Sent_On, Mailing_Subject,
    IP_Stad, IP_Land, IP_Adress, IP_Organization, Visit_ID, Campagne_ID, Contact_ID)
    SELECT rm.Mailing_ID, rm.Mailing_Name, rm.Mailing_Sent_On, rm.Mailing_Subject,
    rv.IP_Stad, rv.IP_Land, rv.IP_Adress, rv.IP_Organization, rv.Visit_ID, rv.Campagne_ID, rv.Contactfiche_ID
    FROM DEP2.dbo.CDI_Mailing rm
    JOIN DEP2.dbo.CDI_Visits rv ON rm.Mailing_ID = rv.Email_Send
    WHERE rm.Mailing_ID IS NOT NULL;
END;