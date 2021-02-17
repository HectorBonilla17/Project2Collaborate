def grade_create(pointsEarned, totalPoints, gradePercent = "", letterGrade = "", feedback = "", assignID, studentID): #DONE
    try:
        print()
        print("Start grade_create():")

        cursor.execute('SELECT AssignmentID FROM Assignments')
        assignTable = cursor.fetchall()

        cursor.execute('SELECT StudentID FROM Students')
        studentsTable = cursor.fetchall()

        
        if(assignID in assignTable and studentID in studentsTable):
            cursor.execute('INSERT INTO Grades (PointsEarned, TotalPoints, GradePercentage, LetterGrade, FacultyFeedback, AssignmentID, StudentID) VALUES ({0}, {1}, {2}, {3}, {4}, {5}, {6})'.format(gradeID, pointsEarned, totalPoints, gradePercent, letterGrade, feedback, date)
            output = cursor.fetchall()
            if output:
                print("grade_create was successful.")
            else:
                print("grade_create failed.")
        else:
            print("Either AssignmentID or StudentID doesn't exist")
        
    except:
        print("An error occurred in grade_create().")
    finally:
        print()
 
def grade_update(newPointsEarned, newTotalPoints, newGradePercent = "", newLetterGrade = "", newFeedback = "", assignID, studentID): #DONE
    try:
        print()
        print("Start grade_update():")

        cursor.execute('UPDATE Grades SET PointsEarned = {0}, TotalPoints = {1}, GradePercentage = {2}, LetterGrade = {3}, FacultyFeedback = {4} WHERE AssignmentID = {5} AND StudentID = {6}'.format(newPointsEarned, newTotalPoints, newGradePercent, newLetterGrade, newFeedback, assignID, studentID)          
        output = cursor.fetchall()
        if output:
            print("grade_update was successful.")
        else:
            print("grade_update failed.")
    except:
        print("An error occurred in grade_update().")
    finally:
        print()

def grade_delete(assignID, studentID): #DONE
    try:
        print()
        print("Start grade_delete():")
        cursor.execute('DELETE FROM Grades WHERE AssignmentID = {0} AND StudentID = {1}'.format(assignID, studentID))           
        output = cursor.fetchall()
        if output:
            print("grade_delete was successful.")
        else:
            print("grade_delete failed.")
    except:
        print("An error occurred in grade_delete().")
    finally:
        print()
        


def grade_get(): #DONE
    try:
        print()
        print("Start grade_get():")
        cursor.execute('SELECT * FROM Grades')          
        output = cursor.fetchall()
        if output:
            print("grade_get was successful.")
        else:
            print("grade_get failed.")
    except:
        print("An error occurred in grade_get().")
    finally:
        print()

#------------------------------------------------------------------------------------------------------

def assignment_create(assignName, sData = "", sTime = "", dTime = "", courseID): #DONE

    cursor.execute('SELECT CourseCreatedBy FROM Courses WHERE CourseCode = {0}'.format(courseID))
    createdBy = cursor.fetchall()

    try:
        print()
        print("Start assignment_create():")
        cursor.execute('INSERT INTO Assignments (AssignmentName, StartDate, StartTime, DueTime, AssignmentCreatedBy.) VALUES ({0}, {1}, {2}, {3}, {4})'.format(assignName, sData, sTime, dTime, createdBy))
        output = cursor.fetchall()
        if output:
            print("assignment_create was successful.")
        else:
            print("assignment_create failed.")
    except:
        print("An error occurred in assignment_create().")
    finally:
        print()
    
def assignment_update(currAssignName, currSData, currSTime, currDTime, newAssignName, newSData, newSTime, newDTime, createdBy): #DONE
    try:
        print()
        print("Start assignment_update():")
        cursor.execute('UPDATE Assignments SET AssignmentName = {0} AND StartDate = {1} AND StartTime = {2} AND DueTime = {3} WHERE AssignmentName = {4} AND StartDate = {5} AND StartTime = {6} AND DueTime = {7} ANDAssignmentCreatedBy = {8}'.format(newAssignName, newSData, newSTime, newDTime, currAssignName, currSData, currSTime, currDTime, newAssignName, createdBy))    
        output = cursor.fetchall()
        if output:
            print("assignment_update was successful.")
        else:
            print("assignment_update failed.")
    except:
        print("An error occurred in assignment_update().")
    finally:
        print()

def assignment_delete(assignName, sData, sTime, dTime, createdBy): #DONE
    try:
        print()
        print("Start assignment_delete():")
        cursor.execute('DELETE FROM Assignments WHERE AssignmentName = "{0}" AND StartDate = "{1}" AND StartTime = "{2}" AND DueDate= "{3}" AND DueTime = "{4}"'.format(assignName, sData, sTime, dTime, createdBy))           
        output = cursor.fetchall()
        if output:
            print("assignment_delete was successful.")
        else:
            print("assignment_delete failed.")
    except:
        print("An error occurred in assignment_delete().")
    finally:
        print()

def assignment_get(): #DONE
    try:
        print()
        print("Start assignment_get():")        
        cursor.execute('SELECT * FROM Assignments')
        output = cursor.fetchall()
        if output:
            print("assignment_get was successful.")
        else:
            print("assignment_get failed.")
    except:
        print("An error occurred in assignment_get().")
    finally:
        print()







