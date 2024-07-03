extends Area2D

func _process(_delta):
	position.y +=0.5
	
func _on_body_entered(body):
	if body.is_in_group("player"):
		queue_free()
		body.hit()
