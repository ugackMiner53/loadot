# <img src="./loadot.svg" width="28px" height="32px"> Loadot
<sup><sub>A Godot modloader for those who want to do it themselves.</sub></sup>

**Loadot** is a Godot 4.x modloader based on [Godot ModLoader](https://github.com/GodotModding/godot-mod-loader) and inspired by [BepInEx](https://bepinex.dev).


## Installation
1. Download the latest release zip from the [releases] page.
2. Extract the contents of the zip into the same folder as the executable of the game you want to mod.
3. Start the game!

To install a mod, download the mod's .zip or .pck file and drop it into the `loadot/mods/` folder!

## Mod Development

### Mod File Structure

An exported Loadot mod file should either be a .zip or a .pck file, which is treated as a [Godot resource pack](https://docs.godotengine.org/en/stable/tutorials/export/exporting_pcks.html) and loaded on startup by Loadot.

Once loaded, an exported mod should have a `loadot/mods/MOD_NAME/` folder, containing a file named `main.gd`. This file will be loaded on startup by Loadot, and will be where all patches are registered for the game.

You can also arbitrarily overwrite any resource by including it in the mod file, but it is recommended to use patches if you are making minor changes to avoid copyright infringement.


### Mod Development Setup

1. Use [GDRE Tools](https://github.com/bruvzg/gdsdecomp/releases) to decompile the game.
2. Clone this repository into the game's decompilation folder (*do not replace `project.godot` if prompted*)
3. Add the following under the `[autoload]` section of `project.godot`:
```toml
[autoload]
Loadot="*res://loadot/core/globals.gd"
LoadotLoader="*res://loadot/core/loader.gd"
```
4. Open the decompilation folder in the Godot version detected by GDRE Tools
5. Create your mod!

### Creating a Mod

With a mod development environment setup, you can start creating a mod by making a folder inside `loadot/mods/` with the name of your mod. Then, add a file named `main.gd` inside with an `_init()` function. Code in here will be run when the mod loads.

<details><summary><i>Code Example</i></summary>

```swift
func _init():
    print("This is my mod!")
```

</details><br>

You can also use Loadot's builtin classes to get easier access to debugging tools like loggers.

<details><summary><i>Code Example</i></summary>

```swift
var logger = Loadot.Logger.new("MyMod")

func _init():
    logger.info("This is my mod!")
```

</details><br>

To load patches in your mod, you can use Loadot's registry in order to change the functionality of an existing class.

<details><summary><i>Code Example</i></summary>

`res://game_class.gd`
(An example script from a game that you're trying to mod.)
```swift
func start_game():
    self.health = 100
    self.stamina = 100
    self.setup_enemies()
```

`res://loadot/mods/mymod/game_class_patch.gd`
(Your patch for the above example script.)
```swift
extends "res://game_class.gd"

func start_game():
    super()
    self.health = 20000
```

The `super()` call above runs the original function from `game_class`, so you can choose to run code before or after the original function, or skip it alltogether by removing the `super()` call!

`res://loadot/mods/mymod/main.gd`
(The main script for your mod.)
```swift
var logger = Loadot.Logger.new("MyMod")

func _init():
    Loadot.Registry.register_patch("res://loadot/mods/mymod/game_class_patch.gd")
    logger.debug("Loaded game class patch!")
```

</details>

### Exporting a Mod

To export your mod, you have three options:
1. Exporting a custom .zip from Godot
2. Creating a custom .zip

**Method 1: Exporting a .pck or .zip from Godot**

Both of these methods are very similar, and involve using builtin functionality from Godot in order to export your mod as a resource pack.

1. Make sure you have an export template installed that allows exporting as a PCK/ZIP (the simplest one seems to be Linux).
2. Go to Export > Resources > Export Mode and choose "Export selected resources (and dependencies)".
3. Uncheck everything except for the resources that you want included in your mod (usually just the `loadot/mods/MOD_NAME` folder).
4. Export PCK/ZIP (you do not need to have debug enabled) to a file!

While you can stop here, there is an additional step for the first method to make sure that you are not distributing copyrighted content.

5. Make sure you export as a .zip, and open the zip after exporting. Delete any files from the zip that were automatically included by Godot during export.

That's it! Place the exported .pck/.zip file into `loadot/mods` in order to load it, or sent it to other people to distribute it!

**Method 2: Creating a custom .zip**

This method *does not* work with importing some assets. Use the other method of mod exporting if there are issues with loading resources during gameplay.

To create a custom zip file with your mod, you have to place your mod in a `loadot/mods/` folder, and make sure that `loadot/core` **does not** exist, deleting it if it does.

Then, zip the loadot folder and name it whatever you want. This can then be placed into `loadot/mods` to load it, or sent to other people to distribute it!

## Differences from other modloaders

**Compared to [Godot Modloader](https://github.com/GodotModding/godot-mod-loader)**

Godot Modloader is a mod loader for game creators and modders alike, allowing authors to easily add mod support into their games.
Loadot is entirely focused on "self setup", where official mod support is not provided for a game. While Godot Modloader supports self setup <sup>([link](https://github.com/GodotModding/godot-mod-loader/wiki/Mod-Loader-Self-Setup))</sup>, it requires more setup on the user's part, and the loader itself is more focused on the experience for game developers.

**Compared to [Godot Universal Mod Manager (GUMM)](https://github.com/KoBeWi/Godot-Universal-Mod-Manager)**

GUMM is a combination mod manager and mod loader that allows users to store, setup, and create mods for games.
Loadot tries to be as simple as possible to integrate with external mod managers like [r2modman](https://r2modman.com/), as well as being easier to maintain, and keep compatibility with more versions of Godot.

## Contributing
Contributions are welcome to the project! Open a [pull request]() and your changes should be reviewed shortly!

You can also contribute by using Loadot! Finding issues and reporting them in the [issues]() helps the project become better for everyone!

