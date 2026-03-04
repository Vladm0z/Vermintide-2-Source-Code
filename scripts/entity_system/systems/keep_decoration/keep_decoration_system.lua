-- chunkname: @scripts/entity_system/systems/keep_decoration/keep_decoration_system.lua

require("scripts/settings/keep_decoration_settings")
require("scripts/unit_extensions/level/keep_decoration_painting_extension")
require("scripts/unit_extensions/level/keep_decoration_trophy_extension")
require("scripts/settings/trophies")

KeepDecorationSystem = class(KeepDecorationSystem, ExtensionSystemBase)

local var_0_0 = {
	"KeepDecorationPaintingExtension",
	"KeepDecorationTrophyExtension"
}
local var_0_1 = {
	"rpc_request_painting",
	"rpc_send_painting"
}

KeepDecorationSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	KeepDecorationSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_0)

	arg_1_0._network_event_delegate = arg_1_1.network_event_delegate

	arg_1_0._network_event_delegate:register(arg_1_0, unpack(var_0_1))

	arg_1_0._network_trasmit = Managers.state.network.network_transmit
	arg_1_0._extensions = {}
	arg_1_0._unit_extensions = {}
	arg_1_0._painting_extensions = {}
	arg_1_0._used_settings_keys = {}
	arg_1_0._used_backend_keys = {}
	arg_1_0._update_index = 0
	arg_1_0._is_leader = Managers.party:is_leader(Network.peer_id())
	arg_1_0._client_paintings = {}
	arg_1_0._client_painting_extensions = {}
	arg_1_0._num_players = 0
end

KeepDecorationSystem.destroy = function (arg_2_0)
	arg_2_0._extensions = nil
	arg_2_0._unit_extensions = nil
	arg_2_0._painting_extensions = nil

	arg_2_0._network_event_delegate:unregister(arg_2_0)
end

