-- See: https://trac.osgeo.org/postgis/wiki/UserWikiRandomPoint
 --
 -- Return 10 random points/rows
 -- SELECT ST_AsText(RandomPointsInPolygon('POLYGON ((10 20, 30 60, 50 20, 10 20))', 10));
 -- Or 10 random points as a single MultiPoint
 -- SELECT ST_AsText(ST_Union(geom))
 -- FROM RandomPointsInPolygon('POLYGON ((10 20, 30 60, 50 20, 10 20))', 10) AS geom
 -- CREATE TABLE india_random_points
 -- (
 --   gid serial NOT NULL,
 --   CONSTRAINT india_random_points_pkey PRIMARY KEY (gid)
 -- );
 -- SELECT AddGeometryColumn('india_random_points', 'geom', 4326, 'POINT', 2);
 -- -- Populate table with 10000 random points within India
 -- INSERT INTO india_random_points(geom)
 -- SELECT RandomPointsInPolygon(geom, 10000)
 -- FROM world WHERE name='INDIA';

CREATE OR REPLACE FUNCTION randompointsinpolygon(geom geometry, num_points integer) RETURNS
SETOF geometry AS $BODY$DECLARE target_proportion numeric; n_ret integer := 0; loops integer := 0; x_min float8; y_min float8; x_max float8; y_max float8; srid integer; rpoint geometry; BEGIN -- Get envelope and SRID of source polygon

SELECT st_xmin(geom),
       st_ymin(geom),
       st_xmax(geom),
       st_ymax(geom),
       st_srid(geom) INTO x_min,
                          y_min,
                          x_max,
                          y_max,
                          srid; -- Get the area proportion of envelope size to determine if a
 -- result can be returned in a reasonable amount of time

SELECT st_area(geom)/st_area(st_envelope(geom)) INTO target_proportion; RAISE debug 'geom: SRID %, NumGeometries %, NPoints %, area proportion within envelope %',
                                                                                    srid,
                                                                                    st_numgeometries(geom),
                                                                                    st_npoints(geom),
                                                                                    round(100.0*target_proportion, 2) || '%'; IF target_proportion < 0.0001 THEN RAISE exception 'Target area proportion of geometry is too low (%)',
                                                                                                                                                                                 100.0*target_proportion || '%'; END IF; RAISE debug 'bounds: % % % %',
x_min,
y_min,
x_max,
y_max; while n_ret < num_points LOOP loops := loops + 1;
SELECT st_setsrid(st_makepoint(random()*(x_max - x_min) + x_min, random()*(y_max - y_min) + y_min), srid) INTO rpoint; IF st_contains(geom, rpoint) THEN n_ret := n_ret + 1; RETURN NEXT rpoint; END IF; END LOOP; RAISE debug 'determined in % loops (% efficiency)',
loops,
round(100.0*num_points/loops, 2) || '%'; END$BODY$ LANGUAGE plpgsql VOLATILE cost 100 ROWS 1000;
