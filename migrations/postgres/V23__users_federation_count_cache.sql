ALTER TABLE users
    ADD COLUMN federation_count BIGINT NOT NULL DEFAULT 0;

UPDATE users u
SET federation_count = uf.cnt
FROM (
    SELECT user_id, COUNT(*)::BIGINT AS cnt
    FROM user_federations
    GROUP BY user_id
) uf
WHERE u.id = uf.user_id;

CREATE OR REPLACE FUNCTION sync_users_federation_count()
    RETURNS TRIGGER
    LANGUAGE plpgsql
AS
$$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE users
        SET federation_count = federation_count + 1
        WHERE id = NEW.user_id;
        RETURN NEW;
    END IF;

    IF TG_OP = 'DELETE' THEN
        UPDATE users
        SET federation_count = GREATEST(federation_count - 1, 0)
        WHERE id = OLD.user_id;
        RETURN OLD;
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_sync_users_federation_count
    AFTER INSERT OR DELETE OF user_id
    ON user_federations
    FOR EACH ROW
EXECUTE FUNCTION sync_users_federation_count();
