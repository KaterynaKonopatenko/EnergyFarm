extends Node
## Player resources: stored energy (kWh) and money (UAH) owned stations

const START_MONEY := 10000.0
const SOLAR_PANEL_PRICE := 5000.0

var energy_kwh := 0.0
var money_uah := START_MONEY
var solar_panels := 1

func buy_solar_panel() -> void:
	if money_uah < SOLAR_PANEL_PRICE:
		return
	money_uah -= SOLAR_PANEL_PRICE
	solar_panels += 1
