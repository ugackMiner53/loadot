extends Node

var logger = Loadot.Logger.new("Loadot")

const MOD_DIR = "loadot/mods/"

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
            logger.debug("Folder loading currently unsupported. Skipping %s" % directory)            

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
    
    for directory in mod_dir.get_directories(): 
        var mod_main := mod_directory.path_join(directory).path_join("main.gd")
        if FileAccess.file_exists(mod_main):
            load(mod_main).new()
            logger.debug("Loaded %s" % directory)
        else:
            logger.warning("Folder %s does not have main.gd! Skipping..." % directory)


func local_folder_dir(subfolder := "") -> String:
    var game_install_directory := OS.get_executable_path().get_base_dir()

    if OS.get_name() == "macOS":
        game_install_directory += "/../Resources"

    return game_install_directory.path_join(subfolder)