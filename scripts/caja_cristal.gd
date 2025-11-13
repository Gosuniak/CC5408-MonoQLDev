extends "res://scripts/Caja_Base.gd"

@onready var timer: Timer = $Timer
@onready var top_detector: Area2D = $TopDetector
@onready var down_detector: Area2D = $DownDetector

var ha_sido_pisada = false

func _ready():
	super()
	# Conectar señales en el código
	top_detector.body_entered.connect(_on_detector_body_entered)
	down_detector.body_entered.connect(_on_detector_body_entered)
	timer.timeout.connect(_on_break_timer_timeout)

func _on_detector_body_entered(body):
	# Comprobar si el cuerpo es un jugador y si no hemos sido pisados ya
	if body.is_in_group("player") and not ha_sido_pisada:
		ha_sido_pisada = true
		print("Caja de CRISTAL ha sido pisada (por arriba o abajo)")
		timer.start()
		# Opcional: Aquí puedes cambiar el sprite a uno "roto"
		# $Pivot/Sprite2D.texture = preload("res://sprites/caja_cristal_rota.png")

func _on_break_timer_timeout():
	print("Caja de CRISTAL se rompió")
	queue_free() # Adiós, caja
