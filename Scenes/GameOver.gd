extends Node2D

func _ready():
	pass


func _on_Continue_pressed():
	var next_level_resource = load("res://Scenes/Main.tscn");
	var next_level = next_level_resource.instance()
	next_level.load_saved_game = true
	State.current_health = 35
	get_tree().root.call_deferred("add_child", next_level)
	queue_free()


func _on_Quit_pressed():
	get_tree().quit()
