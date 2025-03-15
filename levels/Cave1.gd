extends Node2D

func _ready():
	var tilemap = $CastleTileMap
	var map_rect = tilemap.get_used_rect()
	var cell_size = tilemap.cell_size
	var global_offset = tilemap.global_position
	var screen_resolution_multiplier = 2
	
	# Calculate how level size using tilemap position
	var camera_limits = {
		"left": map_rect.position.x * cell_size.x * screen_resolution_multiplier,
		"right": map_rect.end.x * cell_size.x * screen_resolution_multiplier,
		"top": map_rect.position.y * cell_size.y * screen_resolution_multiplier,
		"bottom": map_rect.end.y * cell_size.y * screen_resolution_multiplier
	}
	
	print("camera limits: ", camera_limits)
	# Pass these limits to the player/camera (e.g., via a signal or direct reference)
	$Player.setup_camera_limits(camera_limits)
	print("cell_size = ", cell_size)
	print("Tilemap Global Position:", tilemap.global_position)
	print("Tilemap Used Rect:", tilemap.get_used_rect())
	print("Tilemap Size (px):", tilemap.get_used_rect().size * tilemap.cell_size)




