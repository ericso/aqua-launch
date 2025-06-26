extends Node2D

@onready var ring_scene = preload("res://ring.tscn")
@onready var ripple_scene = preload("res://ripple.tscn")

var spawn_timer := 0.0

# spawn rate of rings is dependent on the number of rings on screen
# more rings on screen increases the spawn interval
@export var spawn_interval := 1.0 # default spawn rate in seconds
@export var base_interval := 1.0
@export var interval_per_ring := 3.0
@export var max_interval := 10.0

@export var nudge_force = 100000
var min_nudge_force = 0
var max_nudge_force = nudge_force / 2

func _process(delta: float) -> void:
	spawn_timer += delta
	
	var visible_ring_count = get_visible_ring_count()
	spawn_interval = clamp(base_interval + (visible_ring_count * interval_per_ring), base_interval, max_interval)

	if spawn_timer >= spawn_interval:
		spawn_timer = 0
		spawn_ring()
		
func get_visible_ring_count() -> int:
	var count := 0
	var viewport_rect := get_viewport().get_visible_rect()

	for ring in get_tree().get_nodes_in_group("rings"):
		if ring is Node2D and viewport_rect.has_point(ring.global_position):
			count += 1
	return count
	
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
			var force = clamp(nudge_force / distance, min_nudge_force, max_nudge_force)  # Inverse falloff
			ring.apply_impulse(dir.normalized() * force)
