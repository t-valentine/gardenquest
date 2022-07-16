extends KinematicBody2D

# Node references
onready var player = get_node("/root/Main/Player")

# Random number generator
var rng = RandomNumberGenerator.new()

# Movement variables
export var speed = 50
var direction : Vector2
var last_direction = Vector2(0, 1)
var bounce_countdown = 0

# Animation variables
var other_animation_playing = false

func _ready():
	rng.randomize()
	connect("body_entered", self, "_on_Area2D_body_entered")


func _on_Timer_timeout():
	# Calculate the position of the player relative to the enemy
	var player_relative_position = player.position - position
	
	if player_relative_position.length() <= 20:
		# If player is near, don't move but turn toward it
		direction = Vector2.ZERO
		last_direction = player_relative_position.normalized()
	elif player_relative_position.length() <= 100 and bounce_countdown == 0:
		# If player is within range, move toward it
		direction = player_relative_position.normalized()
	elif bounce_countdown == 0:
		# If player is too far, randomly decide whether to stand still or where to move
		var random_number = rng.randf()
		if random_number < 0.05:
			direction = Vector2.ZERO
		elif random_number < 0.1:
			direction = Vector2.DOWN.rotated(rng.randf() * 2 * PI)
	
	# Update bounce countdown
	if bounce_countdown > 0:
		bounce_countdown = bounce_countdown - 1
		
func _physics_process(delta):
	var movement = direction * speed * delta
	
	var collision = move_and_collide(movement)
	
	if collision != null and collision.collider.name != "Player":
		direction = direction.rotated(rng.randf_range(PI/4, PI/2))
		bounce_countdown = rng.randi_range(2, 5)
		
	# Animate bug based on direction
	if not other_animation_playing:
		animates_monster(direction)
		
func get_animation_direction(direction: Vector2):
	var norm_direction = direction.normalized()
	if norm_direction.y >= 0.707:
		return "down"
	elif norm_direction.y <= -0.707:
		return "up"
	return "down"

func animates_monster(direction: Vector2):
	if direction != Vector2.ZERO:
		last_direction = direction
		
		# Choose walk animation based on movement direction
		var animation = get_animation_direction(last_direction) + "_walk"
		
		# Play the walk animation
		$AnimatedSprite.play(animation)
	else:
		# Choose idle animation based on last movement direction and play it
		var animation = get_animation_direction(last_direction) + "_idle"
		$AnimatedSprite.play(animation)
	
func from_dictionary(data):
	position = Vector2(data.position[0], data.position[1])
	
func to_dictionary():
	return {
		"position" : [position.x, position.y],
	}

func deletes_on_loss(health):
	if health == 0:
		queue_free()

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		get_node("/root/Main").save()
		get_tree().change_scene("res://Scenes/Combat.tscn")
		self.queue_free()
