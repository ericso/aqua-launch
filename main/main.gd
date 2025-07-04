extends Node2D

@onready var ripple_scene = preload("res://ripple/ripple.tscn")

@export var nudge_force = 50000
var min_nudge_force = 100
var max_nudge_force = nudge_force / 3.0


# TODO remove when done testing
var end_score = 10

# flag indicating whether or not the game is active
var game_active := false

func _ready():
	$UI/NewGameButton.pressed.connect(_on_new_game_pressed)
	
	var basket = preload("res://basket/basket.tscn").instantiate()
	basket.position = get_viewport_rect().size / 2 + Vector2(0, 350)
	basket.basket_scale = 0.3
	basket.get_node("BasketMouth").connect("ring_collected", Callable(self, "_on_ring_collected"))
	add_child(basket)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		apply_wave_impulse(event.position)

func apply_wave_impulse(tap_pos: Vector2) -> void:
	var ripple = ripple_scene.instantiate()
	ripple.global_position = tap_pos
	add_child(ripple)
	
	# impulse rings
	for ring in get_tree().get_nodes_in_group("rings"):
		if ring is RigidBody2D:
			var dir = ring.global_position - tap_pos
			var distance = dir.length()
			if distance == 0:
				continue
			var force = clamp(nudge_force / distance, min_nudge_force, max_nudge_force)  # Inverse falloff
			ring.apply_impulse(dir.normalized() * force)
			
	# impulse mines
	for mine in get_tree().get_nodes_in_group("mines"):
		if mine is RigidBody2D:
			var dir = mine.global_position - tap_pos
			var distance = dir.length()
			if distance == 0:
				continue
			var force = clamp(nudge_force / distance, min_nudge_force, max_nudge_force)  # Inverse falloff
			mine.apply_impulse(dir.normalized() * force)

# TODO add mine collection and collision signals and handlers
func _on_ring_collected() -> void:
	if game_active:
		ScoreManager.add_score(1)
	
	$UI/Score.text = "Score: %d" % ScoreManager.get_score()
	if ScoreManager.get_score() == end_score:
		end_game()

func _on_new_game_pressed():
	reset_game()
	game_active = true
	ScoreManager.reset_score()
	$RingSpawner.ring_spawn_timer = 0
	$MineSpawner.mine_spawn_timer = 0
	$UI/NewGameButton.visible = false

func end_game():
	game_active = false
	$UI/NewGameButton.visible = true

func is_game_active() -> bool:
	return game_active

func reset_game():
	# Remove all existing rings
	for ring in get_tree().get_nodes_in_group("rings"):
		ring.queue_free()

	# Reset timer, spawn system, player state, etc.
	ScoreManager.reset_score()
	$UI/Score.text = "Score: 0"
