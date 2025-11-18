extends Area2D
class_name SoldierSyringe

@export var attack_speed_increase: float = .1

#subject to change but increases attack_speed stat by 3%

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if "heal" in body:
			var AttackSpeedPercentIncrease = body.CalculateMaxAttackSpeedPercentage(attack_speed_increase)
			body.IncreaseMaxAttackSpeed(AttackSpeedPercentIncrease)
		queue_free()
