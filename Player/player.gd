extends CharacterBody2D
class_name Player

## ============================
## --- VARIABLES & ONREADY ---
## ============================

# Animation Player du joueur
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Vitesse de base
@export var base_speed: float = 400.0

# Force minimale/maximale de tir
@export var minThrowStrength: float = 100
@export var maxThrowStrength: float = 600

# Référence de la balle tenue (ou null)
var ballRef: Ball = null

# Charge actuelle de tir
var charge_strength: float = 0.0
var arrow_x_scale_factor: float = 0.8

# Gravité extraite des settings
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#status de vie de la balle
var is_dead: bool = false

# Signal lorsqu’on sort de l'écran
signal on_death 


## ============================
## ----------- READY ----------
## ============================

func _ready() -> void:
	# Connexions des zones
	$PickupArea.connect("body_entered", _on_pickuparea_body_entered)
	$Hitbox.connect("body_entered", _on_hitbox_body_entered)

	# Flèche de visée invisible au début
	$BallHolder/Arrow.visible = false

	# Initialise et active le système de states
	$StateManager.initiate()


## ============================
## ---- PHYSICS PROCESS -------
## ============================

func _physics_process(delta: float) -> void:
	# Applique la gravité
	velocity.y += gravity * delta

	# Update du state actif
	$StateManager.call_active_state_update(delta)
	
	# Inputs joueur
	handle_inputs(delta)
	
	# Mort si on tombe en bas de l'écran
	if position.y > Global.death_y and not is_dead:
		is_dead = true
		on_death.emit()
		
	# Déplacements Godot
	move_and_slide()


## ============================
## ----------- INPUTS ---------
## ============================

func handle_inputs(delta: float) -> void:
	## --- Déplacements Gauche/Droite --- ##
	if Input.is_action_pressed("Left") or Input.is_action_pressed("Right") \
	or Input.is_action_just_released("Left") or Input.is_action_just_released("Right"):
		var axis := Input.get_axis("Left", "Right")
		$StateManager.handle_state_input(E_Inputs.move_x, axis, delta)

	## --- Saut --- ##
	if Input.is_action_just_pressed("Jump"):
		$StateManager.handle_state_input(E_Inputs.jump, 1, delta)

	if Input.is_action_just_released("Jump"):
		$StateManager.handle_state_input(E_Inputs.jump, 0, delta)

	## --- Lancer de balle (charger) --- ##
	if Input.is_action_pressed("Throw") and ballRef != null:
		var dist := global_position.distance_to(get_global_mouse_position())
		charge_strength = clamp(
			remap(dist, 0, 200, minThrowStrength, maxThrowStrength),
			minThrowStrength,
			maxThrowStrength
		)
		update_throw_arrow()

	## --- Relâcher et lancer --- ##
	if Input.is_action_just_released("Throw") and ballRef != null:
		throw_ball(ballRef, charge_strength)
		$BallHolder/Arrow.visible = false


## ============================
## ---- EVENTS ---
## ============================

func _on_pickuparea_body_entered(body: Ball):
	ballRef = body
	grab_ball(body)


func _on_hitbox_body_entered(body: Node2D) -> void:
	on_death.emit()
	
func _on_throw_cooldown_timeout() -> void:
	enable_ball_pickup()
	



## ============================
## ---- MÉCANIQUES DE BALLE ---
## ============================

func grab_ball(ball: Ball) -> void:
	disable_ball_pickup()

	ball.get_state_manager().handle_state_transition(E_BallStates.held)
	ball.reparent($BallHolder)



func throw_ball(ball: Ball, strength: float):
	# Détache la balle
	ball.reparent(get_parent())

	ball.global_position = $BallHolder.global_position
	ball.get_state_manager().handle_state_transition(E_BallStates.free)
	$ThrowCooldown.start()

	# Direction du tir
	var throw_dir: Vector2 = (get_global_mouse_position() - ball.global_position).normalized()
	ball.apply_impulse(-throw_dir * strength)


func update_throw_arrow():
	$BallHolder/Arrow.visible = true
	$BallHolder/Arrow.rotation = (get_global_mouse_position() - global_position).angle()
	$BallHolder/Arrow.scale = Vector2(-charge_strength / maxThrowStrength * arrow_x_scale_factor, $BallHolder/Arrow.scale.y)


## ============================
## - ACTIVER / DÉSACTIVER PICKUP -
## ============================

func enable_ball_pickup() -> void:
	$PickupArea.connect("body_entered", _on_pickuparea_body_entered)
	
	#Grab automatiquement la balle si elle overlap déjà
	for body in $PickupArea.get_overlapping_bodies():
		if body is Ball:
			grab_ball(body)
			break


func disable_ball_pickup() -> void:
	$PickupArea.disconnect("body_entered", _on_pickuparea_body_entered)


## ============================
## -- AUTRES SETTERS -
## ============================

# Utilisé par certains states (tweens, etc.)
func set_velocity_x(value: float) -> void:
	velocity.x = value
