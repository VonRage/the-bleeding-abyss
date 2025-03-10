extends Node2D

var current_saved_level = "Castle"

onready var current_track = $MindsEye1
onready var fade_timer = $FadeOutTimer
onready var button_sound = $TitleScreen/Control/StartButton/PressedSound

func load_level(level_name):
	get_tree().change_scene("res://levels/%s.tscn" % level_name)

func _on_Button_pressed():
	button_sound.play()
	fade_timer.start()
	fade_music_out()
	yield(fade_timer, "timeout")
	load_level(current_saved_level)

func fade_music_out():
	var tween = create_tween()
	tween.tween_property(current_track, "volume_db", -80.0, 10)

func _on_MindsEye1_finished():
	current_track = $MindsEye2
	$MindsEye2.play()
	print_debug("Song 2")

func _on_MindsEye2_finished():
	current_track = $MindsEye3
	$MindsEye3.play()
	print_debug("Song 3")

func _on_MindsEye3_finished():
	current_track = $MindsEye1
	$MindsEye1.play()
	print_debug("Song 1")
