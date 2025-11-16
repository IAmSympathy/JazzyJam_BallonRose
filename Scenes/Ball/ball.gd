extends RigidBody2D
class_name Ball

signal on_death

var can_be_picked_up = false

func _ready():
	pass

func _process(_delta):
	pass

func get_state_manager():
	return $StateManager

func ballfreeze():
	gravity_scale = 0
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	freeze = true


func _on_hitbox_body_entered(body: Node2D) -> void:
	on_death.emit()
	queue_free()
