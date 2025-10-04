extends Node

var loader
var wait_frames
var time_max = 100 # msec
var current_scene
var loading_screen_scene = preload("res://transition-scenes/loading.tscn")
var loading_screen
var wait_for_input = false  # New variable
var loaded_scene = null  # Store the loaded scene

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	set_process(false)
	
## Loads a new scene with an optional loading screen[br]
## [br]
## Parameters:[br]
## - path: String - The resource path to the scene (e.g., "res://levels/level_1.tscn")[br]
## - require_button_press: bool - If true, waits for player input before transitioning after loading completes
func goto_scene(path, require_button_press = false):  # New parameter
	wait_for_input = require_button_press
	loaded_scene = null
	loader = ResourceLoader.load_interactive(path)
	if loader == null:
		show_error()
		return
	
	set_process(true)
	current_scene.queue_free()
	show_loading_screen()
	wait_frames = 1

func show_loading_screen():
	loading_screen = loading_screen_scene.instance()
	get_tree().get_root().add_child(loading_screen)

func hide_loading_screen():
	if loading_screen:
		loading_screen.queue_free()
		loading_screen = null

func update_progress():
	if loading_screen:
		var progress = float(loader.get_stage()) / loader.get_stage_count()
		var progress_bar = loading_screen.get_node("ColorRect/ProgressBar")
		progress_bar.value = progress * 100

func _process(_delta):
	if loader == null:
		# Check if we're waiting for input
		if wait_for_input and loaded_scene != null:
			if Input.is_action_just_pressed("ui_accept"):  # Change to your button
				set_new_scene(loaded_scene)
				wait_for_input = false
				loaded_scene = null
		else:
			set_process(false)
		return

	# Wait for frames to let the loading screen show up
	if wait_frames > 0:
		wait_frames -= 1
		return

	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + time_max:
		var err = loader.poll()

		if err == ERR_FILE_EOF:  # Finished loading
			var resource = loader.get_resource()
			loader = null
			
			if wait_for_input:
				# Store the scene and show "Press button to continue"
				loaded_scene = resource
				show_continue_prompt()
			else:
				# Load immediately
				set_new_scene(resource)
			break
		elif err == OK:
			update_progress()
		else:  # Error during loading
			show_error()
			loader = null
			break

func show_continue_prompt():
	if loading_screen:
		# Update your loading screen to show "Press [Button] to Continue"
		# Adjust path to match your scene structure
		var progress_bar = loading_screen.get_node("ColorRect/ProgressBar")
		progress_bar.value = 100
		# If you have a label, update it:
		# loading_screen.get_node("ColorRect/Label").text = "Press X to Continue"

func set_new_scene(scene_resource):
	current_scene = scene_resource.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
	hide_loading_screen()

func show_error():
	push_error("Failed to load scene")
	hide_loading_screen()
	set_process(false)
