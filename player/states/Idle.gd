extends State

# Exports a variable using NodePath to be used to set a variable
export var fall_state_path : NodePath
# The state var is set using the NodePath used above
onready var fall_state := get_node(fall_state_path) as State
export var jump_state_path : NodePath
onready var jump_state := get_node(jump_state_path) as State
export var walk_state_path : NodePath
onready var walk_state := get_node(walk_state_path) as State


func enter() -> void:
	.enter()
	velocity.x = 0

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('ui_jump') and parent.is_on_floor():
		return jump_state
	if Input.is_action_just_pressed('ui_left') or Input.is_action_just_pressed('ui_right'):
		return walk_state
	return null

func process_physics(delta: float) -> State:
	if !parent.is_on_floor():
		if velocity.y > 0:
			return fall_state
	return null
