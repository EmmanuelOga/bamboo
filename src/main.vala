using Gtk;

int main (string[] args)
{
    Gtk.init (ref args);

    var main = new Bamboo.Controller.Main ();

    main.run();

    Gtk.main ();

    return 0;
}
