extends Node

# Singleton - Maneja items para cada jugador por separado
var jugador1_item_scene: PackedScene = null
var jugador2_item_scene: PackedScene = null

# Referencias a los jugadores
var player_bottom = null
var player_top = null

func _ready():
	print("GameManager inicializado - Sistema bidireccional de cajas")

# Jugador de ABAJO recoge item
func jugador1_recoger_item(scene: PackedScene):
	if jugador1_item_scene == null:
		jugador1_item_scene = scene
		print("¡Jugador AZUL recogió item! Puede lanzar cajas hacia ARRIBA")

# Jugador de ARRIBA recoge item
func jugador2_recoger_item(scene: PackedScene):
	if jugador2_item_scene == null:
		jugador2_item_scene = scene
		print("¡Jugador VERDE recogió item! Puede lanzar cajas hacia ABAJO")

# Jugador de ABAJO usa item
func jugador1_usar_item() -> PackedScene:
	if jugador1_item_scene != null:
		var scene_to_spawn = jugador1_item_scene
		jugador1_item_scene = null # Consumir el item
		print("Jugador AZUL usará item para lanzar caja.")
		return scene_to_spawn
	return null # No tiene item

# Jugador de ARRIBA usa item
func jugador2_usar_item() -> PackedScene:
	if jugador2_item_scene != null:
		var scene_to_spawn = jugador2_item_scene
		jugador2_item_scene = null # Consumir el item
		print("Jugador VERDE usará item para lanzar caja.")
		return scene_to_spawn
	return null # No tiene item

# Helper para saber si tiene *cualquier* item (para el UI)
func jugador1_tiene_item() -> bool:
	return jugador1_item_scene != null
	
func jugador2_tiene_item() -> bool:
	return jugador2_item_scene != null

# === SISTEMA DE VICTORIA ===

signal nivel_completado
signal jugador_muerto(jugador, nombre_jugador, causa)
signal game_over_signal

var juego_terminado = false
const PLAYER_BOTTOM_NAME := "Blue kitten"
const PLAYER_TOP_NAME := "Green kitten"

func victoria():
	if juego_terminado:
		return
	juego_terminado = true
	print("¡¡¡ NIVEL COMPLETADO !!!")
	emit_signal("nivel_completado")
	get_tree().paused = true

func registrar_muerte(player: Node, causa: String = "was lost."):
	if juego_terminado:
		return
	juego_terminado = true
	var nombre = _obtener_nombre_jugador(player)
	print("%s murió: %s" % [nombre, causa])
	emit_signal("jugador_muerto", player, nombre, causa)
	get_tree().paused = true

func game_over():
	if juego_terminado:
		return
	print("Game ouva")
	juego_terminado = true
	emit_signal("game_over_signal")
	get_tree().paused = true

func reiniciar_escena():
	resetear_juego()
	get_tree().reload_current_scene()

# Función para resetear el estado del juego
func resetear_juego():
	juego_terminado = false
	jugador1_item_scene = null
	jugador2_item_scene = null
	get_tree().paused = false
	print("GameManager reseteado")

func _obtener_nombre_jugador(player: Node) -> String:
	if player == player_bottom:
		return PLAYER_BOTTOM_NAME
	if player == player_top:
		return PLAYER_TOP_NAME
	return "Unknown kitten"
