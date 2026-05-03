extends State

const jump_force : float = -650.0
export var jump_timer : float = 0.1

export (NodePath) var fall_node
export (NodePath) var throw_node

onready var fall_state: State  = get_node(fall_node)
onready var throw_state: State = get_node(throw_node)

var can_jump : bool = true
var direction : int = 0

func enter() -> void:
	# This calls the base class enter function, which is necessary here
	# to make sure the animation switches
	.enter()
	parent.velocity.y += jump_force




func process_physics(delta: float) -> State:
	jump_timer -= delta
	parent.velocity = parent.move_and_slide(parent.velocity, Vector2.UP)

	if Input.is_action_pressed("ui_jump") and jump_timer > 0.0:
		parent.velocity.y = min(parent.velocity.y, jump_force)
		return null
	elif jump_timer <= 0:
		return fall_state
	elif Input.is_action_just_released("ui_jump"):
		return fall_state

	parent.velocity.y += parent.gravity

	return null

func process_frame(_delta: float) -> State:
	if Input.is_action_pressed("ui_left"):
		direction = -1
		parent.body_anim.flip_h = true
	elif Input.is_action_pressed("ui_right"):
		direction = 1
		parent.body_anim.flip_h = false
	else:
		direction = 0

	if Input.is_action_just_pressed("ui_throw"):
		return throw_state

	return null



func exit():
	jump_timer = 0.2
