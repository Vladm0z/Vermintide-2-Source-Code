-- chunkname: @scripts/managers/game_mode/mechanisms/shared_state_versus.lua

require("scripts/network/shared_state")

local var_0_0 = require("scripts/managers/game_mode/mechanisms/shared_state_versus_spec")

SharedStateVersus = class(SharedStateVersus)

function SharedStateVersus.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0._shared_state = SharedState:new("shared_state_versus_" .. arg_1_3, var_0_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0._is_server = arg_1_1
	arg_1_0._server_peer_id = arg_1_3
	arg_1_0._own_peer_id = arg_1_4
end

function SharedStateVersus.full_sync(arg_2_0)
	arg_2_0._shared_state:full_sync()
end

function SharedStateVersus.register_rpcs(arg_3_0, arg_3_1)
	arg_3_0._shared_state:register_rpcs(arg_3_1)
end

function SharedStateVersus.unregister_rpcs(arg_4_0)
	arg_4_0._shared_state:unregister_rpcs()
end

function SharedStateVersus.network_context_created(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	arg_5_0._shared_state:network_context_created(arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
end

function SharedStateVersus.destroy(arg_6_0)
	arg_6_0._shared_state:destroy()

	arg_6_0._shared_state = nil
end

function SharedStateVersus.get_revision(arg_7_0)
	return arg_7_0._shared_state:get_revision()
end

function SharedStateVersus.is_peer_fully_synced(arg_8_0, arg_8_1)
	return arg_8_0._shared_state:is_peer_fully_synced(arg_8_1)
end

function SharedStateVersus.get_hero_cosmetics(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0._shared_state:get_key("hero_cosmetics", nil, arg_9_2)

	return arg_9_0._shared_state:get_peer(arg_9_1, var_9_0)
end

function SharedStateVersus.set_hero_cosmetics(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7, arg_10_8, arg_10_9, arg_10_10)
	local var_10_0 = arg_10_0._shared_state:get_key("hero_cosmetics", nil, arg_10_2)

	arg_10_0._shared_state:set_peer(arg_10_1, var_10_0, {
		weapon_slot = arg_10_3,
		weapon = arg_10_4,
		weapon_pose = arg_10_5,
		weapon_pose_skin = arg_10_6,
		hero_skin = arg_10_7,
		hat = arg_10_8,
		frame = arg_10_9,
		pactsworn_cosmetics = arg_10_10
	})
end

function SharedStateVersus.on_match_ended(arg_11_0)
	local var_11_0 = arg_11_0._shared_state:get_key("match_ended")

	arg_11_0._shared_state:set_server(var_11_0, true)
end

function SharedStateVersus.get_match_ended(arg_12_0)
	local var_12_0 = arg_12_0._shared_state:get_key("match_ended")

	arg_12_0._shared_state:get_server(var_12_0)
end

function SharedStateVersus.on_party_won_early(arg_13_0)
	local var_13_0 = arg_13_0._shared_state:get_key("party_won_early")

	arg_13_0._shared_state:set_server(var_13_0, true)
end

function SharedStateVersus.get_party_won_early(arg_14_0)
	local var_14_0 = arg_14_0._shared_state:get_key("party_won_early")

	return arg_14_0._shared_state:get_server(var_14_0)
end

function SharedStateVersus.generate_match_id(arg_15_0)
	local var_15_0 = Application.guid()
	local var_15_1 = arg_15_0._shared_state:get_key("match_id")

	arg_15_0._shared_state:set_server(var_15_1, var_15_0)
end

function SharedStateVersus.get_match_id(arg_16_0)
	local var_16_0 = arg_16_0._shared_state:get_key("match_id")

	return arg_16_0._shared_state:get_server(var_16_0)
end
