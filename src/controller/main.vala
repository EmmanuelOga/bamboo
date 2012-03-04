using Gtk;
using Bamboo;

namespace Bamboo.Controller
{
    public class Main : Object
    {

        public Bamboo.View.Main view;

        public Main()
        {
            this.view = new View.Main (this);
            this.view.inew.activate.connect(this.new_library);
            this.view.save.activate.connect(this.save_all_libraries);
            this.view.open.activate.connect(this.open_library);

            this.view.notebook.focus.connect(() => {
                message("OK");
                return true;
            });

            this.view.show_all ();
        }

        public void run()
        {
            // Do nothing. Might be used to open last document or something in the future.
        }

        private Widget? current_tab()
        {
            int page = view.notebook.get_current_page();
            return view.notebook.get_nth_page(page);
        }

        private void new_library()
        {
            append_tab(new Controller.Documents (this).view, "New Library");
        }

        private void open_library()
        {
            message("open a lib.");
        }

        private void save_all_libraries()
        {
            var tab = current_tab();

            if (tab is Widget)
            {
                string kind;
                tab.get("kind", out kind);

                if (kind == "documents")
                {
                    ((tab as View.Documents).controller as Controller.Documents).save();
                }
                else
                {
                    message("Nothing to save.");
                }
            }
        }

        private void append_tab(Gtk.Widget widget, string title)
        {
            this.view.append_page (title, widget);
            this.view.show_all ();
        }
    }
}
