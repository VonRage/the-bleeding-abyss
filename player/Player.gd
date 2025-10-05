class_name Player
extends KinematicBody2D


onready var head_anim = $HeadSprite
onready var body_anim = $BodySprite
onready var body_collision = $CollisionBody
onready var state_machine = $StateMachine
onready var main_cam = $Camera2D

var create_body_standin = load("res://player/BodyStandin.tscn").instance()
var create_head_standin = load("res://player/HeadStandin.tscn").instance()


var velocity : Vector2 = Vector2.ZERO
# Sets gravity var to Godot's built in var
# Editable in project settings
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_position : Vector2


func _ready() -> void:
	# Initialize the state machine, passing a reference of
	# the player to the states, that way they can move and
	# react accordingly
	state_machine.init(self)


# Sets up Camera2D limits in accordance with where the tilemap has been painted in level
func setup_camera_limits(limits: Dictionary):
	main_cam.limit_left = limits["left"]
	main_cam.limit_right = limits["right"]
	main_cam.limit_top = limits["top"]
	main_cam.limit_bottom = limits["bottom"]


func _unhandled_input(event : InputEvent) -> void:
	state_machine.process_input(event)


func _physics_process(delta : float) -> void:
	state_machine.process_physics(delta)


func _process(delta : float) -> void:
	state_machine.process_frame(delta)


func _on_ExitBlock_body_entered(_body):
	get_tree().change_scene("res://title-screen/Cave3.tscn")
