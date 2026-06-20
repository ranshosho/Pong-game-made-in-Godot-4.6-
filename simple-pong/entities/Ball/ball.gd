extends CharacterBody2D

@export var initial_ball_speed = 300
@export var speed_accumulator = 50
var ball_speed = initial_ball_speed

var hitcounter = 0
var max_hitcounter = 12
var direction = Vector2()

func _ready():
	randomize()
	set_start_direction()

func set_start_direction():
	var random_x = 0
	
	if randi()%10 < 5:
		random_x = 1
	else:
		random_x = -1
		
	direction = Vector2(random_x, randf_range(-1,1))
	direction = direction.normalized() * ball_speed
	
func _physics_process(delta):
	var collision = move_and_collide(direction * delta)
	if collision:
		direction = direction.bounce(collision.get_normal())
		if collision.get_collider().is_in_group("rackets"):
			var y = direction.y / 2 + collision.get_collider().velocity.y
			
			direction = Vector2(direction.x, y).normalized() * (ball_speed + hitcounter * speed_accumulator)
			
			if hitcounter < max_hitcounter:
				hitcounter += 1
				
			$RacketSound.play()
		else:
			$WallSound.play()
			
func reset():
	position = Vector2(512, 256)
	direction = Vector2()
	direction = Vector2.ZERO
	hitcounter = 0
