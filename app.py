import sqlite3 as sql
from enum import Enum

DATABASE = 'cars.db'

TABLES = ['Stock', 'Cars', 'Purchases', 'Buyers']

class Tables(Enum):
    STOCK = 'Stock'
    CARS = 'Cars'
    PURCHASES = 'Purchases'
    BUYERS = 'Buyers'

def fetch_all_from_table(table):
    if table in TABLES:
        with sql.connect(DATABASE) as db:
            cursor = db.cursor()
            query = f'SELECT * FROM {table}'
            cursor.execute(query)
            return cursor.fetchall()
    else:
        return f'Error: table {table} dose not exist'

def display_data_from_table(table):
    if table in TABLES:
        with sql.connect(DATABASE) as db:
            cursor = db.cursor()
            query = f'SELECT * FROM {table}'
            cursor.execute(query)

            for item in cursor.fetchall():
                print(item)
    else:
        return f'Error: table {table} dose not exist'

if __name__ == '__main__':
    while 1:
        action = input('What would you like to do? ')

        match action:
            case '1':
                display_data_from_table(Tables.CARS.value)
                break

            case _:
                print('Invalid action.')
