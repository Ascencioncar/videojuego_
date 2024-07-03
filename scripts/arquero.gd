extends CharacterBody2D

@export var flecha : PackedScene
@export var flechaiz : PackedScene
@export var flechcombo: PackedScene

var gravedad:int=500
var velocidad : int = 500
var disparar: bool=true
var hitplayer:bool=false
var combo:bool=false


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
				$AnimatedSprite2D.play("atack")
				disparar = false
				shootizquierda()
		elif $pruebacombo.is_colliding():
			$AnimatedSprite2D.flip_h=false
			var obj = $pruebacombo.get_collider()
			if obj.is_in_group("player") and combo:
				combo = false
				#$AnimatedSprite2D.play("atack")
				comboarquero()
				
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

func comboarquero():
		velocity= Vector2(-50,0)
		var newflecha = flechcombo.instantiate()
		newflecha.global_position =$combo.global_position
		get_parent().add_child(newflecha)
		
		var newflecha1 = flechcombo.instantiate()
		newflecha1.global_position = $combo1.global_position
		get_parent().add_child(newflecha1)
		
		var newflecha2 = flechcombo.instantiate()
		newflecha2.global_position = $combo2.global_position
		get_parent().add_child(newflecha2)
		
func hit():
	hitplayer=true
	velocity= Vector2.ZERO
	if !$AnimatedSprite2D.flip_h:
		velocity= Vector2(0,-100)
	else:
		velocity= Vector2(0,-100)
	$AnimatedSprite2D.play("hit")
	await $AnimatedSprite2D.animation_finished
	velocity= Vector2.ZERO
	hitplayer=false
	
func _on_timer_timeout():
	disparar=true
	combo=true
	
func dead():
	set_physics_process(false)
	$AnimatedSprite2D.play("hit")
	await ($AnimatedSprite2D.animation_finished)
	#queue_free()
