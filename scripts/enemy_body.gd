# enemy_body.gd
# Dropped at an enemy's death position. Two interactions:
#   - Player walks over it → player.assimilate(self): reparented to player, grants stat bonus
#   - Enemy hits it → player.lose_body(self): stat bonus reversed, body freed

extends Area2D

# Prevents the player from assimilating the same body twice if they stay overlapping.
var _assimilated: bool = false


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if _assimilated:
			return
		_assimilated = true
		body.assimilate(self)
	elif body.is_in_group("enemies"):
		# Find player to reverse the stat bonus, then remove this body.
		var players := get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			players[0].lose_body(self)
		queue_free()
