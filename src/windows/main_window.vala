using Gtk;

public class MainWindow : Window {

    public MainWindow () {
        this.title = "Bamboo";
        this.window_position = WindowPosition.CENTER;
        set_default_size (800, 600);

        var label = new Label("");
        label.set_markup("<b>Search</b>");

        var search = new Entry();

        var open_button = new ToolButton.from_stock (Stock.ADD);
        open_button.is_important = true;
        open_button.clicked.connect (on_open_clicked);

        var categories = new ComboBoxText();
        categories.append_text("All");
        categories.set_active(0);

        var hbox = new Box (Orientation.HORIZONTAL, 0);

        hbox.pack_start (label       , false , true , 4);
        hbox.pack_start (search      , true  , true , 4);
        hbox.pack_start (categories  , false , true , 4);
        hbox.pack_start (open_button , false , true , 4);

        var vbox = new Box (Orientation.VERTICAL, 0);
        vbox.pack_start (hbox, false, true, 0);

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
