#include <stdio.h>
#include <sqlite3.h>

int display_data(
  void *param,
  int argc, 
  char **argv, 
  char **columns
) 
{
  for (int i = 0; i< argc; i++)
  {
    printf("%s, ", argv[i]);
  }
  printf("\n");
  return 0;
}

int main() 
{
  sqlite3 *db;
  sqlite3_stmt *stmt;
  char *errmsg = 0;
  int action = 0;
  bool loop = true;

  sqlite3_open("cars.db", &db);

  while (loop)
  {
    printf(
      "\n"
      "What would you like to do?\n"
      "1. Display Cars\n"
      "2. Display Buyers\n"
      "3. Create new purchase\n"
      "4. Quit\n"
    );

    scanf("%d", &action);
    printf("\n");

    switch (action)
    {
      case 1:
        if (sqlite3_exec(db, "SELECT * FROM Cars;", display_data, 0, &errmsg) != SQLITE_OK)
        {
          fprintf(stderr, "%s", errmsg);
          sqlite3_free(errmsg);
        }
        break;

      case 2:
        if (sqlite3_exec(db, "SELECT * FROM Buyers;", display_data, 0, &errmsg) != SQLITE_OK)
        {
          fprintf(stderr, "%s", errmsg);
          sqlite3_free(errmsg);
        }
        break;

      case 3:
        break

      case 4:
        loop = false;
        break;

      default:
        printf("Enter a valid input");
        break;
    }
  }

  sqlite3_close(db);

return 0;
}
