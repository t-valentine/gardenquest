extends Node

var quest_status
var QuestStatus
var fairymom
var dialoguePopup
var player
var dialogue_state = 0

func _ready():
	dialoguePopup = get_tree().root.get_node("/root/Main/CanvasLayer/DialougePopup")
	player = get_tree().root.get_node("/root/Main/Player")
	
func _physics_process(delta):
	fairymom = get_tree().root.get_node("/root/Main/Fairymom")
	if fairymom.turniphat == true:
		self.position.x = 304 
		self.position.y = -224 

func talk(answer = ""):
	fairymom = get_tree().root.get_node("/root/Main/Fairymom")
	quest_status = fairymom.QuestStatus
	$AnimatedSprite.play("idle")
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Worm"
	
	# Show the current dialogue
	if fairymom.battery_found == false:
		if fairymom.turniphat == false:
			match dialogue_state:
				0:
					dialogue_state = 1
					dialoguePopup.dialogue = "Sorry, Aphid, you need to get your hat from your mom\n before you can head out."
					dialoguePopup.answers = "[A] Okay..."
					dialoguePopup.open()
				1:
					dialogue_state = 0
					dialoguePopup.close()
					# $AnimatedSprite.play("idle")
		else:
			match dialogue_state:
				0:
					dialogue_state = 1
					dialoguePopup.dialogue = "Good luck out there!"
					dialoguePopup.answers = "[A] Thanks!"
					dialoguePopup.open()
				1:
					dialogue_state = 0
					dialoguePopup.close()
					# $AnimatedSprite.play("idle")
	else:
		match dialogue_state:
				0:
					dialogue_state = 1
					dialoguePopup.dialogue = "Wow, you found it!"
					dialoguePopup.answers = "[A] I did!"
					dialoguePopup.open()
				1:
					dialogue_state = 0
					dialoguePopup.close()
					# $AnimatedSprite.play("idle")


