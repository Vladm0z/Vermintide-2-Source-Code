-- chunkname: @scripts/managers/side/side_manager.lua

require("scripts/managers/side/side")

local testify = script_data.testify

testify = not testify and require("scripts/managers/side/side_manager_testify")
SideManager = class(SideManager)
ALL_PLAYER_AND_BOT_UNITS = {}

SideManager.init = function (self, arg_1_1)
	-- function 1
	arg_1_1[0] = {
		name = "undecided",
		relations = {},
		available_profiles = {},
		party = Managers.party:get_party(0)
	}
	self._sides, self._side_lookup = self:_create_sides(arg_1_1)

	self:_setup_relations(arg_1_1, self._sides, self._side_lookup)

	self.side_by_party = self:_setup_side_by_party(self._sides)
	self.side_by_unit = {}
	self._player_units_lookup = {}
end

SideManager._create_sides = function (arg_2_0, arg_2_1)
	-- function 2
	local tbl = {}
	local tbl_2 = {}

	for i = 0, #arg_2_1 do
		local var_2_2 = arg_2_1[i]
		local name = var_2_2.name

		fassert(tbl_2[name] == nil, "Side with the same name exists in side_composition, side_name(%s)", name)

		local var_2_4 = Side:new(var_2_2, i)

		tbl[i] = var_2_4
		tbl_2[name] = var_2_4
	end

	fassert(table.is_empty(tbl) == false, "No sides specified")

	return tbl, tbl_2
end

