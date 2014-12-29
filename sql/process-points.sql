drop table if exists inspection_point_buffers;

-- Group identical overlapping points and count how many occupy
-- the space.
create temporary table inspection_overlappoing_points as
  select a.geom as geom,
        count(*)
  from latest_inspections a,
       latest_inspections b
  where st_equals(a.geom, b.geom)
        and a.rest_id <> b.rest_id
  group by 1
  order by 2 desc;

-- Using the number of points occupying a space, create a buffer region which
-- we'll use later to disperse points in. More points equals a larger buffer zone.
create temporary table inspection_point_buffers as
  select st_buffer(geom, 0.000003 * count, 'quad_segs=8') as geom2
  from inspection_overlappoing_points;

-- Randomly place points that occupy the same space using our buffer zones we
-- created earlier.
update latest_inspections set
  geom = randompoint(geom2)
  from inspection_point_buffers buffers
  where st_contains(geom2, geom);
