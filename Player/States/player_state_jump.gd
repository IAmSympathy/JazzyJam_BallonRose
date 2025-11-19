extends PlayerStateMaster
class_name PlayerStateJump

@export var jump_velocity: float = 350.0
@export var move_speed : float = 20
@export var duration_decelerate: float = 0.2


## ============================
## ----------- ENTER ----------
## ============================

# Appelé lorsque le joueur entre dans l’état Jump
func enter():
	super.enter()  # Logique commune à tous les states

	# Joue le son de saut
	$JumpSFX.play()

	# Lance l’animation de saut
	player.animation_player.play("jump")

	# Applique l’impulsion vers le haut
	player.velocity.y = -jump_velocity

	# Applique le mouvement immédiatement pour refléter le saut dans le même frame
	player.move_and_slide()


## ============================
## --------- INPUTS -----------
## ============================

# Appelé lorsqu’un input est détecté
func handle_input(input : String, value : int, delta: float):
	super.handle_input(input, value, delta)

	# Si le joueur relâche la touche de déplacement horizontal
	if input == E_Inputs.move_x and value == 0:

		# Crée un tween pour diminuer la vitesse progressivement
		var tween: Tween = create_tween()

		# Interpole player.velocity.x vers 0 sur une durée définie
		tween.tween_method(
			Callable(player, "set_velocity_x"),
			player.velocity.x,
			0,
			duration_decelerate
		)


## ============================
## ---------- UPDATE ----------
## ============================

# Appelé à chaque frame physique
func update(delta: float):
	super.update(delta)

	# Si la vitesse verticale devient positive → il ne monte plus → transition vers Fall
	if player.velocity.y > 0:
		state_manager.handle_state_transition(E_PlayerStates.fall)

	# Ajoute la vitesse horizontale selon les inputs gauches/droite
	player.velocity.x += Input.get_axis("Left", "Right") * move_speed

	# Empêche d’aller plus vite que la vitesse maximale
	player.velocity.x = clamp(player.velocity.x, -player.base_speed, player.base_speed)

	# Applique le mouvement avec la nouvelle velocity
	player.move_and_slide()


## ============================
## ----------- EXIT -----------
## ============================

# Appelé lorsque le joueur quitte l’état Jump
func exit():
	super.exit()
	# Aucun comportement particulier à ajouter pour le moment
