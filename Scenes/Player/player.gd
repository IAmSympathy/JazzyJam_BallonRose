extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var base_speed: float = 200.0

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

	
#Sert à être dans dans des tween de states par exemple
func set_velocity_x(value : float) -> void:
	print("lol")
	velocity.x = value
