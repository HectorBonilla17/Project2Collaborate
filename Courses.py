
#- Insert a row into the Courses table using CourseName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter, and CourseCreatedBy.
#	- CourseCreatedBy must be an existing value in the Faculty table's FacultyID column.

def createCourse(CourseName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter, CourseCreatedBy):
    try:
        print()
        print("Start createCourse():")
        cursor.execute('SELECT FacultyID FROM Faculty')
        faulty_ids = cursor.fetchall()
        for id in faulty_ids:
            if (CourseCreatedBy == id):
                cursor.execute('INSERT INTO Courses (CourseName, CourseCode, SourseSectionNumber, CourseYear, CourseQuater, CourseCreatedBy) VALUES ({0}, {1}, {2}, {3}, {4}, {5})').format(CourseName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter, CourseCreatedBy)
                output = cursor.fetchall()
                if output:
                    print("createCourse() was successful.")
                else:
                    print("createCourse() failed.")
            else:
                print("FacultyID doesn't exist.")
    except:
        print("An error occurred in createCourse().")
    finally:
        print()



#- Update a row in the Courses table using CourseName, CourseCode, CourseSectionNumber, CourseYear, and CourseQuarter.

def updateCourse(currCode, currSectionNumber, currYear, currQuarter, newName, newCode, newSectionNumber, newYear, newQuater):
    try:
        print()
        print("Start updatCourse():")
        cursor.execute('UPDATE Courses SET CourseName = {4}, CourseCode = {5}, CourseSectionNumber = {6}, CourseYear = {7}, CourseQuater = {8} WHERE CourseCode = {0} AND CourseSectionNumber = {1} AND CourseYear = {2} AND CourseQuarter = {3}').format(currCode, currSectionNumber, currYear, currQuarter, newName, newCode, newSectionNumber, newYear, newQuater)
        output = cursor.fetchall()
        if output:
            print("updateCourse() was successful.")
        else:
            print("updateCourse() failed.")
    except:
        print("An error occurred in updateCourse().")
    finally:
        print()



#- Delete a row in the Courses table. Use CourseName, CourseCode, CourseSectionNumber, CourseYear, CourseQuarter, and CourseCreatedBy to find a specific row to delete.

def deleteCourse(CourseName, CourseCode, CourseSectionNumber, CourseYesr, CourseQuarter, CourseCreatedBy):
    try:
        print()
        print("Start deleteCourse():")
        cursor.execute('DELETE FROM Courses WHERE CourseName = {0} AND CourseCose = {1} AND CourseSectionNumber = {2} AND CourseYear = {3} AND CourseQuarter = {4} AND CourseCreatedBy = {5}').format(CourseName, CourseCode, CourseSectionNumber, CourseYesr, CourseQuarter, CourseCreatedBy)
        output = cursor.fetchall()
        if output:
            print("deleteCourse() was successfull.")
        else:
            print("deleteCourse() failed.")
    except:
        print("An error occurred in deleteCourse().")
    finally:
        print()


#- Select all rows in the Courses table.

def getCourse():
    try:
        print()
        print("Start getCourse():")
        cursor.execute('SELECT * FROM Courses')
        output = cursor.fetchall()
        if output:
            print("getCourse() was successful.")
        else:
            print("getCourse() failed.")
    except:
        print("An error occurred in getCourse().")
    finally:
        print()