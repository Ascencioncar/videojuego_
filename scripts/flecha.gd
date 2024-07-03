extends Area2D

func _process(_delta):
	position.x +=5.5
	
func _on_body_entered(body):
	if body.is_in_group("player"):
		body.hit()
		queue_free()
