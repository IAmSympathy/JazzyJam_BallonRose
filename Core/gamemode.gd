extends Node
class_name Gamemode

## ============================
## --- VARIABLES & SIGNALS ----
## ============================

# Référence au joueur dans la scène
var player: CharacterBody2D

# Signaux pour indiquer que les animations de transition sont terminées
signal transition_hide_finished
signal transition_show_finished


## ============================
## ----------- READY ----------
## ============================

func _ready() -> void:
	# Récupère le joueur dans le LevelManager
	player = $LevelManager.get_node("Player")
	$LevelManager.gamemode = self


## ============================
## ---- UTILITAIRES ----------
## ============================

func start_game():
	$LevelManager.start_level(0)
	$LevelManager.toggle_music(true)
	play_transition("Show")

# Joue une animation de transition
# "Show" -> affichage, "Hide" -> disparition
func play_transition(transition: String):
	match transition:
		"Show":
			$AnimationPlayer.play("transition_show")
		"Hide":
			$AnimationPlayer.play("transition_hide")


# Callback lorsque l'AnimationPlayer termine une animation
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"transition_show":
			transition_show_finished.emit()
		"transition_hide":
			transition_hide_finished.emit()


## ============================
## --- EVENTS ---
## ============================

# Appelé lorsque le joueur ou la balle meurt
func _on_level_manager_on_lose() -> void:
	$LoseSFX.play()
	play_transition("Hide")
	connect("transition_hide_finished", reset_level)


# Appelé lorsque le joueur ou la balle termine le niveau
func _on_level_manager_on_level_completed() -> void:
	play_transition("Hide")
	connect("transition_hide_finished", go_to_next_level)

# Appelé lorsque le joueur termine le jeu
func _on_level_manager_on_game_completed() -> void:
	$WinSFX.play()

# Appelé lorsque le son de fin se termine
func _on_win_sfx_finished() -> void:
	play_transition("Hide")
	connect("transition_hide_finished", go_to_end)


## ============================
## ----- CALLBACKS ----------
## ============================

# Réinitialise le niveau après la transition
func reset_level():
	disconnect("transition_hide_finished", reset_level)
	$LevelManager.restart_level()
	play_transition("Show")


# Passe au niveau suivant après la transition
func go_to_next_level():
	disconnect("transition_hide_finished", go_to_next_level)
	$LevelManager.next_level()
	play_transition("Show")


# Affiche l'écran de fin après la transition
func go_to_end():
	var end_screen_scene: PackedScene = preload("res://UI/end_screen.tscn")
	var end_screen: Node = end_screen_scene.instantiate()
	get_parent().add_child(end_screen)
	$LevelManager.queue_free()
	play_transition("Show")

