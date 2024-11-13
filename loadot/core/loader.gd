extends Node

const MOD_DIR = "loadot/mods/"

var logger = Loadot.Logger.new("Loadot")
var unpacked_directories : PackedStringArray = []

func _init():
    logger.debug("Starting Loadot Loader...")

    # Read in all mods from /loadot/mods/*
    load_packed_mods(local_folder_dir(MOD_DIR))
    
    # Start running mods from res://loadot/mods/*/main.gd
    load_mods("res://%s" % MOD_DIR)

# Gets all *.pck and *.zip files from directory and loads them as resource pack
func load_packed_mods(packed_directory : String):
    var mod_dir = DirAccess.open(packed_directory)
    if mod_dir:
        for directory in mod_dir.get_directories():
            directory = packed_directory.path_join(directory)
            logger.debug("Loading unpacked directory %s" % directory)
            unpacked_directories.append(directory) 

        for file in mod_dir.get_files():
            file = packed_directory.path_join(file)
            logger.debug("Loading file %s" % file)
            if file.ends_with(".pck") or file.ends_with(".zip"):
                ProjectSettings.load_resource_pack(file)
    else:
        logger.error("Packed mod directory %s not found!" % packed_directory)

func load_mods(mod_directory : String):
    var mod_dir = DirAccess.open(mod_directory)
    if not mod_dir:
        logger.error("Mod directory %s not found!" % mod_directory)
        return

    # Godot 4.4+ function to list folders in Resources instead of DirAccess (see https://github.com/godotengine/godot/pull/96590)
    # Commented out because it's unclear if FileAccess 
    # if ResourceLoader.has_method("list_directory"):
    #    directories = ResourceLoader.call("list_directory", mod_directory)


    # Load packed mods
    for directory in mod_dir.get_directories(): 
        logger.debug("Found mod %s, loading..." % directory)
        load_mod(mod_directory.path_join(directory))
    
    # Load unpacked mods
    for directory in unpacked_directories:
        logger.debug("Found debug mod %s, loading..." % directory)
        logger.warning("Unpacked mods do not overwrite builtin files. Pack the mod into a .zip to overwrite files.")
        load_mod(directory)


func load_mod(mod_path : String):
    var mod_main := mod_path.path_join("main.gd")
    if ResourceLoader.exists(mod_main):
        load(mod_main).new()
    else:
        logger.warning("%s does not exist! Skipping..." % mod_main)


func local_folder_dir(subfolder := "") -> String:
    var game_install_directory := OS.get_executable_path().get_base_dir()

    if OS.get_name() == "macOS":
        game_install_directory += "/../Resources"

    return game_install_directory.path_join(subfolder)