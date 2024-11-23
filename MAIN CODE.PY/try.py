import mysql.connector
from mysql.connector import errorcode

try:
    # Replace 'your_host', 'your_user', 'your_password', and 'your_database' with your MySQL server credentials
    cnx = mysql.connector.connect(
        user='your_user',
        password='your_password',
        host='your_host',
        database='your_database'
    )
    cursor = cnx.cursor()

    # Sample query
    query = "SELECT * FROM your_table"
    cursor.execute(query)

    # Fetch and print results
    for row in cursor.fetchall():
        print(row)

    # Close the cursor and connection
    cursor.close()
    cnx.close()

except mysql.connector.Error as err:
    if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print("Something is wrong with your user name or password")
    elif err.errno == errorcode.ER_BAD_DB_ERROR:
        print("Database does not exist")
    else:
        print(err)
