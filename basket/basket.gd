extends Area2D

signal ring_collected

@export var basket_scale: float = 1.0

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	
	# resize the basket
	$Sprite.scale = Vector2.ONE * basket_scale
	$CollisionShape.scale = Vector2.ONE * basket_scale

func _on_body_entered(body):
	if body.is_in_group("rings"):
		body.queue_free()
		emit_signal("ring_collected")
