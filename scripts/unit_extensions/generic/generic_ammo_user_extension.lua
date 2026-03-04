-- chunkname: @scripts/unit_extensions/generic/generic_ammo_user_extension.lua

script_data.infinite_ammo = script_data.infinite_ammo or Development.parameter("infinite_ammo")
GenericAmmoUserExtension = class(GenericAmmoUserExtension)

GenericAmmoUserExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.unit = arg_1_2
	arg_1_0.owner_unit = arg_1_3.owner_unit
	arg_1_0.item_name = arg_1_3.item_name
	arg_1_0._is_server = Managers.player.is_server

	local var_1_0 = arg_1_3.ammo_percent or 1
	local var_1_1 = arg_1_3.ammo_data

	arg_1_0._reload_time = var_1_1.reload_time
	arg_1_0._override_reload_time = nil
	arg_1_0._override_reload_anim = nil
	arg_1_0._single_clip = var_1_1.single_clip
	arg_1_0._infinite_ammo = var_1_1.infinite_ammo

	if var_1_1.infinite_ammo then
		var_1_0 = 1
	end

	arg_1_0._max_ammo = var_1_1.max_ammo
	arg_1_0._start_ammo = math.round(var_1_0 * arg_1_0._max_ammo)
	arg_1_0._ammo_per_clip = var_1_1.ammo_per_clip or arg_1_0._max_ammo
	arg_1_0._ammo_per_reload = var_1_1.ammo_per_reload
	arg_1_0._starting_loaded_ammo = var_1_1.starting_loaded_ammo
	arg_1_0._current_ammo = var_1_1.starting_loaded_ammo or 0
	arg_1_0._starting_reserve_ammo = var_1_1.starting_reserve_ammo
	arg_1_0._original_max_ammo = arg_1_0._max_ammo
	arg_1_0._original_ammo_percent = var_1_0
	arg_1_0._original_ammo_per_clip = arg_1_0._ammo_per_clip
	arg_1_0._ammo_immediately_available = var_1_1.ammo_immediately_available or false
	arg_1_0._reload_on_ammo_pickup = var_1_1.reload_on_ammo_pickup or false
	arg_1_0._play_reload_anim_on_wield_reload = var_1_1.play_reload_anim_on_wield_reload
	arg_1_0._has_wield_reload_anim = var_1_1.has_wield_reload_anim
	arg_1_0._destroy_when_out_of_ammo = var_1_1.destroy_when_out_of_ammo
	arg_1_0._unwield_when_out_of_ammo = var_1_1.unwield_when_out_of_ammo

	if var_1_1.force_wield_previous_weapon_when_ammo_given ~= nil then
		arg_1_0._force_wield_previous_weapon_when_ammo_given = var_1_1.force_wield_previous_weapon_when_ammo_given
	else
		arg_1_0._force_wield_previous_weapon_when_ammo_given = false
	end

	if var_1_1.wield_previous_weapon_when_destroyed ~= nil then
		arg_1_0._wield_previous_weapon_when_destroyed = var_1_1.wield_previous_weapon_when_destroyed
	else
		arg_1_0._wield_previous_weapon_when_destroyed = true
	end

	arg_1_0._ammo_type = var_1_1.ammo_type or "default"
	arg_1_0._ammo_kind = var_1_1.ammo_kind or "default"
	arg_1_0._block_ammo_pickup = var_1_1.block_ammo_pickup or false
	arg_1_0._play_reload_animation = true
	arg_1_0._reload_event = arg_1_3.reload_event
	arg_1_0.pickup_reload_event_1p = arg_1_3.pickup_reload_event_1p
	arg_1_0._last_reload_event = arg_1_3.last_reload_event or arg_1_0._reload_event
	arg_1_0._no_ammo_reload_event = arg_1_3.no_ammo_reload_event
	arg_1_0.slot_name = arg_1_3.slot_name

	local var_1_2 = ScriptUnit.has_extension(arg_1_0.owner_unit, "first_person_system")

	if var_1_2 then
		arg_1_0.first_person_extension = var_1_2
		arg_1_0.first_person_unit = var_1_2:get_first_person_unit()

		if var_1_1.should_update_anim_ammo then
			arg_1_0._should_update_anim_ammo = true

			assert(arg_1_0.first_person_unit)
		end
	end
end

GenericAmmoUserExtension.extensions_ready = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_0:apply_buffs()
	arg_2_0:_update_anim_ammo()
end

