import pyodbc

server = '192.168.189.129,1433'
database = 'P2C'
username = 'TeamLogin'
password = 'T3amUs3r'
connection = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=' + server + ';DATABASE=' + database + ';UID=' + username + ';PWD=' + password)
cursor = connection.cursor()


# FUNCTIONS FOR LOGIN PAGE:
# - Register/Sign up for a new Student account
#       - Add a new Student to the Students table.
# - Register/Sign up for a new Faculty account
#       - Add a new Faculty to the Faculty table.
# - Check password (for Students and Faculty)
#       - Check that the password matches the given email. Works in either the Students table or the Faculty table.
# - Login (for Students and Faculty)
#       - Verify that the password matches the email. Works in either the Students table or the Faculty table.
# - Reset password (for Students and Faculty)
#       - Ask for the user's email, old password, and new password.
#       - Change the old password to the new password for the user with the given email. Works in either the Students table or the Faculty table.
# - Check if the current user is a Faculty
#       - Check if the current user's email is in the Faculty table. If it's there, the current user is a Faculty. If it isn't there, the current user is a Student.


def register_new_student(first_name, middle_name, last_name, email, phone_number, student_password):
    try:
        print()
        print("Start register_new_student():")
        cursor.execute("INSERT INTO Students VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, '{0}', '{1}', '{2}', '{3}', '{4}', HASHBYTES('SHA2_256', '{5}'));".format(first_name, middle_name, last_name, email, phone_number, student_password))
        connection.commit()
        print("New Student account created!")
    except:
        print("An error occurred in register_new_student().")
    finally:
        print()


def register_new_faculty(first_name, middle_name, last_name, email, phone_number, faculty_password, job_title):
    try:
        print()
        print("Start register_new_faculty():")
        cursor.execute("INSERT INTO Faculty VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, '{0}', '{1}', '{2}', '{3}', '{4}', HASHBYTES('SHA2_256', '{5}'), '{6}');".format(first_name, middle_name, last_name, email, phone_number, faculty_password, job_title))
        connection.commit()
        print("New Faculty account created!")
    except:
        print("An error occurred in register_new_faculty().")
    finally:
        print()


def check_password(email, password_given):
    if isFaculty(email) == True:   # If current user is Faculty
        try:
            print()
            print("Start check_password() for Faculty:")
            cursor.execute("SELECT * FROM Faculty WHERE Email = '{0}' AND FacultyPassword = HASHBYTES('SHA2_256', '{1}');".format(email, password_given))
            output = cursor.fetchall()
            print(output)
            print()
            if output:   # If one row is returned
                print("Faculty password is correct.")
                return True
            elif not output:   # If zero rows are returned
                print("Faculty password is incorrect.")
                return False
        except:
            print("An error occurred in check_password() for Faculty.")
            return False
        finally:
            print()
    else:   # If current user is Student
        try:
            print()
            print("Start check_password() for Student:")
            cursor.execute("SELECT * FROM Students WHERE Email = '{0}' AND StudentPassword = HASHBYTES('SHA2_256', '{1}');".format(email, password_given))
            output = cursor.fetchall()
            print(output)
            print()
            if output:   # If one row is returned
                print("Student password is correct.")
                return True
            elif not output:   # If zero rows are returned
                print("Student password is incorrect.")
                return False
        except:
            print("An error occurred in check_password() for Student.")
            return False
        finally:
            print()


def user_login(email, user_password):
    if isFaculty(email) == True:   # If current user is Faculty
        try:
            print()
            print("Start user_login() for Faculty:")
            cursor.execute("SELECT Email, FacultyPassword FROM Faculty WHERE Email = '{0}' AND FacultyPassword = HASHBYTES('SHA2_256', '{1}');".format(email, user_password))
            output = cursor.fetchall()
            if output:   # If one row is returned
                print("Faculty log in was successful.")
            else:   # If zero roes are returned
                print("Faculty log in failed.")
        except:
            print("An error occurred in user_login() for Faculty.")
        finally:
            print()
    else:   # If current user is Student
        try:
            print()
            print("Start user_login() for Student:")
            cursor.execute("SELECT Email, StudentPassword FROM Students WHERE Email = '{0}' AND StudentPassword = HASHBYTES('SHA2_256', '{1}');".format(email, user_password))
            output = cursor.fetchall()
            if output:   # If one row is returned
                print("Student log in was successful.")
            else:
                print("Student log in failed.")
        except:
            print("An error occurred in user_login() for Student.")
        finally:
            print()


def reset_password(email, old_password, new_password):
    if isFaculty(email) == True:   # If current user is Faculty
        try:
            print()
            print("Start reset_password() for Faculty:")
            # Run "check_password" function to verify that old_password is the same as the existing password stored in the database.
            if check_password(email, old_password) == True:
                #Correct password
                cursor.execute("UPDATE Faculty SET FacultyPassword = HASHBYTES('SHA2_256', '{0}') WHERE Email = '{1}';".format(new_password, email))
                connection.commit()
                print("Faculty password reset was successful.")
            else:
                #Incorrect password
                print("Faculty password reset failed. Please enter the correct email and password for your account.")
        except:
            print("An error occurred in reset_password() for Faculty.")
        finally:
            print()
    else:   # If current user is Student
        try:
            print()
            print("Start reset_password() for Student:")
            # Run "check_password" function to verify that old_password is the same as the existing password stored in the database.
            if check_password(email, old_password) == True:
                #Correct password
                cursor.execute("UPDATE Students SET StudentPassword = HASHBYTES('SHA2_256', '{0}') WHERE Email = '{1}';".format(new_password, email))
                connection.commit()
                print("Student password reset was successful.")
            else:
                #Incorrect password
                print("Student password reset failed. Please enter the correct email and password for your account.")
        except:
            print("An error occurred in reset_password().")
        finally:
            print()


def isFaculty(email):
    try:
        print()
        print("Start isFaculty():")
        cursor.execute("SELECT * FROM Faculty WHERE Email = '{0}';".format(email))
        output = cursor.fetchall()
        print(output)
        print()
        if output:   # If one row is returned
            print("The current user is a faculty.")
            return True
        elif not output:   # If zero rows are returned
            print("The current user is a student.")
            return False
    except:
        print("An error occurred in isFaculty().")
    finally:
        print()


def main_program():
    try:
        print()
        print("Start main_program():")
        # CALL FUNCTIONS BELOW:
#        register_new_student("Spongebob", " ", "Squarepants", "krustykrabpizza@mail.com", " ", "dhRT8@1eRt")
#        register_new_faculty("Patrick", "S.", "Star", "MayonaiseMan@mail.com", "424-875-0123", "abCd3Ffg0", "Adjunct Professor")
#        check_password("MayonaiseMan@mail.com", "abCd3Ffg0")
#        check_password("krustykrabpizza@mail.com", "dhRT8@1eRt")
#        user_login("krustykrabpizza@mail.com", "dhRT8@1eRt")
#        user_login("MayonaiseMan@mail.com", "abCd3Ffg0")
#        reset_password("MayonaiseMan@mail.com", "abCd3Ffg0", "MyNameIsNotRick")
#        reset_password("krustykrabpizza@mail.com", "dhRT8@1eRt", "KrabbyPatty")
#        isFaculty("krustykrabpizza@mail.com")
#        isFaculty("MayonaiseMan@mail.com")
#        user_login("MayonaiseMan@mail.com", "MyNameIsNotRick")
#        user_login("krustykrabpizza@mail.com", "KrabbyPatty")
    except:
        print("An error occurred in main_program().")
    finally:
        print("End of main_program().")
        print()


main_program()
