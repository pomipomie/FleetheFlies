extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.playing = true
	#we play the animation and randomly choose one of the three animation types
	var fly_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = fly_types[randi() % fly_types.size()]

#make the flies delete themselves when they leave the screen
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
