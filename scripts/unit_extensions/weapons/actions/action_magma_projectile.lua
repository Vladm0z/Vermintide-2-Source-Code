-- chunkname: @scripts/unit_extensions/weapons/actions/action_magma_projectile.lua

ActionMagmaProjectile = class(ActionMagmaProjectile, ActionShotgun)

ActionMagmaProjectile.client_owner_start_action = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	ActionMagmaProjectile.super.client_owner_start_action(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)

	local is_spell = arg_1_1.is_spell
	local owner_buff_extension = self.owner_buff_extension

	if not self.charge_level and not (self.charge_level >= 1) or not is_spell then
		owner_buff_extension:trigger_procs("on_full_charge_action", arg_1_1, arg_1_2, arg_1_3)
	end
end

ActionMagmaProjectile._start_shooting = function (self)
	-- function 2
	local owner_unit = self.owner_unit
	local current_action = self.current_action
	local extension = ScriptUnit.extension(owner_unit, "first_person_system")
	local get_projectile_start_position_rotation, var_2_4 = extension:get_projectile_start_position_rotation()

	if not current_action.fire_at_gaze_setting and not ScriptUnit.has_extension(owner_unit, "eyetracking_system") and not ScriptUnit.extension(owner_unit, "eyetracking_system"):get_is_feature_enabled("tobii_fire_at_gaze") then
		var_2_4 = self.start_gaze_rotation:unbox()
	end

	self._fire_position:store(get_projectile_start_position_rotation)
	self._fire_rotation:store(var_2_4)

	if not Managers.player:owner(self.owner_unit).bot_player then
		Managers.state.controller_features:add_effect("rumble", {
			rumble_effect = "handgun_fire"
		})
	end

	self:_use_ammo()
	self:_add_overcharge()
	self:_proc_spell_used(self.owner_buff_extension)

	if not current_action.alert_sound_range_fire then
		Managers.state.entity:system("ai_system"):alert_enemies_within_range(owner_unit, POSITION_LOOKUP[owner_unit], current_action.alert_sound_range_fire)
	end

	local fire_sound_event = self.current_action.fire_sound_event

	if not fire_sound_event then
		local fire_sound_on_husk = self.current_action.fire_sound_on_husk

		extension:play_hud_sound_event(fire_sound_event, nil, fire_sound_on_husk)
	end

	self.state = "shooting"
end
