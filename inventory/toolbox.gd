extends Control

@onready var inv: Inv = preload("res://inventory/inventories/player.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var is_opened =false

func _ready():
	inv.update.connect(updateSlots)
	updateSlots()

func _process(delta):
	#inv.update.connect(updateSlots)
	updateSlots()

func updateSlots():
	for i in range(min(inv.slots.size(), slots.size(), 9)):
		slots[i].update(inv.slots[i])
