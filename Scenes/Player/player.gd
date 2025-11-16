extends CharacterBody2D

@onready var fleche: Sprite2D = $Fleche
@onready var animation_player: AnimationPlayer = $AnimationPlayer



@export var minThrowStrength: float = 100
@export var maxThrowStrength: float = 600

signal on_death 


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var base_speed: float = 200.0
var ballRef: RigidBody2D = null
var chargeStrength: float = 0.0

func _ready() -> void:
	$PickupArea.connect("body_entered", _on_area_2d_body_entered)
	fleche.visible = false
	$Hitbox.connect("body_entered", _on_hitbox_body_entered)



func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	updateFacingDirection()
	move_and_slide()
	$StateManager.call_active_state_update(delta)
	#MoveX
	if Input.is_action_just_pressed("Left") or Input.is_action_just_pressed("Right") or Input.is_action_just_released("Left") or Input.is_action_just_released("Right"):
		$StateManager.handle_state_input(E_Inputs.move_x, Input.get_axis("Left","Right"), delta)

	if Input.is_action_just_pressed("Jump"):
		$StateManager.handle_state_input(E_Inputs.jump, 1, delta)
	if Input.is_action_just_released("Jump"):
		$StateManager.handle_state_input(E_Inputs.jump, 0, delta)

	if $BallHolder.get_child_count() > 0:
		ballRef = $BallHolder.get_child(0) as RigidBody2D
	
	if Input.is_action_pressed("ThrowBall") and ballRef != null:
		global_position.distance_to(get_global_mouse_position())
		chargeStrength = clamp(remap(global_position.distance_to(get_global_mouse_position()), 0, 200, minThrowStrength, maxThrowStrength), minThrowStrength, maxThrowStrength)
		
		fleche.visible = true
		fleche.rotation = (get_global_mouse_position() - global_position).angle()
		fleche.scale = Vector2(-chargeStrength / maxThrowStrength, 1 )




	if Input.is_action_just_released("ThrowBall") and ballRef != null:
		throwBall(ballRef, chargeStrength) 
		fleche.visible = false
		print("Thrown with strength: " + str(chargeStrength))

	ballRef = null

#Sert à être dans dans des tween de states par exemple
func set_velocity_x(value : float) -> void:
	velocity.x = value

func _on_area_2d_body_entered(body: RigidBody2D):
	attachBall(body)



func throwBall(ball:RigidBody2D, strength:float):
	ball.connect( "can_be_picked_up",enablePickUpBall)
	#togglePickUpBall(true)	#$Area2D.connect("body_entered", _on_area_2d_body_entered)
	enablePickUpBall()
	ball.get_parent().remove_child(ball)
	get_parent().add_child(ball)
	ball.global_position = $BallHolder.global_position
	ball.get_state_manager().handle_state_transition("Free")

	
	var direction = (get_global_mouse_position() - ball.global_position).normalized()
	ball.apply_impulse(-direction * strength)
	




func attachBall(ball: RigidBody2D) -> void:
	var balle = ball as Ball

	var tween := create_tween()
	print("scale avant:", ball.scale)
	tween.tween_property(ball,"global_position", $BallHolder.global_position,0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT) #Un tween pour faire une transition smooth vers le ballHolder du joueur
	await tween.finished
	print("scale après:", ball.scale)
	print("Zone penetrée")
	ball.ballfreeze()
	#togglePickUpBall(false)
	disablePickUpBall()	#$Area2D.disconnect("body_entered", _on_area_2d_body_entered)
	ball.get_parent().remove_child(ball)
	$BallHolder.add_child(ball)
	ball.global_position = $BallHolder.global_position
	ball.get_state_manager().handle_state_transition("Held")


# func togglePickUpBall(value: bool) -> void:
# 	$PickupArea.monitoring = value
func enablePickUpBall() -> void:
	$PickupArea.monitoring = true
	print("Pick Up Enabled")

	
func disablePickUpBall() -> void:
	$PickupArea.monitoring = false
	print("Pick Up Disabled")

func updateFacingDirection() -> void:
	var dir := Input.get_axis("Left", "Right")
	if dir != 0:
		# Flip le sprite
		$Sprites.scale.x = 0.25 * sign(dir)
		
		# Place le BallHolder du bon côté du joueur
		var holder := $BallHolder
		holder.position.x = abs(holder.position.x) * sign(dir)
		fleche.global_position.x = holder.global_position.x



func _on_hitbox_body_entered(body: Node2D) -> void:
	on_death.emit()
