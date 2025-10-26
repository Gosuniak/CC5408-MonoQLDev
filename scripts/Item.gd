extends Area2D

@onready var sprite = $Sprite2D

func _ready():
	# Agregar a un solo grupo - cualquier jugador puede recogerlo
	add_to_group("items")
	

func recoger():
	print("¡Item recogido!")
	queue_free()
