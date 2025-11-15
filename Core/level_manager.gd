extends Node
class_name LevelManager

#Settings
var curren_level_index: int = 0
@export var level_list: Array[LevelMaster] = []

var player_scene: PackedScene = preload("res://Scenes/Player/player.tscn")
signal level_complete

func _ready() -> void:
	var level: LevelMaster = level_list[curren_level_index]
	start_level(level)
	
func start_level(level: LevelMaster):
	#Level
	$CanvasLayer/LevelName.text = level.level_name

	#Spawn le player
	var player: CharacterBody2D = player_scene.instantiate() as CharacterBody2D
	add_child(player)
	player.position = level_list[0].get_node("Start").position
	
	level.connect("end_reached",on_level_end_reached)


func next_level():
	curren_level_index += 1
	start_level(level_list[curren_level_index])


func on_level_end_reached() -> void:
	level_complete.emit()
