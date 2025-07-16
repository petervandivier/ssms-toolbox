/*
schema_object_name
*/

    concat(
        object_schema_name([object_id]),
        N'.',
        object_name([object_id])
    ) as schema_object_name,
