-- chunkname: @scripts/managers/game_mode/versus_dark_pact_career_delegator.lua

VersusDarkPactCareerDelegator = class(VersusDarkPactCareerDelegator)

local tbl = {
	default = {
		[0] = 1,
		0.5,
		0.25,
		0.125
	},
	vs_poison_wind_globadier = {
		[0] = 0.8,
		0.4,
		0.2,
		0.1
	}
}
local tbl_2 = {
	[1] = 0.25
}

VersusDarkPactCareerDelegator.init = function (self)
	-- function 1
	self._playable_boss_can_be_picked = false
	self._picks_per_career = {}
	self._picks_per_player = {}
	self._peer_picking_boss = nil
	self._rolled_careers_time_stamp = {}
	self._last_picked_by_player = {}

	Managers.state.event:register(self, "on_player_left_party", "on_player_left_party")
	Managers.state.event:register(self, "player_profile_assigned", "on_player_profile_assigned")

	self._mechanism = Managers.mechanism:game_mechanism()

	self:_override_available_profiles(GameModeSettings.versus)
	self:_initialize_custom_settings()
end

VersusDarkPactCareerDelegator._override_available_profiles = function (self, arg_2_1)
	-- function 2
	local mechanism_setting_for_title = Managers.mechanism:mechanism_setting_for_title("override_career_availability")

	if not self._bosses then
		self._bosses = table.shallow_copy(arg_2_1.dark_pact_boss_profiles)

		for i = #self._bosses, 1, -1 do
			if mechanism_setting_for_title[self._bosses[i]] == false then
				table.swap_delete(self._bosses, i)
			end
		end
	end

	if not self._all_careers then
		self._all_careers = table.shallow_copy(arg_2_1.dark_pact_profile_order)

		for j = #self._all_careers, 1, -1 do
			if mechanism_setting_for_title[self._all_careers[j]] == false then
				table.swap_delete(self._all_careers, j)
			end
		end
	end
end

VersusDarkPactCareerDelegator.destroy = function (arg_3_0)
	-- function 3
	Managers.state.event:unregister("on_player_left_party", arg_3_0)
	Managers.state.event:unregister("player_profile_assigned", arg_3_0)
	Managers.state.event:unregister("player_unit_relinquished", arg_3_0)
end

VersusDarkPactCareerDelegator._roll_career_options = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local tbl_2 = {}
	local alloc_table = FrameTable.alloc_table()

	for i = 1, arg_4_1 do
		alloc_table[i] = 0
	end

	local var_4_2 = self._picks_per_player[arg_4_3]

	var_4_2 = var_4_2 or {}
	self._picks_per_player[arg_4_3] = var_4_2

	for j = 1, #arg_4_2 do
		local var_4_3 = arg_4_2[j]
		local _picks_per_career = self._picks_per_career
		local var_4_5 = self._picks_per_career[var_4_3]

		var_4_5 = var_4_5 or 0
		_picks_per_career[var_4_3] = var_4_5

		local var_4_6 = self._picks_per_career[var_4_3]
		local var_4_7 = tbl[var_4_3]

		var_4_7 = var_4_7 or tbl.default

		local _weight_by_repetition = self:_weight_by_repetition(arg_4_3, var_4_3)
		local num = 1

		if not (not self._custom_settings_spawn_chance_multipliers and table.is_empty(self._custom_settings_spawn_chance_multipliers)) then
			num = self._custom_settings_spawn_chance_multipliers[var_4_3]
		end

		local random = math.random()
		local var_4_11 = var_4_7[var_4_6]

		var_4_11 = var_4_11 or 0

		local num_2 = random * var_4_11 * _weight_by_repetition * num
		local min = table.min(alloc_table)

		if num_2 >= alloc_table[min] then
			tbl_2[min] = var_4_3
			alloc_table[min] = num_2
		end
	end

	for k = 1, #tbl_2 do
		local var_4_14 = tbl_2[k]

		var_4_2[k] = var_4_14
		self._picks_per_career[var_4_14] = self._picks_per_career[var_4_14] + 1
	end

	return tbl_2
end

