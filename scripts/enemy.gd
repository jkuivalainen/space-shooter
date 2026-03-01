# enemy.gd
# Red square enemy that chases the player at a fixed speed.
# On contact with the player it triggers game over; on bullet hit it dies.

extends CharacterBody2D

const SPEED: float = 120.0

# Cached reference to the player node — resolved once in _ready.
var _player: Node = null


func _ready() -> void:
	add_to_group("enemies")
	# Find the player by group so enemy doesn't need a hard scene path.
	var players := get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		_player = players[0]


func _physics_process(_delta: float) -> void:
	if GameManager.state == GameManager.State.GAME_OVER:
		return
	if _player == null:
		return

	# Simple pursuit: move directly toward the player each frame.
	var dir: Vector2 = (_player.global_position - global_position).normalized()
	velocity = dir * SPEED
	move_and_slide()

	# Check if we've reached (overlapped) the player.
	for i in get_slide_collision_count():
		var col := get_slide_collision(i)
		if col.get_collider() != null and col.get_collider().is_in_group("player"):
			GameManager.player_died()
			break


func take_hit() -> void:
	# Phase 2: drop a body here. For now, just remove the enemy.
	queue_free()
