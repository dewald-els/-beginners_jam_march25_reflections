class_name HealthUI
extends PanelContainer

@onready var health_hearts_h_box: HBoxContainer = %HealthHeartsHBox

var health: int = 5
var hearts: Array[HealthHeart] = []


func _ready() -> void:
	SignalBus.incorrect_input.connect(_on_incorrect_input)
	for heart in health_hearts_h_box.get_children():
		hearts.append(heart)

func _on_incorrect_input() -> void:
	if health > 0:
		health -= 1
		hearts[health].set_empty()
		if health == 0:
			SignalBus.health_empty.emit()
