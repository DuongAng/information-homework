SELECT table_name
FROM information_schema.tables
WHERE table_schema = '...';


DO $$ 
DECLARE
    r RECORD;
BEGIN

    FOR r IN (SELECT table_name 
              FROM information_schema.tables
              WHERE table_schema = '...') LOOP

        EXECUTE 'DROP TABLE IF EXISTS ....' || r.table_name || ' CASCADE';
    END LOOP;
END $$;

-- Drop function
DO $$
DECLARE
    func_command TEXT;
BEGIN
    FOR func_command IN
        SELECT 'DROP FUNCTION ' || n.nspname || '.' || p.proname || '(' || pg_get_function_identity_arguments(p.oid) || ');'
        FROM pg_proc p
        JOIN pg_namespace n ON p.pronamespace = n.oid
        WHERE n.nspname NOT IN ('pg_catalog', 'information_schema') -- Loại trừ các hàm hệ thống
    LOOP
        EXECUTE func_command;
    END LOOP;
END;
$$;
