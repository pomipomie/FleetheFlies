extends Area2D

signal hit

# Using the export keyword on the first variable speed allows us to set its value in the Inspector.
export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

func _ready():
	screen_size = get_viewport_rect().size #find the size of the game window

func _process(delta):
	#Set movement direction
	var velocity = Vector2.ZERO # The player's movement vector, (0, 0) by default
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed #prevents fast diagonal movement
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	#Update the player's position
	position += velocity * delta
	#clamp prevents the player from leaving the screen
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	#change which animation the AnimatedSprite is playing based on its direction
	if velocity.x != 0:
		if velocity.x < 0:
			$AnimatedSprite.animation = "left"
		else:
			$AnimatedSprite.animation = "right"
	elif velocity.y != 0:
		if velocity.y < 0:
			$AnimatedSprite.animation = "up"
		else:
			$AnimatedSprite.animation = "down"

func _on_Player_body_entered(body):
	hide() # Player disappears after being hit.
	emit_signal("hit")
	# Must be deferred as we can't change physics properties on a physics callback.
	# We need to disable the player's collision so that we don't trigger the hit signal more than once.
	#Using set_deferred() tells Godot to wait to disable the shape until it's safe to do so.
	$CollisionShape2D.set_deferred("disabled", true)

#reset the player when starting a new game.
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
