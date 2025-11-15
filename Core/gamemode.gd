extends Node


func _on_level_manager_level_complete() -> void:
	$AnimationPlayer.play("transition")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "transition":
		$LevelManager.next_level()

