# Based on script extension from Delta V and GodotModding

static func inject_script(script_path : String) -> Script:


    var child_script : Script = load(script_path)

    child_script.set_meta("injected_script_path", script_path)

    child_script.new()

    var parent_script : Script = child_script.get_base_script()
    var parent_script_path = parent_script.resource_path

    # Here we want to store the fact that we're injecting so we can do a dependency chain

    # This is just for testing
    child_script.take_over_path(parent_script_path)
    return child_script