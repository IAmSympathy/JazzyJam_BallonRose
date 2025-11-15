extends CharacterBody2D

func _process(delta: float) -> void:
	$StateManager.call_active_state_update()