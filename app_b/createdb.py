import sqlite3 as lite


def readData():

    f = open('schema.sql', 'r')

    with f:

        data = f.read()

        return data


con = lite.connect('database.db')

with con:

    cur = con.cursor()

    sql = readData()
    cur.executescript(sql)

    cur.execute ("SELECT * from users")
    rows = cur.fetchall()

    for row in rows:
        print row
