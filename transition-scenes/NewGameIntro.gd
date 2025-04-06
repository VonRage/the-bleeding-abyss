extends Control


onready var bible_verse = $CanvasLayer/BibleVerse
onready var delay_timer = $DelayTimer


export var fade_time : float = 1.0


func _ready():
	fade_in_label()


func _process(delta):
	print_debug(delay_timer.wait_time)


func fade_in_label():
	var tween = create_tween()
	tween.tween_property(bible_verse, "modulate:a", 1.0, fade_time)
	# Connect the tween completion signal to handle the delay before fading out
	tween.connect("tween_completed", self, "_on_fade_in_completed")


# This function is called once the fade-in is complete.
func _on_fade_in_completed(object, key):
	if object == bible_verse and key == "modulate:a":
		delay_timer.start()  # Start the delay timer after fade-in completes


func _on_DelayTimer_timeout():
	var tween = create_tween()
	tween.tween_property(bible_verse, "modulate:a", 0.0, fade_time)

