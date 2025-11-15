extends BallStateMaster
class_name BallStateFree




#Est appellé lorsqu'on entre dans le state
func enter():
	ball.freeze = false
	super.enter()

#Est appellé lorsqu'on sort du state
func exit():
	super.exit()

#Est appellé lorsqu'un input est détecté
func handle_input(input : String, value : int, delta: float):
	super.handle_input(input,value, delta)
	
#Est appellé à chaque frame
func update(delta: float):
	super.update(delta)
