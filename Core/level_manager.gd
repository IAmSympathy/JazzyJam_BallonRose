extends Node
class_name LevelManager

var level_list := {
	-1: preload("res://Levels/level_1.tscn"),
	0: preload("res://Levels/level_1.tscn"),
	1: preload("res://Levels/level_2.tscn"),
	2: preload("res://Levels/level_3.tscn"),
	3: preload("res://Levels/level_4.tscn"),
	4: preload("res://Levels/level_5.tscn"),
}
var current_level: LevelMaster 

var player: CharacterBody2D
var ball: RigidBody2D
var curren_level_index: int = -1

var player_scene: PackedScene = preload("res://Scenes/Player/player.tscn")
var ball_scene: PackedScene = preload("res://Scenes/Ball/ball.tscn")
signal level_complete
signal game_complete
signal on_lose

func _ready() -> void:



	var level_scene: PackedScene = level_list[curren_level_index]
	current_level = level_scene.instantiate()
	
	start_level(current_level)

	
	
func start_level(level: LevelMaster):
	current_level = level
	add_child(current_level)
	$CanvasLayer/LevelName.text = current_level.level_name

	#Spawn le player ou le téléporte
	
	if player != null:
		player.queue_free()
	player = player_scene.instantiate() as CharacterBody2D
	add_child(player)

	ball = ball_scene.instantiate() as RigidBody2D
	var ball_holder := player.get_node("BallHolder")
	add_child(ball)
	ball.global_position = player.global_position + Vector2(50, 50)
	ball.connect("on_death", on_player_death)
	
	player.position = current_level.get_node("Start").position + Vector2(0, -32)
	player.connect("on_death", on_player_death)
	
	current_level.connect("end_reached",on_level_end_reached)


func next_level():
	player.queue_free()
	ball.queue_free()
	current_level.queue_free()
	curren_level_index += 1
	
	if curren_level_index < level_list.size() - 1:
		start_level(level_list[curren_level_index].instantiate())
	else:
		game_complete.emit()
		current_level.disconnect("end_reached", on_level_end_reached)
	


func on_level_end_reached() -> void:
	current_level.disconnect("end_reached", on_level_end_reached)
	level_complete.emit()

func on_player_death():
	on_lose.emit()

func restart_level():
	start_level(current_level)
