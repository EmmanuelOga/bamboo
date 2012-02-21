using Gtk;

int main (string[] args) {
    Gtk.init (ref args);

    var window = new Bamboo.MainWindow ();
    window.destroy.connect (Gtk.main_quit);
    window.show_all ();

    int d;

    for (int i = 0; i < 250; i++)
    {
        d = i % 10;
        window.insert_row(@"Introduction to Burping $i", @"Burp $d", "10/10/2011");
    }

    Gtk.main ();
    return 0;
}
