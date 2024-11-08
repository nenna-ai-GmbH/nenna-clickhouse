CREATE USER nenna_cloud IDENTIFIED WITH sha256_password BY 'password';
GRANT SELECT, INSERT ON default.event_masking TO nenna_cloud;