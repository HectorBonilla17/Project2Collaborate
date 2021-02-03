def grade_create(gradeID, pointsEarned, totalPoints, gradePercent, letterGrade, feedback, date):
    try:
        print()
        print("Start grade_create():")
        cursor.execute('INSERT INTO Grades (GradeID, PointsEarned, TotalPoints, GradePercentage, LetterGrade, FacultyFeedback, DatePosted) VALUES ({0}, {1}, {2}, {3}, {4}, {5}, {6})'.format(gradeID, pointsEarned, totalPoints, gradePercent, letterGrade, feedback, date)
        output = cursor.fetchall()
        if output:
            print("grade_create was successful.")
        else:
            print("grade_create failed.")
    except:
        print("An error occurred in grade_create().")
    finally:
        print()
 
def grade_update(gradeID, pointsEarned, totalPoints, gradePercent, letterGrade, feedback, date):
    try:
        print()
        print("Start grade_update():")

        cursor.execute('UPDATE Grades SET PointsEarned = {1}, TotalPoints = {2}, GradePercentage = {3}, LetterGrade = {4}, FacultyFeedback = {5}, DatePosted = {6} WHERE GradeID = {0}'.format(gradeID, pointsEarned, totalPoints, gradePercent, letterGrade, feedback, date)          
        output = cursor.fetchall()
        if output:
            print("grade_update was successful.")
        else:
            print("grade_update failed.")
    except:
        print("An error occurred in grade_update().")
    finally:
        print()

#------------------------------------------------------------------------------------------------------

def assignment_create(assignID, assignName, sData, sTime, dDate, dTime):
    try:
        print()
        print("Start assignment_create():")
        cursor.execute('INSERT INTO Assignments (AssignmentID, AssignmentName, StartDate, StartTime, DueDate, DueTime) VALUES ({0}, {1}, {2}, {3}, {4}, {5})'.format(assignID, assignName, sData, sTime, dDate, dTime)
        output = cursor.fetchall()
        if output:
            print("assignment_create was successful.")
        else:
            print("assignment_create failed.")
    except:
        print("An error occurred in assignment_create().")
    finally:
        print()
    
def assignment_update(assignID, assignName, sData, sTime, dDate, dTime):
    try:
        print()
        print("Start assignment_update():")
        cursor.execute('UPDATE Assignments SET AssignmentName = {1}, StartDate = {2}, StartTime = {3}, DueDate = {4}, DueTime = {5}, WHERE AssignmentID = {0}'.format(assignID, assignName, sData, sTime, dDate, dTime)             
        output = cursor.fetchall()
        if output:
            print("assignment_update was successful.")
        else:
            print("assignment_update failed.")
    except:
        print("An error occurred in assignment_update().")
    finally:
        print()
