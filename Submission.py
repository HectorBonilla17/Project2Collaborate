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
        
def submission_get(SubmissionDate = "", SubmissionTime = "", AssignmentID = "", SubmittedByStudent = "", SubmittedByFaculty = ""):
    try:
        print()
        print("Start submission_get():")

        args = locals()
        optionalSelect = ""
        for i in args:
            if(len(args[i]) != 0 and len(testArray) == 0):
                optionalSelect = "WHERE " + i + " = " + args[i]
        
            elif(len(args[i]) != 0 and len(testArray) != 0):
                optionalSelect += ' AND ' + i + " = " + args[i]


        cursor.execute('SELECT * FROM Submissions {0}'.format(optionalSelect))
        output = cursor.fetchall()
        if output:
            print("submission_get was successful.")
        else:
            print("submission_get failed.")
    except:
        print("An error occurred in submission_get().")
    finally:
        print()
