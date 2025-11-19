extends PlayerStateMaster
class_name PlayerStateRun


## ============================
## ----------- ENTER ----------
## ============================
func enter():
	super.enter()
	player.animation_player.play("Run")


## ============================
## --------- INPUTS -----------
## ============================
func handle_input(input: String, value: int, delta: float):
	super.handle_input(input, value, delta)

	# Si on arrête de bouger → Idle
	if input == E_Inputs.move_x and value == 0:
		state_manager.handle_state_transition(E_PlayerStates.idle)

	# Si on saute → Jump
	if input == E_Inputs.jump:
		state_manager.handle_state_transition(E_PlayerStates.jump)


## ============================
## ---------- UPDATE ----------
## ============================
func update(delta: float):
	super.update(delta)

	# Applique le mouvement horizontal
	player.velocity.x = Input.get_axis("Left", "Right") * player.base_speed

	# On gère la physique ici parce que ce state override le déplacement
	player.move_and_slide()

	# Met à jour la direction visuelle du joueur
	update_facing_direction()


## ============================
## ----------- EXIT -----------
## ============================
func exit():
	super.exit()
	# Rien de spécial pour l’instant


## ============================
## ----- CUSTOM FUNCTIONS -----
## ============================
func update_facing_direction() -> void:
	var direction: float = Input.get_axis("Left","Right")

	# Ne rien faire si on ne bouge pas
	if direction == 0:
		return

	# Flip du sprite
	player.get_node("Sprites").scale.x = abs(player.get_node("Sprites").scale.x) * sign(direction)

	# Réoriente le BallHolder du bon côté
	var holder := player.get_node("BallHolder")
	holder.position.x = abs(holder.position.x) * sign(direction)
