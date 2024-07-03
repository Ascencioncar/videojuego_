extends CharacterBody2D

@export var flecha : PackedScene
@export var flechaiz : PackedScene
var gravedad:int=500
var velocidad : int = 500
var disparar: bool=true
var hitplayer:bool=false


func _ready():
	pass
	
func _physics_process(delta):
	velocity.y+=gravedad*delta
	if !hitplayer:
		if $RayCast2D.is_colliding():
			$AnimatedSprite2D.flip_h=false
			var obj = $RayCast2D.get_collider()
			if obj.is_in_group("player") and disparar:
				disparar = false
				shoot()
				$AnimatedSprite2D.play("atack")

		elif $izquierda.is_colliding():
			$AnimatedSprite2D.flip_h=true
			var obj = $izquierda.get_collider()
			if obj.is_in_group("player") and disparar:
				disparar = false
				$AnimatedSprite2D.play("atack")
				shootizquierda()
				
			
		else:
			$AnimatedSprite2D.play("idle")
	move_and_slide()	
		

func shoot():
	#disparo derecha 
	var newflecha = flecha.instantiate()
	newflecha.global_position = $spawflechas.global_position
	get_parent().add_child(newflecha)

func shootizquierda():
	#disparo izquierda
	var newflecha = flechaiz.instantiate()
	newflecha.global_position = $spawflechasiz.global_position
	get_parent().add_child(newflecha)

func hit():
	hitplayer=true
	velocity= Vector2.ZERO
	if !$AnimatedSprite2D.flip_h:
		velocity= Vector2(-100,-200)
	else:
		velocity= Vector2(100,-200)
	$AnimatedSprite2D.play("hit")
	await $AnimatedSprite2D.animation_finished
	velocity= Vector2.ZERO
	hitplayer=false
	
func _on_timer_timeout():
	disparar=true
	
func dead():
	set_physics_process(false)
	$AnimatedSprite2D.play("hit")
	await ($AnimatedSprite2D.animation_finished)
	#queue_free()
	
