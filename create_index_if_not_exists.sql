CREATE OR REPLACE FUNCTION public.create_index_if_not_exists(index_name text, table_name text, column_expression text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- Check if the index already exists
    IF EXISTS (
        SELECT 1
        FROM pg_indexes
        WHERE tablename = split_part(table_name, '.', 2)
          and schemaname = split_part(table_name, '.', 1)
       		AND indexdef like '%' || column_expression || '%'
    ) THEN
        RAISE NOTICE 'Index already exists';
    ELSE
        -- Create the index if it doesn't exist
        EXECUTE format('CREATE INDEX %I ON %I %s', index_name, table_name, column_expression);
        RAISE NOTICE 'Index % created.', index_name;
    END IF;
END;
$function$
;

-- How to use:
-- SELECT public.create_index_if_not_exists(
--  'name_of_index',
--  'schema.table_name',
--  'column_expression_for_index'
-- );
