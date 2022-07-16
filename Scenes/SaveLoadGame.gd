extends Node

var load_saved_game = false

func save():
	var data = {
		"player" : $Player.to_dictionary(),
		"fairymom" : $Fairymom.to_dictionary(),
		"battery" : is_instance_valid(get_node("/root/Main/Battery")),
	}
	
	var file = File.new()
	file.open("user://savegame.json", File.WRITE)
	var json = to_json(data)
	file.store_line(json)
	file.close()

func _ready():
	var file = File.new()
	if load_saved_game and file.file_exists("user://savegame.json"):
		file.open("user://savegame.json", File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		
		$Player.from_dictionary(data.player)
		$Fairymom.from_dictionary(data.fairymom)
		if($Fairymom.battery_found):
			$Battery.queue_free()
