USE Formula1;

START TRANSACTION;
CREATE TABLE IF NOT EXISTS circuits (
	circuit_id INTEGER,
	circuit_ref VARCHAR(20),
	circuit_name VARCHAR(42),
	location VARCHAR(24),
	country VARCHAR(15),
	lat DECIMAL(8, 6),
	lng DECIMAL(9, 6),
    alt INTEGER,
	url VARCHAR(75),
	PRIMARY KEY(circuit_id)
);
CREATE TABLE IF NOT EXISTS races (
	race_id INTEGER,
	race_year INTEGER,
	race_round INTEGER,
	circuit_id INTEGER,
	race_name VARCHAR(35),
	race_date DATE,
	race_time TIME,
	url	VARCHAR(75),
	PRIMARY KEY(race_id),
	FOREIGN KEY(circuit_id) REFERENCES circuits(circuit_id)
);
CREATE TABLE IF NOT EXISTS drivers (
	driver_id INTEGER,
	driver_ref VARCHAR(25),
	num_number INTEGER,
	driver_code VARCHAR(3),
	first_name VARCHAR(20),
	surname VARCHAR(25),
	dob DATE,
	nationality VARCHAR(20),
	url VARCHAR(75),
	PRIMARY KEY(driver_id)
);
CREATE TABLE IF NOT EXISTS driver_standings (
	driver_standings_id INTEGER,
	race_id INTEGER,
	driver_id INTEGER,
	points INTEGER,
	driver_position INTEGER,
	position_text VARCHAR(3),
	wins INTEGER,
	PRIMARY KEY(driver_standings_id),
	FOREIGN KEY(race_id) REFERENCES races(race_id),
	FOREIGN KEY(driver_id) REFERENCES drivers(driver_id)
);
CREATE TABLE IF NOT EXISTS constructors (
	constructor_id INTEGER,
	constructor_ref VARCHAR(25),
	constructor_name VARCHAR(28),
	nationality VARCHAR(22),
	url VARCHAR(75),	
    PRIMARY KEY(constructor_id)
);
CREATE TABLE IF NOT EXISTS results (
	result_id INTEGER,
	race_id INTEGER,
	driver_id INTEGER,
	constructor_id INTEGER,
	num_number INTEGER,
	grid INTEGER,
	results_position INTEGER,
	position_text VARCHAR(3),
	position_order INTEGER,
	points INTEGER,
	laps INTEGER,
	results_time DECIMAL,
	milliseconds INTEGER,
	fastestLap INTEGER,
	ranking	INTEGER,
	fastest_lap_time DECIMAL,
	fastest_lap_speed DECIMAL,
	status_id INTEGER,
	FOREIGN KEY(race_id) REFERENCES races(race_id),
	FOREIGN KEY(driver_id) REFERENCES drivers(driver_id),
	FOREIGN KEY(constructor_id) REFERENCES constructors(constructor_id)
);
CREATE TABLE IF NOT EXISTS constructor_standings (
	constructor_standings_id INTEGER,
	race_id INTEGER,
	constructor_id INTEGER,
	points INTEGER,
	Constructor_position INTEGER,
	position_text VARCHAR(3),
	wins INTEGER,
	PRIMARY KEY(constructor_standings_id),
	FOREIGN KEY(race_id) REFERENCES races(race_id),
	FOREIGN KEY(constructor_id) REFERENCES constructors(constructor_id)
);
CREATE TABLE IF NOT EXISTS constructor_results (
	constructor_results_id INTEGER,
	race_id INTEGER,
	constructor_id INTEGER,
	points INTEGER,
	constructor_status DECIMAL,
	PRIMARY KEY(constructor_results_id),
	FOREIGN KEY(race_id) REFERENCES races(race_id),
	FOREIGN KEY(constructor_id) REFERENCES constructors(constructor_id)
);
CREATE TABLE IF NOT EXISTS laptimes (
	race_id INTEGER,
	driver_id INTEGER,
	lap INTEGER,
	laptime_position INTEGER,
	lap_time DECIMAL,
	milliseconds INTEGER,
	FOREIGN KEY(race_id) REFERENCES races(race_id),
	FOREIGN KEY(driver_id) REFERENCES drivers(driver_id)
);
CREATE TABLE IF NOT EXISTS pitstops (
	race_id INTEGER,
	driver_id INTEGER,
	pitstop INTEGER,
	lap INTEGER,
	lap_time DECIMAL,
	duration DECIMAL,
	milliseconds INTEGER,
	FOREIGN KEY(race_id) REFERENCES races(race_id),
	FOREIGN KEY(driver_id) REFERENCES drivers(driver_id)
);
CREATE TABLE IF NOT EXISTS qualifying (
	qualify_id INTEGER,
	race_id INTEGER,
	driver_id INTEGER,
	constructor_id INTEGER,
	num_number INTEGER,
	qualifying_position INTEGER,
	q1 DECIMAL,
	q2 DECIMAL,
	q3 DECIMAL,
	PRIMARY KEY(qualify_id),
	FOREIGN KEY(race_id) REFERENCES races(race_id),
	FOREIGN KEY(driver_id) REFERENCES drivers(driver_id),
	FOREIGN KEY(constructor_id) REFERENCES constructors(constructor_id)
);
CREATE TABLE IF NOT EXISTS seasons (
	yr INTEGER,
	url VARCHAR(75)
);
CREATE TABLE IF NOT EXISTS current_status (
	status_id INTEGER,
	current_status VARCHAR(20),
	PRIMARY KEY(status_id)
);
COMMIT;