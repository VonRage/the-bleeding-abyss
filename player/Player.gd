extends KinematicBody2D


# Constants
const RUN_SPEED = 600
const JUMP_FORCE = -600
const GRAVITY = 800

# Bools
var is_head_launched = false

# Vectors
var velocity = Vector2.ZERO

# Floats
var jump_height = 0.0
var jump_time = 0.0
export var jump_speed = 2
export var launch_speed = 130
export var head_ups = -400

# Node References
onready var anim = $BodySprite

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Start gravity and movement ability
	apply_gravity(delta)
	if !is_head_launched:
		handle_normal_movement(delta)
		launch_head()
	elif is_head_launched:
		handle_projectile_movement(delta)

func handle_normal_movement(delta):
		run()
		jump(delta)
		velocity = move_and_slide(velocity, Vector2.UP)
		if velocity.x < 0:
			anim.flip_h = true
		elif velocity.x > 0:
			anim.flip_h = false
			
func handle_projectile_movement(delta):
	# Allow limited air control
	if Input.is_action_pressed("ui_right"):
		velocity.x = RUN_SPEED/jump_speed
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -RUN_SPEED/jump_speed
	else:
		velocity.x = 0
	velocity = move_and_slide(velocity, Vector2.UP)

# Apply gravity if not on the ground
func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += delta * GRAVITY

# Player Running Movement and Animation
func run():
	if Input.is_action_pressed("ui_left") and is_on_floor():
		anim.play("walk")
		velocity.x = -RUN_SPEED
	elif Input.is_action_pressed("ui_right") and is_on_floor():
		anim.play("walk")
		velocity.x = RUN_SPEED
	else:
		anim.play("idle")
		velocity.x = 0

# Movement
func jump(delta):
	if Input.is_action_pressed("ui_jump"):
		jump_time = clamp(jump_time + delta * 6, 0.0, 1.0)
		jump_height = lerp(velocity.y, JUMP_FORCE, jump_time)
	if Input.is_action_pressed("ui_jump") and is_on_floor():
		velocity.y = jump_height
		
# Aerial Movement
	if Input.is_action_pressed("ui_left") and !is_on_floor():
		anim.play("walk")
		velocity.x = -RUN_SPEED/jump_speed
	elif Input.is_action_pressed("ui_right") and !is_on_floor():
		anim.play("walk")
		velocity.x = RUN_SPEED/jump_speed

func launch_head():
	if Input.is_action_pressed("ui_throw") and !is_head_launched:
		is_head_launched = true
		$BodySprite.hide()
		$CollisionBody.disabled = true
		var direction = -1 if anim.flip_h else 1
		velocity = Vector2(launch_speed * direction, head_ups)


func _on_ExitBlock_body_entered(body):
	print_debug("Maybe now?")
