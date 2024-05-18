extends Node2D

@onready var place = $place

# Called when the node enters the scene tree for the first time.
func _ready():
	#var tree = $place/appleTree
	#tree.setState(2)
	#add_child(tree)
	
	for spawnable in get_tree().get_nodes_in_group("saved"):
		spawnable.remove_from_group("saved")
	
	Load()
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	save()

func save():
# apple tree -------------------------------------------------------------
	Save.appleTrees = []
	for appleTree in get_tree().get_nodes_in_group("appleTree"):
		Save.appleTrees.append({
			"name": appleTree.name,
			"pos": {
				"x": appleTree.transform[2][0],
				"y": appleTree.transform[2][1],
			},
			"state": appleTree.state
		})
		appleTree.add_to_group("saved")
	# sticks ------------------------------------------------------------------
	Save.sticks = []
	for sticks in get_tree().get_nodes_in_group("stick"):
		Save.sticks.append({
			"name": sticks.name,
			"pos": {
				"x": sticks.transform[2][0],
				"y": sticks.transform[2][1],
			},
		})
		sticks.add_to_group("saved")

		Save.saveGame()
func Load():
	for appleTree in Save.loadGame().spawnables.appleTrees:
		var appleTreeLoad = preload("res://scenes/spawnable ores items/apple_tree.tscn")
		var appleTreeIns = appleTreeLoad.instantiate()
		appleTreeIns.position.x = appleTree.pos.x
		appleTreeIns.position.y = appleTree.pos.y
		appleTreeIns.setState(appleTree.state)
		get_child(2).add_child(appleTreeIns)
