extends RigidBody2D

@export var ring_floating_damp := 4 # damping to simulate water resistance
@export var ring_scale: float = 1.0
@export var ring_gravity_scale: float = 0.6

var spawn_timer := 0.0

func _process(delta) -> void:
	if position.y > 1400:
		queue_free()

func _ready():
	# resize the rings
	$Sprite.scale = Vector2.ONE * ring_scale
	$CollisionShape.scale = Vector2.ONE * ring_scale
	
	# set the gravity
	gravity_scale = ring_gravity_scale
	
	# set the gravity damping
	linear_damp = ring_floating_damp
	angular_damp = ring_floating_damp
