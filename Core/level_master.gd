extends Node
class_name LevelMaster

@export var level_name: String = "Default Level Name"
signal end_reached

func _on_end_body_entered(body: Node2D) -> void:
	end_reached.emit()
