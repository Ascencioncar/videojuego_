extends CharacterBody2D


@export var flecha: PackedScene
var disparar: bool=true

func _ready():
	pass
	
func _process(_delta):
	if $RayCast2D.is_colliding():
		var obj = $RayCast2D.get_collider()
		if obj.is_in_group("player") and disparar:
			disparar = false
			shoot()
			$AnimatedSprite2D.play("atack")
	
func shoot():
	var newflecha = flecha.instantiate()
	newflecha.global_position = $spawflecha.global_position
	get_parent().add_child(newflecha)


func _on_timer_timeout():
	disparar=true
