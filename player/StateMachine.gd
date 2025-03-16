extends Node

# Exports a variable of NodePath type to be used to set a variable next
# Drag and drop a node from scene tree into inspector to assign
export var starting_state_path : NodePath
# The starting state is set using the NodePath used above
# Unsure if setting it as State will throw an error or not when
# an invalid script is attached or not (Hope it does!)
# This is as easy as "export var starting_state : State" in Godot 4....
onready var starting_state = get_node(starting_state_path) as State


var current_state : State


# Initialize the state machine by giving each child state a reference to the
# parent object it belongs to and enter the default starting_state.
func init(parent : Player) -> void:
	for child in get_children():
		child.parent = parent

	# Initialize to the default state
	change_state(starting_state)
	print_debug("init starting state: ", starting_state)


# Change to the new state by first calling any exit logic on the current state.
func change_state(new_state : State) -> void:
	if current_state:
		current_state.exit()

	current_state = new_state
	current_state.enter()
	print_debug("new state change: ", new_state)
	print_debug("current state after: ", current_state)


# Pass through functions for the Player to call,
# handling state changes as needed.
func process_physics(delta : float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)


func process_input(event : InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)


func process_frame(delta : float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)
