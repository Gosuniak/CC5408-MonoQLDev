extends Node2D

@onready var fondo_victoria = $UIVictoria/FondoVictoria
@onready var panel_menu = $UIVictoria/PanelMenu
@onready var btn_siguiente = $UIVictoria/PanelMenu/BtnSiguienteNivel
@onready var btn_reiniciar = $UIVictoria/PanelMenu/BtnReiniciar

func _ready():
	# Conectar señal de nivel completado del GameManager
	GameManager.nivel_completado.connect(_on_nivel_completado)
	
	# Conectar señales de los botones
	btn_siguiente.pressed.connect(_on_siguiente_nivel)
	btn_reiniciar.pressed.connect(_on_reiniciar_nivel)

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
