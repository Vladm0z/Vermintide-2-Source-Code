-- chunkname: @scripts/entity_system/systems/hud/hud_system.lua

require("scripts/unit_extensions/default_player_unit/player_hud")

HUDSystem = class(HUDSystem, ExtensionSystemBase)

local tbl = {
	"PlayerHud"
}
local tbl_2 = {
	"rpc_set_current_location"
}

HUDSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	HUDSystem.super.init(self, arg_1_1, arg_1_2, tbl)

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl_2))

	self.network_transmit = Managers.state.network.network_transmit
end

HUDSystem.destroy = function (self)
	-- function 2
	self.network_event_delegate:unregister(self)

	self.network_event_delegate = nil
	self.network_transmit = nil
end

HUDSystem.rpc_set_current_location = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local unit = self.unit_storage:unit(arg_3_2)

	if not Unit.alive(unit) then
		return
	end

	local var_3_1 = NetworkLookup.locations[arg_3_3]

	ScriptUnit.extension(unit, "hud_system"):set_current_location(var_3_1)
end

HUDSystem.add_subtitle = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	Managers.state.event:trigger("ui_event_start_subtitle", arg_4_1, arg_4_2)
end

HUDSystem.remove_subtitle = function (arg_5_0, arg_5_1)
	-- function 5
	Managers.state.event:trigger("ui_event_stop_subtitle", arg_5_1)
end
