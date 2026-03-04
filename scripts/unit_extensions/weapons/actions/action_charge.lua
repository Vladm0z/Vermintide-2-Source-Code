-- chunkname: @scripts/unit_extensions/weapons/actions/action_charge.lua

ActionCharge = class(ActionCharge, ActionBase)

function ActionCharge.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionCharge.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	if ScriptUnit.has_extension(arg_1_4, "inventory_system") then
		local var_1_0 = ScriptUnit.extension(arg_1_0.owner_unit, "inventory_system")
		local var_1_1 = var_1_0:get_wielded_slot_name()

		arg_1_0.left_unit = var_1_0:get_slot_data(var_1_1).left_unit_1p
	end

	arg_1_0.status_extension = ScriptUnit.has_extension(arg_1_4, "status_system")
	arg_1_0.spread_extension = ScriptUnit.has_extension(arg_1_7, "spread_system")
	arg_1_0.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
	arg_1_0.first_person_extension = ScriptUnit.extension(arg_1_4, "first_person_system")
	arg_1_0.weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
	arg_1_0.ammo_extension = ScriptUnit.has_extension(arg_1_7, "ammo_system")
	arg_1_0._rumble_effect_id = nil
end

function ActionCharge.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2)
	ActionCharge.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2)

	local var_2_0 = arg_2_0.owner_unit

	arg_2_0.current_action = arg_2_1
	arg_2_0.audio_loop_id = arg_2_1.audio_loop_id or "charge"
	arg_2_0.charge_ready_sound_event = arg_2_0.current_action.charge_ready_sound_event
	arg_2_0.charge_flow_event_left_weapon = arg_2_1.charge_flow_event_left_weapon
	arg_2_0.venting_overcharge = nil
	arg_2_0._max_charge = false

	local var_2_1 = arg_2_0.overcharge_extension

	if arg_2_1.vent_overcharge and var_2_1 and var_2_1:get_overcharge_value() > 0 then
		var_2_1:vent_overcharge()

		arg_2_0.venting_overcharge = true
	end

	arg_2_0.fully_charged_triggered = false
	arg_2_0.total_overcharge_added = 0
	arg_2_0.remove_overcharge_on_interrupt = arg_2_1.remove_overcharge_on_interrupt

	local var_2_2 = ScriptUnit.extension(var_2_0, "buff_system")

	arg_2_0.buff_extension = var_2_2
	arg_2_0.charge_level = 0
	arg_2_0.charge_time = var_2_2:apply_buffs_to_value(arg_2_1.charge_time, "reduced_ranged_charge_time")
	arg_2_0.charge_complete_time = arg_2_0.charge_time + arg_2_2
	arg_2_0.overcharge_timer = 0
	arg_2_0.ability_charge_timer = 0
	arg_2_0.ammo_consumption_timer = 0

	if not arg_2_1.vent_overcharge then
		Unit.flow_event(arg_2_0.first_person_unit, "lua_charge_start")
	end

	local var_2_3 = arg_2_1.charge_effect_name

	if var_2_3 then
		local var_2_4 = arg_2_0.weapon_unit
		local var_2_5 = Unit.node(var_2_4, "fx_muzzle")

		arg_2_0.particle_id = ScriptWorld.create_particles_linked(arg_2_0.world, var_2_3, var_2_4, var_2_5, "destroy")

		if arg_2_0.left_unit then
			local var_2_6 = Unit.node(arg_2_0.left_unit, "fx_muzzle")

			arg_2_0.left_particle_id = ScriptWorld.create_particles_linked(arg_2_0.world, var_2_3, arg_2_0.left_unit, var_2_6, "destroy")
		end
	end

	arg_2_0:_start_charge_sound()

	local var_2_7 = arg_2_1.spread_template_override

	if var_2_7 then
		arg_2_0.spread_extension:override_spread_template(var_2_7)
	end

	if arg_2_1.zoom then
		local var_2_8 = ScriptUnit.extension(arg_2_0.owner_unit, "status_system")

		if not var_2_8:is_zooming() then
			var_2_8:set_zooming(true)
		end
	end

	local var_2_9 = arg_2_1.loaded_projectile_settings

	if var_2_9 then
		ScriptUnit.extension(arg_2_0.owner_unit, "inventory_system"):set_loaded_projectile_override(var_2_9)
	end
end

