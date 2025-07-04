extends Area2D

@export var basket_scale: float = 1.0
@export var max_health := 100
var health := max_health

func _ready():
	# resize the basket
	$Sprite.scale = Vector2.ONE * basket_scale
	$BasketMouth.scale = Vector2.ONE * basket_scale
	$BasketBody.scale = Vector2.ONE * basket_scale
	
	update_health_bar()

func update_health_bar():
	$HealthBar.value = health

func apply_damage(amount: int):
	health -= amount
	health = clamp(health, 0, max_health)
	update_health_bar()

	if health <= 0:
		die()

# TODO this doesn't work yet
func die():
	# Trigger game over
	get_tree().call_group("ui", "show_game_over")  # or emit signal