GenericAmmoUserExtension.apply_buffs = function (arg_3_0)
	if arg_3_0.slot_name == "slot_ranged" or arg_3_0.slot_name == "slot_career_skill_weapon" then
		arg_3_0:_apply_buffs()
	end

	arg_3_0:reset()
end

GenericAmmoUserExtension._apply_buffs = function (arg_4_0)
	local var_4_0 = ScriptUnit.extension(arg_4_0.owner_unit, "buff_system")

	arg_4_0.owner_buff_extension = var_4_0
	arg_4_0._ammo_per_clip = math.ceil(var_4_0:apply_buffs_to_value(arg_4_0._original_ammo_per_clip, "clip_size"))
	arg_4_0._max_ammo = math.ceil(var_4_0:apply_buffs_to_value(arg_4_0._original_max_ammo, "total_ammo"))
	arg_4_0._start_ammo = math.round(arg_4_0._original_ammo_percent * arg_4_0._max_ammo)
end

GenericAmmoUserExtension.refresh_buffs = function (arg_5_0)
	local var_5_0 = arg_5_0:total_ammo_fraction()

	arg_5_0:_apply_buffs()

	local var_5_1 = arg_5_0._start_ammo - arg_5_0._current_ammo
	local var_5_2 = arg_5_0._available_ammo or math.huge

	arg_5_0._available_ammo = math.min(var_5_1, var_5_2)

	if var_5_0 == 1 then
		arg_5_0:reset()
	end
end

GenericAmmoUserExtension.destroy = function (arg_6_0)
	return
end

GenericAmmoUserExtension.reset = function (arg_7_0)
	local var_7_0 = arg_7_0._initialized and arg_7_0:total_remaining_ammo() == 0
	local var_7_1 = arg_7_0._starting_loaded_ammo or arg_7_0._start_ammo

	if arg_7_0._ammo_immediately_available then
		arg_7_0._current_ammo = var_7_1
	else
		arg_7_0._current_ammo = math.min(arg_7_0._ammo_per_clip, var_7_1)
	end

	arg_7_0._available_ammo = arg_7_0._starting_reserve_ammo or arg_7_0._start_ammo - arg_7_0._current_ammo
	arg_7_0._shots_fired = 0

	arg_7_0:_update_anim_ammo()

	if var_7_0 then
		local var_7_2 = ScriptUnit.has_extension(arg_7_0.owner_unit, "inventory_system")

		if var_7_2 and arg_7_0.slot_name == var_7_2:get_wielded_slot_name() then
			arg_7_0:instant_reload(true, arg_7_0._no_ammo_reload_event)
		end
	end

	arg_7_0._initialized = true
end

GenericAmmoUserExtension.update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	local var_8_0 = Managers.player:owner(arg_8_0.owner_unit)

	if arg_8_0._queued_reload then
		if arg_8_0:can_reload() then
			arg_8_0:start_reload(true)
		end

		arg_8_0._queued_reload = false
	end

	arg_8_0:_check_ammo()

	if arg_8_0._next_reload_time and arg_8_5 > arg_8_0._next_reload_time then
		if not arg_8_0._start_reloading then
			local var_8_1 = arg_8_0.owner_buff_extension
			local var_8_2 = arg_8_0._ammo_per_clip - arg_8_0._current_ammo
			local var_8_3 = arg_8_0._ammo_per_reload and var_8_2 >= arg_8_0._ammo_per_reload and arg_8_0._ammo_per_reload or var_8_2
			local var_8_4 = math.min(var_8_3, arg_8_0._available_ammo)

			arg_8_0._current_ammo = arg_8_0._current_ammo + var_8_4

			if var_8_1 then
				local var_8_5 = var_8_1:has_buff_type("no_ammo_consumed")
				local var_8_6 = var_8_1:has_buff_type("markus_huntsman_activated_ability") or var_8_1:has_buff_type("markus_huntsman_activated_ability_duration")
				local var_8_7 = var_8_1:has_buff_type("twitch_no_overcharge_no_ammo_reloads")

				if not var_8_5 and not var_8_6 and not var_8_7 then
					arg_8_0._available_ammo = arg_8_0._available_ammo - var_8_4
				end

				var_8_1:trigger_procs("on_reload")
				arg_8_0:_update_anim_ammo()
			end

			if not LEVEL_EDITOR_TEST and not arg_8_0._is_server then
				local var_8_8 = var_8_0:network_id()
				local var_8_9 = var_8_0:local_player_id()
				local var_8_10 = NetworkLookup.proc_events.on_reload

				Managers.state.network.network_transmit:send_rpc_server("rpc_proc_event", var_8_8, var_8_9, var_8_10)
			end
		end

		arg_8_0._start_reloading = nil

		if arg_8_0._ammo_per_clip - arg_8_0._current_ammo > 0 and arg_8_0._available_ammo > 0 then
			local var_8_11 = arg_8_0._override_reload_time or arg_8_0._reload_time

			arg_8_0._override_reload_time = nil

			local var_8_12 = var_8_11

			if arg_8_0.owner_buff_extension then
				var_8_11 = arg_8_0.owner_buff_extension:apply_buffs_to_value(var_8_11, "reload_speed")
			end

			arg_8_0._next_reload_time = arg_8_5 + var_8_11

			if arg_8_0._play_reload_animation then
				Unit.set_flow_variable(arg_8_0.unit, "wwise_reload_speed", var_8_12 / var_8_11)
				arg_8_0:start_reload_animation(var_8_11)

				if not var_8_0.bot_player then
					Managers.state.controller_features:add_effect("rumble", {
						rumble_effect = "reload_start"
					})
				end
			end
		else
			arg_8_0._next_reload_time = nil

			if not var_8_0.bot_player then
				Managers.state.controller_features:add_effect("rumble", {
					rumble_effect = "reload_over"
				})
			end
		end
	end
