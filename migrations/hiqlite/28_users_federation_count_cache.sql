ALTER TABLE users
    ADD federation_count INTEGER NOT NULL DEFAULT 0;

UPDATE users
SET federation_count = (
    SELECT COUNT(*)
    FROM user_federations uf
    WHERE uf.user_id = users.id
);

CREATE TRIGGER user_federations_count_ai
    AFTER INSERT
    ON user_federations
BEGIN
    UPDATE users
    SET federation_count = federation_count + 1
    WHERE id = NEW.user_id;
END;

CREATE TRIGGER user_federations_count_ad
    AFTER DELETE
    ON user_federations
BEGIN
    UPDATE users
    SET federation_count = CASE
        WHEN federation_count > 0 THEN federation_count - 1
        ELSE 0
        END
    WHERE id = OLD.user_id;
END;
