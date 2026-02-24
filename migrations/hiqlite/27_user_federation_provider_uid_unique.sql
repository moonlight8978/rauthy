DELETE FROM user_federations
WHERE rowid NOT IN (
    SELECT MIN(rowid)
    FROM user_federations
    GROUP BY provider_id, federation_uid
);

CREATE UNIQUE INDEX user_federations_provider_id_federation_uid_uindex
    ON user_federations (provider_id, federation_uid);
