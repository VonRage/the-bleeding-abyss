extends State

export var jump_force : float   = 40
export var jump_timer : float   = 150.0

export (NodePath) var fall_node
export (NodePath) var walk_node
export (NodePath) var idle_node
export (NodePath) var throw_node

onready var fall_state: State  = get_node(fall_node)
onready var walk_state: State  = get_node(walk_node)
onready var idle_state: State  = get_node(idle_node)
onready var throw_state: State = get_node(throw_node)

var can_jump : bool = true
var direction : int = 0

func enter() -> void: 
	# This calls the base class enter function, which is necessary here
	# to make sure the animation switches
	.enter()
	can_jump = true
	parent.velocity.y += jump_force



func process_physics(delta: float) -> State: 
	if Input.is_action_pressed("ui_jump") and can_jump:
		parent.velocity.y += -4 * (1 + abs(parent.velocity.x))
		jump_timer -= delta
		if jump_timer <= 0.0:
			can_jump = false
			return fall_state
		return null

	if Input.is_action_just_released("ui_jump"): 
		can_jump = false
		return fall_state

	parent.velocity.y += parent.gravity
	parent.velocity = parent.move_and_slide(parent.velocity, Vector2.UP) 

	if can_jump == false:
		return fall_state

	return null

func process_frame(delta: float) -> State:
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

	if parent.is_on_floor(): 
		if direction != 0: 
			return walk_state
		return idle_state

	return null



func exit(): 
	jump_timer = 2.0
