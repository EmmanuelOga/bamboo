using Gtk;

namespace Bamboo.View {
    public class Documents {

        public Gtk.Box          box;
        public Gtk.ComboBoxText categories;
        public Gtk.Entry        search;
        public Gtk.TreeView     list;

        public Gtk.ToolButton   add_button;
        public Gtk.ToolButton   remove_button;
        public Gtk.ToolButton   edit_button;
        public Gtk.ToolButton   open_button;

        public Documents ()
        {
            var hbox = new Box (Orientation.VERTICAL, 0);
            hbox.pack_start (create_controls(), false, true, 4);
            hbox.pack_start (create_list(), true, true, 4);

            this.box = new Box (Orientation.HORIZONTAL, 0);
            this.box.pack_start (hbox, true, true, 2);
            this.box.pack_start (create_toolbar(), false, true, 2);

            create_text_column(0, "Title");
            create_text_column(1, "Category");
            create_text_column(2, "Last Read");
        }

        private Toolbar create_toolbar()
        {
            var toolbar = new Toolbar ();
            toolbar.get_style_context ();
            toolbar.orientation = Orientation.VERTICAL;
            toolbar.set_icon_size(IconSize.SMALL_TOOLBAR);
            toolbar.set_style(ToolbarStyle.ICONS);

            this.add_button = new ToolButton.from_stock (Stock.ADD);
            this.add_button.is_important = true; // Why?
            this.remove_button = new ToolButton.from_stock (Stock.REMOVE);
            this.remove_button.is_important = true;
            this.edit_button = new ToolButton.from_stock (Stock.EDIT);
            this.edit_button.is_important = true; // Why?
            this.open_button = new ToolButton.from_stock (Stock.OPEN);
            this.open_button.is_important = true;

            toolbar.add (this.add_button);
            toolbar.add (this.remove_button);
            toolbar.add (this.edit_button);
            toolbar.add (this.open_button);

            return toolbar;
        }

        private Widget create_controls()
        {
            var label = new Label("");
            label.set_markup("<b>Filter</b>");

            this.search     = new Entry();
            this.categories = new ComboBoxText();

            var hbox = new Box (Orientation.HORIZONTAL, 0);

            hbox.pack_start (label      , false , true , 4);
            hbox.pack_start (search     , true  , true , 4);
            hbox.pack_start (categories , false , true , 4);

            return hbox;
        }

        private Widget create_list()
        {
            this.list = new Gtk.TreeView ();
            this.list.fixed_height_mode = true;

            var swin = new ScrolledWindow(null, null);
            swin.set_border_width(5);
            swin.set_policy(PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
            swin.add(this.list);

            return swin;
        }

        private void create_text_column(int position, string title)
        {
            this.list.insert_column_with_attributes (-1, title, new CellRendererText (), "text", position);
            var col = this.list.get_column(position);
            col.set_sort_column_id (position);
            col.set_resizable (true);
            col.set_expand (true);
        }
    }

}
