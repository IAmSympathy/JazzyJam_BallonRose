extends PlayerStateMaster
class_name PlayerStateJump

func enter():
	super.enter()
	print("Je suis en Idle !!!")

func exit():
	super.exit()

func handle_input(input : String, value : int, delta: float):
	super.handle_input(input,value,delta)
	
func update(delta: float):
	super.update(delta)
	

	