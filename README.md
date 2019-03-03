## GCS - Global Color Scheme

GCS is a tool to change the color scheme of your Linux desktop. It can take care of general purpose toolkits (like GTK) as well as specific applications which have their own color settings. The purpose of GCS is to configure every configurable color in your desktop in a consistent manner and with a single command.


![Preview](preview.gif?raw=true "Preview")

GCS is easily extensible, so if some program you use is not supported, you can easily create a module for it (details are in MODULES-HOWTO.md).

### Installation
``` sudo make install```

GCS is installed under ```/usr/local```

### Dependencies
The following tools are required:

* ```sed``` - used extensively for text substitution
* ```oomox``` - used for gtk+ theming (available [here](https://github.com/actionless/oomox))
* ```crudini``` - used for editing ini-style configuration files
* ```xmlstarlet``` - used for editing XML configuration files
* ```dconf```, ```gsettings``` - used for editing configuration of GNOME programs

### Usage
When invoked, GCS can perform one of three actions: apply a theme, make a backup of the current configuration, and restore an existing backup. These three actions are mutually exclusive.

To apply a color theme:
```
gcs [options] <color_theme_name>
```

To create a backup:
```
gcs [options] -b <backup_name>
```

To restore a backup:
```
gcs [options] -r <backup_name>
```

By default, these actions call as many available modules as possible. If a module is disabled from the configuration file, or if it's disaled by default, it will not be called in any case.

For all the three actions, it is possible to restrict operation to a single module using the ```-m <module_name>``` option.

For the first action (apply a theme), the -n flag performs a "dry run": no action is actually executed, each module just briefly describes what it would do to apply a theme.

TAB completion for options, theme names, backup names, and module names is suppported in bash using the provided completion file.

There is also an option to import themes designed in Oomox (which easier and less error-prone than writing them by hand). The syntax is as follows:
```
gcs -i <theme_name>
```
More details are given in THEMES-HOWTO.md.


```gcs -h``` shows an help screen with a summary of this information, and also lists available themes and modules.

```gcs -m <module_name> -h``` shows a module-specific help screen, describing what it does, how it works, and possible caveats.


### Warnings

GCS directly manipulates the configuration files of other programs!
This might have unexpected consequences. While I've been using it for quite some time and it works reliably for me, you should use it with care. Be sure to always have a backup of the involved configuration files, either with the embedded backup functionality or otherwise.

For first-time users, the recommended workflow is as follows:

* Make a full backup: ```gcs -b first_backup```. The files are saved in $HOME/.local/gcs/backups/first_backup, sorted in subdirectories for each module. Take note of which modules are used.
* Apply a theme, one module at a time e.g. ```gcs -m gtk clearlooks```. See if it works correctly, or if you need to tweak. If you're in trouble, restore the configuration from the backup, e.g. ```gcs -m gtk -r first_backup```. As a last resort, disable the module by creating/editing the configuration file $HOME/.config/gcs/gcs.conf. For the ```gtk``` module, you should add the following text (for other modules, change the heading name):
```
[gtk]
enable=false
```
* When you are sure that everything works as intended, you can apply new themes using all the modules at once: ```gcs <theme_name>```

Finally, remember that the built-in backup functionality restores entire files as they were when the backup took place. If you made any modifications in the meantime, they will be lost.

