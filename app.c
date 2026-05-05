#include <stdio.h>
#include <string.h>
#include <sqlite3.h>

int display_data(
  void *param,
  int argc, 
  char **argv, 
  char **columns
) {
  int *first_call = (int*)param;

  if (*first_call) {
    for (int i = 0; i < argc - 1; i++) {
      printf("%s, ", columns[i]);
    }

    printf("%s\n", columns[argc - 1]);
    *first_call = 0;
  }

  for (int i = 0; i < argc - 1; i++) {
    printf("%s, ", argv[i]);
  }
  
  printf("%s\n", argv[argc - 1]);
  return 0;
}

int main() {
  sqlite3 *db;
  sqlite3_stmt *stmt;
  char *errmsg = 0;

  int action;

  int loop = 1;
  int first_call = 1;

  char date = '0';
  char quit = 'n';
  int buyer_id = 0;
  int car_id = 0;
  int price = 0;

  sqlite3_open("cars.db", &db);

  while (loop) {
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

    switch (action) {
      case 1:
        if (sqlite3_exec(db, "SELECT Cars.*, Stock.stock FROM Cars JOIN Stock ON Cars.id = Stock.car_id;", display_data, &first_call, &errmsg) != SQLITE_OK) {
          fprintf(stderr, "%s", errmsg);
          sqlite3_free(errmsg);
        }
        first_call = 1;
        break;

      case 2:
        if (sqlite3_exec(db, "SELECT * FROM Buyers;", display_data, &first_call, &errmsg) != SQLITE_OK) {
          fprintf(stderr, "%s", errmsg);
          sqlite3_free(errmsg);
        }
        first_call = 1;
        break;

      case 3:
        printf("What is the buyer id? (enter 0 to cancel)\n");
        scanf("%d", &buyer_id);

        if (buyer_id < 1) break;

        printf("\nWhat is the car id? (enter 0 to cancel)\n");
        scanf("%d", &car_id);

        if (car_id < 1) break;

        printf("\nWhat is the price? (enter 0 to cancel)\n");
        scanf("%d", &price);

        if (price < 1) break;

        printf("\nWhat was the date of purchase? (format dd-mm-yyyy, enter 0 to cancel)\n");
        scanf("%s", &date);

        if (strcmp(&date, "0") == 0) break;

        printf("\nIs this the purchase you would like to insert? y/n (enter 0 to cancel)\n");
        printf("buyer_id: %d, car_id: %d, price: %d, date: %s\n", buyer_id, car_id, price, &date);
        scanf("%s", &quit);

        if (strcmp(&quit, "y") != 0) break;

        printf("%s\n", &quit);

        break;

      case 4:
        loop = 0;
        break;

      default:
        printf("Enter a valid input\n");
        break;
    }
  }

  sqlite3_close(db);

return 0;
}
