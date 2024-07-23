extends CharacterBody2D


const JUMP_VELOCITY = -300
const GRAVITY = 700
const JUMP_ANGLE = -PI/8
const FALL_ANGLE = PI/2
var bird_hit: bool
#var rotation_timer: float # delay timer for bird to stay in jumping position
var falling: bool
var flying: bool
var stop_at: float # y position of ground, for bird to stop falling at


func _physics_process(delta):
	
	if flying:
		velocity.y += GRAVITY * delta
		
		if Input.is_action_just_pressed("jump"):
			#rotation = -PI/8
			rotation = lerp(rotation, JUMP_ANGLE, 1)
			velocity.y = JUMP_VELOCITY
			#rotation_timer = 0.5
		
		else:
			rotation = lerp(rotation, FALL_ANGLE, 0.01)
			
		# If bird stay in jumping position
		# for less than 0.5 sec (set in above line),
		# don't make the bird go into PI/2 position yet
		#if rotation_timer > 0:
			#rotation_timer -= delta
		#else:
			#rotation = lerp(rotation, PI/2, 0.05)
			
		# When bird is falling down, stop bird flapping animation
		if rotation >= 1.5:
			$AnimatedSprite2D.stop()
		else:
			$AnimatedSprite2D.play()
	
	elif falling:
		$AnimatedSprite2D.stop()
		if position.y < stop_at:
			velocity.y += GRAVITY * 3 * delta
			rotation = lerp(rotation, FALL_ANGLE, 0.05)
		else:
			falling = false
	
	else:
		$AnimatedSprite2D.stop()
		velocity.y = 0
	
	move_and_collide(velocity * delta)
	


func _ready():
	pass


func stop():
	$AnimatedSprite2D.stop()
