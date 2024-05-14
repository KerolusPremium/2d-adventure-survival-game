extends Control

@onready var inv: Inv = preload("res://inventory/inventories/player.tres")
@onready var slots: Array = $NinePatchRect/GridContainer2.get_children()

var is_opened =false

func _ready():
	inv.update.connect(updateSlots)
	updateSlots()
	close()

func updateSlots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])

func _process(delta):
	if Input.is_action_just_pressed("inventory"):
		if is_opened:
			close()
		else:
			open()

func open():
	visible = true
	is_opened = true

func close():
	visible = false
	is_opened = false

func _on_close_button_button_down():
	close()
