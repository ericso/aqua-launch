extends Node2D

@onready var ring_scene = preload("res://ring.tscn")
@onready var ripple_scene = preload("res://ripple.tscn")

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

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		apply_wave_impulse(event.position)

func apply_wave_impulse(tap_pos: Vector2) -> void:
	var ripple = ripple_scene.instantiate()
	ripple.global_position = tap_pos
	add_child(ripple)
	
	# TODO remove after testing
	print("Tap at: ", tap_pos)
	for ring in get_tree().get_nodes_in_group("rings"):
		if ring is RigidBody2D:
			var dir = ring.global_position - tap_pos
			var distance = dir.length()
			if distance == 0:
				continue
			var force = clamp(5000 / distance, 50, 600)  # Inverse falloff
			ring.apply_impulse(dir.normalized() * force)
