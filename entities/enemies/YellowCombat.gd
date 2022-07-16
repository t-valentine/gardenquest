extends KinematicBody2D


var last_direction = Vector2(0, 1)

func _physics_process(delta):
	# Get player input
	var direction: Vector2
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# If input is digital, normalize it for diagonal movement
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
	
	# Animate player based on direction
	animates_player(direction)
	
func animates_player(direction: Vector2):
	var animation = "idle"
	$AnimatedSprite.play(animation)
