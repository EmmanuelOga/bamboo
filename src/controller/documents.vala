using Gtk;
using Bamboo;

namespace Bamboo.Controller
{
    public class Documents : Object
    {

        public Controller.Main main_controller;
        public Model.Documents documents;
        public View.Documents view;

        private string save_path;

        private TimeoutSource query_timeout;

        public Documents(Controller.Main main_controller)
        {
            this.main_controller = main_controller;
            this.documents = new Model.Documents();
            this.view = new View.Documents(this, this.documents.sorted);

            setup_categories();
            setup_list();
            setup_addition();
            setup_removal();
            setup_edition();
            setup_opening();
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
            this.view.append_column("Title", (_column, _cell, _model, _iter) => {
                 Model.Document document; _model.get(_iter, 0, out document);
                 (_cell as Gtk.CellRendererText).text = document.title;
            });

            this.view.append_column("Category", (_column, _cell, _model, _iter) => {
                 Model.Document document; _model.get(_iter, 0, out document);
                 (_cell as Gtk.CellRendererText).text = document.category;
            });

            this.view.append_column("Last Read", (_column, _cell, _model, _iter) => {
                 Model.Document document; _model.get(_iter, 0, out document);
                 (_cell as Gtk.CellRendererText).text = document.last_read.format("%x %X");
            });

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

        public bool save()
        {
            if (!FileUtils.test(this.save_path, FileTest.IS_REGULAR))
            {
                if (!stablish_save_path())
                {
                    message("save canceled");
                    return false;
                }
            }

            message(@"Actual save to: $save_path");

            return true;
        }

        private bool stablish_save_path()
        {
            var file_chooser = new FileChooserDialog ("Open File", main_controller.view, FileChooserAction.SAVE,
                                                                                         Stock.CANCEL, ResponseType.CANCEL,
                                                                                         Stock.SAVE,   ResponseType.ACCEPT);
            if (file_chooser.run () == ResponseType.ACCEPT) {
                this.save_path = file_chooser.get_filename ();

                if (!/.+\.bamboo$/.match(this.save_path))
                {
                    this.save_path = @"$save_path.bamboo";
                }

                file_chooser.destroy ();
                return true;
            }

            file_chooser.destroy ();
            return false;
        }

        private void setup_addition()
        {
            this.view.add_button.clicked.connect (() => {
                 var file_chooser = new FileChooserDialog ("Open File", main_controller.view, FileChooserAction.OPEN,
                                                                                              Stock.CANCEL, ResponseType.CANCEL,
                                                                                              Stock.ADD,    ResponseType.ACCEPT);
                 if (file_chooser.run () == ResponseType.ACCEPT) {

                    string filename = file_chooser.get_filename ();
                    string tentative_title = filename;

                    try
                    {
                        tentative_title = /\.pdf$/.replace(Path.get_basename(filename), -1, 0, "");
                        tentative_title = /[^a-zA-Z0-9]/.replace(tentative_title, -1, 0, " ");
                    }
                    catch(GLib.RegexError e)
                    {
                        // Do nothing.
                    }

                    var dialog = new View.Document (this, tentative_title, this.documents.categories);

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
                    Model.Document document;
                    model.get(iter, 0, out document);
                    message(@"Opening $(document.title)");
                });
            });
        }

        private void setup_opening()
        {
            this.view.open_button.clicked.connect (() => {
                this.view.selected_row_iter(true, (present, model, iter) => {
                    Model.Document document;
                    model.get(iter, 0, out document);
                    message(@"Opening $(document.title)");
                });
            });
        }

        private void add_file (string title, string category, string filename)
        {
            this.documents.insert(title, category, filename);
        }
    }
}
