extends State
class_name BallStateMaster


#Est appellé lorsqu'on entre dans le state
func enter():
	super.enter()

#Est appellé lorsqu'on sort du state
func exit():
	super.exit()

#Est appellé lorsqu'un input est détecté
func handle_input(input: String, value: bool):
	super.handle_input(input,value)
	
#Est appellé à chaque frame
func update():
	super.update()
