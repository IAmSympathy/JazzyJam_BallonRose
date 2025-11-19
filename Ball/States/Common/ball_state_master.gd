extends State
class_name BallStateMaster

# Référence automatique vers la Balle possédé par ce StateManager
# - @onready garantit que ceci est exécuté une fois que le node est ready
# - state_manager.possessed_node est défini dans le StateManager
@onready var ball: Ball = state_manager.possessed_node

## ============================
## ----------- ENTER ----------
## ============================
# Appelé lorsque le State devient actif.
# Tous les States Player devraient appeler super.enter() pour garder
# le comportement commun défini dans la clase parent "State".
func enter():
	super.enter()

## ============================
## ----------- EXIT -----------
## ============================
# Appelé lorsque le State est quitté.
# Utilisé pour nettoyer les tweens, signaux, timers, etc.
func exit():
	super.exit()

## ============================
## --------- INPUTS -----------
## ============================
# Appelé lorsqu’un input est détecté par le Player.
# Par exemple : move_x, jump, throw, etc.
# On envoie ici l’input au State actif qui peut décider d'une transition.
func handle_input(input: String, value: int, delta: float):
	super.handle_input(input, value, delta)

	
## ============================
## ---------- UPDATE ----------
## ============================
# Appelé à chaque frame de jeu (souvent depuis _physics_process du Player via StateManager).
# Sert à mettre à jour les mouvements continus, physique interne du State, etc.
func update(delta: float):
	super.update(delta)
