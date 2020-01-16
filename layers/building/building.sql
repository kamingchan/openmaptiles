CREATE OR REPLACE FUNCTION layer_building(bbox geometry, zoom_level int)
RETURNS TABLE(geometry geometry, osm_id bigint, name text, building text) AS $$
    SELECT geometry, osm_id, name, building
    FROM (
        -- etldoc: osm_building_polygon_gen1 -> layer_building:z13
        SELECT
            osm_id, geometry, name, building
        FROM osm_building_polygon_gen1
        WHERE zoom_level = 13 AND geometry && bbox
        UNION ALL
        -- etldoc: osm_building_polygon -> layer_building:z14_
        SELECT
           osm_id, geometry, name, building
        FROM osm_building_polygon
        WHERE zoom_level = 14 AND geometry && bbox
    ) AS zoom_levels;
$$ LANGUAGE SQL IMMUTABLE;
