CREATE USER IF NOT EXISTS metabase IDENTIFIED WITH sha256_password BY 'password';
GRANT SELECT, INSERT ON default.event_masking TO metabase;