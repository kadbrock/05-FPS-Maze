extends Control

func _ready():
	# Set mouse mode to visible
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_Play_pressed():
	var _scene = get_tree().change_scene("res://Game.tscn")


func _on_Quit_pressed():
	get_tree().quit()
