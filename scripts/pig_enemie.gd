extends CharacterBody2D


var velocidad: int = 80
var vel_perseguir: int=100
var gravedad: int =100
var perseguir:bool=false

func _ready():
	$AnimatedSprite2D.play("run")
	velocity.x=-velocidad
	

func _physics_process(delta):
	velocity.y +=gravedad*delta
	detectar()
	if !perseguir:
		if is_on_wall():
			if !$AnimatedSprite2D.flip_h:
				velocity.x=velocidad
			else:
				velocity.x=-velocidad	
	
		if velocity.x < 0:
			$AnimatedSprite2D.flip_h=false
		elif velocity.x> 0: 
			$AnimatedSprite2D.flip_h=true
	move_and_slide()
	
func detectar():
	if $right.is_colliding():
		var obj = $right.get_collider()
		if obj.is_in_group("player"):
			perseguir=true
			velocity.x = vel_perseguir
			$AnimatedSprite2D.flip_h=true
		else:
			perseguir=false
			
	if $left.is_colliding():
		var obj = $left.get_collider()
		if obj.is_in_group("player"):
			perseguir=true
			velocity.x = -vel_perseguir
			$AnimatedSprite2D.flip_h=false
		else:
			perseguir=false

func dead():
	set_physics_process(false)
	$AnimatedSprite2D.play("dead")
	await ($AnimatedSprite2D.animation_finished)
	queue_free()
	

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.hit()
		



