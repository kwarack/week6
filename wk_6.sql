--TASK 1
SELECT name
	FROM geometries
	WHERE ST_Equals(geom, ST_GeometryFromText('Point (0 0)', 4326));

SELECT * 
	FROM pgcensustract 
	WHERE ST_Intersects(
		geom, 
		ST_GeomFromText('POLYGON((406286 124178, 406286 125000, 416286 125000,
416286 124178, 406286 124178))',26985)
	);

--Q1
SELECT *
	FROM publicschools
	WHERE ST_Equals(
		geom, 
		ST_GeometryFromText('POINT(413797.2016872928 124604.24301644415)', 26985)
	);
	
--Q2
SELECT *
	FROM publicschools
	WHERE ST_DWithin(
		geom, 
		ST_GeometryFromText('POINT(413797 124604)', 26985),
		1000
	);
	
--Q3
SELECT *
	FROM pgcensustract
	WHERE ST_Contains(
		geom, 
		ST_GeometryFromText('POINT(413797 124604)', 26985)
	);
	
--Q4
SELECT *
	FROM pgroads
	WHERE ST_DWithin(
		geom, 
		ST_GeometryFromText('POINT(413797 124604)', 26985),
		5000
	);
	
--Q5
SELECT rds.fename, rds.fetype
	FROM pgroads AS rds
	JOIN publicschools AS schs
	ON ST_DWithin(
		rds.geom, 
		schs.geom,
		1000
	)
	WHERE schs.school_nam = 'Baden';

--Q6
SELECT tract.geodesc, COUNT(sch.*)
	FROM publicschools AS sch
	JOIN pgcensustract AS tract
	ON ST_Contains(
		tract.geom, 
		sch.geom
	)
	GROUP BY tract.geodesc;
	
--Q7
--road within the 100 meters of a school in tracts with population > 100
SELECT rds.fename, sch.school_nam, tract.geodesc
	FROM pgroads as rds
	JOIN pgcensustract AS tract
	ON ST_Contains(
		tract.geom, 
		rds.geom
	)
	JOIN publicschools AS sch
	ON ST_DWithin(
		rds.geom, 
		sch.geom,
		100
	)
	WHERE tract.population > 1000;