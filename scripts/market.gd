extends Node
## Day-ahead market (UAH/Mwh). Test hourly prices until real data

const TEST_PRICES := [
	3000, 2800, 2600, 2500, 2500, 2700,
	3200, 4000, 4500, 4200, 3800, 3500,
	3300, 3200, 3400, 3800, 4500, 5500,
	6500, 7000, 6000, 5000, 4000, 3400,
]

func get_price() -> float:
	var hour := int(GameClock.game_hours) % 24
	return float(TEST_PRICES[hour])
	
func sell_all() -> void:
	var mwh := Economy.energy_kwh / 1000.0
	Economy.money_uah += mwh * get_price()
	Economy.energy_kwh = 0.0
