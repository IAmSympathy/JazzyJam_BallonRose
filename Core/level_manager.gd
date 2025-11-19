extends Node
class_name LevelManager

## ============================
## --- VARIABLES & SCENES -----
## ============================

# Liste des niveaux (index -> scène préchargée)
var level_list := {
	0: preload("res://Levels/level_1.tscn"),
	1: preload("res://Levels/level_2.tscn"),
	2: preload("res://Levels/level_3.tscn"),
	3: preload("res://Levels/level_4.tscn"),
	4: preload("res://Levels/level_5.tscn"),
}

# Niveau actuel instancié
var current_level: LevelMaster 

# Références aux acteurs du niveau
var player: CharacterBody2D
var ball: RigidBody2D
var gamemode : Gamemode

# Index du niveau courant
var curren_level_index: int = 1

# Scenes préchargées pour instancier player et balle
var player_scene: PackedScene = preload("res://Scenes/Player/player.tscn")
var ball_scene: PackedScene = preload("res://Scenes/Ball/ball.tscn")

# Signaux
signal on_level_completed
signal on_game_completed
signal on_lose


## ============================
## ----------- READY ----------
## ============================

func _ready() -> void:
	# Instancie le niveau courant au démarrage
	var level_scene: PackedScene = level_list[curren_level_index]
	current_level = level_scene.instantiate()


## ============================
## --------- EVENTS -------
## ============================

# Callback lorsque le joueur atteint la fin du niveau
func on_level_end_reached() -> void:
	if current_level.is_connected("on_end_reached", on_level_end_reached):
		current_level.disconnect("on_end_reached", on_level_end_reached)
	on_level_completed.emit()


# Callback lorsque le joueur meurt
func on_player_death():
	on_lose.emit()
	

## ============================
## --------- LEVEL FLOW --------
## ============================

# Initialise et démarre un niveau à l'index donné
func start_level(index: int):
	# Instancie le niveau
	current_level = level_list[index].instantiate()
	add_child(current_level)
	$CanvasLayer/LevelName.text = current_level.level_name

	# Spawn le joueur
	player = player_scene.instantiate() as CharacterBody2D
	add_child(player)
	player.position = current_level.get_node("PlayerStart").position
	player.connect("on_death", on_player_death)

	# Spawn la balle
	ball = ball_scene.instantiate() as RigidBody2D
	add_child(ball)
	ball.position = current_level.get_node("BallStart").position
	ball.connect("on_death", on_player_death)

	# Connecte le signal de fin de niveau
	current_level.connect("on_end_reached", on_level_end_reached)
	
	gamemode.play_transition("show")


# Passe au niveau suivant
func next_level():
	player.queue_free()
	ball.queue_free()
	current_level.queue_free()
	curren_level_index += 1

	# Si il reste des niveaux, on démarre le suivant
	if curren_level_index < level_list.size():
		start_level(curren_level_index)
	else:
		# Sinon, jeu terminé
		on_game_completed.emit()


# Redémarre le niveau courant
func restart_level():
	player.queue_free()
	# Libère la balle si elle existe
	if ball != null:
		ball.queue_free()
		ball = null
	
	current_level.queue_free()
	start_level(curren_level_index)
	
	
## ============================
## --------- AUTRES -------
## ============================

func toggle_music(enable: bool):
	if enable:
		$BMGPlayer.play()
	else:
		$BMGPlayer.stop()
