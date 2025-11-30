extends AnimatableBody2D

@export var desplazamiento: Vector2 = Vector2(0, -50)
@export var velocidad: float = 0.5

var posicion_cerrada: Vector2
var posicion_abierta: Vector2
var tween: Tween

func _ready() -> void:
	posicion_cerrada = global_position
	posicion_abierta = global_position + desplazamiento

func _on_switch_pressed(is_pressed: bool):
	# Cancelamos animación anterior si existe
	if tween:
		tween.kill()
	
	tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	if is_pressed:
		# Abrir
		tween.tween_property(self, "global_position", posicion_abierta, velocidad)
		print("puerta abriéndose")
	else:
		# Cerrar
		tween.tween_property(self, "global_position", posicion_cerrada, velocidad)
		print("puerta cerrándose")
