class_name Letter
extends Node2D

const MAX_X: float = 1280
const MAXY_Y: float = 720


@onready var letter_label: Label = %LetterLabel
@onready var destruct_timer: Timer = %DestructTimer
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var texture_progress_bar: TextureProgressBar = %TextureProgressBar

var letter_text: String
var letter_destruct_time: float
var time_left: float 
var destroyed: bool = false

const SAFE_BUFFER: int = 128


func _ready() -> void:
	if not letter_text or letter_destruct_time <= 0:
		print("Letter values not correctly set: ", letter_text, letter_destruct_time)
		return 
	
	letter_label.text = letter_text
	global_position = _get_random_position()
	_setup_destruct_timer()
	_setup_progressbar()
	
	
func _setup_progressbar() -> void:
	time_left = letter_destruct_time
	

func _process(delta: float) -> void:
	time_left -= delta
	texture_progress_bar.value = (time_left / letter_destruct_time) * 100
	
	
func _setup_destruct_timer() -> void:
	destruct_timer.wait_time = letter_destruct_time
	destruct_timer.timeout.connect(_on_destruct_timeout)
	destruct_timer.start()
	
	
func _get_random_position() -> Vector2:
	var screen_size = get_viewport().get_visible_rect().size
	var x = randf_range(128, screen_size.x - SAFE_BUFFER)
	var y = randf_range(screen_size.y / 2 - SAFE_BUFFER, screen_size.y - SAFE_BUFFER)
	var random_position: Vector2 = Vector2(
		min(x, MAX_X - SAFE_BUFFER),
		min(y, MAXY_Y - SAFE_BUFFER)
	)
	return random_position
	
	
func _on_destruct_timeout() -> void:
	texture_progress_bar.visible = false
	destroy(false) 
	
	
func destroy(correct: bool) -> void:
	
	if destroyed:
		return
	
	destroyed = true
	
	if animation_player.is_playing():
		animation_player.stop()
		
	if not correct:
		animation_player.play("shake")
	else:
		animation_player.play("float_out")
	
	texture_progress_bar.visible = false
	await animation_player.animation_finished
	Callable(queue_free).call_deferred()
