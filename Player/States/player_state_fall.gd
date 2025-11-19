extends PlayerStateMaster
class_name PlayerStateFall

@export var move_speed : float = 5
@export var target_fall_gravity: float = 5000.0
@export var duration_to_terminal_velocity: float = 0.4
@export var duration_decelerate: float = 0.2

var tween_gravity: Tween
var base_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


## ============================
## ----------- ENTER ----------
## ============================

# Appelé lorsque le joueur entre dans l’état Fall
func enter():
	super.enter()

	# Crée un tween qui augmente progressivement la gravité
	# pour simuler l’accélération de la chute vers la vitesse terminale
	tween_gravity = create_tween()
	tween_gravity.tween_property(
		player,                        # Node dont on modifie la propriété
		"gravity",                     # Propriété modifiée
		target_fall_gravity,           # Nouvelle valeur cible
		duration_to_terminal_velocity  # Durée de la transition
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)


## ============================
## --------- INPUTS -----------
## ============================

# Gestion des inputs durant la chute
func handle_input(input : String, value : int, delta: float):
	super.handle_input(input, value, delta)

	# Décélération progressive quand le joueur relâche les touches gauche/droite
	if input == E_Inputs.move_x and value == 0:
		var tween: Tween = create_tween()

		tween.tween_method(
			Callable(player, "set_velocity_x"),   # Fonction appelée
			player.velocity.x,                    # Valeur initiale
			0,                                    # Objectif
			duration_decelerate                   # Durée
		)


## ============================
## ---------- UPDATE ----------
## ============================

# Logique exécutée à chaque frame physique
func update(delta: float):
	super.update(delta)

	# Mouvement horizontal pendant la chute (léger contrôle aérien)
	player.velocity.x += Input.get_axis("Left", "Right") * move_speed

	# Limite la vitesse horizontale à la vitesse maximale du joueur
	player.velocity.x = clamp(player.velocity.x, -player.base_speed, player.base_speed)

	# Applique la velocity
	player.move_and_slide()

	# Vérifie si le joueur touche le sol
	if player.is_on_floor():
		$LandSFX.play()
		state_manager.handle_state_transition(E_PlayerStates.idle)
		
		
		
## ============================
## ----------- EXIT -----------
## ============================

# Appelé lorsque le joueur quitte l’état Fall
func exit():
	# Empêche tout tween restant d'agir après la sortie
	tween_gravity.kill()

	# Remet la gravité de base du joueur
	player.gravity = base_gravity

	# Remet sa vitesse horizontale à 0
	player.velocity.x = 0

	super.exit()
