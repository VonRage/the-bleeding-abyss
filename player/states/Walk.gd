extends State

export (NodePath) var jump_node
export (NodePath) var fall_node
export (NodePath) var idle_node
export (NodePath) var walk_node
export (NodePath) var throw_node

onready var jump_state : State = get_node(jump_node)
onready var fall_state : State = get_node(fall_node)
onready var idle_state : State = get_node(idle_node)
onready var walk_state : State = get_node(walk_node)
onready var throw_state : State = get_node(throw_node)

export (float) var acceleration = 60
export (float) var max_speed = 300
const COYOTE_TIME : float = 0.15
var coyote_time : float = 0.15


func process_frame(delta: float) -> State:
	if Input.is_action_just_pressed("ui_jump"):
		return jump_state

	if Input.is_action_just_pressed("ui_throw"):
		return throw_state

	# Jump grace period countdown
	if !parent.is_on_floor():
		coyote_time -= delta
		print(coyote_time)
	else:
		coyote_time = COYOTE_TIME

	if coyote_time <= 0:
		return fall_state

	return null


func process_physics(delta : float) -> State:


	var direction = get_movement_input()
	if direction < 0:
		parent.body_anim.flip_h = true
	elif direction > 0:
		parent.body_anim.flip_h = false

	#parent.velocity.y += parent.gravity
	parent.velocity.x = clamp(parent.velocity.x + (direction * acceleration), -max_speed, max_speed)
	parent.velocity = parent.move_and_slide(parent.velocity, Vector2.UP)

	if direction == 0:
		parent.velocity.x = lerp(parent.velocity.x, 0, 0.4)
		if parent.velocity.x <= abs(10):
			return idle_state

	return null


func get_movement_input() -> int:
	if Input.is_action_pressed("ui_left"):
		return -1
	elif Input.is_action_pressed("ui_right"):
		return 1

	return 0
