-- chunkname: @scripts/unit_extensions/weapons/actions/action_minigun_spin.lua

ActionMinigunSpin = class(ActionMinigunSpin, ActionBase)

ActionMinigunSpin.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionMinigunSpin.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self.weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
	self.first_person_extension = ScriptUnit.has_extension(arg_1_4, "first_person_system")
end

ActionMinigunSpin.client_owner_start_action = function (self, arg_2_1, arg_2_2)
	-- function 2
	ActionMinigunSpin.super.client_owner_start_action(self, arg_2_1, arg_2_2)

	self._initial_windup = arg_2_1.initial_windup
	self._windup_max = arg_2_1.windup_max
	self._windup_speed = arg_2_1.windup_speed

	if not arg_2_1.windup_start_on_zero then
		self._current_windup = 0
	else
		self._current_windup = self.weapon_extension:get_custom_data("windup")
	end

	self._last_update_t = arg_2_2
	self._audio_loop_id = arg_2_1.audio_loop_id
	self._fp_speed_anim_variable = arg_2_1.fp_speed_anim_variable

	self:start_audio_loop()
end

ActionMinigunSpin.client_owner_post_update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local weapon_extension = self.weapon_extension
	local _current_windup = self._current_windup
	local clamp = math.clamp(_current_windup + self._windup_speed * arg_3_1, self._initial_windup, 1)

	weapon_extension:set_custom_data("windup", clamp)

	self._current_windup = clamp
	self._last_update_t = arg_3_2

	self:_update_animation_speed(clamp)
end

ActionMinigunSpin.start_audio_loop = function (self)
	-- function 4
	local _audio_loop_id = self._audio_loop_id

	if not _audio_loop_id then
		return
	end

	local current_action = self.current_action
	local charge_sound_name = current_action.charge_sound_name
	local charge_sound_stop_event = current_action.charge_sound_stop_event

	if not (not charge_sound_name and charge_sound_stop_event) then
		return
	end

	local weapon_extension = self.weapon_extension
	local charge_sound_husk_name = current_action.charge_sound_husk_name
	local charge_sound_husk_stop_event = current_action.charge_sound_husk_stop_event

	weapon_extension:add_looping_audio(_audio_loop_id, charge_sound_name, charge_sound_stop_event, charge_sound_husk_name, charge_sound_husk_stop_event)
	weapon_extension:start_looping_audio(_audio_loop_id)
end

ActionMinigunSpin._update_animation_speed = function (self, arg_5_1)
	-- function 5
	if not self._fp_speed_anim_variable then
		local num = arg_5_1 / 3 + 0.67
		local clamp = math.clamp(num, NetworkConstants.animation_variable_float.min, NetworkConstants.animation_variable_float.max)

		self.first_person_extension:animation_set_variable(self._fp_speed_anim_variable, clamp)
	end
end

ActionMinigunSpin.finish = function (arg_6_0, ...)
	-- function 6
	ActionMinigunSpin.super.finish(arg_6_0, ...)
end
