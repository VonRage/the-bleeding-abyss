extends Node2D

var level_instance = "res://title-screen/Title.tscn"

func unload_level():
	if (is_instance_valid(level_instance)):
		#level_instance.queue_free()
		#level_instance = null
		print_debug("work")

func load_level(level_name : String):
	unload_level()
	var level_path := "res://world-1/%s.tscn" % level_name
	var level_resource := load(level_path)
	if (level_resource):
		level_instance = level_resource.instance()
		self.add_child(level_instance)

func _on_Button_pressed():
	load_level("Castle")
