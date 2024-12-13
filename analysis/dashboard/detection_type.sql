WITH 
    arrayJoin(groupUniqArray(mapKeys(detections_per_type))) AS detection_types
SELECT 
    organization_id,
    detection_types,
    sumMap(detections_per_type)[detection_types] as original_count,
    mapAdd(
        sumMap(detections_per_type),
        map(detection_types, 2)  -- adds 2 to each detection type
    )[detection_types] as modified_count,
    toDate(now() - INTERVAL 4 WEEK) as query_start_date,
    toDate(now()) as query_end_date
FROM event_masking
WHERE timestamp >= now() - INTERVAL 4 WEEK
  AND timestamp <= now()
GROUP BY 
    organization_id,
    detection_types
ORDER BY 
    organization_id,
    detection_types;
-- TODO: 
-- Link the user via the user_id to the team_id
-- Show the team_id in the query on org level 