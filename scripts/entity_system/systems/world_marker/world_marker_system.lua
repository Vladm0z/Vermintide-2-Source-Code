-- chunkname: @scripts/entity_system/systems/world_marker/world_marker_system.lua

require("scripts/unit_extensions/world_markers/player_equipment_world_marker_extension")
require("scripts/unit_extensions/world_markers/store_world_marker_extension")

WorldMarkerSystem = class(WorldMarkerSystem, ExtensionSystemBase)

local tbl = {
	"PlayerEquipmentWorldMarkerExtension",
	"StoreWorldMarkerExtension"
}

WorldMarkerSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self.super.init(self, arg_1_1, arg_1_2, tbl)
end

WorldMarkerSystem.destroy = function (arg_2_0)
	-- function 2
	return
end
