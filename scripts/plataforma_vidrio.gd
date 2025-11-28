extends Node2D

@onready var area_detector = $AreaDetector

func _ready():
	# Conectamos la señal de choque
	# (Si ya la conectaste manualmente desde el editor, puedes borrar esta línea)
	if not area_detector.body_entered.is_connected(_on_body_entered):
		area_detector.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# 1. Imprime el nombre del objeto que entró
	print("--> ALGO ENTRÓ EN EL ÁREA: ", body.name)
	
	# 2. Imprime los grupos que tiene ese objeto
	print("    Sus grupos son: ", body.get_groups())
	
	# 3. Comprobación normal
	if body.is_in_group("Caja_Hierro"):
		print("    ¡ES DE HIERRO! ROMPIENDO...")
		romper_plataforma()
	else:
		print("    NO es de hierro. Ignorando.")

func romper_plataforma():
	print("¡CRASH! Plataforma de vidrio rota")
	queue_free()
