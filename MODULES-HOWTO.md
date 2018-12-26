## GCS Modules documentation

This documents describes how GCS modules work, for developers who want to crate them. A GCS module consists of a bash script defining some functions with well-known names. Some functions may not apply to all modules, but they should always be defined to avoid problems.

The following functions are currently recognized:

* ```init_module```

* ```check_dependencies```

* ```derive_colors```

* ```apply_theme```

* ```create_backup```

* ```restore_backup```

* ```dry_run```

Modules may also define functions for their internal use. To avoid name clashes, it is recommended to prepend the function names with the module name in this case.

### init_module
This function performs some initialization tasks. In most cases, it reads values from the GCS configuration file, e.g. whether to enable or disable a module, and defines appropriate default values for them. It may also define some string constants that are needed in other functions.

```init_module``` is always executed for all the modules (unless the ```-m``` option is used), even if they are disabled from the configuration file. Thus, it should not perform any real action on configuration files or other parts of the system.

As an example, the ```init_module``` function for the ```gpicview``` module follows:

```
function init_module() {
    GPICVIEW_ENABLE_DEFAULT="true"
    GPICVIEW_CONFIG_FILE_DEFAULT="$HOME/.config/gpicview/gpicview.conf"

    GPICVIEW_ENABLE="$(crudini      --get ${GCS_CONFIG_FILE} gpicview enable      2>/dev/null || echo "${GPICVIEW_ENABLE_DEFAULT}")"
    GPICVIEW_CONFIG_FILE="$(crudini --get ${GCS_CONFIG_FILE} gpicview config_file 2>/dev/null || echo "${GPICVIEW_CONFIG_FILE_DEFAULT}")"
}
```

### check_dependencies
This function decides whether the module should be run or not. It must return 0 to indicate that the module should be run, and non-zero otherwise. Possible reasons to skip a module include:

* the module is disabled from the GCS configuration file or by its default setting;
* the target program, or another required program, is not installed;
* a target configuration file can't be found;

As an example, the ```check_dependencies``` function for the ```gpicview``` module follows:

```
function check_dependencies() {
    if ! which gpicview >/dev/null; then
        return 1

    elif ! [ "${GPICVIEW_ENABLE}" == "true" ]; then
        printf "* Ignoring gpicview (disabled from configuration).\n"
        return 1

    elif ! [ -f "${GPICVIEW_CONFIG_FILE}" ]; then
        printf "* Ignoring gpicview (configuration file \"${GPICVIEW_CONFIG_FILE}\" not found).\n"
        return 1

    else
        return 0

    fi
}
```

### derive_colors
This functions defines the colors to be used in the module, by inheriting them from colors defined in GCS. It is run after ```check_dependencies``` and before ```apply_theme```, and only if the action to perform is to apply a color theme. It is not run  when creating or restoring a backup.

Every module should only use module-specific color names, defined in its ```derive_colors``` function. The recommended way to enforce this is to use the module name as a prefix for module-specific color names.

Themes may define the module-specific color names, but it should be avoided if possible. To make this possible, the ```derive_colors``` function should only assign values to module-specific vaiables only if they are still empty (e.g. use ```example_bg_color=${example_bg_color:.${base_color}}```).

As an example, the ```derive_colors``` function for the ```gpicview``` module follows:

```
function derive_colors() {
    : ${gpicview_bg_color:=${base_color}}
    : ${gpicview_bg_full_color:=${base_color}}
}
```

### apply_theme
This function performs the main action: it modifies configuration files, the GSettings registry, or enything else that is needed to apply the desired colors to the target program.

There aren't many general rules here, as the required actions depend on the specific application. However, in most cases they involve setting some key to a desired value in a text-based files. For this, two helper functions are defined in GCS:

* ```set_value```: it can be used for text files that are not structured in sub-sections, where each line contains a key, a separator, and the corresponding value. The syntax is: ```set_value KEY_NAME SEPARATOR VALUE FILE_NAME```.

