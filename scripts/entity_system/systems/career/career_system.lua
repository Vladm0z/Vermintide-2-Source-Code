-- chunkname: @scripts/entity_system/systems/career/career_system.lua

CareerSystem = class(CareerSystem, ExtensionSystemBase)

local var_0_0 = {
	"CareerExtension"
}
local var_0_1 = {
	"rpc_server_reduce_activated_ability_cooldown",
	"rpc_server_reduce_activated_ability_cooldown_percent",
	"rpc_reduce_activated_ability_cooldown",
	"rpc_reduce_activated_ability_cooldown_percent",
	"rpc_ability_activated"
}

function CareerSystem.init(arg_1_0, arg_1_1, arg_1_2)
	CareerSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_0)

	arg_1_0.unit_extensions = {}

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_0

	var_1_0:register(arg_1_0, unpack(var_0_1))

	arg_1_0.unit_storage = Managers.state.unit_storage
	arg_1_0.network_transmit = Managers.state.network.network_transmit
	arg_1_0.player_manager = Managers.player
end

function CareerSystem.destroy(arg_2_0)
	arg_2_0.network_event_delegate:unregister(arg_2_0)

	arg_2_0.network_event_delegate = nil
end

function CareerSystem.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = CareerSystem.super.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)

	arg_3_0.unit_extensions[arg_3_2] = var_3_0

	return var_3_0
end

function CareerSystem.on_remove_extension(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0.unit_extensions[arg_4_1] = nil

	CareerSystem.super.on_remove_extension(arg_4_0, arg_4_1, arg_4_2)
end

function CareerSystem.server_reduce_activated_ability_cooldown(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if not arg_5_1 then
		return
	end

	local var_5_0 = arg_5_0.unit_storage
	local var_5_1 = {}
	local var_5_2 = 0

	for iter_5_0 = 1, #arg_5_1 do
		local var_5_3 = arg_5_1[iter_5_0]

		if ALIVE[var_5_3] then
			var_5_1[var_5_2], var_5_2 = var_5_0:go_id(var_5_3), var_5_2 + 1
		end
	end

	if var_5_2 > 0 then
		arg_5_0.network_transmit:send_rpc_server("rpc_server_reduce_activated_ability_cooldown", var_5_1, arg_5_2, arg_5_3, arg_5_4)
	end
end

function CareerSystem.rpc_server_reduce_activated_ability_cooldown(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	local var_6_0 = arg_6_0.network_transmit

	if arg_6_0.is_server then
		local var_6_1 = arg_6_0.unit_storage
		local var_6_2 = arg_6_0.player_manager

		for iter_6_0 = 1, #arg_6_2 do
			local var_6_3 = arg_6_2[iter_6_0]
			local var_6_4 = var_6_1:unit(var_6_3)

			if var_6_4 then
				local var_6_5 = var_6_2:owner(var_6_4):network_id()

				var_6_0:send_rpc("rpc_reduce_activated_ability_cooldown", var_6_5, var_6_3, arg_6_3, arg_6_4, arg_6_5)
			end
		end
	else
		var_6_0:send_rpc_server("rpc_server_reduce_activated_ability_cooldown", arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	end
end

function CareerSystem.rpc_reduce_activated_ability_cooldown(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	local var_7_0 = arg_7_0.unit_storage:unit(arg_7_2)
	local var_7_1 = arg_7_0.unit_extensions[var_7_0]

	if var_7_1 then
		var_7_1:reduce_activated_ability_cooldown(arg_7_3, arg_7_4, arg_7_5)
	end
end

function CareerSystem.rpc_server_reduce_activated_ability_cooldown_percent(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	local var_8_0 = arg_8_0.network_transmit

	if arg_8_0.is_server then
		local var_8_1 = arg_8_0.unit_storage
		local var_8_2 = arg_8_0.player_manager
		local var_8_3 = var_8_1:unit(arg_8_2)

		if var_8_3 then
			local var_8_4 = var_8_2:owner(var_8_3):network_id()

			var_8_0:send_rpc("rpc_reduce_activated_ability_cooldown_percent", var_8_4, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
		end
	else
		var_8_0:send_rpc_server("rpc_server_rpc_reduce_activated_ability_cooldown_percent", arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	end
end

function CareerSystem.rpc_reduce_activated_ability_cooldown_percent(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	local var_9_0 = arg_9_0.unit_storage:unit(arg_9_2)
	local var_9_1 = arg_9_0.unit_extensions[var_9_0]

	if var_9_1 then
		var_9_1:reduce_activated_ability_cooldown_percent(arg_9_3, arg_9_4, arg_9_5)
	end
end

function CareerSystem.rpc_ability_activated(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = arg_10_0.unit_storage:unit(arg_10_2)
	local var_10_1 = Managers.player:players_at_peer(Network.peer_id())

	if var_10_1 and var_10_0 then
		for iter_10_0, iter_10_1 in pairs(var_10_1) do
			local var_10_2 = iter_10_1.player_unit

			if ALIVE[var_10_2] then
				local var_10_3 = ScriptUnit.has_extension(var_10_2, "buff_system")

				if var_10_3 then
					var_10_3:trigger_procs("on_ability_activated", var_10_0, arg_10_3)
					Managers.state.achievement:trigger_event("any_ability_used", var_10_0, arg_10_3)
				end
			end
		end
	end

	local var_10_4 = ScriptUnit.has_extension(var_10_0, "buff_system")

	if var_10_4 then
		var_10_4:trigger_procs("on_ability_activated", var_10_0, arg_10_3)
	end

	local var_10_5 = ScriptUnit.has_extension(var_10_0, "cosmetic_system")

	if var_10_5 then
		var_10_5:trigger_ability_activated_events()
	end

	if arg_10_0.is_server then
		local var_10_6 = CHANNEL_TO_PEER_ID[arg_10_1]

		arg_10_0.network_transmit:send_rpc_clients_except("rpc_ability_activated", var_10_6, arg_10_2, arg_10_3)
	end
end
