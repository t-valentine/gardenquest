extends Node

export(Resource) var Enemy = null
onready var random = RandomNumberGenerator.new()

signal textbox_closed

var enemyhealth
var enemymax_health
var current_player_health = 0
var current_player_magic = 0
var current_enemy_health = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	random.randomize()
	
	enemyhealth = 40
	enemymax_health = 40
	
	current_player_health = State.current_health
	current_player_magic = State.current_magic
	set_health($EnemyPanel/HP, enemyhealth, enemymax_health)
	set_health($PlayerPanel/HP, State.current_health, State.max_health)
	set_magic($PlayerPanel/MP, State.current_magic, State.max_magic)
	
	$TextBox.hide()
	$ActionPanel.hide()
	
	display_text("A bothersome pest blocks your path!")
	yield(self, "textbox_closed")
	$ActionPanel.show()
	
func load_main():
	yield(get_tree().create_timer(0.25), "timeout")
	if current_player_health > 0:
		var next_level_resource = load("res://Scenes/Main.tscn");
		var next_level = next_level_resource.instance()
		next_level.load_saved_game = true
		get_tree().root.call_deferred("add_child", next_level)
		queue_free()
	else:
		get_tree().change_scene("res://Scenes/GameOver.tscn")
		queue_free()
	
	#yield(get_tree().create_timer(0.1), "timeout")
	#get_node("/root/Combat").free()
			# get_node("/root/Main").save()
		# get_tree().change_scene("res://Scenes/Combat.tscn")
	
func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "HP: %d/%d" % [health, max_health]
	
func set_magic(progress_bar, magic, max_magic):
	progress_bar.value = magic
	progress_bar.max_value = max_magic
	progress_bar.get_node("Label").text = "MP: %d/%d" % [magic, max_magic]
	
func _input(event):
	if Input.is_action_just_pressed("speak") or Input.is_mouse_button_pressed(BUTTON_LEFT) and $TextBox.visible:
		$TextBox.hide()
		emit_signal("textbox_closed")

func display_text(text):
	$ActionPanel.hide()
	$TextBox.show()
	$TextBox/Label.text = text
	
func enemy_turn():
	
	var damage = random.randi_range(5, 15)
	
	display_text("Ouch! The bug punched you for " + str(damage) + " damage.")
	current_player_health = max(0, current_player_health - damage)
	set_health($PlayerPanel/HP, current_player_health, State.max_health)
	yield(self, "textbox_closed")
	if current_player_health <= 0:
		display_text("idiot")
		yield(get_tree().create_timer(0.25), "timeout")
		load_main()
	
	if current_player_magic < 10:
		var magicback = random.randi_range(0, 5)
		current_player_magic = max(0, current_player_magic + magicback)
		set_magic($PlayerPanel/MP, current_player_magic, State.max_magic)
		display_text("You gain " + str(magicback) +" Magic Points back!")
		yield(self, "textbox_closed")

	$ActionPanel.show()

func _on_Scratch_pressed():
	display_text("You reach out with your claws to scratch \nat the bug!")
	yield(self, "textbox_closed")

	var damage = random.randi_range(5, 15)
	enemyhealth -= damage
	set_health($EnemyPanel/HP, enemyhealth, enemymax_health)
	display_text("You injure the pest for " + str(damage) + " damage!")
	yield(self, "textbox_closed")
	
	if enemyhealth <= 0:
		display_text("The bug was defeated!")
		yield(self, "textbox_closed")
		yield(get_tree().create_timer(0.25), "timeout")
		load_main()
		
	enemy_turn()

func _on_Cast_Spell_pressed():
	display_text("You let the power from your turnip hat well\n up inside you...")
	yield(self, "textbox_closed")
	
	if current_player_magic < 10:
		display_text("You don't have enough MP to cast a spell!")
		yield(self, "textbox_closed")
		enemy_turn()
	else:

		var damage = random.randi_range(1, 30)
		enemyhealth -= damage
		set_health($EnemyPanel/HP, enemyhealth, enemymax_health)
		current_player_magic = max(0, current_player_magic - 6)
		set_magic($PlayerPanel/MP, State.current_magic, State.max_magic)
		
		if enemyhealth <= 0:
			display_text("The bug was defeated!")
			yield(self, "textbox_closed")
			yield(get_tree().create_timer(0.25), "timeout")
			load_main()
			
		
		if damage == 1:
			display_text("You only hit the bug for 1 HP! \n Whoops...")
			yield(self, "textbox_closed")
		elif damage >= 2 and damage <= 29:
			display_text("The bug takes " + str(damage) + " damage!")
			yield(self, "textbox_closed")
		else:
			display_text("Wow! You hit the bug for 30 damage!!")
			yield(self, "textbox_closed")
			
		enemy_turn()
	
func _on_Run_pressed():
	var successfulrun = randi() % 3
	if successfulrun == 0:
		display_text("Got away safely!")
		yield(self, "textbox_closed")
		yield(get_tree().create_timer(0.1), "timeout")
		load_main()
	else:
		display_text("You weren't able to get away!")
		yield(self, "textbox_closed")
		enemy_turn()
