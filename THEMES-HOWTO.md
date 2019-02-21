## GCS Themes documentation

GCS Color themes (or just "themes") describe how the desktop should look. This refers mainly to the UI colors, but some other details are covered too, such as the desktop wallpaper, the icon theme, and the cursor theme.

There is a large number of colors that can be specified, and some of them are derived implicitly from other colors if not given explicitly. For simplicity, they can be grouped as follows:

* Generic UI colors
* base16 colors
* Syntax highlighting colors
* Window manager colors
* Terminal emulator colors
* Other variables

All of these groups and their relationships are described in more detail later. Additionally, each module derives module-specific colors from the theme colors (e.g. `gtk_base_color` is derived from `base_color`). Themes may also define module-specific colors directly, but this should be avoided unless there is no other way to achieve the desired result.

Theme files are plain text files containing a series of variable declaration in the form `variable=value`. The given value can be quoted of unquoted (e.g., both `text_color=#ffffff` and `text_color="#ffffff"` are fine). The values for variables that hold a color can be expressed in one of two ways:

* an explicit RGB color in hex notation, e.g. `#f63401`
* the value of an existing variable, in standard shell notation, e.g. `${text_color}`

Given a theme name, GCS looks for its implementation in the system-wide path first (`/usr/share/gcs/colorthemes`), then in the local path (`/usr/local/share/gcs/colorthemes`), and finally in the user-specific path (`${HOME}/.local/share/gcs/colorthemes`). The theme file must be named `colortheme` and it must be placed in a sub-directory with the same name of the theme. For example, a theme named `example` can be placed in the file `/usr/share/gcs/colorthemes/example/colortheme`, or in `/usr/local/share/gcs/colorthemes/example/colortheme`, or in `${HOME}/.local/share/gcs/colorthemes/example/colortheme`.

If more than one valid file is available for the same theme, they are parsed in order from the least specific (system-wide) to the most specific (user-specific), and variables that are definedd multiple times get the most specific value. This way, a user can customize some details of a theme by only specifying the desired changes with respect to the original theme.


### Generic UI colors

These colors are intendes for generic UI elements, such as window frames, content, text, etc. The most important are the following:

* `base_color`: background color of window content (e.g. text areas).
* `text_color`: text color of window content.
* `bg_color`: background color of window frame (e.g. toolbars, menubar).
* `fg_color`: text color of window frame.
* `selected_bg_color`: background color of selected elements (e.g. selected text).
* `selected_fg_color`: text color of selected elements.

These can't be derived by any other color, thus they are the absolute minimum requirement for a working theme, together with terminal colors or (alternatively) the name of a base16 theme.

The following colors also fall in this category:

* `tooltip_fg_color`: text color of tooltips.
* `tooltip_border_color`: border color of tooltips.
* `tooltip_bg_color`: background color of tooltips.
* `link_color`: color of active hypertext links.
* `link_visited_color`: color of visited hypertext links.
* `error_color`: color to indicate errors.
* `warning_bg_color`: color to indicate warnings.

### base16 colors

base16 is an independent project describing a set of guidelines to construct and apply syntax highlighting schemes. GCS can take advantage of existing base16 schemes, and use them to derive colors for its own use.

There are two ways to define a base16 scheme in GCS:

