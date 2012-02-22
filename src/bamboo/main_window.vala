using Gtk;

namespace Bamboo {
    public class MainWindow : Window {
        public MainWindow() {
            this.title = "Bamboo";
            this.window_position = WindowPosition.CENTER;
            set_default_size (800, 600);
            setup_menues();
        }

        public void setup_menues()
        {
            var group = new AccelGroup ();
            var menubar = new MenuBar ();

            var file = new Gtk.MenuItem.with_mnemonic("_File");
            var help = new Gtk.MenuItem.with_mnemonic("_Help");

            var filemenu = new Gtk.Menu ();
            var helpmenu = new Gtk.Menu ();

            file.set_submenu(filemenu);
            help.set_submenu(helpmenu);

            menubar.append(file);
            menubar.append(help);

            /* Create the File menu content. */
            var inew = new Gtk.ImageMenuItem.from_stock(Stock.NEW, group);
            var open = new Gtk.ImageMenuItem.from_stock(Stock.OPEN, group);
            var quit = new Gtk.ImageMenuItem.from_stock(Stock.QUIT, group);

            quit.activate.connect(Gtk.main_quit);

            filemenu.append(inew);
            filemenu.append(open);
            filemenu.append(quit);

            /* Create the Help menu content. */
            var contents = new Gtk.ImageMenuItem.from_stock(Stock.HELP, group);
            var about    = new Gtk.ImageMenuItem.from_stock(Stock.ABOUT, group);

            helpmenu.append(contents);
            helpmenu.append(about);

            add(menubar);
            add_accel_group(group);
        }
    }
}
