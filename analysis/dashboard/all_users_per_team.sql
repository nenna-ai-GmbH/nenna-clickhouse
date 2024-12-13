SELECT 
    toDate(timestamp) as date,
    organization_id,
    count(DISTINCT user_id) as unique_users,
    toDate(now() - INTERVAL 4 WEEK) as query_start_date,
    toDate(now()) as query_end_date
FROM event_masking
WHERE timestamp >= now() - INTERVAL 4 WEEK
  AND timestamp <= now()
GROUP BY 
    toDate(timestamp),
    organization_id
ORDER BY 
    date DESC,
    organization_id;

-- TODO: 
-- Link the user via the user_id to the team_id
-- Show the team_id in the query on org level 