-- chunkname: @scripts/entity_system/systems/animation/animation_system.lua

require("scripts/entity_system/systems/animation/animation_callback_templates")
require("scripts/entity_system/systems/animation/networked_animation_variable_templates")

AnimationSystem = class(AnimationSystem, ExtensionSystemBase)

local var_0_0 = POSITION_LOOKUP
local var_0_1 = {
	"rpc_sync_anim_state_1",
	"rpc_sync_anim_state_2",
	"rpc_sync_anim_state_3",
	"rpc_sync_anim_state_4",
	"rpc_sync_anim_state_5",
	"rpc_sync_anim_state_6",
	"rpc_sync_anim_state_7",
	"rpc_sync_anim_state_8",
	"rpc_sync_anim_state_9",
	"rpc_sync_anim_state_10",
	"rpc_sync_anim_state_11",
	"rpc_sync_anim_state_12",
	"rpc_anim_event",
	"rpc_anim_event_variable_float",
	"rpc_anim_set_variable_float",
	"rpc_anim_set_variable_int",
	"rpc_link_unit",
	"rpc_anim_set_variable_by_distance",
	"rpc_anim_set_variable_by_time",
	"rpc_update_anim_variable_done"
}
local var_0_2 = {}

AnimationSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	AnimationSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_2)
	Managers.state.event:register(arg_1_0, "animation_callback", "animation_callback")

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_0

	var_1_0:register(arg_1_0, unpack(var_0_1))

	arg_1_0.anim_variable_update_list = {}
	arg_1_0._networked_animation_variables = {}
	arg_1_0._animation_safe_callbacks_buffer_1 = {}
	arg_1_0._animation_safe_callbacks_buffer_2 = {}
	arg_1_0._animation_safe_callbacks = arg_1_0._animation_safe_callbacks_buffer_1
end

AnimationSystem.destroy = function (arg_2_0)
	arg_2_0.network_event_delegate:unregister(arg_2_0)
end

AnimationSystem.animation_callback = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0

	if arg_3_0.is_server then
		local var_3_1 = AnimationCallbackTemplates.server[arg_3_2]

		if var_3_1 then
			var_3_1(arg_3_1, arg_3_3)
		end
	end

	local var_3_2 = AnimationCallbackTemplates.client[arg_3_2]

	if var_3_2 then
		var_3_2(arg_3_1, arg_3_3)
	end
end

AnimationSystem.update = function (arg_4_0, arg_4_1, arg_4_2)
	arg_4_0:update_anim_variables(arg_4_2)
	arg_4_0:_update_networked_anim_variables(arg_4_1.dt, arg_4_2)
end

AnimationSystem.update_anim_variables = function (arg_5_0, arg_5_1)
	local var_5_0 = var_0_0
	local var_5_1 = Vector3.length
	local var_5_2 = Unit.alive
	local var_5_3 = 0
	local var_5_4 = math.clamp
	local var_5_5 = Unit.animation_set_variable

	for iter_5_0, iter_5_1 in pairs(arg_5_0.anim_variable_update_list) do
		if var_5_0[iter_5_0] then
			local var_5_6

			if iter_5_1.goal_pos then
				local var_5_7 = var_5_0[iter_5_0]
				local var_5_8 = iter_5_1.goal_pos:unbox() - var_5_7

				if iter_5_1.flat_distance then
					var_5_8 = Vector3.flat(var_5_8)
				end

				local var_5_9 = var_5_1(var_5_8)
				local var_5_10 = iter_5_1.scale

				var_5_6 = var_5_4(var_5_10 - var_5_10 * var_5_9 / iter_5_1.initial_distance, 0, var_5_10)
			else
				local var_5_11 = arg_5_1 - iter_5_1.start_time
				local var_5_12 = iter_5_1.scale

				var_5_6 = var_5_4(var_5_12 * var_5_11 / iter_5_1.duration, 0, var_5_12)
			end

			var_5_5(iter_5_0, iter_5_1.anim_variable_index, var_5_6)

			var_5_3 = var_5_3 + 1
		else
			arg_5_0.anim_variable_update_list[iter_5_0] = nil
		end
	end
