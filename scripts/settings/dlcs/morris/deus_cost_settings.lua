-- chunkname: @scripts/settings/dlcs/morris/deus_cost_settings.lua

local base_swap_cost = {
	common = 60,
	plentiful = 0,
	exotic = 200,
	rare = 120,
	unique = 300
}
local base_upgrade_cost = {
	common = 100,
	plentiful = 0,
	exotic = 350,
	rare = 200,
	unique = 500
}
local swap_discount = 0.5
local upgrade_discount = 0.5

local function cost_formula_for_swap(equipped_rarity, new_rarity)
	-- function 1
	local value = base_swap_cost[new_rarity] - base_swap_cost[equipped_rarity] * swap_discount

	value = math.ceil(value / 10) * 10

	return math.max(value, 0)
end

local function cost_formula_for_upgrade(equipped_rarity, new_rarity)
	-- function 2
	local value = base_upgrade_cost[new_rarity] - base_upgrade_cost[equipped_rarity] * upgrade_discount

	value = math.ceil(value / 10) * 10

	return math.max(value, 0)
end

DeusCostSettings = not not DeusCostSettings
