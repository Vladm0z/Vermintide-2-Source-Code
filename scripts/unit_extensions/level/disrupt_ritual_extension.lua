-- chunkname: @scripts/unit_extensions/level/disrupt_ritual_extension.lua

DisruptRitualExtension = class(DisruptRitualExtension)

local var_0_0 = {
	"rpc_client_disrupt_ritual_update"
}

function DisruptRitualExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._network_transmit = arg_1_1.network_transmit
	arg_1_0._network_event_delegate = arg_1_1.network_transmit.network_event_delegate

	arg_1_0._network_event_delegate:register(arg_1_0, unpack(var_0_0))

	arg_1_0._event_manager = Managers.state.event

	Managers.state.event:register(arg_1_0, "start_disrupt_ritual", "start_disrupt_ritual")
	Managers.state.event:register(arg_1_0, "player_party_changed", "player_party_changed")

	arg_1_0._volume_system = Managers.state.entity:system("volume_system")
	arg_1_0._tutorial_system = Managers.state.entity:system("tutorial_system")
	arg_1_0._ritual_system = Managers.state.entity:system("disrupt_ritual_system")
	arg_1_0._health_extension = ScriptUnit.extension(arg_1_2, "health_system")
	arg_1_0._level = LevelHelper:current_level(arg_1_1.world)
	arg_1_0._is_server = arg_1_1.is_server
	arg_1_0._unit = arg_1_2
	arg_1_0._next_tick = 0
end

