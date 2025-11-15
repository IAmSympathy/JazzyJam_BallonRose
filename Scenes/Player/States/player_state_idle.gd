extends PlayerStateMaster
class_name PlayerStateIdle

func enter():
	super.enter()
	print("Je suis en Idle !!!")

func exit():
	super.exit()

func handle_input(input : String, value : int, delta: float):
	super.handle_input(input,value,delta)
		
	if input == E_Inputs.move_x:
		state_manager.handle_state_transition(E_PlayerStates.run)
	if input == E_Inputs.jump:
		state_manager.handle_state_transition(E_PlayerStates.jump)
	
func update(delta: float):
	super.update(delta)
	

	