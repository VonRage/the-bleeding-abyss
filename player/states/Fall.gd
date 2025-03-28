extends State


export (float) var acceleration = 60
export (float) var max_speed = 300
export (NodePath) var walk_node
export (NodePath) var idle_node
export (NodePath) var throw_node

onready var walk_state: State = get_node(walk_node)
onready var idle_state: State = get_node(idle_node)
onready var throw_state: State = get_node(throw_node)

func process_physics(delta: float) -> State:
	var direction = 0
	if Input.is_action_pressed("ui_left"):
		direction = -1
		parent.body_anim.flip_h = true
	elif Input.is_action_pressed("ui_right"):
		direction = 1
		parent.body_anim.flip_h = false
	if Input.is_action_just_pressed("ui_throw"):
		return throw_state
	
	parent.velocity.x = clamp(parent.velocity.x + (direction * acceleration), -max_speed, max_speed)
	parent.velocity.y += parent.gravity
	parent.velocity = parent.move_and_slide(parent.velocity, Vector2.UP)

	if parent.is_on_floor():
		if direction != 0:
#			if Input.is_action_pressed("run"):
#				return run_state
			return walk_state
		else:
			return idle_state
	return null
