extends CharacterBody2D
class_name basicmelee
signal died
#@onready var idle_sheet := load("res://assets/Units/Red Units/Warrior/Warrior_Idle.png")
#@onready var run_sheet := load("res://assets/Units/Red Units/Warrior/Warrior_Run.png")
#@onready var attack_sheet := load("res://assets/Units/Red Units/Warrior/Warrior_Attack1.png")
#@onready var ani_player := $AnimationPlayer
@onready var nav_agent := $NavigationAgent2D
@onready var sprite := $AnimatedSprite2D
@onready var attack_hitbox := $Area2D

#@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var player_ref : Player
var player_in_range: Player = null  
var current_state : STATE
const SPEED := 200
var damage_output: float = 20
var already_hit: Array = []
var can_attack := true
@export var attack_cooldown := 2.0

@export var max_health: float = 50
var health: float = 50


enum STATE {
	RUN,
	ATTACK,
	IDLE
}


func _ready() -> void:
	health = max_health
	player_ref = get_tree().get_first_node_in_group("Player")
	sprite.play("walk_animation")

func _physics_process(_delta: float) -> void:
	if current_state == STATE.RUN:
		nav_agent.target_position = player_ref.position
		velocity = position.direction_to(nav_agent.get_next_path_position()) * SPEED
		move_and_slide()
	if player_in_range:
		try_attack()

func try_attack():
	if not can_attack:
		return
	can_attack = false
	start_attack()
	var t = Timer.new()
	t.one_shot = true
	t.wait_time = attack_cooldown
	t.connect("timeout", Callable(self, "_on_attack_cooldown_timeout"))
	add_child(t)
	t.start()

func change_State(new_state:STATE): 
	if new_state == STATE.RUN:
		sprite.play("walk_animation")
	elif new_state == STATE.ATTACK:
		sprite.play("attack_animation")

func take_damage(amount: float) -> void:
	health -= amount
	print("Enemy took damage: ", amount, " | HP left: ", health)
	if health <= 0:
		die()

func die() -> void:
	print("enemy died")
	died.emit()
	queue_free()

func _on_area_2d_body_entered(body) -> void: #Hitbox entered
	if body.is_in_group("Player"):
		player_in_range = body
		start_attack()
		deal_damage_frame()
		reset_attack_hits()

func _on_area_2d_body_exited(body) -> void: #Hitbox exited
	if body == player_in_range:
		player_in_range = null
		change_State(STATE.RUN)
		sprite.play("walk_animation")

func start_attack():
	change_State(STATE.ATTACK)
	sprite.play("attack_animation")



func deal_damage_frame():
	if player_in_range and player_in_range not in already_hit:
		player_in_range.take_damage(damage_output)
		already_hit.append(player_in_range)

func _on_timer_timeout() -> void:
	sprite.play("walk_animation")
	
func reset_attack_hits():
	already_hit.clear()

func _on_attack_cooldown_timeout():
	can_attack = true
