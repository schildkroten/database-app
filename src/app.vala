class DatabaseApp.Application : Gtk.Application {
  public static Application instance;

  private void init_css() {
    var provider = new Gtk.CssProvider();
    provider.load_from_resource("/net/database-app/style.css");

    Gtk.StyleContext.add_provider_for_display(
      Gdk.Display.get_default(),
      provider,
      Gtk.STYLE_PROVIDER_PRIORITY_USER
    );
  }

  public override int command_line(ApplicationCommandLine command_line) {
    var argv = command_line.get_arguments();

    if (command_line.is_remote) {
      if (argv.length >= 2 && argv[1] == "quit") {
        this.instance.quit();
      }
    } else {
      activate();
    }

    return 0;
  }

  public override void activate() {
    init_css();
		var window = new DatabaseApp.Window (this);
		window.present();
    window.maximize();
  }

  public Application() {
    instance = this;
    application_id = "net.database-app";
    flags = ApplicationFlags.HANDLES_COMMAND_LINE;
  }
}
