extends Area2D
class_name BisonSteak

@export var max_health_amount: int = 10

#subject to change but increases max_health stat by 10 (not percent ig?)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if "heal" in body:
			body.IncreaseMaxHealth(max_health_amount)
		queue_free()
