# touch project.godot && godot -s gd.gd --headless

extends SceneTree

func _init():
	DirAccess.open("res://").make_dir("scripts")
	var file = FileAccess.open("res://scripts/main.gd", FileAccess.WRITE)
	file.store_line("class_name Main")
	file.store_line("extends Node")
	file.close()

	var node = Node.new()
	node.name = "node"
	node.set_script(load("res://scripts/main.gd"))

	var packed_scene = PackedScene.new()
	packed_scene.pack(node)
	ResourceSaver.save(packed_scene, "res://main.tscn")
	node.queue_free()

	var config = ConfigFile.new()
	config.set_value("application", "run/main_scene", "res://main.tscn")
	config.set_value("application", "run/max_fps", 60)
	config.set_value("display", "window/stretch/mode", "viewport")
	config.set_value("display", "window/size/viewport_width", 2000)
	config.set_value("display", "window/size/viewport_height", 1000)
	config.set_value("display", "window/size/window_width_override", 200)
	config.set_value("display", "window/size/window_height_override", 100)
	config.set_value("input_devices", "pointing/emulate_touch_from_mouse", true)
	config.save("res://project.godot")

	quit()
