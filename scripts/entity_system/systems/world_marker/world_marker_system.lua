-- chunkname: @scripts/entity_system/systems/world_marker/world_marker_system.lua

require("scripts/unit_extensions/world_markers/player_equipment_world_marker_extension")
require("scripts/unit_extensions/world_markers/store_world_marker_extension")

WorldMarkerSystem = class(WorldMarkerSystem, ExtensionSystemBase)

local var_0_0 = {
	"PlayerEquipmentWorldMarkerExtension",
	"StoreWorldMarkerExtension"
}

function WorldMarkerSystem.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_0)
end

function WorldMarkerSystem.destroy(arg_2_0)
	return
end
