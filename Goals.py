def goal_create(GoalName, GoalDescription = "", StartDate = "", StartTime = "", EndDate = "", EndTime = "", GoalStatus, GoalOwners = "", GoalStage, TeamID): #DONE
    try:
        print()
        print("Start goal_create():")

        cursor.execute('SELECT TeamID FROM Teams')
        teamIDTable = cursor.fetchall()

        if(TeamID in teamIDTable):
            cursor.execute('INSERT INTO Goals (GoalName, GoalDescription, StartDate, StartTime, EndDate, EndTime, GoalStatus, GoalOwners, GoalStage, and TeamID) VALUES ({0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}, {8}, {9})'.format(GoalName, GoalDescription, StartDate, StartTime, EndDate, EndTime, GoalStatus, GoalOwners, GoalStage, TeamID))
            output = cursor.fetchall()
            if output:
                print("goal_create was successful.")
            else:
                print("goal_create failed.")      
        else:
            print("TeamID doesn't exist")
        
    except:
        print("An error occurred in goal_create().")
    finally:
        print()

#----------------------------------------------------------
 
def goal_update(newGoalName, newGoalDescription, newStartDate, newStartTime, newEndDate, newEndTime, newGoalStatus, newGoalOwners, newGoalStage, currGoalName, currGoalStatus, teamID): #DONE
    try:
        print()
        print("Start goal_update():")
        cursor.execute('UPDATE Goals SET GoalName = {0} AND GoalDescription = {1} AND StartDate = {2} AND StartTime = {3} AND EndDate = {4} AND EndTime = {5} AND GoalStatus = {6} AND GoalOwners = {7} AND GoalStage = {8} WHERE GoalName = {9} AND GoalStatus = {10} AND TeamID = {11}'.format(newGoalName, newGoalDescription, newStartDate, newStartTime, newEndDate, newEndTime, newGoalStatus, newGoalOwners, newGoalStage, currGoalName, currGoalStatus, teamID))
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
        
def goals_get(): #DONE
    try:
        print()
        print("Start goals_get():")

        cursor.execute('SELECT * FROM Goals')    
        output = cursor.fetchall()
        if output:
            print("goals_get was successful.")
        else:
            print("gDoals_get failed.")
    except:
        print("An error occurred in goals_get().")
    finally:
        print()
