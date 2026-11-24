extends CanvasLayer
## Updates HUD labels and wires up HUD buttons

@onready var energy_label: Label = $VBoxContainer/EnergyLabel
@onready var money_label: Label = $VBoxContainer/MoneyLabel
@onready var clock_label: Label = $VBoxContainer/ClockLabel
@onready var price_label: Label = $VBoxContainer/PriceLabel
@onready var speed_buttons: HBoxContainer = $VBoxContainer/SpeedButtons
@onready var sell_button: Button = $VBoxContainer/SellButton
@onready var buy_button: Button = $VBoxContainer/BuyPanelButton

func _ready() -> void:
	sell_button.pressed.connect(Market.sell_all)
	buy_button.pressed.connect(Economy.buy_solar_panel)
	for speed in GameClock.ALLOWED_SPEEDS:
		var button := Button.new()
		button.text = "x" + str(int(speed))
		button.pressed.connect(GameClock.set_speed.bind(speed))
		speed_buttons.add_child(button)

func _process(_delta: float) -> void:
	var speed := int(GameClock.time_scale)
	var time_text := GameClock.get_time_text()
	var price := Market.get_price()
	var kwh := Economy.energy_kwh
	energy_label.text = "Енергія: %.1f кВт·год, панелей: %d" % [kwh,Economy.solar_panels]
	money_label.text = "Гроші: %.2f грн" % Economy.money_uah
	clock_label.text = "Час: %s (x%d)" % [time_text, speed]
	price_label.text = "Ціна: %.0f грн/МВт·год" % price
