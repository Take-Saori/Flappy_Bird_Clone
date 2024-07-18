extends Node

@export var pipe_scene: PackedScene
const SCROLL_SPEED = 5
const START_POS = Vector2(76,354)
var ground_scrolled_position: int # to set position.x for Ground
var screen_size
var ground_height: float
var game_running: bool = false
var pipe_array: Array
var score: int
var bird_width: float

func _ready():
	screen_size = get_viewport().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	bird_width = $Bird.get_node("AnimatedSprite2D").sprite_frames.get_frame_texture("default", 0).get_size().y
	$Bird.stop_at = screen_size.y - ground_height - bird_width
	init_new_game()
	

func init_new_game():
	$Bird.flying = false
	$Bird.falling = false
	$Bird.position = START_POS
	$Bird.rotation = 0
	$Ground.hit.connect(self.game_over)
	score = 0
	$HUD.update_score(score)
	ground_scrolled_position = 0
	$HUD.start_game.connect(self.init_new_game)
	$HUD.hide_restart_button()
	get_tree().call_group("pipes", "queue_free")
	pipe_array.clear()


func _input(event):
	if game_running == false:
		if event.is_action_pressed("jump"):
			start_game()


func start_game():
	init_new_game()
	$HUD.hide_start_message()
	game_running = true
	$Bird.flying = true
	$PipeTimer.start()


func _process(delta):
	if game_running:
		ground_scrolled_position += SCROLL_SPEED
		# When half of ground scrolls over the screen, push it back to the starting position
		# to make it seem like the ground is moving infintely
		if ground_scrolled_position >= screen_size.x:
			ground_scrolled_position = 0
		$Ground.position.x = -ground_scrolled_position
		
		for pipe in pipe_array:
			pipe.position.x -= SCROLL_SPEED
			if pipe.position.x < -screen_size.x * 0.5:
				pipe.queue_free()
				pipe_array.erase(pipe)
	
func _on_pipe_timer_timeout():
	var pipe = pipe_scene.instantiate()
	
	# Make the pipe appear outside of screen to make it seem like
	# it moved into the screen naturally
	pipe.position.x = screen_size.x * 1.1
	# Randomize the pipe position
	# The middle of the space between the top and bottom pipe
	# is the position mark (0,0) of the pipe
	pipe.position.y = randf_range((screen_size.y-ground_height) * 0.25,
									(screen_size.y-ground_height) * 0.75)

	# Set pipe's speed to the same as ground
	#pipe.scroll_speed = SCROLL_SPEED
	# When bird hits the pipe, game over
	pipe.hit.connect(self.game_over)
	pipe.scored.connect(self.add_score)
	# Add node as child node of main node
	pipe_array.append(pipe)
	add_child(pipe)
	
	
func add_score():
	score += 1
	$HUD.update_score(score) 

func game_over():
	game_running = false
	$Bird.flying = false
	$Bird.falling = true
	$PipeTimer.stop()
	$HUD.show_restart_button()
