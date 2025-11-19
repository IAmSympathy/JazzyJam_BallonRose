extends Node
class_name StateManager

## ============================
## ------- VARIABLES ----------
## ============================

# Le state actuellement actif
@export var active_state: State

# Le node contrôlé par les states (ex: Player)
@export var possessed_node: Node2D

# Liste des states disponibles
@export var states: Array[State]


## ============================
## ----- INITIALISATION -------
## ============================

func initiate() -> void:
	# Appelé dans le _ready du player
	if active_state == null:
		push_error("StateManager: Aucun active_state assigné !")
		return

	# Donne une référence du possessed node au state si nécessaire
	active_state.enter()


## ============================
## ---- CHANGEMENT DE STATE ---
## ============================

func handle_state_transition(next_state_name: String) -> void:
	var next_state: State = null

	# Trouve le state demandé dans la liste
	for state in states:
		if state.state_name == next_state_name:
			next_state = state
			break

	# Si aucun state trouvé → erreur claire
	if next_state == null:
		push_error("StateManager: State '" + next_state_name + "' introuvable !")
		return

	# Quitte l'état actuel
	await active_state.exit()

	# Change d'état
	active_state = next_state
	active_state.enter()


## ============================
## -------- INPUT HANDLER -----
## ============================

# Appelé par le Player lorsqu'un input est capturé
func handle_state_input(input: String, value: int, delta: float) -> void:
	if active_state != null:
		active_state.handle_input(input, value, delta)


## ============================
## ----- UPDATE DU STATE ------
## ============================

# Appelé par le Player dans son _physics_process
func call_active_state_update(delta: float) -> void:
	if active_state != null:
		active_state.update(delta)


## ============================
## ----------- GETTERS ----------
## ============================

func get_active_state_name() -> String:
	return active_state.state_name
	
func get_active_state() -> State:
	return active_state
