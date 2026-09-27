-- chunkname: @scripts/unit_extensions/weapons/actions/action_aim.lua

ActionAim = class(ActionAim, ActionBase)

ActionAim.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionAim.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self.ammo_extension = ScriptUnit.has_extension(arg_1_7, "ammo_system")
	self.spread_extension = ScriptUnit.has_extension(arg_1_7, "spread_system")
	self.weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
end

local function fn(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	return arg_2_1 / ActionUtils.get_action_time_scale(arg_2_2, arg_2_0)
end

ActionAim.client_owner_start_action = function (self, arg_3_1, arg_3_2)
	-- function 3
	ActionAim.super.client_owner_start_action(self, arg_3_1, arg_3_2)

	local owner_unit = self.owner_unit

	self.current_action = arg_3_1
	self.zoom_condition_function = arg_3_1.zoom_condition_function
	self.played_aim_sound = false
	self.heavy_aim_flow_done = false
	self.fully_charged_triggered = false

	local extension = ScriptUnit.extension(owner_unit, "buff_system")

	self.buff_extension = extension

	local var_3_2 = fn
	local var_3_3 = arg_3_1
	local aim_sound_delay = arg_3_1.aim_sound_delay

	aim_sound_delay = aim_sound_delay or 0

	local var_3_5 = var_3_2(var_3_3, aim_sound_delay, owner_unit, extension)
	local var_3_6 = fn
	local var_3_7 = arg_3_1
	local aim_zoom_delay = arg_3_1.aim_zoom_delay

	aim_zoom_delay = aim_zoom_delay or 0

	local var_3_9 = var_3_6(var_3_7, aim_zoom_delay, owner_unit, extension)
	local var_3_10 = fn
	local var_3_11 = arg_3_1
	local heavy_aim_flow_delay = arg_3_1.heavy_aim_flow_delay

	heavy_aim_flow_delay = heavy_aim_flow_delay or 0

	local var_3_13 = var_3_10(var_3_11, heavy_aim_flow_delay, owner_unit, extension)
	local var_3_14 = fn
	local var_3_15 = arg_3_1
	local charge_time = arg_3_1.charge_time

	charge_time = charge_time or 0

	local var_3_17 = var_3_14(var_3_15, charge_time, owner_unit, extension)

	self.aim_sound_time = arg_3_2 + var_3_5
	self.aim_zoom_time = arg_3_2 + var_3_9
	self.heavy_aim_flow_time = arg_3_2 + var_3_13
	self.charge_time_trigger = arg_3_2 + var_3_17

	local extension_2 = ScriptUnit.extension(owner_unit, "first_person_system")

	extension_2:disable_rig_movement()
	extension_2:enable_rig_offset()

	local spread_template_override = arg_3_1.spread_template_override

	if not spread_template_override then
		self.spread_extension:override_spread_template(spread_template_override)
	end

	local loaded_projectile_settings = arg_3_1.loaded_projectile_settings

	if not loaded_projectile_settings then
		ScriptUnit.extension(owner_unit, "inventory_system"):set_loaded_projectile_override(loaded_projectile_settings)
	end

	self.charge_ready_sound_event = self.current_action.charge_ready_sound_event

	self:_start_charge_sound()
end

ActionAim._start_charge_sound = function (self)
	-- function 4
	local current_action = self.current_action
	local owner_unit = self.owner_unit
	local owner_player = self.owner_player
	local flag = not owner_player and owner_player.bot_player
	local flag_2 = not owner_player and not owner_player.remote
	local wwise_world = self.wwise_world

	if not (not flag_2 and flag) then
		local start_charge_sound, var_4_7 = ActionUtils.start_charge_sound(wwise_world, self.weapon_unit, owner_unit, current_action)

		self.charging_sound_id = start_charge_sound
		self.wwise_source_id = var_4_7
	end

	ActionUtils.play_husk_sound_event(wwise_world, current_action.charge_sound_husk_name, owner_unit, flag)
end

ActionAim._stop_charge_sound = function (self)
	-- function 5
	local current_action = self.current_action
	local owner_unit = self.owner_unit
	local owner_player = self.owner_player
	local flag = not owner_player and owner_player.bot_player
	local flag_2 = not owner_player and not owner_player.remote
	local wwise_world = self.wwise_world

	if not (not flag_2 and flag) then
		ActionUtils.stop_charge_sound(wwise_world, self.charging_sound_id, self.wwise_source_id, current_action)

		self.charging_sound_id = nil
		self.wwise_source_id = nil
	end

	ActionUtils.play_husk_sound_event(wwise_world, current_action.charge_sound_husk_stop_event, owner_unit, flag)
end

ActionAim.client_owner_post_update = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local current_action = self.current_action
	local owner_unit = self.owner_unit

	if not Application.user_setting("tobii_eyetracking") and not ScriptUnit.has_extension(owner_unit, "eyetracking_system") then
		local extension = ScriptUnit.extension(owner_unit, "eyetracking_system")

		if not (not extension:get_is_feature_enabled("tobii_aim_at_gaze") and extension:get_aim_at_gaze_cancelled()) then
			local extension_2 = ScriptUnit.extension(owner_unit, "input_system")
			local get = extension_2:get("look_raw")

			get = get or Vector3(0, 0, 0)

			local get_2 = extension_2:get("look_raw_controller")

			get_2 = get_2 or Vector3(0, 0, 0)

			if not (Vector3.length(get) > 0.01 or not (Vector3.length(get_2) > 0.01)) then
				ScriptUnit.extension(owner_unit, "first_person_system"):stop_force_look_rotation()
				extension:set_aim_at_gaze_cancelled(true)
			end
		end
	end

	if not self.zoom_condition_function and not self.zoom_condition_function() then
		local extension_3 = ScriptUnit.extension(owner_unit, "status_system")
		local extension_4 = ScriptUnit.extension(owner_unit, "input_system")
		local extension_5 = ScriptUnit.extension(owner_unit, "buff_system")

		if not (extension_3:is_zooming() or not (arg_6_2 >= self.aim_zoom_time)) then
			extension_3:set_zooming(true, current_action.default_zoom)
		end

		if not extension_5:has_buff_perk("increased_zoom") and not extension_3:is_zooming() and not extension_4:get("action_three") then
			extension_3:switch_variable_zoom(current_action.buffed_zoom_thresholds)
		end
	end

	if not (self.played_aim_sound or not (arg_6_2 >= self.aim_sound_time) or Managers.player:owner(self.owner_unit).bot_player) then
		Managers.state.controller_features:add_effect("rumble", {
			rumble_effect = "aim_start"
		})

		local aim_sound_event = current_action.aim_sound_event

		if not aim_sound_event then
			if not current_action.looping_aim_sound then
				local aim_sound_event_2 = current_action.aim_sound_event
				local unaim_sound_event = current_action.unaim_sound_event

				self.weapon_extension:add_looping_audio("aim", aim_sound_event_2, unaim_sound_event, nil, nil, true)
			else
				local wwise_world = self.wwise_world

				WwiseWorld.trigger_event(wwise_world, aim_sound_event)
			end
		end

		self.played_aim_sound = true
	end

	if not (self.heavy_aim_flow_done or not (arg_6_2 >= self.heavy_aim_flow_time) or Managers.player:owner(self.owner_unit).bot_player) then
		Managers.state.controller_features:add_effect("rumble", {
			rumble_effect = "aim_start"
		})

		local heavy_aim_flow_event = current_action.heavy_aim_flow_event

		if not heavy_aim_flow_event then
			Unit.flow_event(self.first_person_unit, heavy_aim_flow_event)
		end

		local heavy_aim_sound_event = current_action.heavy_aim_sound_event

		if not heavy_aim_sound_event then
			local wwise_world_2 = self.wwise_world

			WwiseWorld.trigger_event(wwise_world_2, heavy_aim_sound_event)
		end

		self.heavy_aim_flow_done = true
	end

	if not (not (arg_6_2 > self.charge_time_trigger) or self.fully_charged_triggered) then
		self.fully_charged_triggered = true

		self.buff_extension:trigger_procs("on_full_charge")
	end
end

ActionAim.finish = function (self, arg_7_1)
	-- function 7
	local current_action = self.current_action
	local ammo_extension = self.ammo_extension
	local owner_unit = self.owner_unit
	local unzoom_condition_function = current_action.unzoom_condition_function

	if not unzoom_condition_function and not unzoom_condition_function(arg_7_1) then
		ScriptUnit.extension(owner_unit, "status_system"):set_zooming(false)
	end

	local extension = ScriptUnit.extension(owner_unit, "first_person_system")

	extension:enable_rig_movement()
	extension:disable_rig_offset()
	extension:stop_force_look_rotation()

	local reload_when_out_of_ammo_condition_func = current_action.reload_when_out_of_ammo_condition_func
	local flag

	flag = reload_when_out_of_ammo_condition_func or not true or reload_when_out_of_ammo_condition_func(owner_unit, arg_7_1)

	if not ammo_extension and not ammo_extension:can_reload() and (ammo_extension:ammo_count() ~= 0 or not current_action.reload_when_out_of_ammo) and not flag then
		local flag_2 = true

		ammo_extension:start_reload(flag_2)
	end

	if not self.spread_extension then
		self.spread_extension:reset_spread_template()
	end

	local unaim_sound_event = current_action.unaim_sound_event

	if not unaim_sound_event then
		local wwise_world = self.wwise_world

		WwiseWorld.trigger_event(wwise_world, unaim_sound_event)
	end

	if not Managers.player:owner(owner_unit).bot_player then
		Managers.state.controller_features:add_effect("rumble", {
			rumble_effect = "full_stop"
		})
	end

	if not current_action.reset_aim_assist_on_exit then
		extension:reset_aim_assist_multiplier()
	end

	ScriptUnit.extension(owner_unit, "inventory_system"):set_loaded_projectile_override(nil)
	self.buff_extension:trigger_procs("on_charge_finished")

	if not current_action.looping_aim_sound then
		self:_stop_charge_sound()
	end
end
