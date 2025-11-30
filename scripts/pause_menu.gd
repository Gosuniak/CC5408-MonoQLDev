extends CanvasLayer

@onready var continue_button: Button = %ContinueButton
@onready var retry_button: Button = %RetryButton
@onready var main_menu_button: Button = %MainMenuButton

func _ready() -> void:
	continue_button.pressed.connect(_on_continue_pressed)
	retry_button.pressed.connect(_on_retry_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	$PauseUI.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_toggle_pause()
	elif event.is_action_pressed("ui_accept") and visible:
		_on_continue_pressed()

func _on_continue_pressed():
	_set_menu_state(false)

func _on_retry_pressed():
	_set_menu_state(false)
	get_tree().reload_current_scene()

func _on_main_menu_pressed():
	_set_menu_state(false)
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")

func _toggle_pause() -> void:
	var will_pause := not get_tree().paused
	get_tree().paused = will_pause
	_set_menu_state(will_pause)

func _set_menu_state(show: bool) -> void:
	$PauseUI.visible = show
	if show:
		continue_button.grab_focus()
	else:
		get_tree().paused = false
