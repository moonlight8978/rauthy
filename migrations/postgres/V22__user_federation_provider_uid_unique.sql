DELETE FROM user_federations uf
USING (
    SELECT ctid
    FROM (
        SELECT ctid,
               ROW_NUMBER() OVER (
                   PARTITION BY provider_id, federation_uid
                   ORDER BY user_id, provider_id
               ) AS rn
        FROM user_federations
    ) dedupe
    WHERE dedupe.rn > 1
) del
WHERE uf.ctid = del.ctid;

CREATE UNIQUE INDEX user_federations_provider_id_federation_uid_uindex
    ON user_federations (provider_id, federation_uid);
