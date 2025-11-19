extends BallStateMaster
class_name BallStateHeld

## ============================
## ----------- ENTER ----------
## ============================

# Appelé lorsque la balle entre dans l’état “Held”
# (lorsqu’elle est tenue par le joueur)
func enter():
	super.enter()
	#Freeze la balle
	ball.gravity_scale = 0
	ball.linear_velocity = Vector2.ZERO
	ball.angular_velocity = 0
	ball.set_deferred("freeze", true)
	
	#Animation de déplacement vers le ball holder (position 0 vu que c'est son parent)
	var grab_tween := create_tween()
	grab_tween.tween_property(
		ball,
		"position",
		Vector2.ZERO,
		0.1
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


## ============================
## --------- INPUTS -----------
## ============================

# Appelé lorsqu’un input est détecté
# Ici, cet état ne gère pas d’inputs directement
func handle_input(input : String, value : int, delta: float):
	super.handle_input(input, value, delta)



## ============================
## ---------- UPDATE ----------
## ============================

# Appelé à chaque frame
# Sert généralement à suivre le joueur pendant qu’il tient la balle
func update(delta: float):
	super.update(delta)


## ============================
## ----------- EXIT -----------
## ============================

# Appelé lorsque la balle quitte cet état
# (par exemple lorsqu’elle est relâchée)
func exit():
	super.exit()