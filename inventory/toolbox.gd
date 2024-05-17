extends Control

@onready var inv: Inv = preload("res://inventory/inventories/player.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var currentSlot := 0

var is_opened =false

func _ready():
	inv.update.connect(updateSlots)
	updateSlots()

func _process(delta):
	#inv.update.connect(updateSlots)
	updateSlots()
	if Input.is_action_just_pressed("scroll up"):
		currentSlot -= 1
		if currentSlot < 0:
			currentSlot = 8
	
	if Input.is_action_just_pressed("scroll down"):
		currentSlot += 1
		if currentSlot > 8:
			currentSlot = 0
	updateSlotTexture()
	
	if Input.is_action_just_pressed("place"):
		if inv.slots[currentSlot].item.placeable: #check if item can be placed
			var mousePos = get_global_mouse_position()
			var placeNodePath = inv.slots[currentSlot].item.placeNode.node
			print(placeNodePath)
			var placeNode = load("res://" + placeNodePath)
			var placeNodeIns = placeNode.instantiate()
			placeNodeIns.global_position = mousePos
			if inv.slots[currentSlot].item.placeGroup != "":
				placeNodeIns.add_to_group(inv.slots[currentSlot].item.placeGroup)
			get_parent().get_parent().get_parent().get_child(2).add_child(placeNodeIns)
			inv.slots[currentSlot].amount -= 1
func updateSlotTexture():
	var i = 0
	for slot in slots:
		if str(slot.name.to_int() - 1) == str(currentSlot):
			slot.get_child(0).texture = load("res://assets/ui/inventory-current-slot.png")
		else:
			slot.get_child(0).texture = load("res://assets/ui/inventory-slot.png")
	pass

func updateSlots():
	for i in range(min(inv.slots.size(), slots.size(), 9)):
		slots[i].update(inv.slots[i])
