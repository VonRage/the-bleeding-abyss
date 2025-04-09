extends State

export (float) var jump_force = 25
export (float) var min_jump_height = 300
export (float) var max_jump_height = 1000
export (float) var max_speed = 300
export (float) var acceleration = 60

export (NodePath) var fall_node
export (NodePath) var walk_node
export (NodePath) var idle_node
export (NodePath) var throw_node

onready var fall_state: State = get_node(fall_node)
onready var walk_state: State = get_node(walk_node)
onready var idle_state: State = get_node(idle_node)
onready var throw_state: State = get_node(throw_node)

var canJump : bool = true
var jump_time : float = 0.0


func enter() -> void:
	# This calls the base class enter function, which is necessary here
	# to make sure the animation switches
	.enter()
	parent.velocity.y = 0
	canJump = true

func process_physics(delta: float) -> State:
	var direction = 0
	if Input.is_action_pressed("ui_jump"):
		if canJump == true:
			if parent.velocity.y > -max_jump_height:
				parent.velocity.y = lerp(-min_jump_height, -max_jump_height, jump_time)
				jump_time += delta
			elif parent.velocity.y <= -max_jump_height:
				canJump = false
	if Input.is_action_just_released("ui_jump"):
		canJump = false
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
	
	parent.velocity.x = clamp(parent.velocity.x + (direction * acceleration), -max_speed, max_speed)
	parent.velocity = parent.move_and_slide(parent.velocity, Vector2.UP)
	
	if canJump == false:
		return fall_state

	if parent.is_on_floor():
		if direction != 0:
			return walk_state
		return idle_state
	return null


func exit():
	jump_time = 0.0
