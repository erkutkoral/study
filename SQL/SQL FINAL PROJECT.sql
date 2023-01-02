---- PROJECT ----
--- USING JOINS ---

--- Write and execute a SQL query to list the school names, community names and average attendance for communities with a hardship index of 98.---
SELECT S.NAME_OF_SCHOOL, CENSUS.COMMUNITY_AREA_NAME, S.AVERAGE_STUDENT_ATTENDANCE
FROM SCHOOLS AS S
LEFT OUTER JOIN CHICAGO_CENSUS_DATA AS CENSUS ON CENSUS.COMMUNITY_AREA_NUMBER = S.COMMUNITY_AREA_NUMBER
WHERE CENSUS.HARDSHIP_INDEX = '98';

---Write and execute a SQL query to list all crimes that took place at a school. Include case number, crime type and community name.---
SELECT CRIME.CASE_NUMBER, CRIME.PRIMARY_TYPE, CENSUS.COMMUNITY_AREA_NAME
FROM CHICAGO_CRIME_DATA AS CRIME
LEFT OUTER JOIN CHICAGO_CENSUS_DATA AS CENSUS ON CRIME.COMMUNITY_AREA_NUMBER = CENSUS.COMMUNITY_AREA_NUMBER
WHERE CRIME.LOCATION_DESCRIPTION LIKE 'SCHOOL%';

---Exercise 2: Creating a View---
--Write and execute a SQL statement to create a view showing the columns listed in the following table, with new column names as shown in the second column.---ü
CREATE VIEW SCHOOLINFO AS
SELECT NAME_OF_SCHOOL AS SCHOOL_NAME, SAFETY_ICON AS SAFETY_RATING, Family_Involvement_Icon AS Family_Rating, Environment_Icon AS Environment_Rating, Instruction_Icon AS Instruction_Rating, Leaders_Icon AS Leaders_Rating, Teachers_Icon AS Teachers_Rating
FROM SCHOOLS;
--- Write and execute a SQL statement that returns all of the columns from the view.---
SELECT * FROM SCHOOLINFO;
--- Write and execute a SQL statement that returns just the school name and leaders rating from the view.---
SELECT SCHOOL_NAME, LEADERS_RATING
FROM SCHOOLINFO;

---Exercise 3: Creating a Stored Procedure---
---- Write the structure of a query to create or replace a stored procedure called UPDATE_LEADERS_SCORE that takes a in_School_ID parameter as an integer and a in_Leader_Score parameter as an integer. Don’t forget to use the #SET TERMINATOR statement to use the @ for the CREATE statement terminator----
--#SET TERMINATOR @
CREATE OR REPLACE PROCEDURE UPDATE_LEADERS_SCORE (IN in_School_ID INTEGER, IN in_Leader_Score INTEGER)

	LANGUAGE SQL
	MODIFIES SQL DATA
	
	BEGIN
	
END
@

---Inside your stored procedure, write a SQL statement to update the Leaders_Score field in the CHICAGO_PUBLIC_SCHOOLS table for the school identified by in_School_ID to the value in the in_Leader_Score parameter.----
--#SET TERMINATOR @
CREATE OR REPLACE PROCEDURE UPDATE_LEADERS_SCORE (IN in_School_ID INTEGER, IN in_Leader_Score INTEGER)

	LANGUAGE SQL
	MODIFIES SQL DATA
	
	BEGIN
	
		UPDATE SCHOOLS
			SET LEADERS_SCORE = in_Leader_Score
			WHERE SCHOOL_ID = in_School_ID;
	
END
@

--- Inside your stored procedure, write a SQL IF statement to update the Leaders_Icon field in the CHICAGO_PUBLIC_SCHOOLS table for the school identified by in_School_ID using the following information.---
--#SET TERMINATOR @
CREATE OR REPLACE PROCEDURE UPDATE_LEADERS_SCORE (IN in_School_ID INTEGER, IN in_Leader_Score INTEGER)

	LANGUAGE SQL
	MODIFIES SQL DATA
	
	BEGIN
	
		UPDATE SCHOOLS
			SET LEADERS_SCORE = in_Leader_Score
			WHERE SCHOOL_ID = in_School_ID;
		
		IF in_Leader_Score > 0 AND in_Leader_Score < 20 THEN

		UPDATE SCHOOLS
			SET Leaders_Icon = 'Very weak'
			WHERE School_ID = in_School_ID;

		ELSEIF in_Leader_Score < 40 THEN

		UPDATE SCHOOLS
			SET Leaders_Icon = 'Weak'
			WHERE School_ID = in_School_ID;

		ELSEIF in_Leader_Score < 60 THEN
		
		UPDATE SCHOOLS
			SET Leaders_Icon = 'AVG'
			WHERE School_ID = in_School_ID;
			
		ELSEIF in_Leader_Score < 80 THEN
		
		UPDATE SCHOOLS
			SET Leaders_Icon = 'Strong'
			WHERE School_ID = in_School_ID;
		
		ELSEIF in_Leader_Score < 100 THEN

		UPDATE SCHOOLS
			SET Leaders_Icon = 'Very Strong'
			WHERE School_ID = in_School_ID;

		END IF;
	
