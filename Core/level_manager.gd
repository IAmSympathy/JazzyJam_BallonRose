extends Node
class_name LevelManager

#Settings
@export var level_list: Array[LevelMaster] = []

var player_scene: PackedScene = preload("res://Scenes/Player/player.tscn")
signal level_complete
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var level: LevelMaster = level_list[0]
	start_level(level)
	
func start_level(level: LevelMaster):
	#Level
	$CanvasLayer/LevelName.text = level.level_name

	#Spawn le player
	var player: CharacterBody2D = player_scene.instantiate() as CharacterBody2D
	add_child(player)
	player.position = level.get_node("Start").position


func _on_level_master_end_reached() -> void:
	level_complete.emit()
	
func next_level():
	pass
