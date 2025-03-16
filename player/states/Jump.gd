extends State

# Exports a variable using NodePath to be used to set a variable
export var fall_state_path : NodePath
# The state var is set using the NodePath used above
onready var fall_state := get_node(fall_state_path) as State
export var idle_state_path : NodePath
onready var idle_state := get_node(idle_state_path) as State


const JUMP_HEIGHT : int = 1000
const MIN_JUMP_HEIGHT : int = 200
const MAX_COYOTE_TIME : int = 6


var coyote_timer : int = 0
var can_jump : bool = true


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
	return null


# Class function will be called first
# Called in _process on Player
func process_frame(delta : float) -> State:
	# Set state to idle
	if parent.is_on_floor() and coyote_timer == MAX_COYOTE_TIME:
		return idle_state
	# Set state to fall
	if velocity.y > 200:
		return fall_state
	return null


# Class function will be called first
# Called in _physics_process() on Player
func process_physics(delta : float) -> State:
	apply_gravity(delta)
	
	if parent.is_on_floor():
		can_jump = true
		coyote_timer = 0
	else:
		coyote_timer += 1
		if coyote_timer > MAX_COYOTE_TIME:
			can_jump = false
	
	if Input.is_action_pressed("ui_jump") and can_jump == true:
		velocity.y = -JUMP_HEIGHT
	
	if Input.is_action_just_released("ui_jump"):
		if velocity.y < -MIN_JUMP_HEIGHT:
			velocity.y = -MIN_JUMP_HEIGHT
	
	
	#friction_on_air()
	horizontal_movement(delta)
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
