using Gtk;

namespace Bamboo.Model
{
    public class Documents : Object
    {
        public ListStore       list;
        public TreeModelFilter filtered;
        public TreeModelSort   sorted;

        public string current_category;
        public string previous_category;

        public Gee.HashSet<string> categories;

        public Documents ()
        {
            this.list     = new ListStore (1, typeof(Bamboo.Model.Document));
            this.filtered = new TreeModelFilter(list, null);
            this.sorted   = new TreeModelSort.with_model(filtered);

            this.sorted.set_sort_func(0, (_model, _iter_a, _iter_b) => {
                Document doc_a; Document doc_b; _model.get(_iter_a, 0, out doc_a); _model.get(_iter_b, 0, out doc_b);
                return doc_a.sort_compare_title(doc_b);
            });

            this.sorted.set_sort_func(1, (_model, _iter_a, _iter_b) => {
                Document doc_a; Document doc_b; _model.get(_iter_a, 0, out doc_a); _model.get(_iter_b, 0, out doc_b);
                return doc_a.sort_compare_category(doc_b);
            });

            this.sorted.set_sort_func(2, (_model, _iter_a, _iter_b) => {
                Document doc_a; Document doc_b; _model.get(_iter_a, 0, out doc_a); _model.get(_iter_b, 0, out doc_b);
                return doc_a.sort_compare_last_read(doc_b);
            });

            this.categories = new Gee.HashSet<string>();
            add_category("All");
            this.previous_category = this.current_category = "All";

            filtered.set_visible_func((model, iter) => {
                Document document;
                model.get(iter, 0, out document);

                if (this.current_category != "All") {
                    if (this.current_category != document.category) return false;
                }

                if (this._current_regex == null) return true;
                if (document.title.length == 0) return false;
                return this._current_regex.match(document.title);
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

        public void insert(string title, string category, string path)
        {
            TreeIter iter;
            this.list.append (out iter);
            this.list.set (iter, 0, new Document(title, category, path));
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
