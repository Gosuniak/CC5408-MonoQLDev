extends CanvasLayer

@onready var next_level_button: Button = $PanelMenu/VBoxContainer/NextLevelButton
@onready var retry_button: Button = $PanelMenu/VBoxContainer/RetryButton
@onready var main_menu_button: Button = %MainMenuButton

func _ready() -> void:
	# Conectar señal de nivel completado del GameManager
	GameManager.nivel_completado.connect(_on_nivel_completado)
	
	# Conectar señales botones
	next_level_button.pressed.connect(_on_next_level_pressed)
	retry_button.pressed.connect(_on_retry_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	
	visible = false

func _on_nivel_completado():
	print("Señal recibida por menú victoria")
	visible = true

func _on_next_level_pressed():
	print("Botón Siguiente Nivel presionado")
	# TODO: Cargar siguiente nivel cuando lo tengas
	print("Próximamente: Nivel 2")
	# Cuando tengas nivel 2:
	# GameManager.resetear_juego()
	# get_tree().paused = false
	# get_tree().change_scene_to_file("res://scenes/nivel2.tscn")

func _on_retry_pressed():
	print("Botón Reiniciar presionado")
	# Resetear el estado del GameManager
	GameManager.resetear_juego()
	# Despausar y reiniciar el nivel
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_menu_pressed():
	visible = false
	GameManager.resetear_juego()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")
