extends RigidBody2D

@export var floating_damp := 6.5 # damping to simulate water resistance

func _process(delta) -> void:
	if position.y > 1400:
		queue_free()

func _ready():
	linear_damp = floating_damp
	angular_damp = floating_damp