* ```set_value_section```: it can be used for text files that are structured in sub-sections, delimited by headers such as ```[section_name]```. Similarly to ```set_value```, each line in a section contains a key, a separator, and the corresponding value. The syntax is: ```set_value_section SECTION_NAME KEY_NAME SEPARATOR VALUE FILE_NAME```.

```set_value``` and ```set_value_section``` may not work as intended in all cases, so it advised to test their use extensively and always have backups. Alternatively, the ```crudini``` command is suggested to read and/or modify ini-style configuration files (refer to its documentation for more details).

When modify a configuration file, it is recommended to make a copy of it in a temporary directory (e.g. create one under ${GCS_TMP_DIR}), modify it, and copy it back over the original. This reduces the possibility of leaving the configuration file in an inconsistent state if GCS is interrupted by e.g. a ctrl+C keypress.

As an example, the ```apply_theme``` function for the ```gpicview``` module follows:

```
function apply_theme() {
    printf "* Setting colors for gpicview..."

    GPICVIEW_TMP_DIR="${GCS_TMP_DIR}/gpicview"
    GPICVIEW_TMP_CONFIG_FILE="${GPICVIEW_TMP_DIR}/gpicview.conf"
    mkdir "${GPICVIEW_TMP_DIR}"
    cp "${GPICVIEW_CONFIG_FILE}" "${GPICVIEW_TMP_CONFIG_FILE}"

    set_value "bg"      "=" "${gpicview_bg_color}"      "${GPICVIEW_TMP_CONFIG_FILE}"
    set_value "bg_full" "=" "${gpicview_bg_full_color}" "${GPICVIEW_TMP_CONFIG_FILE}"

    mv "${GPICVIEW_TMP_CONFIG_FILE}" "${GPICVIEW_CONFIG_FILE}"

    printf " done.\n"
}
```

### create_backup
This function is used to make a backup of configuration files and/or other information, so that they can be restored later. It is only run when the ```-b``` switch is used. The backup shoud only contain files or other stuff that is modified by ```apply_theme```, to safeguard against accidental corruption.

```create_backup``` should create a module-specific directory under "${GCS_BACKUPS_DIR}/${GCS_BACKUP_NAME}/", and save everything that is needed there.

As an example, the ```create_backup``` function for the ```gpicview``` module follows:

```
function create_backup() {
    printf "* Making backup of gpicview configuration file..."

    GPICVIEW_BACKUP_DIR="${GCS_BACKUPS_DIR}/${GCS_BACKUP_NAME}/gpicview"
    mkdir -p "${GPICVIEW_BACKUP_DIR}"
    cp "${GPICVIEW_CONFIG_FILE}" "${GPICVIEW_BACKUP_DIR}/gpicview.conf"

    printf " done.\n"
}
```

### restore_backup
This function takes  the files and information saved by ```create_backup``` and puts them back at the original place. It is only run when the ```-r``` switch is used. The files to use can be found in the same place where ```create_backup``` left them, i.e. in the same module-specific directory under "${GCS_BACKUPS_DIR}/${GCS_BACKUP_NAME}/". However, as a good measure, they should be checked for existence before using.

As an example, the ```restore_backup``` function for the ```gpicview``` module follows:

```
function restore_backup() {
    printf "* Restoring backup of gpicview configuration file..."

    GPICVIEW_BACKUP_DIR="${GCS_BACKUPS_DIR}/${GCS_BACKUP_NAME}/gpicview"
    if [ -f "${GPICVIEW_BACKUP_DIR}/gpicview.conf" ]; then
        cp "${GPICVIEW_BACKUP_DIR}/gpicview.conf" "${GPICVIEW_CONFIG_FILE}"
        printf " done.\n"
    else
        printf " not found!\n"
    fi
}
```

### dry_run
This function is run when the  ```-n``` option is used, instead of ```derive_colors``` and ```apply_theme```. It should not perform any action. Instead, it should print a generic description of what the ```apply_theme``` function would do without the ```-n``` switch (e.g. modify a particular configuration file, GSettings key, or else).

As an example, the ```dry_run``` function for the ```gpicview``` module follows:

```
function dry_run() {
    printf "* gpicview: set background color in \"${GPICVIEW_CONFIG_FILE}\".\n"
}
```