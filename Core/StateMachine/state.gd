extends Node
class_name State

@export var state_manager: StateManager
@export var state_name: String = "Default"

#Est appellé lorsqu'on entre dans le state
func enter():
	pass

#Est appellé lorsqu'on sort du state
func exit():
	pass
	
#Est appelé à chaque frame
func handle_input(_input : String, _value : int, _delta: float):
	pass
	
#Est appellé à chaque frame
func update(_delta: float):
	pass
	
