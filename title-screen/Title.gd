extends Node2D

var level_instance
var current_saved_level = "Castle"

func load_level(level_name : String):
	get_tree().change_scene("res://levels/%s.tscn" % level_name)

func _on_Button_pressed():
	load_level(current_saved_level)