KeepDecorationSystem.on_add_extension = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, ...)
	local var_3_0 = Unit.get_data(arg_3_2, "decoration_settings_key")
	local var_3_1 = arg_3_0._used_settings_keys
	local var_3_2 = arg_3_0._used_backend_keys

	fassert(not var_3_1[var_3_0], "Multiple units has the same decoration_settings_key \"" .. tostring(var_3_0) .. "\". Fix it in the unit data!")

	local var_3_3 = KeepDecorationSettings[var_3_0]

	fassert(var_3_3, "No settings found for decoration_settings_key \"" .. tostring(var_3_0) .. "\". Fix it in keep_decoration_settings.lua!")

	local var_3_4 = var_3_3.backend_key

	fassert(not var_3_2[var_3_4], "Multiple decoration settings has the same backend_key \"" .. tostring(var_3_4) .. "\". Fix it in keep_decoration_settings.lua!")

	local var_3_5 = KeepDecorationSystem.super.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, ...)

	if arg_3_3 == "KeepDecorationPaintingExtension" then
		if Unit.get_data(arg_3_2, "painting_data", "is_client_painting") then
			arg_3_0._client_painting_extensions[#arg_3_0._client_painting_extensions + 1] = var_3_5
		end

		arg_3_0._painting_extensions[#arg_3_0._painting_extensions + 1] = var_3_5
	end

	var_3_5.keep_decoration_system = arg_3_0
	arg_3_0._extensions[#arg_3_0._extensions + 1] = var_3_5
	arg_3_0._unit_extensions[arg_3_2] = var_3_5
	arg_3_0._used_settings_keys[var_3_0] = true
	arg_3_0._used_backend_keys[var_3_4] = true

	return var_3_5
end

KeepDecorationSystem.update = function (arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0._extensions
	local var_4_1 = #var_4_0

	if var_4_1 == 0 then
		return
	end

	local var_4_2 = arg_4_0._update_index + 1

	if var_4_1 < var_4_2 then
		var_4_2 = 1
	end

	var_4_0[var_4_2]:distributed_update()

	local var_4_3 = Managers.state.game_mode:level_key()
	local var_4_4 = LevelSettings[var_4_3]

	if arg_4_0._is_leader and var_4_4.use_keep_decorations then
		local var_4_5 = Managers.player:human_players()
		local var_4_6 = 0

		for iter_4_0, iter_4_1 in pairs(var_4_5) do
			var_4_6 = var_4_6 + 1
		end

		if arg_4_0._is_leader and var_4_6 ~= arg_4_0._num_players then
			arg_4_0._num_players = var_4_6

			arg_4_0:_sync_client_paintings()
			arg_4_0:_refresh_client_paintings()
		end
	end

	arg_4_0._update_index = var_4_2
end

KeepDecorationSystem.on_painting_set = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0._painting_extensions
	local var_5_1 = Paintings[arg_5_1].frame

	for iter_5_0 = 1, #var_5_0 do
		local var_5_2 = var_5_0[iter_5_0]
		local var_5_3 = var_5_2:get_selected_decoration()
		local var_5_4 = Paintings[var_5_3].frame
		local var_5_5 = var_5_2:is_client_painting()

		if var_5_3 == arg_5_1 and arg_5_2 ~= var_5_2 and var_5_1 == var_5_4 and not var_5_5 then
			var_5_2:decoration_selected("hor_none")
			var_5_2:sync_decoration()
		end
	end
end

KeepDecorationSystem.on_decoration_set = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_0._extensions

	for iter_6_0 = 1, #var_6_0 do
		local var_6_1 = var_6_0[iter_6_0]

		if var_6_1:get_selected_decoration() == arg_6_1 and arg_6_2 ~= var_6_1 then
			local var_6_2 = arg_6_3 == "painting" and "hor_none" or arg_6_3 == "trophy" and "hub_trophy_empty"

			var_6_1:decoration_selected(var_6_2)
			var_6_1:sync_decoration()
		end
	end
end

KeepDecorationSystem.is_decoration_in_use = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._extensions

	for iter_7_0 = 1, #var_7_0 do
		if var_7_0[iter_7_0]:get_selected_decoration() == arg_7_1 then
			return true
		end
	end

	return false
end

KeepDecorationSystem._add_client_painting = function (arg_8_0, arg_8_1, arg_8_2)
	arg_8_0._client_paintings[arg_8_1] = arg_8_2
end

KeepDecorationSystem._sync_client_paintings = function (arg_9_0)
	local var_9_0 = arg_9_0._client_paintings
	local var_9_1 = Managers.player:human_players()
	local var_9_2 = Network.peer_id()

	for iter_9_0, iter_9_1 in pairs(var_9_0) do
		local var_9_3 = false

		for iter_9_2, iter_9_3 in pairs(var_9_1) do
			if iter_9_0 == iter_9_3.peer_id and iter_9_3.peer_id ~= var_9_2 then
				var_9_3 = true

				break
			end
		end

		if not var_9_3 then
			var_9_0[iter_9_0] = nil
		end
	end

	arg_9_0._client_paintings = var_9_0
end

KeepDecorationSystem._refresh_client_paintings = function (arg_10_0)
	local var_10_0 = arg_10_0._client_paintings
	local var_10_1 = {}
	local var_10_2 = 1

	for iter_10_0, iter_10_1 in pairs(var_10_0) do
		var_10_1[var_10_2] = iter_10_1
		var_10_2 = var_10_2 + 1
	end

	for iter_10_2 = 1, 3 do
		local var_10_3 = var_10_1[iter_10_2] or "hidden"

		arg_10_0._client_painting_extensions[iter_10_2]:set_client_painting(var_10_3)
	end
end

KeepDecorationSystem.rpc_send_painting = function (arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = CHANNEL_TO_PEER_ID[arg_11_1]

	arg_11_0:_add_client_painting(var_11_0, arg_11_2)
	arg_11_0:_refresh_client_paintings()
end

KeepDecorationSystem.rpc_request_painting = function (arg_12_0, arg_12_1)
	local var_12_0 = Managers.backend:get_interface("keep_decorations"):get_decoration("keep_hall_painting_wood_base_5") or "hor_none"

	arg_12_0.network_transmit:send_rpc_server("rpc_send_painting", var_12_0)
end

KeepDecorationSystem.hot_join_sync = function (arg_13_0, arg_13_1)
	local var_13_0 = Managers.state.game_mode:level_key()

	if LevelSettings[var_13_0].use_keep_decorations then
		local var_13_1 = PEER_ID_TO_CHANNEL[arg_13_1]

		RPC.rpc_request_painting(var_13_1)
	end
end
