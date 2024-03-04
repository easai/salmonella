WITH
  SalmonellaIncidents AS (
    SELECT
      DATE_TRUNC (report_date, MONTH) AS report_month,
      COUNT(*) AS incident_count
    FROM
      `bigquery-public-data.fda_food.food_enforcement`
    WHERE
      reason_for_recall LIKE '%Salmonella%'
    GROUP BY
      report_month
  ),
  MonthlyAverages AS (
    SELECT
      report_month,
      AVG(incident_count) AS average_incidents,
      STDDEV (incident_count) AS stddev_incidents
    FROM
      SalmonellaIncidents
    GROUP BY
      report_month
  )
SELECT
  report_month,
  FORMAT_DATE ("%b %Y", report_month) AS formatted_month,
  average_incidents,
  stddev_incidents
FROM
  MonthlyAverages
ORDER BY
  report_month;