extends Node
class_name StateManager

@export var active_state: State
@export var possessed_node : Node2D
@export var states: Dictionary[String, State]

func _ready() -> void:
	active_state.enter()

# À appeller pour changer de state
func handle_state_transition(next_state_name: String):
	active_state.exit()
	active_state = states[next_state_name]
	active_state.enter()

# À appeller dans le possessed pawn lorsqu'un input est détecté
func handle_state_input(input : String, value : bool):
	active_state.handle_input(input, value)	

# À appeller dans le _process du possessed pawn
func call_active_state_update():
	active_state.update()
	