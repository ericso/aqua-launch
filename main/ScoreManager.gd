extends Node


### SCORE
var score: int = 0

func add_score(amount: int = 1) -> void:
	score += amount

func reset_score() -> void:
	score = 0

func get_score() -> int:
	return score


### MINES HIT
var mines_hit: int = 0

func record_mine_hit(amount: int = 1) -> void:
	mines_hit += amount

func reset_mines_hit() -> void:
	mines_hit = 0

func get_mines_hit() -> int:
	return mines_hit
