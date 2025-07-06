extends Node2D

@onready var ripple_scene = preload("res://ripple/ripple.tscn")

@export var nudge_force = 50000
var min_nudge_force = 100
var max_nudge_force = nudge_force / 3.0

# flag indicating whether or not the game is active
var game_active := false

var basket: Node = null

# the amount of damage a mine does to the basket
var mine_damage: float = 5.0

# rings_deducted is the amount of rings deducted from the score when a mine hits
# the basket
var rings_deducted: int = 0

func _ready():
	$UI/NewGameButton.pressed.connect(_on_new_game_pressed)
	
	basket = preload("res://basket/basket.tscn").instantiate()
	basket.position = get_viewport_rect().size / 2 + Vector2(0, 350)
	basket.basket_scale = 0.3
	basket.get_node("BasketMouth").connect("ring_collected", Callable(self, "_on_ring_collected"))
	add_child(basket)
	
	# connect the mine_hit signal
	basket.get_node("BasketBody/MineSensor").connect("mine_hit", Callable(self, "_on_mine_hit"))
	
	# connect the game_over signal
	basket.connect("game_over", Callable(self, "_on_game_over"))

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

# _on_ring_collected is the handler for when the basket collects a ring
func _on_ring_collected(ring: Node2D) -> void:
	# twinkle should animate regardless of game in progress
	var twinkle = preload("res://ring/twinkle/twinkle.tscn").instantiate()
	get_tree().current_scene.add_child(twinkle)
	twinkle.global_position = ring.global_position
	
	if game_active:
		ScoreManager.add_score(1)
	
	$UI/Score.text = "Score: %d" % ScoreManager.get_score()

# _on_mine_hit is the handler for when a mine collides with the basket
# A mine hit should do two things: decrease the score and do damage to the basket
func _on_mine_hit(mine: Node2D) -> void:
	# explosion should always happen on hit, whether or not game is running
	var explosion = preload("res://mine/explosion/explosion.tscn").instantiate()
	get_tree().current_scene.add_child(explosion)
	# offset the explosion to be above the mine
	explosion.global_position = mine.global_position + Vector2(0, -100)
	
	# play the sound effect
	$ExplosionFx.play()
	
	if game_active:
		# score go down
		ScoreManager.decrement_score(rings_deducted)
		
		# damage basket
		if basket:
			basket.apply_damage(mine_damage)
	
	$UI/Score.text = "Score: %d" % ScoreManager.get_score()

func _on_new_game_pressed():
	reset_game()
	game_active = true
	ScoreManager.reset_score()
	$RingSpawner.ring_spawn_timer = 0
	$MineSpawner.mine_spawn_timer = 0
	$UI/NewGameButton.visible = false
	$BackgroundMusic.volume_db = +10  # raise background music volume by 10dB

func _on_game_over():
	end_game()
	$BackgroundMusic.volume_db = -10  # raise background music volume by 10dB
	
func end_game():
	game_active = false
	$UI/NewGameButton.visible = true

func is_game_active() -> bool:
	return game_active

func reset_game():
	# remove all existing rings
	for ring in get_tree().get_nodes_in_group("rings"):
		ring.queue_free()
	
	# remove all existing mines
	for ring in get_tree().get_nodes_in_group("mines"):
		ring.queue_free()
	
	# reset score
	ScoreManager.reset_score()
	$UI/Score.text = "Score: 0"
	
	# reset basket health
	basket.reset_health()
