extends Area2D

signal mine_hit(mine: Node2D)

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("mines"):
		body.queue_free()
		emit_signal("mine_hit", body)
