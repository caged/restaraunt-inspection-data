SELECT DISTINCT ON (rest_id) rest_id,
  name,
  date,
  score,
  st_setsrid(st_makepoint(lon, lat), 4326) AS geom,
  pkey
FROM inspections
WHERE score > 0
ORDER BY rest_id, date desc;
