using Gtk;

namespace Bamboo {
    public class Documents {

        public ComboBoxText categories;
        public string current_category = "";
        public string previous_category = "";

        public Entry search = null;
        public string last_query = "";
        public string current_query = "";
        public Regex current_regex = null;

        public ListStore listmodel;
        public Gtk.Window main_window;

        public Box view;

        public Documents (Gtk.Window main_window)
        {
            this.main_window = main_window;
            this.view = new Box (Orientation.VERTICAL, 0);
            this.view.pack_start (create_controls(), false, true, 4);
            this.view.pack_start (create_list(), true, true, 4);
        }

        private Widget create_controls()
        {
            var label = new Label("");
            label.set_markup("<b>Filter</b>");

            this.search = new Entry();

            var open_button = new ToolButton.from_stock (Stock.ADD);

            open_button.is_important = true;
            open_button.clicked.connect (() => {

                var file_chooser = new FileChooserDialog ("Open File", main_window,  FileChooserAction.OPEN,
                                                                                     Stock.CANCEL, ResponseType.CANCEL,
                                                                                     Stock.ADD,    ResponseType.ACCEPT);
                if (file_chooser.run () == ResponseType.ACCEPT) {
                    open_file (file_chooser.get_filename ());
                }

                file_chooser.destroy ();
            });

            this.categories = new ComboBoxText();
            this.categories.append_text("All");
            this.categories.set_active(0);

            this.previous_category = this.current_category = "All";

            this.categories.changed.connect(() => {
                this.current_category = categories.get_active_text();
            });

            var hbox = new Box (Orientation.HORIZONTAL, 0);

            hbox.pack_start (label       , false , true , 4);
            hbox.pack_start (search      , true  , true , 4);
            hbox.pack_start (categories  , false , true , 4);
            hbox.pack_start (open_button , false , true , 4);

            return hbox;
        }

        private Widget create_list()
        {
            var treeview = new TreeView ();
            var swin = new ScrolledWindow(null, null);

            treeview.fixed_height_mode = true;

            swin.set_border_width(5);
            swin.set_policy(PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
            swin.add(treeview);

            this.listmodel = new ListStore (4, typeof (string), typeof (string),  typeof (string), typeof (string));
            var modelfilter = new TreeModelFilter(listmodel, null);

            setup_filtering(modelfilter);

            var modelsort = new TreeModelSort.with_model(modelfilter);

            treeview.set_model (modelsort);

            treeview.insert_column_with_attributes (-1, "Title",     new CellRendererText (), "text", 0);
            treeview.insert_column_with_attributes (-1, "Category",  new CellRendererText (), "text", 1);
            treeview.insert_column_with_attributes (-1, "Last Read", new CellRendererText (), "text", 2);

            // Make columns sortable.
            for (int i= 0; i < 3; i++)
            {
              var col = treeview.get_column(i);
              col.set_sort_column_id (i);
              col.set_resizable (true);
              col.set_expand (true);
            }

            return swin;
        }

        private void setup_filtering(TreeModelFilter modelfilter)
        {
            modelfilter.set_visible_func((model, iter) => {
                string category, title;

                if (this.current_category != "All")
                {
                    model.get(iter, 1, out category);

                    if (this.current_category != category)
                    {
                        return false;
                    }
                }

                if (this.current_regex == null) return true;

                model.get(iter, 0, out title);

                if (title.length == 0) return false;

                return this.current_regex.match(title);
            });

            var query_timeout = new TimeoutSource (500);

            query_timeout.set_callback(() => {

                this.current_query = this.search.get_text();

                if ((this.previous_category != this.current_category) || (this.last_query != this.current_query))
                {
                  if (this.current_query.length > 0 && this.current_query != this.last_query)
                  {
                    try
                    {
                      this.current_regex = new Regex(this.current_query);
                    }
                    catch(GLib.RegexError e)
                    {
                      this.current_regex = null;
                    }
                  }
                  else
                  {
                    this.current_regex = null;
                  }

                  this.previous_category = this.current_category;
                  this.last_query = this.current_query;

                  modelfilter.refilter();
                }

                return true;
            });
            query_timeout.attach(null);
        }

        private void open_file (string filename)
        {
            stderr.printf (filename);
        }

        public void insert_row(string title, string category, string last_read)
        {
            TreeIter iter;
            this.listmodel.append (out iter);
            this.listmodel.set (iter, 0, title, 1, category, 2, last_read);

            if (!has_category(category))
            {
                this.categories.append_text(category);
            }
        }

        // TODO use a Set, or better yet, write a custom Set backed TreeModel.
        public bool has_category(string category)
        {
            string cat;
            TreeIter iter;

            var categories_model = this.categories.get_model();

            bool existing = false;
            bool iter_found = categories_model.get_iter_first(out iter);

            while (iter_found && !existing) {
                categories_model.get(iter, 0, out cat);
                existing = cat == category;
                iter_found = categories_model.iter_next(ref iter);
            }
            return existing;
        }

    }
}