end

GenericAmmoUserExtension._check_ammo = function (arg_9_0)
	if arg_9_0._shots_fired > 0 then
		arg_9_0._current_ammo = arg_9_0._current_ammo - arg_9_0._shots_fired
		arg_9_0._shots_fired = 0

		fassert(arg_9_0._current_ammo >= 0)

		if arg_9_0._current_ammo == 0 then
			local var_9_0 = arg_9_0.unit
			local var_9_1 = arg_9_0.owner_unit
			local var_9_2 = Managers.player:owner(arg_9_0.owner_unit)
			local var_9_3 = arg_9_0.owner_buff_extension

			if not var_9_2 or not var_9_2.bot_player then
				Unit.flow_event(var_9_0, "used_last_ammo_clip")

				if var_9_3 then
					var_9_3:trigger_procs("on_ammo_clip_used")
				end
			end

			if arg_9_0._available_ammo == 0 then
				if arg_9_0._destroy_when_out_of_ammo then
					local var_9_4 = ScriptUnit.extension(var_9_1, "inventory_system")
					local var_9_5 = ScriptUnit.has_extension(var_9_1, "status_system")

					var_9_4:destroy_item_by_name(arg_9_0.slot_name, arg_9_0.item_name, false, true)

					if (arg_9_0._last_ammo_used_was_given and arg_9_0._force_wield_previous_weapon_when_ammo_given or arg_9_0._wield_previous_weapon_when_destroyed) and not (var_9_5 and CharacterStateHelper.pack_master_status(var_9_5)) and var_9_4:get_wielded_slot_name() == arg_9_0.slot_name then
						var_9_4:wield_previous_weapon()
					end
				elseif arg_9_0._unwield_when_out_of_ammo then
					ScriptUnit.extension(var_9_1, "inventory_system"):wield_previous_weapon()
				else
					local var_9_6 = Managers.player:unit_owner(var_9_1)
					local var_9_7 = arg_9_0.item_name
					local var_9_8 = POSITION_LOOKUP[var_9_1]

					Managers.telemetry_events:player_ammo_depleted(var_9_6, var_9_7, var_9_8)
				end

				Unit.flow_event(var_9_0, "used_last_ammo")
			end
		end
	end
end

GenericAmmoUserExtension.start_reload_animation = function (arg_10_0, arg_10_1)
	if arg_10_0.pickup_reload_event_1p then
		local var_10_0 = arg_10_0.pickup_reload_event_1p

		if arg_10_0.first_person_extension then
			arg_10_0.first_person_extension:animation_event(var_10_0)
		end
	end

	local var_10_1 = arg_10_0._reload_event
	local var_10_2 = arg_10_0._ammo_per_clip - arg_10_0._current_ammo

	if arg_10_0.reloaded_from_zero_ammo then
		arg_10_0.reloaded_from_zero_ammo = nil

		if arg_10_0._no_ammo_reload_event then
			var_10_1 = arg_10_0._no_ammo_reload_event
		end
	elseif var_10_2 == 1 or arg_10_0._available_ammo == 1 then
		var_10_1 = arg_10_0._last_reload_event
	end

	var_10_1 = arg_10_0._override_reload_anim or var_10_1
	arg_10_0._override_reload_anim = nil

	if var_10_1 then
		if arg_10_0.first_person_extension then
			local var_10_3 = arg_10_0.first_person_extension

			var_10_3:animation_set_variable("reload_time", arg_10_1)
			var_10_3:animation_event(var_10_1)
		end

		local var_10_4 = Managers.state.unit_storage:go_id(arg_10_0.owner_unit)
		local var_10_5 = NetworkLookup.anims[var_10_1]

		if not LEVEL_EDITOR_TEST then
			if arg_10_0._is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_anim_event", var_10_5, var_10_4)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_anim_event", var_10_5, var_10_4)
			end
		end
	end
