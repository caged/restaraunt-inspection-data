drop table if exists latest_inspections;

create table latest_inspections AS
  (SELECT DISTINCT ON (rest_id) rest_id, date, name,
                                               score,
                                               pkey,
                                               type,
                                               lat,
                                               lon,
                                               st_setsrid(st_makepoint(lon, lat), 4326) AS geom
   FROM inspections
   WHERE score > 0
     AND lat IS NOT NULL
     AND lat != 0
     AND lon IS NOT NULL
     AND lon != 0
   ORDER BY rest_id, date DESC);

alter table latest_inspections
 alter column geom type geometry(Point, 4326)
 using st_setsrid(geom,4326)
