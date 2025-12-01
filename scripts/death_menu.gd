extends CanvasLayer

const MAIN_MENU_SCENE_PATH := "res://ui/main_menu.tscn"

@onready var death_ui: Control = $DeathUI
@onready var title_label: Label = %TitleLabel
@onready var description_label: Label = %DescriptionLabel
@onready var cause_label: Label = %CauseLabel
@onready var retry_button: Button = %RetryButton
@onready var main_menu_button: Button = %MainMenuButton

var _is_showing := false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	death_ui.visible = false
	retry_button.pressed.connect(_on_retry_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	var death_signal := GameManager.jugador_muerto
	if death_signal.is_connected(Callable(self, "_on_jugador_muerto")):
		return
	death_signal.connect(Callable(self, "_on_jugador_muerto"))

func _unhandled_input(event: InputEvent) -> void:
	if not _is_showing:
		return
	if event.is_action_pressed("ui_accept"):
		_on_retry_pressed()
	elif event.is_action_pressed("pause"):
		_on_main_menu_pressed()

func _on_jugador_muerto(_player: Node, nombre_jugador: String, causa: String) -> void:
	if _is_showing:
		return
	_is_showing = true
	death_ui.visible = true
	title_label.text = "%s is down!" % nombre_jugador
	description_label.text = "Both kittens need to survive to finish the run."
	cause_label.text = "%s %s" % [nombre_jugador, causa]
	retry_button.grab_focus()

func _on_retry_pressed() -> void:
	_hide_menu()
	GameManager.resetear_juego()
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_menu_pressed() -> void:
	_hide_menu()
	GameManager.resetear_juego()
	get_tree().paused = false
	get_tree().change_scene_to_file(MAIN_MENU_SCENE_PATH)

func _hide_menu() -> void:
	_is_showing = false
	death_ui.visible = false