VersusDarkPactCareerDelegator.request_careers = function (self, arg_5_1)
	-- function 5
	printf("[DELEGATOR] requested careers, peer_id: %s", arg_5_1)
	self:_release_career_for_player(arg_5_1)

	local settings = Managers.state.game_mode:game_mode():settings()
	local _custom_num_special_pick_options = self._custom_num_special_pick_options

	_custom_num_special_pick_options = _custom_num_special_pick_options or settings.dark_pact_picking_rules.special_pick_options

	local _roll_career_options = self:_roll_career_options(_custom_num_special_pick_options, self._all_careers, arg_5_1)

	if not self._playable_boss_can_be_picked then
		if not DEDICATED_SERVER then
			cprint("[VS BOSS] added boss to picking list")
		elseif not Managers.state.network.is_server then
			print("[VS BOSS] added boss to picking list")
		end

		assert(self._peer_picking_boss == nil, "Peer_picking_boss needs to be nill, another player is picking the boss")

		self._peer_picking_boss = arg_5_1

		for i = 1, #self._bosses do
			local var_5_3 = self._bosses[i]

			_roll_career_options[#_roll_career_options + 1] = var_5_3

			table.insert(self._picks_per_player[arg_5_1], var_5_3)

			local _picks_per_career = self._picks_per_career
			local var_5_5 = self._picks_per_career[var_5_3]

			var_5_5 = var_5_5 or 0
			_picks_per_career[var_5_3] = var_5_5 + 1

			self:set_playable_boss_can_be_picked(false)
		end
	end

	self._rolled_careers_time_stamp[arg_5_1] = Managers.time:time("game")

	return _roll_career_options, "all"
end

VersusDarkPactCareerDelegator.set_playable_boss_can_be_picked = function (self, arg_6_1)
	-- function 6
	if not (self._custom_setting_no_bosses or #self._bosses ~= 0) then
		return
	end

	if not DEDICATED_SERVER then
		cprint("[VS BOSS] setting is_playble_boss_next")
	elseif not Managers.state.network.is_server then
		printf("[Playable_bosses] setting is_playble_boss_next %s", arg_6_1)
	end

	if self._peer_picking_boss ~= nil or not arg_6_1 then
		self._playable_boss_can_be_picked = true
	elseif not arg_6_1 then
		self._playable_boss_can_be_picked = false
	else
		print("[VS BOSS] self._playable_boss_can_be_picked was not sett")
	end
end

VersusDarkPactCareerDelegator.get_playable_boss_can_be_picked = function (self)
	-- function 7
	return self._playable_boss_can_be_picked
end

VersusDarkPactCareerDelegator.on_player_profile_assigned = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	local name = SPProfiles[arg_8_3].careers[arg_8_4].name
	local settings = Managers.state.game_mode:game_mode():settings()

	if not self._picks_per_player[arg_8_1] then
		return
	end

	if not (table.contains(settings.dark_pact_profile_order, name) or table.contains(GameModeSettings.versus.dark_pact_boss_profiles, name)) then
		return
	end

	self:_career_picked(arg_8_1, name)
end

VersusDarkPactCareerDelegator.on_player_left_party = function (self, arg_9_1)
	-- function 9
	self:_release_career_for_player(arg_9_1)

	self._picks_per_player[arg_9_1] = nil
end

VersusDarkPactCareerDelegator._career_picked = function (self, arg_10_1, arg_10_2)
	-- function 10
	self:_picking_telemetry(arg_10_1, arg_10_2)
	self:_release_career_for_player(arg_10_1)

	local _picks_per_career = self._picks_per_career
	local var_10_1 = self._picks_per_career[arg_10_2]

	var_10_1 = var_10_1 or 0
	_picks_per_career[arg_10_2] = var_10_1 + 1

	local var_10_2 = self._picks_per_player[arg_10_1]

	var_10_2 = var_10_2 or {}
	self._picks_per_player[arg_10_1] = var_10_2

	if not (not self._peer_picking_boss and arg_10_1 ~= self._peer_picking_boss) then
		if not table.contains(self._bosses, arg_10_2) then
			self._peer_picking_boss = nil
		else
			self._peer_picking_boss = nil

			self:set_playable_boss_can_be_picked(true)
		end
	end

	var_10_2[1] = arg_10_2

	self:_register_player_career(arg_10_1, arg_10_2)
end

VersusDarkPactCareerDelegator._release_career_for_player = function (self, arg_11_1)
	-- function 11
	local var_11_0 = self._picks_per_player[arg_11_1]

	if not var_11_0 then
		for i = 1, #var_11_0 do
			local var_11_1 = var_11_0[i]

			self._picks_per_career[var_11_1] = self._picks_per_career[var_11_1] - 1

			printf("[DELEGATOR] releasing career: %s", var_11_0[i])

			var_11_0[i] = nil
		end
	end
end

VersusDarkPactCareerDelegator.update = function (arg_12_0)
	-- function 12
	return
end

VersusDarkPactCareerDelegator._picking_telemetry = function (self, arg_13_1, arg_13_2)
	-- function 13
	local settings = Managers.state.game_mode:game_mode():settings()

	if not (table.contains(settings.dark_pact_profile_order, arg_13_2) or table.contains(GameModeSettings.versus.dark_pact_boss_profiles, arg_13_2)) then
		return
	end

	if not Managers.player:player_from_peer_id(arg_13_1) then
		return
	end

	if not self._picks_per_player[arg_13_1] then
		return
	end

	local get_peer_backend_id = self._mechanism:get_peer_backend_id(arg_13_1)

	get_peer_backend_id = get_peer_backend_id or "offline backend"

	local shallow_copy = table.shallow_copy(self._picks_per_player[arg_13_1])
	local match_id = Managers.mechanism:game_mechanism():match_id()
	local num = Managers.time:time("game") - self._rolled_careers_time_stamp[arg_13_1]
	local PLATFORM = PLATFORM
	local BUILD = BUILD

	Managers.telemetry_events:versus_pactsworn_picking(match_id, get_peer_backend_id, shallow_copy, arg_13_2, num, PLATFORM, BUILD)
end

VersusDarkPactCareerDelegator._weight_by_repetition = function (self, arg_14_1, arg_14_2)
	-- function 14
	local var_14_0 = self._last_picked_by_player[arg_14_1]

	if not var_14_0 then
		return 1
	end

	for i = 1, #var_14_0 do
		if var_14_0[i] == arg_14_2 then
			return tbl_2[i]
		end
	end

	return 1
end

VersusDarkPactCareerDelegator._register_player_career = function (self, arg_15_1, arg_15_2)
	-- function 15
	local var_15_0 = self._last_picked_by_player[arg_15_1]

	var_15_0 = var_15_0 or {}
	self._last_picked_by_player[arg_15_1] = var_15_0

	table.insert(var_15_0, 1, arg_15_2)

	for i = #tbl_2 + 1, #var_15_0 do
		var_15_0[i] = nil
	end
end

VersusDarkPactCareerDelegator._initialize_custom_settings = function (self)
	-- function 16
	local mechanism_try_call, var_16_1, var_16_2 = Managers.mechanism:mechanism_try_call("get_custom_game_setting", "num_pactsworn_picking_options")

	if not var_16_2 then
		return
	end

	if not var_16_1 then
		self._custom_num_special_pick_options = var_16_1
	end

	local _all_careers = self._all_careers

	self._custom_settings_spawn_chance_multipliers = {}

	local num = 0

	for i = 1, #_all_careers do
		local var_16_5 = _all_careers[i]
		local str = var_16_5 .. "_spawn_chance_multiplier"
		local mechanism_try_call_2, var_16_8, var_16_9 = Managers.mechanism:mechanism_try_call("get_custom_game_setting", str)

		if not mechanism_try_call and not var_16_2 and not var_16_8 then
			self._custom_settings_spawn_chance_multipliers[var_16_5] = var_16_8

			if var_16_8 ~= 0 then
				num = num + 1
			end
		end
	end

	local _bosses = self._bosses
	local tbl = {}

	for j = 1, #self._bosses do
		local var_16_12 = _bosses[j]
		local str_2 = var_16_12 .. "_spawn_chance_multiplier"
		local mechanism_try_call_3, var_16_15, var_16_16 = Managers.mechanism:mechanism_try_call("get_custom_game_setting", str_2)

		if not (var_16_15 == "default" or var_16_15 == false) then
			self._custom_settings_spawn_chance_multipliers[var_16_12] = var_16_15
			self._all_careers[#self._all_careers + 1] = var_16_12
			num = num + 1
		elseif var_16_15 == "default" then
			tbl[#tbl + 1] = var_16_12
		end
	end

	self._bosses = tbl
	self._custom_setting_no_bosses = #self._bosses == 0

	if num == 0 then
		table.clear(self._custom_settings_spawn_chance_multipliers)
	elseif num < self._custom_num_special_pick_options then
		self._custom_num_special_pick_options = num
	end
end
