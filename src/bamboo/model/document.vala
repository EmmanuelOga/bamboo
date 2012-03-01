using Gtk;

namespace Bamboo.Model
{
    public class Document : Object
    {
        public Document(string title, string category, string path)
        {
            this.title = title;
            this.category = category;
            this.path = path;
            this.last_read = new DateTime.now_local ();
        }

        public string title;
        public string category;
        public string path;

        public DateTime last_read;

        public int sort_compare_title(Bamboo.Model.Document other)
        {
            return this.title.collate(other.title);
        }

        public int sort_compare_category(Bamboo.Model.Document other)
        {
            return this.category.collate(other.category);
        }

        public int sort_compare_last_read(Bamboo.Model.Document other)
        {
            return this.last_read.compare(other.last_read);
        }
    }
}
