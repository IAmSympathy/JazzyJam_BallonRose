extends PlayerStateMaster
class_name PlayerStateRun

@export var speed: int = 400

func enter():
	super.enter()
	print("Je suis en run !!!")

func exit():
	super.exit()

func handle_input(input : String, value : int, delta: float):
	super.handle_input(input,value,delta)
	
	if input == E_Inputs.move_x:
		#On sort du state si on ne bouge plus
		if value == 0:
			state_manager.handle_state_transition(E_PlayerStates.idle)


func update(delta: float):
	super.update(delta)
	
	state_manager.possessed_node.velocity.x = Input.get_axis("Left", "Right") * speed
	state_manager.possessed_node.move_and_slide()

	
