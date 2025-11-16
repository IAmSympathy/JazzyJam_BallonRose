extends CanvasLayer
var gamemode: Node

@onready var musique: AudioStreamPlayer2D = $MusicAudioPlayer
@onready var son: AudioStreamPlayer2D = $ClickSFX

func _on_button_pressed() -> void:
	musique.stop()
	son.play()
	
	
func on_transition_finished(_anim_name: StringName) -> void:
	gamemode.get_node("AnimationPlayer").disconnect("animation_finished",on_transition_finished)
	queue_free()


func _on_click_sfx_finished():
	var gamemode_scene: PackedScene = preload("res://Core/gamemode.tscn")
	gamemode = gamemode_scene.instantiate()
	
	get_parent().add_child(gamemode)
	gamemode.get_node("AnimationPlayer").play("transition_out")
	gamemode.get_node("AnimationPlayer").connect("animation_finished",on_transition_finished)

	
