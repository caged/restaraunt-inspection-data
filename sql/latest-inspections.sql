drop table if exists latest_inspections;

create table latest_inspections as
  (select distinct on (inspections.rest_id) inspections.rest_id, inspections.date, id, name,
                                               score,
                                               pkey,
                                               type,
                                               lat,
                                               lon,
                                               case
                                                  when score < 70 then 'd'
                                                  when score >= 70 and score < 80 then 'c'
                                                  when score >= 80 and score < 90 then 'b'
                                                  else 'a'
                                                end as grade,
                                               (select string_agg(law, ',') as laws from violations where inspection_id = id and law !~ '^99|98' group by inspection_id) as laws,
                                               st_setsrid(st_makepoint(lon, lat), 4326) as geom
   from inspections
   where score > 0
     and lat is not null
     and lat != 0
     and lon is not null
     and lon != 0
   order by inspections.rest_id, inspections.date desc);

alter table latest_inspections
 alter column geom type geometry(Point, 4326)
 using st_setsrid(geom,4326)
