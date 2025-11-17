extends CharacterBody2D
class_name Arrow

var target : CharacterBody2D
var target_coords : Vector2
const flight_speed := 200

func _ready() -> void:
	target_coords = target.position
	
func _physics_process(_delta: float) -> void:
	var direction = position.direction_to(target_coords)
	velocity = direction + flight_speed
	var angle = direction.angle()
	rotation = angle
