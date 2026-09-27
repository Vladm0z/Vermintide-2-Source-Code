-- chunkname: @scripts/managers/achievements/achievement_manager.lua

require("scripts/managers/achievements/achievement_templates")

local scripts_managers_achievements_achievements_outline = require("scripts/managers/achievements/achievements_outline")
local var_0_1 = rawget(_G, "World")
local var_0_2 = rawget(_G, "script_data")
local var_0_3 = rawget(_G, "Color")
local var_0_4 = rawget(_G, "Gui")
local num = 1
local num_2 = 2
local num_3 = 3
local num_4 = 4

if not IS_CONSOLE then
	local tbl = {}
	local achievements = AchievementTemplates.achievements
	local categories = scripts_managers_achievements_achievements_outline.categories

	for i, v in ipairs(categories) do
		table.clear(tbl)

		local entries = v.entries

		for k, v_2 in pairs(entries) do
			if not achievements[v_2].disable_on_consoles then
				tbl[#tbl + 1] = k
			end
		end

		for i4 = #tbl, 1, -1 do
			local var_0_13 = tbl[i4]
			local var_0_14 = entries[var_0_13]

			table.remove(entries, var_0_13)
			Application.warning(string.format("### [AchievementManager] Stripping %q for consoles", var_0_14))
		end
	end
end

AchievementManager = class(AchievementManager)

local num_5 = 1

AchievementManager.STORE_COMPLETED_LEVEL = false

AchievementManager.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self.initialized = false
	self.world = arg_1_1
	self._statistics_db = arg_1_2
	self._event_mappings = {}
	self._template_event_data = {}
	self._templates = {}
	self._unlocked_achievements = {}
	self._unlock_tasks = {}
	self._available_careers = {}
	self._achievement_data = {}
	self._incompleted_achievements = {}
	self._state_completed_achievements = {}
	self._timed_events = {}
	self._canceled_timed_events_n = 0
	self._canceled_timed_events = {}
	self._platform_achievements_to_verify = {}
	self._verify_platform_achievements_data = {}
	self._backend_interface_loot = Managers.backend:get_interface("loot")

	if IS_WINDOWS or not IS_LINUX then
		if not (not rawget(_G, "Steam") and GameSettingsDevelopment.network_mode ~= "steam") then
			self.platform = "steam"
		else
			self.platform = "debug"
		end
	elseif not IS_PS4 then
		self.platform = "ps4"
	elseif not IS_XB1 then
		self.platform = "xb1"
	else
		self.platform = "debug"
	end

	if not GameSettingsDevelopment.achievements_disabled then
		self.platform = "debug"
	end

	local _event_mappings = self._event_mappings
	local num = 0

	for k, v in pairs(AchievementTemplates.achievements) do
		if not ((self.platform ~= "steam" or not v.ID_STEAM or not IS_PS4) and (v.ID_PS4 or not IS_XB1 or v.ID_XB1 or self.platform ~= "debug")) then
			local num_2 = num + 1

			self._templates[num_2] = v
			num = num_2
		end

		local events = v.events

		if not events then
			for i, v_2 in ipairs(events) do
				local _event_mappings_2 = self._event_mappings
				local var_1_5 = self._event_mappings[v_2]

				var_1_5 = var_1_5 or {}
				_event_mappings_2[v_2] = var_1_5
				self._event_mappings[v_2][#self._event_mappings[v_2] + 1] = v
				self._template_event_data[v.id] = {}
			end
		end
	end

	self._template_count = num
	self._curr_template_idx = 1
	self._platform_functions = require("scripts/managers/achievements/platform_" .. self.platform)

	assert(self._platform_functions, "Can't load platform functions for platform %s", self.platform)
	self._platform_functions.init(self)
	printf("[AchievementManager] Achievements using the %s platform", self.platform)
	self:event_enable_achievements(true)

	if num == 0 or var_0_2.settings.use_beta_mode or not Managers.state.game_mode:setting("disable_achievements") then
		self._enabled = false
	end

	Managers.state.event:register(self, "event_enable_achievements", "event_enable_achievements")

	self.initialized = true
end

AchievementManager.trigger_event = function (self, arg_2_1, ...)
	-- function 2
	if not GameSettingsDevelopment.read_only_backend then
		return
	end

	local _event_mappings = self._event_mappings
	local _template_event_data = self._template_event_data
	local var_2_2 = _event_mappings[arg_2_1]
	local _unlocked_achievements = self._unlocked_achievements
	local tbl = {
		...
	}

	if not var_2_2 then
		local local_player = Managers.player:local_player()

		if not local_player then
			return
		end

		local stats_id = local_player:stats_id()
		local _statistics_db = self._statistics_db

		table.clear(self._available_careers)

		local _available_careers = self._available_careers
		local player = Managers.player
		local human_players = player:human_players()

		if not human_players then
			for k, v in pairs(human_players) do
				local _profile_index = v._profile_index

				if not _profile_index then
					local player_unit = v.player_unit
					local flag = not player_unit and player:owner(player_unit)

					_profile_index = not flag and flag:profile_index()
				end

				if not _profile_index then
					local var_2_14 = SPProfiles[_profile_index]
					local flag_2 = not var_2_14 and var_2_14.careers[v._career_index]

					if not flag_2 then
						_available_careers[flag_2.display_name] = true
					end
				end
			end
		end

		for i, v_2 in ipairs(var_2_2) do
			local var_2_16 = _unlocked_achievements[v_2.id]
			local required_career = v_2.required_career
			local flag_3 = not required_career and _available_careers[required_career]
			local allow_in_inn = v_2.allow_in_inn

			allow_in_inn = allow_in_inn or not global_is_inside_inn

			local always_run = v_2.always_run

			if not allow_in_inn and not flag_3 and not var_2_16 and not always_run then
				v_2.on_event(_statistics_db, stats_id, _template_event_data[v_2.id], arg_2_1, tbl)
			end
		end
	end

	local event = Managers.state.event

	if not event then
		event:trigger("on_achievement_event", arg_2_1, tbl)
	end
end

AchievementManager.register_timed_event = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local time = Managers.time:time("game")
	local tbl = {
		arg_3_1,
		arg_3_2,
		arg_3_3,
		arg_3_4,
		valid = true
	}

	arg_3_0._timed_events[tbl] = time + (arg_3_3 or 0)

	return tbl
end

AchievementManager.cancel_timed_event = function (self, arg_4_1)
	-- function 4
	if not self._timed_events[arg_4_1] then
		arg_4_1.valid = false

		local num = self._canceled_timed_events_n + 1

		self._canceled_timed_events[num] = arg_4_1
		self._canceled_timed_events_n = num
	end
end

AchievementManager.get_registered_timed_event = function (self, arg_5_1)
	-- function 5
	return self._timed_events[arg_5_1]
end

AchievementManager.reset_timed_event = function (self, arg_6_1)
	-- function 6
	local var_6_0 = self._timed_events[arg_6_1]

	if not var_6_0 and not arg_6_1.valid then
		var_6_0[arg_6_1] = Managers.time:time("game") + var_6_0[num_3]

		return true
	end

	return false
end

AchievementManager._update_timed_events = function (self, arg_7_1, arg_7_2)
	-- function 7
	local _timed_events = self._timed_events
	local _canceled_timed_events = self._canceled_timed_events

	for i = 1, self._canceled_timed_events_n do
		_timed_events[_canceled_timed_events[i]] = nil
		_canceled_timed_events[i] = nil
	end

	self._canceled_timed_events_n = 0

	local stats_id = Managers.player:local_player():stats_id()
	local _statistics_db = self._statistics_db

	for k, v in pairs(_timed_events) do
		if v <= arg_7_2 then
			local var_7_4 = k[num]
			local var_7_5 = k[num_2]
			local var_7_6 = k[num_4]
			local var_7_7 = AchievementTemplates.achievements[var_7_4]
			local var_7_8 = self._template_event_data[var_7_7.id]

			var_7_7[var_7_5](_statistics_db, stats_id, var_7_8, var_7_6)
			self:cancel_timed_event(k)
		end
	end
end

AchievementManager.destroy = function (self)
	-- function 8
	Managers.state.event:unregister("event_enable_achievements", self)

	if not self.gui then
		var_0_1.destroy_gui(self.world, self.gui)

		self.gui = nil
	end

	self._timed_events = nil
end

AchievementManager.event_enable_achievements = function (self, arg_9_1)
	-- function 9
	self._enabled = arg_9_1
end

AchievementManager.is_enabled = function (self)
	-- function 10
	return self._enabled
end

AchievementManager.num_achievement_categories = function (arg_11_0)
	-- function 11
	return #scripts_managers_achievements_achievements_outline.categories
end

AchievementManager.update = function (self, arg_12_1, arg_12_2)
	-- function 12
	if not self._enabled and not self:_check_version_number() and not self:_check_initialized_achievements() and not self:_verify_platform_achievements() and not GameSettingsDevelopment.read_only_backend then
		return
	end

	if not self._error_timeout then
		self._error_timeout = self._error_timeout - arg_12_1

		if self._error_timeout < 0 then
			self._error_timeout = nil
		end

		return
	end

	local _platform_functions = self._platform_functions
	local update = _platform_functions.update

	if not update and not update(self) then
		return
	end

	local local_player = Managers.player:local_player()

	if not local_player then
		return
	end

	local _unlock_tasks = self._unlock_tasks
	local _unlocked_achievements = self._unlocked_achievements

	for k, v in pairs(_unlock_tasks) do
		local token = v.token
		local unlock_result, var_12_7 = _platform_functions.unlock_result(token, k)

		if not unlock_result then
			_unlock_tasks[k] = nil

			if var_12_7 == nil then
				if not v.achievement_completed then
					_unlocked_achievements[k] = true
				end
			else
				Application.warning("Unlocking achievement with id %s failed due to error message %s", k, tostring(var_12_7))

				self._error_timeout = 5

				return
			end
		end
	end

	if not (not self._console_achievement_check_delay and not (arg_12_2 < self._console_achievement_check_delay)) then
		self:_update_timed_events(arg_12_1, arg_12_2)

		return
	end

	local _curr_template_idx = self._curr_template_idx
	local var_12_9 = self._templates[_curr_template_idx]
	local id = var_12_9.id
	local _statistics_db = self._statistics_db
	local stats_id = local_player:stats_id()
	local _template_event_data = self._template_event_data

	if not (not not _unlocked_achievements[id] or not _unlock_tasks[id]) then
		local var_12_14
		local var_12_15
		local var_12_16
		local achievement_rewards_claimed = self._backend_interface_loot:achievement_rewards_claimed(var_12_9.id)

		if not _platform_functions.set_progress and not var_12_9.progress then
			local _achievement_progress = self:_achievement_progress(var_12_9.id, achievement_rewards_claimed)
			local var_12_19 = _achievement_progress[1]
			local var_12_20 = _achievement_progress[2]

			var_12_14, var_12_15, var_12_16 = _platform_functions.set_progress(var_12_9, var_12_19, var_12_20)
		else
			var_12_16 = self:_achievement_completed(var_12_9.id, achievement_rewards_claimed)

			if not var_12_16 then
				var_12_14, var_12_15 = _platform_functions.unlock(var_12_9)
			end
		end

		if not var_12_14 then
			if not IS_XB1 then
				self._console_achievement_check_delay = arg_12_2 + num_5
			end

			_unlock_tasks[id] = {
				token = var_12_14,
				achievement_completed = var_12_16
			}
		elseif not var_12_15 then
			Crashify.print_exception("[AchievementManager]", "ERROR: %s", var_12_15)
		end
	end

	local num = _curr_template_idx + 1

	if num > self._template_count then
		num = 1
	end

	self._curr_template_idx = num

	self:_check_for_completed_achievements()
	self:_update_timed_events(arg_12_1, arg_12_2)
end

AchievementManager.reset = function (self)
	-- function 13
	self._platform_functions.reset()

	self._unlocked_achievements = {}
	self._unlock_tasks = {}
end

AchievementManager.outline = function (self)
	-- function 14
	if not self.initialized then
		return nil, "AchievementManager not initialized"
	end

	return scripts_managers_achievements_achievements_outline
end

AchievementManager._search_sub_categories = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	-- function 15
	if not arg_15_1 then
		return
	end

	local flag = arg_15_3 or {}

	for i = 1, #arg_15_1 do
		local var_15_1 = arg_15_1[i]
		local name = var_15_1.name

		if not (arg_15_4 or name ~= arg_15_2) then
			local flag_2 = true
			local entries = var_15_1.entries

			if not entries then
				table.append(flag, entries)
			end

			self:_search_sub_categories(var_15_1.categories, arg_15_2, flag, flag_2)
		else
			self:_search_sub_categories(var_15_1.categories, arg_15_2, flag)
		end
	end

	return flag
end

AchievementManager.get_entries_from_category = function (self, arg_16_1)
	-- function 16
	return self:_search_sub_categories(scripts_managers_achievements_achievements_outline.categories, arg_16_1)
end

AchievementManager.get_data_by_id = function (self, arg_17_1)
	-- function 17
	local var_17_0 = self._achievement_data[arg_17_1]

	fassert(var_17_0, "Have not set up achievement (%s) yet.", arg_17_1)

	return var_17_0
end

AchievementManager.setup_achievement_data = function (self)
	-- function 18
	if not self._enabled then
		return
	end

	if not self.initialized then
		return nil, "AchievementManager not initialized"
	end

	local function fn(self, arg_19_1)
		-- function 19
		for i, v in ipairs(arg_19_1) do
			if not v.categories then
				fn(self, v.categories)
			end

			if not v.entries then
				local flag = true

				self:setup_achievement_data_from_list(v.entries, flag)
			end
		end

		if not table.is_empty(self._state_completed_achievements) then
			Managers.backend:get_interface("statistics"):save_state_completed_achievements(self._state_completed_achievements)
			Managers.backend:commit(true)
		end
	end

	fn(self, scripts_managers_achievements_achievements_outline.categories)
end

AchievementManager.setup_achievement_data_from_list = function (self, arg_20_1, arg_20_2)
	-- function 20
	if not self._enabled then
		return
	end

	local get_interface = Managers.backend:get_interface("statistics")
	local get_achievement_reward_levels = get_interface:get_achievement_reward_levels()

	for i, v in ipairs(arg_20_1) do
		self:_setup_achievement_data(v, get_achievement_reward_levels)
	end

	if not (arg_20_2 or table.is_empty(self._state_completed_achievements)) then
		get_interface:save_state_completed_achievements(self._state_completed_achievements)
		Managers.backend:commit(true)

		self._state_completed_achievements = {}
	end
end

AchievementManager.can_claim_achievement_rewards = function (self, arg_21_1)
	-- function 21
	if not self._enabled then
		return nil, "AchievementManager not enabled"
	end

	if not self.initialized then
		return nil, "AchievementManager not initialized"
	end

	local _backend_interface_loot = self._backend_interface_loot

	if not _backend_interface_loot:can_claim_achievement_rewards(arg_21_1) then
		return nil, "Achievement already claimed."
	end

	if not _backend_interface_loot:polling_reward() then
		return nil, "Achievement reward polling in progress."
	end

	return true
end

AchievementManager.can_claim_all_achievement_rewards = function (self, arg_22_1)
	-- function 22
	if not self._enabled then
		return nil, nil, "AchievementManager not enabled"
	end

	if not self.initialized then
		return nil, nil, "AchievementManager not initialized"
	end

	local can_claim_all_achievement_rewards, var_22_1, var_22_2 = self._backend_interface_loot:can_claim_all_achievement_rewards(arg_22_1)

	if not (not can_claim_all_achievement_rewards and not (#var_22_2 > 1)) then
		return var_22_1, var_22_2, "Some of the achievements have already been claimed!"
	end

	if not can_claim_all_achievement_rewards then
		return nil, nil, "None of the achievements could be claimed."
	end

	return var_22_1, nil, nil
end

AchievementManager.claim_reward = function (self, arg_23_1)
	-- function 23
	local _backend_interface_loot = self._backend_interface_loot
	local generate_reward_loot_id = _backend_interface_loot:generate_reward_loot_id()

	_backend_interface_loot:claim_achievement_rewards(arg_23_1, generate_reward_loot_id)

	return generate_reward_loot_id
end

AchievementManager.claim_multiple_rewards = function (self, arg_24_1)
	-- function 24
	local _backend_interface_loot = self._backend_interface_loot
	local generate_reward_loot_id = _backend_interface_loot:generate_reward_loot_id()

	_backend_interface_loot:claim_multiple_achievement_rewards(arg_24_1, generate_reward_loot_id)

	return generate_reward_loot_id
end

AchievementManager.polling_reward = function (self)
	-- function 25
	return self._backend_interface_loot:polling_reward()
end

AchievementManager.has_any_unclaimed_achievement = function (self)
	-- function 26
	local unlock = Managers.unlock

	for k, v in pairs(self._achievement_data) do
		if not (not v.completed and v.claimed) then
			local required_dlc = v.required_dlc
			local required_dlc_extra = v.required_dlc_extra
			local is_dlc_unlocked

			if not required_dlc then
				is_dlc_unlocked = unlock:is_dlc_unlocked(required_dlc)

				if not is_dlc_unlocked then
					-- Nothing
				end
			end

			is_dlc_unlocked = not required_dlc_extra and unlock:is_dlc_unlocked(required_dlc_extra)

			::label_26_0::

			if not is_dlc_unlocked then
				return true
			end
		end
	end

	return false
end

AchievementManager.evaluate_end_of_level_achievements = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	-- function 27
	local end_of_level_achievement_evaluations = AchievementTemplates.end_of_level_achievement_evaluations

	for k, v in pairs(end_of_level_achievement_evaluations) do
		local levels = v.levels

		if not levels and not table.contains(levels, arg_27_3) then
			local evaluation_func = v.evaluation_func
			local allowed_difficulties = v.allowed_difficulties

			if not allowed_difficulties and allowed_difficulties[arg_27_4] or not evaluation_func(arg_27_1, arg_27_2) then
				local stat_to_increment = v.stat_to_increment

				arg_27_1:increment_stat(arg_27_2, stat_to_increment)
			end
		end
	end
end

AchievementManager._check_version_number = function (self)
	-- function 28
	if not self._checked_version_number then
		if not self._version_token then
			local check_version_number, var_28_1 = self._platform_functions.check_version_number()

			if not check_version_number then
				self._checked_version_number = true
			else
				self._version_token = var_28_1
			end
		else
			local version_result, var_28_3 = self._platform_functions.version_result(self._version_token)

			if not version_result then
				self._version_token = nil

				if not var_28_3 then
					print("[AchievementManager] Couldn't update achievement version number stat")
				else
					self._checked_version_number = true
				end
			end
		end
	end

	return self._checked_version_number
end

AchievementManager._check_initialized_achievements = function (self)
	-- function 29
	if not self._initialized_achievements then
		self._initialized_achievements = true

		local var_29_0
		local var_29_1

		for i = 1, self._template_count do
			local var_29_2 = self._templates[i]
			local is_unlocked, var_29_4 = self._platform_functions.is_unlocked(var_29_2)

			if not is_unlocked then
				self._unlocked_achievements[var_29_2.id] = true
			elseif not var_29_4 then
				Application.warning(string.format("[AchievementManager] ERROR: %s", var_29_4))

				self._unlocked_achievements[var_29_2.id] = true
			end
		end
	end

	return self._initialized_achievements
end

AchievementManager._display_completion_ui = function (arg_30_0, arg_30_1)
	-- function 30
	local var_30_0 = Localize(AchievementTemplates.achievements[arg_30_1].name)
	local format = string.format(Localize("finish_level_to_complete_challenge"), var_30_0)
	local flag = true

	Managers.chat:add_local_system_message(1, format, flag)
end

local function fn(self, arg_31_1, arg_31_2)
	-- function 31
	self[arg_31_1] = self[arg_31_2]
	self[arg_31_2] = nil
end

AchievementManager._check_for_completed_achievements = function (self)
	-- function 32
	if self._incompleted_template_count > 0 then
		local _incompleted_template_curr_idx = self._incompleted_template_curr_idx
		local var_32_1 = self._incompleted_achievements[_incompleted_template_curr_idx]
		local id = var_32_1.id

		fassert(id, "incompleted_template_id is nil on %s ", var_32_1.name)

		if not self:_achievement_completed(id) then
			self:_display_completion_ui(id)

			if not AchievementManager.STORE_COMPLETED_LEVEL then
				self._state_completed_achievements[#self._state_completed_achievements + 1] = id

				Managers.backend:get_interface("statistics"):save_state_completed_achievements(self._state_completed_achievements)
			end

			fn(self._incompleted_achievements, _incompleted_template_curr_idx, self._incompleted_template_count)

			self._incompleted_template_count = self._incompleted_template_count - 1
		end

		local num = _incompleted_template_curr_idx + 1

		if num > self._incompleted_template_count then
			num = 1
		end

		self._incompleted_template_curr_idx = num
	end
end

AchievementManager._achievement_completed = function (self, arg_33_1, arg_33_2)
	-- function 33
	if not arg_33_2 then
		return true
	end

	local var_33_0 = AchievementTemplates.achievements[arg_33_1]

	if type(var_33_0.completed) == "boolean" then
		return var_33_0.completed
	elseif type(var_33_0.completed) == "function" then
		local local_player = Managers.player:local_player()

		return var_33_0.completed(self._statistics_db, local_player:stats_id())
	end
end

AchievementManager._achievement_progress = function (self, arg_34_1, arg_34_2)
	-- function 34
	local var_34_0
	local var_34_1 = AchievementTemplates.achievements[arg_34_1]

	if type(var_34_1.progress) == "table" then
		var_34_0 = var_34_1.progress
	elseif type(var_34_1.progress) == "function" then
		local stats_id = Managers.player:local_player():stats_id()

		var_34_0 = var_34_1.progress(self._statistics_db, stats_id, var_34_1)
	end

	if not var_34_0 then
		return
	end

	if not arg_34_2 then
		return {
			var_34_0[2],
			var_34_0[2]
		}
	end

	return var_34_0
end

AchievementManager.setup_incompleted_achievements = function (self)
	-- function 35
	if not self._enabled then
		return
	end

	local num = 0
	local _backend_interface_loot = self._backend_interface_loot

	for k, v in pairs(AchievementTemplates.achievements) do
		local achievement_rewards_claimed = _backend_interface_loot:achievement_rewards_claimed(k)

		if self:_achievement_completed(k, achievement_rewards_claimed) or not v.display_completion_ui then
			local num_2 = num + 1

			self._incompleted_achievements[num_2] = v
			num = num_2
		end
	end

	self._incompleted_template_count = num
	self._incompleted_template_curr_idx = 1
end

AchievementManager._setup_achievement_data = function (self, arg_36_1, arg_36_2)
	-- function 36
	local var_36_0 = AchievementTemplates.achievements[arg_36_1]

	fassert(var_36_0, "Missing achievemnt for [\"%s\"]", arg_36_1)

	local var_36_1
	local var_36_2
	local var_36_3
	local var_36_4
	local var_36_5
	local var_36_6
	local var_36_7
	local var_36_8
	local local_player = Managers.player:local_player()

	if not local_player then
		return nil, "Missing player"
	end

	local stats_id = local_player:stats_id()

	if type(var_36_0.name) == "function" then
		local var_36_11, var_36_12 = pcall(var_36_0.name)

		if not var_36_11 then
			var_36_1 = var_36_12
		else
			Application.warning("Failed to evaluate achievement name for %s: %s", arg_36_1, var_36_12)

			var_36_1 = "<Error>"
		end
	elseif type(var_36_0.name) == "string" then
		var_36_1 = Localize(var_36_0.name)
	end

	if type(var_36_0.desc) == "function" then
		local var_36_13, var_36_14 = pcall(var_36_0.desc)

		if not var_36_13 then
			var_36_2 = var_36_14
		else
			Application.warning("Failed to evaluate achievement desc for %s: %s", arg_36_1, var_36_14)

			var_36_2 = "<Error>"
		end
	elseif type(var_36_0.desc) == "string" then
		var_36_2 = Localize(var_36_0.desc)
	end

	local _backend_interface_loot = self._backend_interface_loot
	local achievement_rewards_claimed = _backend_interface_loot:achievement_rewards_claimed(arg_36_1)
	local _achievement_completed = self:_achievement_completed(arg_36_1, achievement_rewards_claimed)
	local _achievement_progress = self:_achievement_progress(arg_36_1, achievement_rewards_claimed)

	if not (_achievement_completed or _achievement_progress ~= 100) then
		local _platform_functions = self._platform_functions

		if not (not _platform_functions.is_platform_achievement(var_36_0) and _platform_functions.is_unlocked(var_36_0)) then
			self:_add_achievement_to_platform_unlock_verification(arg_36_1)
		end
	end

	if type(var_36_0.requirements) == "table" then
		var_36_5 = var_36_0.requirements
	elseif type(var_36_0.requirements) == "function" then
		var_36_5 = var_36_0.requirements(self._statistics_db, stats_id)
	end

	if not var_36_5 then
		for i, v in ipairs(var_36_5) do
			if type(v.name) == "string" then
				v.name = Localize(v.name)
			elseif type(v.name) == "function" then
				local var_36_20, var_36_21 = pcall(v.name)

				if not var_36_20 then
					v.name = var_36_21
				else
					Application.warning("Failed to evaluate requirement name for %s: %s", arg_36_1, var_36_21)

					v.name = "<Error>"
				end
			end

			if not achievement_rewards_claimed then
				var_36_5[i].completed = true
			end
		end
	end

	if not (not AchievementManager.STORE_COMPLETED_LEVEL and not _achievement_completed and achievement_rewards_claimed or not arg_36_2 or arg_36_2[arg_36_1]) then
		self._state_completed_achievements[#self._state_completed_achievements + 1] = arg_36_1
	end

	local get_achievement_rewards = _backend_interface_loot:get_achievement_rewards(arg_36_1)
	local tbl = {
		id = arg_36_1,
		name = var_36_1,
		desc = var_36_2,
		desc_value = var_36_8,
		icon = var_36_0.icon,
		required_dlc = var_36_0.required_dlc,
		required_dlc_extra = var_36_0.required_dlc_extra,
		completed = _achievement_completed,
		progress = _achievement_progress,
		requirements = var_36_5,
		reward = get_achievement_rewards,
		claimed = achievement_rewards_claimed or false
	}

	self._achievement_data[arg_36_1] = tbl
end

AchievementManager._add_achievement_to_platform_unlock_verification = function (arg_37_0, arg_37_1)
	-- function 37
	local var_37_0 = AchievementTemplates.achievements[arg_37_1]

	arg_37_0._platform_achievements_to_verify[#arg_37_0._platform_achievements_to_verify + 1] = var_37_0
end

AchievementManager._verify_platform_achievements = function (self)
	-- function 38
	local _platform_functions = self._platform_functions
	local _verify_platform_achievements_data = self._verify_platform_achievements_data

	_verify_platform_achievements_data = _verify_platform_achievements_data or {}

	if not _verify_platform_achievements_data.in_progress then
		if not _platform_functions.unlock_result(_verify_platform_achievements_data.token, _verify_platform_achievements_data.template_id) then
			_verify_platform_achievements_data.in_progress = false
		end

		return
	end

	local _platform_achievements_to_verify = self._platform_achievements_to_verify
	local var_38_3 = _platform_achievements_to_verify[#_platform_achievements_to_verify]

	if not var_38_3 then
		return true
	end

	local verify_platform_unlocked, var_38_5 = self._platform_functions.verify_platform_unlocked(var_38_3)

	if not verify_platform_unlocked then
		return
	end

	if not var_38_5 then
		_verify_platform_achievements_data.token = var_38_5
		_verify_platform_achievements_data.template_id = var_38_3.id
		_verify_platform_achievements_data.in_progress = true
	end

	self._platform_achievements_to_verify[#self._platform_achievements_to_verify] = nil
end

local num_6 = 16
local str = "arial"
local str_2 = "materials/fonts/" .. str

AchievementManager.debug_draw = function (self)
	-- function 39
	if not var_0_2.achievement_debug then
		return
	end

	if not self.gui then
		self.gui = var_0_1.create_screen_gui(self.world, "material", "materials/fonts/gw_fonts", "immediate")
	end

	local gui = self.gui
	local res_w = RESOLUTION_LOOKUP.res_w
	local res_h = RESOLUTION_LOOKUP.res_h
	local var_39_3 = var_0_3(250, 255, 255, 100)
	local var_39_4 = var_0_3(240, 25, 50, 25)
	local var_39_5 = var_0_3(250, 255, 120, 0)
	local var_39_6 = var_0_3(255, 255, 255, 100)
	local var_39_7 = var_0_3(100, 255, 255, 0)
	local var_39_8 = Vector3(res_w / 2, res_h - 100, 200)
	local copy = Vector3.copy(var_39_8)
	local format = string.format("Achievements v2 [%s]", self.platform)

	var_0_4.text(gui, format, str_2, num_6, str, copy, var_39_3)

	for i = 1, self._template_count do
		local id = self._templates[i].id

		copy.y = copy.y - 20

		local var_39_12 = var_39_5

		var_0_4.text(gui, id, str_2, num_6, str, copy, var_39_12)

		if not self._unlocked_achievements[id] then
			var_0_4.rect(gui, copy + Vector3(-10, 2, 0), Vector2(220, 2), var_39_7)
		elseif not self._unlock_tasks[id] then
			var_0_4.text(gui, "unlocking...", str_2, num_6, str, copy + Vector3(240, 0, 0), var_39_6)
		end
	end

	var_0_4.rect(gui, Vector3(var_39_8.x - 20, copy.y - 20, 100), Vector2(300, var_39_8.y - copy.y + 40), var_39_4)
end

AchievementManager.get_challenge_progression = function (self, arg_40_1)
	-- function 40
	local stats_id = Managers.player:local_player():stats_id()
	local _statistics_db = self._statistics_db
	local tbl = {}

	if not arg_40_1 then
		local get_entries_from_category = self:get_entries_from_category(arg_40_1)

		for i, v in ipairs(get_entries_from_category) do
			local var_40_4 = AchievementTemplates.achievements[v]

			if not var_40_4 and not var_40_4.progress then
				local progress = var_40_4.progress(_statistics_db, stats_id)

				tbl[v] = progress[1] / progress[2]
			elseif not var_40_4 then
				local flag

				flag = not var_40_4.completed(_statistics_db, stats_id) and 1 and 0
				tbl[v] = flag
			end
		end
	else
		for k, v_2 in pairs(AchievementTemplates.achievements) do
			if not v_2.progress then
				local progress_2 = v_2.progress(_statistics_db, stats_id)

				tbl[k] = progress_2[1] / progress_2[2]
			elseif not v_2 then
				local flag_2

				flag_2 = not v_2.completed(_statistics_db, stats_id) and 1 and 0
				tbl[k] = flag_2
			end
		end
	end

	return tbl
end
