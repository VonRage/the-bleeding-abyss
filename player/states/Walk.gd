extends MoveState

func process_input(event: InputEvent) -> State:
	# First run parent code and make sure we don't need to exit early
	# based on its logic
	var new_state = .process_input(event)
	if new_state:
		return new_state
	
#	if Input.is_action_just_pressed("run"):
#		return run_state

	return null

