extends State


export (NodePath) var jump_node
export (NodePath) var fall_node
export (NodePath) var walk_node
export (NodePath) var throw_node

onready var jump_state: State = get_node(jump_node)
onready var fall_state: State = get_node(fall_node)
onready var walk_state: State = get_node(walk_node)
onready var throw_state: State = get_node(throw_node)

func enter() -> void:
	.enter()
	parent.velocity.x = 0

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
#		if Input.is_action_pressed("run"):
#			return run_state
		return walk_state
	elif Input.is_action_just_pressed("ui_jump"):
		return jump_state
	elif Input.is_action_just_pressed("ui_throw"):
		return throw_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += parent.gravity
	parent.velocity = parent.move_and_slide(parent.velocity, Vector2.UP)

	if !parent.is_on_floor():
		return fall_state
	return null