end

AnimationSystem.anim_event = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if not arg_6_3 and Managers.state.network:game() then
		local var_6_0 = arg_6_0.unit_storage:go_id(arg_6_1)

		fassert(var_6_0, "Unit storage does not have a game object id for %q", arg_6_1)

		local var_6_1 = NetworkLookup.anims[arg_6_2]

		if arg_6_0.is_server then
			arg_6_0.network_transmit:send_rpc_clients("rpc_anim_event", var_6_1, var_6_0)
		else
			arg_6_0.network_transmit:send_rpc_server("rpc_anim_event", var_6_1, var_6_0)
		end
	end

	arg_6_0:_init_networked_variables(arg_6_1, arg_6_2)

	return Unit.animation_event(arg_6_1, arg_6_2)
end

AnimationSystem.anim_event_with_variable_float = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	if not arg_7_5 and Managers.state.network:game() then
		local var_7_0 = arg_7_0.unit_storage:go_id(arg_7_1)

		fassert(var_7_0, "Unit storage does not have a game object id for %q", arg_7_1)

		local var_7_1 = NetworkLookup.anims[arg_7_2]
		local var_7_2 = NetworkLookup.anims[arg_7_3]

		if arg_7_0.is_server then
			arg_7_0.network_transmit:send_rpc_clients("rpc_anim_event_variable_float", var_7_1, var_7_0, var_7_2, arg_7_4)
		else
			arg_7_0.network_transmit:send_rpc_server("rpc_anim_event_variable_float", var_7_1, var_7_0, var_7_2, arg_7_4)
		end
	end

	arg_7_0:_init_networked_variables(arg_7_1, arg_7_2)

	local var_7_3 = Unit.animation_find_variable(arg_7_1, arg_7_3)

	Unit.animation_set_variable(arg_7_1, var_7_3, arg_7_4)
	Unit.animation_event(arg_7_1, arg_7_2)
end

if LEVEL_EDITOR_TEST then
	AnimationSystem.anim_event = function (arg_8_0, arg_8_1, arg_8_2)
		arg_8_0:_init_networked_variables(arg_8_1, arg_8_2)
		Unit.animation_event(arg_8_1, arg_8_2)
	end

	AnimationSystem.anim_event_with_variable_float = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
		arg_9_0:_init_networked_variables(arg_9_1, arg_9_2)

		local var_9_0 = Unit.animation_find_variable(arg_9_1, arg_9_3)

		Unit.animation_set_variable(arg_9_1, var_9_0, arg_9_4)
		Unit.animation_event(arg_9_1, arg_9_2)
	end
end

