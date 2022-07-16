extends Node

enum QuestStatus { NOT_STARTED, STARTED, COMPLETED }
var quest_status = QuestStatus.NOT_STARTED
var dialogue_state = 0
var battery_found = false
var turniphat = false
var dialoguePopup
var player
var current_player_health = State.current_health
var current_player_magic = State.current_magic

func _ready():
	dialoguePopup = get_tree().root.get_node("/root/Main/CanvasLayer/DialougePopup")
	player = get_tree().root.get_node("/root/Main/Player")

func talk(answer = ""):
	# Currently, there are no talk sprites
	$AnimatedSprite.play("idle")
	# Set dialoguePopup npc to FairyMom
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "FairyMom"
	
	# Show the current dialogue
	match quest_status:
	
		QuestStatus.NOT_STARTED:
			match dialogue_state:
				0:
					dialogue_state = 1
					dialoguePopup.dialogue = "Where have you been? Our Light is out, I need you to go to the \nSummit and retrieve an artifact for me to fix the Light."
					dialoguePopup.answers = "[A] Where?  [S] What? [D] Okay."
					dialoguePopup.open()
				1:
					match answer:
						"A":
							dialogue_state = 1
							dialoguePopup.dialogue = "The Summit, just follow the Northern path and you’ll find it."
							dialoguePopup.answers = "[A] Where?  [S] What? [D] Okay."
							dialoguePopup.open()
						"S":
							dialogue_state = 1
							dialoguePopup.dialogue = "It’s a large artifact, you’ll know it when you see it."
							dialoguePopup.answers = "[A] Where?  [S] What? [D] Okay."
							dialoguePopup.open()
						"D":
							dialogue_state = 2
							dialoguePopup.dialogue = "Thank you, Aphid, I really appreciate this. Here's your hat, remember \nyou need it to cast spells."
							dialoguePopup.answers = "[A] Thanks!"
							turniphat = true
							dialoguePopup.open()
				2:
					dialogue_state = 0
					quest_status = QuestStatus.STARTED
					dialoguePopup.close()
					# $AnimatedSprite.play("idle")
				3:
					dialogue_state = 0
					dialoguePopup.close()
					# $AnimatedSprite.play("idle")
		QuestStatus.STARTED:
			match dialogue_state:
				0:
					dialogue_state = 1
					dialoguePopup.dialogue = "Did you follow the path? It goes right to the Summit."
					if battery_found:
						dialoguePopup.answers = "[A] Yes  [S] No"
					else:
						dialoguePopup.answers = "[A] No  [S] I need help..."
					dialoguePopup.open()
				1:
					if battery_found and answer == "A":
						dialogue_state = 2
						dialoguePopup.dialogue = "You found it! Thank you, finally we’ll be able to light the nighttime again."
						dialoguePopup.answers = "[A] You're welcome!"
						dialoguePopup.open()
					if answer == "S" and !battery_found:
						dialogue_state = 3
						dialoguePopup.dialogue = "Oh, those bugs hurt you? Let me help."
						dialoguePopup.answers = "[A] ..."
						current_player_health = 35
						current_player_magic = 10
						dialoguePopup.open()
					else:
						dialogue_state = 3
						dialoguePopup.dialogue = "Well, go on then."
						dialoguePopup.answers = "[A] ..."
						dialoguePopup.open()
				2:
					dialogue_state = 0
					quest_status = QuestStatus.COMPLETED
					dialoguePopup.close()
					# $AnimatedSprite.play("idle")
				3:
					dialogue_state = 0
					dialoguePopup.close()
					# $AnimatedSprite.play("idle")
		QuestStatus.COMPLETED:
			match dialogue_state:
				0:
					dialogue_state = 1
					dialoguePopup.dialogue = "Thanks again for your help!"
					dialoguePopup.answers = "[A] Bye"
					dialoguePopup.open()
				1:
					dialogue_state = 0
					dialoguePopup.close()
					# $AnimatedSprite.play("idle")
func from_dictionary(data):
	battery_found = data.battery_found
	turniphat = data.turniphat
	quest_status = int(data.quest_status)

func to_dictionary():
	return {
		"quest_status" : quest_status,
		"battery_found" : battery_found,
		"turniphat" : turniphat
	}

