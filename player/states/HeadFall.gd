extends State


export (float) var acceleration = 60
export (float) var max_speed = 300
export (NodePath) var head_roll_node
export (NodePath) var head_idle_node

onready var head_roll_state: State = get_node(head_roll_node)
onready var head_idle_state: State = get_node(head_idle_node)

func process_physics(delta: float) -> State:
	var direction = 0
	if Input.is_action_pressed("ui_left"):
		direction = -1
		parent.body_anim.flip_h = true
	elif Input.is_action_pressed("ui_right"):
		direction = 1
		parent.body_anim.flip_h = false
	
	parent.velocity.x = clamp(parent.velocity.x + (direction * acceleration), -max_speed, max_speed)
	parent.velocity.y += parent.gravity
	parent.velocity = parent.move_and_slide(parent.velocity, Vector2.UP)

	if parent.is_on_floor():
		if direction != 0:
#			if Input.is_action_pressed("run"):
#				return run_state
			return head_roll_state
		else:
			return head_idle_state
	return null
