extends Area2D

# Lista de jugadores dentro de la zona
var jugadores_dentro = []

func _ready():
	# Conectar señales de entrada/salida
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	print("Zona de victoria creada")

func _on_body_entered(body):
	# Verificar si es un jugador
	if body == GameManager.player_bottom or body == GameManager.player_top:
		if body not in jugadores_dentro:
			jugadores_dentro.append(body)
			print("Jugador entró en zona. Total: ", jugadores_dentro.size())
			verificar_victoria()

func _on_body_exited(body):
	# Remover jugador de la lista
	if body in jugadores_dentro:
		jugadores_dentro.erase(body)
		print("Jugador salió de zona. Total: ", jugadores_dentro.size())

func verificar_victoria():
	# Verificar si AMBOS jugadores están dentro
	var jugador1_dentro = GameManager.player_bottom in jugadores_dentro
	var jugador2_dentro = GameManager.player_top in jugadores_dentro
	
	if jugador1_dentro and jugador2_dentro:
		print("¡AMBOS JUGADORES EN LA ZONA!")
		GameManager.victoria()
