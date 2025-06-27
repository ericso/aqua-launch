extends RigidBody2D

@export var floating_damp := 4 # damping to simulate water resistance

@export var ring_scale: float = 1.0

func _process(delta) -> void:
	if position.y > 1400:
		queue_free()

func _ready():
	# resize the rings
	$Sprite.scale = Vector2.ONE * ring_scale
	$CollisionShape.scale = Vector2.ONE * ring_scale
	
	# set the gravity
	gravity_scale = 0.6
	
	# set the gravity damping
	linear_damp = floating_damp
	angular_damp = floating_damp
