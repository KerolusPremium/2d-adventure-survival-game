extends StaticBody2D

@onready var animation_player = $AnimationPlayer

func _ready():
	fall()

func fall():
	animation_player.play("falling from tree")
	await get_tree().create_timer(1.5).timeout
	animation_player.play("fade")
	print("+1 apple")
	await get_tree().create_timer(0.3).timeout
	queue_free()
