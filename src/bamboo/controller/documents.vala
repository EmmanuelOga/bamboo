using Gtk;

namespace Bamboo.Controller
{
    public class Documents
    {

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
            setup_removal();
            setup_edition();
            setup_opening();

            for (int i = 0; i < 9; i++)
            {
                this.documents.insert(@"Introduction to Burping $i", @"Burp $(i%10)", "/some/path");
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

            this.view.list.cursor_changed.connect(() => {
                this.view.selected_row_iter(false, (present, model, iter) => {
                    this.view.set_selection_tool_buttons_sensitive(present);
                });
            });
        }

        private void setup_addition()
        {
            this.view.add_button.clicked.connect (() => {
                 var file_chooser = new FileChooserDialog ("Open File", main_controller.view, FileChooserAction.OPEN,
                                                                                              Stock.CANCEL, ResponseType.CANCEL,
                                                                                              Stock.ADD,    ResponseType.ACCEPT);
                 if (file_chooser.run () == ResponseType.ACCEPT) {

                    string filename = file_chooser.get_filename ();
                    var dialog = new Bamboo.View.NewDocument (this.documents.categories);

                    dialog.add_document.connect((title, category) => {
                        add_file (title, category, filename);
                    });

                    dialog.show_all ();
                 }

                 file_chooser.destroy ();
            });
        }

        private void setup_removal()
        {
            this.view.remove_button.clicked.connect (() => {
                this.view.selected_row_iter(true, (present, model, iter) => {
                    model.row_deleted(model.get_path(iter));
                });
            });
        }

        private void setup_edition()
        {
            this.view.edit_button.clicked.connect (() => {
                this.view.selected_row_iter(true, (present, model, iter) => {
                    string title;
                    model.get(iter, Bamboo.Model.Documents.Columns.TITLE, out title);
                    message(@"Editing $title");
                });
            });
        }

        private void setup_opening()
        {
            this.view.open_button.clicked.connect (() => {
                this.view.selected_row_iter(true, (present, model, iter) => {
                    string title;
                    model.get(iter, Bamboo.Model.Documents.Columns.TITLE, out title);
                    message(@"Opening $title");
                });
            });
        }

        private void add_file (string title, string category, string filename)
        {
            this.documents.insert(title, category, filename);
        }
    }
}
