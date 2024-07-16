class_name  MainMenu
extends Control


@onready var btn_start = $MarginContainer/HBoxContainer/VBoxContainer/btn_start as Button
@onready var btn_exit = $MarginContainer/HBoxContainer/VBoxContainer/btn_exit as Button
@onready var start_game = preload("res://scenes/node_3d.tscn") as PackedScene

func _ready():
	btn_start.button_down.connect(on_start_pressed)
	btn_exit.button_down.connect(on_exit_pressed)
	

func on_start_pressed() -> void:
	
	get_tree().change_scene_to_packed(start_game)
	
func on_exit_pressed() -> void:
	get_tree().quit()
