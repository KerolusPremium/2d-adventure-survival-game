extends Panel

@onready var itemTexture: Sprite2D = $itemTexture
@onready var amountText: Label = $Label

func update(slot:invSlot):
	if !slot.item or slot.amount <= 0:
		itemTexture.visible = false
		amountText.visible = false
	else:
		itemTexture.visible = true
		itemTexture.texture = slot.item.texture
		if slot.amount == 1:
			amountText.visible = false
		else:
			amountText.visible = true
		amountText.text = str(slot.amount)
