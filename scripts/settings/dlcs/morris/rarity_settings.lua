-- chunkname: @scripts/settings/dlcs/morris/rarity_settings.lua

local plentiful_color = Colors.get_table("plentiful")
local red = 255 / plentiful_color[2]
local green = 255 / plentiful_color[3]
local blue = 255 / plentiful_color[4]
local plentiful_multiplier = red < green and (red or green) or not (red < green) and green

plentiful_multiplier = plentiful_multiplier < blue and (plentiful_multiplier or blue) or not (plentiful_multiplier < blue) and blue

local common_color = Colors.get_table("common")
local red = 255 / common_color[2]
local green = 255 / common_color[3]
local blue = 255 / common_color[4]
local common_multiplier = red < green and (red or green) or not (red < green) and green

common_multiplier = common_multiplier < blue and (common_multiplier or blue) or not (common_multiplier < blue) and blue

local rare_color = Colors.get_table("rare")
local red = 255 / rare_color[2]
local green = 255 / rare_color[3]
local blue = 255 / rare_color[4]
local rare_multiplier = red < green and (red or green) or not (red < green) and green

rare_multiplier = rare_multiplier < blue and (rare_multiplier or blue) or not (rare_multiplier < blue) and blue

local exotic_color = Colors.get_table("exotic")
local red = 255 / exotic_color[2]
local green = 255 / exotic_color[3]
local blue = 255 / exotic_color[4]
local exotic_multiplier = red < green and (red or green) or not (red < green) and green

exotic_multiplier = exotic_multiplier < blue and (exotic_multiplier or blue) or not (exotic_multiplier < blue) and blue

local unique_color = Colors.get_table("unique")
local red = 255 / unique_color[2]
local green = 255 / unique_color[3]
local blue = 255 / unique_color[4]
local unique_multiplier = red < green and (red or green) or not (red < green) and green

unique_multiplier = unique_multiplier < blue and (unique_multiplier or blue) or not (unique_multiplier < blue) and blue

local event_color = Colors.get_table("event")
local red = 255 / event_color[2]
local green = 255 / event_color[3]
local blue = 255 / event_color[4]
local event_multiplier = red < green and (red or green) or not (red < green) and green

event_multiplier = event_multiplier < blue and (event_multiplier or blue) or not (event_multiplier < blue) and blue
ORDER_RARITY = table.mirror_array({
	"plentiful",
	"common",
	"rare",
	"exotic",
	"unique",
	"magic",
	"promo"
})
RaritySettings = RaritySettings
RarityIndex = {}

for rarity_name, rarity_data in pairs(RaritySettings) do
	RarityIndex[rarity_name] = rarity_data.order
end
