extends Node

# declare inputtext nodes godot 4.0
@onready var UsernameInputText = get_node("../username")
@onready var PasswordInputText = get_node("../password")

func _ready():
	UsernameInputText.grab_focus()

func _on_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	pass # Replace with function body.

func _on_gui_input(event):
	if event.is_action_pressed("tab_press"):
		PasswordInputText.grab_focus()
	if event.is_action_pressed("enter_press"):
		get_tree().change_scene_to_file("res://scenes/main.tscn")
	pass
