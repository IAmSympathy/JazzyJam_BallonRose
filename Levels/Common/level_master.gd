extends Node
class_name LevelMaster

@export var level_name: String = "Default Level Name"
signal end_reached
var star_collected:bool = false

func _ready() -> void:
	$Start.visible = false

func _on_end_body_entered(body: Node2D) -> void:
	
	if not star_collected:
		star_collected = true
		$CollectStarSFX.play()
		$End/AnimatedBlueStar.visible = false

func _on_collect_star_sfx_finished() -> void:
	end_reached.emit()