SideManager._setup_relations = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	for i = 0, #arg_3_1 do
		local var_3_0 = arg_3_1[i]
		local var_3_1 = arg_3_2[i]
		local relations = var_3_0.relations

		for k, v in pairs(relations) do
			local tbl = {}

			for l = 1, #v do
				local var_3_4 = v[l]

				fassert(arg_3_3[var_3_4], "Side (%s) does not exist", var_3_4)

				tbl[#tbl + 1] = arg_3_3[var_3_4]
			end

			var_3_1:set_relation(k, tbl)
		end

		var_3_1:set_relation("ally", {
			var_3_1
		})
	end
end

SideManager._setup_side_by_party = function (arg_4_0, arg_4_1)
	-- function 4
	local tbl = {}

	for i = 0, #arg_4_1 do
		local var_4_1 = arg_4_1[i]
		local party = var_4_1.party

		if not party then
			fassert(tbl[party] == nil, "Party has multiple sides, this is not supported (party_id==%s)", tostring(party.party_id))

			tbl[party] = var_4_1
		end
	end

	return tbl
end

SideManager.sides = function (self)
	-- function 5
	return self._sides
end

SideManager.get_side = function (self, arg_6_1)
	-- function 6
	return self._sides[arg_6_1]
end

SideManager.get_side_from_name = function (self, arg_7_1)
	-- function 7
	return self._side_lookup[arg_7_1]
end

SideManager.get_party_from_side_name = function (self, arg_8_1)
	-- function 8
	return self._side_lookup[arg_8_1].party
end

SideManager.versus_is_hero = function (self, arg_9_1)
	-- function 9
	local var_9_0 = self.side_by_unit[arg_9_1]

	if not (not var_9_0 and var_9_0:name() == "heroes") then
		return
	end

	return not not Managers.player:owner(arg_9_1)
end

SideManager.versus_is_dark_pact = function (self, arg_10_1)
	-- function 10
	local var_10_0 = self.side_by_unit[arg_10_1]

	return not var_10_0 and var_10_0:name() == "dark_pact"
end

SideManager.add_unit_to_side = function (self, arg_11_1, arg_11_2)
	-- function 11
	local var_11_0 = self._sides[arg_11_2]

	var_11_0:add_unit(arg_11_1)

	self.side_by_unit[arg_11_1] = var_11_0

	local get_enemy_sides = var_11_0:get_enemy_sides()

	for i = 1, #get_enemy_sides do
		get_enemy_sides[i]:add_enemy_unit(arg_11_1)
	end

	local get_allied_sides = var_11_0:get_allied_sides()

	for j = 1, #get_allied_sides do
		get_allied_sides[j]:add_allied_unit(arg_11_1)
	end

	return var_11_0
end

SideManager.remove_unit_from_side = function (self, arg_12_1)
	-- function 12
	local var_12_0 = self.side_by_unit[arg_12_1]

	if not var_12_0 then
		return
	end

	local get_enemy_sides = var_12_0:get_enemy_sides()

	for i = 1, #get_enemy_sides do
		get_enemy_sides[i]:remove_enemy_unit(arg_12_1)
	end

	local get_allied_sides = var_12_0:get_allied_sides()

	for j = 1, #get_allied_sides do
		get_allied_sides[j]:remove_allied_unit(arg_12_1)
	end

	self.side_by_unit[arg_12_1] = nil

	var_12_0:remove_unit(arg_12_1)
end

SideManager.add_player_unit_to_side = function (self, arg_13_1, arg_13_2)
	-- function 13
	self:add_unit_to_side(arg_13_1, arg_13_2)

	local var_13_0 = self._sides[arg_13_2]

	var_13_0:add_player_unit(arg_13_1)

	local get_enemy_sides = var_13_0:get_enemy_sides()

	for i = 1, #get_enemy_sides do
		get_enemy_sides[i]:add_enemy_player_unit(arg_13_1)
	end

	self._player_units_lookup[arg_13_1] = true
end

SideManager.remove_player_unit_from_side = function (self, arg_14_1)
	-- function 14
	self._player_units_lookup[arg_14_1] = nil

	local var_14_0 = self.side_by_unit[arg_14_1]
	local get_enemy_sides = var_14_0:get_enemy_sides()

	for i = 1, #get_enemy_sides do
		get_enemy_sides[i]:remove_enemy_player_unit(arg_14_1)
	end

	var_14_0:remove_player_unit(arg_14_1)
	self:remove_unit_from_side(arg_14_1)
	self:_remove_player_unit_from_lists(arg_14_1)

	local owner = Managers.player:owner(arg_14_1)

	Managers.state.event:trigger("on_player_left_side", owner:unique_id(), owner:local_player_id(), var_14_0.side_id)
end

SideManager.is_enemy = function (self, arg_15_1, arg_15_2)
	-- function 15
	local var_15_0 = self.side_by_unit[arg_15_1]

	return not var_15_0 and var_15_0.enemy_units_lookup[arg_15_2], var_15_0
end

SideManager.is_enemy_by_side = function (arg_16_0, arg_16_1, arg_16_2)
	-- function 16
	if not (arg_16_1 == nil or arg_16_2 ~= nil) then
		return false
	end

	if arg_16_1.enemy_sides_lookup[arg_16_2] == nil then
		return false
	end

	return true
end

SideManager.is_enemy_by_party = function (self, arg_17_1, arg_17_2)
	-- function 17
	return self:is_enemy_by_side(self.side_by_party[arg_17_1], self.side_by_party[arg_17_2])
end

SideManager.is_enemy_by_player = function (self, arg_18_1, arg_18_2)
	-- function 18
	local get_party_from_unique_id = Managers.party:get_party_from_unique_id(arg_18_1:unique_id())
	local get_party_from_unique_id_2 = Managers.party:get_party_from_unique_id(arg_18_2:unique_id())

	return self:is_enemy_by_party(get_party_from_unique_id, get_party_from_unique_id_2)
end

SideManager.is_ally = function (self, arg_19_1, arg_19_2)
	-- function 19
	local var_19_0 = self.side_by_unit[arg_19_1]

	return not var_19_0 and var_19_0.allied_units_lookup[arg_19_2], var_19_0
end

SideManager.is_ally_by_side = function (arg_20_0, arg_20_1, arg_20_2)
	-- function 20
	if arg_20_1 == nil then
		return false
	end

	if arg_20_1.allied_sides_lookup[arg_20_2] == nil then
		return false
	end

	return true
end

SideManager.is_player_friendly_fire = function (self, arg_21_1, arg_21_2)
	-- function 21
	if not (not arg_21_1 and arg_21_2) then
		return false
	end

	local _player_units_lookup = self._player_units_lookup

	if not (not _player_units_lookup[arg_21_1] and _player_units_lookup[arg_21_2]) then
		return false
	end

	local var_21_1 = self.side_by_unit[arg_21_1]
	local var_21_2 = self.side_by_unit[arg_21_2]

	if not (not var_21_1 and var_21_2) then
		return false
	end

	return var_21_1 == var_21_2
end

SideManager.destroy = function (self)
	-- function 22
	self._sides = nil
	self.side_by_unit = nil
	self._player_units_lookup = nil
end

SideManager.remove_aggro_unit = function (self, arg_23_1, arg_23_2)
	-- function 23
	local get_enemy_sides = self._sides[arg_23_1]:get_enemy_sides()
	local count = #get_enemy_sides

	for i = 1, count do
		local AI_TARGET_UNITS = get_enemy_sides[i].AI_TARGET_UNITS
		local count_2 = #AI_TARGET_UNITS

		for j = 1, count_2 do
			if arg_23_2 == AI_TARGET_UNITS[j] then
				AI_TARGET_UNITS[j] = AI_TARGET_UNITS[count_2]
				AI_TARGET_UNITS[count_2] = nil

				break
			end
		end
	end
end

SideManager.update_frame_tables = function (self)
	-- function 24
	table.clear(ALL_PLAYER_AND_BOT_UNITS)

	local _sides = self._sides
	local count = #_sides

	for i = 1, count do
		local var_24_2 = _sides[i]

		self:_update_frame_tables(var_24_2, ALL_PLAYER_AND_BOT_UNITS)
	end

	for j = 1, count do
		local var_24_3 = _sides[j]

		self:_update_ally_frame_tables(var_24_3)
		self:_update_enemy_frame_tables(var_24_3)
	end
end

local alive = Unit.alive

local function fn(arg_25_0)
	-- function 25
	local var_25_0 = alive(arg_25_0)

	var_25_0 = not var_25_0 and not ScriptUnit.extension(arg_25_0, "status_system"):is_ready_for_assisted_respawn()

	return var_25_0
end

local function fn_2(arg_26_0)
	-- function 26
	local extension = ScriptUnit.extension(arg_26_0, "status_system")
	local flag = true

	if not extension.in_ghost_mode then
		flag = false
	end

	return not not extension:is_in_end_zone() or not not extension:is_invisible() or not flag or not not extension.spawn_grace or HEALTH_ALIVE[arg_26_0]
end

SideManager.is_valid_target = fn_2

local function fn_3(arg_27_0)
	-- function 27
	if not ALIVE[arg_27_0] then
		return false
	end

	local has_extension = ScriptUnit.has_extension(arg_27_0, "status_system")

	if not has_extension then
		return not not has_extension.ready_for_assisted_respawn or not not has_extension:is_in_end_zone() or not not has_extension:is_invisible() or not not has_extension.spawn_grace or HEALTH_ALIVE[arg_27_0]
	end

	return true
end

local POSITION_LOOKUP = POSITION_LOOKUP

SideManager._update_frame_tables = function (arg_28_0, arg_28_1, arg_28_2)
	-- function 28
	local PLAYER_UNITS = arg_28_1.PLAYER_UNITS
	local PLAYER_POSITIONS = arg_28_1.PLAYER_POSITIONS
	local count = #arg_28_2
	local PLAYER_AND_BOT_UNITS = arg_28_1.PLAYER_AND_BOT_UNITS
	local PLAYER_AND_BOT_POSITIONS = arg_28_1.PLAYER_AND_BOT_POSITIONS
	local num = 0
	local num_2 = 0
	local player_units = arg_28_1:player_units()
	local count_2 = #player_units
	local player = Managers.player
	local flag = false

	for i = 1, count_2 do
		local var_28_11 = player_units[i]

		if not fn(var_28_11) then
			local var_28_12 = POSITION_LOOKUP[var_28_11]

			num_2 = num_2 + 1
			PLAYER_AND_BOT_UNITS[num_2] = var_28_11
			PLAYER_AND_BOT_POSITIONS[num_2] = var_28_12
			arg_28_2[count + i] = var_28_11

			if not player:owner(var_28_11):is_player_controlled() then
				num = num + 1
				PLAYER_UNITS[num] = var_28_11
				PLAYER_POSITIONS[num] = var_28_12
			else
				flag = true
			end
		end
	end

	arg_28_1.has_bots = flag

	local num_3 = num + 1

	while not PLAYER_UNITS[num_3] do
		PLAYER_UNITS[num_3] = nil
		PLAYER_POSITIONS[num_3] = nil
		num_3 = num_3 + 1
	end

	local num_4 = num_2 + 1

	while not PLAYER_AND_BOT_UNITS[num_4] do
		PLAYER_AND_BOT_UNITS[num_4] = nil
		PLAYER_AND_BOT_POSITIONS[num_4] = nil
		num_4 = num_4 + 1
	end
end

SideManager._update_ally_frame_tables = function (arg_29_0, arg_29_1)
	-- function 29
	local PLAYER_AND_BOT_UNITS = arg_29_1.PLAYER_AND_BOT_UNITS
	local num = 0
	local NON_DISABLED_PLAYER_AND_BOT_UNITS = arg_29_1.NON_DISABLED_PLAYER_AND_BOT_UNITS

	for i = 1, #PLAYER_AND_BOT_UNITS do
		local var_29_3 = PLAYER_AND_BOT_UNITS[i]
		local has_extension = ScriptUnit.has_extension(var_29_3, "status_system")

		if not (not has_extension and has_extension:is_disabled_non_temporarily()) then
			num = num + 1
			NON_DISABLED_PLAYER_AND_BOT_UNITS[num] = var_29_3
		end
	end

	for j = num + 1, #NON_DISABLED_PLAYER_AND_BOT_UNITS do
		NON_DISABLED_PLAYER_AND_BOT_UNITS[j] = nil
	end
end

SideManager._update_enemy_frame_tables = function (arg_30_0, arg_30_1)
	-- function 30
	local ENEMY_PLAYER_UNITS = arg_30_1.ENEMY_PLAYER_UNITS
	local ENEMY_PLAYER_POSITIONS = arg_30_1.ENEMY_PLAYER_POSITIONS
	local ENEMY_PLAYER_AND_BOT_UNITS = arg_30_1.ENEMY_PLAYER_AND_BOT_UNITS
	local ENEMY_PLAYER_AND_BOT_POSITIONS = arg_30_1.ENEMY_PLAYER_AND_BOT_POSITIONS
	local VALID_ENEMY_PLAYERS_AND_BOTS = arg_30_1.VALID_ENEMY_PLAYERS_AND_BOTS
	local VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS = arg_30_1.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS

	table.clear(VALID_ENEMY_PLAYERS_AND_BOTS)
	table.clear(VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS)

	local num = 0
	local num_2 = 0
	local enemy_player_units = arg_30_1:enemy_player_units()
	local count = #enemy_player_units
	local player = Managers.player

	for i = 1, count do
		local var_30_11 = enemy_player_units[i]

		if not fn(var_30_11) then
			local var_30_12 = POSITION_LOOKUP[var_30_11]

			num_2 = num_2 + 1
			ENEMY_PLAYER_AND_BOT_UNITS[num_2] = var_30_11
			ENEMY_PLAYER_AND_BOT_POSITIONS[num_2] = var_30_12
			VALID_ENEMY_PLAYERS_AND_BOTS[var_30_11] = true

			if not player:owner(var_30_11):is_player_controlled() then
				num = num + 1
				ENEMY_PLAYER_UNITS[num] = var_30_11
				ENEMY_PLAYER_POSITIONS[num] = var_30_12
			end

			if not fn_2(var_30_11) then
				VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[var_30_11] = true
			end
		end
	end

	local num_3 = num + 1

	while not ENEMY_PLAYER_UNITS[num_3] do
		ENEMY_PLAYER_UNITS[num_3] = nil
		ENEMY_PLAYER_POSITIONS[num_3] = nil
		num_3 = num_3 + 1
	end

	local num_4 = num_2 + 1

	while not ENEMY_PLAYER_AND_BOT_UNITS[num_4] do
		ENEMY_PLAYER_AND_BOT_UNITS[num_4] = nil
		ENEMY_PLAYER_AND_BOT_POSITIONS[num_4] = nil
		num_4 = num_4 + 1
	end

	local AI_TARGET_UNITS = arg_30_1.AI_TARGET_UNITS
	local system = Managers.state.entity:system("aggro_system")
	local get_enemy_sides = arg_30_1:get_enemy_sides()
	local count_2 = #get_enemy_sides
	local num_5 = 1

	for j = 1, count_2 do
		local var_30_20 = get_enemy_sides[j]
		local var_30_21 = system.aggroable_units[var_30_20.side_id]

		for k, v in pairs(var_30_21) do
			if not fn_3(k) then
				AI_TARGET_UNITS[num_5] = k
				num_5 = num_5 + 1
			end
		end
	end

	while not AI_TARGET_UNITS[num_5] do
		AI_TARGET_UNITS[num_5] = nil
		num_5 = num_5 + 1
	end
end

SideManager._remove_player_unit_from_lists = function (self, arg_31_1)
	-- function 31
	POSITION_LOOKUP[arg_31_1] = nil

	local _sides = self._sides
	local count = #_sides

	for i = 1, count do
		local var_31_2 = _sides[i]
		local PLAYER_UNITS = var_31_2.PLAYER_UNITS
		local PLAYER_POSITIONS = var_31_2.PLAYER_POSITIONS
		local count_2 = #PLAYER_UNITS

		for j = 1, count_2 do
			if arg_31_1 == PLAYER_UNITS[j] then
				PLAYER_UNITS[j] = PLAYER_UNITS[count_2]
				PLAYER_UNITS[count_2] = nil
				PLAYER_POSITIONS[j] = PLAYER_POSITIONS[count_2]
				PLAYER_POSITIONS[count_2] = nil

				break
			end
		end

		local PLAYER_AND_BOT_UNITS = var_31_2.PLAYER_AND_BOT_UNITS
		local PLAYER_AND_BOT_POSITIONS = var_31_2.PLAYER_AND_BOT_POSITIONS
		local count_3 = #PLAYER_AND_BOT_UNITS

		for k = 1, count_3 do
			if arg_31_1 == PLAYER_AND_BOT_UNITS[k] then
				PLAYER_AND_BOT_UNITS[k] = PLAYER_AND_BOT_UNITS[count_3]
				PLAYER_AND_BOT_UNITS[count_3] = nil
				PLAYER_AND_BOT_POSITIONS[k] = PLAYER_AND_BOT_POSITIONS[count_3]
				PLAYER_AND_BOT_POSITIONS[count_3] = nil

				break
			end
		end

		local ENEMY_PLAYER_UNITS = var_31_2.ENEMY_PLAYER_UNITS
		local ENEMY_PLAYER_POSITIONS = var_31_2.ENEMY_PLAYER_POSITIONS
		local count_4 = #ENEMY_PLAYER_UNITS

		for l = 1, count_4 do
			if arg_31_1 == ENEMY_PLAYER_UNITS[l] then
				ENEMY_PLAYER_UNITS[l] = ENEMY_PLAYER_UNITS[count_4]
				ENEMY_PLAYER_UNITS[count_4] = nil
				ENEMY_PLAYER_POSITIONS[l] = ENEMY_PLAYER_POSITIONS[count_4]
				ENEMY_PLAYER_POSITIONS[count_4] = nil

				break
			end
		end

		local ENEMY_PLAYER_AND_BOT_UNITS = var_31_2.ENEMY_PLAYER_AND_BOT_UNITS
		local ENEMY_PLAYER_AND_BOT_POSITIONS = var_31_2.ENEMY_PLAYER_AND_BOT_POSITIONS
		local count_5 = #ENEMY_PLAYER_AND_BOT_UNITS

		for i4 = 1, count_5 do
			if arg_31_1 == ENEMY_PLAYER_AND_BOT_UNITS[i4] then
				ENEMY_PLAYER_AND_BOT_UNITS[i4] = ENEMY_PLAYER_AND_BOT_UNITS[count_5]
				ENEMY_PLAYER_AND_BOT_UNITS[count_5] = nil
				ENEMY_PLAYER_AND_BOT_POSITIONS[i4] = ENEMY_PLAYER_AND_BOT_POSITIONS[count_5]
				ENEMY_PLAYER_AND_BOT_POSITIONS[count_5] = nil

				break
			end
		end

		var_31_2.VALID_ENEMY_PLAYERS_AND_BOTS[arg_31_1] = nil
		var_31_2.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[arg_31_1] = nil
	end
end

SideManager.get_side_from_player_unique_id = function (self, arg_32_1)
	-- function 32
	local party = Managers.party
	local party_id = party:get_status_from_unique_id(arg_32_1).party_id
	local get_party = party:get_party(party_id)

	return self.side_by_party[get_party]
end

SideManager.update_testify = function (arg_33_0, arg_33_1, arg_33_2)
	-- function 33
	Testify:poll_requests_through_handler(testify, arg_33_0)
end
