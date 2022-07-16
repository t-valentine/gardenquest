extends Popup

# Defers initialization of var until _ready is called
onready var player = get_node("/root/Main/Player")
var already_paused
var selected_menu



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func change_menu_color():
	$Resume.color = Color('#afcc5d')
	$Save.color = Color('#afcc5d')
	$Quit.color = Color('#afcc5d')
	
	match selected_menu:
		0:
			$Resume.color = Color('#c2e293')   
		1:
			$Save.color = Color('#c2e293')
		2:
			$Quit.color = Color('#c2e293')

func _input(event):
	if not visible:
		if Input.is_action_just_pressed("menu"):
			# Pause game
			get_tree().paused = true
			# Reset the popup
			selected_menu = 0
			change_menu_color()
			# Show popup
			player.set_process_input(false)
			popup()
	else:
		if Input.is_action_just_pressed("ui_down"):
			selected_menu = (selected_menu + 1) % 3;
			change_menu_color()
		elif Input.is_action_just_pressed("ui_up"):
			if selected_menu > 0:
				selected_menu = selected_menu - 1
			else:
				selected_menu = 2
			change_menu_color()
		elif Input.is_action_just_pressed("speak"):
			match selected_menu:
				0:
					# Resume game
					if not already_paused:
						get_tree().paused = false
					player.set_process_input(true)
					hide()
				1:
					# Save Game
					get_node("/root/Main").save()
					get_tree().paused = false
					player.set_process_input(true)
					hide()
				2:
					# Quit game
					get_tree().quit()
