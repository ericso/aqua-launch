extends Node2D

@onready var ring_scene = preload("res://ring/ring.tscn")

var ring_spawn_timer := 0.0

# spawn rate of rings is dependent on the number of rings on screen
# more rings on screen increases the spawn interval
@export var ring_spawn_interval := 0.05 # default spawn rate in seconds
@export var base_interval := 0.05
@export var interval_per_ring := 0.1
@export var max_interval := 0.5

func _process(delta: float) -> void:
	# Ring spawning should happen only when told to by the game manager
	if not is_inside_tree() or not is_spawning():
		return

	ring_spawn_timer += delta
	
	var visible_ring_count = get_visible_ring_count()
	ring_spawn_interval = clamp(base_interval + (visible_ring_count * interval_per_ring), base_interval, max_interval)

	if ring_spawn_timer >= ring_spawn_interval:
		ring_spawn_timer = 0
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
	ring.ring_scale = 0.08
	add_child(ring)

# This is now *delegated* to the GameManager or Main.gd
func is_spawning() -> bool:
	return get_parent().has_method("is_game_active") and get_parent().is_game_active()
