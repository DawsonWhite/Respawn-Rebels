extends CharacterBody2D
class_name Player

@onready var idle_sheet := load("res://assets/Units/Blue Units/Archer/Archer_Idle.png")
@onready var attack_sheet := load("res://assets/Units/Blue Units/Archer/Archer_Shoot.png")
@onready var run_sheet := load("res://assets/Units/Blue Units/Archer/Archer_Run.png")
@onready var sprite := $AnimatedSprite2D
@onready var ani_player := $AnimationPlayer
@onready var attack_timer := $AttackTimer

const SPEED : int = 200
var max_health: float = 100
var current_health: int = 100
var damage_output: float = 20
var movement_speed: float = 1
var direction : Vector2
var facing_right : bool = true
@export var can_attack := true

@export var arrow_scene_string : String
var arrow_scene : Resource
var current_scene : Node2D


func _ready() -> void:
	arrow_scene = load(arrow_scene_string)
	current_scene = get_tree().get_first_node_in_group("MainScene")



func _process(_delta: float) -> void:
	direction = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		direction.y += -movement_speed
	if Input.is_action_pressed("ui_down"):
		direction.y += movement_speed
	if Input.is_action_pressed("ui_left"):
		direction.x += -movement_speed
	if Input.is_action_pressed("ui_right"):
		direction.x += movement_speed
	direction = direction.normalized()

func _physics_process(_delta: float) -> void:
	velocity = direction * SPEED
	animatePlayer()
	move_and_slide()
	
func animatePlayer():
	if direction == Vector2.ZERO:
		if can_attack:
			# I switched to animatedsprite2D's for now so this isnt needed atm, lets wait on most animations
			#sprite.texture = attack_sheet
			sprite.play("idle")
		else:
			#sprite.texture = idle_sheet
			sprite.play("idle")
	else:
		if direction.x >= 0:
			facing_right = true
		else:
			facing_right = false
		#sprite.texture = run_sheet
		sprite.play("idle")
	sprite.flip_h = !facing_right
	
func Attack(target_enemy: CharacterBody2D) -> void:
	var new_arrow: Arrow = arrow_scene.instantiate()
	new_arrow.target = target_enemy
	current_scene.add_child(new_arrow)

#for now these calc methods take in a decimal and uses it to 
#return the percent increase amount that an item would give
func CalculateMaxDamagePercentage(amount) -> float:
	return damage_output * amount

func CalculateMaxHealthPercentage(amount) -> float:
	return max_health * amount

func CalculateMaxMovementSpeedPercentage(amount) -> float:
	return movement_speed * amount

#these methods increase a max stat by a inputted amount for any items
func IncreaseMaxHealth(amount: float) -> void:
	max_health = max_health + amount
	print("Max Health  is now ", max_health)

func IncreaseMaxDamage(amount: float) -> void:
	damage_output = damage_output + amount
	print("Max Damage Output is now ", damage_output)

func IncreaseMaxMovementSpeed(amount: float) -> void:
	movement_speed = movement_speed + amount
	print("Max Movement speed is now ", movement_speed)

func heal(amount: int) -> void:
	current_health = min(current_health + amount, max_health)
	print("Player healed! Current HP: ", current_health)

func _on_attack_timer_timeout() -> void:
	can_attack = true
