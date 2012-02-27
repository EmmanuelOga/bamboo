using Gtk;

namespace Bamboo.Model
{
    public class Documents
    {
        public ListStore       list;
        public TreeModelFilter filtered;
        public TreeModelSort   sorted;

        public string current_category;
        public string previous_category;

        public Gee.HashSet<string> categories;

        public Documents ()
        {
            this.list     = new ListStore (4, typeof (string), typeof (string), typeof (string), typeof (string));
            this.filtered = new TreeModelFilter(list, null);
            this.sorted   = new TreeModelSort.with_model(filtered);

            this.categories = new Gee.HashSet<string>();
            add_category("All");
            this.previous_category = this.current_category = "All";

            filtered.set_visible_func((model, iter) => {
                if (this.current_category != "All") {
                    string category;
                    model.get(iter, 1, out category);
                    if (this.current_category != category) return false;
                }

                if (this._current_regex == null) return true;

                string title;
                model.get(iter, 0, out title);
                if (title.length == 0) return false;
                return this._current_regex.match(title);
            });
        }

        public void update_filtering()
        {
            if ((this.previous_category != this.current_category) || (this._previous_query != this._current_query))
            {
                this.previous_category = this.current_category;
                this._previous_query = this._current_query;

                filtered.refilter();
            }
        }

        public void insert(string title, string category, string last_read)
        {
            TreeIter iter;
            this.list.append (out iter);
            this.list.set (iter, 0, title, 1, category, 2, last_read);
            this.add_category(category);
        }

        public bool add_category(string category)
        {
            if (this.categories.add(category))
            {
                category_added(category);
                return true;
            }
            else return false;
        }

        public signal void category_added(string category);

        private Regex _current_regex;
        private string _current_query;
        private string _previous_query;

        public string current_query {
            get
            {
                return _current_query;
            }
            set
            {
                _previous_query = _current_query;
                _current_query = value;
                try
                {
                    this._current_regex = new Regex(value);
                }
                catch(GLib.RegexError e)
                {
                    this._current_regex = null;
                }
            }
        }
    }
}
