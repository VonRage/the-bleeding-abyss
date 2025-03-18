extends State

export (NodePath) var head_jump_node
export (NodePath) var head_fall_node
export (NodePath) var head_roll_node

onready var head_jump_state: State = get_node(head_jump_node)
onready var head_fall_state: State = get_node(head_fall_node)
onready var head_roll_state: State = get_node(head_roll_node)

func enter() -> void:
	.enter()
	parent.velocity.x = 0

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
#		if Input.is_action_pressed("run"):
#			return run_state
		return head_roll_state
	elif Input.is_action_just_pressed("ui_jump"):
		return head_jump_state
#	elif Input.is_action_just_pressed("ui_return"):
#		return return_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += parent.gravity
	parent.velocity = parent.move_and_slide(parent.velocity, Vector2.UP)

	if !parent.is_on_floor():
		return head_fall_state
	return null
