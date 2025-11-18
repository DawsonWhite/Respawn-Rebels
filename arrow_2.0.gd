extends Area2D
class_name Arrow_2
@export var speed: float = 400
@export var damage: float
var pos: Vector2
var rota: float
var dir: float



func _ready() -> void:
	add_to_group("Arrow")
	global_position = pos
	global_rotation = rota

func _physics_process(delta: float) -> void:
	global_rotation = dir
	global_position += Vector2.RIGHT.rotated(dir) * speed * delta



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		body.take_damage(damage)
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("KillZone"):
		queue_free()
