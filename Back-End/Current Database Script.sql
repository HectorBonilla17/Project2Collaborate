USE P2C; /* Selects the database you want to use */





/*
SQL commands to delete the tables (and their data) from the database:

DROP TABLE TeamMembers;
DROP TABLE Grades;
DROP TABLE Submissions;
DROP TABLE Assignments;
DROP TABLE Goals;
DROP TABLE Teams;
DROP TABLE Courses;
DROP TABLE Users;
DROP TABLE Faculty;
DROP TABLE Students;
*/





/*
STUDENTS TABLE:
- Email must be unique.
- StudentPassword is encrypted via hashing.
*/
CREATE TABLE Students (
StudentID INT,
FirstName VARCHAR(64) NOT NULL,
MiddleName VARCHAR(64),
LastName VARCHAR(64) NOT NULL,
Email VARCHAR(100) NOT NULL UNIQUE,
PhoneNumber VARCHAR(32),
StudentPassword VARCHAR(64) NOT NULL,
CONSTRAINT PK_Students PRIMARY KEY (StudentID)
);

/*
FACULTY TABLE:
- Email must be unique.
- FacultyPassword is encrypted via hashing.

- JobTitle example: 'Professor'.
*/
CREATE TABLE Faculty (
FacultyID INT,
FirstName VARCHAR(64) NOT NULL,
MiddleName VARCHAR(64),
LastName VARCHAR(64) NOT NULL,
Email VARCHAR(100) NOT NULL UNIQUE,
PhoneNumber VARCHAR(32),
FacultyPassword VARCHAR(64) NOT NULL,
JobTitle VARCHAR(100),
CONSTRAINT PK_Faculty PRIMARY KEY (FacultyID)
);

/*
USERS TABLE:
- The Users table's UserID will only be used with the Submissions table.
	- Although the Users table is not connected to the Students table or the Faculty table, all values in the Users table's UserID column will already exist in either the Students table's StudentID column or the Faculty table's FacultyID column.
*/
CREATE TABLE Users (
UserID INT,
UserType CHAR(7) NOT NULL,
CONSTRAINT PK_Users PRIMARY KEY (UserID)
);

/*
COURSES TABLE:
- CourseCode example: 'CSC 394'.
- CourseYear examples: '2020 - 2021'.
- CourseQuarter values: 'Winter', 'Spring', 'Summer', 'Autumn'.

- Values in the CourseCreatedBy column will be the current user's ID.
	- These values must already exist in the Faculty table's FacultyID column.
	- Basically, only Faculty should be able to add courses.
*/
CREATE TABLE Courses (
CourseID INT,
CourseName VARCHAR(200) NOT NULL,
CourseCode VARCHAR(16) NOT NULL,
CourseSectionNumber VARCHAR(8) NOT NULL,
CourseYear VARCHAR(32) NOT NULL,
CourseQuarter VARCHAR(32) NOT NULL,
CourseCreatedBy INT,
CONSTRAINT PK_Courses PRIMARY KEY (CourseID),
CONSTRAINT FK_Faculty_Courses FOREIGN KEY (CourseCreatedBy) REFERENCES Faculty(FacultyID)
);