function DisruptRitualExtension.start_disrupt_ritual(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	if arg_2_1 ~= arg_2_0._unit then
		return
	end

	arg_2_0._active = true
	arg_2_0._volume_name = arg_2_2

	local var_2_0 = Unit.get_data(arg_2_0._unit, "health")

	arg_2_0._max_damage = var_2_0

	arg_2_0._health_extension:set_current_damage(arg_2_0._max_damage)

	arg_2_0._current_damage = 0

	arg_2_0._event_manager:trigger("tutorial_event_show_health_bar", arg_2_0._unit, true)

	if not arg_2_0._is_server then
		return
	end

	arg_2_3 = arg_2_3 or "any_alive_players_inside"

	if arg_2_3 == "all_alive_players_inside" then
		arg_2_0._condition_func = arg_2_0._volume_system.all_alive_human_players_inside
		arg_2_3 = "all_alive_players_inside"
	elseif arg_2_3 == "any_alive_players_inside" then
		arg_2_0._condition_func = arg_2_0._volume_system.any_alive_human_players_inside
		arg_2_3 = "players_inside"
	else
		fassert(false, "disrupt ritual has to be of type 'all_alive_players_inside' or 'any_alive_players_inside' ")
	end

	arg_2_0._tick_length = arg_2_5
	arg_2_0._num_progression_events = arg_2_4
	arg_2_0._damage_per_tick = arg_2_6
	arg_2_0._heal_per_tick = arg_2_7
	arg_2_0._active = true

	arg_2_0._volume_system:register_volume(arg_2_2, "trigger_volume", {
		sub_type = arg_2_3
	})

	local var_2_1 = {}

	for iter_2_0 = 0, 100 do
		local var_2_2 = Unit.get_data(arg_2_0._unit, "checkpoints", iter_2_0)

		if not var_2_2 then
			break
		end

		if var_2_2 ~= 0 then
			var_2_1[#var_2_1 + 1] = var_2_2
		end
	end

	arg_2_0._checkpoints = var_2_1
	arg_2_0._num_checkpoints = #var_2_1

	local var_2_3 = {
		[1] = 0,
		[arg_2_4] = var_2_0
	}
	local var_2_4 = var_2_0 / arg_2_4

	for iter_2_1 = 2, arg_2_4 - 1 do
		var_2_3[iter_2_1] = var_2_4 * iter_2_1
	end

	arg_2_0._progression_event_thresholds = var_2_3
	arg_2_0._num_progression_events = arg_2_4
end

function DisruptRitualExtension.update(arg_3_0, arg_3_1)
	if not arg_3_0._active or arg_3_1 < arg_3_0._next_tick then
		return
	end

	arg_3_0._next_tick = arg_3_1 + arg_3_0._tick_length

	local var_3_0 = arg_3_0._current_damage
	local var_3_1 = arg_3_0._checkpoints
	local var_3_2 = arg_3_0._current_checkpoint or 0
	local var_3_3 = arg_3_0._current_progression_event or 0

	if arg_3_0._condition_func(arg_3_0._volume_system, arg_3_0._volume_name) then
		arg_3_0:server_apply_damage(var_3_0, var_3_1, var_3_2, arg_3_0._num_checkpoints)
	else
		arg_3_0:server_heal(var_3_0, var_3_1, var_3_2)
	end

	local var_3_4 = arg_3_0._current_damage

	arg_3_0._health_extension:set_current_damage(arg_3_0._max_damage - var_3_4)
	arg_3_0:server_update_progression_status(arg_3_0._progression_event_thresholds, var_3_3, arg_3_0._num_progression_events, var_3_4)
	arg_3_0:print_damage(var_3_4)
	arg_3_0:server_send_rpc_update_clients(var_3_4, arg_3_0._current_checkpoint or 0, arg_3_0._current_progression_event, arg_3_0._volume_name)
end

function DisruptRitualExtension.server_heal(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	if arg_4_0._increasing_damage then
		arg_4_0:fire_flow_event("decreased", "damage")

		arg_4_0._increasing_damage = false
	end

	local var_4_0 = 0
	local var_4_1 = arg_4_1 - arg_4_0._heal_per_tick

	if arg_4_3 > 0 then
		var_4_0 = arg_4_2[arg_4_3]
	end

	if var_4_1 < var_4_0 then
		return
	end

	arg_4_0._current_damage = var_4_1
end

function DisruptRitualExtension.server_apply_damage(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if not arg_5_0._increasing_damage then
		arg_5_0:fire_flow_event("increased", "damage")

		arg_5_0._increasing_damage = true
	end

	arg_5_0._current_damage = arg_5_1 + arg_5_0._damage_per_tick

	if arg_5_0._current_damage >= arg_5_0._max_damage then
		arg_5_0._tutorial_system:flow_callback_show_health_bar(arg_5_0._unit, false)

		arg_5_0._active = false
	end

	if arg_5_3 == arg_5_4 then
		return
	end

	local var_5_0 = arg_5_3 + 1

	if arg_5_0._current_damage >= arg_5_2[var_5_0] then
		arg_5_0._current_checkpoint = var_5_0

		arg_5_0:fire_flow_event(var_5_0, "checkpoint")
		arg_5_0:print_checkpoint(var_5_0)
	end
end

function DisruptRitualExtension.server_update_progression_status(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = arg_6_1[arg_6_2 + 1]
	local var_6_1

	if var_6_0 then
		var_6_1 = var_6_0 <= arg_6_4
	end

	local var_6_2

	if var_6_1 then
		var_6_2 = arg_6_2 + 1
	end

	if not var_6_2 then
		return
	end

	arg_6_0._current_progression_event = var_6_2

	arg_6_0:fire_flow_event(var_6_2, "progression")
	arg_6_0:print_progression_event(var_6_2)
end

function DisruptRitualExtension.server_send_rpc_update_clients(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	arg_7_0._network_transmit:send_rpc_clients("rpc_client_disrupt_ritual_update", arg_7_1, arg_7_2, arg_7_3, arg_7_4)
end

function DisruptRitualExtension.rpc_client_disrupt_ritual_update(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	if not arg_8_0._active or arg_8_0._volume_name ~= arg_8_5 then
		return
	end

	if arg_8_2 > arg_8_0._current_damage and not arg_8_0._increasing_damage then
		arg_8_0:fire_flow_event("increased", "damage")

		arg_8_0._increasing_damage = true
	elseif arg_8_2 < arg_8_0._current_damage and arg_8_0._increasing_damage then
		arg_8_0:fire_flow_event("decreased", "damage")

		arg_8_0._increasing_damage = false
	end

	arg_8_0._current_damage = arg_8_2

	arg_8_0._health_extension:set_current_damage(arg_8_0._max_damage - arg_8_2)

	if arg_8_0._current_checkpoint ~= arg_8_3 and arg_8_3 ~= 0 then
		arg_8_0._current_checkpoint = arg_8_3

		arg_8_0:fire_flow_event(arg_8_3, "checkpoint")
		arg_8_0:print_checkpoint(arg_8_3)
	end

	if arg_8_0._current_progression_event ~= arg_8_4 then
		arg_8_0._current_progression_event = arg_8_4

		arg_8_0:fire_flow_event(arg_8_4, "progression")
		arg_8_0:print_progression_event(arg_8_4)
	end

	if arg_8_2 >= arg_8_0._max_damage then
		arg_8_0._event_manager:trigger("tutorial_event_show_health_bar", arg_8_0._unit, false)

		arg_8_0._active = false
	end
end

function DisruptRitualExtension.player_party_changed(arg_9_0)
	if arg_9_0._active then
		Unit.flow_event(arg_9_0._unit, "show_health_bar")
	end
end

function DisruptRitualExtension.fire_flow_event(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0._volume_name .. "_" .. arg_10_2 .. "_" .. arg_10_1

	Level.trigger_event(arg_10_0._level, var_10_0)
end

function DisruptRitualExtension.print_damage(arg_11_0, arg_11_1)
	print("Disrupt Ritual ", arg_11_0._volume_name, " current damage: ", arg_11_1)
end

function DisruptRitualExtension.print_progression_event(arg_12_0, arg_12_1)
	print(arg_12_0._volume_name, ": Disrupt Ritual progress updated. Current progression event: ", arg_12_1)
end

function DisruptRitualExtension.print_checkpoint(arg_13_0, arg_13_1)
	print(arg_13_0._volume_name, ": Disrupt Ritual checkpoint updated. Current checkpoint: ", arg_13_1)
end

function DisruptRitualExtension.destroy(arg_14_0)
	arg_14_0._network_event_delegate:unregister(arg_14_0)
end
