class_name Game
extends Node

# Difficulty curve: Exponential Decay Formula (Smooth Decrease)
# Equation: T_n = T_min + (T_max - T_min) * exp(-k * n)

@onready var next_letter_timer: Timer = %NextLetterTimer
@onready var letters_container: Node = %LettersContainer
@onready var score_label: Label = %ScoreLabel
@onready var total_spawned_label: Label = %TotalSpawnedLabel

@export var letter_scene: PackedScene
@export var game_camera: GameCamera

@export var initial_letter_interval: float = 2.0
@export var difficulty_factor: float = 0.025
var current_letter_interval: float
var total_letters_spawned: int = 0
var minimum_interval: float = 0.5

const SOURCE_TEXT: Array[String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

var current_letter: Letter
var score: int = 0
var is_dead:bool = false

var correct_letters: Array[Dictionary] = []
var incorrect_letters: Array[Dictionary] = []

func _ready() -> void:
	
	SignalBus.health_empty.connect(_on_health_empty)
	
	next_letter_timer.wait_time = initial_letter_interval
	next_letter_timer.timeout.connect(_on_next_letter_timeout)
	
	current_letter_interval = initial_letter_interval
	
	_create_next_letter()
	_start_new_timer()


func _get_next_letter() -> String:
	randomize()
	return SOURCE_TEXT[randi() % SOURCE_TEXT.size()]


func _create_next_letter() -> void:
	if is_dead: 
		return
		
	var random_letter: String = _get_next_letter()
	var letter_instance: Letter = letter_scene.instantiate()
	letter_instance.letter_destruct_time = current_letter_interval
	letter_instance.letter_text = random_letter
	current_letter = letter_instance
	letters_container.add_child(letter_instance)
	total_letters_spawned += 1
	total_spawned_label.text = "Letters: " + str(total_letters_spawned)

func _start_new_timer() -> void:
	if is_dead: 
		return
		
	var new_interval = minimum_interval + (initial_letter_interval - minimum_interval) * exp(-difficulty_factor * total_letters_spawned)
	current_letter_interval = new_interval
	next_letter_timer.stop()
	next_letter_timer.wait_time = new_interval
	next_letter_timer.start() 

	
func _unhandled_input(event: InputEvent) -> void:
	if next_letter_timer.is_stopped():
		return
		
	if is_dead:
		return
		
	if event is InputEventKey and event.pressed:
		
		var keycode:int = event.keycode
		
		if _valid_keycode_entered(keycode):
			var typed_letter: String = char(keycode)
			if typed_letter == current_letter.letter_text:
				correct_letters.append({
					"letter": current_letter.letter_text,
					"time_left": next_letter_timer.time_left
				})
				score += 1
				score_label.text = "Score: " + str(score)
				current_letter.destroy(true)
				next_letter_timer.stop()
				_create_next_letter()
				_start_new_timer()
			else:
				game_camera.shake(100)
				current_letter.destroy(false)
				incorrect_letters.append({
					"letter": current_letter.letter_text,
					"time_left": next_letter_timer.time_left
				})
				_on_next_letter_timeout()
			

func _valid_keycode_entered(keycode: int) -> bool:
	return (keycode >= KEY_A and keycode <= KEY_Z) or (keycode >= KEY_0 and keycode <= KEY_9)


func _on_next_letter_timeout() -> void:
	if is_dead:
		return
		
	SignalBus.incorrect_input.emit()
	_create_next_letter()
	_start_new_timer()
	
func _on_health_empty() -> void:
	print("Dead")
	is_dead = true
	current_letter.destroy(true)
	next_letter_timer.paused = true
	