* declare its name in the `base16_scheme` variable (valid names are those listed in https://github.com/chriskempson/base16-schemes-source/blob/master/list.yaml)
* declare the 16 colors individually, from `base00` to `base0F`, possibly following the guidelines at https://github.com/chriskempson/base16/blob/master/styling.md.

Using a base16 scheme is optional, and it is provided as a simpler way to cover both the "syntax highlighting" and "terminal emulator" categories without much effort. When a base16 scheme is provided, it is not necessary to define explicit colors for them, however it is still possible to do so (these definitions will override the colors derived from the base16 scheme).

If a base16 scheme is not provided, then terminal colors should be defined explicitly as they have no defaults. As for syntax highlighting, it is possible to define the colors explicitly or neglect such category (see the dedicated section).

### Syntax highlighting colors

Variables in this category define colors for syntax highlighting of code in supported IDEs and text editors. These are derived from base16 colors if a base16 scheme is defined, and no further definition is required for this category. If it is not defined, syntax highlighting is controlled by the `editor_syntax_enable` variable.

By default, `editor_syntax_enable` is set to `false`. In this situation, GCS applies the default colors of each editor/IDE, and the theme does not need to define any syntax highlighting colors.

When the theme sets `editor_syntax_enable` to `true`, it should also define variables for syntax highlighting. Some of them can be derived from other colors, while some should necessarily be specified in the theme.

The following variables are currently recognized (there may be differences in how different editors/IDEs use them):

* `editor_bg`: background color for text area (default: `base_color`).
* `editor_fg`: text color for text area (default: `text_color`).
* `editor_selected_bg`: background color for selected text (default: `selected_bg_color`).
* `editor_selected_fg`: text color for selected text (default: `selected_fg_color`).
* `editor_frame_bg`: background color for parts of the window frame (default: `bg_color`).
* `editor_frame_fg`: text color for parts of the window frame (default: `fg_color`).
* `editor_current_line_bg`: background color of the current line (default: `bg_color`).
* `editor_indent_guide`: color for indentation guides (default: `editor_string`, if defined in the theme).
* `editor_long_line_marker`: color for the marker indicating the recommended maximum line length (default: `editor_current_line_bg`).
* `editor_caret`: color for the caret (default: `text_color`).
* `editor_error`: color indicating incorrect syntax (default: `error_color`).
* `editor_brace_bad`: color indicating non-matching brackets (default: `error_color`).
* `editor_variable`: color for code variables (default: `editor_class`, if defined by the theme).
* `editor_comment`: color for comment lines or blocks (no default).
* `editor_white_space`: color for symbols indicating white spaces (default: `editor_comment`, if defined by the theme).
* `editor_number`: color for literal numerical quantities appearing in code (no default).
* `editor_string`: color for literal strings (no default).
* `editor_brace_good`: color for correctly matching brackets (default: `editor_string`, if defined by the theme).
* `editor_keyword`: color for language keywords (default: `selected_bg_color`).
* `editor_operator`: color for language operators (no defaults).
* `editor_preprocessor`: color for preprpcessor macros (no default).
* `editor_section_header`: color for section headers (default: `editor_preprocessor`).
* `editor_class`: color for class names (no default).
* `editor_character`: color for character constants (default: `editor_number`).
* `editor_tag`: color for tags in markup languages (no default).
* `editor_tag_unknown`: color for unknown tags in markup languages (no default).
* `editor_tag_end`: color for tag end in markup languages (no default).
* `editor_attribute`: color for tag attributes in markup languages (no default).
* `editor_attribute_unknown`: color for unknown tags in markup languages (no default).
* `editor_value`: color for attribute values in markup languages (no default).
* `editor_entity`: color for entities in markup languages (no default).
* `editor_diff_added`: color for lines added in diffs (no default).
* `editor_diff_removed`: color for lines removed in diffs (no default).
* `editor_diff_changed`: color for lines changed in diffs (no default).

### Window manager colors

This category includes colors that in most cases are relevant only to window managers, i.e. for title bars and tray bars. They are optional, as they can be derived from other colors. The following colors are recognized:

* `titlebar_urgent_bg_color`: background color for the titlebar of windows marked as "urgent".
* `titlebar_urgent_fg_color`: text color for the titlebar of windows marked as "urgent".
* `titlebar_focused_bg_color`: background color for the titlebar of the focused window.
* `titlebar_focused_fg_color`: text color for the titlebar of the focused window.
* `titlebar_unfocused_bg_color`: background color for the titlebar of unfocused windows.
* `titlebar_unfocused_fg_color`: text color for the titlebar of unfocused windows.
* `tray_bg_color`: background color for the tray bar.
* `tray_fg_color`: text color for the tray bar.
* `tray_focused_bg_color`: background color for the focused item on the tray bar.
* `tray_focused_fg_color`: text color for the focused item on the tray bar.
* `tray_unfocused_bg_color`: background color for unfocused items on the tray bar.
* `tray_unfocused_fg_color`: text color for unfocused items on the tray bar.
* `tray_urgent_bg_color`: background color for items marked as "urgent" on the tray bar.
* `tray_urgent_fg_color`: text color for items marked as "urgent" on the tray bar.

### Terminal emulator colors

This category contains colors that apply to terminal emulators. For some terminals, only the background color (`terminal_bg_color`) and the text color (`terminal_fg_color`) can be changed. For others, it is possible to change the complete palette, consisting of the following colors:

* `terminal_palette_red`
* `terminal_palette_yellow`
* `terminal_palette_green`
* `terminal_palette_cyan`
* `terminal_palette_blue`
* `terminal_palette_purple`
* `terminal_palette_light_red`
* `terminal_palette_light_yellow`
* `terminal_palette_light_green`
* `terminal_palette_light_cyan`
* `terminal_palette_light_blue`
* `terminal_palette_light_purple`

If a base16 scheme is used, these colors are sett automatically, although the light and non-light variants are identical. Otherwise, the theme must set them manually.

For some terminals it is also possible to make the background color semi-transparent. This is controlled by the `terminal_opacity` variable, which can range from 0 (full transparency) to 1 (full opacity).

### Other variables

This category includes elements that affect the overall look of the desktop. These are not directly related to colors, but they can be matched using e.g. color variations.

First, there are variables related to the desktop wallpaper. `wallpaper_image` contains the name of an image file to be used as a wallpaper. It should be relative to the directory where the theme file is. `wallpaper_mode` describes how the wallpaper image should be resized. Possible values are:

* "centered": image is positioned in the middle of the screen, without resizing.
* "tiled": repeat the image multiple time to fill the desktop area.
* "stretched": resize the image to the desktop size, possibly changing the aspect ratio.
* "zoom-fit": the image is centered and resized as much as possible, without exceeding the screen size and preserving the aspect ratio.
* "zoom-fill": the image is centered and resized as much as possible, so as to fill the entire screen, and preserving the aspect ratio.

If part of the desktop is not covered by the wallpaper, its color can be st via the `wallpaper_bg_color` variable. Additionally, the color for the text and shadow of desktop icons can be set via the `wallpaper_text_color` and `wallpaper_shadow_color` variables, respectively.

The `icon_theme_name` variable sets the icon theme to be used in the applications. The value should be the name of the desired icon theme, as it appears in other theming applications (e.g. "Adwaita"). This variable can be used to set an icon theme whose colors match those of the overall theme.

Similarly, `cursor_theme_name` sets the desired cursor theme. The value should be the name of a cursor theme, as it appears in other theming applications.
