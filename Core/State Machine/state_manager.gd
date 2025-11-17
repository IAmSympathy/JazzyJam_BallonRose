extends Node
class_name StateManager

@export var active_state: State
@export var possessed_node : Node2D
@export var states: Array[State]

func _ready() -> void:
	active_state.enter()

# À appeller pour changer de state
func handle_state_transition(next_state_name: String):
	var next_state: State
	
	for state in states:
		
		if state.state_name == next_state_name:
			next_state = state
			
	await active_state.exit()

	active_state = next_state
	active_state.enter()

# À appeller dans le possessed pawn lorsqu'un input est détecté
func handle_state_input(input : String, value : int, delta: float):
	active_state.handle_input(input, value, delta)
	

# À appeller dans le _process du possessed pawn
func call_active_state_update(delta: float):
	active_state.update(delta)
	
func get_active_state_name():
	return active_state.state_name
	
	
