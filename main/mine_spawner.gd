extends Node2D

@onready var mine_scene = preload("res://mine/mine.tscn")

var mine_spawn_timer := 0.0

# TODO currently the spawn rate of mine matches that of rings
# Consider if this should be re-visited.
# spawn rate of mines is dependent on the number of mines on screen
# more rings on screen increases the spawn interval
@export var mine_spawn_interval := 0.05 # default spawn rate in seconds
@export var base_interval := 0.05
@export var interval_per_ring := 0.1
@export var max_interval := 0.5

func _process(delta: float) -> void:
	# mine spawning should happen only when told to by the game manager
	if not is_inside_tree() or not is_spawning():
		return
	
	mine_spawn_timer += delta
	
	var visible_mine_count = get_visible_mine_count()
	mine_spawn_interval = clamp(base_interval + (visible_mine_count * interval_per_ring), base_interval, max_interval)

	if mine_spawn_timer >= mine_spawn_interval:
		mine_spawn_timer = 0
		spawn_mine()

func get_visible_mine_count() -> int:
	var count := 0
	var viewport_rect := get_viewport().get_visible_rect()

	for mine in get_tree().get_nodes_in_group("mines"):
		if mine is Node2D and viewport_rect.has_point(mine.global_position):
			count += 1
	return count
	
func spawn_mine():
	var mine = mine_scene.instantiate()
	var x_pos = randf_range(50, 670) # Avoid edges of 720px wide screen
	mine.position = Vector2(x_pos, -100)
	mine.mine_scale = 0.08
	
	add_child(mine)

func is_spawning() -> bool:
	return get_parent().has_method("is_game_active") and get_parent().is_game_active()
