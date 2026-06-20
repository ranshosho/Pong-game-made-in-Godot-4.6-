extends CharacterBody2D

signal update

#Declare member variables here. Examples:
@export var move_speed = 250
var direction = Vector2()

#called when the Node enters the scenetree for the first time.
func _ready():
	pass #replace with function body
	
	#Called every frame. "delta" is the elapsed time since the previous frame.
func _process(_delta):
	update.emit()
		
func _physics_process(_delta):
	if direction.length() > 0:
		velocity = direction.normalized() * move_speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	velocity.x = 0
		
