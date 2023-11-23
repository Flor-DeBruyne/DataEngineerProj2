USE DW;
DROP PROCEDURE IF EXISTS fill_dim_date;
GO
CREATE PROCEDURE fill_dim_date
AS

DECLARE @StartDate DATE = '2018-01-01';
DECLARE @EndDate DATE = '2023-12-31';
DECLARE @CurrentDate DATE = @StartDate;

-- Loop to insert dates into DimDate
WHILE @CurrentDate <= @EndDate
BEGIN
    INSERT INTO DimDate (
        date_key,
        date,
        day_num,
        day_of_year,
        day_of_week,
        day_of_week_name,
        week_num,
        week_begin_date,
        week_end_date,
        last_week_begin_date,
        last_week_end_date,
        last_2_week_begin_date,
        last_2_week_end_date,
        month_num,
        month_name,
        yearmonth_num,
        last_month_num,
        last_month_name,
        last_month_year,
        last_yearmonth_num,
        quarter_num,
        year_num,
        is_weekday
    )
    VALUES (
        CONVERT(INT, FORMAT(@CurrentDate, 'yyyyMMdd')),
        @CurrentDate,
        DATEPART(DAY, @CurrentDate),
        DATEPART(DAYOFYEAR, @CurrentDate),
        DATEPART(WEEKDAY, @CurrentDate),
        DATENAME(WEEKDAY, @CurrentDate),
        DATEPART(WEEK, @CurrentDate),
        DATEADD(DAY, 1 - DATEPART(WEEKDAY, @CurrentDate), @CurrentDate),
        DATEADD(DAY, 7 - DATEPART(WEEKDAY, @CurrentDate), @CurrentDate),
        DATEADD(DAY, -6 - DATEPART(WEEKDAY, @CurrentDate), @CurrentDate),
        DATEADD(DAY, 0 - DATEPART(WEEKDAY, @CurrentDate), @CurrentDate),
        DATEADD(DAY, -13 - DATEPART(WEEKDAY, @CurrentDate), @CurrentDate),
        DATEADD(DAY, -7 - DATEPART(WEEKDAY, @CurrentDate), @CurrentDate),
        DATEPART(MONTH, @CurrentDate),
        DATENAME(MONTH, @CurrentDate),
        DATEPART(YEAR, @CurrentDate) * 100 + DATEPART(MONTH, @CurrentDate),
        DATEPART(MONTH, DATEADD(MONTH, -1, @CurrentDate)),
        DATENAME(MONTH, DATEADD(MONTH, -1, @CurrentDate)),
        DATEPART(YEAR, DATEADD(MONTH, -1, @CurrentDate)),
        DATEPART(YEAR, @CurrentDate) * 100 + DATEPART(MONTH, DATEADD(MONTH, -1, @CurrentDate)),
        DATEPART(QUARTER, @CurrentDate),
        DATEPART(YEAR, @CurrentDate),
        CASE WHEN DATEPART(WEEKDAY, @CurrentDate) IN (1, 7) THEN '0' ELSE '1' END
    );

    SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
END;