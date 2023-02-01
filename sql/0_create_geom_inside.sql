ALTER TABLE gpw
	ADD COLUMN geom_inside GEOMETRY
(POINT, 4326);

UPDATE gpw
SET geom_inside = ST_SetSRID(ST_Point(INSIDE_X, INSIDE_Y),4326);

CREATE INDEX gpw_inside_idx ON gpw
USING GIST (geom_inside);