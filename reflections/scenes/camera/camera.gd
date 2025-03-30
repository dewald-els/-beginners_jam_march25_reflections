class_name GameCamera
extends Camera2D

@export var shake_noise: Noise

var x_noise_sample_vector = Vector2.RIGHT
var y_noise_sample_vector = Vector2.DOWN
var noise_sample_travel_rate = 500
var max_shake_offset: int = 10
var current_shake_percentage = 0
var x_noise_sample_position = Vector2.ZERO
var y_noise_sample_position = Vector2.ZERO
var shake_decay: int = 3

func _process(delta: float) -> void:
	if (current_shake_percentage > 0):
		_process_shake(delta)
		
func _process_shake(delta):
	x_noise_sample_position += x_noise_sample_vector * noise_sample_travel_rate * delta
	y_noise_sample_position += y_noise_sample_vector * noise_sample_travel_rate * delta
	var x_sample = shake_noise.get_noise_2d(x_noise_sample_position.x, x_noise_sample_position.y)
	var y_sample = shake_noise.get_noise_2d(y_noise_sample_position.x, y_noise_sample_position.y)
	
	var shake_offset = Vector2(x_sample, y_sample) * max_shake_offset * pow(current_shake_percentage, 2)
	offset = shake_offset
	current_shake_percentage = clamp(current_shake_percentage - shake_decay * delta, 0, 1)

func shake(percentage, decay = 3):
	shake_decay = decay
	current_shake_percentage = clamp(current_shake_percentage + percentage, 0, 1)
