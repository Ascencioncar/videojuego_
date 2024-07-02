extends CharacterBody2D

var velocidad : int = 200
var salto : int = 250
var gravedad : int = 500
var hitplayer=false
var cont_jump:int=0
var max_jump:int=2

func _ready():
	$Area2D/CollisionShape2D.disabled =true
	

func _physics_process(delta):
	
	velocity.y +=gravedad*delta
	if !hitplayer:
		if Input.is_action_pressed("ui_right"):
			$CollisionShape2D.position.x= 167
			$Area2D.position.x = 0
			velocity.x = velocidad
			$anim.flip_h=false
		elif Input.is_action_pressed("ui_left"):
			$CollisionShape2D.position.x= 180
			$Area2D.position.x = -50
			velocity.x = -velocidad
			$anim.flip_h=true
		else:
			velocity.x=0
					
		if is_on_floor():
			cont_jump=0
			if Input.is_action_just_pressed("saltar"):
				$jump.play()
				cont_jump+=1
				velocity.y = -salto	
				
		else:
			if Input.is_action_just_pressed("saltar") and max_jump > cont_jump:
				$jump.play()
				cont_jump+=1
				velocity.y = -salto
				
			if Input.is_action_just_released("saltar"):
				velocity.y+= 5000*delta
		
		animaciones()
	
	move_and_slide()		
	
	
	
func _input(_event):
	if Input.is_action_just_pressed("atacar") and !hitplayer:
		$atack.play()
		set_physics_process(false)
		$anim.play("atack")	
		$Area2D/CollisionShape2D.disabled=false
		await $anim.animation_finished
		$Area2D/CollisionShape2D.disabled=true
		set_physics_process(true)
		print("golpe")
		

func animaciones():
	if is_on_floor():
		if velocity.x !=0:
			$anim.play("run")
		else:
			$anim.play("idle")
	else:
		if velocity.y < 0:
			$anim.play("jump")
		else:
			$anim.play("fall")

func hit():
	hitplayer=true
	velocity= Vector2.ZERO
	
	if !$anim.flip_h:
		velocity= Vector2(-100,-250)
	else:
		velocity= Vector2(100,-250)
	$anim.play("hit")
	await $anim.animation_finished
	velocity= Vector2.ZERO
	hitplayer=false
	get_tree().get_nodes_in_group("barravidaplayer")[0].DisminuirVida(30)
	
func dead():
	set_physics_process(false)
	$anim.play("dead")
	await $anim.animation_finished
	queue_free() 
	

func _on_area_2d_body_entered(body):
	if body.is_in_group("enemie"):
		body.dead()

	
