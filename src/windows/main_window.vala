using Gtk;

public class MainWindow : Window {

    public MainWindow () {
        this.title = "Bamboo";
        this.window_position = WindowPosition.CENTER;
        set_default_size (800, 600);

        var toolbar = new Toolbar ();
        toolbar.set_style(Gtk.ToolbarStyle.ICONS);
        toolbar.get_style_context ().add_class (STYLE_CLASS_PRIMARY_TOOLBAR);

        var open_button = new ToolButton.from_stock (Stock.ADD);
        open_button.is_important = true;
        toolbar.add (open_button);
        open_button.clicked.connect (on_open_clicked);

        var vbox = new Box (Orientation.VERTICAL, 0);
        vbox.pack_start (toolbar, false, true, 0);
        add (vbox);
    }

    private void on_open_clicked () {
        var file_chooser = new FileChooserDialog ("Open File", this,  FileChooserAction.OPEN,
                                                                      Stock.CANCEL, ResponseType.CANCEL,
                                                                      Stock.ADD,    ResponseType.ACCEPT);

        if (file_chooser.run () == ResponseType.ACCEPT) {
            open_file (file_chooser.get_filename ());
        }

        file_chooser.destroy ();
    }

    private void open_file (string filename) {
        stderr.printf (filename);
    }
}
