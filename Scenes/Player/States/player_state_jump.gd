extends PlayerStateMaster
class_name PlayerStateJump

@export var jump_velocity: float = 350.0
@export var move_speed : float = 20
@export var duration_decelerate: float = 0.2

func enter():
	super.enter()
	state_manager.possessed_node.velocity.y = -jump_velocity
	state_manager.possessed_node.move_and_slide()

func exit():
	super.exit()

func handle_input(input : String, value : int, delta: float):
	super.handle_input(input,value,delta)

	if input == E_Inputs.move_x and value == 0:
		var tween: Tween = create_tween()
		tween.tween_method(Callable(state_manager.possessed_node, "set_velocity_x"),state_manager.possessed_node.velocity.x,0,duration_decelerate)

	
func update(delta: float):
	super.update(delta)
	
	if state_manager.possessed_node.velocity.y > 0:
		state_manager.handle_state_transition(E_PlayerStates.fall)
	
	state_manager.possessed_node.velocity.x += Input.get_axis("Left", "Right") * move_speed
	state_manager.possessed_node.velocity.x = clamp(state_manager.possessed_node.velocity.x,-state_manager.possessed_node.base_speed,state_manager.possessed_node.base_speed)
	state_manager.possessed_node.move_and_slide()
	
	

	