end

GenericAmmoUserExtension.remove_ammo = function (arg_11_0, arg_11_1)
	if arg_11_0._available_ammo == 0 and arg_11_0._current_ammo == 0 then
		return
	end

	arg_11_0._available_ammo = math.floor(math.clamp(arg_11_0._available_ammo - arg_11_1, 0, arg_11_0._max_ammo))
end

GenericAmmoUserExtension.add_ammo = function (arg_12_0, arg_12_1)
	if arg_12_0._destroy_when_out_of_ammo then
		return
	end

	if arg_12_0._available_ammo == 0 and arg_12_0._current_ammo == 0 then
		arg_12_0.reloaded_from_zero_ammo = true

		local var_12_0 = Managers.player:unit_owner(arg_12_0.owner_unit)
		local var_12_1 = arg_12_0.item_name
		local var_12_2 = POSITION_LOOKUP[arg_12_0.owner_unit]

		Managers.telemetry_events:player_ammo_refilled(var_12_0, var_12_1, var_12_2)

		local var_12_3 = arg_12_0.owner_buff_extension

		if var_12_3 then
			var_12_3:trigger_procs("on_gained_ammo_from_no_ammo")

			if not LEVEL_EDITOR_TEST and not arg_12_0._is_server then
				local var_12_4 = Managers.player:owner(arg_12_0.owner_unit)
				local var_12_5 = var_12_4:network_id()
				local var_12_6 = var_12_4:local_player_id()
				local var_12_7 = NetworkLookup.proc_events.on_gained_ammo_from_no_ammo

				Managers.state.network.network_transmit:send_rpc_server("rpc_proc_event", var_12_5, var_12_6, var_12_7)
			end
		end
	end

	local var_12_8

	if arg_12_1 and arg_12_0._ammo_immediately_available then
		arg_12_0._current_ammo = math.floor(math.clamp(arg_12_0._current_ammo + arg_12_1, 0, arg_12_0._max_ammo))
	elseif arg_12_1 then
		arg_12_0._available_ammo = math.floor(math.clamp(arg_12_0._available_ammo + arg_12_1, 0, arg_12_0._max_ammo - (arg_12_0._current_ammo - arg_12_0._shots_fired)))
	elseif arg_12_0._ammo_immediately_available then
		arg_12_0._current_ammo = arg_12_0._max_ammo
	else
		arg_12_0._available_ammo = arg_12_0._max_ammo - (arg_12_0._current_ammo - arg_12_0._shots_fired)
	end

	arg_12_0:_update_anim_ammo()
end

