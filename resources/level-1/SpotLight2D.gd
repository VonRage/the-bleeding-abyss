extends Light2D


func _on_Area2D_body_entered(body):
	$ClickOnSound.play()
	energy = 1
