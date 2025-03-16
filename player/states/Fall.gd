extends State

# Exports a variable using NodePath to be used to set a variable
export var idle_state_path : NodePath
# The state var is set using the NodePath used above
onready var idle_state := get_node(idle_state_path) as State
export var walk_state_path : NodePath
onready var walk_state := get_node(walk_state_path) as State


# Class function will be called first
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
	return null


# Class function will be called first
# Called in _process on Player
func process_frame(delta : float) -> State:
	return null


# Class function will be called first
# Called in _physics_process() on Player
func process_physics(delta : float) -> State:
	apply_gravity(delta)
	horizontal_movement(delta)
	
	if parent.is_on_floor():
		# Transition to Walk only if actively moving horizontally
		var is_moving = Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")
		if is_moving and abs(velocity.x) > 50:
			return walk_state
		# Transition to Idle
		else:
			return idle_state
	
	#friction_on_air()
	
	velocity = parent.move_and_slide(velocity, Vector2.UP)
	
	return null


func apply_gravity(delta) -> void:
	if velocity.y <= LIMIT_SPEED_Y:
		velocity.y += gravity

func friction_on_air():
	velocity.x = lerp(velocity.x, 0, 0.01)

func horizontal_movement(delta):
	if Input.is_action_pressed("ui_right"):
		velocity.x = min(velocity.x + ACCELERATION, MAX_SPEED)
	elif Input.is_action_pressed("ui_left"):
		velocity.x = max(velocity.x - ACCELERATION, -MAX_SPEED)
	else:
		velocity.x = lerp(velocity.x, 0, 0.4)
