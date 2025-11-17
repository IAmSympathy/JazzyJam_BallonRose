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




#Aide par ChatGPT pour la transformation de vélocité après téléportation
func transform_velocity_between_portals(
	velocity: Vector2,
	entry_portal: Node2D,
	exit_portal: Node2D
) -> Vector2:

	var angle_in  = entry_portal.global_rotation
	var angle_out = exit_portal.global_rotation

	var relative_angle = angle_out - angle_in
	return velocity.rotated(relative_angle)
	
#Aide par ChatGPT pour la transformation de vélocité après téléportation
func _on_portal_entered(body: Node2D) -> void:
	$EnterSFX.play()
	other_portal.can_teleport = false
	other_portal.get_node("Area2D").connect("body_exited", _on_other_portal_exited)
	if(can_teleport):
		var target_pos := other_portal.global_position
		var target_rot := other_portal.global_rotation
	
		# CHARACTERBODY2D
		if body is CharacterBody2D:
			var cb := body as CharacterBody2D
	
			cb.velocity = transform_velocity_between_portals(
				cb.velocity,
				self,
				other_portal
			)
	
			cb.global_position = target_pos
			await get_tree().physics_frame
			return
	
		# RIGIDBODY2D
		if body is RigidBody2D:
			var rb := body as RigidBody2D
	
			# Transformer la vélocité
			rb.linear_velocity = transform_velocity_between_portals(
				rb.linear_velocity,
				self,
				other_portal
			)
	
			rb.angular_velocity = 0
	
			# Appliquer la nouvelle transform
			var t := rb.global_transform
			t.origin = target_pos
	
			PhysicsServer2D.body_set_state(
				rb.get_rid(),
				PhysicsServer2D.BODY_STATE_TRANSFORM,
				t
			)
	
			return
	
		# AUTRES Node2D
		body.global_position = target_pos

		
func _on_other_portal_exited(body: Node2D) -> void:
		other_portal.can_teleport = true
		print("balle sortie")
