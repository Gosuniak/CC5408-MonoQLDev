extends Node

# Singleton - Maneja items para cada jugador por separado

var jugador1_tiene_item = false  # Jugador de ABAJO
var jugador2_tiene_item = false  # Jugador de ARRIBA

# Referencias a los jugadores
var player_bottom = null
var player_top = null

func _ready():
	print("GameManager inicializado - Sistema bidireccional de cajas")

# Jugador de ABAJO recoge item
func jugador1_recoger_item():
	jugador1_tiene_item = true
	print("¡Jugador AZUL recogió item! Puede lanzar cajas hacia ARRIBA")

# Jugador de ARRIBA recoge item
func jugador2_recoger_item():
	jugador2_tiene_item = true
	print("¡Jugador VERDE recogió item! Puede lanzar cajas hacia ABAJO")

# Jugador de ABAJO usa item
func jugador1_usar_item():
	if jugador1_tiene_item:
		jugador1_tiene_item = false
		print("Jugador AZUL lanzó caja hacia ARRIBA")
		return true
	return false

# Jugador de ARRIBA usa item
func jugador2_usar_item():
	if jugador2_tiene_item:
		jugador2_tiene_item = false
		print("Jugador VERDE lanzó caja hacia ABAJO")
		return true
	return false
