extends Node

@export var basic_enemy_scene: PackedScene

const SPAWN_RADIUS = 375

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	

func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as CharacterBody2D
	if player == null:
		return
	
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
	var enemy = basic_enemy_scene.instantiate() as Node2D
	enemy.add_to_group("enemy")
	get_parent().add_child(enemy)
	enemy.global_position = spawn_position