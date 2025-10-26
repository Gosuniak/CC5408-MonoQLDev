extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $Sprite2D
@onready var label = $Label

# Precargar escena de caja
var caja_scene = preload("res://scenes/caja.tscn")

func _ready():
	GameManager.player_bottom = self
	actualizar_label()

func _physics_process(delta):
	# Gravedad
	if not is_on_floor():
		velocity.y += gravity * delta

	# Saltar con W
	if Input.is_action_just_pressed("jugador1_saltar") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movimiento con A y D
	var direction = Input.get_axis("jugador1_izquierda", "jugador1_derecha")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	# Recoger items con S
	detectar_items()
	
	# Lanzar cajas con E
	lanzar_caja()
	
	actualizar_label()

func detectar_items():
	if Input.is_action_just_pressed("jugador1_accion"):
		# Buscar CUALQUIER item
		var items = get_tree().get_nodes_in_group("items")
		for item in items:
			if global_position.distance_to(item.global_position) < 50:
				item.recoger()
				# El JUGADOR 1 recoge el item
				GameManager.jugador1_recoger_item()
				break

func lanzar_caja():
	if Input.is_action_just_pressed("jugador1_lanzar") and GameManager.jugador1_tiene_item:
		if GameManager.jugador1_usar_item():
			# Crear caja
			var caja = caja_scene.instantiate()
			get_parent().add_child(caja)
			
			# Posicionar encima del jugador
			caja.global_position = global_position + Vector2(0, -40)
			
			# CONFIGURAR GRAVEDAD INVERTIDA (flota hacia arriba)
			caja.configurar_gravedad(true)
			
			print("Jugador AZUL lanzó caja hacia ARRIBA")

func actualizar_label():
	if GameManager.jugador1_tiene_item:
		label.text = "WASD [ITEM!]"
	else:
		label.text = "WASD"
