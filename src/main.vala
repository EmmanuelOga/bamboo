using Gtk;

int main (string[] args) {
    Gtk.init (ref args);

    var main_window = new Bamboo.MainWindow ();
    main_window.destroy.connect (Gtk.main_quit);
    main_window.show_all ();

    // var documents_window = new Bamboo.DocumentsWindow ();
    // documents_window.destroy.connect (Gtk.main_quit);
    // documents_window.show_all ();
    //
    //  int d;
    //
    //  for (int i = 0; i < 250; i++)
    //  {
    //      d = i % 10;
    //      documents_window.insert_row(@"Introduction to Burping $i", @"Burp $d", "10/10/2011");
    //  }

    Gtk.main ();

    return 0;
}
