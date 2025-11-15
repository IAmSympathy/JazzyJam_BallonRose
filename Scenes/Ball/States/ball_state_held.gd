extends BallStateMaster
class_name  BallStateHeld

#va chercher le root pour avoir accès aux propriétés de Rigidbody2D

@onready var player =$"../../../../Player"
	

#Est appellé lorsqu'on entre dans le state
func enter():
	#Doit etre mis comme child du joueur pour suivre ses déplacements, et desactiver la physique 
	#ball.freeze = true
	print("freese")
	ball.reparent(player, true)
	super.enter()

#Est appellé lorsqu'on sort du state
func exit():
	super.exit()

#Est appellé lorsqu'un input est détecté
func handle_input(input : String, value : int, delta: float):
	super.handle_input(input,value, delta)
	
#Est appellé à chaque frame
func update(delta: float):
	super.update(delta)
