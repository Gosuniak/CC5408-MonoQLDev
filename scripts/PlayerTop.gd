extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = 400.0

# Gravedad invertida
var gravity = -ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $Sprite2D
@onready var label = $Label
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]
@onready var pivot: Node2D = $Pivot

# Precargar escena de caja
var caja_scene = preload("res://scenes/caja.tscn")

func _ready():
	GameManager.player_top = self
	actualizar_label()

func _physics_process(delta):
	# Gravedad invertida
	if not is_on_ceiling():
		velocity.y += gravity * delta

	# Saltar con Flecha Arriba
	if Input.is_action_just_pressed("jugador2_saltar") and is_on_ceiling():
		velocity.y = JUMP_VELOCITY

	# Movimiento con Flechas
	var direction = Input.get_axis("jugador2_izquierda", "jugador2_derecha")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if direction:
		pivot.scale.x = sign(direction)
	
	if is_on_ceiling():
		if direction or abs(velocity.x) > 10:
			playback.travel("run")
		else:
			playback.travel("idle")
	else:
		if velocity.y > 0:
			playback.travel("jump")
		else:
			playback.travel("fall")
	
	# Recoger items con Flecha Abajo
	detectar_items()
	
	# Lanzar cajas con Ctrl
	lanzar_caja()
	
	actualizar_label()

func detectar_items():
	if Input.is_action_just_pressed("jugador2_accion"):
		# Buscar CUALQUIER item
		var items = get_tree().get_nodes_in_group("items")
		for item in items:
			if global_position.distance_to(item.global_position) < 50:
				item.recoger()
				# El JUGADOR 2 recoge el item
				GameManager.jugador2_recoger_item()
				break

func lanzar_caja():
	if Input.is_action_just_pressed("jugador2_lanzar") and GameManager.jugador2_tiene_item:
		if GameManager.jugador2_usar_item():
			# Crear caja
			var caja = caja_scene.instantiate()
			get_parent().add_child(caja)
			
			# Posicionar debajo del jugador superior
			caja.global_position = global_position + Vector2(0, 40)
			
			# CONFIGURAR GRAVEDAD NORMAL (cae hacia abajo)
			caja.configurar_gravedad(false)
			
			print("Jugador VERDE lanzó caja hacia ABAJO")

func actualizar_label():
	if GameManager.jugador2_tiene_item:
		label.text = "FLECHAS [ITEM!]"
	else:
		label.text = "FLECHAS"
