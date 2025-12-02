extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -250.0

var push_force = 80.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var was_on_floor: bool = false

@onready var sprite_2d: Sprite2D = $Pivot/Sprite2D
@onready var label = $Label
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]
@onready var pivot: Node2D = $Pivot
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var hurtbox: Area2D = $Hurtbox

# Sonidos
@onready var jump: AudioStreamPlayer2D = $Audio/Jump
@onready var death: AudioStreamPlayer2D = $Audio/Death
@onready var pick: AudioStreamPlayer2D = $Audio/Pick
@onready var throw: AudioStreamPlayer2D = $Audio/Throw

func _ready():
	GameManager.player_bottom = self
	actualizar_label()
	add_to_group("player")
	coyote_timer.timeout.connect(_on_coyote_timeout)
	hurtbox.body_entered.connect(_on_hurtbox_body_entered)

func _physics_process(delta):
	# Gravedad
	if not is_on_floor():
		velocity.y += gravity * delta

	# Saltar con W
	if Input.is_action_just_pressed("jugador1_saltar") and (is_on_floor() or not coyote_timer.is_stopped()):
		velocity.y = JUMP_VELOCITY
		was_on_floor = false
		jump.play()

	# Movimiento con A y D
	var direction = Input.get_axis("jugador1_izquierda", "jugador1_derecha")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
	
	if was_on_floor and not is_on_floor():
		coyote_timer.start()
	if is_on_floor():
		coyote_timer.stop()
	
	was_on_floor = is_on_floor()
	
	if direction:
		pivot.scale.x = sign(direction)
	
	if is_on_floor():
		if direction or abs(velocity.x) > 10:
			playback.travel("run")
		else:
			playback.travel("idle")
	else:
		if velocity.y < 0:
			playback.travel("jump")
		else:
			playback.travel("fall")
	
	# Recoger items con S
	detectar_items()
	
	# Lanzar cajas con E
	lanzar_caja()
	
	actualizar_label()

func detectar_items():
	if Input.is_action_just_pressed("jugador1_accion"):
		# No recoger si ya tiene uno
		if GameManager.jugador1_tiene_item():
			return
			
		var items = get_tree().get_nodes_in_group("items")
		for item in items:
			if global_position.distance_to(item.global_position) < 50:
				# Preguntar al item qué escena de caja tiene
				var box_scene_to_get = item.get_box_scene()
				
				if box_scene_to_get:
					# El JUGADOR 1 recoge el item
					GameManager.jugador1_recoger_item(box_scene_to_get)
					item.recoger() # Decirle al item que se elimine
					pick.play()
					break
				else:
					print("ERROR: Item no tiene box_scene configurada")

func lanzar_caja():
	# Comprobar con la nueva función
	if Input.is_action_just_pressed("jugador1_lanzar") and GameManager.jugador1_tiene_item():
		
		# Pedir al GameManager la escena para usar
		var scene_para_lanzar = GameManager.jugador1_usar_item()
		
		if scene_para_lanzar:
			# Crear caja desde la escena obtenida
			var caja = scene_para_lanzar.instantiate()
			get_parent().add_child(caja)
			
			# Posicionar encima del jugador
			caja.global_position = global_position + Vector2(0, -40)
			
			# CONFIGURAR GRAVEDAD INVERTIDA (flota hacia arriba)
			# Todos heredan de CajaBase, así que todos tienen esta función
			caja.configurar_gravedad(true)
			throw.play()
			print("Jugador AZUL lanzó una caja (de un tipo específico) hacia ARRIBA")

func actualizar_label():
	if GameManager.jugador1_tiene_item():
		label.text = "ITEM"
	else:
		label.text = ""

func _on_coyote_timeout():
	pass

func _on_hurtbox_body_entered(_body):
	print("pinchao")
	if not visible:
		return
	death.play()
	set_physics_process(false)
	visible = false
	GameManager.game_over()
