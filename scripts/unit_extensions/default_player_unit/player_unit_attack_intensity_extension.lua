-- chunkname: @scripts/unit_extensions/default_player_unit/player_unit_attack_intensity_extension.lua

require("scripts/settings/attack_intensity_settings")

PlayerUnitAttackIntensityExtension = class(PlayerUnitAttackIntensityExtension)

local num = 25

PlayerUnitAttackIntensityExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._network_manager = Managers.state.network
	self._world = arg_1_1.world
	self._unit = arg_1_2
	self._attack_intensity = {}
	self._attack_allowed = {}
	self._attack_intensity_threshold = {}
	self._attack_intensity_decay = {}
	self._attack_intensity_decay_grace = {}
	self._attack_intensity_reset = {}

	local get_difficulty_settings = Managers.state.difficulty:get_difficulty_settings()
	local difficulty = AttackIntensitySettings.difficulty

	self._attack_intensity_difficulty = Managers.state.difficulty:get_difficulty_value_from_table(difficulty)

	self:_setup_intensity()
end

PlayerUnitAttackIntensityExtension._setup_intensity = function (self)
	-- function 2
	for k, v in pairs(AttackIntensitySettings.attack_type_intesities) do
		local var_2_0 = self._attack_intensity_difficulty[k]

		self._attack_intensity[k] = 0
		self._attack_allowed[k] = true
		self._attack_intensity_threshold[k] = var_2_0.threshold
		self._attack_intensity_decay[k] = var_2_0.decay
		self._attack_intensity_decay_grace[k] = 0
		self._attack_intensity_reset[k] = var_2_0.reset
	end
end

PlayerUnitAttackIntensityExtension.extensions_ready = function (self, arg_3_1, arg_3_2)
	-- function 3
	self._buff_extension = ScriptUnit.extension(arg_3_2, "buff_system")
end

PlayerUnitAttackIntensityExtension.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	for k, v in pairs(AttackIntensitySettings.attack_type_intesities) do
		local var_4_0 = self._attack_intensity_decay_grace[k]

		if var_4_0 > 0 then
			local max = math.max(var_4_0 - arg_4_3, 0)

			self._attack_intensity_decay_grace[k] = max
		else
			local var_4_2 = self._attack_intensity[k]

			if var_4_2 > 0 then
				local num

				if not self._attack_allowed[k] then
					num = self._attack_intensity_decay[k] * 0.25

					if not num then
						-- Nothing
					end
				end

				num = self._attack_intensity_decay[k]

				::label_4_0::

				local var_4_4 = self._attack_intensity_threshold[k]
				local var_4_5 = self._attack_intensity_reset[k]
				local _buff_extension = self._buff_extension
				local apply_buffs_to_value = _buff_extension:apply_buffs_to_value(num, "attack_intensity_decay")
				local apply_buffs_to_value_2 = _buff_extension:apply_buffs_to_value(var_4_4, "attack_intensity_threshold")
				local apply_buffs_to_value_3 = _buff_extension:apply_buffs_to_value(var_4_5, "attack_intensity_reset")
				local max_2 = math.max(var_4_2 - arg_4_3 * apply_buffs_to_value * apply_buffs_to_value_2, 0)

				if apply_buffs_to_value_2 < max_2 then
					self._attack_allowed[k] = false
				end

				if max_2 <= apply_buffs_to_value_3 then
					self._attack_allowed[k] = true
				end

				self._attack_intensity[k] = max_2
			end
		end
	end
end

PlayerUnitAttackIntensityExtension.add_attack_intensity = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	fassert(AttackIntensitySettings.attack_type_intesities[arg_5_1], "No attack intesity settings defined for attack type \"%s\"", arg_5_1)

	self._attack_intensity_decay_grace[arg_5_1] = self._attack_intensity_difficulty[arg_5_1].decay_grace
	self._attack_intensity[arg_5_1] = math.clamp(self._attack_intensity[arg_5_1] + arg_5_2, 0, arg_5_3 or num)

	if self._attack_intensity[arg_5_1] > self._attack_intensity_threshold[arg_5_1] then
		self._attack_allowed[arg_5_1] = false
	elseif not (self._attack_allowed[arg_5_1] or not (self._attack_intensity[arg_5_1] < self._attack_intensity_reset[arg_5_1])) then
		self._attack_allowed[arg_5_1] = true
	end
end

PlayerUnitAttackIntensityExtension.want_an_attack = function (self, arg_6_1)
	-- function 6
	fassert(AttackIntensitySettings.attack_type_intesities[arg_6_1], "No attack intesity settings defined for attack type \"%s\"", arg_6_1)

	return self._attack_allowed[arg_6_1]
end
