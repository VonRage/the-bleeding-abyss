tool
extends TextEdit


func _input(event : InputEvent):
	if event.is_action_pressed("ui_focus_next", true, true) and has_focus():
		if !focus_next.is_empty():
			get_node(focus_next).grab_focus()
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("ui_focus_prev", true, true) and has_focus():
		if !focus_previous.is_empty():
			get_node(focus_previous).grab_focus()
		get_tree().set_input_as_handled()


func _gui_input(event : InputEvent) -> void:
	var mb := event as InputEventMouseButton;
	if mb && !mb.pressed && mb.command:
		var line_col := get_line_column_at_pos(mb.position);
		var line = get_line(line_col.y);
		var continuous := RegEx.new();
		continuous.compile("[^\\s]+"); # continuous stretch of non-whitespace characters
		var hit := continuous.search(line);
		while hit && hit.get_end(0) < line_col.x:
			hit = continuous.search(line, hit.get_end(0) + 1);
		if hit:
			var try_open := ProjectSettings.globalize_path(hit.get_string());
			print("attempting to open uri ", try_open);
			OS.shell_open(try_open);


func _fit_to_contents():
	if !is_visible_in_tree():
		return;
	var style := get_stylebox("normal");
	rect_min_size.y = ceil(style.get_margin(MARGIN_TOP) + style.get_margin(MARGIN_BOTTOM) + get_line_height() * get_total_visible_rows());
