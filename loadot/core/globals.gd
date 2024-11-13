extends Node

var Logger : Script = load("res://loadot/core/logger.gd")

# Unfortunately, we have to instance this here because Godot 4.0 did not have static variables
# This can be avoided by not supporting Godot 4.0
var Registry : Script = load("res://loadot/core/registry.gd").new()


# This should be merged with 
var Injector : Script = load("res://loadot/core/injector.gd")