extends Area2D

@export var basket_scale: float = 1.0

func _ready():
	# resize the basket
	$Sprite.scale = Vector2.ONE * basket_scale
	$BasketMouth.scale = Vector2.ONE * basket_scale
	$BasketBody.scale = Vector2.ONE * basket_scale
