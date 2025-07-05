extends Node2D

func _ready():
	# reduce the size of the twinkle animation
	$AnimatedSprite2D.scale = Vector2.ONE * 0.5
	$AnimatedSprite2D.play()
	$AnimatedSprite2D.connect("animation_finished", Callable(self, "queue_free"))
