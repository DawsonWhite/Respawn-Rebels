extends CharacterBody2D
class_name Player

var bullet_path = preload("res://prefabs/Arrow/shoot.tscn")

@onready var idle_sheet := load("res://assets/Units/Blue Units/Archer/Archer_Idle.png")
@onready var attack_sheet := load("res://assets/Units/Blue Units/Archer/Archer_Shoot.png")
@onready var run_sheet := load("res://assets/Units/Blue Units/Archer/Archer_Run.png")
@onready var sprite := $AnimatedSprite2D
@onready var ani_player := $AnimationPlayer
@onready var attack_timer := $AttackTimer
@export var invincible_time: float = 0.5
var invincible: bool = false
@onready var inv_timer: Timer = $InvincibilityTimer if has_node("InvincibilityTimer") else null

var max_health: float = 100
var current_health: int = 100
var damage_output: float = 20
var movement_speed: float = 300
var direction : Vector2
var facing_right : bool = true
@export var can_attack := true
@export var respawn_position: Vector2
@export var respawn_time: float = 2.0
@export var arrow_scene_string : String
var dead := false
var arrow_scene : Resource
var current_scene : Node2D


func _ready() -> void:
	arrow_scene = load(arrow_scene_string)
	current_scene = get_tree().get_first_node_in_group("MainScene")



func _process(_delta: float) -> void:
	direction = Vector2.ZERO
	if Input.is_action_pressed("up"):
		direction.y += -movement_speed
	if Input.is_action_pressed("down"):
		direction.y += movement_speed
	if Input.is_action_pressed("left"):
		direction.x += -movement_speed
	if Input.is_action_pressed("right"):
		direction.x += movement_speed
	direction = direction.normalized()

func _physics_process(_delta: float) -> void:
	velocity = direction * movement_speed
	#animatePlayer()
	move_and_slide()
	$bullet_spawn.look_at(get_global_mouse_position())
	if can_attack:
		if Input.is_action_just_pressed("shoot"):
			fire()
			can_attack = false
			attack_timer.start()

func fire():
	var bullet = bullet_path.instantiate()
	bullet.dir = $bullet_spawn.global_position.angle_to_point(get_global_mouse_position())
	bullet.pos = $bullet_spawn.global_position
	bullet.rota = bullet.dir
	bullet.damage = damage_output
	get_parent().add_child(bullet)

func take_damage(amount: float, from_position: Vector2 = Vector2.INF) -> void:
	if invincible:
		return

	current_health -= int(amount)
	print("Player took ", amount, " damage. HP:", current_health)
	invincible = true
	if inv_timer:
		inv_timer.start(invincible_time)
	else:
		await get_tree().create_timer(invincible_time).timeout
		invincible = false

	if current_health <= 0:
		die()
func die() -> void:
	if dead:
		return
	dead = true
	print("player died")
	visible = false
	$CollisionShape2D.disabled = true
	set_physics_process(false)
	var t = Timer.new()
	t.one_shot = true
	t.wait_time = respawn_time
	t.connect("timeout", Callable(self, "_respawn"))
	add_child(t)
	t.start()

func _respawn():
	current_health = max_health
	global_position = respawn_position
	visible = true
	$CollisionShape2D.disabled = false
	set_physics_process(true)
	dead = false
	print("Player respawned")


"""func animatePlayer():
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
	sprite.flip_h = !facing_right """
	

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
	
func _on_InvincibilityTimer_timeout() -> void:
	invincible = false
