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
	$Area2D.connect("body_entered", _on_portal_entered)



## ============================
## ---------- PROCESS ---------
## ============================

# Ici rien à faire pour le moment
func _process(delta: float) -> void:
	pass



## ==========================================================
## --- TRANSFORMATION DE VÉLOCITÉ ENTRE DEUX PORTAILS -------
## ==========================================================

# Transforme la vélocité d’un objet qui entre dans un portail
# en fonction de l’orientation relative entre l’entrée et la sortie.
func transform_velocity_between_portals(
	velocity: Vector2,
	entry_portal: Node2D,
	exit_portal: Node2D
) -> Vector2:

	# Rotation de l’objet à l’entrée du portail
	var angle_in  = entry_portal.global_rotation
	# Rotation de l’objet à la sortie du portail
	var angle_out = exit_portal.global_rotation

	# Différence d’angle entre les deux portails
	var relative_angle = angle_out - angle_in

	# On retourne la vélocité ajustée
	return velocity.rotated(relative_angle)



## ============================
## ----- ENTRÉE DANS PORTAL ---
## ============================

# Appelé lorsqu’un objet entre dans le portail
func _on_portal_entered(body: Node2D) -> void:
	$EnterSFX.play()   # Joue le son d’entrée

	# Empêche l’autre portail d’immédiatement renvoyer l’objet
	other_portal.can_teleport = false

	# Lorsqu’un corps sort du portail de sortie, on réactive la téléportation
	other_portal.get_node("Area2D").connect("body_exited", _on_other_portal_exited)

	# Vérifie si ce portail est autorisé à téléporter
	if can_teleport:

		var target_pos := other_portal.global_position
		var target_rot := other_portal.global_rotation


		## --------------------------------------
		## --- CAS : CHARACTERBODY2D (Player) ---
		## --------------------------------------
		if body is CharacterBody2D:
			var cb := body as CharacterBody2D
			
			# Transformation de la vélocité selon angle du portail
			cb.velocity = transform_velocity_between_portals(
				cb.velocity,
				self,
				other_portal
			)

			# Téléportation de la position
			cb.global_position = target_pos

			# On attend un frame physique pour éviter des bugs de slide
			await get_tree().physics_frame
			return


		## --------------------------------------
		## --- CAS : RIGIDBODY2D (balle) --------
		## --------------------------------------
		if body is RigidBody2D:
			var rb := body as RigidBody2D
			
			# Transformation de la vélocité
			rb.linear_velocity = transform_velocity_between_portals(
				rb.linear_velocity,
				self,
				other_portal
			)

			# On supprime l’angular velocity pour éviter une rotation infinie
			rb.angular_velocity = 0

			# Téléportation via le PhysicsServer (plus propre pour RB)
			var t := rb.global_transform
			t.origin = target_pos

			PhysicsServer2D.body_set_state(
				rb.get_rid(),
				PhysicsServer2D.BODY_STATE_TRANSFORM,
				t
			)

			return


		## --------------------------------------
		## --- AUTRE Node2D ----------------------
		## --------------------------------------
		body.global_position = target_pos



## ============================
## ---- SORTIE DU PORTAIL ----
## ============================

# Appelé lorsque le corps sort du portail de sortie
func _on_other_portal_exited(body: Node2D) -> void:
	other_portal.can_teleport = true   # Réactive la téléportation
	print("balle sortie")
