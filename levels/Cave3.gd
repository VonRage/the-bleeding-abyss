extends Node2D

func _ready():
	var tilemap = $CastleTileMap
	var map_rect = tilemap.get_used_rect()
	var cell_size = tilemap.cell_size
	var global_offset = tilemap.global_position
	# Sometimes needed and idk why
	var screen_resolution_multiplier = 2
	
	# Calculate how level size using tilemap position
	var camera_limits = {
		"left": map_rect.position.x * cell_size.x,
		"right": map_rect.end.x * cell_size.x,
		"top": map_rect.position.y * cell_size.y,
		"bottom": map_rect.end.y * cell_size.y
	}
	
	$Player.setup_camera_limits(camera_limits)
