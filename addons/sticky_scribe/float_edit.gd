tool
extends LineEdit

signal value_changed(value);

export var value := NAN setget _set_value;


func _ready():
	connect("text_entered", self, "_on_text_entered");
	connect("focus_exited", self, "_on_text_entered", [""]);


func ui_increment_value(increment : float):
	ui_set_value(increment if is_nan(value) else value + increment);


func ui_set_value(new_value : float):
	if new_value != value:
		_set_value(new_value);
		emit_signal("value_changed", new_value);


func _on_text_entered(new_text : String):
	if text.empty():
		ui_set_value(NAN);
	elif text.is_valid_float():
		ui_set_value(text.to_float());
	else:
		_set_value(value);


func _set_value(new_value : float):
	value = new_value;
	text = "" if is_nan(value) else str(value);
	caret_position = text.length();
