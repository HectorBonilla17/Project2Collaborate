def goal_create(teamName, choosenCourse): #NOT DONE
    try:
        print()
        print("Start goal_create():")

        courseID, teamBy = course_get(choosenCourse)
        
        cursor.execute('INSERT INTO Goals (GoalName, StartDate, StartTime, EndDate, EndTime, GoalStatus, GoalOwners, and GoalStage) VALUES ({0}, {1}, {2})'.format(teamName, courseID, teamBy)
        output = cursor.fetchall()
        if output:
            print("goal_create was successful.")
        else:
            print("goal_create failed.")
    except:
        print("An error occurred in goal_create().")
    finally:
        print()

#----------------------------------------------------------
 
def goal_update(GoalName, GoalDescription, StartDate, StartTime, EndDate, EndTime, GoalStatus, GoalOwners, GoalStage): #NOT DONE
    try:
        print()
        print("Start goal_update():")

        cursor.execute('UPDATE Goals SET GoalName, GoalDescription, StartDate, StartTime, EndDate, EndTime, GoalStatus, GoalOwners, and GoalStage'.format(teamName, courseID, teamBy)      
        output = cursor.fetchall()
        if output:
            print("goal_update was successful.")
        else:
            print("goal_update failed.")
    except:
        print("An error occurred in goal_update().")
    finally:
        print()

#----------------------------------------------------------

def goal_delete(gName, sDate, sTime, eDate, eTime, gStatus, gOwners, gStage): #DONE
    try:
        print()
        print("Start goal_delete():")

        cursor.execute('DELETE FROM Goals WHERE GoalName = {0} AND StartDate = {1} AND StartTime = {2} AND EndDate = {3} AND EndTime = {4} AND GoalStatus = {5} AND GoalOwners = {6} AND GoalStage = {7}'.format(gName, sDate, sTime, eDate, eTime, gStatus, gOwners, gStage)      
        output = cursor.fetchall()
        if output:
            print("goal_delete was successful.")
        else:
            print("goal_delete failed.")
    except:
        print("An error occurred in goal_delete().")
    finally:
        print()
        
#----------------------------------------------------------
        
def goals_get(): #NOT DONE
    try:
        print()
        print("Start goals_get():")

        cursor.execute('SELECT * FROM Goals')    
        output = cursor.fetchall()
        if output:
            print("goals_get was successful.")
        else:
            print("goals_get failed.")
    except:
        print("An error occurred in goals_get().")
    finally:
        print()
