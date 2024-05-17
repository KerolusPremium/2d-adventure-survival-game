extends CharacterBody2D

@export var speed = 100
@export var damage = 2

@export var inv: Inv

var playerState

var lastDirX: float
var lastDirY: float

var mouseLocationFromPlayer = null
var isAttack := false

@onready var animated_sprite_2d = $AnimatedSprite2D

func  _ready():
	hideText()
	self.position.x = loadPos().x
	self.position.y = loadPos().y

func _physics_process(delta):
	if !isAttack:
		mouseLocationFromPlayer = get_global_mouse_position() - self.position
	
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction.x == 0 and direction.y == 0:
		playerState = "idle"
	elif direction.x != 0 or direction.y != 0:
		playerState = "walking"
	velocity = direction * speed
	#move_and_collide(velocity)
	move_and_slide()
	if Input.is_action_pressed("up") or Input.is_action_pressed("down") or Input.is_action_pressed("left") or Input.is_action_pressed("right"):   
		save(self.position.x, self.position.y)
	
	var mousePos = get_global_mouse_position()
	$Marker2D.look_at(mousePos)
	
	if Input.is_action_just_pressed("attack"):
		isAttack = true
		playAnimation(direction)
		await get_tree().create_timer(0.5).timeout
		isAttack = false
	else:
		playAnimation(direction)
	showText(str(self.position))

func playAnimation(dir):
	if isAttack == true: #attack animation
		if mouseLocationFromPlayer.x >= -25 and mouseLocationFromPlayer.x <= 25 and mouseLocationFromPlayer.y < 0:
			$AnimatedSprite2D.play("n_attack")
			lastDirX = 0.0
			lastDirY = -1.0
		if mouseLocationFromPlayer.y >= -25 and mouseLocationFromPlayer.y <= 25 and mouseLocationFromPlayer.x > 0:
			$AnimatedSprite2D.play("e_attack")
			lastDirX = 1.0
			lastDirY = 0
		if mouseLocationFromPlayer.x >= -25 and mouseLocationFromPlayer.x <= 25 and mouseLocationFromPlayer.y > 0:
			$AnimatedSprite2D.play("s_attack")
			lastDirY = 1.0
			lastDirX = 0.0
		if mouseLocationFromPlayer.y >= -25 and mouseLocationFromPlayer.y <= 25 and mouseLocationFromPlayer.x < 0:
			$AnimatedSprite2D.play("w_attack")
			lastDirX = -1.0
			lastDirY = 0.0
	else:
		if playerState == "idle": #idle animation
			if lastDirY == -1.0:
				$AnimatedSprite2D.play("n_idle")
			if lastDirX == 1.0:
				$AnimatedSprite2D.play("e_idle")
			if lastDirY == 1.0:
				$AnimatedSprite2D.play("s_idle")
			if lastDirX == -1.0:
				$AnimatedSprite2D.play("w_idle")
			
			if lastDirX > 0.5 and lastDirY < -0.5:
				$AnimatedSprite2D.play("ne_idle")
			if lastDirX > 0.5 and lastDirY > 0.5:
				$AnimatedSprite2D.play("se_idle")
			if lastDirX < -0.5 and lastDirY > 0.5:
				$AnimatedSprite2D.play("sw_idle")
			if lastDirX < -0.5 and lastDirY < -0.5:
				$AnimatedSprite2D.play("nw_idle")
		if playerState == "walking": #walking animation
			if dir.y == -1:
				$AnimatedSprite2D.play("n_walk")
				lastDirX = 0.0
				lastDirY = -1.0
			if dir.x == 1:
				$AnimatedSprite2D.play("e_walk")
				lastDirX = 1.0
				lastDirY = 0
			if dir.y == 1:
				$AnimatedSprite2D.play("s_walk")
				lastDirY = 1.0
				lastDirX = 0.0
			if dir.x == -1:
				$AnimatedSprite2D.play("w_walk")
				lastDirX = -1.0
				lastDirY = 0.0
			
			if dir.x > 0.5 and dir.y < -0.5:
				$AnimatedSprite2D.play("ne_walk")
				lastDirX = 0.7
				lastDirY = -0.7
			if dir.x > 0.5 and dir.y > 0.5:
				$AnimatedSprite2D.play("se_walk")
				lastDirX = 0.7
				lastDirY = 0.7
			if dir.x < -0.5 and dir.y > 0.5:
				$AnimatedSprite2D.play("sw_walk")
				lastDirX = -0.7
				lastDirY = 0.7
			if dir.x < -0.5 and dir.y < -0.5:
				$AnimatedSprite2D.play("nw_walk")
				lastDirX = -0.7
				lastDirY = -0.7
			
			
	

func player():
	pass

func collect(item):
	inv.insert(item)

func showText(text: String):
	var Text = $camera/Label
	Text.text = text
	Text.visible = true

func hideText():
	var Text = $camera/Label
	Text.text = ""
	Text.visible = false

func save(x, y):
	Save.playerPos = {
		"x": x,
		"y": y,
	}
	Save.saveGame()

func loadPos():
	var data = Save.loadGame()
	return data.playerPos
