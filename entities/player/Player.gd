extends KinematicBody2D

# Player movement speed
export var speed = 75
var fairymom
var current_health = 35
var max_health = 35
var damage = 30

# Player direction
var last_direction = Vector2(0, 1)

func _physics_process(delta):
	# Get player input
	var direction: Vector2
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# If input is digital, normalize it for diagonal movement
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
	
	# Apply movement
	var movement = speed * direction * delta
	move_and_collide(movement)
	
	# Animate player based on direction
	animates_player(direction)
	
	# Turn RayCast2D toward movement direction
	if direction != Vector2.ZERO:
		$RayCast2D.cast_to = direction.normalized() * 8
	
func animates_player(direction: Vector2):
	fairymom = get_tree().root.get_node("/root/Main/Fairymom")
	
	if direction != Vector2.ZERO:
		# update last_direction
		last_direction = direction
		var animation = get_animation_direction(last_direction) + "_walk"
		if fairymom.turniphat == true && fairymom.battery_found == false:
			$AnimatedSprite.play(animation)
		elif fairymom.battery_found == true:
			animation = "battery" + animation
			$AnimatedSprite.play(animation)
		else:
			animation = "naked" + animation
			$AnimatedSprite.play(animation)
		
	else:
		var animation = get_animation_direction(last_direction) + "_idle"
		if fairymom.turniphat == true && fairymom.battery_found == false:
			$AnimatedSprite.play(animation)
		elif fairymom.battery_found == true:
			animation = "battery" + animation
			$AnimatedSprite.play(animation)
		else:
			animation = "naked" + animation
			$AnimatedSprite.play(animation)

func get_animation_direction(direction: Vector2):
	var norm_direction = direction.normalized()
	if norm_direction.y >= 0.707:
		return "down"
	elif norm_direction.y <= -0.707:
		return "up"
	elif norm_direction.x <= -0.707:
		return "left"
	elif norm_direction.x >= 0.707:
		return "right"
	return "down"

func _input(event):
	if event.is_action_pressed("speak"):
		# What's the target?
		var target = $RayCast2D.get_collider()
		if target != null:
			if target.is_in_group("NPCs"):
				# Talk to NPC
				target.talk()
				return
func from_dictionary(data):
	position = Vector2(data.position[0], data.position[1])
		
func to_dictionary():
	return {
		"position" : [position.x, position.y]
	}

