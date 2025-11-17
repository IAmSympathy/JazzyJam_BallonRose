extends PlayerStateMaster
class_name PlayerStateFall

@export var move_speed : float = 5
@export var target_fall_gravity: float = 5000.0
@export var duration_to_terminal_velocity: float = 0.4
@export var duration_decelerate: float = 0.2
var LandSFX := AudioStreamPlayer2D.new()


var tween_gravity: Tween

var base_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	add_child(LandSFX)
	LandSFX.stream = preload("res://Ressources/Sons/Saut_atteerrit.wav")
	LandSFX.volume_db = -15

func enter():
	super.enter()
	LandSFX.play()
	
	tween_gravity = create_tween()
	tween_gravity.tween_property(state_manager.possessed_node, "gravity", target_fall_gravity, duration_to_terminal_velocity).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)

func exit():
	tween_gravity.kill()
	state_manager.possessed_node.gravity = base_gravity
	state_manager.possessed_node.velocity.x = 0
	super.exit()

func handle_input(input : String, value : int, delta: float):
	super.handle_input(input,value,delta)
	
	if input == E_Inputs.move_x and value == 0:
		var tween: Tween = create_tween()
		tween.tween_method(Callable(state_manager.possessed_node, "set_velocity_x"),state_manager.possessed_node.velocity.x,0,duration_decelerate)
	
func update(delta: float):
	super.update(delta)
	
	state_manager.possessed_node.velocity.x += Input.get_axis("Left", "Right") * move_speed
	state_manager.possessed_node.velocity.x = clamp(state_manager.possessed_node.velocity.x,-state_manager.possessed_node.base_speed,state_manager.possessed_node.base_speed)
	state_manager.possessed_node.move_and_slide()
	
	if (state_manager.possessed_node.is_on_floor()):
		LandSFX.play()
		state_manager.handle_state_transition(E_PlayerStates.idle)

	
