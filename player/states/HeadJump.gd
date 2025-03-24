extends State

export (float) var jump_force = 1000
export (float) var min_jump_height = 200
export (float) var max_speed = 300
export (float) var acceleration = 60

export (NodePath) var head_fall_node
export (NodePath) var head_roll_node
export (NodePath) var head_idle_node

onready var head_fall_state: State = get_node(head_fall_node)
onready var head_roll_state: State = get_node(head_roll_node)
onready var idle_state: State = get_node(head_idle_node)


func enter() -> void:
	# This calls the base class enter function, which is necessary here
	# to make sure the animation switches
	.enter()
	if Input.is_action_just_pressed("ui_jump"):
		parent.velocity.y = -jump_force

func process_physics(delta: float) -> State:
	var direction = 0
	if Input.is_action_pressed("ui_left"):
		direction = -1
		parent.body_anim.flip_h = true
	elif Input.is_action_pressed("ui_right"):
		direction = 1
		parent.body_anim.flip_h = false
#	elif Input.is_action_just_pressed("ui_throw"):
#		return throw_state
	
	parent.velocity.x = clamp(parent.velocity.x + (direction * acceleration), -max_speed, max_speed)
	parent.velocity.x = lerp(parent.velocity.x, 0, 0.01)
	parent.velocity.y += parent.gravity
	parent.velocity = parent.move_and_slide(parent.velocity, Vector2.UP)
	
	if parent.velocity.y > 0:
		return head_fall_state

	if parent.is_on_floor():
		if direction != 0:
			#if Input.is_action_pressed("run"):
			#	return run_state
			return head_roll_state
		return idle_state
	return null
