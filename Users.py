# global variable to store current user's id
current_user_id = -1

def getCurrentUserId(email):
    try:
        print()
        print("start getCurrentUserId().")
        global current_user_id # declare global variable, so we can use in the function
        if isFaulty(email) == True:
            cursor.execute('SELECT FacultyID FROM Faculty WHERE Email = email')
            current_user_id = cursor.fetchall() # store id to global variable
            if current_user_id:
                print("getCurrentUserId was successful, and user is faculty.")
            else:
                print("getCurrentUserId failed, can't find id from table Faculty.")
        else:
            cursor.execute('SELECT StudentID FROM Students WHERE Email = email')
            current_user_id = cursor.fetchall()
            if current_user_id:
                print("getCurrentUserId was successful, and user is student.")
            else:
                print("getCurrentUserId failed, can't find id from table Students.")
    except:
        print("An error ocurred in getCurrentUserID().")
    finally:
        print()



# Update a row in the Students table using email

def updateStudent(email, firstName, middleName, lastName, newEmail, phoneNum):
    try:
        print()
        print("Start updateStudent().")
        cursor.execute('UPDATE Students SET FirstName = {1}, MiddleName = {2}, LastName = {3}, Email = {4}, PhoneNumber = {5} WHERE Email = {0}').format(email, firstName, middleName, lastName, newEmail, phoneNum)
        output = cursor.fetchall()
        if output:
            print("updateStudent() was successful.")
        else:
            print("updateStudent() failed.")
    except:
        print("An error occurred in updateStudent().")
    finally:
        print()


# Delete a row in the Students table using email

def deleteStudent(email):
    try:
        print()
        print("Start deleteStudent().")
        cursor.execute('DELETE FROM Students WHERE Email = email')
        output = cursor.fetchall()
        if output:
            print("deleteStudent() was successful.")
        else:
            print("deleteStudent() failed.")
    except:
        print("An error occurred in deleteStudent().")
    finally:
        print()

# Select all row in the Students table.

def getStudent():
    try:
        print()
        print("Start getStudent().")
        cursor.execute('SELECT * FROM Students')
        output = cursor.fetchall()
        if output:
            print("getStudent() was successful.")
        else:
            print("getStudent() failed.")
    except:
        print("An error occurred in getStudent().")
    finally:
        print()


# Update a row in the Faculty table using email

def updateFaculty(email, firstName, middleName, lastName, newEmail, phoneNum, jobTitle):
    try:
        print()
        print("Start updateFaculty().")
        cursor.execute('UPDATE Faculty SET FirstName = {1}, MiddleName = {2}, LastName = {3}, Email = {4}, PhoneNumber = {5}, JobTitle = {6} WHERE Email = {0}').format(email, firstName, middleName, lastName, newEmail, phoneNum, jobTitle)
        output = cursor.fetchall()
        if output:
            print("updateFaculty() was successful.")
        else:
            print("updateFaculty() failed.")
    except:
        print("An error occurred in updateFaulty().")
    finally:
        print()


# Delete a row in the Faculty table using email

def deleteFaculty(email):
    try:
        print()
        print("Start deleteFaculty().")
        cursor.execute('DELETE FROM Faculty WHERE Email = email')
        output = cursor.fetchall()
        if output:
            print("deleteFaculty() was successful.")
        else:
            print("deleteFaculty() failed.")
    except:
        print("An error occurred in deleteFaculty().")
    finally:
        print()


# Select all row in the Faculty table

def getFaculty():
    try:
        print()
        print("Start getFaculty().")
        cursor.execute('SELECT * FROM Faculty')
        output = cursor.fetchall()
        if output:
            print("getFaculty() was successful.")
        else:
            print("getFaculty() failed.")
    except:
        print("An error occurred in getFaculty().")
    finally:
        print()
    
            
    
