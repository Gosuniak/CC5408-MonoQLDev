extends CanvasLayer

# --- NUEVO: Variable para elegir el nivel desde el inspector ---
# El filtro "*.tscn" hace que solo puedas elegir escenas de Godot
@export_file("*.tscn") var siguiente_nivel_path: String 

@onready var next_level_button: Button = $PanelMenu/VBoxContainer/NextLevelButton
@onready var retry_button: Button = $PanelMenu/VBoxContainer/RetryButton
@onready var main_menu_button: Button = %MainMenuButton

func _ready() -> void:
	GameManager.nivel_completado.connect(_on_nivel_completado)
	
	next_level_button.pressed.connect(_on_next_level_pressed)
	retry_button.pressed.connect(_on_retry_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	
	visible = false

func _on_nivel_completado():
	print("Señal recibida por menú victoria")
	visible = true
	
	# Opcional: Si no hay siguiente nivel configurado, ocultar el botón "Siguiente"
	if siguiente_nivel_path == "":
		next_level_button.visible = false
	else:
		next_level_button.visible = true # Por seguridad
		next_level_button.grab_focus() # Para que se pueda usar con teclado/gamepad

func _on_next_level_pressed():
	print("Cargando siguiente nivel...")
	
	if siguiente_nivel_path != "":
		# 1. Resetear datos del GameManager
		GameManager.resetear_juego()
		# 2. Quitar pausa
		get_tree().paused = false
		# 3. Cambiar a la escena que configuraste en el inspector
		get_tree().change_scene_to_file(siguiente_nivel_path)
	else:
		print("ERROR: No has asignado un nivel en el Inspector")
		# Opcional: Si es el último nivel, podrías mandarlos a los créditos
		# _on_main_menu_pressed() 

func _on_retry_pressed():
	print("Botón Reiniciar presionado")
	GameManager.resetear_juego()
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_menu_pressed():
	visible = false
	GameManager.resetear_juego()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")
