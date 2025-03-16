extends State

# Exports a variable using NodePath to be used to set a variable
export var idle_state_path : NodePath
# The state var is set using the NodePath used above
onready var idle_state := get_node(idle_state_path) as State
export var jump_state_path : NodePath
onready var jump_state := get_node(jump_state_path) as State
export var fall_state_path : NodePath
onready var fall_state := get_node(fall_state_path) as State


# Class function will be called first
# In Godot 4 ".enter()" would be replaced by "super()"
# Plays animation specified in inspector
# Called in change_state on StateMachine
func enter() -> void:
	.enter()
	pass


# Class function will be called first
# Called in change_state on StateMachine
func exit() -> void:
	pass


# Class function will be called first
# Called in _unhandled_input on Player
func process_input(event : InputEvent) -> State:
	# Go to jump state
	if Input.is_action_just_pressed("ui_jump"):
		return jump_state
	return null


# Class function will be called first
# Called in _process on Player
func process_frame(delta : float) -> State:
	# Transition to idle state
	if abs(velocity.x) < 1:
		if !Input.is_action_pressed("ui_right") and !Input.is_action_pressed("ui_left"):
			return idle_state
	if !parent.is_on_floor():
		if velocity.y > 0:
			return fall_state
	return null


# Class function will be called first
# Called in _physics_process() on Player
func process_physics(delta : float) -> State:
	apply_gravity(delta)
	horizontal_movement(delta)
	velocity = parent.move_and_slide(velocity, Vector2.UP)
	return null


func apply_gravity(delta) -> void:
	if velocity.y <= LIMIT_SPEED_Y:
		velocity.y += gravity * delta


func horizontal_movement(delta):
	if Input.is_action_pressed("ui_right"):
		velocity.x = min(velocity.x + ACCELERATION, MAX_SPEED)
	elif Input.is_action_pressed("ui_left"):
		velocity.x = max(velocity.x - ACCELERATION, -MAX_SPEED)
	else:
		velocity.x = lerp(velocity.x, 0, 0.4)

