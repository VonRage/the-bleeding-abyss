extends Node2D

signal set_location

const SHADER_OFFSET_X = 480
const SHADER_OFFSET_Y = 276

var body_standin = load("res://Player/BodyStandin.tscn").instance()
var head_standin = load("res://Player/HeadStandin.tscn").instance()
var camera_limits : Dictionary


func _ready():
	var tilemap = $DarkStoneTileMap
	var map_rect = tilemap.get_used_rect()
	var cell_size = tilemap.cell_size
	var screen_resolution_multiplier = 2
	
	# Calculate level size using tilemap position
	camera_limits = {
		"left": map_rect.position.x * cell_size.x * screen_resolution_multiplier,
		"right": map_rect.end.x * cell_size.x * screen_resolution_multiplier,
		"top": map_rect.position.y * cell_size.y * screen_resolution_multiplier,
		"bottom": map_rect.end.y * cell_size.y * screen_resolution_multiplier
	}
	
	# Pass these limits to the player/camera
	$Player.setup_camera_limits(camera_limits)
	
func _process(delta):
	$CRTShader.rect_position.x = clamp($Player.global_position.x - SHADER_OFFSET_X, camera_limits["left"], camera_limits["right"])
	$CRTShader.rect_position.y = clamp($Player.global_position.x - SHADER_OFFSET_Y, camera_limits["top"], camera_limits["bottom"])


func _on_Player_create_standin(player_position):
	add_child(body_standin)
	emit_signal("set_location", player_position)
