CREATE OR REPLACE FUNCTION RandomPoint (
                geom Geometry,
                maxiter INTEGER DEFAULT 1000
        )
        RETURNS Geometry
        AS $$
DECLARE
        i INTEGER := 0;
        x0 DOUBLE PRECISION;
        dx DOUBLE PRECISION;
        y0 DOUBLE PRECISION;
        dy DOUBLE PRECISION;
        xp DOUBLE PRECISION;
        yp DOUBLE PRECISION;
        rpoint Geometry;
BEGIN
        -- find envelope
        x0 = ST_XMin(geom);
        dx = (ST_XMax(geom) - x0);
        y0 = ST_YMin(geom);
        dy = (ST_YMax(geom) - y0);

        WHILE i < maxiter LOOP
                i = i + 1;
                xp = x0 + dx * random();
                yp = y0 + dy * random();
                rpoint = ST_SetSRID( ST_MakePoint( xp, yp ), ST_SRID(geom) );
                EXIT WHEN ST_Within( rpoint, geom );
        END LOOP;

        IF i >= maxiter THEN
                RAISE EXCEPTION 'RandomPoint: number of interations exceeded %', maxiter;
        END IF;

        RETURN rpoint;
END;
$$ LANGUAGE plpgsql;