function ActionCharge._start_charge_sound(arg_3_0)
	local var_3_0 = arg_3_0.current_action
	local var_3_1 = var_3_0.charge_sound_name
	local var_3_2 = var_3_0.charge_sound_stop_event

	if not var_3_1 or not var_3_2 then
		return
	end

	local var_3_3 = arg_3_0.weapon_extension
	local var_3_4 = var_3_0.charge_sound_husk_name
	local var_3_5 = var_3_0.charge_sound_husk_stop_event

	var_3_3:add_looping_audio(arg_3_0.audio_loop_id, var_3_1, var_3_2, var_3_4, var_3_5)

	local var_3_6 = arg_3_0.owner_player

	if var_3_6 and var_3_6.bot_player and not var_3_6.remote then
		local var_3_7 = var_3_0.charge_sound_switch

		if var_3_7 then
			local var_3_8 = ScriptUnit.extension(arg_3_0.owner_unit, "overcharge_system"):above_overcharge_threshold() and "above_overcharge_threshold" or "below_overcharge_threshold"

			var_3_3:set_looping_audio_switch(arg_3_0.audio_loop_id, var_3_7, var_3_8)
		end

		local var_3_9 = var_3_0.charge_sound_parameter_name

		if var_3_9 then
			var_3_3:update_looping_audio_parameter(arg_3_0.audio_loop_id, var_3_9, 1)
		end
	end

	var_3_3:start_looping_audio(arg_3_0.audio_loop_id)
end

