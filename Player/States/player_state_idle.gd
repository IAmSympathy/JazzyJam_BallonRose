extends PlayerStateMaster
class_name PlayerStateIdle


## ============================
## ----------- ENTER ----------
## ============================
func enter():
	# Toujours appeler la logique parent (référence du player, etc.)
	super.enter()

	# Lance l’animation d'attente
	player.animation_player.play("playerIdle")
	
	if not player.is_on_floor():
		state_manager.handle_state_transition(E_PlayerStates.fall)


## ============================
## --------- INPUTS -----------
## ============================
func handle_input(input: String, value: int, delta: float):
	super.handle_input(input, value, delta)

	# Si le joueur bouge -> passer à Run
	if input == E_Inputs.move_x and value != 0:
		state_manager.handle_state_transition(E_PlayerStates.run)

	# Si le joueur saute -> passer à Jump
	if input == E_Inputs.jump:
		state_manager.handle_state_transition(E_PlayerStates.jump)


## ============================
## ---------- UPDATE ----------
## ============================
func update(delta: float):
	super.update(delta)


## ============================
## ----------- EXIT -----------
## ============================
func exit():
	super.exit()
