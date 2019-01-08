# TODO

## Tasks

Non-comprehensive and in no particular order.

- [ ] Double-clicking a non-text sidebar item should launch it in Finder
- [ ] Drop on Text View should add sidebar files, and select first dropped file
- [ ] When removing top-level sidebar items, clear editor if contents is part of that item
- [ ] Make sidebar collapsable using mouse, how to re-open?
- [ ] Drop folder makes folder show up expanded one level.
- [ ] Preview markdown.
- [ ] Syntax highlight markdown.
- [ ] Save markdown file.
- [ ] Sidebar has an area for open files (like bbedit does)?
- [ ] Create an app icon, use [HIG][appicon] to figure "document" icon type
- [ ] Load files or directories via open dialog
- [ ] Save file via save, save-as dialog
- [ ] Centralize data model (so we can track dirty buffers), present stats
- [ ] Allow sidebar to get and start wider
- [ ] Allow the app to participate in a share sheet
- [ ] Preferences window should provide default file location (~/Desktop).
- [ ] If dropped file is an alias for a directory, find/use the directory

## Notes

## Completed

- [x] Revert doc-type registration in info.plist to support app-icon d/d
- [x] Right click to remove top-level sidebar item
- [x] Disallow loading non-text files based on workspace.type UTI.
- [x] Can you ask if a file is a text file? (Use NSWorkspace).
- [x] Don't allow user to select non-text file
- [x] Non-selectable files should be greyed
- [x] Add an event notification for dropped files (on icon, and sidebar)
- [x] Load selected file into text view.
- [x] Double-click folder to toggle expand/collapse.
- [x] Click disclosure on directory to load next level.
- [x] Consider using URL.resourceValues to omit packages, apps, etc
- [x] folders section for outline view
- [x] some sort of data model for managing files and folders
- [x] drop arbitrary files?
- [x] disallow duplicates in sidebar via when dropped
- [x] Restore main window when clicking app icon.
- [x] window limited in how small it can get
- [x] allow files to be dropped on application icon
- [x] drop view delegate so file view controller gets notified
- [x] drag/drop machinery for outline view (log what's dropped)
- [x] github project
- [x] source control
- [x] placeholder `readme.md` file
- [x] Add enough outline headers to remember delegate/datasource
- [x] notion of a transparent tool bar above editor
- [x] basic window (outline view, editor view)
- [x] editor window is 12pt Menlo
- [x] editor window has reasonable insets
- [x] sidebar limited in how big, small it can get
- [x] create the project


[hig]: https://developer.apple.com/design/human-interface-guidelines/macos/overview/themes/
[appicon]: https://developer.apple.com/design/human-interface-guidelines/macos/icons-and-images/app-icon/
