using Gtk;

namespace Bamboo.View {
    public class Documents {

        public Gtk.Box          box;
        public Gtk.ComboBoxText categories;
        public Gtk.Entry        search;
        public Gtk.ToolButton   add_button;
        public Gtk.TreeView     list;

        public Documents ()
        {
            this.box = new Box (Orientation.VERTICAL, 0);
            this.box.pack_start (create_controls(), false, true, 4);
            this.box.pack_start (create_list(),     true,  true, 4);

            create_text_column(0, "Title");
            create_text_column(1, "Category");
            create_text_column(2, "Last Read");
        }

        private Widget create_controls()
        {
            var label = new Label("");
            label.set_markup("<b>Filter</b>");

            this.search     = new Entry();
            this.add_button = new ToolButton.from_stock (Stock.ADD);
            this.categories = new ComboBoxText();

            this.add_button.is_important = true; // Why?

            var hbox = new Box (Orientation.HORIZONTAL, 0);

            hbox.pack_start (label      , false , true , 4);
            hbox.pack_start (search     , true  , true , 4);
            hbox.pack_start (categories , false , true , 4);
            hbox.pack_start (add_button , false , true , 4);

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
