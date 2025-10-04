extends Node

signal scene_loaded

var loader: ResourceInteractiveLoader = null
var next_scene: PackedScene = null
var loading_path: String = ""
var loading: bool = false

func load_scene_async(path: String) -> void:
	if loading:
		push_warning("Already loading a scene.")
		return
	
	loading = true
	loading_path = path
	loader = ResourceLoader.load_interactive(path)

	if loader == null:
		push_warning("Failed to start loading: %s" % path)
		loading = false
		return

	# Start polling in background
	_poll_scene_load()

func _poll_scene_load() -> void:
	if loader == null:
		return
	
	# Poll one step per frame
	while true:
		var err = loader.poll()
		if err == OK:
			next_scene = loader.get_resource()
			loader = null
			loading = false
			# Change the scene here, or emit a signal if you want to trigger transition elsewhere
			get_tree().change_scene_to(next_scene)
			emit_signal("scene_loaded", loading_path)
			break
		elif err == ERR_BUSY:
			yield(get_tree(), "idle_frame")
		else:
			push_warning("Error while loading scene: %s" % err)
			loader = null
			loading = false
			break
