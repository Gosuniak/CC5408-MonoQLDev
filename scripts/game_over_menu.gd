extends CanvasLayer

@onready var retry_button: Button = %RetryButton
@onready var main_menu_button: Button = %MainMenuButton

func _ready() -> void:
	# Empieza oculto
	visible = false
	
	# Conectar a la señal game_over_signal del GameManager
	GameManager.game_over_signal.connect(_on_game_over_signal)
	
	# Conectar botones
	retry_button.pressed.connect(_on_retry_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)

func _on_game_over_signal():
	# Mostrar menú cuando un jugador muere (el juego se pausa)
	visible = true
	retry_button.grab_focus()

func _on_retry_pressed():
	GameManager.resetear_juego() # resetea variables
	get_tree().paused = false # despausa el juego
	get_tree().reload_current_scene() # recarga la escena

func _on_main_menu_pressed():
	visible = false # oculta el menú
	GameManager.resetear_juego() # resetea variables
	get_tree().paused = false # despausa el juego
	get_tree().change_scene_to_file("res://ui/main_menu.tscn") # carga la escena del menú principal
