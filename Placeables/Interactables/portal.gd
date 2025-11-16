extends Node2D
class_name Portal

@export var other_portal: Portal

var can_teleport : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.connect("body_entered",_on_portal_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_portal_entered(body: Node2D) -> void:
	print("Entrée")
	other_portal.can_teleport = false
	other_portal.get_node("Area2D").connect("body_exited", _on_other_portal_exited)
	if(can_teleport):
		# --- CharacterBody2D ---
		if body is CharacterBody2D:
			var cb := body as CharacterBody2D
			cb.global_position = other_portal.position
			return
	
		# --- RigidBody2D ---
		if body is RigidBody2D:
			var rb := body as RigidBody2D
	

			var transform := rb.global_transform
			transform.origin = other_portal.position
	

			PhysicsServer2D.body_set_state(
				rb.get_rid(),
				PhysicsServer2D.BODY_STATE_TRANSFORM,
				transform
			)
			return
		
func _on_other_portal_exited(body: Node2D) -> void:
		other_portal.can_teleport = true
		print("balle sortie")
