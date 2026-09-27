-- chunkname: @scripts/unit_extensions/default_player_unit/charge/player_husk_overcharge_extension.lua

require("scripts/unit_extensions/default_player_unit/charge/overcharge_data")

PlayerHuskOverchargeExtension = class(PlayerHuskOverchargeExtension)

PlayerHuskOverchargeExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.network_manager = Managers.state.network
	self.unit = arg_1_2

	local overcharge_data = arg_1_3.overcharge_data

	self.overcharge_value = 0
	self.overcharge_threshold = 0
	self.max_value = arg_1_3.overcharge_max_value

	local max_value = overcharge_data.max_value

	max_value = max_value or 40
	self.original_max_value = max_value
	self.overcharge_limit = self.max_value * 0.65
	self.overcharge_critical_limit = self.max_value * 0.8
	self._lerped_overcharge_fraction = 0
end

PlayerHuskOverchargeExtension.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	self.status_extension = ScriptUnit.extension(arg_2_2, "status_system")
end

PlayerHuskOverchargeExtension.set_screen_particle_opacity_modifier = function (arg_3_0)
	-- function 3
	return
end

PlayerHuskOverchargeExtension.reset = function (arg_4_0)
	-- function 4
	return
end

PlayerHuskOverchargeExtension.destroy = function (arg_5_0)
	-- function 5
	return
end

PlayerHuskOverchargeExtension.set_animation_variable = function (arg_6_0)
	-- function 6
	return
end

PlayerHuskOverchargeExtension._update_game_object = function (self)
	-- function 7
	local network_manager = self.network_manager
	local unit = self.unit
	local game = network_manager:game()
	local go_id = Managers.state.unit_storage:go_id(unit)

	if not game and not go_id then
		local game_object_field = GameSession.game_object_field(game, go_id, "overcharge_percentage")
		local game_object_field_2 = GameSession.game_object_field(game, go_id, "overcharge_threshold_percentage")
		local game_object_field_3 = GameSession.game_object_field(game, go_id, "overcharge_max_value")
		local num = game_object_field * game_object_field_3

		self.overcharge_threshold, self.overcharge_value = game_object_field_2 * game_object_field_3, num
		self.max_value = game_object_field_3
		self.overcharge_limit = game_object_field_3 * 0.65
		self.overcharge_critical_limit = game_object_field_3 * 0.8
	end
end

PlayerHuskOverchargeExtension.update = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	self:_update_lerped_overcharge(arg_8_3)
	self:_update_game_object()
end

PlayerHuskOverchargeExtension.add_charge = function (arg_9_0)
	-- function 9
	return
end

PlayerHuskOverchargeExtension.remove_charge = function (arg_10_0)
	-- function 10
	return
end

PlayerHuskOverchargeExtension.hud_sound = function (arg_11_0)
	-- function 11
	return
end

PlayerHuskOverchargeExtension.get_overcharge_value = function (self)
	-- function 12
	return self.overcharge_value
end

PlayerHuskOverchargeExtension.is_above_critical_limit = function (self)
	-- function 13
	return self.overcharge_value >= self.overcharge_critical_limit
end

PlayerHuskOverchargeExtension.get_max_value = function (self)
	-- function 14
	return self.max_value
end

PlayerHuskOverchargeExtension.get_original_max_value = function (self)
	-- function 15
	return self.original_max_value
end

PlayerHuskOverchargeExtension.get_overcharge_threshold = function (self)
	-- function 16
	return self.overcharge_threshold
end

PlayerHuskOverchargeExtension.above_overcharge_threshold = function (self)
	-- function 17
	return self.overcharge_value >= self.overcharge_threshold
end

PlayerHuskOverchargeExtension.overcharge_fraction = function (self)
	-- function 18
	return self.overcharge_value / self.max_value
end

PlayerHuskOverchargeExtension.lerped_overcharge_fraction = function (self)
	-- function 19
	return self._lerped_overcharge_fraction
end

PlayerHuskOverchargeExtension.threshold_fraction = function (self)
	-- function 20
	return self.overcharge_threshold / self.max_value
end

PlayerHuskOverchargeExtension.current_overcharge_status = function (self)
	-- function 21
	local get_overcharge_value = self:get_overcharge_value()
	local get_overcharge_threshold = self:get_overcharge_threshold()
	local get_max_value = self:get_max_value()

	return get_overcharge_value, get_overcharge_threshold, get_max_value
end

PlayerHuskOverchargeExtension.vent_overcharge = function (arg_22_0)
	-- function 22
	return
end

PlayerHuskOverchargeExtension.vent_overcharge_done = function (arg_23_0)
	-- function 23
	return
end

PlayerHuskOverchargeExtension.get_anim_blend_overcharge = function (self)
	-- function 24
	local num = self._lerped_overcharge_fraction * self:get_max_value()
	local overcharge_threshold = self.overcharge_threshold
	local max_value = self.max_value

	return (math.clamp((num - overcharge_threshold) / (max_value - overcharge_threshold), 0, 1))
end

PlayerHuskOverchargeExtension._update_lerped_overcharge = function (self, arg_25_1)
	-- function 25
	local overcharge_fraction = self:overcharge_fraction()
	local _lerped_overcharge_fraction = self._lerped_overcharge_fraction

	if overcharge_fraction == _lerped_overcharge_fraction then
		return
	end

	local num = 0.1
	local num_2 = 0.2
	local num_3 = 10
	local num_4 = 0.3
	local abs = math.abs(_lerped_overcharge_fraction - overcharge_fraction)

	if num_2 < abs then
		num_4 = num_4 * num_3
	elseif num < abs then
		num_4 = num_4 * math.remap(num, num_2, 1, num_3, abs)
	end

	local min = math.min(_lerped_overcharge_fraction, overcharge_fraction)
	local max = math.max(_lerped_overcharge_fraction, overcharge_fraction)
	local num_5 = _lerped_overcharge_fraction + math.sign(overcharge_fraction - _lerped_overcharge_fraction) * num_4 * arg_25_1

	self._lerped_overcharge_fraction = math.clamp(num_5, min, max)
end