AnimationSystem._init_networked_variables = function (arg_10_0, arg_10_1, arg_10_2)
	arg_10_0:_remove_networked_variables(arg_10_1)

	if not NetworkedAnimationVariableTemplatesLookup[arg_10_2] then
		return
	end

	local var_10_0 = Unit.get_data(arg_10_1, "breed")

	if not var_10_0 then
		return
	end

	local var_10_1 = var_10_0.networked_animation_variables

	if not var_10_1 then
		return
	end

	local var_10_2 = var_10_1[arg_10_2]

	if not var_10_2 then
		return
	end

	local var_10_3 = arg_10_0._networked_animation_variables

	if var_10_3[arg_10_1] then
		table.clear(var_10_3[arg_10_1].updates)
	end

	for iter_10_0, iter_10_1 in pairs(var_10_2) do
		local var_10_4 = {
			variable_name = iter_10_0,
			variable_index = Unit.animation_find_variable(arg_10_1, iter_10_0),
			variable_data = iter_10_1
		}
		local var_10_5 = NetworkedAnimationVariableTemplates[iter_10_0]

		if var_10_5.init then
			var_10_5.init(arg_10_1, var_10_4)
		end

		local var_10_6 = var_10_3[arg_10_1] or {
			updates = {}
		}

		if var_10_5.update then
			var_10_6.updates[#var_10_6.updates + 1] = var_10_4
		end

		var_10_6[#var_10_6 + 1] = var_10_4
		var_10_3[arg_10_1] = var_10_6
	end
end

AnimationSystem._remove_networked_variables = function (arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0._networked_animation_variables[arg_11_1]

	if var_11_0 then
		for iter_11_0 = 1, #var_11_0 do
			local var_11_1 = var_11_0[iter_11_0]
			local var_11_2 = var_11_1.variable_name
			local var_11_3 = NetworkedAnimationVariableTemplates[var_11_2]

			if var_11_3.stop then
				var_11_3.stop(arg_11_1, var_11_1)
			end

			var_11_0[iter_11_0] = nil
		end
	end
end

AnimationSystem._update_networked_anim_variables = function (arg_12_0, arg_12_1, arg_12_2)
	for iter_12_0, iter_12_1 in pairs(arg_12_0._networked_animation_variables) do
		if not ALIVE[iter_12_0] or not Unit.has_animation_state_machine(iter_12_0) then
			arg_12_0:_remove_networked_variables(iter_12_0)
		else
			local var_12_0 = iter_12_1.updates

			for iter_12_2 = 1, #var_12_0 do
				local var_12_1 = var_12_0[iter_12_2]
				local var_12_2 = var_12_1.variable_name

				NetworkedAnimationVariableTemplates[var_12_2].update(iter_12_0, var_12_1, arg_12_1, arg_12_2)
			end
		end
	end
end

AnimationSystem.rpc_sync_anim_state = function (arg_13_0, arg_13_1, arg_13_2, ...)
	local var_13_0 = arg_13_0.unit_storage:unit(arg_13_2)

	Unit.animation_set_state(var_13_0, ...)
end

AnimationSystem.rpc_sync_anim_state_1 = AnimationSystem.rpc_sync_anim_state
AnimationSystem.rpc_sync_anim_state_2 = AnimationSystem.rpc_sync_anim_state
AnimationSystem.rpc_sync_anim_state_3 = AnimationSystem.rpc_sync_anim_state
AnimationSystem.rpc_sync_anim_state_4 = AnimationSystem.rpc_sync_anim_state
AnimationSystem.rpc_sync_anim_state_5 = AnimationSystem.rpc_sync_anim_state
AnimationSystem.rpc_sync_anim_state_6 = AnimationSystem.rpc_sync_anim_state
AnimationSystem.rpc_sync_anim_state_7 = AnimationSystem.rpc_sync_anim_state
AnimationSystem.rpc_sync_anim_state_8 = AnimationSystem.rpc_sync_anim_state
AnimationSystem.rpc_sync_anim_state_9 = AnimationSystem.rpc_sync_anim_state
AnimationSystem.rpc_sync_anim_state_10 = AnimationSystem.rpc_sync_anim_state
AnimationSystem.rpc_sync_anim_state_11 = AnimationSystem.rpc_sync_anim_state
AnimationSystem.rpc_sync_anim_state_12 = AnimationSystem.rpc_sync_anim_state

AnimationSystem.rpc_anim_event_variable_float = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	local var_14_0 = arg_14_0.unit_storage:unit(arg_14_3)

	if not var_14_0 or not Unit.alive(var_14_0) then
		return
	end

	if arg_14_0.is_server then
		local var_14_1 = CHANNEL_TO_PEER_ID[arg_14_1]

		arg_14_0.network_transmit:send_rpc_clients_except("rpc_anim_event_variable_float", var_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	end

	if Unit.has_animation_state_machine(var_14_0) then
		local var_14_2 = NetworkLookup.anims[arg_14_2]

		assert(var_14_2, "[GameNetworkManager] Lookup missing for event_id", arg_14_2)

		local var_14_3 = NetworkLookup.anims[arg_14_4]

		arg_14_0:anim_event_with_variable_float(var_14_0, var_14_2, var_14_3, arg_14_5, true)
	end
end

AnimationSystem.rpc_anim_set_variable_float = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	local var_15_0 = arg_15_0.unit_storage:unit(arg_15_2)

	if not var_15_0 or not Unit.alive(var_15_0) then
		return
	end

	if arg_15_0.is_server then
		local var_15_1 = CHANNEL_TO_PEER_ID[arg_15_1]

		arg_15_0.network_transmit:send_rpc_clients_except("rpc_anim_set_variable_float", var_15_1, arg_15_2, arg_15_3, arg_15_4)
	end

	if Unit.has_animation_state_machine(var_15_0) then
		local var_15_2 = NetworkLookup.anims[arg_15_3]
		local var_15_3 = Unit.animation_find_variable(var_15_0, var_15_2)

		Unit.animation_set_variable(var_15_0, var_15_3, arg_15_4)
	end
end

AnimationSystem.rpc_anim_set_variable_int = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	local var_16_0 = arg_16_0.unit_storage:unit(arg_16_2)

	if not var_16_0 or not Unit.alive(var_16_0) then
		return
	end

	if arg_16_0.is_server then
		local var_16_1 = CHANNEL_TO_PEER_ID[arg_16_1]

		arg_16_0.network_transmit:send_rpc_clients_except("rpc_anim_set_variable_int", var_16_1, arg_16_2, arg_16_3, arg_16_4)
	end

	if Unit.has_animation_state_machine(var_16_0) then
		local var_16_2 = NetworkLookup.anims[arg_16_3]
		local var_16_3 = Unit.animation_find_variable(var_16_0, var_16_2)

		Unit.animation_set_variable(var_16_0, var_16_3, arg_16_4)
	end
end

AnimationSystem.rpc_anim_event = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	local var_17_0 = arg_17_0.unit_storage:unit(arg_17_3)

	if not var_17_0 or not Unit.alive(var_17_0) then
		return
	end

	if arg_17_0.is_server then
		local var_17_1 = CHANNEL_TO_PEER_ID[arg_17_1]

		arg_17_0.network_transmit:send_rpc_clients_except("rpc_anim_event", var_17_1, arg_17_2, arg_17_3)
	end

	if Unit.has_animation_state_machine(var_17_0) then
		local var_17_2 = NetworkLookup.anims[arg_17_2]

		assert(var_17_2, "[GameNetworkManager] Lookup missing for event_id", arg_17_2)
		arg_17_0:anim_event(var_17_0, var_17_2, true)
	end
end

AnimationSystem.rpc_link_unit = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
	local var_18_0 = arg_18_0.unit_storage:unit(arg_18_2)
	local var_18_1 = arg_18_0.unit_storage:unit(arg_18_4)
	local var_18_2 = Unit.world(var_18_1)

	World.link_unit(var_18_2, var_18_0, arg_18_3, var_18_1, arg_18_5)
end

AnimationSystem.rpc_anim_set_variable_by_distance = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6)
	local var_19_0 = arg_19_0.unit_storage:unit(arg_19_2)

	arg_19_0:_set_variable_by_distance(var_19_0, arg_19_3, arg_19_4, arg_19_5, arg_19_6)
end

AnimationSystem._set_variable_by_distance = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	local var_20_0 = arg_20_3 - var_0_0[arg_20_1]

	if arg_20_5 then
		var_20_0 = Vector3.flat(var_20_0)
	end

	local var_20_1 = Vector3.length(var_20_0)

	if var_20_1 < 0.001 then
		var_20_1 = 0.001
	end

	local var_20_2 = arg_20_0.anim_variable_update_list[arg_20_1]

	if var_20_2 then
		var_20_2.goal_pos = Vector3Box(arg_20_3)
		var_20_2.initial_distance = var_20_1
		var_20_2.scale = arg_20_4
		var_20_2.anim_variable_index = arg_20_2
	else
		arg_20_0.anim_variable_update_list[arg_20_1] = {
			unit = arg_20_1,
			goal_pos = Vector3Box(arg_20_3),
			anim_variable_index = arg_20_2,
			initial_distance = var_20_1,
			scale = arg_20_4,
			flat_distance = arg_20_5
		}
	end
end

AnimationSystem.rpc_anim_set_variable_by_time = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
	local var_21_0 = arg_21_0.unit_storage:unit(arg_21_2)
	local var_21_1 = arg_21_4 * 0.00390625

	arg_21_0:_set_variable_by_time(var_21_0, arg_21_3, var_21_1, arg_21_5)
end

AnimationSystem._set_variable_by_time = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	local var_22_0 = arg_22_0.anim_variable_update_list[arg_22_1]
	local var_22_1 = Managers.time:time("game")

	if var_22_0 then
		var_22_0.start_time = var_22_1
		var_22_0.duration = arg_22_3
		var_22_0.scale = arg_22_4
		var_22_0.anim_variable_index = arg_22_2
	else
		arg_22_0.anim_variable_update_list[arg_22_1] = {
			unit = arg_22_1,
			start_time = var_22_1,
			duration = arg_22_3,
			anim_variable_index = arg_22_2,
			scale = arg_22_4
		}
	end
end

AnimationSystem.rpc_update_anim_variable_done = function (arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = arg_23_0.unit_storage:unit(arg_23_2)

	if arg_23_0.anim_variable_update_list[var_23_0] then
		arg_23_0.anim_variable_update_list[var_23_0] = nil
	end
end

AnimationSystem.set_update_anim_variable_done = function (arg_24_0, arg_24_1)
	local var_24_0 = Managers.state.network:unit_game_object_id(arg_24_1)

	arg_24_0.network_transmit:send_rpc_clients("rpc_update_anim_variable_done", var_24_0)

	arg_24_0.anim_variable_update_list[arg_24_1] = nil
end

AnimationSystem.start_anim_variable_update_by_distance = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5)
	local var_25_0 = Managers.state.network:unit_game_object_id(arg_25_1)

	arg_25_0.network_transmit:send_rpc_clients("rpc_anim_set_variable_by_distance", var_25_0, arg_25_2, arg_25_3, arg_25_4, arg_25_5)
	arg_25_0:_set_variable_by_distance(arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5)
end

AnimationSystem.start_anim_variable_update_by_time = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	local var_26_0 = math.clamp(arg_26_3 * 256, 0, 65535)
	local var_26_1 = Managers.state.network:unit_game_object_id(arg_26_1)

	arg_26_0.network_transmit:send_rpc_clients("rpc_anim_set_variable_by_time", var_26_1, arg_26_2, var_26_0, arg_26_4)
	arg_26_0:_set_variable_by_time(arg_26_1, arg_26_2, arg_26_3, arg_26_4)
end

AnimationSystem.add_safe_animation_callback = function (arg_27_0, arg_27_1)
	arg_27_0._animation_safe_callbacks[#arg_27_0._animation_safe_callbacks + 1] = arg_27_1
end

AnimationSystem.run_safe_animation_callbacks = function (arg_28_0)
	local var_28_0 = arg_28_0._animation_safe_callbacks

	arg_28_0._animation_safe_callbacks = arg_28_0._animation_safe_callbacks == arg_28_0._animation_safe_callbacks_buffer_1 and arg_28_0._animation_safe_callbacks_buffer_2 or arg_28_0._animation_safe_callbacks_buffer_1

	for iter_28_0 = 1, #var_28_0 do
		var_28_0[iter_28_0]()

		var_28_0[iter_28_0] = nil
	end
end
