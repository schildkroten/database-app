using Sqlite;

void ensure_types() {
}

static int main(string[] argv) {
  ensure_types();

	var app = new DatabaseApp.Application();
  return app.run(argv);
}
