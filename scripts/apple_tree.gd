extends Node2D

@onready var apple_growth = $appleGrowth
@onready var tree_growth = $treeGrowth
@onready var animated_sprite_2d = $AnimatedSprite2D

@export var state := 1
# state 0 = sapling
# state 1 = tree without apples
# state 2 = tree with apples

var isPlayerInArea = false

var apple = preload("res://scenes/droppedItems/apple.tscn")
var player = null

@export var item: invItem

func setState(newState: int):
	if newState >= 3 or newState < 0:
		return
	state = newState
	if state == 0:
		tree_growth.start()
	if state == 1:
		apple_growth.start()
	pass

func _ready():
	if state == 0:
		tree_growth.start()
	if state == 1:
		apple_growth.start()
	pass

func _process(delta):
	if state == 0:
		animated_sprite_2d.play("growth")
	if state == 1:
		animated_sprite_2d.play("noApples")
	if state == 2:
		animated_sprite_2d.play("apples")
		if isPlayerInArea:
			if Input.is_action_just_pressed("collect"):
				state = 1
				apple_growth.start()
				dropApple()
	


func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		isPlayerInArea = true
		player = body
		player.showText("Press E to Drop Apple")


func _on_area_2d_body_exited(body):
	if body.has_method("player"):
		isPlayerInArea = false
		body.hideText()


func _on_apple_growth_timeout():
	if state == 1:
		state = 2


func _on_tree_growth_timeout():
	if state == 0:
		state = 1
		apple_growth.start()

func dropApple():
	var appleInstance = apple.instantiate()
	appleInstance.global_position = $Marker2D.global_position
	get_parent().add_child(appleInstance)
	player.collect(item)
	await get_tree().create_timer(3).timeout
	apple_growth.start()
