# bullet.gd
# A fast-moving projectile fired by the player.
# Travels in a fixed direction and destroys itself on contact or when leaving the screen.

extends Area2D

const SPEED: float = 800.0

var direction: Vector2 = Vector2.RIGHT

# Screen bounds are cached on ready to avoid repeated viewport queries.
var _screen_rect: Rect2


func _ready() -> void:
	var vp_size := get_viewport_rect().size
	_screen_rect = Rect2(Vector2.ZERO, vp_size)
	# Connect the body/area overlap signal to handle enemy hits.
	body_entered.connect(_on_body_entered)


func _process(delta: float) -> void:
	position += direction * SPEED * delta
	# Destroy when the bullet leaves the visible screen with a small margin.
	if not _screen_rect.grow(20.0).has_point(position):
		queue_free()


func _on_body_entered(body: Node) -> void:
	# Bullet hits anything with the "enemy" group — let enemy handle its own death.
	if body.is_in_group("enemies"):
		body.take_hit()
		queue_free()
