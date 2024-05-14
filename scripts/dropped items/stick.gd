extends StaticBody2D

@export var item: invItem
var player = null

func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		player = body
		collectItem()
		await get_tree().create_timer(0.1).timeout
		self.queue_free()

func collectItem():
	player.collect(item)
