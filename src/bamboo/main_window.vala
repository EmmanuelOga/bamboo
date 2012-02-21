using Gtk;

namespace Bamboo {
    public class MainWindow : Window {
        public MainWindow() {
            this.title = "Bamboo";
            this.window_position = WindowPosition.CENTER;
            set_default_size (800, 600);
        }
    }
}
