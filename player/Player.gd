class_name Player
extends KinematicBody2D


onready var head_anim = $HeadSprite
onready var body_anim = $BodySprite
onready var state_machine = $StateMachine
onready var main_cam = $Camera2D


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
