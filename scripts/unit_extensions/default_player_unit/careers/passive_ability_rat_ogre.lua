-- chunkname: @scripts/unit_extensions/default_player_unit/careers/passive_ability_rat_ogre.lua

PassiveAbilityRatOgre = class(PassiveAbilityRatOgre)

local var_0_0 = {
	"rpc_start_leap",
	"rpc_stop_leap"
}

function PassiveAbilityRatOgre.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0._unit = arg_1_2
	arg_1_0._is_server = arg_1_1.is_server
	arg_1_0._is_remote_player = arg_1_3.player and arg_1_3.player.remote
	arg_1_0._jump_from_pos = Vector3Box(0, 0, 0)
	arg_1_0._jump_to_pos = Vector3Box(0, 0, 0)
	arg_1_0._update_anim_variables = false
	arg_1_0._network_event_delegate = Managers.state.network.network_transmit.network_event_delegate
	arg_1_0._network_transmit = Managers.state.network.network_transmit

	arg_1_0:register_rpcs(arg_1_0._network_event_delegate)

	arg_1_0._anim_value = 0
end

function PassiveAbilityRatOgre.register_rpcs(arg_2_0, arg_2_1)
	arg_2_0._network_event_delegate = arg_2_1

	arg_2_1:register(arg_2_0, unpack(var_0_0))
end

function PassiveAbilityRatOgre.unregister_rpcs(arg_3_0)
	if arg_3_0._network_event_delegate then
		arg_3_0._network_event_delegate:unregister(arg_3_0)

		arg_3_0._network_event_delegate = nil
	end
end

function PassiveAbilityRatOgre.extensions_ready(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0._career_extension = ScriptUnit.extension(arg_4_2, "career_system")

	if not arg_4_0._is_remote_player then
		arg_4_0._first_person_extension = ScriptUnit.has_extension(arg_4_2, "first_person_system")
	end
end

function PassiveAbilityRatOgre.destroy(arg_5_0)
	arg_5_0:unregister_rpcs()
end

function PassiveAbilityRatOgre.rpc_start_leap(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	if Managers.state.unit_storage:unit(arg_6_2) ~= arg_6_0._unit then
		return
	end

	if arg_6_0._is_server then
		if not DEDICATED_SERVER then
			arg_6_0:set_leap_data(arg_6_3, arg_6_4)
		end

		local var_6_0 = CHANNEL_TO_PEER_ID[arg_6_1]

		arg_6_0._network_transmit:send_rpc_clients_except("rpc_start_leap", var_6_0, arg_6_2, arg_6_3, arg_6_4)
	else
		arg_6_0:set_leap_data(arg_6_3, arg_6_4)
	end
end

function PassiveAbilityRatOgre.rpc_stop_leap(arg_7_0, arg_7_1, arg_7_2)
	if Managers.state.unit_storage:unit(arg_7_2) ~= arg_7_0._unit then
		return
	end

	if arg_7_0._is_server then
		if not DEDICATED_SERVER then
			arg_7_0:stop()
		end

		local var_7_0 = CHANNEL_TO_PEER_ID[arg_7_1]

		arg_7_0._network_transmit:send_rpc_clients_except("rpc_stop_leap", var_7_0, arg_7_2)
	else
		arg_7_0:stop()
	end
end

function PassiveAbilityRatOgre.start_leap(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = Managers.state.unit_storage:go_id(arg_8_0._unit)

	if not arg_8_0._is_server and not arg_8_0._is_remote_player then
		arg_8_0._network_transmit:send_rpc_server("rpc_start_leap", var_8_0, arg_8_1, arg_8_2)
		arg_8_0:set_leap_data(arg_8_1, arg_8_2)
	elseif arg_8_0._is_server and not DEDICATED_SERVER then
		arg_8_0._network_transmit:send_rpc_clients("rpc_start_leap", var_8_0, arg_8_1, arg_8_2)
		arg_8_0:set_leap_data(arg_8_1, arg_8_2)
	elseif arg_8_0._is_server then
		arg_8_0._network_transmit:send_rpc_clients("rpc_start_leap", var_8_0, arg_8_1, arg_8_2)
	end
end

function PassiveAbilityRatOgre.set_leap_data(arg_9_0, arg_9_1, arg_9_2)
	if not DEDICATED_SERVER then
		Vector3Box.store(arg_9_0._jump_from_pos, arg_9_1)
		Vector3Box.store(arg_9_0._jump_to_pos, arg_9_2)

		arg_9_0._update_anim_variables = true

		local var_9_0 = arg_9_0._unit

		if not arg_9_0._is_remote_player then
			arg_9_0._first_person_extension:play_animation_event("attack_jump_air")
		end

		Unit.animation_event(var_9_0, "attack_jump_air")
	end
end

function PassiveAbilityRatOgre.stop_leap(arg_10_0)
	local var_10_0 = Managers.state.unit_storage:go_id(arg_10_0._unit)

	if not var_10_0 then
		return
	end

	if not arg_10_0._is_server and not arg_10_0._is_remote_player then
		arg_10_0._network_transmit:send_rpc_server("rpc_stop_leap", var_10_0)
		arg_10_0:stop()
	elseif arg_10_0._is_server and not DEDICATED_SERVER then
		arg_10_0._network_transmit:send_rpc_clients("rpc_stop_leap", var_10_0)
		arg_10_0:stop()
	elseif arg_10_0._is_server then
		arg_10_0._network_transmit:send_rpc_clients("rpc_stop_leap", var_10_0)
	end
end

function PassiveAbilityRatOgre.stop(arg_11_0)
	arg_11_0._update_anim_variables = false

	local var_11_0 = arg_11_0._unit

	if not Unit.alive(var_11_0) then
		return
	end

	if arg_11_0._anim_value and arg_11_0._anim_value > 0.2 then
		if not arg_11_0._is_remote_player then
			arg_11_0._first_person_extension:play_animation_event("attack_jump_land")
		end

		Unit.animation_event(var_11_0, "attack_jump_land")
	else
		if not arg_11_0._is_remote_player then
			arg_11_0._first_person_extension:play_animation_event("cancel_priming")
		end

		Unit.animation_event(var_11_0, "cancel_priming")
	end
end

function PassiveAbilityRatOgre.update(arg_12_0, arg_12_1, arg_12_2)
	if arg_12_0._update_anim_variables then
		local var_12_0 = arg_12_0._unit

		if not Unit.alive(var_12_0) then
			arg_12_0._update_anim_variables = false

			return
		end

		local var_12_1 = POSITION_LOOKUP[var_12_0]
		local var_12_2 = arg_12_0._jump_from_pos:unbox()
		local var_12_3 = arg_12_0._jump_to_pos:unbox()
		local var_12_4 = Vector3.length(var_12_1 - var_12_2) / Vector3.length(var_12_3 - var_12_2)

		arg_12_0._anim_value = math.clamp(var_12_4 * 2, 0, 2)

		local var_12_5 = "jump_rotation"
		local var_12_6 = Unit.animation_find_variable(var_12_0, var_12_5)

		if arg_12_0._is_remote_player then
			Unit.animation_set_variable(var_12_0, var_12_6, arg_12_0._anim_value)
		else
			Unit.animation_set_variable(var_12_0, var_12_6, arg_12_0._anim_value)
			arg_12_0._first_person_extension:animation_set_variable(var_12_5, arg_12_0._anim_value)
		end
	end
end
