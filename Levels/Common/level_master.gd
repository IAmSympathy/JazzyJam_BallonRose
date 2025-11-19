extends Node
class_name LevelMaster

## ============================
## --- VARIABLES & SIGNALS ----
## ============================

# Nom du niveau (modifiable dans l'éditeur)
@export var level_name: String = "Default Level Name"

# Signal émis lorsque le joueur atteint la fin du niveau
signal on_end_reached
signal on_star_collected

# Booléen indiquant si l'étoile a été collectée
var is_star_collected: bool = false


## ============================
## ----------- READY ----------
## ============================

func _ready() -> void:
	# Cache la vue debug du node Start au lancement
	$PlayerStart.visible = false
	$BallStart.visible = false


## ============================
## ---- ÉVÉNEMENTS BODY -------
## ============================

# Appelé lorsque quelque chose entre en collision avec l'End
func _on_end_box_entered(_body: Node2D) -> void:
	if not is_star_collected:
		is_star_collected = true
		on_star_collected.emit()
		# Joue le son de collecte de l'étoile
		$CollectStarSFX.play()

		# Cache l'étoile
		$End/BlueStar.visible = false


## ============================
## ---- ÉVÉNEMENTS SFX -------
## ============================

# Appelé lorsque le son de collecte de l'étoile se termine
func _on_collect_star_sfx_finished() -> void:
	# Dit au level manager que la fin à été atteinte
	on_end_reached.emit()
