extends Node
class_name State

#Est appellé lorsqu'on entre dans le state
func enter():
	pass

#Est appellé lorsqu'on sort du state
func exit():
	pass

#Est appellé lorsqu'un input est détecté
func handle_input(input: String, value: bool):
	pass
	
#Est appellé à chaque frame
func update():
	pass
	
