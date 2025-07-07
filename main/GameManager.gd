extends Node

# flag indicating whether or not the game is active
var game_active := false

func is_game_active() -> bool:
	return game_active

func set_game_active(is_active: bool) -> void:
	game_active = is_active
