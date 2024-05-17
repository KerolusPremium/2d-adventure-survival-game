extends Node

var playerPos:= {}
var appleTrees:= []
var sticks:= []

func _ready():
	print(loadGame())

func save():
	var saveDic = {
		"playerPos": playerPos,
		"spawnables": {
			"appleTrees": appleTrees,
			"sticks": sticks
		}
	}
	return saveDic

func saveGame():
	var saveGame = FileAccess.open_encrypted_with_pass("user://savegame.save", FileAccess.WRITE, "prm")
	var jsonString = JSON.stringify(save())
	
	saveGame.store_line(jsonString)

func loadGame():
	if !FileAccess.file_exists("user://savegame.save"):
		return
	
	var saveGame = FileAccess.open_encrypted_with_pass("user://savegame.save", FileAccess.READ, "prm")
	
	while saveGame.get_position() < saveGame.get_length():
		var jsonString = saveGame.get_line()
		var json = JSON.new()
		var jsonParse = JSON.parse_string(jsonString)
		var nodeData = json.get_data()
		
		return jsonParse
