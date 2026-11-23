extends CanvasLayer
## Updates HUD labels every frame

@onready var clock_label: Label = $VBoxContainer/ClockLabel

func _process(_delta: float) -> void:
	clock_label.text = "Час: " + GameClock.get_time_text()
