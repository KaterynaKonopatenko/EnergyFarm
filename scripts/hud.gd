extends CanvasLayer
## Updates HUD labels and build game speed buttons

@onready var energy_label: Label = $VBoxContainer/EnergyLabel
@onready var money_label: Label = $VBoxContainer/MoneyLabel
@onready var clock_label: Label = $VBoxContainer/ClockLabel
@onready var speed_buttons: HBoxContainer = $VBoxContainer/SpeedButtons


func _ready() -> void:
	for speed in GameClock.ALLOWED_SPEEDS:
		var button := Button.new()
		button.text = "x" + str(int(speed))
		button.pressed.connect(GameClock.set_speed.bind(speed))
		speed_buttons.add_child(button)

func _process(_delta: float) -> void:
	var speed := int(GameClock.time_scale)
	var time_text := GameClock.get_time_text()
	energy_label.text = "Енергія: %.1f кВт·год" % Economy.energy_kwh
	money_label.text = "Гроші: %.0f грн" % Economy.money_uah
	clock_label.text = "Час: %s (x%d)" % [time_text, speed]
