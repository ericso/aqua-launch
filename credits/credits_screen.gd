extends Control

func _ready():
	$MarginContainer/VBoxContainer/BackButton.pressed.connect(_on_back_button_pressed)
	
func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://main/main.tscn")
