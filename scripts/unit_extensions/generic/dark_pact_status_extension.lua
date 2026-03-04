-- chunkname: @scripts/unit_extensions/generic/dark_pact_status_extension.lua

require("scripts/entity_system/systems/ghost_mode/ghost_mode_utils")

local var_0_0 = require("scripts/utils/stagger_types")

DarkPactStatusExtension = class(DarkPactStatusExtension, GenericStatusExtension)

DarkPactStatusExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	DarkPactStatusExtension.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)

	arg_1_0._profile_index = arg_1_3.profile_id
	arg_1_0._player = arg_1_3.player
	arg_1_0._is_pinning_enemy = nil
	arg_1_0._pinned_enemy_unit = nil
	arg_1_0._is_packmaster_grabbing = nil
	arg_1_0._is_packmaster_dragging = nil
	arg_1_0._unarmed = nil
	arg_1_0._packmaster_dragged_unit = nil
	arg_1_0._stagger_type = var_0_0.none
	arg_1_0._accumulated_stagger = 0
	arg_1_0._stagger_count = 0
	arg_1_0._stagger_direction = Vector3Box(Vector3(0, 0, 0))
	arg_1_0._stagger_animation_scale = 1
	arg_1_0._stagger_animation_done = false
	arg_1_0._stagger_length = 0
	arg_1_0._stagger_time = 0
	arg_1_0._stagger_immune_time = nil
	arg_1_0._heavy_stagger_immune_time = nil
	arg_1_0._always_stagger_suffered = false
	arg_1_0._breed = arg_1_3.breed or Unit.get_data(arg_1_2, "breed")
	arg_1_0._stagger_reset_time = 0
	arg_1_0._breed_action = nil
	arg_1_0._is_climbing = false
	arg_1_0._is_tunneling = false
	arg_1_0._is_spawning = false
end

DarkPactStatusExtension.extensions_ready = function (arg_2_0)
	DarkPactStatusExtension.super.extensions_ready(arg_2_0)
end

DarkPactStatusExtension.destroy = function (arg_3_0)
	DarkPactStatusExtension.super.destroy(arg_3_0)
end

DarkPactStatusExtension.set_pinning_enemy = function (arg_4_0, arg_4_1, arg_4_2)
	if arg_4_1 then
		arg_4_0._pinned_enemy_unit = arg_4_2
		arg_4_0._is_pinning_enemy = true
	else
		arg_4_0._pinned_enemy_unit = nil
		arg_4_0._is_pinning_enemy = false
	end
end

DarkPactStatusExtension.set_is_packmaster_grabbing = function (arg_5_0, arg_5_1)
	arg_5_0._is_packmaster_grabbing = arg_5_1
end

DarkPactStatusExtension.get_is_packmaster_grabbing = function (arg_6_0)
	return arg_6_0._is_packmaster_grabbing
end

DarkPactStatusExtension.get_is_packmaster_dragging = function (arg_7_0)
	return arg_7_0._is_packmaster_dragging
end

DarkPactStatusExtension.set_is_packmaster_dragging = function (arg_8_0, arg_8_1)
	arg_8_0._is_packmaster_dragging = true
	arg_8_0._packmaster_dragged_unit = arg_8_1
end

DarkPactStatusExtension.set_packmaster_released = function (arg_9_0)
	arg_9_0._is_packmaster_dragging = false
	arg_9_0._packmaster_dragged_unit = nil
end

DarkPactStatusExtension.set_unarmed = function (arg_10_0, arg_10_1)
	arg_10_0._unarmed = arg_10_1
end

DarkPactStatusExtension.get_unarmed = function (arg_11_0)
	return arg_11_0._unarmed
end

DarkPactStatusExtension.get_packmaster_dragged_unit = function (arg_12_0)
	return arg_12_0._packmaster_dragged_unit
end

DarkPactStatusExtension.set_ghost_mode = function (arg_13_0, arg_13_1)
	arg_13_0.in_ghost_mode = arg_13_1
end

DarkPactStatusExtension.get_in_ghost_mode = function (arg_14_0)
	return arg_14_0.in_ghost_mode
end

DarkPactStatusExtension.in_view_enemy_party_players = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = arg_15_2:network_id()
	local var_15_1 = arg_15_2:local_player_id()
	local var_15_2 = Managers.party:get_party_from_player_id(var_15_0, var_15_1)
	local var_15_3 = Managers.state.side.side_by_party[var_15_2].ENEMY_PLAYER_AND_BOT_POSITIONS

	return (GhostModeUtils.in_line_of_sight_of_enemies(arg_15_1, var_15_3, arg_15_3))
end

