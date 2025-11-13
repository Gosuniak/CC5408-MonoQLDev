extends Area2D

@onready var sprite = $Sprite2D

@export var box_scene: PackedScene

func _ready():
	# Agregar a un solo grupo - cualquier jugador puede recogerlo
	add_to_group("items")
	if box_scene == null:
		print("CUIDAO, no hay una box_scene asignada")
	

func recoger():
	print("¡Item recogido!")
	queue_free()

func get_box_scene() -> PackedScene:
	return box_scene
