extends Sprite


const light_on_speed : float = 0.5


var start_light : bool = false
var light_lerp : float = 0.0


func _process(delta):
	if start_light == true:
		light_lerp = clamp (light_lerp + delta * 0.5, 0, 1.5)
		$Light2D8.energy = lerp(0, 1, light_lerp)


func _on_Area2D_body_entered(body):
	start_light = true
