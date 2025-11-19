extends RigidBody2D
class_name Ball

## ============================
## --------- VARIABLES & SIGNALS ----------
## ============================

#status de vie de la balle
var is_dead: bool = false

# Signal émis lorsque la balle "meurt"
signal on_death

# Signal émis lorsque la balle touche un objet 
signal on_ball_hit

## ============================
## ----------- READY ----------
## ============================

func _ready() -> void:
	# Rien à initialiser pour l’instant
	pass


## ============================
## ----- GESTION PHYSIQUE -----
## ============================

func _physics_process(delta: float) -> void:
	$StateManager.call_active_state_update(delta)
	
	# Si la balle tombe sous une certaine limite,
	# on déclenche sa mort
	if position.y > 380:
		die()

## ============================
## ----------- EVENTS ---------
## ============================

func _on_hitbox_body_entered(body: Node) -> void:
	# Si un pic touche la balle, elle meurt
	die()
	
func _on_body_hit(body: Node2D) -> void:
	on_ball_hit.emit()
	
	if body is Saw and !is_dead:
		die()


func _on_pop_sfx_finished() -> void:
	# Le son "pop" est terminé → on supprime la balle
	queue_free()


## ============================
## ----------- Getters ---------
## ============================

func get_state_manager() -> StateManager:
	return $StateManager


## ============================
## ----------- MORT -----------
## ============================

func die() -> void:
	# 1) Émission du signal de mort
	on_death.emit()
	is_dead = true

	# 2) Jouer le son d’explosion/pop
	#    (à la fin du son, la balle sera free dans _on_pop_sfx_finished)
	$PopSFX.play()
	
	$Sprite2D.visible = false
