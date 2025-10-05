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

func process_frame(delta: float) -> State:
	if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
		return walk_state
	if Input.is_action_pressed("ui_jump"):
		print_debug("Jump input detected in idle state")
		print_debug("Returning jump_state: ", jump_state)
		return jump_state
	if Input.is_action_just_pressed("ui_throw"):
		return throw_state
	return null

func process_physics(_delta: float) -> State:
	parent.velocity.y += parent.gravity
	parent.velocity = parent.move_and_slide(parent.velocity, Vector2.UP)

	if !parent.is_on_floor():
		print_debug("falling")
		return fall_state
	return null
