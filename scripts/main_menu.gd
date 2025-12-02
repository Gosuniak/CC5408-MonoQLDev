extends Control

@export var main_scene: PackedScene

@onready var start_button: Button = %StartButton
@onready var credits_button: Button = %CreditsButton
@onready var quit_button: Button = %QuitButton
@onready var credits_overlay: ColorRect = %CreditsOverlay
@onready var close_credits_button: Button = %CloseCreditsButton
@onready var cat_image: TextureRect = %CatImage

var _cat_idle_tween: Tween

func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	credits_button.pressed.connect(_on_credits_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	close_credits_button.pressed.connect(_hide_credits)
	_set_default_focus()
	_start_cat_idle_animation()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and not _is_overlay_open():
		_on_start_pressed()
	elif event.is_action_pressed("ui_cancel") and _is_overlay_open():
		_hide_credits()

func _on_start_pressed():
	get_tree().change_scene_to_packed(main_scene)

func _on_credits_pressed():
	_show_credits()

func _on_quit_pressed():
	get_tree().quit()

func _show_credits() -> void:
	if not is_instance_valid(credits_overlay):
		return
	credits_overlay.visible = true
	if is_instance_valid(close_credits_button):
		close_credits_button.grab_focus()

func _hide_credits() -> void:
	if is_instance_valid(credits_overlay):
		credits_overlay.visible = false
	_set_default_focus()

func _set_default_focus() -> void:
	if is_instance_valid(start_button):
		start_button.grab_focus()

func _is_overlay_open() -> bool:
	return is_instance_valid(credits_overlay) and credits_overlay.visible

func _start_cat_idle_animation() -> void:
	if not is_instance_valid(cat_image):
		return
	if is_instance_valid(_cat_idle_tween):
		_cat_idle_tween.kill()

	var base_position := cat_image.position
	_cat_idle_tween = create_tween().set_loops()
	_cat_idle_tween.tween_property(cat_image, "position:y", base_position.y - 6.0, 1.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_cat_idle_tween.tween_property(cat_image, "position:y", base_position.y, 1.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
