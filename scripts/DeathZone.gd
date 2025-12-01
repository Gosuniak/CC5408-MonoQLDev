extends Area2D

@export var causa_muerte: String = "slipped into the void."

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body == null:
		return
	if not body.is_in_group("player"):
		return
	GameManager.registrar_muerte(body, causa_muerte)


