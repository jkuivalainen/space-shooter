# hud.gd
# Manages the on-screen timer and the game-over overlay.

extends CanvasLayer

@onready var _timer_label: Label = $TimerLabel
@onready var _overlay: Control = $GameOverOverlay
@onready var _final_time_label: Label = $GameOverOverlay/VBoxContainer/FinalTimeLabel


func _ready() -> void:
	GameManager.game_over.connect(_on_game_over)


func _process(_delta: float) -> void:
	if GameManager.state == GameManager.State.PLAYING:
		_timer_label.text = _format_time(GameManager.elapsed_time)


func _on_game_over(elapsed: float) -> void:
	_final_time_label.text = "Time: " + _format_time(elapsed)
	_overlay.visible = true


# Converts seconds to MM:SS string.
func _format_time(seconds: float) -> String:
	var s := int(seconds)
	return "%02d:%02d" % [s / 60, s % 60]
