using Gtk;

public class MainWindow : Window {

    public MainWindow ()
    {
        this.title = "Bamboo";
        this.window_position = WindowPosition.CENTER;
        set_default_size (800, 600);

        var vbox = new Box (Orientation.VERTICAL, 0);
        vbox.pack_start (create_toolbar(), false, true, 4);
        vbox.pack_start (create_list(), true, true, 4);

        add (vbox);
    }

    private Widget create_toolbar() {
        var label = new Label("");
        label.set_markup("<b>Search</b>");

        var search = new Entry();

        var open_button = new ToolButton.from_stock (Stock.ADD);

        open_button.is_important = true;
        open_button.clicked.connect (() => {
            var file_chooser = new FileChooserDialog ("Open File", this,  FileChooserAction.OPEN,
                                                                          Stock.CANCEL, ResponseType.CANCEL,
                                                                          Stock.ADD,    ResponseType.ACCEPT);

            if (file_chooser.run () == ResponseType.ACCEPT) {
                open_file (file_chooser.get_filename ());
            }

            file_chooser.destroy ();
        });

        var categories = new ComboBoxText();
        categories.append_text("All");
        categories.set_active(0);

        var hbox = new Box (Orientation.HORIZONTAL, 0);

        hbox.pack_start (label       , false , true , 4);
        hbox.pack_start (search      , true  , true , 4);
        hbox.pack_start (categories  , false , true , 4);
        hbox.pack_start (open_button , false , true , 4);

        return hbox;
    }

    private Widget create_list()
    {
        var view = new TreeView ();

        var swin = new ScrolledWindow(null, null);

        swin.set_border_width(5);
        swin.set_policy(PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
        swin.add_with_viewport(view);


        var listmodel = new ListStore (4, typeof (string), typeof (string),  typeof (string), typeof (string));
        view.set_model (listmodel);

        view.insert_column_with_attributes (-1, "Title", new CellRendererText (), "text", 0);
        view.insert_column_with_attributes (-1, "Category", new CellRendererText (), "text", 1);
        view.insert_column_with_attributes (-1, "Last Read", new CellRendererText (), "text", 2, "foreground", 3);

        TreeIter iter;

        for (int i = 0; i < 250; i++) {
          listmodel.append (out iter);
          listmodel.set (iter, 0, @"Introduction to Burping $i", 1, "Burp", 2, "10/10/2011");
        }

        return swin;
    }

    private void open_file (string filename)
    {
        stderr.printf (filename);
    }
}