DarkPactStatusExtension.update = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	DarkPactStatusExtension.super.update(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	arg_16_0:update_stagger_count(arg_16_5)
end

DarkPactStatusExtension.is_staggered = function (arg_17_0)
	return arg_17_0._stagger_type > var_0_0.none
end

DarkPactStatusExtension.accumulated_stagger = function (arg_18_0)
	return arg_18_0._accumulated_stagger
end

DarkPactStatusExtension.stagger_count = function (arg_19_0)
	return arg_19_0._stagger_count
end

DarkPactStatusExtension.stagger_direction = function (arg_20_0)
	return arg_20_0._stagger_direction
end

DarkPactStatusExtension.stagger_animation_scale = function (arg_21_0)
	return arg_21_0._stagger_animation_scale
end

DarkPactStatusExtension.stagger_time = function (arg_22_0)
	return arg_22_0._stagger_time
end

DarkPactStatusExtension.stagger_immune_time = function (arg_23_0)
	return arg_23_0._stagger_immune_time
end

DarkPactStatusExtension.stagger_type = function (arg_24_0)
	return arg_24_0._stagger_type
end

DarkPactStatusExtension.set_stagger_immune_time = function (arg_25_0, arg_25_1)
	arg_25_0._stagger_immune_time = arg_25_1
end

DarkPactStatusExtension.heavy_stagger_immune_time = function (arg_26_0)
	return arg_26_0._heavy_stagger_immune_time
end

DarkPactStatusExtension.set_heavy_stagger_immune_time = function (arg_27_0, arg_27_1)
	arg_27_0._heavy_stagger_immune_time = arg_27_1
end

DarkPactStatusExtension.set_always_stagger_suffered = function (arg_28_0, arg_28_1)
	arg_28_0._always_stagger_suffered = arg_28_1
end

DarkPactStatusExtension.always_stagger_suffered = function (arg_29_0)
	return arg_29_0._always_stagger_suffered
end

DarkPactStatusExtension.stagger_length = function (arg_30_0)
	return arg_30_0._stagger_length
end

DarkPactStatusExtension.stagger_animation_done = function (arg_31_0)
	return arg_31_0._stagger_animation_done
end

DarkPactStatusExtension.set_stagger_animation_done = function (arg_32_0, arg_32_1)
	arg_32_0._stagger_animation_done = arg_32_1
end

DarkPactStatusExtension.set_stagger_values = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5, arg_33_6, arg_33_7, arg_33_8)
	local var_33_0 = Managers.time:time("game")

	arg_33_0._stagger_type = arg_33_1

	arg_33_0._stagger_direction:store(arg_33_2)

	arg_33_0._stagger_length = arg_33_3
	arg_33_0._accumulated_stagger = arg_33_4
	arg_33_0._stagger_time = arg_33_5 > 0 and arg_33_5 + var_33_0 or 0
	arg_33_0._stagger_animation_scale = arg_33_6 or 1
	arg_33_0._always_stagger_suffered = arg_33_7 or false

	if not arg_33_8 or not Managers.state.network:game() then
		return
	end

	local var_33_1 = arg_33_5 or 0
	local var_33_2 = Managers.state.unit_storage:go_id(arg_33_0.unit)

	if arg_33_0.is_server then
		local var_33_3 = Managers.player:owner(arg_33_0.unit)

		if var_33_3 then
			local var_33_4 = var_33_3.peer_id

			Managers.state.network.network_transmit:send_rpc("rpc_set_stagger", var_33_4, var_33_2, arg_33_1, arg_33_2, arg_33_3, arg_33_4, var_33_1, arg_33_0._stagger_animation_scale, arg_33_0._always_stagger_suffered)
		end
	else
		Managers.state.network.network_transmit:send_rpc_server("rpc_set_stagger", var_33_2, arg_33_1, arg_33_2, arg_33_3, arg_33_4, var_33_1, arg_33_0._stagger_animation_scale, arg_33_0._always_stagger_suffered)
	end
end

local var_0_1 = 10

DarkPactStatusExtension.increase_stagger_count = function (arg_34_0)
	local var_34_0 = Managers.time:time("main")
	local var_34_1 = Unit.get_data(arg_34_0.unit, "breed")
	local var_34_2 = arg_34_0._stagger_count
	local var_34_3 = var_34_1.stagger_count_reset_time or var_0_1

	arg_34_0._stagger_count = var_34_2 + 1
	arg_34_0._stagger_reset_time = var_34_0 + var_34_3
end

DarkPactStatusExtension.update_stagger_count = function (arg_35_0, arg_35_1)
	if arg_35_1 > arg_35_0._stagger_reset_time and arg_35_0._stagger_count > 0 then
		arg_35_0._stagger_count = 0
	end
end

DarkPactStatusExtension.set_breed_action = function (arg_36_0, arg_36_1, arg_36_2)
	arg_36_0._breed_action = BreedActions[arg_36_1][arg_36_2]
end

DarkPactStatusExtension.breed_action = function (arg_37_0)
	return arg_37_0._breed_action
end

DarkPactStatusExtension.set_is_climbing = function (arg_38_0, arg_38_1)
	arg_38_0._is_climbing = arg_38_1
end

DarkPactStatusExtension.is_climbing = function (arg_39_0)
	return arg_39_0._about_to_climb or arg_39_0._is_climbing
end

DarkPactStatusExtension.should_climb = function (arg_40_0)
	return arg_40_0._about_to_climb
end

DarkPactStatusExtension.set_should_climb = function (arg_41_0, arg_41_1)
	arg_41_0._about_to_climb = arg_41_1
end

DarkPactStatusExtension.should_tunnel = function (arg_42_0)
	return arg_42_0._is_tunneling
end

DarkPactStatusExtension.set_should_tunnel = function (arg_43_0, arg_43_1)
	arg_43_0._is_tunneling = arg_43_1
end

DarkPactStatusExtension.should_spawn = function (arg_44_0)
	return arg_44_0._is_spawning
end

DarkPactStatusExtension.set_should_spawn = function (arg_45_0, arg_45_1)
	arg_45_0._is_spawning = arg_45_1
end

return "DarkPactStatusExtension"
