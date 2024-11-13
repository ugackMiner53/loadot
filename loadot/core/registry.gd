# Loadot Registry, for accessing mod details and other information

var mods : Array[ModResource] = []



class ModResource extends Resource:
    var id : String
    var name : String
    var version : String

    func _init(_id : String, _name := _id, _version := "1.0.0") -> void:
        id = _id
        name = _name
        version = _version




func register_mod(id : String, name : String, version : String):
    var mod = ModResource.new(id, name, version)
    mods.append(mod)


func register_script_extension(_script : Script) -> void:
    # Register script extension here
    pass