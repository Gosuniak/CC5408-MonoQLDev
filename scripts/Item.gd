extends Area2D

@onready var sprite = $Sprite2D

@export var box_scene: PackedScene

func _ready():
	# Agregar a un solo grupo - cualquier jugador puede recogerlo
	add_to_group("items")
	if box_scene:
		# Llamamos a la función que pinta la moneda según la caja que almacene
		update_color()
	else:
		print("CUIDAO, no hay una box_scene asignada")

func update_color():
	# Idea: obtener ruta escena caja y buscar palabras clave (madera, hierro, cristal) para definir color
	var path_file = box_scene.resource_path.to_lower()
	if "madera" in path_file:
		sprite.modulate = Color.SADDLE_BROWN
	elif "cristal" in path_file:
		sprite.modulate = Color.CYAN
	elif "hierro" in path_file:
		sprite.modulate = Color.SILVER

func recoger():
	print("¡Item recogido!")
	queue_free()

func get_box_scene() -> PackedScene:
	return box_scene
