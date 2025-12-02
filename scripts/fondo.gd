extends CanvasLayer

@onready var imagen_fondo: TextureRect = $ImagenFondo

@export var textura_personalizada: Texture2D

func _ready() -> void:
	# Si se añadió una textura personalizada, se usa
	if textura_personalizada:
		imagen_fondo.texture = textura_personalizada