function ActionCharge._stop_charge_sound(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0.current_action.charge_sound_stop_event_condition_func

	if var_4_0 and not var_4_0(arg_4_0.owner_unit, arg_4_1) then
		return
	end

	arg_4_0.weapon_extension:stop_looping_audio(arg_4_0.audio_loop_id)
end

function ActionCharge.client_owner_post_update(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_0.current_action
	local var_5_1 = arg_5_0.charge_time
	local var_5_2 = arg_5_0.charge_complete_time - arg_5_2

	if var_5_0.ammo_charge then
		local var_5_3 = arg_5_0.ammo_extension

		if not var_5_3 or var_5_3:current_ammo() < 1 then
			return
		end
	end

	local var_5_4 = var_5_0.overcharge_type
	local var_5_5

	if var_5_2 > 0 and var_5_1 > 0 then
		var_5_5 = 1 - var_5_2 / var_5_1
	elseif var_5_2 > 0 and var_5_1 <= 0 or var_5_2 <= 0 and var_5_1 > 0 or var_5_2 <= 0 and var_5_1 <= 0 then
		var_5_5 = 1
	end

	local var_5_6 = math.max(math.min(var_5_5, 1), 0)

	if not var_5_0.vent_overcharge and var_5_6 >= 1 and not arg_5_0._max_charge then
		arg_5_0._max_charge = true

		Unit.flow_event(arg_5_0.first_person_unit, "lua_max_charge")

		if not arg_5_0.fully_charged_triggered then
			arg_5_0.buff_extension:trigger_procs("on_full_charge")

			arg_5_0.fully_charged_triggered = true
		end
	end

	local var_5_7 = arg_5_0.overcharge_extension
	local var_5_8 = ScriptUnit.extension(arg_5_0.owner_unit, "inventory_system")
	local var_5_9 = ScriptUnit.extension(arg_5_0.owner_unit, "career_system")

	if var_5_4 and var_5_7:get_overcharge_value() == 0 and arg_5_0.venting_overcharge then
		CharacterStateHelper.stop_weapon_actions(var_5_8, "no_more_overcharge")
		CharacterStateHelper.stop_career_abilities(var_5_9, "no_more_overcharge")
	end

	if var_5_0.overcharge_interval then
		arg_5_0.overcharge_timer = arg_5_0.overcharge_timer + arg_5_1

		if arg_5_0.overcharge_timer >= var_5_0.overcharge_interval then
			if var_5_4 then
				local var_5_10 = PlayerUnitStatusSettings.overcharge_values[var_5_4]

				if arg_5_0.remove_overcharge_on_interrupt and var_5_5 == 1 then
					var_5_10 = PlayerUnitStatusSettings.overcharge_values.drakegun_charging
				end

				arg_5_0.overcharge_extension:add_charge(var_5_10, nil, var_5_4)

				arg_5_0.total_overcharge_added = arg_5_0.total_overcharge_added + var_5_10
			end

			arg_5_0.overcharge_timer = 0
		end
	end

	if var_5_0.ammo_charge then
		arg_5_0.ammo_consumption_timer = arg_5_0.ammo_consumption_timer + arg_5_1

		if arg_5_0.ammo_consumption_timer >= var_5_0.charge_time / var_5_0.ammo_per_clip then
			local var_5_11 = arg_5_0.ammo_extension

			if var_5_11 then
				var_5_11:use_ammo(1)
			end

			arg_5_0.ammo_consumption_timer = 0
		end
	end

	if var_5_0.charge_anim_variable then
		arg_5_0.first_person_extension:animation_set_variable(var_5_0.charge_anim_variable, var_5_6)
	end

	local var_5_12 = arg_5_0.particle_id
	local var_5_13 = var_5_0.charge_effect_material_name
	local var_5_14 = var_5_0.charge_effect_material_variable_name

	if var_5_13 and var_5_14 and var_5_12 and World.has_particles_material(arg_5_3, var_5_12, var_5_13) then
		World.set_particles_material_scalar(arg_5_3, var_5_12, var_5_13, var_5_14, var_5_6)
	end

	local var_5_15 = arg_5_0.left_particle_id
	local var_5_16 = var_5_0.charge_effect_material_name
	local var_5_17 = var_5_0.charge_effect_material_variable_name

	if var_5_16 and var_5_17 and var_5_15 and World.has_particles_material(arg_5_3, var_5_15, var_5_16) then
		World.set_particles_material_scalar(arg_5_3, var_5_15, var_5_16, var_5_17, var_5_6)
	end

	local var_5_18 = arg_5_0.owner_unit
	local var_5_19 = Managers.player:owner(var_5_18)

	if not (var_5_19 and var_5_19.bot_player) then
		local var_5_20 = var_5_0.charge_sound_parameter_name

		if var_5_20 then
			local var_5_21 = arg_5_0.wwise_world
			local var_5_22 = arg_5_0.wwise_source_id

			WwiseWorld.set_source_parameter(var_5_21, var_5_22, var_5_20, var_5_6)
		end

		if arg_5_0.charge_ready_sound_event and var_5_6 >= 1 then
			arg_5_0.first_person_extension:play_hud_sound_event(arg_5_0.charge_ready_sound_event)

			arg_5_0.charge_ready_sound_event = nil
		end

		if var_5_6 >= 1 and arg_5_0.charge_flow_event_left_weapon and arg_5_0.left_unit then
			Unit.flow_event(arg_5_0.left_unit, arg_5_0.charge_flow_event_left_weapon)

			arg_5_0.charge_flow_event_left_weapon = nil
		end
	end

	if var_5_6 >= 1 and not Managers.player:owner(arg_5_0.owner_unit).bot_player and not arg_5_0._rumble_effect_id then
		arg_5_0._rumble_effect_id = Managers.state.controller_features:add_effect("persistent_rumble", {
			rumble_effect = "reload_start"
		})
	end

	arg_5_0.charge_level = var_5_6
end

function ActionCharge._clean_up(arg_6_0, arg_6_1)
	if arg_6_0.particle_id then
		World.destroy_particles(arg_6_0.world, arg_6_0.particle_id)

		arg_6_0.particle_id = nil
	end

	if arg_6_0.left_particle_id then
		World.destroy_particles(arg_6_0.world, arg_6_0.left_particle_id)

		arg_6_0.left_particle_id = nil
	end

	if arg_6_0._rumble_effect_id then
		Managers.state.controller_features:stop_effect(arg_6_0._rumble_effect_id)

		arg_6_0._rumble_effect_id = nil
	end

	arg_6_0:_stop_charge_sound(arg_6_1)
end

function ActionCharge.finish(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.owner_unit
	local var_7_1 = arg_7_0.first_person_unit
	local var_7_2 = arg_7_0.current_action

	arg_7_0:_clean_up(arg_7_1)

	local var_7_3 = arg_7_0.overcharge_extension

	if var_7_2.vent_overcharge and var_7_3 then
		var_7_3:vent_overcharge_done()
	end

	if arg_7_0.remove_overcharge_on_interrupt then
		if arg_7_1 == "interrupted" then
			var_7_3:remove_charge(arg_7_0.total_overcharge_added * 0.75)
		elseif arg_7_1 == "hold_input_released" then
			var_7_3:remove_charge(arg_7_0.total_overcharge_added * 0.5)
		end
	end

	if arg_7_1 == "hold_input_released" or arg_7_1 == "weapon_wielded" then
		Unit.flow_event(var_7_1, "lua_charge_cancel")
	end

	Unit.flow_event(var_7_1, "lua_charge_stop")

	if arg_7_0.spread_extension then
		arg_7_0.spread_extension:reset_spread_template()
	end

	if var_7_2.zoom then
		ScriptUnit.extension(var_7_0, "status_system"):set_zooming(false)
	end

	ScriptUnit.extension(arg_7_0.owner_unit, "inventory_system"):set_loaded_projectile_override(nil)
	arg_7_0.buff_extension:trigger_procs("on_charge_finished")

	return {
		charge_level = arg_7_0.charge_level
	}
end

function ActionCharge.destroy(arg_8_0)
	arg_8_0:_clean_up()
end
