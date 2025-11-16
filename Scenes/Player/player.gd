extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var base_speed: float = 200.0


func _ready() -> void:
	$Area2D.connect("body_entered", _on_area_2d_body_entered)



func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	move_and_slide()
	$StateManager.call_active_state_update(delta)
	#MoveX
	if Input.is_action_just_pressed("Left") or Input.is_action_just_pressed("Right") or Input.is_action_just_released("Left") or Input.is_action_just_released("Right"):
		$StateManager.handle_state_input(E_Inputs.move_x, Input.get_axis("Left","Right"), delta)

	if Input.is_action_just_pressed("Jump"):
		$StateManager.handle_state_input(E_Inputs.jump, 1, delta)
	if Input.is_action_just_released("Jump"):
		$StateManager.handle_state_input(E_Inputs.jump, 0, delta)
	
	if Input.is_action_just_pressed("ThrowBall"):
		var ball = $BallHolder.get_child(0) as RigidBody2D
		throwBall(ball)

#Sert à être dans dans des tween de states par exemple
func set_velocity_x(value : float) -> void:
	print("lol")
	velocity.x = value

func _on_area_2d_body_entered(body: RigidBody2D):
	attachBall(body)


func throwBall(ball:RigidBody2D):
	ball.connect( "can_be_picked_up",enablePickUpBall)
	#togglePickUpBall(true)	#$Area2D.connect("body_entered", _on_area_2d_body_entered)
	ball.get_parent().remove_child(ball)
	get_parent().add_child(ball)
	ball.global_position = $BallHolder.global_position
	ball.get_state_manager().handle_state_transition("Free")
	ball.apply_impulse(Vector2(1, -0.5).normalized() * 200.0)
	




func attachBall(ball: RigidBody2D) -> void:
	var balle = ball as Ball

	var tween := create_tween()
	tween.tween_property(ball,"global_position", $BallHolder.global_position,0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT) #Un tween pour faire une transition smooth vers le ballHolder du joueur
	await tween.finished

	print("Zone penetrée")
	ball.ballfreeze()
	disablePickUpBall()	#$Area2D.disconnect("body_entered", _on_area_2d_body_entered)
	ball.get_parent().remove_child(ball)
	$BallHolder.add_child(ball)
	ball.global_position = $BallHolder.global_position
	ball.get_state_manager().handle_state_transition("Held")

func enablePickUpBall() -> void:
	$Area2D.monitoring = true
	print("Pick Up Enabled")

	
func disablePickUpBall() -> void:
	$Area2D.monitoring = false
	print("Pick Up Disabled")


	