/*
TEAMS TABLE
- Values in the TeamCreatedBy column will be the current user's ID.
	- These values must already exist in the Courses table's CourseCreatedBy column.
	- Basically, only the creator of a course should be able to add teams to the course.
*/
CREATE TABLE Teams (
TeamID INT,
TeamName VARCHAR(64) NOT NULL,
CourseID INT,
TeamCreatedBy INT NOT NULL,
CONSTRAINT PK_Teams PRIMARY KEY (TeamID),
CONSTRAINT FK_Courses_Teams FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

/*
GOALS TABLE:
- GoalStatus values: 'DONE', 'NOT DONE'.
- GoalOwners: Team members who are responsible for completing the goal. In other words, team members who are assigned the goal.
- GoalStage: Which stage of the progress bar the goal is in. Values: integers between 1 and 5.
- TeamID: The team that created the goal. GoalOwners must be in this team.

- If StartDate, StartTime, EndDate, or EndTime are empty, use NULL.
*/
CREATE TABLE Goals (
GoalID INT,
GoalName VARCHAR(200) NOT NULL,
GoalDescription VARCHAR(4096),
StartDate DATE,
StartTime TIME(0),
EndDate DATE,
EndTime TIME(0),
GoalStatus VARCHAR(16) NOT NULL,
GoalOwners VARCHAR(400),
GoalStage INT NOT NULL,
TeamID INT,
CONSTRAINT PK_Goals PRIMARY KEY (GoalID),
CONSTRAINT FK_Teams_Goals FOREIGN KEY (TeamID) REFERENCES Teams(TeamID)
);

/*
ASSIGNMENTS TABLE
- Values in the AssignmentCreatedBy column will be the current user's ID.
	- These values must already exist in the Courses table's CourseCreatedBy column.
	- Basically, only the creator of a course should be able to add assignments to the course.

- If StartDate, StartTime, DueDate, or DueTime are empty, use NULL.
*/
CREATE TABLE Assignments (
AssignmentID INT,
AssignmentName VARCHAR(200) NOT NULL,
StartDate DATE,
StartTime TIME(0),
DueDate DATE,
DueTime TIME(0),
CourseID INT,
AssignmentCreatedBy INT NOT NULL,
CONSTRAINT PK_Assignments PRIMARY KEY (AssignmentID),
CONSTRAINT FK_Courses_Assignments FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

/*
SUBMISSIONS TABLE
- Values in the SubmittedByUser column will be the current user's ID.
	- These values must already exist in the Users table's UserID column.
	- Basically, any user in a course should be able to add submissions to assignments in that course.
*/
CREATE TABLE Submissions (
SubmissionID INT,
SubmissionDate DATE DEFAULT CAST(GETDATE() AS DATE),
SubmissionTime TIME(0) DEFAULT CAST(CURRENT_TIMESTAMP AS TIME(0)),
SubmissionComment VARCHAR(4096),
AssignmentID INT,
SubmittedByUser INT,
CONSTRAINT PK_Submissions PRIMARY KEY (SubmissionID),
CONSTRAINT FK_Assignments_Submissions FOREIGN KEY (AssignmentID) REFERENCES Assignments(AssignmentID),
CONSTRAINT FK_Users_Submissions FOREIGN KEY (SubmittedByUser) REFERENCES Users(UserID)
);

/*
GRADES TABLE
- Only the Faculty who created an assignment should be able to add grades for that assignment.
*/
CREATE TABLE Grades (
GradeID INT,
PointsEarned DECIMAL(6,2) NOT NULL,
TotalPoints DECIMAL(6,2) NOT NULL,
GradePercentage DECIMAL(5,2),
LetterGrade VARCHAR(4),
FacultyFeedback VARCHAR(4096),
DatePosted DATE DEFAULT CAST(GETDATE() AS DATE),
AssignmentID INT,
StudentID INT,
CONSTRAINT PK_Grades PRIMARY KEY (GradeID),
CONSTRAINT FK_Assignments_Grades FOREIGN KEY (AssignmentID) REFERENCES Assignments(AssignmentID),
CONSTRAINT FK_Students_Grades FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);

/*
TEAM_MEMBERS TABLE
*/
CREATE TABLE TeamMembers (
TeamID INT,
StudentID INT,
CONSTRAINT PK_TeamMembers PRIMARY KEY (TeamID, StudentID),
CONSTRAINT FK_Teams_TeamMembers FOREIGN KEY (TeamID) REFERENCES Teams(TeamID),
CONSTRAINT FK_Students_TeamMembers FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);





/* SQL queries that let you see the data stored in the tables */
SELECT * FROM Students;
SELECT * FROM Faculty;
SELECT * FROM Users;
SELECT * FROM Courses;
SELECT * FROM Teams;
SELECT * FROM Goals;
SELECT * FROM Assignments;
SELECT * FROM Submissions;
SELECT * FROM Grades;
SELECT * FROM TeamMembers;



/* SQL queries that deletes all of the data in the tables

TRUNCATE TABLE TeamMembers;
TRUNCATE TABLE Grades;
TRUNCATE TABLE Submissions;
TRUNCATE TABLE Assignments;
TRUNCATE TABLE Goals;
TRUNCATE TABLE Teams;
TRUNCATE TABLE Courses;
TRUNCATE TABLE Users;
TRUNCATE TABLE Faculty;
TRUNCATE TABLE Students;
*/





/*
STUDENTS TABLE:
	- INSERT INTO Students VALUES(StudentID, FirstName, MiddleName, LastName, Email, PhoneNumber, StudentPassword);
*/
INSERT INTO Students VALUES((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Krishan', ' ', 'Patel', 'krishanpatel@mail.com', '123-456-7890', HASHBYTES('SHA2_256', 'Admin123'));
INSERT INTO Students VALUES((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Zining', ' ', 'Wang', 'ZiningW@mail.com', '826-563-8563', HASHBYTES('SHA2_256', 'Password123'));
INSERT INTO Students VALUES((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Hector', ' ', 'Bonilla', 'hbonilla@mail.com', '193-183-2357', HASHBYTES('SHA2_256', 'Password123'));
INSERT INTO Students VALUES((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Tom', ' ', 'Zdanowski', 'tomZ@mail.com', '963-134-7845', HASHBYTES('SHA2_256', 'Password123'));
INSERT INTO Students VALUES((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Ahad', ' ', 'Ansari', 'AhadAnsari@mail.com', '194-732-6742', HASHBYTES('SHA2_256', 'Password123'));
INSERT INTO Students VALUES((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Mohamed', ' ', 'Elkarem', 'moe@mail.com', '846-264-5836', HASHBYTES('SHA2_256', 'Password123'));
INSERT INTO Students VALUES((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Yousuf', ' ', 'Kazmi', 'yousuf@mail.com', '685-745-9384', HASHBYTES('SHA2_256', 'Password123'));
INSERT INTO Students VALUES((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Larry', 'Larry', 'Sanders', 'larrylarry@mail.com', '728-173-2731', HASHBYTES('SHA2_256', 'JQDr74EN'));
INSERT INTO Students VALUES((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Barry', 'M.', 'Jackson', 'barryJackson@mail.com', '693-684-8026', HASHBYTES('SHA2_256', 'vP3S7em4'));
INSERT INTO Students VALUES((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Gary', ' ', 'Marks', 'marksGary@mail.com', '675-193-5724', HASHBYTES('SHA2_256', 'UPv8jwfU'));



/*
FACULTY TABLE:
	- INSERT INTO Faculty VALUES(FacultyID, FirstName, MiddleName, LastName, Email, PhoneNumber, FacultyPassword, JobTitle);
*/
INSERT INTO Faculty VALUES((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Thomas', ' ', 'Muscarello', 'tmuscarello@mail.com', '987-654-3210', HASHBYTES('SHA2_256', 'Admin123'), 'Professor');
INSERT INTO Faculty VALUES((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Tiger', 'W.', 'Hancock', 'tigerhancock@mail.com', '754-397-0006', HASHBYTES('SHA2_256', 'Password123'), 'Professor');
INSERT INTO Faculty VALUES((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Reese', ' ', 'Harvey', 'rHarvey@mail.com', '315-114-2352', HASHBYTES('SHA2_256', 'Password123'), ' ');
INSERT INTO Faculty VALUES((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Cyrus', 'R.', 'Lamb', 'Cyrus@mail.com', '930-889-9376', HASHBYTES('SHA2_256', 'Xemu8nfP'), 'Professor');
INSERT INTO Faculty VALUES((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Owen', ' ', 'Emerson', 'OwEm@mail.com', '124-737-8614', HASHBYTES('SHA2_256', 'FDVbeh8t'), 'Assistant Professor');
INSERT INTO Faculty VALUES((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Madeline', ' ', 'Osborne', 'MadelineOsborne@mail.com', '851-485-4471', HASHBYTES('SHA2_256', 'Rjf7RFCh'), 'Associate Professor');
INSERT INTO Faculty VALUES((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Quynn', ' ', 'Oneil', 'Oneil@mail.com', '521-572-2764', HASHBYTES('SHA2_256', 'Em9ZByLx'), 'Professor');
INSERT INTO Faculty VALUES((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Idona', ' ', 'Martinez', 'martinez@mail.com', '703-419-5149', HASHBYTES('SHA2_256', 'u88wSVUZ'), ' ');
INSERT INTO Faculty VALUES((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Gannon', ' ', 'Rivas', 'grivas@mail.com', '352-934-3366', HASHBYTES('SHA2_256', 'QN5RkPJg'), ' ');
INSERT INTO Faculty VALUES((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Elliott', 'Joseph', 'Downs', 'EJDowns@mail.com', '589-727-7780', HASHBYTES('SHA2_256', 'Y7RjV9M9'), 'Assistant Professor');



/*
USERS TABLE:
	- INSERT INTO Users VALUES (UserID, UserType);
*/
INSERT INTO Users VALUES ('1186947', 'Student');
INSERT INTO Users VALUES ('1297220', 'Student');
INSERT INTO Users VALUES ('1352061', 'Student');
INSERT INTO Users VALUES ('1783033', 'Student');
INSERT INTO Users VALUES ('1797533', 'Student');
INSERT INTO Users VALUES ('2238456', 'Student');
INSERT INTO Users VALUES ('3134651', 'Student');
INSERT INTO Users VALUES ('8061639', 'Student');
INSERT INTO Users VALUES ('8174384', 'Student');
INSERT INTO Users VALUES ('8962503', 'Student');
INSERT INTO Users VALUES ('1106314', 'Faculty');
INSERT INTO Users VALUES ('1212517', 'Faculty');
INSERT INTO Users VALUES ('3872070', 'Faculty');
INSERT INTO Users VALUES ('3900900', 'Faculty');
INSERT INTO Users VALUES ('4706150', 'Faculty');
INSERT INTO Users VALUES ('6044655', 'Faculty');
INSERT INTO Users VALUES ('7375767', 'Faculty');
INSERT INTO Users VALUES ('7442154', 'Faculty');
INSERT INTO Users VALUES ('8496808', 'Faculty');
INSERT INTO Users VALUES ('9514907', 'Faculty');



/*
COURSES TABLE:
	- INSERT INTO Courses VALUES (CourseID, CourseName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter, CourseCreatedBy);
*/
INSERT INTO Courses VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Software Projects', 'CSC 394', (ABS(CHECKSUM(NEWID())) % 900) + 100, '2020 - 2021', 'Winter', (SELECT FacultyID FROM Faculty WHERE Email = 'tmuscarello@mail.com'));
INSERT INTO Courses VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Database Systems', 'CSC 355', (ABS(CHECKSUM(NEWID())) % 900) + 100, '2020 - 2021', 'Autumn', (SELECT FacultyID FROM Faculty WHERE Email = 'rHarvey@mail.com'));
INSERT INTO Courses VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Big Data', 'CSC 555', (ABS(CHECKSUM(NEWID())) % 900) + 100, '2019 - 2020', 'Summer', (SELECT FacultyID FROM Faculty WHERE Email = 'tigerhancock@mail.com'));
INSERT INTO Courses VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Cryptology', 'CSC 333', (ABS(CHECKSUM(NEWID())) % 900) + 100, '2017 - 2018', 'Summer', (SELECT FacultyID FROM Faculty WHERE Email = 'tmuscarello@mail.com'));
INSERT INTO Courses VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Intro to Literature', 'ENG 101', (ABS(CHECKSUM(NEWID())) % 900) + 100, '2020 - 2021', 'Autumn', (SELECT FacultyID FROM Faculty WHERE Email = 'Oneil@mail.com'));
INSERT INTO Courses VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Essay Writing', 'WRD 483', (ABS(CHECKSUM(NEWID())) % 900) + 100, '2019 - 2020', 'Spring', (SELECT FacultyID FROM Faculty WHERE Email = 'Oneil@mail.com'));
INSERT INTO Courses VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Biology', 'SCI 900', (ABS(CHECKSUM(NEWID())) % 900) + 100, '2020 - 2021', 'Winter', (SELECT FacultyID FROM Faculty WHERE Email = 'EJDowns@mail.com'));
INSERT INTO Courses VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Intro to Networking', 'NET 301', (ABS(CHECKSUM(NEWID())) % 900) + 100, '2019 - 2020', 'Spring', (SELECT FacultyID FROM Faculty WHERE Email = 'grivas@mail.com'));
INSERT INTO Courses VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Data Structures 1', 'CSC 200', (ABS(CHECKSUM(NEWID())) % 900) + 100, '2020 - 2021', 'Winter', (SELECT FacultyID FROM Faculty WHERE Email = 'martinez@mail.com'));
INSERT INTO Courses VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Data Structures 2', 'CSC 201', (ABS(CHECKSUM(NEWID())) % 900) + 100, '2020 - 2021', 'Spring', (SELECT FacultyID FROM Faculty WHERE Email = 'martinez@mail.com'));



/*
TEAMS TABLE:
	- INSERT INTO Teams VALUES (TeamID, TeamName, CourseID, TeamCreatedBy);
*/
INSERT INTO Teams VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Team 10', '6210732', (SELECT CourseCreatedBy FROM Courses WHERE Courses.CourseID = '6210732'));
INSERT INTO Teams VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Team 20', '6210732', (SELECT CourseCreatedBy FROM Courses WHERE Courses.CourseID = '6210732'));
INSERT INTO Teams VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Team 100', '5627528', (SELECT CourseCreatedBy FROM Courses WHERE Courses.CourseID = '5627528'));
INSERT INTO Teams VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Team 5', '4659502', (SELECT CourseCreatedBy FROM Courses WHERE Courses.CourseID = '4659502'));
INSERT INTO Teams VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Team 2', '4659502', (SELECT CourseCreatedBy FROM Courses WHERE Courses.CourseID = '4659502'));
INSERT INTO Teams VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Blue Team', '1542886', (SELECT CourseCreatedBy FROM Courses WHERE Courses.CourseID = '1542886'));
INSERT INTO Teams VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Team 46', '3339026', (SELECT CourseCreatedBy FROM Courses WHERE Courses.CourseID = '3339026'));
INSERT INTO Teams VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Team 89', '8215937', (SELECT CourseCreatedBy FROM Courses WHERE Courses.CourseID = '8215937'));
INSERT INTO Teams VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Team 52', '6775985', (SELECT CourseCreatedBy FROM Courses WHERE Courses.CourseID = '6775985'));
INSERT INTO Teams VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Green Team', '6210732', (SELECT CourseCreatedBy FROM Courses WHERE Courses.CourseID = '6210732'));



/*
GOALS TABLE:
	- INSERT INTO Goals VALUES (GoalID, GoalName, GoalDescription, StartDate, StartTime, EndDate, EndTime, GoalStatus, GoalOwners, GoalStage, TeamID);
*/
INSERT INTO Goals VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Homework 5', 'Finish system design. Create a presentation video.', NULL, NULL, '2021-01-15', '23:59:00', 'DONE', 'Tom, Krishan', 1, '2054711');
INSERT INTO Goals VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Assignment 2', ' ', '2020-08-27', '00:00:00', '2020-08-31', '17:45:00', 'DONE', 'Barry', 3, '2054711');
INSERT INTO Goals VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Work on the project', ' ', NULL, NULL, NULL, NULL, 'NOT DONE', ' ', 4, '2419967');
INSERT INTO Goals VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Finish Assignment 1', ' ', '2019-06-04', NULL, '2019-06-11', NULL, 'NOT DONE', 'Gary', 4, '2822803');
INSERT INTO Goals VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Final Project', ' ', NULL, NULL, '2020-12-01', NULL, 'NOT DONE', ' ', 5, '2822803');
INSERT INTO Goals VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Group Study Session for Midterm Exam', ' ', '2020-09-21', '12:30:00', NULL, '14:00:00', 'NOT DONE', 'Yousuf, Ahad, Mohamed', 2, '5033928');
INSERT INTO Goals VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Start Homework 7', 'Create plan for 5-page essay', NULL, '19:00:00', NULL, '20:00:00', 'DONE', 'Zining', 2, '9099554');
INSERT INTO Goals VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Team meeting', 'Need to discuss our goals for Week 4', '2019-03-11', '15:00:00', '2019-03-11', '16:30:00', 'NOT DONE', 'Larry, Barry, Gary', 1, '9340932');
INSERT INTO Goals VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Team meeting', ' ', '2020-11-30', '10:00:00', NULL, NULL, 'DONE', ' ', 3, '9540762');
INSERT INTO Goals VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Assignment 4', 'Write Python functions today, solve math problems tomorrow', '2021-02-12', NULL, '2021-02-14', NULL, 'NOT DONE', 'Zining, Hector', 3, '9540762');



/*
ASSIGNMENTS TABLE:
	- INSERT INTO Assignments VALUES (AssignmentID, AssignmentName, StartDate, StartTime, DueDate, DueTime, CourseID, AssignmentCreatedBy);
*/
INSERT INTO Assignments VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Homework 1', '2020-08-16', NULL, '2020-08-26', NULL, '6210732', (SELECT CourseCreatedBy FROM Courses WHERE Courses.CourseID = '6210732'));
INSERT INTO Assignments VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Homework 2', NULL, NULL, NULL, NULL, '6210732', (SELECT CourseCreatedBy FROM Courses WHERE Courses.CourseID = '6210732'));
INSERT INTO Assignments VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Assignment 8', NULL, NULL, '2020-10-10', '10:10:10', '1542886', (SELECT CourseCreatedBy FROM Courses WHERE Courses.CourseID = '1542886'));
INSERT INTO Assignments VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Assignment 2', '2021-01-01', '00:00:00', '2021-01-04', '23:59:59', '3339026', (SELECT CourseCreatedBy FROM Courses WHERE Courses.CourseID = '3339026'));
INSERT INTO Assignments VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Assignment 7', '2021-03-21', NULL, '2021-04-01', '00:00:00', '4659502', (SELECT CourseCreatedBy FROM Courses WHERE Courses.CourseID = '4659502'));
INSERT INTO Assignments VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Homework 5', NULL, NULL, '2019-12-08', NULL, '4659502', (SELECT CourseCreatedBy FROM Courses WHERE Courses.CourseID = '4659502'));
INSERT INTO Assignments VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Homework 7', '2017-02-21', NULL, '2017-03-21', NULL, '5627528', (SELECT CourseCreatedBy FROM Courses WHERE Courses.CourseID = '5627528'));
INSERT INTO Assignments VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Assignment 4', '2020-05-05', NULL, '2020-05-09', NULL, '5908716', (SELECT CourseCreatedBy FROM Courses WHERE Courses.CourseID = '5908716'));
INSERT INTO Assignments VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Final project', NULL, NULL, '2021-08-09', '12:00:00', '6775985', (SELECT CourseCreatedBy FROM Courses WHERE Courses.CourseID = '6775985'));
INSERT INTO Assignments VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Midterm Exam', '2019-07-17', NULL, '2019-07-24', NULL, '8215937', (SELECT CourseCreatedBy FROM Courses WHERE Courses.CourseID = '8215937'));



/*
SUBMISSIONS TABLE:
	- INSERT INTO Submissions VALUES (SubmissionID, SubmissionDate, SubmissionTime, SubmissionComment, AssignmentID, SubmittedByUser);

	- SubmissionDate and SubmissionTime will use the current date and time as their values.
*/
INSERT INTO Submissions (SubmissionID, SubmissionComment, AssignmentID, SubmittedByUser) VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, ' ', '1174010', '1186947');
INSERT INTO Submissions (SubmissionID, SubmissionComment, AssignmentID, SubmittedByUser) VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Test submission', '1174010', '9514907');
INSERT INTO Submissions (SubmissionID, SubmissionComment, AssignmentID, SubmittedByUser) VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, ' ', '2225819', '1186947');
INSERT INTO Submissions (SubmissionID, SubmissionComment, AssignmentID, SubmittedByUser) VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, ' ', '2225819', '3134651');
INSERT INTO Submissions (SubmissionID, SubmissionComment, AssignmentID, SubmittedByUser) VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 'Updated homework file', '3087101', '1783033');
INSERT INTO Submissions (SubmissionID, SubmissionComment, AssignmentID, SubmittedByUser) VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, ' ', '3188753', '4706150');
INSERT INTO Submissions (SubmissionID, SubmissionComment, AssignmentID, SubmittedByUser) VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, ' ', '3685504', '3134651');
INSERT INTO Submissions (SubmissionID, SubmissionComment, AssignmentID, SubmittedByUser) VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, ' ', '8058509', '8061639');
INSERT INTO Submissions (SubmissionID, SubmissionComment, AssignmentID, SubmittedByUser) VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, ' ', '6073866', '1797533');
INSERT INTO Submissions (SubmissionID, SubmissionComment, AssignmentID, SubmittedByUser) VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, ' ', '6073866', '8962503');



/*
GRADES TABLE:
	- INSERT INTO Grades VALUES (GradeID, PointsEarned, TotalPoints, GradePercentage, LetterGrade, FacultyFeedback, DatePosted, AssignmentID, StudentID);

	- DatePosted will use the current date as its value.
*/
INSERT INTO Grades (GradeID, PointsEarned, TotalPoints, GradePercentage, LetterGrade, FacultyFeedback, AssignmentID, StudentID) VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 59, 60, 0, 'A+', 'Great work', '1174010', '1783033');
INSERT INTO Grades (GradeID, PointsEarned, TotalPoints, GradePercentage, LetterGrade, FacultyFeedback, AssignmentID, StudentID) VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 96, 100, 96.00, 'A', ' ', '2225819', '3134651');
INSERT INTO Grades (GradeID, PointsEarned, TotalPoints, GradePercentage, LetterGrade, FacultyFeedback, AssignmentID, StudentID) VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 8, 10, 80.00, 'B', 'Average work', '2225819', '1797533');
INSERT INTO Grades (GradeID, PointsEarned, TotalPoints, GradePercentage, LetterGrade, FacultyFeedback, AssignmentID, StudentID) VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 0.2, 1, 0, 'F', 'You only answered one question', '3087101', '2238456');
INSERT INTO Grades (GradeID, PointsEarned, TotalPoints, GradePercentage, LetterGrade, FacultyFeedback, AssignmentID, StudentID) VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 0, 15, 0.00, ' ', 'I did not receive a submission from you', '3188753', '3134651');
INSERT INTO Grades (GradeID, PointsEarned, TotalPoints, GradePercentage, LetterGrade, FacultyFeedback, AssignmentID, StudentID) VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 22, 25, 88.00, 'B+', 'Good job.', '3685504', '8061639');
INSERT INTO Grades (GradeID, PointsEarned, TotalPoints, GradePercentage, LetterGrade, FacultyFeedback, AssignmentID, StudentID) VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 16, 30, 0, 'D', ' ', '6588474', '8174384');
INSERT INTO Grades (GradeID, PointsEarned, TotalPoints, GradePercentage, LetterGrade, FacultyFeedback, AssignmentID, StudentID) VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 72, 100, 72.00, 'C-', ' ', '6588474', '1297220');
INSERT INTO Grades (GradeID, PointsEarned, TotalPoints, GradePercentage, LetterGrade, FacultyFeedback, AssignmentID, StudentID) VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 85, 120, 70.83, ' ', ' ', '8058509', '1352061');
INSERT INTO Grades (GradeID, PointsEarned, TotalPoints, GradePercentage, LetterGrade, FacultyFeedback, AssignmentID, StudentID) VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, 23, 35, 65.71, ' ', ' ', '8716378', '3134651');



/*
TEAM_MEMBERS TABLE:
	- INSERT INTO TeamMembers VALUES (TeamID, StudentID);
*/
INSERT INTO TeamMembers VALUES ('2054711', '1186947');
INSERT INTO TeamMembers VALUES ('2054711', '8061639');
INSERT INTO TeamMembers VALUES ('2822803', '1186947');
INSERT INTO TeamMembers VALUES ('2419967', '8174384');
INSERT INTO TeamMembers VALUES ('5033928', '1797533');
INSERT INTO TeamMembers VALUES ('5086331', '1797533');
INSERT INTO TeamMembers VALUES ('5086331', '3134651');
INSERT INTO TeamMembers VALUES ('6219535', '1352061');
INSERT INTO TeamMembers VALUES ('9540762', '1297220');
INSERT INTO TeamMembers VALUES ('9099554', '1186947');