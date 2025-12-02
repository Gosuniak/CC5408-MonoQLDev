extends Area2D

# Definimos señal para compuerta/plataforma
signal switch_signal(is_pressed: bool)

# Variable para arrastrar la compuerta/plataforma objetivo desde el editor
@export var targets: Array[Node2D]

# Precargamos las texturas del botón normal y presionado
const textura_normal = preload("res://assets/switch/button.png")
const textura_presionado = preload("res://assets/switch/button_pressed.png")

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var pressed_sound: AudioStreamPlayer2D = $Pressed

var is_active: bool = false

func _ready() -> void:
	if textura_normal:
		sprite_2d.texture = textura_normal
	
	# Conexión de señales del área
	body_entered.connect(_verificar_zona)
	body_exited.connect(_verificar_zona)
	
	# Conexión de switch_signal
	for target in targets:
		if target:
			if target.has_method("_on_switch_pressed"):
				# Conectar señal a la compuerta/plataformna
				switch_signal.connect(target._on_switch_pressed)
				print("conexión exitosa entre botón y ", target.name)
			else:
				print("Error: el objeto", target.name, " no tiene el método")
		else:
			print("Warning: no se ha asignado target desde el inspector")

func _verificar_zona(_body):
	# Escanear todo lo que está tocando el botón ahora mismo
	var cuerpos_detectados = get_overlapping_bodies()
	var hay_algo_valido = false
	
	# Filtrar la lista
	for cuerpo in cuerpos_detectados:
		if cuerpo.is_in_group("player") or cuerpo is RigidBody2D:
			hay_algo_valido = true
			break
	
	# Si el estado cambió respecto a cómo estaba antes, hace algo
	if hay_algo_valido != is_active:
		is_active = hay_algo_valido
		animar_visuals(is_active) # feedback visual
		emit_signal("switch_signal", is_active) # emitimos la señal para la compuerta/plataforma

func animar_visuals(pressed: bool):
	if pressed:
		# Cambiar a imagen presionada
		if textura_presionado:
			sprite_2d.texture = textura_presionado
			pressed_sound.play()
	else:
		# Volver a imagen normal
		if textura_normal:
			sprite_2d.texture = textura_normal
