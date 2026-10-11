extends SceneTree
func _initialize() -> void:
	var file:=FileAccess.open("res://builds/GODOT-LICENSES.txt",FileAccess.WRITE)
	file.store_string("Godot Engine\n\n"+Engine.get_license_text()+"\n\n")
	file.store_string(JSON.stringify(Engine.get_copyright_info(),"  ")+"\n\n")
	file.store_string(JSON.stringify(Engine.get_license_info(),"  "))
	file.close()
	quit()
