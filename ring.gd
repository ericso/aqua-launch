extends RigidBody2D

@export var floating_damp := 4 # damping to simulate water resistance

func _process(delta) -> void:
	if position.y > 1400:
		queue_free()

func _ready():
	gravity_scale = 0.6
	linear_damp = floating_damp
	angular_damp = floating_damp
