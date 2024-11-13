extends Node

var Logger : Script = load("res://loadot/core/logger.gd")

# Unfortunately, we have to instance this here because Godot 4.0 did not have static variables
# This can be avoided by not supporting Godot 4.0
var Registry : Script = load("res://loadot/core/registry.gd").new()


# This should likely be merged with registry at some point
var Injector : Script = load("res://loadot/core/injector.gd")