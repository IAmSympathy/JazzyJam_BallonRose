extends Node
class_name State

@onready var state_manager: Node = $"../../StateManager"
@export var state_name: String = "Default"

#Est appellé lorsqu'on entre dans le state
func enter():
	pass

#Est appellé lorsqu'on sort du state
func exit():
	pass
	
#Est appelé à chaque frame
func handle_input(input : String, value : int, delta: float):
	pass
	
#Est appellé à chaque frame
func update(delta: float):
	pass
	
