extends Node2D

@onready var hud = get_node("HUD")
@onready var action_text = hud.get_node("CountdownContainer/CenterContainer/ActionText")
@onready var score_label_p1 = hud.get_node("PointsDisplay/ScorePlayerOne")
@onready var score_label_p2 = hud.get_node("PointsDisplay/ScorePlayerTwo")

var score_player_one = 0
var score_player_two = 0
var max_score = 3
var round_active = false

func _ready():
	update_score_display()
	start_new_round()
	
func _process(_delta):
		if $StartTimer.time_left > 0:
			var countdown_val = int(ceil($StartTimer.time_left))
			action_text.set_text(str(countdown_val))

func update_score_display():
	score_label_p1.set_text(str(score_player_one))
	score_label_p2.set_text(str(score_player_two))
	
func _on_field_goal_left() -> void:
	if not round_active:
		return
		round_active = false
	score_player_two += 1
	update_score_display()
	if score_player_two >= max_score:
		show_winner("Player Two Wins!")
	else:
		start_new_round()


func _on_field_goal_right() -> void:
	if not round_active:
		return
		round_active = false
	score_player_one += 1
	update_score_display()
	if score_player_one >= max_score:
		show_winner("Player One Wins!")
	else:
		start_new_round()

		
func start_new_round():
	round_active = false
	$Ball.reset()
	$Racket.set_position(Vector2(50,256))
	$Racket2.set_position(Vector2(974,256))
	print(hud)
	print(hud.get_children())
	hud.get_node("CountdownContainer").visible = true
	$StartTimer.start()
	
func _on_start_timer_timeout() -> void:
	hud.get_node("CountdownContainer").visible = false
	round_active = true
	$Ball.set_start_direction()

func show_winner(message: String):
	round_active = false
	$Ball.set_process(false)
	$Ball.set_physics_process(false)
	action_text.set_text(message)
	hud.get_node("CountDownContainer").visible = true
	await get_tree().create_timer(2.0).timeout
	action_text.set_text("Press Space to Restart")
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		set_process_input(false)
		score_player_one = 0
		score_player_two = 0
		update_score_display()
		$Ball.set_process(true)
		$Ball.set_physics_process(true)
		start_new_round()
		
