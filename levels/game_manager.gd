extends Node
@export var enemies_per_wave: int = 3
@export var wave_Scalar: int = 2
@export var enemy_scene: PackedScene
@onready var spawn_points = $Spawnpoints.get_children()
@onready var enemy_container = $Enemies
var current_wave: int = 1
var enemies_spawned: int = 0
var enemies_killed: int = 0
var enemies_required: int = 0

func _ready():
	start_wave()

func start_wave():
	print("Starting Wave ", current_wave)
	enemies_spawned = 0
	enemies_killed = 0
	enemies_required = enemies_per_wave + (current_wave - 1) * wave_Scalar
	spawn_wave(enemies_required)


func spawn_wave(amount: int):
	for i in amount:
		spawn_enemy()

func spawn_enemy():
	var enemy = enemy_scene.instantiate()

	# choose a random spawn point
	var sp = spawn_points.pick_random()
	enemy.global_position = sp.global_position
	# add to scene
	enemy_container.add_child(enemy)

	# connect to death
	if enemy.has_signal("died"):
		enemy.died.connect(_on_enemy_died)

	enemies_spawned += 1

func _on_enemy_died():
	enemies_killed += 1
	print("Enemy killed: ", enemies_killed, "/", enemies_required)

	if enemies_killed >= enemies_required:
		next_wave()


func next_wave():
	current_wave += 1
	print("Wave ", current_wave, " incoming!")
	start_wave()
