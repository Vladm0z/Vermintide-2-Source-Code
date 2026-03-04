-- chunkname: @scripts/entity_system/systems/hud/hud_system.lua

require("scripts/unit_extensions/default_player_unit/player_hud")

HUDSystem = class(HUDSystem, ExtensionSystemBase)

local var_0_0 = {
	"PlayerHud"
}
local var_0_1 = {
	"rpc_set_current_location"
}

HUDSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	HUDSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_0)

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_0

	var_1_0:register(arg_1_0, unpack(var_0_1))

	arg_1_0.network_transmit = Managers.state.network.network_transmit
end

HUDSystem.destroy = function (arg_2_0)
	arg_2_0.network_event_delegate:unregister(arg_2_0)

	arg_2_0.network_event_delegate = nil
	arg_2_0.network_transmit = nil
end

HUDSystem.rpc_set_current_location = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_0.unit_storage:unit(arg_3_2)

	if not Unit.alive(var_3_0) then
		return
	end

	local var_3_1 = NetworkLookup.locations[arg_3_3]

	ScriptUnit.extension(var_3_0, "hud_system"):set_current_location(var_3_1)
end

HUDSystem.add_subtitle = function (arg_4_0, arg_4_1, arg_4_2)
	Managers.state.event:trigger("ui_event_start_subtitle", arg_4_1, arg_4_2)
end

HUDSystem.remove_subtitle = function (arg_5_0, arg_5_1)
	Managers.state.event:trigger("ui_event_stop_subtitle", arg_5_1)
end
