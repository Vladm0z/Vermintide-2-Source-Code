-- chunkname: @scripts/managers/side/side.lua

SideRelations, SideRelationLookup = table.enum_lookup("ally", "enemy", "neutral")
Side = class(Side)

Side.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._name = arg_1_1.name
	self._units = {}
	self.units_lookup = {}
	self._num_units = 0
	self._player_units = {}
	self._enemy_sides = {}
	self.enemy_sides_lookup = {}
	self._enemy_units = {}
	self.enemy_units_lookup = {}
	self._num_enemy_units = 0
	self._enemy_player_units = {}
	self._allied_sides = {}
	self.allied_sides_lookup = {}
	self._allied_units = {}
	self.allied_units_lookup = {}
	self._num_allied_units = 0
	self._neutral_sides = {}
	self.neutral_sides_lookup = {}
	self.party = arg_1_1.party
	self.side_id = arg_1_2
	self.broadphase_category = {
		arg_1_1.name
	}
	self.enemy_broadphase_categories = {}
	self.ally_broadphase_categories = {}
	self.neutral_broadphase_categories = {}
	self._broadphase_categories_by_relation = {
		[SideRelations.ally] = self.ally_broadphase_categories,
		[SideRelations.enemy] = self.enemy_broadphase_categories,
		[SideRelations.neutral] = self.neutral_broadphase_categories
	}

	local add_these_settings = arg_1_1.add_these_settings

	if not add_these_settings then
		for k, v in pairs(add_these_settings) do
			fassert(not self[k], "Mechanism trying to add setting that is already defined")

			self[k] = v
		end
	end

	self.has_bots = false
	self.PLAYER_UNITS = {}
	self.PLAYER_POSITIONS = {}
	self.PLAYER_AND_BOT_UNITS = {}
	self.PLAYER_AND_BOT_POSITIONS = {}
	self.NON_DISABLED_PLAYER_AND_BOT_UNITS = {}
	self.ENEMY_PLAYER_UNITS = {}
	self.ENEMY_PLAYER_POSITIONS = {}
	self.ENEMY_PLAYER_AND_BOT_UNITS = {}
	self.ENEMY_PLAYER_AND_BOT_POSITIONS = {}
	self.VALID_ENEMY_PLAYERS_AND_BOTS = {}
	self.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS = {}
	self.AI_TARGET_UNITS = {}
end

