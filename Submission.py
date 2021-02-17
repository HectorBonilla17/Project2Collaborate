def submission_create(assignID, subComment = "", subByStudent = "", subByFaculty = ""):
    try:
        print()
        print("Start submission_create():")
        cursor.execute('INSERT INTO Submissions (SubmissionComment, AssignmentID, SubmittedByStudent, and SubmittedByFaculty) VALUES ({0}, {1}, {2}, {3})'.format(subComment, assignID, subByStudent, subByFaculty))
        output = cursor.fetchall()
        if output:
            print("submission_create was successful.")
        else:
            print("submission_create failed.")
    except:
        print("An error occurred in submission_create().")
    finally:
        print()

        
#----------------------------------------------------------
        
def submission_get():
    try:
        print()
        print("Start submission_get():")
        cursor.execute('SELECT * FROM Submissions')
        output = cursor.fetchall()
        if output:
            print("submission_get was successful.")
        else:
            print("submission_get failed.")
    except:
        print("An error occurred in submission_get().")
    finally:
        print()
