extends Node
class_name LevelManager

var level_list := {
	0: preload("res://Levels/level_1.tscn"),
	1: preload("res://Levels/level_2.tscn"),
}
var current_level: LevelMaster 

var player: CharacterBody2D
var curren_level_index: int = 0

var player_scene: PackedScene = preload("res://Scenes/Player/player.tscn")
signal level_complete
signal game_complete

func _ready() -> void:
	var level_scene: PackedScene = level_list[curren_level_index]
	current_level = level_scene.instantiate()
	
	start_level(current_level)
	
func start_level(level: LevelMaster):
	current_level = level
	add_child(current_level)
	$CanvasLayer/LevelName.text = current_level.level_name

	#Spawn le player ou le téléporte
	
	player = player_scene.instantiate() as CharacterBody2D
	add_child(player)
	player.position = current_level.get_node("Start").position
	
	current_level.connect("end_reached",on_level_end_reached)


func next_level():
	player.queue_free()
	current_level.queue_free()
	curren_level_index += 1
	
	if curren_level_index < level_list.size():
		start_level(level_list[curren_level_index].instantiate())
	else:
		game_complete.emit()
		current_level.disconnect("end_reached", on_level_end_reached)
	


func on_level_end_reached() -> void:
	current_level.disconnect("end_reached", on_level_end_reached)
	level_complete.emit()
