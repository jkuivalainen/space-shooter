# player.gd
# Controls the player: 8-directional movement, mouse/stick aiming, and auto-fire.

extends CharacterBody2D

const SPEED: float = 250.0
const FIRE_RATE: float = 0.2  # seconds between shots

# Preload bullet scene so we can instantiate it without a path string at runtime.
@onready var _bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")
@onready var _muzzle: Marker2D = $Muzzle  # spawn point offset from center

var _fire_timer: float = 0.0
var _dead: bool = false


func _ready() -> void:
	add_to_group("player")
	GameManager.game_over.connect(_on_game_over)


func _process(delta: float) -> void:
	if _dead:
		return
	_handle_aim()
	_handle_shooting(delta)


func _physics_process(_delta: float) -> void:
	if _dead:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	# Build movement vector from keyboard (WASD) or left stick.
	var input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input.normalized() * SPEED
	move_and_slide()

	# Keep player inside the viewport.
	var vp_size := get_viewport_rect().size
	position = position.clamp(Vector2.ZERO, vp_size)


func _handle_aim() -> void:
	# Use axis 2/3 for right stick (Godot joypad axes: 2=RX, 3=RY).
	var right_x := Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	var right_y := Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	var right_stick := Vector2(right_x, right_y)

	if right_stick.length() > 0.2:
		rotation = right_stick.angle()
	else:
		# Mouse aim: rotate toward cursor in world space.
		var mouse_pos := get_global_mouse_position()
		rotation = (mouse_pos - global_position).angle()


func _handle_shooting(delta: float) -> void:
	_fire_timer -= delta
	if _fire_timer > 0.0:
		return

	# Shoot on left mouse button or right trigger (mapped via "shoot" action).
	if Input.is_action_pressed("shoot"):
		_fire()
		_fire_timer = FIRE_RATE


func _fire() -> void:
	var bullet: Node = _bullet_scene.instantiate()
	# Spawn at the muzzle marker so bullets appear at the hexagon tip.
	bullet.global_position = _muzzle.global_position
	bullet.direction = Vector2.RIGHT.rotated(rotation)
	# Add to the main scene so the bullet isn't parented to the player.
	get_tree().current_scene.add_child(bullet)


func _on_game_over(_elapsed: float) -> void:
	_dead = true
	velocity = Vector2.ZERO