END
@

---Write a query to call the stored procedure, passing a valid school ID and a leader score of 50, to check that the procedure works as expected.---
CALL UPDATE_LEADERS_SCORE(400018, 50);

---Update your stored procedure definition. Add a generic ELSE clause to the IF statement that rolls back the current work if the score did not fit any of the preceding categories---
--#SET TERMINATOR @
CREATE OR REPLACE PROCEDURE UPDATE_LEADERS_SCORE (IN in_School_ID INTEGER, IN in_Leader_Score INTEGER)

	LANGUAGE SQL
	MODIFIES SQL DATA
	
	BEGIN
	
		UPDATE SCHOOLS
			SET LEADERS_SCORE = in_Leader_Score
			WHERE SCHOOL_ID = in_School_ID;
		
		IF in_Leader_Score > 0 AND in_Leader_Score < 20 THEN

		UPDATE SCHOOLS
			SET Leaders_Icon = 'Very weak'
			WHERE School_ID = in_School_ID;

		ELSEIF in_Leader_Score < 40 THEN

		UPDATE SCHOOLS
			SET Leaders_Icon = 'Weak'
			WHERE School_ID = in_School_ID;

		ELSEIF in_Leader_Score < 60 THEN
		
		UPDATE SCHOOLS
			SET Leaders_Icon = 'AVG'
			WHERE School_ID = in_School_ID;
			
		ELSEIF in_Leader_Score < 80 THEN
		
		UPDATE SCHOOLS
			SET Leaders_Icon = 'Strong'
			WHERE School_ID = in_School_ID;
		
		ELSEIF in_Leader_Score < 100 THEN

		UPDATE SCHOOLS
			SET Leaders_Icon = 'Very Strong'
			WHERE School_ID = in_School_ID;
		ELSE
			ROLLBACK;
		
		END IF;
	
END
@

---Update your stored procedure definition again. Add a statement to commit the current unit of work at the end of the procedure.---
--#SET TERMINATOR @
CREATE OR REPLACE PROCEDURE UPDATE_LEADERS_SCORE (IN in_School_ID INTEGER, IN in_Leader_Score INTEGER)

	LANGUAGE SQL
	MODIFIES SQL DATA
	
	BEGIN
	
		UPDATE SCHOOLS
			SET LEADERS_SCORE = in_Leader_Score
			WHERE SCHOOL_ID = in_School_ID;
		
		IF in_Leader_Score > 0 AND in_Leader_Score < 20 THEN

		UPDATE SCHOOLS
			SET Leaders_Icon = 'Very weak'
			WHERE School_ID = in_School_ID;

		ELSEIF in_Leader_Score < 40 THEN

		UPDATE SCHOOLS
			SET Leaders_Icon = 'Weak'
			WHERE School_ID = in_School_ID;

		ELSEIF in_Leader_Score < 60 THEN
		
		UPDATE SCHOOLS
			SET Leaders_Icon = 'AVG'
			WHERE School_ID = in_School_ID;
			
		ELSEIF in_Leader_Score < 80 THEN
		
		UPDATE SCHOOLS
			SET Leaders_Icon = 'Strong'
			WHERE School_ID = in_School_ID;
		
		ELSEIF in_Leader_Score < 100 THEN

		UPDATE SCHOOLS
			SET Leaders_Icon = 'Very Strong'
			WHERE School_ID = in_School_ID;
		ELSE
			ROLLBACK;
		
		END IF;
		
		COMMIT;
	
END
@

---Write and run one query to check that the updated stored procedure works as expected when you use a valid score of 38.---
CALL UPDATE_LEADERS_SCORE(400018, 38);

---Write and run another query to check that the updated stored procedure works as expected when you use an invalid score of 101.---
CALL UPDATE_LEADERS_SCORE(400018, 101);

