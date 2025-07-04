extends RigidBody2D

@export var mine_floating_damp := 4 # damping to simulate water resistance
@export var mine_scale: float = 1.0
@export var mine_gravity_scale: float = 0.9

var spawn_timer := 0.0

func _process(delta) -> void:
	if position.y > 1400:
		queue_free()

func _ready():
	# resize the rings
	$Sprite.scale = Vector2.ONE * mine_scale
	$CollisionShape.scale = Vector2.ONE * mine_scale
	
	# set the gravity
	gravity_scale = mine_gravity_scale
	
	# set the gravity damping
	linear_damp = mine_floating_damp
	angular_damp = mine_floating_damp
