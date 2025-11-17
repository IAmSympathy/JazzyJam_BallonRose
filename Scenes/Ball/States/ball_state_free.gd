extends BallStateMaster
class_name BallStateFree

signal can_be_picked_up


#Est appellé lorsqu'on entre dans le state
func enter():
	super.enter()
	print("Ball is Free")
	state_manager.possessed_node.freeze = false
	state_manager.possessed_node.gravity_scale = 1.0   

	

#Est appellé lorsqu'on sort du state
func exit():
	super.exit()

#Est appellé lorsqu'un input est détecté
func handle_input(input : String, value : int, delta: float):
	super.handle_input(input,value, delta)
	
#Est appellé à chaque frame
func update(delta: float):
	super.update(delta)

	if state_manager.possessed_node.is_on_floor():
		can_be_picked_up.emit()
		print("Can be picked up")


