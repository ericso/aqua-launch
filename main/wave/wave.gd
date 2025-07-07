extends Node2D

func _ready():
	$AnimatedSprite2D.play()
	$AnimatedSprite2D.connect("animation_finished", Callable(self, "queue_free"))
