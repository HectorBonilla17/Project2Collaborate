def team_create(teamName, choosenCourse):
    try:
        print()
        print("Start team_create():")

        courseID, teamBy = course_get(choosenCourse)
        
        cursor.execute('INSERT INTO Teams (TeamName, CourseID, TeamCreatedBy) VALUES ({0}, {1}, {2})'.format(teamName, courseID, teamBy)
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
 
def team_update(teamName, courseID, teamBy):
    try:
        print()
        print("Start team_update():")

        cursor.execute('UPDATE Teams SET CourseID = {1}, TeamCreatedBy = {2} WHERE TeamName = {0}'.format(teamName, courseID, teamBy)      
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

def team_delete(teamName, courseID, teamBy):
    try:
        print()
        print("Start team_delete():")

        cursor.execute('DELETE FROM Teams WHERE TeamName = {0}, CourseID = {1}, TeamCreatedBy = {2}'.format(teamName, courseID, teamBy)      
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
