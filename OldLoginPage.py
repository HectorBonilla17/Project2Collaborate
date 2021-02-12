import pyodbc

server = '[INSERT IP ADDRESS],1433'
database = 'P2C'
username = 'TeamLogin'
password = 'T3amUs3r'
connection = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=' + server + ';DATABASE=' + database + ';UID=' + username + ';PWD=' + password)
cursor = connection.cursor()


# FUNCTIONS FOR LOGIN PAGE:
# - Register/Sign up for a new account
#       - Add a new User to the Users table.
# - Check password
#       - Check that the password matches the given email in the Users table.
# - Student Login
#       - Verify that the Password matches the Email in the Users table.
# - Faculty Login
#       - Verify that the Password matches the Email in the Users table.
# - Reset password
#       - Ask for the user's Email, old Password, and new Password.
#       - Change the old Password to the new Password for the user with the given Email.


def register_new_user(first_name, middle_name, last_name, email, phone_number, user_type, user_password):
    try:
        print()
        print("Start register_new_user():")
        cursor.execute("INSERT INTO Users VALUES ((ABS(CHECKSUM(NEWID())) % 9000000) + 1000000, '{0}', '{1}', '{2}', '{3}', '{4}', '{5}', HASHBYTES('SHA2_256', '{6}'));".format(first_name, middle_name, last_name, email, phone_number, user_type, user_password))
        connection.commit()
        cursor.execute("UPDATE Users SET MiddleName = NULL WHERE MiddleName = '';")
        cursor.execute("UPDATE Users SET PhoneNumber = NULL WHERE PhoneNumber = '';")
        connection.commit()
        print("New User account created!")
    except:
        print("An error occurred in register_new_user().")
    finally:
        print()


def check_password(email, password_given):
    try:
        print()
        print("Start check_password():")
        cursor.execute("SELECT * FROM Users WHERE Email = '{0}' AND UserPassword = HASHBYTES('SHA2_256', '{1}');".format(email, password_given))
        output = cursor.fetchall()
        print(output)
        print()
        if output:   # If one row is returned
            print("Password is correct.")
            return True
        elif not output:   # If zero rows are returned
            print("Password is incorrect.")
            return False
    except:
        print("An error occurred in check_password().")
        return False
    finally:
        print()


def student_login(email, user_password):
    try:
        print()
        print("Start student_login():")
        cursor.execute("SELECT Email, UserPassword, UserType FROM Users WHERE Email = '{0}' AND UserPassword = HASHBYTES('SHA2_256', '{1}') AND UserType = 'Student';".format(email, user_password))
        output = cursor.fetchall()
        if output:
            print("Student log in was successful.")
        else:
            print("Student log in failed.")
    except:
        print("An error occurred in student_login().")
    finally:
        print()


def faculty_login(email, user_password):
    try:
        print()
        print("Start faculty_login():")
        cursor.execute("SELECT Email, UserPassword, UserType FROM Users WHERE Email = '{0}' AND UserPassword = HASHBYTES('SHA2_256', '{1}') AND UserType = 'Faculty';".format(email, user_password))
        output = cursor.fetchall()
        if output:
            print("Faculty log in was successful.")
        else:
            print("Faculty log in failed.")
    except:
        print("An error occurred in faculty_login().")
    finally:
        print()


def reset_password(email, old_user_password, new_user_password):
    try:
        print()
        print("Start reset_password():")
        # Run "Check Password" function to verify that old_user_password is the same as the existing password stored in the database
        if check_password(email, old_user_password) == True:
            #Correct password
            cursor.execute("UPDATE Users SET UserPassword = HASHBYTES('SHA2_256', '{0}') WHERE Email = '{1}';".format(new_user_password, email))
            connection.commit()
            print("Password reset was successful.")
        else:
            #Incorrect password
            print("Password reset failed. Please enter the correct email and password for your account.")
    except:
        print("An error occurred in reset_password().")
    finally:
        print()


def main_program():
    try:
        print()
        print("Start main_program():")
        # CALL FUNCTIONS BELOW THIS LINE:
        # register_new_user("Squidward", " ", "Tentacles", "krustykrabpizza@mail.com", " ", "Student", "dhRT8@1eRt")
        # check_password("krustykrabpizza@mail.com", "dhRT8@1eRt")
        # student_login("krustykrabpizza@mail.com", "dhRT8@1eRt")
        # register_new_user("Patrick", "P.", "Star", "nothisispatrick@gmail.com", "124-248-1248", "Faculty", "wRT3*&tpO0")
        # check_password("nothisispatrick@gmail.com", "wRT3*&tpO0")
        # faculty_login("nothisispatrick@gmail.com", "wRT3*&tpO0")
        # reset_password("krustykrabpizza@mail.com", "dhRT8@1eRt", "SP0NGEBOB!!!")
        # check_password("krustykrabpizza@mail.com", "SP0NGEBOB!!!")
    except:
        print("An error occurred in main_program().")
    finally:
        print("End of main_program().")
        print()


main_program()
