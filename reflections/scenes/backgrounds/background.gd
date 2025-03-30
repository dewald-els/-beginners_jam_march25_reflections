class_name BackgroundPanel
extends Panel

var colours: Array[Color] = [
	Color("#7cfc9c"),
	Color("#e74ae8"),
	Color("#4646f5"),
	Color("#98fcf8"),
	Color("#f6cb57"),
	Color("#ed6e6f"),
	Color("#9740c3"),
	Color("#332d3f"),
]

enum Colours {
	Green,
	Pink,
	Blue,
	Aqua,
	Yellow,
	Red,
	Purple,
	Black
}

@export var colour: Colours = Colours.Green

func _ready() -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = colours[colour]
	add_theme_stylebox_override("panel", style)
