extends Area2D
class_name JetFuel

@export var movement_speed_amount: float = .1

#subject to change but increases movement_speed stat by 10%

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if "heal" in body:
			var MaxMovemenrSpeedIncrease: float = body.CalculateMaxMovementSpeedPercentage(movement_speed_amount)
			body.IncreaseMaxMovementSpeed(MaxMovemenrSpeedIncrease)
		queue_free()
