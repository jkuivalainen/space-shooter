# enemy_body.gd
# Dropped at an enemy's death position. Two interactions:
#   - Player walks over it → player.assimilate(self): reparented to player, grants stat bonus
#   - Enemy hits it → player.lose_body(self): stat bonus reversed, body freed
#
# Assimilation is retried every frame while the player overlaps the body, so a
# previously full slot becoming free is picked up without the player having to
# leave and re-enter.

extends Area2D

var _assimilated: bool = false
# Non-null while the player is physically overlapping this body.
var _nearby_player: Node = null


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _process(_delta: float) -> void:
	if _assimilated or _nearby_player == null:
		return
	# Keep trying each frame until a slot on the player's hexagon becomes free.
	if _nearby_player.assimilate(self):
		_assimilated = true


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		_nearby_player = body
	elif body.is_in_group("enemies"):
		# Only reverse stat bonuses if the player has already assimilated this body.
		# An unassimilated body hasn't granted any bonus, so just destroy it silently.
		if _assimilated:
			var players := get_tree().get_nodes_in_group("player")
			if players.size() > 0:
				players[0].lose_body(self)
		queue_free()


func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		_nearby_player = null
