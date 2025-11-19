extends Node2D
class_name Portal

@export var other_portal: Portal   # Référence vers l’autre portail (sortie)

var can_teleport : bool = true     # Empêche les téléportations en boucle infinie


## ============================
## ----------- READY ----------
## ============================

# Appelé lorsque le portail est ajouté dans la scène
func _ready() -> void:
	# On connecte le signal de détection d’entrée dans l’Area2D
	$TeleportArea.connect("body_entered", _on_portal_entered)


## ==========================================================
## --- TRANSFORMATION DE VÉLOCITÉ ENTRE DEUX PORTAILS -------
## ==========================================================

func get_portal_forward(portal: Node2D) -> Vector2:
	return Vector2.LEFT.rotated(portal.global_rotation)

# Transforme la vélocité d’un objet qui entre dans un portail
# en fonction de l’orientation relative entre l’entrée et la sortie.
func transform_velocity_between_portals(
	velocity: Vector2,
	entry_portal: Node2D,
	exit_portal: Node2D
) -> Vector2:

	# Rotation de l’objet à l’entrée du portail
	var angle_in: Vector2  = get_portal_forward(entry_portal)
	# Rotation de l’objet à la sortie du portail
	var angle_out: Vector2 = get_portal_forward(exit_portal)

	# Différence d’angle entre les deux portails
	var relative_angle: float = angle_in.angle_to(angle_out) 

	# On retourne la vélocité ajustée
	return velocity.rotated(relative_angle)



## ============================
## ----- ENTRÉE DANS PORTAL ---
## ============================

# Appelé lorsqu’un objet entre dans le portail
func _on_portal_entered(body: Node2D) -> void:
	print("entrée")
	$EnterSFX.play()   # Joue le son d’entrée

	# Empêche l’autre portail d’immédiatement renvoyer l’objet
	other_portal.can_teleport = false

	# Lorsqu’un corps sort du portail de sortie, on réactive la téléportation
	other_portal.get_node("TeleportArea").connect("body_exited", _on_other_portal_exited)

	# Vérifie si ce portail est autorisé à téléporter
	if can_teleport:
		var target_pos := other_portal.global_position
		## --------------------------------------
		## --- PLAYER ---
		## --------------------------------------
		if body is CharacterBody2D:	
		
			# Transformation de la vélocité selon angle du portail
			body.velocity = transform_velocity_between_portals(
				body.velocity,
				self,
				other_portal
			)
			
			# Téléportation via le PhysicsServer
			body.global_transform.origin = target_pos + Vector2(0,-50)
			
			body.global_position = target_pos
			
			return

		## --------------------------------------
		## --- BALL --------
		## --------------------------------------
		if body is RigidBody2D:
			# Transformation de la vélocité
			body.linear_velocity = transform_velocity_between_portals(
				body.linear_velocity,
				self,
				other_portal
			)

			# On supprime l’angular velocity pour éviter une rotation infinie
			body.angular_velocity = 0

			# Téléportation via le PhysicsServer
			body.global_transform.origin = target_pos

			PhysicsServer2D.body_set_state(
				body.get_rid(),
				PhysicsServer2D.BODY_STATE_TRANSFORM,
				body.global_transform
			)

			return



## ============================
## ---- SORTIE DU PORTAIL ----
## ============================

# Appelé lorsque le corps sort du portail de sortie
func _on_other_portal_exited(_body: Node2D) -> void:
	other_portal.can_teleport = true   # Réactive la téléportation
