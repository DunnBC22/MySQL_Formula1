ALTER TABLE constructor_standings ADD COLUMN extra VARCHAR(4);
ALTER TABLE constructors ADD COLUMN extra VARCHAR(4);
ALTER TABLE constructor_results MODIFY COLUMN constructor_status VARCHAR(5);

# before the data is imported
ALTER TABLE drivers MODIFY COLUMN dob VARCHAR(15);
ALTER TABLE drivers MODIFY COLUMN num_number VARCHAR(2);

# after the data is imported - still need to work on these
ALTER TABLE drivers MODIFY COLUMN dob date;
ALTER TABLE drivers MODIFY COLUMN num_number INTEGER; # use a CTE - IF statement

ALTER TABLE Formula1.races MODIFY COLUMN race_time TIME DEFAULT NULL;

ALTER TABLE Formula1.laptimes DROP COLUMN lap_time;

ALTER TABLE Formula1.pitstops MODIFY COLUMN lap_time TIME;
ALTER TABLE Formula1.pitstops RENAME COLUMN lap_time TO pitstop_time;

ALTER TABLE Formula1.results DROP COLUMN results_time;

ALTER TABLE Formula1.results MODIFY COLUMN num_number DECIMAL(10,3) DEFAULT NULL;
ALTER TABLE Formula1.results MODIFY COLUMN results_position DECIMAL(10,3) DEFAULT NULL;
ALTER TABLE Formula1.results MODIFY COLUMN points DECIMAL(10,3) DEFAULT NULL;
ALTER TABLE Formula1.results MODIFY COLUMN milliseconds DECIMAL(10,3) DEFAULT NULL;
ALTER TABLE Formula1.results MODIFY COLUMN fastestLap DECIMAL(10,3) DEFAULT NULL;
ALTER TABLE Formula1.results MODIFY COLUMN ranking DECIMAL(10,3) DEFAULT NULL;
ALTER TABLE Formula1.results MODIFY COLUMN fastest_lap_time DECIMAL(10,3) DEFAULT NULL;

ALTER TABLE Formula1.qualifying MODIFY COLUMN q1 DECIMAL(10,3);
ALTER TABLE Formula1.qualifying MODIFY COLUMN q2 DECIMAL(10,3);
ALTER TABLE Formula1.qualifying MODIFY COLUMN q3 DECIMAL(10,3);


ALTER TABLE Formula1.results MODIFY COLUMN num_number INTEGER DEFAULT NULL;
ALTER TABLE Formula1.results MODIFY COLUMN results_position INTEGER DEFAULT NULL;
ALTER TABLE Formula1.results MODIFY COLUMN points INTEGER DEFAULT NULL;
ALTER TABLE Formula1.results MODIFY COLUMN milliseconds INTEGER DEFAULT NULL;
ALTER TABLE Formula1.results MODIFY COLUMN fastestLap INTEGER DEFAULT NULL;
ALTER TABLE Formula1.results MODIFY COLUMN ranking INTEGER DEFAULT NULL;
ALTER TABLE Formula1.results MODIFY COLUMN fastest_lap_time DECIMAL(10,3) DEFAULT NULL;
ALTER TABLE Formula1.results MODIFY COLUMN fastest_lap_speed DECIMAL(10,3) DEFAULT NULL;