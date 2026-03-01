# player.gd
# Controls the player: 8-directional movement, mouse/stick aiming, and auto-fire.
# Phase 2: assimilating enemy bodies adjusts _speed and _fire_rate, and bodies
# orbit the player as a shield layer.

extends CharacterBody2D

# Live stats — modified up/down by assimilate / lose_body.
var _speed: float = 160.0
var _fire_rate: float = 0.2

# Preload bullet scene so we can instantiate it without a path string at runtime.
@onready var _bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")
@onready var _muzzle: Marker2D = $Muzzle  # spawn point offset from center

var _fire_timer: float = 0.0
var _dead: bool = false

# Assimilated bodies, in assimilation order — index determines hex orbit position.
var _bodies: Array[Node] = []


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
	velocity = input.normalized() * _speed
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
		_fire_timer = _fire_rate


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


# Attach a newly dropped body to the player's hex orbit.
# The body is reparented here so it travels with the player and acts as a shield.
func assimilate(body: Node) -> void:
	_bodies.append(body)
	var index := _bodies.size() - 1
	# Expand to a new ring every 6 bodies; each ring is 28 px further out.
	var ring: int = floori(float(index) / 6.0)
	var radius := 40.0 + float(ring) * 28.0
	var angle := deg_to_rad((index % 6) * 60.0)

	# Reparent without keeping global transform — we'll set position explicitly.
	body.reparent(self, false)
	body.position = Vector2(radius, 0.0).rotated(angle)

	# Turn yellow to signal assimilation.
	var poly := body.get_node("Polygon2D")
	poly.color = Color(1.0, 1.0, 0.0, 1.0)

	# Faster shooting, slower movement — clamped so they don't hit degenerate values.
	_fire_rate = max(0.05, _fire_rate - 0.04)
	_speed = max(60.0, _speed - 15.0)


# Called by enemy_body.gd when an enemy destroys one of the orbiting bodies.
# Reverses the stat deltas applied during assimilation.
func lose_body(body: Node) -> void:
	_bodies.erase(body)
	# Cap at base values so phantom increments (e.g. from future bugs) can't push
	# stats above where they started.
	_fire_rate = min(0.2, _fire_rate + 0.04)
	_speed     = min(160.0, _speed + 15.0)
