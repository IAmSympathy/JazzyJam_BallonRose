extends CanvasLayer

## ============================
## --- VARIABLES & ONREADY ----
## ============================

# Référence au gamemode instancié
var gamemode: Gamemode

# Musique et effets sonores
@onready var musique: AudioStreamPlayer2D = $MusicAudioPlayer
@onready var son: AudioStreamPlayer2D = $ClickSFX

# Booléen pour savoir si le jeu a déjà commencé
var game_started: bool = false


## ============================
## ----------- INPUT ----------
## ============================

# Appelé lorsque le bouton principal est pressé
func _on_button_pressed() -> void:
	if not game_started:
		game_started = true

		# Arrête la musique du menu et joue le son du clic
		musique.stop()
		son.play()

		# Instancie le gamemode et l'ajoute à la scène
		var gamemode_scene: PackedScene = preload("res://Core/gamemode.tscn")
		gamemode = gamemode_scene.instantiate()
		get_parent().add_child(gamemode)

		# Cache l'écran'
		gamemode.play_transition("Hide")


# Appelé lorsque le son de clic se termine
func _on_click_sfx_finished():
	gamemode.start_game()
	# Supprime le CanvasLayer du menu
	queue_free()


# Appelé lorsque la souris entre sur le bouton
func _on_button_mouse_entered() -> void:
	$HoverSFX.play()
