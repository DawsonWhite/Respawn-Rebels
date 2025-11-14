extends Area2D
class_name MagicMushroom

@export var heal_amount: float = .03
@export var damage_amount: float = .03
@export var movement_speed_amount: float = .03

#subject to change but increases all stats by 3%

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if "heal" in body:
			var DamagePercentIncrease: float = body.CalculateMaxDamagePercentage(damage_amount)
			var MaxHealthPercentIncrease: float = body.CalculateMaxHealthPercentage(heal_amount)
			var MaxMovemenrSpeedIncrease: float = body.CalculateMaxMovementSpeedPercentage(movement_speed_amount)
			body.IncreaseMaxHealth(MaxHealthPercentIncrease)
			body.IncreaseMaxDamage(DamagePercentIncrease)
			body.IncreaseMaxMovementSpeed(MaxMovemenrSpeedIncrease)
		queue_free()
