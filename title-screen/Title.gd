extends Node2D


onready var current_track = $MindsEye1
onready var fade_timer = $FadeOutTimer
onready var button_sound = $TitleScreen/Control/StartButton/PressedSound


func _ready():
	#SceneLoader.load_scene_async("res://transition-scenes/NewGameIntro.tscn")
	pass

func _process(delta):
	
	# Checking if "Play" button is pressed
	if Input.is_action_just_pressed("ui_accept"):
		_on_Button_pressed()


func _on_Button_pressed():
	#Clicky sound does click
	button_sound.play()
	# Start music fade out
	fade_timer.start()
	fade_music_out()
	# Waits for the fade out to finish before performing next action
	yield(fade_timer, "timeout")


func fade_music_out():
	# Tweening the music to fade out
	var tween = create_tween()
	tween.tween_property(current_track, "volume_db", -80.0, 5)


func _on_MindsEye1_finished():
	#Changing music track
	current_track = $MindsEye2
	$MindsEye2.play()


func _on_MindsEye2_finished():
	#Changing music track
	current_track = $MindsEye3
	$MindsEye3.play()


func _on_MindsEye3_finished():
	#Changing music track
	current_track = $MindsEye1
	$MindsEye1.play()


func _on_FadeOutTimer_timeout():
	SceneLoader.goto_scene("res://levels/Cave.tscn")
