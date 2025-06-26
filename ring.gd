extends Area2D

@export var fall_speed := 150.0

func _process(delta) -> void:
	position.y += fall_speed * delta
	if position.y > 1400:
		queue_free()

func _ready():
	connect("input_event", Callable(self, "_on_input_event"))

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		print("Ring clicked!")
		queue_free()  # or collect, score, etc.
