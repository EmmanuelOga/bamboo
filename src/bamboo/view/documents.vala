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

            append_column("Title", (_column, _cell, _model, _iter) => {
                 Bamboo.Model.Document document;
                 _model.get(_iter, 0, out document);
                 (_cell as Gtk.CellRendererText).text = document.title;
            });

            append_column("Category", (_column, _cell, _model, _iter) => {
                 Bamboo.Model.Document document;
                 _model.get(_iter, 0, out document);
                 (_cell as Gtk.CellRendererText).text = document.category;
            });

            append_column("Last Read", (_column, _cell, _model, _iter) => {
                 Bamboo.Model.Document document;
                 _model.get(_iter, 0, out document);
                 (_cell as Gtk.CellRendererText).text = document.last_read.format("%x %X");
            });
        }

        private void append_column(string title, CellLayoutDataFunc cell_data_func)
        {
            // http://www.mono-project.com/GtkSharp_TreeView_Tutorial
            var col = new Gtk.TreeViewColumn ();
            col.set_title(title);
            col.set_resizable (true);
            col.set_expand (true);
            col.set_sizing(TreeViewColumnSizing.FIXED);

            var cell = new Gtk.CellRendererText ();
            col.pack_start (cell, true);

            col.set_cell_data_func (cell, cell_data_func);

            int pos = this.list.append_column (col) - 1;

            col.set_sort_column_id (pos);
        }

        private Toolbar create_toolbar()
        {
            var toolbar = new Toolbar ();
            toolbar.get_style_context ();
            toolbar.orientation = Orientation.VERTICAL;
            toolbar.set_icon_size(IconSize.SMALL_TOOLBAR);
            toolbar.set_style(ToolbarStyle.ICONS);

            this.add_button = new ToolButton.from_stock (Stock.ADD);
            this.remove_button = new ToolButton.from_stock (Stock.REMOVE);
            this.edit_button = new ToolButton.from_stock (Stock.EDIT);
            this.open_button = new ToolButton.from_stock (Stock.OPEN);

            set_selection_tool_buttons_sensitive(false);

            toolbar.add (this.add_button);
            toolbar.add (this.remove_button);
            toolbar.add (this.edit_button);
            toolbar.add (this.open_button);

            return toolbar;
        }

        public void set_selection_tool_buttons_sensitive(bool sensitivity)
        {
            this.remove_button.sensitive = sensitivity;
            this.edit_button.sensitive = sensitivity;
            this.open_button.sensitive = sensitivity;
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
            //this.list.fixed_height_mode = true;

            var swin = new ScrolledWindow(null, null);
            swin.set_border_width(5);
            swin.set_policy(PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
            swin.add(this.list);

            return swin;
        }

        public delegate void SelectionCallback(bool presence, TreeModel? model, TreeIter? iter);

        public void selected_row_iter(bool only_when_true, SelectionCallback cbk)
        {
            TreeModel model;
            TreeIter iter;
            var selection = this.list.get_selection();
            bool presence = selection.get_selected(out model, out iter);

            if (presence == true || only_when_true == false) cbk(presence, model, iter);
        }

    }

}
