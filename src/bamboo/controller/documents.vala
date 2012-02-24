using Gtk;

namespace Bamboo.Controller {
    public class Documents {

        public Bamboo.Controller.Main main_controller;
        public Bamboo.Model.Documents documents;
        public Bamboo.View.Documents view;

        private TimeoutSource query_timeout;

        public Documents(Bamboo.Controller.Main main_controller)
        {
            this.main_controller = main_controller;
            this.documents = new Bamboo.Model.Documents();
            this.view = new Bamboo.View.Documents();

            setup_categories();
            setup_list();
            setup_addition();

             for (int i = 0; i < 250; i++)
             {
                 this.documents.insert(@"Introduction to Burping $i", @"Burp $(i%10)", "10/10/2011");
             }
        }

        private void setup_categories()
        {
            foreach(string category in this.documents.categories) {
                this.view.categories.append_text(category);
            }

            this.view.categories.set_active(0);

            this.documents.category_added.connect((category) => {
                this.view.categories.append_text(category);
            });

            this.view.search.changed.connect(() => {
                this.documents.current_query = this.view.search.get_text();
            });

            this.view.categories.changed.connect(() => {
                this.documents.current_category = this.view.categories.get_active_text();
            });
        }

        private void setup_list()
        {
            this.view.list.set_model (this.documents.sorted);

            this.query_timeout = new TimeoutSource (500);

            query_timeout.set_callback(() => {
                this.documents.update_filtering();
                return true;
            });

            query_timeout.attach(null);
        }

        private void setup_addition()
        {
            this.view.add_button.clicked.connect (() => {
                 var file_chooser = new FileChooserDialog ("Open File", main_controller.view, FileChooserAction.OPEN,
                                                                                              Stock.CANCEL, ResponseType.CANCEL,
                                                                                              Stock.ADD,    ResponseType.ACCEPT);
                 if (file_chooser.run () == ResponseType.ACCEPT) {
                     open_file (file_chooser.get_filename ());
                 }

                 file_chooser.destroy ();
             });
        }

        private void open_file (string filename)
        {
            stderr.printf (filename);
        }
    }
}
