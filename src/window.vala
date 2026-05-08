using Sqlite;

[GtkTemplate(ui="/net/database-app/ui/window.ui")]
class DatabaseApp.Window : Gtk.ApplicationWindow {
  private Database db;
  private int rc;
  private bool first_run = true;

  [GtkChild]
	private unowned Gtk.Label cars_table;
  [GtkChild]
  private unowned Gtk.Label buyers_table;
  [GtkChild]
  private unowned Gtk.Label purchases_table;

  [GtkChild]
  private unowned Gtk.SpinButton car_id_entry;
  private Gtk.Adjustment car_id_adjustment;

  [GtkChild]
  private unowned Gtk.SpinButton buyer_id_entry;
  private Gtk.Adjustment buyer_id_adjustment;

  [GtkChild]
  private unowned Gtk.SpinButton price_entry;
  private Gtk.Adjustment price_adjustment;

  [GtkChild]
  private unowned Gtk.Entry date_entry;

  [GtkCallback]
  private void insert_purchase() {
    rc = db.exec(
      "INSERT INTO Purchases (car_id, buyer_id, price, date) VALUES (%f, %f, %f, '%s');".printf(
        car_id_entry.value,
        buyer_id_entry.value,
        price_entry.value,
        date_entry.text
      ),
      () => { return 0; },
      null
    );

    if (rc != OK) {
      stderr.printf("SQL error: %s\n", db.errmsg());
    }

    purchases_table.label = get_table(db, "SELECT * FROM Purchases;");
  }

  private string get_table(Database db, string query) {
    var builder = new StringBuilder();

    rc = db.exec(query, (n_columns, values, column_names) => {
      if (first_run) {
        for (int i = 0; i < n_columns; i++) {
          if (i == n_columns - 1) {
            builder.append("%s".printf(column_names[i]));
          } else {
            builder.append("%s, ".printf(column_names[i]));
          }
        }

        builder.append("\n");
        first_run = false;
      }

      for (int i = 0; i < n_columns; i++) {
        if (i == n_columns - 1) {
          builder.append("%s".printf(values[i]));
        } else {
          builder.append("%s, ".printf(values[i]));
        }
      }

      builder.append("\n");
      return 0;
    }, null);

    first_run = true;

    if (rc != OK) {
      stderr.printf("SQL error: %s\n", db.errmsg());
      return "";
    }

    return builder.str;
  }

	public Window(Gtk.Application app) {
    this.application = app;

    car_id_adjustment = new Gtk.Adjustment(0, 1, 15, 1, 0, 0);
    buyer_id_adjustment = new Gtk.Adjustment(0, 1, 15, 1, 0, 0);
    price_adjustment = new Gtk.Adjustment(0, 1, 1000000, 1, 0, 0);

    car_id_entry.adjustment = car_id_adjustment;
    buyer_id_entry.adjustment = buyer_id_adjustment;
    price_entry.adjustment = price_adjustment;

    date_entry.text = new DateTime.now_local().format("%Y-%m-%d");
	  
    if (Database.open("cars.db", out db) != OK) {
      stderr.printf("Can't open database: %s\n", db.errmsg());
    } else {
      cars_table.label = get_table(db, "SELECT Cars.*, Stock.stock FROM Cars JOIN Stock on Cars.id == Stock.car_id;");
      buyers_table.label = get_table(db, "SELECT * FROM Buyers;");
      purchases_table.label = get_table(db, "SELECT * FROM Purchases;");
    }
  }
}
