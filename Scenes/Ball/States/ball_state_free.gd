extends BallStateMaster
class_name BallStateFree

@export var base_velocity: Vector2 = Vector2(0, 500)

## ============================
## ----------- READY ----------
## ============================

func _ready() -> void:
	ball.linear_velocity = base_velocity


## ============================
## ----------- ENTER ----------
## ============================

# Appelé lorsque la balle entre dans ce state (Free)
func enter():
	super.enter()  # Appelle la logique de base du parent BallStateMaster

	# Débloque la physique : la balle peut retomber normalement
	ball.freeze = false

	# Rétablit la gravité pour qu'elle tombe
	ball.gravity_scale = 1.0


## ============================
## --------- INPUTS -----------
## ============================

# Appelé lorsqu’un input est détecté
# Ici, la balle n’a pas vraiment d’input à gérer
func handle_input(input: String, value: int, delta: float):
	super.handle_input(input, value, delta)


## ============================
## ---------- UPDATE ----------
## ============================

# Appelé à chaque frame (souvent depuis _physics_process)
func update(delta: float):
	super.update(delta)


## ============================
## ----------- EXIT -----------
## ============================

# Appelé lorsque la balle quitte ce state
func exit():
	super.exit()
	# Pour l'instant, aucune action particulière à faire ici
