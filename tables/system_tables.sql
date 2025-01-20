TRUNCATE TABLE system.text_log;
TRUNCATE TABLE system.metric_log;
TRUNCATE TABLE system.asynchronous_metric_log;
TRUNCATE TABLE system.trace_log;
TRUNCATE TABLE system.processors_profile_log;
TRUNCATE TABLE system.query_log;
TRUNCATE TABLE system.error_log;
TRUNCATE TABLE system.part_log;


ALTER TABLE system.text_log
MODIFY TTL event_time + INTERVAL 10 DAY DELETE;

ALTER TABLE system.metric_log
MODIFY TTL event_time + INTERVAL 10 DAY DELETE;

ALTER TABLE system.asynchronous_metric_log
MODIFY TTL event_time + INTERVAL 10 DAY DELETE;

ALTER TABLE system.trace_log
MODIFY TTL event_time + INTERVAL 10 DAY DELETE;

ALTER TABLE system.processors_profile_log
MODIFY TTL event_time + INTERVAL 10 DAY DELETE;

ALTER TABLE system.query_log
MODIFY TTL event_time + INTERVAL 10 DAY DELETE;

ALTER TABLE system.error_log
MODIFY TTL event_time + INTERVAL 10 DAY DELETE;

ALTER TABLE system.part_log
MODIFY TTL event_time + INTERVAL 10 DAY DELETE;

