#!/bin/bash
ip="192.168.189.129"

if [ ! -z "$(ls -A ./input)" ]; then
    echo "There are input files that need to be processed."

    for FILE in `ls -tU input/`
    do
        IFS='&&&' read -ra inputArray <<< $(cat input/$FILE)
        echo "INPUT0: ${inputArray[0]} INPUT1: ${inputArray[3]} INPUT2: ${inputArray[6]} INPUT3: ${inputArray[9]} INPUT4: ${inputArray[12]} INPUT5: ${inputArray[15]} INPUT6: ${inputArray[18]} INPUT7: ${inputArray[21]} INPUT8: ${inputArray[24]} INPUT9: ${inputArray[27]} INPUT10: ${inputArray[30]} INPUT11: ${inputArray[33]} INPUT12: ${inputArray[36]} INPUT13: ${inputArray[39]} INPUT14: ${inputArray[42]} INPUT15: ${inputArray[45]} INPUT16: ${inputArray[48]} INPUT17: ${inputArray[51]} INPUT18: ${inputArray[54]} INPUT19: ${inputArray[57]} INPUT20: ${inputArray[60]}"

        if [ ${inputArray[0]} == "studentLogIn" ]; then
            # Parameters: Email, StudentPassword
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "SELECT StudentID FROM Students WHERE Email = '${inputArray[3]}' AND StudentPassword = HASHBYTES('SHA2_256', '${inputArray[6]}');" < /dev/null` > output/$FILE   ##### Use this to set the value for the current user ID

        elif [ ${inputArray[0]} == "facultyLogIn" ]; then
            # Parameters: Email, FacultyPassword
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "SELECT FacultyID FROM Faculty WHERE Email = '${inputArray[3]}' AND FacultyPassword = HASHBYTES('SHA2_256', '${inputArray[6]}');" < /dev/null` > output/$FILE   ##### Use this to set the value for the current user ID

        elif [ ${inputArray[0]} == "resetStudentPassword" ]; then
            # Parameters: Email, CurrentStudentPassword, NewStudentPassword
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "UPDATE Students SET StudentPassword = HASHBYTES('SHA2_256', '${inputArray[9]}') WHERE Email = '${inputArray[3]}' AND StudentPassword = HASHBYTES('SHA2_256', '${inputArray[6]}');" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "resetFacultyPassword" ]; then
            # Parameters: Email, CurrentFacultyPassword, NewFacultyPassword
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "UPDATE Faculty SET FacultyPassword = HASHBYTES('SHA2_256', '${inputArray[9]}') WHERE Email = '${inputArray[3]}' AND FacultyPassword = HASHBYTES('SHA2_256', '${inputArray[6]}');" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "studentLogOut" ]; then
            echo "-1" > output/$FILE   ##### Use this to reset the value of the current user ID

        elif [ ${inputArray[0]} == "facultyLogOut" ]; then
            echo "-1" > output/$FILE   ##### Use this to reset the value of the current user ID

        elif [ ${inputArray[0]} == "createStudent" ]; then
            # Parameters: FirstName, MiddleName, LastName, Email, PhoneNumber, StudentPassword
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "INSERT INTO Students VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, '${inputArray[3]}', '${inputArray[6]}', '${inputArray[9]}', '${inputArray[12]}', '${inputArray[15]}', HASHBYTES('SHA2_256', '${inputArray[18]}'));" < /dev/null`
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "INSERT INTO Users VALUES ((SELECT StudentID FROM Students WHERE Email = '${inputArray[12]}'), 'Student');" < /dev/null`
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "SELECT StudentID FROM Students WHERE Email = '${inputArray[12]}';" < /dev/null` > output/$FILE   ##### Use this to set the value for the current user ID

        elif [ ${inputArray[0]} == "updateStudent" ]; then
            # Parameters: NewFirstName, NewMiddleName, NewLastName, NewEmail, NewPhoneNumber, CurrentUserID
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "UPDATE Students SET FirstName = '${inputArray[3]}', MiddleName = '${inputArray[6]}', LastName = '${inputArray[9]}', Email = '${inputArray[12]}', PhoneNumber = '${inputArray[15]}' WHERE StudentID = '${inputArray[18]}';" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "deleteStudent" ]; then
            # Parameters: CurrentUserID
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "DELETE FROM Submissions WHERE SubmittedByUser = '${inputArray[3]}';" < /dev/null`
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "DELETE FROM Users WHERE UserID = '${inputArray[3]}';" < /dev/null`
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "DELETE FROM Grades WHERE StudentID = '${inputArray[3]}';" < /dev/null`
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "DELETE FROM TeamMembers WHERE StudentID = '${inputArray[3]}';" < /dev/null`
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "DELETE FROM Students WHERE StudentID = '${inputArray[3]}';" < /dev/null`
            echo "-1" > output/$FILE   ##### Use this to reset the value of the current user ID

        elif [ ${inputArray[0]} == "getStudent" ]; then
            # Parameters: CurrentUserID
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "SELECT '!!!!!', FirstName, '&&&', MiddleName, '&&&', LastName, '&&&', Email, '&&&', PhoneNumber FROM Students WHERE StudentID = '${inputArray[3]}';" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "getAllStudents" ]; then
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "SELECT '!!!!!', FirstName, '&&&', MiddleName, '&&&', LastName, '&&&', Email, '&&&', PhoneNumber FROM Students;" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "createFaculty" ]; then
            # Parameters: FirstName, MiddleName, LastName, Email, PhoneNumber, FacultyPassword, JobTitle
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "INSERT INTO Faculty VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, '${inputArray[3]}', '${inputArray[6]}', '${inputArray[9]}', '${inputArray[12]}', '${inputArray[15]}', HASHBYTES('SHA2_256', '${inputArray[18]}'), '${inputArray[21]}');" < /dev/null`
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "INSERT INTO Users VALUES ((SELECT FacultyID FROM Faculty WHERE Email = '${inputArray[12]}'), 'Faculty');" < /dev/null`
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "SELECT FacultyID FROM Faculty WHERE Email = '${inputArray[12]}';" < /dev/null` > output/$FILE   ##### Use this to set the value for the current user ID

        elif [ ${inputArray[0]} == "updateFaculty" ]; then
            # Parameters: NewFirstName, NewMiddleName, NewLastName, NewEmail, NewPhoneNumber, NewJobTitle, CurrentUserID
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "UPDATE Faculty SET FirstName = '${inputArray[3]}', MiddleName = '${inputArray[6]}', LastName = '${inputArray[9]}', Email = '${inputArray[12]}', PhoneNumber = '${inputArray[15]}', JobTitle = '${inputArray[18]}' WHERE FacultyID = '${inputArray[21]}';" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "deleteFaculty" ]; then
            # Parameters: CurrentUserID
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "DELETE FROM Submissions WHERE SubmittedByUser = '${inputArray[3]}';" < /dev/null`
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "DELETE FROM Users WHERE UserID = '${inputArray[3]}';" < /dev/null`
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "DELETE FROM Grades WHERE AssignmentID IN (SELECT AssignmentID FROM Assignments WHERE AssignmentCreatedBy = '${inputArray[3]}');" < /dev/null`
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "DELETE FROM Assignments WHERE AssignmentCreatedBy = '${inputArray[3]}';" < /dev/null`
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "DELETE FROM Goals WHERE TeamID IN (SELECT TeamID FROM Teams WHERE TeamCreatedBy = '${inputArray[3]}');" < /dev/null`
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "DELETE FROM TeamMembers WHERE TeamID IN (SELECT TeamID FROM Teams WHERE TeamCreatedBy = '${inputArray[3]}');" < /dev/null`
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "DELETE FROM Teams WHERE TeamCreatedBy = '${inputArray[3]}';" < /dev/null`
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "DELETE FROM Courses WHERE CourseCreatedBy = '${inputArray[3]}';" < /dev/null`
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "DELETE FROM Faculty WHERE FacultyID = '${inputArray[3]}';" < /dev/null`
            echo "-1" > output/$FILE   ##### Use this to reset the value of the current user ID

        elif [ ${inputArray[0]} == "getFaculty" ]; then
            # Parameters: CurrentUserID
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "SELECT '!!!!!', FirstName, '&&&', MiddleName, '&&&', LastName, '&&&', Email, '&&&', PhoneNumber, '&&&', JobTitle FROM Faculty WHERE FacultyID = '${inputArray[3]}';" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "getAllFaculty" ]; then
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "SELECT '!!!!!', FirstName, '&&&', MiddleName, '&&&', LastName, '&&&', Email, '&&&', PhoneNumber, '&&&', JobTitle FROM Faculty;" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "createCourse" ]; then
            # Parameters: CourseName, CourseCode, CourseYear, CourseQuarter, CurrentUserID
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "INSERT INTO Courses VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, '${inputArray[3]}', '${inputArray[6]}', (ABS(CHECKSUM(NEWID())) % 900) + 100, '${inputArray[9]}', '${inputArray[12]}', '${inputArray[15]}');" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "updateCourse" ]; then
            # Parameters: NewCourseName, NewCourseCode, NewCourseSectionNumber, NewCourseYear, NewCourseQuarter, CurrentCourseCode, CurrentCourseSectionNumber, CurrentCourseYear, CurrentCourseQuarter, CurrentUserID
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "UPDATE Courses SET CourseName = '${inputArray[3]}', CourseCode = '${inputArray[6]}', CourseSectionNumber = '${inputArray[9]}', CourseYear = '${inputArray[12]}', CourseQuarter = '${inputArray[15]}' WHERE CourseCode = '${inputArray[18]}' AND CourseSectionNumber = '${inputArray[21]}' AND CourseYear = '${inputArray[24]}' AND CourseQuarter = '${inputArray[27]}' AND CourseCreatedBy = '${inputArray[30]}';" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "deleteCourse" ]; then
            # Parameters: CourseCode, CourseSectionNumber, CourseYear, CourseQuarter, CurrentUserID
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "DELETE FROM Grades WHERE AssignmentID IN (SELECT AssignmentID FROM Assignments WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[3]}' AND CourseSectionNumber = '${inputArray[6]}' AND CourseYear = '${inputArray[9]}' AND CourseQuarter = '{inputArray[12]}' AND CourseCreatedBy = '${inputArray[15]}'));" < /dev/null`
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "DELETE FROM Submissions WHERE AssignmentID IN (SELECT AssignmentID FROM Assignments WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[3]}' AND CourseSectionNumber = '${inputArray[6]}' AND CourseYear = '${inputArray[9]}' AND CourseQuarter = '{inputArray[12]}' AND CourseCreatedBy = '${inputArray[15]}'));" < /dev/null`
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "DELETE FROM Assignments WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[3]}' AND CourseSectionNumber = '${inputArray[6]}' AND CourseYear = '${inputArray[9]}' AND CourseQuarter = '{inputArray[12]}' AND CourseCreatedBy = '${inputArray[15]}');" < /dev/null`
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "DELETE FROM Goals WHERE TeamID IN (SELECT TeamID FROM Teams WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[3]}' AND CourseSectionNumber = '${inputArray[6]}' AND CourseYear = '${inputArray[9]}' AND CourseQuarter = '${inputArray[12]}' AND CourseCreatedBy = '${inputArray[15]}'));" < /dev/null`
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "DELETE FROM TeamMembers WHERE TeamID IN (SELECT TeamID FROM Teams WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[3]}' AND CourseSectionNumber = '${inputArray[6]}' AND CourseYear = '${inputArray[9]}' AND CourseQuarter = '{inputArray[12]}' AND CourseCreatedBy = '${inputArray[15]}'));" < /dev/null`
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "DELETE FROM Teams WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[3]}' AND CourseSectionNumber = '${inputArray[6]}' AND CourseYear = '${inputArray[9]}' AND CourseQuarter = '${inputArray[12]}' AND CourseCreatedBy = '${inputArray[15]}');" < /dev/null`
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "DELETE FROM Courses WHERE CourseCode = '${inputArray[3]}' AND CourseSectionNumber = '${inputArray[6]}' AND CourseYear = '${inputArray[9]}' AND CourseQuarter = '${inputArray[12]}' AND CourseCreatedBy = '${inputArray[15]}';" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "getCourseForStudent" ]; then
            # Parameters: CourseCode, CourseSectionNumber, CourseYear, CourseQuarter, CurrentUserID
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "SELECT '!!!!!', CourseName, '&&&', CourseCode, '&&&', CourseSectionNumber, '&&&', CourseYear, '&&&', CourseQuarter FROM Courses WHERE CourseCode = '${inputArray[3]}' AND CourseSectionNumber = '${inputArray[6]}' AND CourseYear = '${inputArray[9]}' AND CourseQuarter = '${inputArray[12]}' AND CourseID IN (SELECT CourseID FROM Teams WHERE TeamID IN (SELECT TeamID FROM TeamMembers WHERE StudentID = '${inputArray[15]}'));" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "getCourseForFaculty" ]; then
            # Parameters: CourseCode, CourseSectionNumber, CourseYear, CourseQuarter, CurrentUserID
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "SELECT '!!!!!', CourseName, '&&&', CourseCode, '&&&', CourseSectionNumber, '&&&', CourseYear, '&&&', CourseQuarter FROM Courses WHERE CourseCode = '${inputArray[3]}' AND CourseSectionNumber = '${inputArray[6]}' AND CourseYear = '${inputArray[9]}' AND CourseQuarter = '${inputArray[12]}' AND CourseCreatedBy = '${inputArray[15]}';" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "getAllCoursesForStudent" ]; then
            # Parameters: CurrentUserID
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "SELECT '!!!!!', CourseName, '&&&', CourseCode, '&&&', CourseSectionNumber, '&&&', CourseYear, '&&&', CourseQuarter FROM Courses WHERE CourseID IN (SELECT CourseID FROM Teams WHERE TeamID IN (SELECT TeamID FROM TeamMembers WHERE StudentID = '${inputArray[3]}'));" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "getAllCoursesForFaculty" ]; then
            # Parameters: CurrentUserID
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "SELECT '!!!!!', CourseName, '&&&', CourseCode, '&&&', CourseSectionNumber, '&&&', CourseYear, '&&&', CourseQuarter FROM Courses WHERE CourseCreatedBy = '${inputArray[3]}';" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "getAllCourses" ]; then
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "SELECT '!!!!!', CourseName, '&&&', CourseCode, '&&&', CourseSectionNumber, '&&&', CourseYear, '&&&', CourseQuarter FROM Courses;" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "createTeam" ]; then
            # Parameters: TeamName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter, CurrentUserID
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "INSERT INTO Teams VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, '${inputArray[3]}', (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[6]}' AND CourseSectionNumber = '${inputArray[9]}' AND CourseYear = '${inputArray[12]}' AND CourseQuarter = '${inputArray[15]}'), '${inputArray[18]}');" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "updateTeam" ]; then
            # Parameters: NewTeamName, CurrentTeamName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter, CurrentUserID
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "UPDATE Teams SET TeamName = '${inputArray[3]}' WHERE TeamName = '${inputArray[6]}' AND CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[9]}' AND CourseSectionNumber = '${inputArray[12]}' AND CourseYear = '${inputArray[15]}' AND CourseQuarter = '${inputArray[18]}' AND CourseCreatedBy = '${inputArray[21]}');" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "deleteTeam" ]; then
            # Parameters: TeamName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter, CurrentUserID
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "DELETE FROM Goals WHERE TeamID = (SELECT TeamID FROM Teams WHERE TeamName = '${inputArray[3]}' AND CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[6]}' AND CourseSectionNumber = '${inputArray[9]}' AND CourseYear = '${inputArray[12]}' AND CourseQuarter = '${inputArray[15]}' AND CourseCreatedBy = '${inputArray[18]}'));" < /dev/null`
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "DELETE FROM TeamMembers WHERE TeamID = (SELECT TeamID FROM Teams WHERE TeamName = '${inputArray[3]}' AND CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[6]}' AND CourseSectionNumber = '${inputArray[9]}' AND CourseYear = '${inputArray[12]}' AND CourseQuarter = '${inputArray[15]}' AND CourseCreatedBy = '${inputArray[18]}'));" < /dev/null`
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "DELETE FROM Teams WHERE TeamName = '${inputArray[3]}' AND CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[6]}' AND CourseSectionNumber = '${inputArray[9]}' AND CourseYear = '${inputArray[12]}' AND CourseQuarter = '${inputArray[15]}' AND CourseCreatedBy = '${inputArray[18]}');" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "getTeamForStudent" ]; then
            # Parameters: TeamName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter, CurrentUserID
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "SELECT TeamName FROM Teams WHERE TeamName = '${inputArray[3]}' AND CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[6]}' AND CourseSectionNumber = '${inputArray[9]}' AND CourseYear = '${inputArray[12]}' AND CourseQuarter = '${inputArray[15]}') AND TeamID IN (SELECT TeamID FROM TeamMembers WHERE StudentID = '${inputArray[18]}');" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "getTeamForFaculty" ]; then
            # Parameters: TeamName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter, CurrentUserID
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "SELECT TeamName FROM Teams WHERE TeamName = '${inputArray[3]}' AND CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[6]}' AND CourseSectionNumber = '${inputArray[9]}' AND CourseYear = '${inputArray[12]}' AND CourseQuarter = '${inputArray[15]}') AND TeamCreatedBy = '${inputArray[18]}';" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "getAllTeams" ]; then
            # Gets all teams in a course.
            # Parameters: CourseCode, CourseSectionNumber, CourseYear, CourseQuarter
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "SELECT TeamName FROM Teams WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[3]}' AND CourseSectionNumber = '${inputArray[6]}' AND CourseYear = '${inputArray[9]}' AND CourseQuarter = '${inputArray[12]}');" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "createTeamMember" ]; then
            # Parameters: TeamName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter, CurrentUserID, Email
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "INSERT INTO TeamMembers VALUES ((SELECT TeamID FROM Teams WHERE TeamName = '${inputArray[3]}' AND CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[6]}' AND CourseSectionNumber = '${inputArray[9]}' AND CourseYear = '${inputArray[12]}' AND CourseQuarter = '${inputArray[15]}') AND TeamCreatedBy = '${inputArray[18]}'), (SELECT StudentID FROM Students WHERE Email = '${inputArray[21]}'));" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "updateTeamMember" ]; then
            # Moves a student to another team
            # Parameters: NewTeamName, CurrentTeamName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter, CurrentUserID, Email
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "UPDATE TeamMembers SET TeamID = (SELECT TeamID FROM Teams WHERE TeamName = '${inputArray[3]}' AND CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[9]}' AND CourseSectionNumber = '${inputArray[12]}' AND CourseYear = '${inputArray[15]}' AND CourseQuarter = '${inputArray[18]}') AND TeamCreatedBy = '${inputArray[21]}') WHERE TeamID = (SELECT TeamID FROM Teams WHERE TeamName = '${inputArray[6]}' AND CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[9]}' AND CourseSectionNumber = '${inputArray[12]}' AND CourseYear = '${inputArray[15]}' AND CourseQuarter = '${inputArray[18]}') AND TeamCreatedBy = '${inputArray[21]}') AND StudentID = (SELECT StudentID FROM Students WHERE Email = '${inputArray[24]}');" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "deleteTeamMember" ]; then
            # Parameters: TeamName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter, CurrentUserID, Email
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "DELETE FROM TeamMembers WHERE TeamID = (SELECT TeamID FROM Teams WHERE TeamName = '${inputArray[3]}' AND CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[6]}' AND CourseSectionNumber = '${inputArray[9]}' AND CourseYear = '${inputArray[12]}' AND CourseQuarter = '${inputArray[15]}') AND TeamCreatedBy = '${inputArray[18]}') AND StudentID = (SELECT StudentID FROM Students WHERE Email = '${inputArray[21]}');" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "getTeamMember" ]; then
            # Parameters: TeamName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter, Email
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "SELECT '!!!!!', FirstName, '&&&', MiddleName, '&&&', LastName, '&&&', Email, '&&&', PhoneNumber FROM Students WHERE StudentID IN (SELECT StudentID FROM TeamMembers WHERE TeamID = (SELECT TeamID FROM Teams WHERE TeamName = '${inputArray[3]}' AND CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[6]}' AND CourseSectionNumber = '${inputArray[9]}' AND CourseYear = '${inputArray[12]}' AND CourseQuarter = '${inputArray[15]}'))) AND StudentID = (SELECT StudentID FROM Students WHERE Email = '${inputArray[18]}');" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "getAllTeamMembers" ]; then
            # Gets all team members in a team
            # Parameters: TeamName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "SELECT '!!!!!', FirstName, '&&&', MiddleName, '&&&', LastName, '&&&', Email, '&&&', PhoneNumber FROM Students WHERE StudentID IN (SELECT StudentID FROM TeamMembers WHERE TeamID = (SELECT TeamID FROM Teams WHERE TeamName = '${inputArray[3]}' AND CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[6]}' AND CourseSectionNumber = '${inputArray[9]}' AND CourseYear = '${inputArray[12]}' AND CourseQuarter = '${inputArray[15]}')));" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "createGoal" ]; then
            # Parameters: GoalName, GoalDescription, StartDate, StartTime, EndDate, EndTime, GoalStatus, GoalOwners, GoalStage, TeamName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "INSERT INTO Goals VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, '${inputArray[3]}', '${inputArray[6]}', '${inputArray[9]}', '${inputArray[12]}', '${inputArray[15]}', '${inputArray[18]}', '${inputArray[21]}', '${inputArray[24]}', '${inputArray[27]}', (SELECT TeamID FROM Teams WHERE TeamName = '${inputArray[30]}' AND CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[33]}' AND CourseSectionNumber = '${inputArray[36]}' AND CourseYear = '${inputArray[39]}' AND CourseQuarter = '${inputArray[42]}')));" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "updateGoal" ]; then
            # Parameters: NewGoalName, NewGoalDescription, NewStartDate, NewStartTime, NewEndDate, NewEndTime, NewGoalStatus, NewGoalOwners, NewGoalStage, CurrentGoalName, CurrentGoalStage, TeamName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "UPDATE Goals SET GoalName = '${inputArray[3]}', GoalDescription = '${inputArray[6]}', StartDate = '${inputArray[9]}', StartTime = '${inputArray[12]}', EndDate = '${inputArray[15]}', EndTime = '${inputArray[18]}', GoalStatus = '${inputArray[21]}', GoalOwners = '${inputArray[24]}', GoalStage = '${inputArray[27]}' WHERE GoalName = '${inputArray[30]}' AND GoalStage = '${inputArray[33]}' AND TeamID = (SELECT TeamID FROM Teams WHERE TeamName = '${inputArray[36]}' AND CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[39]}' AND CourseSectionNumber = '${inputArray[42]}' AND CourseYear = '${inputArray[45]}' AND CourseQuarter = '${inputArray[48]}'));" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "deleteGoal" ]; then
            # Parameters: GoalName, GoalStage, TeamName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "DELETE FROM Goals WHERE GoalName = '${inputArray[3]}' AND GoalStage = '${inputArray[6]}' AND TeamID = (SELECT TeamID FROM Teams WHERE TeamName = '${inputArray[9]}' AND CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[12]}' AND CourseSectionNumber = '${inputArray[15]}' AND CourseYear = '${inputArray[18]}' AND CourseQuarter = '${inputArray[21]}'));" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "getGoal" ]; then
            # Gets a goal created by a team
            # Parameters: GoalName, GoalStage, TeamName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "SELECT '!!!!!', GoalName, '&&&', GoalDescription, '&&&', StartDate, '&&&', StartTime, '&&&', EndDate, '&&&', EndTime, '&&&', GoalStatus, '&&&', GoalOwners, '&&&', GoalStage FROM Goals WHERE GoalName = '${inputArray[3]}' AND GoalStage = '${inputArray[6]}' AND TeamID = (SELECT TeamID FROM Teams WHERE TeamName = '${inputArray[9]}' AND CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[12]}' AND CourseSectionNumber = '${inputArray[15]}' AND CourseYear = '${inputArray[18]}' AND CourseQuarter = '${inputArray[21]}'));" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "getAllGoals" ]; then
            # Gets all goals created by a team
            # Parameters: TeamName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "SELECT '!!!!!', GoalName, '&&&', GoalDescription, '&&&', StartDate, '&&&', StartTime, '&&&', EndDate, '&&&', EndTime, '&&&', GoalStatus, '&&&', GoalOwners, '&&&', GoalStage FROM Goals WHERE TeamID = (SELECT TeamID FROM Teams WHERE TeamName = '${inputArray[3]}' AND CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[6]}' AND CourseSectionNumber = '${inputArray[9]}' AND CourseYear = '${inputArray[12]}' AND CourseQuarter = '${inputArray[15]}'));" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "createAssignment" ]; then
            # Parameters: AssignmentName, StartDate, StartTime, DueDate, DueTime, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter, CurrentUserID
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "INSERT INTO Assignments VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, '${inputArray[3]}', '${inputArray[6]}', '${inputArray[9]}', '${inputArray[12]}', '${inputArray[15]}', (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[18]}' AND CourseSectionNumber = '${inputArray[21]}' AND CourseYear = '${inputArray[24]}' AND CourseQuarter = '${inputArray[27]}'), '${inputArray[30]}');" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "updateAssignment" ]; then
            # Parameters: NewAssignmentName, NewStartDate, NewStartTime, NewDueDate, NewDueTime, CurrentAssignmentName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter, CurrentUserID
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "UPDATE Assignments SET AssignmentName = '${inputArray[3]}', StartDate = '${inputArray[6]}', StartTime = '${inputArray[9]}', DueDate = '${inputArray[12]}', DueTime = '${inputArray[15]}' WHERE AssignmentName = '${inputArray[18]}' AND CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[21]}' AND CourseSectionNumber = '${inputArray[24]}' AND CourseYear = '${inputArray[27]}' AND CourseQuarter = '${inputArray[30]}') AND AssignmentCreatedBy = '${inputArray[33]}';" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "deleteAssignment" ]; then
            # Parameters: AssignmentName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter, CurrentUserID
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "DELETE FROM Assignments WHERE AssignmentName = '${inputArray[3]}' AND CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[6]}' AND CourseSectionNumber = '${inputArray[9]}' AND CourseYear = '${inputArray[12]}' AND CourseQuarter = '${inputArray[15]}') AND AssignmentCreatedBy = '${inputArray[18]}';" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "getAssignment" ]; then
            # Gets an assignment in a course
            # Parameters: AssignmentName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "SELECT '!!!!!', AssignmentName, '&&&', StartDate, '&&&', StartTime, '&&&', DueDate, '&&&', DueTime FROM Assignments WHERE AssignmentName = '${inputArray[3]}' AND CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[6]}' AND CourseSectionNumber = '${inputArray[9]}' AND CourseYear = '${inputArray[12]}' AND CourseQuarter = '${inputArray[15]}');" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "getAllAssignments" ]; then
            # Gets all assignments in a course
            # Parameters: CourseCode, CourseSectionNumber, CourseYear, CourseQuarter
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "SELECT '!!!!!', AssignmentName, '&&&', StartDate, '&&&', StartTime, '&&&', DueDate, '&&&', DueTime FROM Assignments WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[3]}' AND CourseSectionNumber = '${inputArray[6]}' AND CourseYear = '${inputArray[9]}' AND CourseQuarter = '${inputArray[12]}');" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "createGrade" ]; then
            # Parameters: PointsEarned, TotalPoints, GradePercentage, LetterGrade, FacultyFeedback, AssignmentName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter, Email
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "INSERT INTO Grades(GradeID, PointsEarned, TotalPoints, GradePercentage, LetterGrade, FacultyFeedback, AssignmentID, StudentID) VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, '${inputArray[3]}', '${inputArray[6]}', '${inputArray[9]}', '${inputArray[12]}', '${inputArray[15]}', (SELECT AssignmentID FROM Assignments WHERE AssignmentName = '${inputArray[18]}' AND CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[21]}' AND CourseSectionNumber = '${inputArray[24]}' AND CourseYear = '${inputArray[27]}' AND CourseQuarter = '${inputArray[30]}')), (SELECT StudentID FROM Students WHERE Email = '${inputArray[33]}'));" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "updateGrade" ]; then
            # Parameters: NewPointsEarned, NewTotalPoints, NewGradePercentage, NewLetterGrade, NewFacultyFeedback, AssignmentName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter, Email
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "UPDATE Grades SET PointsEarned = '${inputArray[3]}', TotalPoints = '${inputArray[6]}', GradePercentage = '${inputArray[9]}', LetterGrade = '${inputArray[12]}', FacultyFeedback = '${inputArray[15]}', DatePosted = CAST(GETDATE() AS DATE) WHERE AssignmentID = (SELECT AssignmentID FROM Assignments WHERE AssignmentName = '${inputArray[18]}' AND CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[21]}' AND CourseSectionNumber = '${inputArray[24]}' AND CourseYear = '${inputArray[27]}' AND CourseQuarter = '${inputArray[30]}')) AND StudentID = (SELECT StudentID FROM Students WHERE Email = '${inputArray[33]}');" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "deleteGrade" ]; then
            # Parameters: AssignmentName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter, Email
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "DELETE FROM Grades WHERE AssignmentID = (SELECT AssignmentID FROM Assignments WHERE AssignmentName = '${inputArray[3]}' AND CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[6]}' AND CourseSectionNumber = '${inputArray[9]}' AND CourseYear = '${inputArray[12]}' AND CourseQuarter = '${inputArray[15]}')) AND StudentID = (SELECT StudentID FROM Students WHERE Email = '${inputArray[18]}');" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "getGrade" ]; then
            # Gets a student's grade for an assignment
            # Parameters: AssignmentName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter, Email
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "SELECT '!!!!!', PointsEarned, '&&&', TotalPoints, '&&&', GradePercentage, '&&&', LetterGrade, '&&&', FacultyFeedback, '&&&', DatePosted FROM Grades WHERE AssignmentID = (SELECT AssignmentID FROM Assignments WHERE AssignmentName = '${inputArray[3]}' AND CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[6]}' AND CourseSectionNumber = '${inputArray[9]}' AND CourseYear = '${inputArray[12]}' AND CourseQuarter = '${inputArray[15]}')) AND StudentID = (SELECT StudentID FROM Students WHERE Email = '${inputArray[18]}');" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "getAllGradesForStudent" ]; then
            # Gets a student's grades for all assignments in a course
            # Parameters: CourseCode, CourseSectionNumber, CourseYear, CourseQuarter, Email
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "SELECT '!!!!!', PointsEarned, '&&&', TotalPoints, '&&&', GradePercentage, '&&&', LetterGrade, '&&&', FacultyFeedback, '&&&', DatePosted FROM Grades WHERE AssignmentID IN (SELECT AssignmentID FROM Assignments WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[3]}' AND CourseSectionNumber = '${inputArray[6]}' AND CourseYear = '${inputArray[9]}' AND CourseQuarter = '${inputArray[12]}')) AND StudentID = (SELECT StudentID FROM Students WHERE Email = '${inputArray[15]}');" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "createSubmission" ]; then
            # Parameters: SubmissionComment, AssignmentName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter, CurrentUserID
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "INSERT INTO Submissions(SubmissionID, SubmissionComment, AssignmentID, SubmittedByUser) VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, '${inputArray[3]}', (SELECT AssignmentID FROM Assignments WHERE AssignmentName = '${inputArray[6]}' AND CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[9]}' AND CourseSectionNumber = '${inputArray[12]}' AND CourseYear = '${inputArray[15]}' AND CourseQuarter = '${inputArray[18]}')), '${inputArray[21]}');" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "deleteSubmission" ]; then
            # Parameters: SubmissionDate, SubmissionTime, AssignmentName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter, CurrentUserID
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "DELETE FROM Submissions WHERE SubmissionDate = '${inputArray[3]}' AND SubmissionTime = '${inputArray[6]}' AND AssignmentID = (SELECT AssignmentID FROM Assignments WHERE AssignmentName = '${inputArray[9]}' AND CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[12]}' AND CourseSectionNumber = '${inputArray[15]}' AND CourseYear = '${inputArray[18]}' AND CourseQuarter = '${inputArray[21]}')) AND SubmittedByUser = '${inputArray[24]}';" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "getSubmission-Student" ]; then
            # Gets a student's submission
            # Parameters: CurrentUserID, SubmissionDate, SubmissionTime, AssignmentName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "SELECT '!!!!!', Assignments.AssignmentName, '&&&', Students.Email, '&&&', Submissions.SubmissionDate, '&&&', Submissions.SubmissionTime, '&&&', Submissions.SubmissionComment, '&&&', Assignments.DueDate, '&&&', Assignments.DueTime FROM ((Assignments INNER JOIN Submissions ON Assignments.AssignmentID = Submissions.AssignmentID) INNER JOIN Students ON Submissions.SubmittedByUser = Students.StudentID) WHERE Submissions.SubmittedByUser = '${inputArray[3]}' AND Submissions.SubmissionDate = '${inputArray[6]}' AND Submissions.SubmissionTime = '${inputArray[9]}' AND Assignments.AssignmentName = '${inputArray[12]}' AND Assignments.CourseID IN (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[15]}' AND CourseSectionNumber = '${inputArray[18]}' AND CourseYear = '${inputArray[21]}' AND CourseQuarter = '${inputArray[24]}');" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "getSubmission-Faculty" ]; then
            # Gets a faculty's submission
            # Parameters: Email, SubmissionDate, SubmissionTime, AssignmentName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "SELECT '!!!!!', Assignments.AssignmentName, '&&&', Students.Email, '&&&', Submissions.SubmissionDate, '&&&', Submissions.SubmissionTime, '&&&', Submissions.SubmissionComment, '&&&', Assignments.DueDate, '&&&', Assignments.DueTime FROM ((Assignments INNER JOIN Submissions ON Assignments.AssignmentID = Submissions.AssignmentID) INNER JOIN Students ON Submissions.SubmittedByUser = Students.StudentID) WHERE Submissions.SubmittedByUser = (SELECT Users.UserID FROM ((Users INNER JOIN Students ON Users.UserID = Students.StudentID) INNER JOIN Faculty ON UserID = FacultyID) WHERE Students.Email = '${inputArray[3]}' OR Faculty.Email = '${inputArray[3]}') AND Submissions.SubmissionDate = '${inputArray[6]}' AND Submissions.SubmissionTime = '${inputArray[9]}' AND Assignments.AssignmentName = '${inputArray[12]}' AND Assignments.CourseID IN (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[15]}' AND CourseSectionNumber = '${inputArray[18]}' AND CourseYear = '${inputArray[21]}' AND CourseQuarter = '${inputArray[24]}');" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "getStudentSubmissionsForAssignment" ]; then
            # Gets a student's submissions for an assignment
            # Parameters: CurrentUserID, AssignmentName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "SELECT Assignments.AssignmentName, Students.Email, Submissions.SubmissionDate, Submissions.SubmissionTime, Submissions.SubmissionComment, Assignments.DueDate, Assignments.DueTime FROM ((Assignments INNER JOIN Submissions ON Assignments.AssignmentID = Submissions.AssignmentID) INNER JOIN Students ON Submissions.SubmittedByUser = Students.StudentID) WHERE Submissions.SubmittedByUser = '${inputArray[3]}' AND Assignments.AssignmentName = '${inputArray[6]}' AND Assignments.CourseID IN (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[9]}' AND CourseSectionNumber = '${inputArray[12]}' AND CourseYear = '${inputArray[15]}' AND CourseQuarter = '${inputArray[18]}');" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "getFacultySubmissionsForAssignment" ]; then
            # Gets a faculty's submissions for an assignment
            # Parameters: Email, AssignmentName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "SELECT Assignments.AssignmentName, Students.Email, Submissions.SubmissionDate, Submissions.SubmissionTime, Submissions.SubmissionComment, Assignments.DueDate, Assignments.DueTime FROM ((Assignments INNER JOIN Submissions ON Assignments.AssignmentID = Submissions.AssignmentID) INNER JOIN Students ON Submissions.SubmittedByUser = Students.StudentID) WHERE Submissions.SubmittedByUser = (SELECT Users.UserID FROM ((Users INNER JOIN Students ON Users.UserID = Students.StudentID) INNER JOIN Faculty ON UserID = FacultyID) WHERE Students.Email = '${inputArray[3]}' OR Faculty.Email = '${inputArray[3]}') AND Assignments.AssignmentName = '${inputArray[6]}' AND Assignments.CourseID IN (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[9]}' AND CourseSectionNumber = '${inputArray[12]}' AND CourseYear = '${inputArray[15]}' AND CourseQuarter = '${inputArray[18]}');" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "getAllSubmissionsForAssignment" ]; then
            # Gets all submissions for an assignment
            # Parameters: AssignmentName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter, CurrentUserID
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "SELECT Assignments.AssignmentName, Students.Email, Submissions.SubmissionDate, Submissions.SubmissionTime, Submissions.SubmissionComment, Assignments.DueDate, Assignments.DueTime FROM ((Assignments INNER JOIN Submissions ON Assignments.AssignmentID = Submissions.AssignmentID) INNER JOIN Students ON Submissions.SubmittedByUser = Students.StudentID) WHERE Assignments.AssignmentName = '${inputArray[3]}' AND Assignments.CourseID IN (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[6]}' AND CourseSectionNumber = '${inputArray[9]}' AND CourseYear = '${inputArray[12]}' AND CourseQuarter = '${inputArray[15]}' AND CourseCreatedBy = '${inputArray[18]}');" < /dev/null` > output/$FILE

        elif [ ${inputArray[0]} == "getAllSubmissionsForCourse" ]; then
            # Gets all submissions for all assignments in a course
            # Parameters: CourseCode, CourseSectionNumber, CourseYear, CourseQuarter, CurrentUserID
            echo `sqlcmd -h -1 -U TeamLogin -P T3amUs3r -S $ip -d P2C -q "SELECT Assignments.AssignmentName, Students.Email, Submissions.SubmissionDate, Submissions.SubmissionTime, Submissions.SubmissionComment, Assignments.DueDate, Assignments.DueTime FROM ((Assignments INNER JOIN Submissions ON Assignments.AssignmentID = Submissions.AssignmentID) INNER JOIN Students ON Submissions.SubmittedByUser = Students.StudentID) WHERE Assignments.CourseID IN (SELECT CourseID FROM Courses WHERE CourseCode = '${inputArray[3]}' AND CourseSectionNumber = '${inputArray[6]}' AND CourseYear = '${inputArray[9]}' AND CourseQuarter = '${inputArray[12]}' AND CourseCreatedBy = '${inputArray[15]}');" < /dev/null` > output/$FILE

        else
            echo "ERROR" > output/$FILE

        fi

        cat output/$FILE
        rm -f input/$FILE
    done
fi
