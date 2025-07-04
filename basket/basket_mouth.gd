extends Area2D

signal ring_collected

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("rings"):
		body.queue_free()
		emit_signal("ring_collected")
