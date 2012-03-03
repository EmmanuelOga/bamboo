using Gtk;

namespace Bamboo.View
{
    public class Main : Window
    {
        public Object controller { get; construct set; }
        public string kind { get { return "main"; } }

        public Gtk.MenuBar    menubar;
        public Gtk.AccelGroup accelgroup;
        public Gtk.Notebook   notebook;

        public Gtk.ImageMenuItem inew;
        public Gtk.ImageMenuItem save;
        public Gtk.ImageMenuItem open;
        public Gtk.ImageMenuItem quit;

        public Main(Object controller)
        {
            Object(controller: controller);

            this.title = "Bamboo";
            this.window_position = WindowPosition.CENTER;
            set_default_size (800, 600);

            var vbox = new Box (Orientation.VERTICAL, 0);
            vbox.pack_start (create_menubar(), false, true, 4);
            vbox.pack_start (create_notebook(), true, true, 4);

            add (vbox);

            add_accel_group(this.accelgroup);

            destroy.connect (Gtk.main_quit);
        }

        private Gtk.MenuBar create_menubar()
        {
            this.accelgroup = new Gtk.AccelGroup ();
            this.menubar = new Gtk.MenuBar ();

            var file = new Gtk.MenuItem.with_mnemonic("_File");
            var help = new Gtk.MenuItem.with_mnemonic("_Help");

            var filemenu = new Gtk.Menu ();
            var helpmenu = new Gtk.Menu ();

            file.set_submenu(filemenu);
            help.set_submenu(helpmenu);

            menubar.append(file);
            menubar.append(help);

            /* Create the File menu content. */
            this.inew = new Gtk.ImageMenuItem.with_mnemonic("_New Library");
            this.save = new Gtk.ImageMenuItem.from_stock(Stock.SAVE, accelgroup);
            this.open = new Gtk.ImageMenuItem.from_stock(Stock.OPEN, accelgroup);
            this.quit = new Gtk.ImageMenuItem.from_stock(Stock.QUIT, accelgroup);

            inew.set_image(new Gtk.Image.from_stock(Stock.NEW, Gtk.IconSize.MENU));
            inew.set_accel_group(accelgroup);

            quit.activate.connect(Gtk.main_quit);

            filemenu.append(inew);
            filemenu.append(save);
            filemenu.append(open);
            filemenu.append(quit);

            /* Create the Help menu content. */
            var contents = new Gtk.ImageMenuItem.from_stock(Stock.HELP,  accelgroup);
            var about    = new Gtk.ImageMenuItem.from_stock(Stock.ABOUT, accelgroup);

            helpmenu.append(contents);
            helpmenu.append(about);

            return this.menubar;
        }

        private Gtk.Notebook create_notebook()
        {
           this.notebook = new Gtk.Notebook();
           this.notebook.set_scrollable(true);
           return this.notebook;
        }

        public void append_page(string title, Gtk.Widget widget)
        {
            var label = new Gtk.Label(title);
            this.notebook.append_page(widget, label);
        }

        public void remove_pages()
        {
            while (this.notebook.get_n_pages() > 0)
                this.notebook.remove_page(-1);
        }

    }
}
