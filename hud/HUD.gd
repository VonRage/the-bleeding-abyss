extends Control

onready var pause_state = get_tree().paused

onready var quit = $CanvasLayer/QuitButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_released("ui_pause"):
		pause()

# Pause and unpause the game
func pause():
	if pause_state == false:
		get_tree().paused = true
		quit.visible = true
	elif pause_state == true:
		get_tree().paused = false
		quit.visible = false

# Pause Menu Buttons
func _on_QuitButton_pressed():
	get_tree().quit()
