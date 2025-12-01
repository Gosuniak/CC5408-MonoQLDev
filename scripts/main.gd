extends Node2D

const DEATH_MENU_SCENE := preload("res://ui/death_menu.tscn")
const DEATH_ZONE_SCENE := preload("res://scripts/DeathZone.gd")
const PLAYER_LAYER_MASK := 2
const DEATH_ZONE_EXTRA_WIDTH := 400.0
const DEATH_ZONE_DEPTH := 120.0
const DEATH_ZONE_PADDING := 80.0

@onready var fondo_victoria: ColorRect = $UIVictoria/FondoVictoria
@onready var panel_menu: Control = $UIVictoria/PanelMenu
@onready var btn_siguiente: Button = %BtnSiguienteNivel
@onready var btn_reiniciar: Button = %BtnReiniciar
@onready var tile_map_layer: TileMapLayer = $TileMapLayer

var death_menu_instance: CanvasLayer = null

func _ready():
	# Conectar señal de nivel completado del GameManager
	GameManager.nivel_completado.connect(_on_nivel_completado)
	_ensure_death_menu()
	_spawn_death_zones()
	
	# Conectar señales de los botones, con validaciones por si alguna ruta cambió
	if is_instance_valid(btn_siguiente):
		btn_siguiente.pressed.connect(_on_siguiente_nivel)
	else:
		push_warning("BtnSiguienteNivel no se encontró en UIVictoria.")

	if is_instance_valid(btn_reiniciar):
		btn_reiniciar.pressed.connect(_on_reiniciar_nivel)
	else:
		push_warning("BtnReiniciar no se encontró en UIVictoria.")

func _on_nivel_completado():
	print("Main recibió señal de nivel completado")
	
	# Mostrar UI de victoria
	fondo_victoria.visible = true
	panel_menu.visible = true

func _on_siguiente_nivel():
	print("Botón Siguiente Nivel presionado")
	# TODO: Cargar siguiente nivel cuando lo tengas
	print("Próximamente: Nivel 2")
	# Cuando tengas nivel 2:
	# GameManager.resetear_juego()
	# get_tree().paused = false
	# get_tree().change_scene_to_file("res://scenes/nivel2.tscn")

func _on_reiniciar_nivel():
	print("Botón Reiniciar presionado")
	# Resetear el estado del GameManager
	GameManager.resetear_juego()
	# Despausar y reiniciar el nivel
	get_tree().paused = false
	get_tree().reload_current_scene()

func _ensure_death_menu() -> void:
	if death_menu_instance and is_instance_valid(death_menu_instance):
		return
	if DEATH_MENU_SCENE == null:
		return
	death_menu_instance = DEATH_MENU_SCENE.instantiate()
	death_menu_instance.name = "DeathMenu"
	add_child(death_menu_instance)

func _spawn_death_zones() -> void:
	if DEATH_ZONE_SCENE == null:
		return
	if get_node_or_null("BottomDeathZone") or get_node_or_null("TopDeathZone"):
		return
	if tile_map_layer == null:
		return
	var used_rect: Rect2i = tile_map_layer.get_used_rect()
	var tile_set := tile_map_layer.tile_set
	var cell_size := Vector2(16, 16)
	if tile_set:
		var ts_size: Vector2i = tile_set.tile_size
		cell_size = Vector2(ts_size.x, ts_size.y)
	var used_position := used_rect.position
	var used_size := used_rect.size
	var top_left := Vector2(used_position.x, used_position.y) * cell_size + tile_map_layer.position
	var bottom_right := Vector2(used_position.x + used_size.x, used_position.y + used_size.y) * cell_size + tile_map_layer.position
	var center_x := (top_left.x + bottom_right.x) * 0.5
	var width := (bottom_right.x - top_left.x) + DEATH_ZONE_EXTRA_WIDTH
	var top_y := top_left.y - DEATH_ZONE_PADDING
	var bottom_y := bottom_right.y + DEATH_ZONE_PADDING
	_create_death_zone("TopDeathZone", Vector2(center_x, top_y), Vector2(width, DEATH_ZONE_DEPTH), "drifted above the safe ceiling.")
	_create_death_zone("BottomDeathZone", Vector2(center_x, bottom_y), Vector2(width, DEATH_ZONE_DEPTH), "slipped beneath the platforms.")

func _create_death_zone(name: String, position: Vector2, size: Vector2, causa: String) -> void:
	var zone: Area2D = DEATH_ZONE_SCENE.new()
	zone.name = name
	zone.position = position
	zone.causa_muerte = causa
	zone.collision_layer = 0
	zone.collision_mask = PLAYER_LAYER_MASK
	zone.process_mode = Node.PROCESS_MODE_ALWAYS
	var collision_shape := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = size
	collision_shape.shape = shape
	zone.add_child(collision_shape)
	add_child(zone)
