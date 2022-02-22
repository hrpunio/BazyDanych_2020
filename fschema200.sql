--
-- Flight delays database schema
--
DROP TABLE IF EXISTS FLIGHT;
DROP TABLE IF EXISTS DATE;
DROP TABLE IF EXISTS LINE;
DROP TABLE IF EXISTS ORI;
DROP TABLE IF EXISTS DEST;

CREATE TABLE FLIGHT (
   FID INTEGER,
   dateId CHAR(10),
   oriId  CHAR(5),
   destId CHAR(5),
   lineId VARCHAR(6),
   ArrDel INTEGER,
   DepDel INTEGER,
   primary key (FID));
  
CREATE TABLE DATE (
   DID CHAR(10),
   Year INTEGER,
   Quarter INTEGER,
   Month INTEGER,
   DayofMonth INTEGER,
   DayOfWeek INTEGER,
   FlightDate CHAR(10),
   primary key (DID));

CREATE TABLE LINE (
   ID VARCHAR(6),
   Name CHAR(20),
   primary key (ID));

CREATE TABLE ORI (
   AID CHAR(5),
   Code CHAR(3),
   Name VARCHAR,
   State CHAR(2),
   primary key (AID));

CREATE TABLE DEST (
   AID CHAR(5),
   Code CHAR(3),
   Name VARCHAR,
   State CHAR(2),
   primary key (AID));
