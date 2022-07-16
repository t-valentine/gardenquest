extends Area2D


var fairymom


# Called when the node enters the scene tree for the first time.
func _ready():
	fairymom = get_tree().root.get_node("/root/Main/Fairymom")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Battery_body_entered(body):
	if body.name == "Player":
		get_tree().queue_delete(self)
		fairymom.battery_found = true
