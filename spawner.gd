extends Node2D

@onready var ring_scene = preload("res://ring.tscn")

var spawn_timer := 0.0

@export var spawn_interval := 1.5 # seconds

func _process(delta: float) -> void:
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_timer = 0;
		spawn_ring()

func spawn_ring():
	var ring = ring_scene.instantiate()
	var x_pos = randf_range(50, 670) # Avoid edges of 720px wide screen
	ring.position = Vector2(x_pos, -100)
	add_child(ring)
