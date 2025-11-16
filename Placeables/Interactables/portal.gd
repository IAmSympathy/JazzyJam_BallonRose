extends Node2D
class_name Portal

@export var other_portal: Portal

var can_teleport : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.connect("body_entered",_on_portal_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_portal_entered(body: Node2D) -> void:
	other_portal.can_teleport = false
	other_portal.get_node("Area2D").connect("body_exited", _on_other_portal_exited)
	if(can_teleport):
		body.position = other_portal.position
		
func _on_other_portal_exited(body: Node2D) -> void:
		other_portal.can_teleport = true
