extends CharacterBody2D
class_name basicmelee

@onready var idle_sheet := load("res://assets/Units/Red Units/Warrior/Warrior_Idle.png")
@onready var run_sheet := load("res://assets/Units/Red Units/Warrior/Warrior_Run.png")
@onready var attack_sheet := load("res://assets/Units/Red Units/Warrior/Warrior_Attack1.png")
@onready var ani_player := $AnimationPlayer
@onready var nav_agent := $NavigationAgent2D
@onready var sprite := $Sprite2D
var player_ref : Player
var current_state : STATE
const SPEED := 100
enum STATE {
	RUN,
	ATTACK,
	IDLE
}


func _ready() -> void:
	player_ref = get_tree().get_first_node_in_group("Player")
	ani_player.play("run")
	
func _physics_process(delta: float) -> void:
	if current_state == STATE.RUN:
		nav_agent.target_position = player_ref.position
		velocity = position.direction_to(nav_agent.get_next_path_position()) * SPEED
		move_and_slide()


func change_State(new_state:STATE): 
	if new_state == STATE.RUN:
		sprite.texture = run_sheet
	elif new_state == STATE.ATTACK:
		sprite.texture = attack_sheet
	else:
		sprite.texture = idle_sheet
		
		


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		ani_player.play("attack")

func _on_timer_timeout() -> void:
	ani_player.play("run")
