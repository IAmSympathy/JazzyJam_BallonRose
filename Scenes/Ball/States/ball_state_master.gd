extends State
class_name BallStateMaster
@onready var ball = owner as RigidBody2D

#Est appellé lorsqu'on entre dans le state
func enter():
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
