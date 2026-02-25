CREATE TABLE user_federations (
    user_id TEXT NOT NULL
        CONSTRAINT user_federations_user_id_fk
            REFERENCES users
            ON UPDATE CASCADE ON DELETE CASCADE,
    provider_id TEXT NOT NULL
        CONSTRAINT user_federations_provider_id_fk
            REFERENCES auth_providers
            ON UPDATE CASCADE ON DELETE CASCADE,
    federation_uid TEXT NOT NULL,
    CONSTRAINT user_federations_pk
        PRIMARY KEY (user_id, provider_id)
) STRICT;

INSERT OR IGNORE INTO user_federations (user_id, provider_id, federation_uid)
SELECT id, auth_provider_id, federation_uid
FROM users
WHERE auth_provider_id IS NOT NULL
    AND federation_uid IS NOT NULL;
