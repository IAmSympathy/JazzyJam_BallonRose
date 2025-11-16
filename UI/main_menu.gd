extends CanvasLayer
var gamemode: Node

@onready var musique: AudioStreamPlayer2D = $MusicAudioPlayer
@onready var son: AudioStreamPlayer2D = $ClickSFX
var game_started: bool = false

func _on_button_pressed() -> void:
	if not game_started :
		game_started = true
		musique.stop()
		son.play()
		
		var gamemode_scene: PackedScene = preload("res://Core/gamemode.tscn")
		gamemode = gamemode_scene.instantiate()
		get_parent().add_child(gamemode)
		gamemode.get_node("AnimationPlayer").play("transition_out")


func _on_click_sfx_finished():
		gamemode.get_node("AnimationPlayer").play("transition_in")
		gamemode.get_node("LevelManager").get_node("AudioStreamPlayer2D").play()
		queue_free()

func _on_button_mouse_entered() -> void:
	$HoverSFX.play()
