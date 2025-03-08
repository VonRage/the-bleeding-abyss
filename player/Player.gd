extends KinematicBody2D

const ACCELERATION = 3000
const MAX_SPEED = 18000
const LIMIT_SPEED_Y = 1200
const JUMP_HEIGHT = 36000
const MIN_JUMP_HEIGHT = 12000
const MAX_COYOTE_TIME = 6
const JUMP_BUFFER_TIME = 10
const GRAVITY = 2100

var velocity = Vector2()
var axis = Vector2()

var coyoteTimer = 0
var jumpBufferTimer = 0
var canJump = false
var friction = false

var is_head_launched = false
const launch_speed = 130
const head_ups = -600

onready var anim = $BodySprite

func _physics_process(delta):
	if velocity.y <= LIMIT_SPEED_Y:
		velocity.y += GRAVITY * delta

	friction = false
	getInputAxis()
	launch_head()

	# Basic vertical movement mechanics
	if !is_head_launched:
		horizontalMovement(delta)
		flip_sprite()

	# Jumping mechanics and coyote time
	if is_on_floor():
		canJump = true
		coyoteTimer = 0
	else:
		coyoteTimer += 1
		if coyoteTimer > MAX_COYOTE_TIME:
			canJump = false
			coyoteTimer = 0
		friction = true
	
	jumpBuffer(delta)

	if Input.is_action_just_pressed("ui_jump"):
		if canJump:
			jump(delta)
			frictionOnAir()

	setJumpHeight(delta)
	jumpBuffer(delta)

	velocity = move_and_slide(velocity, Vector2.UP)

func jump(delta):
	velocity.y = -JUMP_HEIGHT * delta

func frictionOnAir():
	if friction:
		velocity.x = lerp(velocity.x, 0, 0.01)

func jumpBuffer(delta):
	if jumpBufferTimer > 0:
		if is_on_floor():
			jump(delta)
		jumpBufferTimer -= 1

func setJumpHeight(delta):
	if Input.is_action_just_released("ui_up"):
		if velocity.y < -MIN_JUMP_HEIGHT * delta:
			velocity.y = -MIN_JUMP_HEIGHT * delta

func horizontalMovement(delta):
	if Input.is_action_pressed("ui_right"):
		velocity.x = min(velocity.x + ACCELERATION * delta, MAX_SPEED * delta)
	elif Input.is_action_pressed("ui_left"):
		velocity.x = max(velocity.x - ACCELERATION * delta, -MAX_SPEED * delta)
	else:
		velocity.x = lerp(velocity.x, 0, 0.4)

func getInputAxis():
	axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis = axis.normalized()

func flip_sprite():
	if velocity.x > 0:
		anim.flip_h = false
	elif velocity.x < 0:
		anim.flip_h = true

func launch_head():
	if Input.is_action_pressed("ui_throw") and !is_head_launched:
		is_head_launched = true
		$BodySprite.hide()
		$CollisionBody.disabled = true
		var direction = -1 if anim.flip_h else 1
		velocity = Vector2(launch_speed * direction, head_ups)


func _on_ExitBlock_body_entered(_body):
	print_debug("Maybe now?")
