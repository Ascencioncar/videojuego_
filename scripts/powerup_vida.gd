extends Area2D

var vidaextra:int=40

func _on_body_entered(body):
	if body.is_in_group("player"):
		get_tree().get_nodes_in_group("barravidaplayer")[0].value +=vidaextra
		queue_free()
	