GenericAmmoUserExtension.add_ammo_to_reserve = function (arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0._available_ammo

	if arg_13_0._ammo_immediately_available then
		arg_13_0._current_ammo = math.min(arg_13_0._max_ammo, arg_13_0._current_ammo + arg_13_1)
	else
		local var_13_1 = arg_13_0:ammo_count()

		arg_13_0._available_ammo = math.min(arg_13_0._max_ammo - var_13_1, arg_13_0._available_ammo + arg_13_1)
	end

	arg_13_0.owner_buff_extension:trigger_procs("on_gained_ammo_from_no_ammo")

	if not LEVEL_EDITOR_TEST and not arg_13_0._is_server then
		local var_13_2 = Managers.player:owner(arg_13_0.owner_unit)
		local var_13_3 = var_13_2:network_id()
		local var_13_4 = var_13_2:local_player_id()
		local var_13_5 = NetworkLookup.proc_events.on_gained_ammo_from_no_ammo

		Managers.state.network.network_transmit:send_rpc_server("rpc_proc_event", var_13_3, var_13_4, var_13_5)
	end

	if var_13_0 == 0 and arg_13_0._current_ammo == 0 and arg_13_0:can_reload() then
		arg_13_0._queued_reload = true
	end

	arg_13_0:_update_anim_ammo()
end

GenericAmmoUserExtension.use_ammo = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = arg_14_0.owner_buff_extension
	local var_14_1 = false

	if var_14_0 then
		local var_14_2 = math.round(arg_14_1 * var_14_0:apply_buffs_to_value(1, "ammo_used_multiplier")) - arg_14_1

		if arg_14_1 + var_14_2 > arg_14_0:ammo_count() then
			local var_14_3 = arg_14_1 + var_14_2 - arg_14_0:ammo_count()

			var_14_2 = var_14_2 - var_14_3

			arg_14_0:remove_ammo(math.min(var_14_3), arg_14_0:remaining_ammo())
		end

		arg_14_1 = arg_14_1 + var_14_2
		var_14_1 = var_14_0:has_buff_perk("infinite_ammo")
	end

	if (var_14_1 or arg_14_0._infinite_ammo) and arg_14_0.slot_name == "slot_ranged" then
		arg_14_1 = 0
	end

	if script_data.infinite_ammo then
		arg_14_1 = 0
	end

	arg_14_0._shots_fired = arg_14_0._shots_fired + arg_14_1

	if var_14_0 then
		var_14_0:trigger_procs("on_ammo_used", arg_14_0, arg_14_1)
		Managers.state.achievement:trigger_event("ammo_used", arg_14_0.owner_unit)

		if arg_14_0:total_remaining_ammo() == 0 then
			var_14_0:trigger_procs("on_last_ammo_used")
		end

		if not LEVEL_EDITOR_TEST and not arg_14_0._is_server then
			local var_14_4 = Managers.player:owner(arg_14_0.owner_unit)
			local var_14_5 = var_14_4:network_id()
			local var_14_6 = var_14_4:local_player_id()
			local var_14_7 = NetworkLookup.proc_events.on_ammo_used

			Managers.state.network.network_transmit:send_rpc_server("rpc_proc_event", var_14_5, var_14_6, var_14_7)

			if arg_14_0:total_remaining_ammo() == 0 then
				local var_14_8 = NetworkLookup.proc_events.on_last_ammo_used

				Managers.state.network.network_transmit:send_rpc_server("rpc_proc_event", var_14_5, var_14_6, var_14_8)
			end
		end
	end

	arg_14_0:_update_anim_ammo()

	arg_14_0._last_ammo_used_was_given = arg_14_2

	fassert(arg_14_0:ammo_count() >= 0, "ammo went below 0")

	if arg_14_3 then
		arg_14_0:_check_ammo()
	end
end

GenericAmmoUserExtension.start_reload = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	fassert(arg_15_0:can_reload(), "Tried to start reloading without being able to reload")
	fassert(arg_15_0._next_reload_time == nil, "next_reload_time is nil")

	arg_15_0._override_reload_time = arg_15_2
	arg_15_0._start_reloading = true
	arg_15_0._next_reload_time = 0
	arg_15_0._play_reload_animation = arg_15_1
	arg_15_0._override_reload_anim = arg_15_3

	local var_15_0 = ScriptUnit.extension_input(arg_15_0.owner_unit, "dialogue_system")
	local var_15_1 = FrameTable.alloc_table()

	var_15_1.item_name = arg_15_0.item_name or "UNKNOWN ITEM"

	local var_15_2 = "reload_started"

	var_15_0:trigger_dialogue_event(var_15_2, var_15_1)
end

GenericAmmoUserExtension.abort_reload = function (arg_16_0)
	fassert(arg_16_0:is_reloading(), "Tried to abort reload while reloading")

	arg_16_0._start_reloading = nil
	arg_16_0._next_reload_time = nil

	Unit.flow_event(arg_16_0.unit, "stop_reload_sound")

	if arg_16_0.first_person_extension then
		arg_16_0.first_person_extension:show_first_person_ammo(false)
	end
end

GenericAmmoUserExtension.ammo_count = function (arg_17_0)
	return arg_17_0._current_ammo - arg_17_0._shots_fired
end

GenericAmmoUserExtension.clip_size = function (arg_18_0)
	return arg_18_0._ammo_per_clip
end

GenericAmmoUserExtension.clip_full = function (arg_19_0)
	return arg_19_0:ammo_count() == arg_19_0._ammo_per_clip
end

GenericAmmoUserExtension.remaining_ammo = function (arg_20_0)
	return arg_20_0._available_ammo
end

GenericAmmoUserExtension.ammo_available_immediately = function (arg_21_0)
	return arg_21_0._ammo_immediately_available
end

GenericAmmoUserExtension.can_reload = function (arg_22_0)
	if arg_22_0:is_reloading() then
		return false
	end

	if arg_22_0:clip_full() then
		return false
	end

	if arg_22_0._infinite_ammo or script_data.infinite_ammo then
		return true
	end

	return arg_22_0._available_ammo > 0
end

GenericAmmoUserExtension.total_remaining_ammo = function (arg_23_0)
	return arg_23_0:remaining_ammo() + arg_23_0:ammo_count()
end

GenericAmmoUserExtension.total_ammo_fraction = function (arg_24_0)
	return (arg_24_0:remaining_ammo() + arg_24_0:ammo_count()) / arg_24_0:max_ammo()
end

GenericAmmoUserExtension.max_ammo = function (arg_25_0)
	return arg_25_0._max_ammo
end

GenericAmmoUserExtension.current_ammo = function (arg_26_0)
	return arg_26_0._current_ammo
end

GenericAmmoUserExtension.is_reloading = function (arg_27_0)
	return arg_27_0._next_reload_time ~= nil
end

GenericAmmoUserExtension.full_ammo = function (arg_28_0)
	return arg_28_0:remaining_ammo() + arg_28_0:ammo_count() == arg_28_0:max_ammo()
end

GenericAmmoUserExtension.using_single_clip = function (arg_29_0)
	return arg_29_0._single_clip
end

GenericAmmoUserExtension.reload_on_ammo_pickup = function (arg_30_0)
	return arg_30_0._reload_on_ammo_pickup
end

GenericAmmoUserExtension.play_reload_anim_on_wield_reload = function (arg_31_0)
	return arg_31_0._play_reload_anim_on_wield_reload
end

GenericAmmoUserExtension.has_wield_reload_anim = function (arg_32_0)
	return arg_32_0._has_wield_reload_anim
end

GenericAmmoUserExtension.ammo_type = function (arg_33_0)
	return arg_33_0._ammo_type
end

GenericAmmoUserExtension.infinite_ammo = function (arg_34_0)
	return arg_34_0._infinite_ammo or script_data.infinite_ammo
end

GenericAmmoUserExtension.ammo_kind = function (arg_35_0)
	return arg_35_0._ammo_kind
end

GenericAmmoUserExtension.ammo_blocked = function (arg_36_0)
	return arg_36_0._block_ammo_pickup
end

GenericAmmoUserExtension.add_ammo_to_clip = function (arg_37_0, arg_37_1)
	arg_37_0._current_ammo = arg_37_0._current_ammo + arg_37_1

	arg_37_0:_update_anim_ammo()
end

GenericAmmoUserExtension.instant_reload = function (arg_38_0, arg_38_1, arg_38_2)
	if not arg_38_1 then
		local var_38_0 = arg_38_0._ammo_per_clip - arg_38_0._current_ammo
		local var_38_1 = math.min(var_38_0, arg_38_0._available_ammo)

		arg_38_0._current_ammo = arg_38_0._current_ammo + var_38_1
		arg_38_0._available_ammo = arg_38_0._available_ammo - var_38_1
		arg_38_0._shots_fired = 0
	else
		arg_38_0._current_ammo = arg_38_0._ammo_per_clip
		arg_38_0._shots_fired = 0
	end

	if arg_38_2 then
		if arg_38_0.first_person_extension then
			local var_38_2 = arg_38_0.first_person_extension

			var_38_2:animation_set_variable("reload_time", math.huge)
			var_38_2:animation_event(arg_38_2)
		end

		if not LEVEL_EDITOR_TEST then
			local var_38_3 = Managers.state.unit_storage:go_id(arg_38_0.owner_unit)
			local var_38_4 = NetworkLookup.anims[arg_38_2]

			if arg_38_0.is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_anim_event", var_38_4, var_38_3)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_anim_event", var_38_4, var_38_3)
			end
		end
	end

	arg_38_0:_update_anim_ammo()
end

GenericAmmoUserExtension._update_anim_ammo = function (arg_39_0)
	if not arg_39_0._should_update_anim_ammo then
		return
	end

	local var_39_0 = arg_39_0._current_ammo - arg_39_0._shots_fired

	arg_39_0.first_person_extension:animation_set_variable("ammo_count", var_39_0, true)
end
