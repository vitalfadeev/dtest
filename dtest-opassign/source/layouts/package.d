module ui.layouts;

static import ui.vbox;


shared ui.vbox.VBox VBox;


shared static this()  // shared static constructor
{
    VBox = new ui.vbox.VBox();
}
