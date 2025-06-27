extends Node

var score: int = 0

func add_score(amount: int = 1) -> void:
	score += amount

func reset_score() -> void:
	score = 0

func get_score() -> int:
	return score
