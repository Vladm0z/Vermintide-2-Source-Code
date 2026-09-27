-- chunkname: @scripts/entity_system/systems/career/career_system.lua

CareerSystem = class(CareerSystem, ExtensionSystemBase)

local tbl = {
	"CareerExtension"
}
local tbl_2 = {
	"rpc_server_reduce_activated_ability_cooldown",
	"rpc_server_reduce_activated_ability_cooldown_percent",
	"rpc_reduce_activated_ability_cooldown",
	"rpc_reduce_activated_ability_cooldown_percent",
	"rpc_ability_activated"
}

CareerSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	CareerSystem.super.init(self, arg_1_1, arg_1_2, tbl)

	self.unit_extensions = {}

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl_2))

	self.unit_storage = Managers.state.unit_storage
	self.network_transmit = Managers.state.network.network_transmit
	self.player_manager = Managers.player
end

CareerSystem.destroy = function (self)
	-- function 2
	self.network_event_delegate:unregister(self)

	self.network_event_delegate = nil
end

CareerSystem.on_add_extension = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local on_add_extension = CareerSystem.super.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)

	arg_3_0.unit_extensions[arg_3_2] = on_add_extension

	return on_add_extension
end

CareerSystem.on_remove_extension = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	arg_4_0.unit_extensions[arg_4_1] = nil

	CareerSystem.super.on_remove_extension(arg_4_0, arg_4_1, arg_4_2)
end

CareerSystem.server_reduce_activated_ability_cooldown = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	if not arg_5_1 then
		return
	end

	local unit_storage = self.unit_storage
	local tbl = {}
	local num = 0

	for i = 1, #arg_5_1 do
		local var_5_3 = arg_5_1[i]

		if not ALIVE[var_5_3] then
			tbl[num], num = unit_storage:go_id(var_5_3), num + 1
		end
	end

	if num > 0 then
		self.network_transmit:send_rpc_server("rpc_server_reduce_activated_ability_cooldown", tbl, arg_5_2, arg_5_3, arg_5_4)
	end
end

CareerSystem.rpc_server_reduce_activated_ability_cooldown = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	local network_transmit = self.network_transmit

	if not self.is_server then
		local unit_storage = self.unit_storage
		local player_manager = self.player_manager

		for i = 1, #arg_6_2 do
			local var_6_3 = arg_6_2[i]
			local unit = unit_storage:unit(var_6_3)

			if not unit then
				local network_id = player_manager:owner(unit):network_id()

				network_transmit:send_rpc("rpc_reduce_activated_ability_cooldown", network_id, var_6_3, arg_6_3, arg_6_4, arg_6_5)
			end
		end
	else
		network_transmit:send_rpc_server("rpc_server_reduce_activated_ability_cooldown", arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	end
end

CareerSystem.rpc_reduce_activated_ability_cooldown = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
	local unit = self.unit_storage:unit(arg_7_2)
	local var_7_1 = self.unit_extensions[unit]

	if not var_7_1 then
		var_7_1:reduce_activated_ability_cooldown(arg_7_3, arg_7_4, arg_7_5)
	end
end

CareerSystem.rpc_server_reduce_activated_ability_cooldown_percent = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	local network_transmit = self.network_transmit

	if not self.is_server then
		local unit_storage = self.unit_storage
		local player_manager = self.player_manager
		local unit = unit_storage:unit(arg_8_2)

		if not unit then
			local network_id = player_manager:owner(unit):network_id()

			network_transmit:send_rpc("rpc_reduce_activated_ability_cooldown_percent", network_id, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
		end
	else
		network_transmit:send_rpc_server("rpc_server_rpc_reduce_activated_ability_cooldown_percent", arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	end
end

CareerSystem.rpc_reduce_activated_ability_cooldown_percent = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	-- function 9
	local unit = self.unit_storage:unit(arg_9_2)
	local var_9_1 = self.unit_extensions[unit]

	if not var_9_1 then
		var_9_1:reduce_activated_ability_cooldown_percent(arg_9_3, arg_9_4, arg_9_5)
	end
end

CareerSystem.rpc_ability_activated = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local unit = self.unit_storage:unit(arg_10_2)
	local players_at_peer = Managers.player:players_at_peer(Network.peer_id())

	if not players_at_peer and not unit then
		for k, v in pairs(players_at_peer) do
			local player_unit = v.player_unit

			if not ALIVE[player_unit] then
				local has_extension = ScriptUnit.has_extension(player_unit, "buff_system")

				if not has_extension then
					has_extension:trigger_procs("on_ability_activated", unit, arg_10_3)
					Managers.state.achievement:trigger_event("any_ability_used", unit, arg_10_3)
				end
			end
		end
	end

	local has_extension_2 = ScriptUnit.has_extension(unit, "buff_system")

	if not has_extension_2 then
		has_extension_2:trigger_procs("on_ability_activated", unit, arg_10_3)
	end

	local has_extension_3 = ScriptUnit.has_extension(unit, "cosmetic_system")

	if not has_extension_3 then
		has_extension_3:trigger_ability_activated_events()
	end

	if not self.is_server then
		local var_10_6 = CHANNEL_TO_PEER_ID[arg_10_1]

		self.network_transmit:send_rpc_clients_except("rpc_ability_activated", var_10_6, arg_10_2, arg_10_3)
	end
end
