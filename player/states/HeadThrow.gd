extends State


export (NodePath) var head_idle_node
export (NodePath) var head_roll_node
export (NodePath) var head_jump_node

onready var head_idle_state: State = get_node(head_idle_node)
onready var head_roll_state: State = get_node(head_roll_node)
onready var head_jump_state: State = get_node(head_jump_node)


export var throw_strength : float = 1000
export var throw_height : float = 300
var direction : int


func enter() -> void:
	.enter()
	if parent.body_anim.flip_h == true:
		direction = -1
	elif parent.body_anim.flip_h == false:
		direction = 1
	parent.body_anim.visible = false
	parent.body_collision.disabled = true
	if Input.is_action_just_pressed("ui_throw"):
		parent.velocity.x = direction * throw_strength
		parent.velocity.y = -throw_height
	parent.emit_signal("create_standin", parent.global_position)

func process_physics(delta):
	parent.velocity.y += parent.gravity
	parent.velocity = parent.move_and_slide(parent.velocity, Vector2.UP)
	
	if parent.is_on_floor():
		if Input.is_action_just_pressed("ui_jump"):
			return head_jump_state
		elif !Input.is_action_pressed("ui_right") and !Input.is_action_pressed("ui_left"):
			parent.velocity.x = lerp(parent.velocity.x, 0, 0.4)
			if parent.velocity.x <= abs(10):
				return head_idle_state
		elif Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
			return head_roll_state
		else:
			return head_idle_state
