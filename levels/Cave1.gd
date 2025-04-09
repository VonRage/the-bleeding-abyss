extends Node2D


const SHADER_OFFSET_X = 480
const SHADER_OFFSET_Y = 276

var camera_limits : Dictionary


func _ready():
	var tilemap = $DarkStoneTileMap
	var map_rect = tilemap.get_used_rect()
	var cell_size = tilemap.cell_size
	var scale_mult = tilemap.scale
	
	# Calculate level size using tilemap position
	camera_limits = {
		"left": map_rect.position.x * cell_size.x * scale_mult.x,
		"right": map_rect.end.x * cell_size.x * scale_mult.x,
		"top": map_rect.position.y * cell_size.y * scale_mult.y,
		"bottom": map_rect.end.y * cell_size.y * scale_mult.y
	}
	
	# Pass these limits to the player/camera
	$Player.setup_camera_limits(camera_limits)
	
func _process(delta):
	$CRTShader.rect_position.x = clamp($Player.global_position.x - SHADER_OFFSET_X, camera_limits["left"], camera_limits["right"])
	$CRTShader.rect_position.y = clamp($Player.global_position.x - SHADER_OFFSET_Y, camera_limits["top"], camera_limits["bottom"])

