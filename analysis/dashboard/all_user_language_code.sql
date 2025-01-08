SELECT 
    toStartOfWeek(timestamp) as week,
    organization_id,
    user_input_language_code,
    count(DISTINCT user_id) as unique_users,
    toDate(now() - INTERVAL 4 WEEK) as query_start_date,
    toDate(now()) as query_end_date
FROM event_masking
WHERE timestamp >= now() - INTERVAL 4 WEEK
  AND timestamp <= now()
GROUP BY 
    toStartOfWeek(timestamp),
    organization_id,
    user_input_language_code
ORDER BY 
    week DESC,
    organization_id,
    user_input_language_code;