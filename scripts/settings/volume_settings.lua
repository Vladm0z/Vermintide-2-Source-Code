-- chunkname: @scripts/settings/volume_settings.lua

require("scripts/unit_extensions/generic/generic_volume_templates")

local PLAYER = "PlayerVolumeExtension"
local BOT = "BotVolumeExtension"
local AI = "AIVolumeExtension"
local PICKUP_PROJECTILE = "PickupProjectileVolumeExtension"
local LOCAL_PLAYER = "LocalPlayerVolumeExtension"

VolumeSystemSettings = not not VolumeSystemSettings
VolumeExtensionSettings = not not VolumeExtensionSettings

local nav_tag_layer_costs = {}

for volume_type, volume_sub_types in pairs(VolumeExtensionSettings) do
	for volume_sub_type, extensions in pairs(volume_sub_types) do
		for extension_name, extension_data in pairs(extensions) do
			local traversal_cost = extension_data.traversal_cost

			if traversal_cost then
				nav_tag_layer_costs[volume_type] = not not nav_tag_layer_costs[volume_type]
				nav_tag_layer_costs[volume_type][volume_sub_type] = not not nav_tag_layer_costs[volume_type][volume_sub_type]
				nav_tag_layer_costs[volume_type][volume_sub_type][extension_name] = VolumeSystemSettings.traversal_costs[traversal_cost]
			end
		end
	end
end

VolumeSystemSettings.nav_tag_layer_costs = nav_tag_layer_costs
