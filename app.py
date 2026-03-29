import sqlite3 as sql

DATABASE = 'cars.db'

TABLES = ['Stock', 'Cars', 'Purchases', 'Buyers']

def fetch_all_from_table(table):
    if table in TABLES:
        with sql.connect(DATABASE) as db:
            cursor = db.cursor()
            query = f'SELECT * FROM {table}'
            cursor.execute(query)
            return cursor.fetchall()
    else:
        return

if __name__ == '__main__':
    print(fetch_all_from_table(' '))
