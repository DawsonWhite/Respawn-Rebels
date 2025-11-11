extends CharacterBody2D
class_name Player

@onready var idle_sheet := load("res://assets/Units/Blue Units/Archer/Archer_Idle.png")
@onready var attack_sheet := load("res://assets/Units/Blue Units/Archer/Archer_Shoot.png")
@onready var run_sheet := load("res://assets/Units/Blue Units/Archer/Archer_Run.png")
@onready var sprite := $Sprite2D
@onready var ani_player := $AnimationPlayer
@onready var attack_timer := $AttackTimer

const SPEED : int = 200
var direction : Vector2
var facing_right : bool = true
@export var can_attack := true

@export var arrow_scene_string : String
var arrow_scene : Resource
var current_scene : Node2D


func _ready() -> void:
	arrow_scene = load(arrow_scene_string)
	current_scene = get_tree().get_first_node_in_group("MainScene")



func _process(delta: float) -> void:
	direction = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		direction.y += -1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_left"):
		direction.x += -1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	direction = direction.normalized()

func _physics_process(delta: float) -> void:
	velocity = direction * SPEED
	animatePlayer()
	move_and_slide()
	
func animatePlayer():
	if direction == Vector2.ZERO:
		if can_attack:
			sprite.texture = attack_sheet
			ani_player.play("attack")
		else:
			sprite.texture = idle_sheet
			ani_player.play("idle")
	else:
		if direction.x >= 0:
			facing_right = true
		else:
			facing_right = false
		sprite.texture = run_sheet
		ani_player.play("run")
	sprite.flip_h = !facing_right
	
func Attack():
	var new_arrow : Arrow = arrow_scene.instantiate()
	current_scene.add_child(new_arrow)
	
	


func _on_attack_timer_timeout() -> void:
	can_attack = true
