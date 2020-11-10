# Nautilus extension that adds 'Open in Code' action to
# the right-click menu
#
# Fork of Nautilus Admin Extension
#
# author	aendeavor@Georg Lauterbach
# version	0.1.0 stable

from gi.repository import Nautilus, GObject
import os
import urllib
import gi

gi.require_version('Gtk', '3.0')
gi.require_version('Nautilus', '3.0')


class NautilusCode(Nautilus.MenuProvider, GObject.GObject):
    def __init__(self):
        pass

    def get_file_items(self, window, files):
        if len(files) < 1:
            return
        file = files[0]

        items = []
        self.window = window

        if file.get_uri_scheme() == "file":
            items += [self._create_item(file)]

        return items

    def get_background_items(self, window, file):
        items = []
        self.window = window

        if file.is_directory() and file.get_uri_scheme() == "file":
            items += [self._create_item(file)]

        return items

    def _create_item(self, file):
        """Creates the 'Open in Code' menu item."""
        item = Nautilus.MenuItem(name="NautilusCode::Code",
                                 label="Open in Code",
                                 tip="Open in VS Code")

        item.connect("activate", self._terminal_run, file)
        return item

    def _terminal_run(self, menu, file):
        execute = "code '" + str(urllib.unquote(file.get_uri()[7:])) + "' &"
        os.system(execute)
