extends Area2D

signal mine_hit

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	# TODO remove after debugging
	print("DEBUG: _on_body_entered mine")
	
	if body.is_in_group("mines"):
		emit_signal("mine_hit")
