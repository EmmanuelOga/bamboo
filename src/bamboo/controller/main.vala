using Gtk;

namespace Bamboo.Controller {
    public class Main {

        public Bamboo.View.Main view;
        public Bamboo.Controller.Documents documents;

        public Main() {
            this.view = new Bamboo.View.Main ();
            this.documents = new Bamboo.Controller.Documents (this);
        }

        public void run()
        {
            this.view.append_page ("Documents", this.documents.view.box);
            this.view.show_all ();
        }

    }
}
