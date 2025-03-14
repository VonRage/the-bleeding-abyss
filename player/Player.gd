extends KinematicBody2D

const ACCELERATION = 3000
const MAX_SPEED = 18000
const LIMIT_SPEED_Y = 1200
const JUMP_HEIGHT = 60000
const MIN_JUMP_HEIGHT = 12000
const MAX_COYOTE_TIME = 6
const JUMP_BUFFER_TIME = 10
const GRAVITY = 2100
const TOLERANCE = .05

var velocity = Vector2()

var coyoteTimer = 0
var jumpBufferTimer = 0
var canJump = false
var friction = false

var is_head_launched = false
var launch_speed = 1000
var head_ups = -300
var rotate_ccw = true
var rotate_speed = 1

onready var anim = $BodySprite
onready var hud = $HUD
onready var main_cam = $Camera2D
onready var quit_button = $HUD/CanvasLayer/QuitButton
onready var throw_angle = $ThrowRotator.rotation_degrees

func _ready():
	pass

# Sets up Camera2D limits in accordance with where the tilemap has been painted in level
func setup_camera_limits(limits: Dictionary):
	main_cam.limit_left = limits["left"]
	main_cam.limit_right = limits["right"]
	main_cam.limit_top = limits["top"]
	main_cam.limit_bottom = limits["bottom"]


func _physics_process(delta):
	if velocity.y <= LIMIT_SPEED_Y:
		velocity.y += GRAVITY * delta

	launch_head(delta)

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
	if Input.is_action_just_released("ui_jump"):
		if velocity.y < -MIN_JUMP_HEIGHT * delta:
			velocity.y = -MIN_JUMP_HEIGHT * delta

func horizontalMovement(delta):
	if Input.is_action_pressed("ui_right"):
		velocity.x = min(velocity.x + ACCELERATION * delta, MAX_SPEED * delta)
		anim.play("walk")
	elif Input.is_action_pressed("ui_left"):
		velocity.x = max(velocity.x - ACCELERATION * delta, -MAX_SPEED * delta)
		anim.play("walk")
	else:
		velocity.x = lerp(velocity.x, 0, 0.4)
		if is_on_floor():
			anim.play("idle")

func flip_sprite():
	if velocity.x > 0:
		anim.flip_h = false
	elif velocity.x < 0:
		anim.flip_h = true

func launch_head(delta):
#	print_debug(throw_angle)
	$ThrowRotator/Line2D.rotation = throw_angle
	if Input.is_action_pressed("ui_throw", delta):
		if rotate_ccw:
			throw_angle += delta * rotate_speed
			if throw_angle >= 180 - TOLERANCE:
				throw_angle = 180  # Snap to 180 to ensure precision
				rotate_ccw = false
		else:
			throw_angle -= delta * rotate_speed
			if throw_angle <= 0 + TOLERANCE:
				throw_angle = 0  # Snap to 0 to ensure precision
				rotate_ccw = true
	
	if Input.is_action_just_released("ui_throw") and !is_head_launched:
		is_head_launched = true
		$BodySprite.hide()
		$CollisionBody.disabled = true
		var direction = Vector2(cos(deg2rad(throw_angle)), -sin(deg2rad(throw_angle)))
		velocity = direction.normalized() * launch_speed

func _on_ExitBlock_body_entered(_body):
	get_tree().change_scene("res://title-screen/Title.tscn")

func _process(_delta):
	if Input.is_action_just_released("ui_reset"):
		get_tree().change_scene("res://levels/Castle.tscn")
