extends Node

export(PackedScene) var fly_scene
var score

func _ready():
	randomize()

func game_over():
	$ScoreTimer.stop()
	$FlyTimer.stop()
	$HUD.show_game_over()

func game_won():
	$ScoreTimer.stop()
	$FlyTimer.stop()
	$HUD.show_20_secs()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	get_tree().call_group("mobs", "queue_free")
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Dodge the flies for 20 seconds")

func _on_FlyTimer_timeout():
	# Create a new instance of the fly scene.
	var fly = fly_scene.instance()

	# Choose a random location on Path2D.
	var fly_spawn_location = get_node("FlyPath/SpawnLocation")
	fly_spawn_location.offset = randi()

	# Set the fly's direction perpendicular to the path direction.
	var direction = fly_spawn_location.rotation + PI / 2

	# Set the fly's position to a random location.
	fly.position = fly_spawn_location.position

	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	fly.rotation = direction

	# Choose the velocity for the fly.
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	fly.linear_velocity = velocity.rotated(direction)

	# Spawn the fly by adding it to the Main scene.
	add_child(fly)

func _on_ScoreTimer_timeout():
	score += 1
	if score == 20:
		game_won()
	$HUD.update_score(score)

func _on_StartTimer_timeout():
	$ScoreTimer.start()
	$FlyTimer.start()
