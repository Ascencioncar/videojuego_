extends StaticBody2D

@export var bullet : PackedScene
var disparar: bool=true

func _ready():
	pass
	
func _process(_delta):
	if $RayCast2D.is_colliding():
		var obj = $RayCast2D.get_collider()
		if obj.is_in_group("player") and disparar:
			disparar = false
			shoot()
			$AnimatedSprite2D.play("shoot")
	
func shoot():
	var newbullet = bullet.instantiate()
	newbullet.global_position = $spawbullet.global_position
	get_parent().add_child(newbullet)


func _on_timer_timeout():
	disparar=true
	
