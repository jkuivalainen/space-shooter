# main.gd
# Root scene script: initialises the game and handles the restart action.

extends Node2D


func _ready() -> void:
	# Black background is set via project rendering defaults.
	pass


func _process(_delta: float) -> void:
	# Only accept restart input when game is over.
	if GameManager.state == GameManager.State.GAME_OVER:
		if Input.is_action_just_pressed("restart"):
			GameManager.restart()
