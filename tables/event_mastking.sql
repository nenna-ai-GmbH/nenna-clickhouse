CREATE TABLE IF NOT EXISTS event_masking (
    event_id String,
    timestamp DateTime,
    user_id UInt32,
    role_id Nullable(Enum('Policy Admin' = 1, 'User' = 2, 'Operator' = 3, 'NULL' = 0)),
    url Nullable(String),
    user_agent Nullable(String),
    organization_id String,
    user_input_language_code String,
    user_input_type Nullable(Enum(
        'text/plain' = 1,
        'application/pdf' = 2,
        'application/msword' = 3,
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' = 4,
        'application/vnd.ms-powerpoint' = 5,
        'image/jpeg' = 6,
        'video/mp4' = 7,
        'audio/mpeg' = 8,
        'NULL' = 0
    )),
    endpoint Enum('filter' = 1, 'filter_binary' = 2) DEFAULT 'filter',
    filtered_by_policy_id Nullable(String),
    event_trigger Enum('masking' = 1, 'de_masking' = 2, 'send' = 3),
    user_input String,
    total_detections UInt32 DEFAULT 0,
    detections_per_type Map(String, UInt32)
) ENGINE = MergeTree()
ORDER BY (timestamp, event_id);