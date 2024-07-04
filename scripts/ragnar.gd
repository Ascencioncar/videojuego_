extends CharacterBody2D

var velocidad : int = 500
var salto : int = 350
var gravedad : int = 500
var hitplayer=false
var cont_jump:int=0
var max_jump:int=2
var esquivar:bool=false
@export var puñoderecha: PackedScene
@export var puñoizquierda: PackedScene

func _ready():
	$Area2D/atack1y2.disabled =true
	

func _physics_process(delta):
	
	velocity.y +=gravedad*delta
	if !hitplayer:
		if Input.is_action_pressed("ui_right"):
			$anim.position.x=0
			velocity.x = velocidad
			$anim.flip_h=false
			$CollisionRagnar.position.x=0
			$Area2D/atack1y2.position.x=-45
			$Area2D/uppercut.position.x=-45
			
			
		elif Input.is_action_pressed("ui_left"):
			$anim.position.x=-31
			velocity.x = -velocidad
			$anim.flip_h=true
			$Area2D/atack1y2.position.x=-102
			$Area2D/uppercut.position.x=-102
			
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
				velocity.y+= 4500*delta
		
		animaciones()
	
	move_and_slide()		
	
	
func _input(_event):
	if is_on_floor():
		if Input.is_action_just_pressed("atacar") and !hitplayer:
			$atack.play()
			set_physics_process(false)
			$anim.play("atack")
			$Area2D/atack1y2.disabled=false
			await $anim.animation_finished
			$Area2D/atack1y2.disabled=true
			set_physics_process(true)
		
			
		if Input.is_action_just_pressed("atack2") and !hitplayer:
			$atack.play()
			set_physics_process(false)
			$anim.play("atack2")
			$Area2D/atack1y2.disabled=false
			await $anim.animation_finished
			$Area2D/atack1y2.disabled=true
			set_physics_process(true)
			
			
		if Input.is_action_just_pressed("atack3") and !hitplayer:
			set_physics_process(false)
			$atack.play()
			$anim.play("atack3")	
			$Area2D/uppercut.disabled=false
			await $anim.animation_finished
			$Area2D/uppercut.disabled=true
			set_physics_process(true)
		
		if Input.is_action_just_pressed("puñetazoderecho") and !hitplayer and $anim.flip_h==false:
			set_physics_process(false)
			$atack.play()
			$anim.play("atack")
			puñetazoderecho()
			await $anim.animation_finished
			set_physics_process(true)
			
		if Input.is_action_just_pressed("puñetazoizquierdo") and !hitplayer and $anim.flip_h==true:
			set_physics_process(false)
			$atack.play()
			$anim.play("atack2")
			puñetazoizquierda()
			await $anim.animation_finished
			set_physics_process(true)
			
		if Input.is_action_just_pressed("esquivar") and !hitplayer and !esquivar:
			$CollisionRagnar.disabled=true
			#set_physics_process(false)
			$atack.play()
			$anim.play("idle")
			await $anim.animation_finished
			#set_physics_process(true)
			$CollisionRagnar.disabled=false
		

func puñetazoderecho():
	
		var newpuño = puñoderecha.instantiate()
		newpuño.global_position = $"puñetazos/dirección derecha".global_position
		get_parent().add_child(newpuño)
	
func puñetazoizquierda():
	
		var newpuño1 = puñoizquierda.instantiate()
		newpuño1.global_position = $"puñetazos/dirección izquierda".global_position
		get_parent().add_child(newpuño1)
	
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
		velocity= Vector2(0,0)
	else:
		velocity= Vector2(0,0)
	$anim.play("recibir flecha")
	await $anim.animation_finished
	velocity= Vector2.ZERO
	hitplayer=false
	get_tree().get_nodes_in_group("barravidaplayer")[0].DisminuirVida(30)
	
	
func dead():
		$CollisionRagnar.disabled=true
		set_physics_process(false)
		$anim.play("dead")
		await $anim.animation_finished
		#queue_free() 
		
func _on_area_2d_body_entered(body):
	if body.is_in_group("enemie"):
		body.hit()

func _on_timer_timeout():
	esquivar=true
