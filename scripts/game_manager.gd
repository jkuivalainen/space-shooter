# game_manager.gd
# Autoload singleton that owns game state, the survival timer, and difficulty scaling.
# Other nodes call GameManager.player_died() to trigger game over.

extends Node

enum State { PLAYING, GAME_OVER }

signal game_over(elapsed: float)

var state: State = State.PLAYING
var elapsed_time: float = 0.0


func _process(delta: float) -> void:
	if state == State.PLAYING:
		elapsed_time += delta


func player_died() -> void:
	if state == State.GAME_OVER:
		return  # ignore duplicate calls
	state = State.GAME_OVER
	emit_signal("game_over", elapsed_time)


func restart() -> void:
	# Reset state before reloading the scene so the new scene starts clean.
	state = State.PLAYING
	elapsed_time = 0.0
	get_tree().reload_current_scene()
