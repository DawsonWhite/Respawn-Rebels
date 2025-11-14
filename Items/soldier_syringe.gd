extends Area2D
class_name SoldierSyringe

@export var movement_speed_amount: float = .03

#subject to change but increases movement_speed stat by 3%

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if "heal" in body:
			var MaxMovementSpeedIncrease: float = body.CalculateMaxMovementSpeedPercentage(movement_speed_amount)
			body.IncreaseMaxMovementSpeed(MaxMovementSpeedIncrease)
		queue_free()
