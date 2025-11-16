extends Node

var player: CharacterBody2D
var bHasLoss: bool

func _ready() -> void:
	player = $LevelManager.get_node("Player")

func _on_level_manager_level_complete() -> void:
	$AnimationPlayer.play("transition_out")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "transition_out":
		if bHasLoss:
			$LevelManager.restart_level()
			bHasLoss = false
		else:
			$LevelManager.next_level()
		$AnimationPlayer.play("transition_in")

func _on_level_manager_game_complete() -> void:
	var end_screen_scene: PackedScene = preload("res://UI/end_screen.tscn")
	var end_screen: Node = end_screen_scene.instantiate()
	get_parent().add_child(end_screen)
	queue_free()

func _on_level_manager_on_lose() -> void:
	bHasLoss = true
	$AnimationPlayer.play("transition_out")
	
