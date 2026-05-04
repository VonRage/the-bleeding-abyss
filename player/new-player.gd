extends KinematicBody2D

onready var body_sprite: Sprite = $BodySprite
onready var head_sprite: Sprite = $HeadSprite
onready var collision_body: CollisionShape2D = $CollisionBody
onready var collision_head: CollisionShape2D = $CollisionHead
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var main_camera: Camera2D = $Camera2D

export var gravity: int = 98
export var speed: int = 300
export var jump_velocity: int = -400
export var terminal_velocity: int = 300

const JUMP_BUFFER: int = 6

var jump_buffer: float = JUMP_BUFFER
var direction: int
var velocity : Vector2 = Vector2.ZERO

enum State {
	IDLE,
	RUN,
	JUMP,
	FALL,
	HEAD_THROW,
	HEAD_IDLE,
	HEAD_ROLL,
	HEAD_JUMP,
	HEAD_FALL,
	BODY_IDLE,
	BODY_RUN,
	BODY_JUMP,
	BODY_FALL,
	SWAP_CONTROL
}
var current_state = State.IDLE


func _physics_process(delta):
	execute_state(delta)
	move_and_slide(velocity)


###################################################
###################################################
###                                             ###
###                 State Machine               ###
###                                             ###
###################################################
###################################################


###################################################
###              General State Logic            ###
###################################################


func execute_state(delta) -> void:
	match current_state:
		State.IDLE:
			idle_state(delta)
		State.RUN:
			run_state(delta)
		State.JUMP:
			jump_state(delta)
		State.FALL:
			fall_state(delta)


###################################################
###                 Player States               ###
###################################################


func idle_state(delta) -> void:
	# Change State
	if Input.get_axis("ui_left", "ui_right"):
		enter_new_state(State.RUN)
	if Input.is_action_just_pressed("ui_jump"):
		enter_new_state(State.JUMP)
	if not is_on_floor():
		enter_new_state(State.FALL)


func run_state(delta) -> void:
	move()

	# Change State
	if not Input.get_axis("ui_left", "ui_right"):
		jump_buffer = JUMP_BUFFER
		enter_new_state(State.IDLE)
	elif Input.is_action_pressed("ui_jump"):
		jump_buffer = JUMP_BUFFER
		enter_new_state(State.JUMP)
	elif is_on_floor():
		return
	# The following happens if player isn't on floor
	# Jump input buffer (allows for a few frames of grace for jumping when running off a ledge)
	if jump_buffer > 0:
		jump_buffer -= 1
	elif jump_buffer <= 0:
		jump_buffer = JUMP_BUFFER
		enter_new_state(State.FALL)


# Allows smoother fall transition
const JUMP_TO_FALL_THRESHOLD = 100

func jump_state(delta) -> void:
	move()
	apply_gravity(delta)

	# Change State
	# Threshold set to make change in animation look/feel better
	if velocity.y > JUMP_TO_FALL_THRESHOLD:
		enter_new_state(State.FALL)


func fall_state(delta) -> void:
	move()
	apply_gravity(delta)

	# Change State
	if is_on_floor():
		if Input.get_axis("ui_left", "ui_right"):
			enter_new_state(State.RUN)
		else:
			enter_new_state(State.IDLE)


# GLHF with these
func head_throw_state(delta) -> void:
	pass

func head_idle_state(delta) -> void:
	pass

func head_roll_state(delta) -> void:
	pass

func head_jump_state(delta) -> void:
	pass

func head_fall_state(delta) -> void:
	pass

func body_idle_state(delta) -> void:
	pass

func body_run_state(detla) -> void:
	pass

func body_jump_state(delta) -> void:
	pass

func body_fall_state(delta) -> void:
	pass

func swap_control_state(detla) -> void:
	pass


###################################################
###             Change To New State             ###
###################################################


# Changes the current state to the new state
func enter_new_state(new_state) -> void:
	# Just double check to make sure you're actually changing states
	# Helps prevent actions from performing when not meant to
	if current_state == new_state:
		return

	# Change to new state the player will be in
	current_state = new_state

	# Executed when entering a new state (one-shot)
	match current_state:
		State.IDLE:
			animation_player.play("idle")
		State.RUN:
			animation_player.play("run")
		State.JUMP:
			animation_player.play("jump")
			velocity.y = jump_velocity
		State.FALL:
			animation_player.play("fall")


###################################################
###################################################
###                                             ###
###                    Movement                 ###
###                                             ###
###################################################
###################################################


func apply_gravity(delta) -> void:
	# Terminal velocity
	if velocity.y >= terminal_velocity:
		return

	# Actually apply gravity
	velocity.y += gravity * delta


# Enables movement
func move() -> void:
	# Gets the player's pressed input; left or right
	direction = Input.get_axis("ui_left", "ui_right")

	# Var to easily change sprite direction
	var left: int = -1
	var right: int = 1

	# Change sprite direction based on which way the player presses
	if direction == left:
		head_sprite.flip_h = true
		body_sprite.flip_h = true
	if direction == right:
		head_sprite.flip_h = false
		body_sprite.flip_h = false

	# Player movement in direction of pressed axis
	if direction:
		velocity.x = direction * speed
	# Friction to slow down player after button is released
	else:
		velocity.x = move_toward(velocity.x, 0, speed)


###################################################
###################################################
###                                             ###
###                   Camera                    ###
###                                             ###
###################################################
###################################################


# Sets up Camera2D limits in accordance with where the tilemap has been painted in level
# Interacts with script of the currect level
func setup_camera_limits(limits: Dictionary):
	main_camera.limit_left = limits["left"]
	main_camera.limit_right = limits["right"]
	main_camera.limit_top = limits["top"]
	main_camera.limit_bottom = limits["bottom"]
