extends Node

@export var sword_ability: PackedScene

const MAX_RANGE = 150

# Called when the node enters the scene tree for the first time.
func _ready():
	$SwordAbilityTimer.timeout.connect(on_timer_timeout)

func on_timer_timeout():
	var enemies = get_tree().get_nodes_in_group("enemy")
	var player = get_tree().get_first_node_in_group("player")
	enemies.filter(func(enemy: Node2D): 
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
	)
	if enemies.size() == 0:
		return
	
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
	
	var enemy = enemies[0] as Node2D
	var sword_instance = sword_ability.instantiate() as Node2D
	enemy.get_parent().add_child(sword_instance)
	sword_instance.global_position = enemy.global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4

	var enemy_direction = enemy.global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()
