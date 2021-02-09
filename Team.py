def team_create(teamID, teamName, courseID, teamBy):
    try:
        print()
        print("Start team_create():")
        cursor.execute('INSERT INTO Teams (TeamID , TeamName, CourseID, TeamCreatedBy) VALUES ({0}, {1}, {2}, {3})'.format(teamID, teamName, courseID, teamBy)
        output = cursor.fetchall()
        if output:
            print("team_create was successful.")
        else:
            print("team_create failed.")
    except:
        print("An error occurred in team_create().")
    finally:
        print()

#----------------------------------------------------------
 
def team_update(teamID, teamName, courseID, teamBy):
    try:
        print()
        print("Start team_update():")

        cursor.execute('UPDATE Teams SET TeamName = {1}, CourseID = {2}, TeamCreatedBy = {3} WHERE TeamID = {0}'.format(teamID, teamName, courseID, teamBy)      
        output = cursor.fetchall()
        if output:
            print("team_update was successful.")
        else:
            print("team_update failed.")
    except:
        print("An error occurred in team_update().")
    finally:
        print()

#----------------------------------------------------------

def team_delete(teamID):
    try:
        print()
        print("Start team_delete():")

        cursor.execute('DELETE FROM Teams WHERE TeamID = {0}'.format(teamID)      
        output = cursor.fetchall()
        if output:
            print("team_delete was successful.")
        else:
            print("team_delete failed.")
    except:
        print("An error occurred in team_delete().")
    finally:
        print()
        
#----------------------------------------------------------
        
def team_get():
    try:
        print()
        print("Start team_get():")

        cursor.execute('SELECT * FROM Teams')    
        output = cursor.fetchall()
        if output:
            print("team_get was successful.")
        else:
            print("team_get failed.")
    except:
        print("An error occurred in team_get().")
    finally:
        print()
