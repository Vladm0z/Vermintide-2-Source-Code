-- chunkname: @scripts/settings/dlcs/woods/passive_ability_thornsister.lua

PassiveAbilityThornsister = class(PassiveAbilityThornsister)

PassiveAbilityThornsister.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	self._owner_unit = arg_1_2
	self._ability_init_data = arg_1_4
	self._cooldown_buff = nil
	self._stack_buffs = {}
	self._num_stack_buffs = 0
end

PassiveAbilityThornsister.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	self._career_extension = ScriptUnit.has_extension(arg_2_2, "career_system")
	self._buff_extension = ScriptUnit.has_extension(arg_2_2, "buff_system")

	local _ability_init_data = self._ability_init_data

	self._career_extension:setup_extra_ability_uses(0, _ability_init_data.cooldown, _ability_init_data.starting_stack_count, _ability_init_data.max_stacks)

	local has_extension = ScriptUnit.has_extension(arg_2_2, "talent_system")

	self:_update_extra_abilities_info(has_extension)
	self:_register_events()
end

PassiveAbilityThornsister.destroy = function (self)
	-- function 3
	self:_unregister_events()
end

PassiveAbilityThornsister._register_events = function (arg_4_0)
	-- function 4
	Managers.state.event:register(arg_4_0, "on_talents_changed", "on_talents_changed")
end

PassiveAbilityThornsister._unregister_events = function (arg_5_0)
	-- function 5
	if not Managers.state.event then
		Managers.state.event:unregister("on_talents_changed", arg_5_0)
	end
end

PassiveAbilityThornsister.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	local _career_extension = self._career_extension

	if not _career_extension then
		return
	end

	_career_extension:modify_extra_ability_charge(arg_6_1)

	local _buff_extension = self._buff_extension

	if not _buff_extension then
		local get_extra_ability_uses, var_6_3 = _career_extension:get_extra_ability_uses()
		local get_extra_ability_charge, var_6_5 = _career_extension:get_extra_ability_charge()
		local _cooldown_buff = self._cooldown_buff

		if not _cooldown_buff and not _cooldown_buff.is_stale then
			_cooldown_buff = nil
		end

		if get_extra_ability_uses < var_6_3 then
			if not _cooldown_buff then
				local add_buff = _buff_extension:add_buff("kerillian_thorn_sister_free_ability_cooldown")

				_cooldown_buff = _buff_extension:get_buff_by_id(add_buff)
				self._cooldown_buff = _cooldown_buff
			end

			_cooldown_buff.start_time = arg_6_2 - get_extra_ability_charge
			_cooldown_buff.duration = var_6_5
		elseif not _cooldown_buff then
			_buff_extension:remove_buff(_cooldown_buff.id)

			self._cooldown_buff = nil
		end

		local _stack_buffs = self._stack_buffs
		local _num_stack_buffs = self._num_stack_buffs

		if _num_stack_buffs < get_extra_ability_uses then
			for i = 1, get_extra_ability_uses - _num_stack_buffs do
				_stack_buffs[_num_stack_buffs + i] = _buff_extension:add_buff("kerillian_thorn_sister_free_ability_stack")
			end
		elseif get_extra_ability_uses < _num_stack_buffs then
			for j = 1, _num_stack_buffs - get_extra_ability_uses do
				local num = _num_stack_buffs - j + 1

				_buff_extension:remove_buff(_stack_buffs[num])

				_stack_buffs[num] = nil
			end
		end

		self._num_stack_buffs = get_extra_ability_uses
	end
end

PassiveAbilityThornsister.on_talents_changed = function (self, arg_7_1, arg_7_2)
	-- function 7
	if arg_7_1 ~= self._owner_unit then
		return
	end

	local _buff_extension = self._buff_extension

	if not _buff_extension then
		local _cooldown_buff = self._cooldown_buff

		if not (not _cooldown_buff and _cooldown_buff.is_stale) then
			_buff_extension:remove_buff(_cooldown_buff.id)
		end

		self._cooldown_buff = nil

		local _stack_buffs = self._stack_buffs
		local _num_stack_buffs = self._num_stack_buffs

		for i = 1, _num_stack_buffs do
			local num = _num_stack_buffs - i + 1

			_buff_extension:remove_buff(_stack_buffs[num])

			_stack_buffs[num] = nil
		end

		self._num_stack_buffs = 0
	end

	self:_update_extra_abilities_info(arg_7_2)
end

PassiveAbilityThornsister._update_extra_abilities_info = function (self, arg_8_1)
	-- function 8
	if not arg_8_1 then
		return
	end

	local _career_extension = self._career_extension

	if not _career_extension then
		return
	end

	local max_stacks = self._ability_init_data.max_stacks

	if not arg_8_1:has_talent("kerillian_double_passive") then
		max_stacks = max_stacks + 1
	end

	_career_extension:update_extra_ability_uses_max(max_stacks)

	local cooldown = self._ability_init_data.cooldown

	if not arg_8_1:has_talent("kerillian_thorn_sister_faster_passive") then
		cooldown = cooldown * 0.5
	end

	_career_extension:update_extra_ability_charge(cooldown)
end
