# enemy_spawner.gd
# Spawns enemies from random positions on the screen edges.
# Spawn interval decreases over time (difficulty scaling) driven by GameManager.elapsed_time.

extends Node

const SPAWN_INTERVAL_START: float = 2.0
const SPAWN_INTERVAL_MIN: float = 0.3
# Reduce interval by this much for every 10 seconds survived.
const DIFFICULTY_STEP: float = 0.15

@onready var _enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")

var _spawn_timer: float = 0.0


func _process(delta: float) -> void:
	if GameManager.state == GameManager.State.GAME_OVER:
		return

	_spawn_timer -= delta
	if _spawn_timer <= 0.0:
		_spawn_enemy()
		_spawn_timer = _current_interval()


func _current_interval() -> float:
	# Linear decrease: subtract DIFFICULTY_STEP per 10 seconds elapsed.
	var reduction: float = floor(GameManager.elapsed_time / 10.0) * DIFFICULTY_STEP
	return max(SPAWN_INTERVAL_START - reduction, SPAWN_INTERVAL_MIN)


func _spawn_enemy() -> void:
	var vp_size := get_viewport().get_visible_rect().size
	var pos := _random_edge_position(vp_size)

	var enemy: Node = _enemy_scene.instantiate()
	enemy.global_position = pos
	get_tree().current_scene.add_child(enemy)


# Returns a random point on one of the four screen edges with a small outward margin.
func _random_edge_position(vp_size: Vector2) -> Vector2:
	const MARGIN: float = 30.0
	var edge := randi() % 4
	match edge:
		0:  # top
			return Vector2(randf_range(0, vp_size.x), -MARGIN)
		1:  # bottom
			return Vector2(randf_range(0, vp_size.x), vp_size.y + MARGIN)
		2:  # left
			return Vector2(-MARGIN, randf_range(0, vp_size.y))
		_:  # right
			return Vector2(vp_size.x + MARGIN, randf_range(0, vp_size.y))