Side.set_relation = function (self, arg_2_1, arg_2_2)
	-- function 2
	local var_2_0
	local var_2_1
	local var_2_2

	if arg_2_1 == SideRelations.enemy then
		var_2_0 = self._enemy_sides
		var_2_1 = self.enemy_sides_lookup
		var_2_2 = self.enemy_broadphase_categories
	elseif arg_2_1 == SideRelations.ally then
		var_2_0 = self._allied_sides
		var_2_1 = self.allied_sides_lookup
		var_2_2 = self.ally_broadphase_categories
	elseif arg_2_1 == SideRelations.neutral then
		var_2_0 = self._neutral_sides
		var_2_1 = self.neutral_sides_lookup
		var_2_2 = self.neutral_broadphase_categories
	else
		ferror("Unknown relation (%s)", arg_2_1)
	end

	for i = 1, #arg_2_2 do
		local var_2_3 = arg_2_2[i]

		var_2_0[#var_2_0 + 1] = var_2_3
		var_2_1[var_2_3] = true
		var_2_2[#var_2_2 + 1] = var_2_3:name()
	end
end

Side.name = function (self)
	-- function 3
	return self._name
end

Side.get_enemy_sides = function (self)
	-- function 4
	return self._enemy_sides
end

Side.get_allied_sides = function (self)
	-- function 5
	return self._allied_sides
end

Side.add_unit = function (self, arg_6_1)
	-- function 6
	fassert(self.units_lookup[arg_6_1] == nil, "Unit is already added to side.")

	local num = self._num_units + 1

	self._units[num] = arg_6_1
	self.units_lookup[arg_6_1] = num
	self._num_units = num
end

Side.remove_unit = function (self, arg_7_1)
	-- function 7
	fassert(self.units_lookup[arg_7_1] ~= nil, "Unit has not been added or is already removed from side.")

	local _units = self._units
	local _num_units = self._num_units
	local units_lookup = self.units_lookup
	local var_7_3 = units_lookup[arg_7_1]
	local var_7_4 = _units[_num_units]

	_units[var_7_3] = var_7_4
	units_lookup[var_7_4] = var_7_3
	_units[_num_units] = nil
	units_lookup[arg_7_1] = nil
	self._num_units = _num_units - 1
end

Side.broadphase_categories_by_relation = function (self, arg_8_1)
	-- function 8
	return self._broadphase_categories_by_relation[arg_8_1]
end

Side.add_enemy_unit = function (self, arg_9_1)
	-- function 9
	fassert(self.enemy_units_lookup[arg_9_1] == nil, "Enemy unit is already added to side.")

	local num = self._num_enemy_units + 1

	self._enemy_units[num] = arg_9_1
	self.enemy_units_lookup[arg_9_1] = num
	self._num_enemy_units = num
end

Side.remove_enemy_unit = function (self, arg_10_1)
	-- function 10
	fassert(self.enemy_units_lookup[arg_10_1] ~= nil, "Enemy unit has not been added or is already removed from side.")

	local _enemy_units = self._enemy_units
	local _num_enemy_units = self._num_enemy_units
	local enemy_units_lookup = self.enemy_units_lookup
	local var_10_3 = enemy_units_lookup[arg_10_1]
	local var_10_4 = _enemy_units[_num_enemy_units]

	_enemy_units[var_10_3] = var_10_4
	enemy_units_lookup[var_10_4] = var_10_3
	_enemy_units[_num_enemy_units] = nil
	enemy_units_lookup[arg_10_1] = nil
	self._num_enemy_units = _num_enemy_units - 1
end

Side.add_allied_unit = function (self, arg_11_1)
	-- function 11
	fassert(self.allied_units_lookup[arg_11_1] == nil, "Ally unit is already added to side.")

	local num = self._num_allied_units + 1

	self._allied_units[num] = arg_11_1
	self.allied_units_lookup[arg_11_1] = num
	self._num_allied_units = num
end

Side.remove_allied_unit = function (self, arg_12_1)
	-- function 12
	fassert(self.allied_units_lookup[arg_12_1] ~= nil, "Ally unit has not been added or is already removed from side.")

	local _allied_units = self._allied_units
	local _num_allied_units = self._num_allied_units
	local allied_units_lookup = self.allied_units_lookup
	local var_12_3 = allied_units_lookup[arg_12_1]
	local var_12_4 = _allied_units[_num_allied_units]

	_allied_units[var_12_3] = var_12_4
	allied_units_lookup[var_12_4] = var_12_3
	_allied_units[_num_allied_units] = nil
	allied_units_lookup[arg_12_1] = nil
	self._num_allied_units = _num_allied_units - 1
end

Side.add_player_unit = function (self, arg_13_1)
	-- function 13
	local _player_units = self._player_units

	fassert(table.find(_player_units, arg_13_1) == nil, "player_unit has already been added to side.")

	_player_units[#_player_units + 1] = arg_13_1
end

Side.remove_player_unit = function (self, arg_14_1)
	-- function 14
	local _player_units = self._player_units
	local find = table.find(_player_units, arg_14_1)

	fassert(find ~= false, "player_unit did not get added or has already been removed from side.")
	table.swap_delete(_player_units, find)
end

Side.add_enemy_player_unit = function (self, arg_15_1)
	-- function 15
	local _enemy_player_units = self._enemy_player_units

	fassert(table.find(_enemy_player_units, arg_15_1) == nil, "player_unit has already been added as an enemy.")

	_enemy_player_units[#_enemy_player_units + 1] = arg_15_1
end

Side.remove_enemy_player_unit = function (self, arg_16_1)
	-- function 16
	local _enemy_player_units = self._enemy_player_units
	local find = table.find(_enemy_player_units, arg_16_1)

	fassert(find ~= nil, "player_unit did not get added or has already been removed as an enemy.")
	table.swap_delete(_enemy_player_units, find)
end

Side.player_units = function (self)
	-- function 17
	return self._player_units
end

Side.enemy_player_units = function (self)
	-- function 18
	return self._enemy_player_units
end

Side.enemy_units = function (self)
	-- function 19
	return self._enemy_units
end
