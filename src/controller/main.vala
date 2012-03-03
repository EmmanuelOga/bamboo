using Gtk;

namespace Bamboo.Controller
{
    public class Main : Object
    {

        public Bamboo.View.Main view;
        public Bamboo.Controller.Documents documents;

        public Main()
        {
            this.view = new Bamboo.View.Main ();

            this.view.inew.activate.connect(this.new_library);
            this.view.save.activate.connect(this.save_all_libraries);
            this.view.open.activate.connect(this.open_library);

            this.view.show_all ();
        }

        public void run()
        {
            // Do nothing. Might be used to open last document or something in the future.
        }

        public void new_library()
        {
            message("create a new lib.");
        }

        public void open_library()
        {
            message("open a lib.");
            //this.documents = new Bamboo.Controller.Documents (this);
            //this.view.append_page ("Documents", this.documents.view.box);
            ////this.view.remove_pages();
            //this.view.show_all ();
            //this.view.title = "Bamboo - Carozo y Narizota";
        }

        public void save_all_libraries()
        {
            message("save all libs.");
        }
    }
}
