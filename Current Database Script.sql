/*
RANDOM NOTES:
- I could remove the TeamCreatedBy column from the Teams table.
- I could remove the AssignmentCreatedBy column from the Assignments table.
- I could add more tables between the existing tables to make the design simpler (look at Week 3 code).
*/





USE P2C;

/*
DROP TABLE TeamMembers;
DROP TABLE Grades;
DROP TABLE Submissions;
DROP TABLE Assignments;
DROP TABLE Goals;
DROP TABLE Teams;
DROP TABLE Courses;
DROP TABLE Faculty;
DROP TABLE Students;
DROP TABLE Users;
*/





/*
USERS TABLE:
- UserType = 'Student' or 'Faculty'.
*/
CREATE TABLE Users (
UserID INT,
UserType VARCHAR(8),
CONSTRAINT PK_Users PRIMARY KEY (UserID)
);

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
Password VARCHAR(64) NOT NULL,
CONSTRAINT PK_Students PRIMARY KEY (StudentID),
CONSTRAINT FK_Users_Students FOREIGN KEY (StudentID) REFERENCES Users(UserID)
);

/*
FACULTY TABLE:
- Email must be unique.
- FacultyPassword is encrypted via hashing.
*/
CREATE TABLE Faculty (
FacultyID INT,
FirstName VARCHAR(64) NOT NULL,
MiddleName VARCHAR(64),
LastName VARCHAR(64) NOT NULL,
Email VARCHAR(100) NOT NULL UNIQUE,
PhoneNumber VARCHAR(32),
Password VARCHAR(64) NOT NULL,
JobTitle VARCHAR(100) NOT NULL,
CONSTRAINT PK_Faculty PRIMARY KEY (FacultyID),
CONSTRAINT FK_Users_Faculty FOREIGN KEY (FacultyID) REFERENCES Users(UserID)
);

/*
COURSES TABLE:
- CourseCode example: 'CSC 394'.
- CourseYear examples: '2020 - 2021' or '2021'.
- CourseQuarter values: 'Winter', 'Spring', 'Summer', 'Autumn'.
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
- Values in the TeamCreatedBy column will be taken from the CourseCreatedBy column in the Courses table.
*/
CREATE TABLE Teams (
TeamID INT,
TeamName VARCHAR(64) NOT NULL,
CourseID INT,
TeamCreatedBy INT,
CONSTRAINT PK_Teams PRIMARY KEY (TeamID),
CONSTRAINT FK_Courses_Teams FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

/*
GOALS TABLE:
- GoalStatus values: 'DONE', 'NOT DONE'.
- GoalOwners: Team members who are responsible for completing the goal. In other words, team members who are assigned the goal.
- GoalStage: Which stage of the progress bar the goal is in. Values: integers between 1 and 5.
- TeamID: The team that created the goal. GoalOwners must be in this team.
*/
CREATE TABLE Goals (
GoalID INT,
GoalName VARCHAR(200) NOT NULL,
GoalDescription VARCHAR(4096),
StartDate DATE,
StartTime TIME,
EndDate DATE,
EndTime TIME,
GoalStatus VARCHAR(16) NOT NULL DEFAULT 'NOT DONE',
GoalOwners VARCHAR(400),
GoalStage INT NOT NULL,
TeamID INT,
CONSTRAINT PK_Goals PRIMARY KEY (GoalID),
CONSTRAINT FK_Teams_Goals FOREIGN KEY (TeamID) REFERENCES Teams(TeamID)
);

/*
ASSIGNMENTS TABLE
*/
CREATE TABLE Assignments (
AssignmentID INT,
AssignmentName VARCHAR(200) NOT NULL,
StartDate DATE,
StartTime TIME,
DueDate DATE,
DueTime TIME,
CourseID INT,
AssignmentCreatedBy INT,
CONSTRAINT PK_Assignments PRIMARY KEY (AssignmentID),
CONSTRAINT FK_Courses_Assignments FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

/*
SUBMISSIONS TABLE:
- SubmissionDate uses the current date.
- SubmissionTime uses the current time.
*/
CREATE TABLE Submissions (
SubmissionID INT,
SubmissionDate DATE DEFAULT GETDATE(),
SubmissionTime TIME DEFAULT CURRENT_TIMESTAMP,
SubmissionComment VARCHAR(4096),
AssignmentID INT,
SubmittedBy INT,
CONSTRAINT PK_Submissions PRIMARY KEY (SubmissionID),
CONSTRAINT FK_Assignments_Submissions FOREIGN KEY (AssignmentID) REFERENCES Assignments(AssignmentID),
CONSTRAINT FK_Users_Submissions FOREIGN KEY (SubmittedBy) REFERENCES Users(UserID)
);

/*
GRADES TABLE
- DatePosted uses the current date.
*/
CREATE TABLE Grades (
GradeID INT,
PointsEarned DECIMAL(6,2) NOT NULL DEFAULT 0,
TotalPoints DECIMAL(6,2) NOT NULL DEFAULT 1,
GradePercentage DECIMAL(5,2),
LetterGrade VARCHAR(4),
FacultyFeedback VARCHAR(4096),
DatePosted DATE DEFAULT GETDATE(),
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
