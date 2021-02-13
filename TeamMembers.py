#- Insert a row into the TeamMembers table using TeamID and StudentID.
#- TeamID must be an existing value in the Teams table's TeamID column.
#- StudentID must be an existing value in the Students table's StudentID column.

def createTeamMember(teamID, studentID):
    try:
        print()
        print("Start createTeamMember().")
        cursor.execute('SELECT TeamID FROM Teams')
        team_ids = cursor.fetchall()
        if teamID in team_ids:
            cursor.execute('SELECT StudentID FROM Students')
            student_ids = cursor.fetchall()
            if studentID in student_ids:
                cursor.execute('INSERT INTO TeamMembers (TeamID, StudentID) VALUES ({0}, {1})').format(teamID, studentID)
                output = cursor.fetchall()
                if output:
                    print("createTeamMember() was successful.")
                else:
                    print("createTeamMember() failed.")
            else:
                print("StudentID doesn't exist.")
        else:
            print("TeamID doesn't exist.")
    except:
        print("An error occurred in createTeamMember().")
    finally:
        print()
        


#- Update a row in the TeamMembers table using TeamID and StudentID.

def updateTeamMember(currTeamID, currStudentID, newTeamID, newStudentID):
    try:
        print()
        print("Start updateTeamMember().")
        cursor.execute('UPDATE TeamMembers SET TeamID = {2}, StudentID = {3} WHERE TeamID = {0} AND StudentID = {1}').format(currTeamID, currStudentID, newTeamID, newStudentID)
        output = cursor.fetchall()
        if output:
            print("updateTeamMember() was successful.")
        else:
            print("updateTeamMember() failed.")
    except:
        print("An error occurred in updateTeamMember().")
    finally:
        print()


#- Delete a row in the TeamMembers table. Use TeamID and StudentID to find a specific row to delete.

def deleteTeamMember(teamID, studentID):
    try:
        print()
        print("Start deleteTeamMember().")
        cursor.execute("DELETE FROM TeamMembers WHERE TeamID = {0} AND StudentID = {1}").format(teamID, studentID)
        output = cursor.fetchall()
        if output:
            print("deleteTeamMember() was successful.")
        else:
            print("deleteTeamMember() failed.")
    except:
        print("An error occurred in deleteTeamMember().")
    finally:
        print()

#- Select all rows in the TeamMembers table.

def getTeamMembers():
    try:
        print()
        print("Start getTeamMembers().")
        cursor.execute('SELECT * FROM TeamMembers')
        output = cursor.fetchall()
        if output:
            print("getTeamMembers() was successful.")
        else:
            print("getTeamMembers() failed.")
    except:
        print("An error occureed in getTeamMembers().")
    finally:
        print()