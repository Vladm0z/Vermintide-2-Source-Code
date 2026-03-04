-- chunkname: @scripts/managers/achievements/achievement_manager.lua

require("scripts/managers/achievements/achievement_templates")

local var_0_0 = require("scripts/managers/achievements/achievements_outline")
local var_0_1 = rawget(_G, "World")
local var_0_2 = rawget(_G, "script_data")
local var_0_3 = rawget(_G, "Color")
local var_0_4 = rawget(_G, "Gui")
local var_0_5 = 1
local var_0_6 = 2
local var_0_7 = 3
local var_0_8 = 4

if IS_CONSOLE then
	local var_0_9 = {}
	local var_0_10 = AchievementTemplates.achievements
	local var_0_11 = var_0_0.categories

	for iter_0_0, iter_0_1 in ipairs(var_0_11) do
		table.clear(var_0_9)

		local var_0_12 = iter_0_1.entries

		for iter_0_2, iter_0_3 in pairs(var_0_12) do
			if var_0_10[iter_0_3].disable_on_consoles then
				var_0_9[#var_0_9 + 1] = iter_0_2
			end
		end

		for iter_0_4 = #var_0_9, 1, -1 do
			local var_0_13 = var_0_9[iter_0_4]
			local var_0_14 = var_0_12[var_0_13]

			table.remove(var_0_12, var_0_13)
			Application.warning(string.format("### [AchievementManager] Stripping %q for consoles", var_0_14))
		end
	end
end

AchievementManager = class(AchievementManager)

local var_0_15 = 1

AchievementManager.STORE_COMPLETED_LEVEL = false

AchievementManager.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.initialized = false
	arg_1_0.world = arg_1_1
	arg_1_0._statistics_db = arg_1_2
	arg_1_0._event_mappings = {}
	arg_1_0._template_event_data = {}
	arg_1_0._templates = {}
	arg_1_0._unlocked_achievements = {}
	arg_1_0._unlock_tasks = {}
	arg_1_0._available_careers = {}
	arg_1_0._achievement_data = {}
	arg_1_0._incompleted_achievements = {}
	arg_1_0._state_completed_achievements = {}
	arg_1_0._timed_events = {}
	arg_1_0._canceled_timed_events_n = 0
	arg_1_0._canceled_timed_events = {}
	arg_1_0._platform_achievements_to_verify = {}
	arg_1_0._verify_platform_achievements_data = {}
	arg_1_0._backend_interface_loot = Managers.backend:get_interface("loot")

	if IS_WINDOWS or IS_LINUX then
		if rawget(_G, "Steam") and GameSettingsDevelopment.network_mode == "steam" then
			arg_1_0.platform = "steam"
		else
			arg_1_0.platform = "debug"
		end
	elseif IS_PS4 then
		arg_1_0.platform = "ps4"
	elseif IS_XB1 then
		arg_1_0.platform = "xb1"
	else
		arg_1_0.platform = "debug"
	end

	local var_1_0 = arg_1_0._event_mappings
	local var_1_1 = 0

	for iter_1_0, iter_1_1 in pairs(AchievementTemplates.achievements) do
		if arg_1_0.platform == "steam" and iter_1_1.ID_STEAM or IS_PS4 and iter_1_1.ID_PS4 or IS_XB1 and iter_1_1.ID_XB1 or arg_1_0.platform == "debug" then
			local var_1_2 = var_1_1 + 1

			arg_1_0._templates[var_1_2] = iter_1_1
			var_1_1 = var_1_2
		end

		local var_1_3 = iter_1_1.events

		if var_1_3 then
			for iter_1_2, iter_1_3 in ipairs(var_1_3) do
				arg_1_0._event_mappings[iter_1_3] = arg_1_0._event_mappings[iter_1_3] or {}
				arg_1_0._event_mappings[iter_1_3][#arg_1_0._event_mappings[iter_1_3] + 1] = iter_1_1
				arg_1_0._template_event_data[iter_1_1.id] = {}
			end
		end
	end

	arg_1_0._template_count = var_1_1
	arg_1_0._curr_template_idx = 1
	arg_1_0._platform_functions = require("scripts/managers/achievements/platform_" .. arg_1_0.platform)

	assert(arg_1_0._platform_functions, "Can't load platform functions for platform %s", arg_1_0.platform)
	arg_1_0._platform_functions.init(arg_1_0)
	printf("[AchievementManager] Achievements using the %s platform", arg_1_0.platform)
	arg_1_0:event_enable_achievements(true)

	if var_1_1 == 0 or var_0_2.settings.use_beta_mode or Managers.state.game_mode:setting("disable_achievements") then
		arg_1_0._enabled = false
	end

	Managers.state.event:register(arg_1_0, "event_enable_achievements", "event_enable_achievements")

	arg_1_0.initialized = true
end

AchievementManager.trigger_event = function (arg_2_0, arg_2_1, ...)
	if DEDICATED_SERVER or var_0_2["eac-untrusted"] then
		return
	end

	local var_2_0 = arg_2_0._event_mappings
	local var_2_1 = arg_2_0._template_event_data
	local var_2_2 = var_2_0[arg_2_1]
	local var_2_3 = arg_2_0._unlocked_achievements
	local var_2_4 = {
		...
	}

	if var_2_2 then
		local var_2_5 = Managers.player:local_player()

		if not var_2_5 then
			return
		end

		local var_2_6 = var_2_5:stats_id()
		local var_2_7 = arg_2_0._statistics_db

		table.clear(arg_2_0._available_careers)

		local var_2_8 = arg_2_0._available_careers
		local var_2_9 = Managers.player
		local var_2_10 = var_2_9:human_players()

		if var_2_10 then
			for iter_2_0, iter_2_1 in pairs(var_2_10) do
				local var_2_11 = iter_2_1._profile_index

				if not var_2_11 then
					local var_2_12 = iter_2_1.player_unit
					local var_2_13 = var_2_12 and var_2_9:owner(var_2_12)

					var_2_11 = var_2_13 and var_2_13:profile_index()
				end

				if var_2_11 then
					local var_2_14 = SPProfiles[var_2_11]
					local var_2_15 = var_2_14 and var_2_14.careers[iter_2_1._career_index]

					if var_2_15 then
						var_2_8[var_2_15.display_name] = true
					end
				end
			end
		end

		for iter_2_2, iter_2_3 in ipairs(var_2_2) do
			local var_2_16 = var_2_3[iter_2_3.id]
			local var_2_17 = iter_2_3.required_career
			local var_2_18 = not var_2_17 or var_2_8[var_2_17]
			local var_2_19 = iter_2_3.allow_in_inn or not global_is_inside_inn
			local var_2_20 = iter_2_3.always_run

			if var_2_19 and var_2_18 and (not var_2_16 or var_2_20) then
				iter_2_3.on_event(var_2_7, var_2_6, var_2_1[iter_2_3.id], arg_2_1, var_2_4)
			end
		end
	end

	local var_2_21 = Managers.state.event

	if var_2_21 then
		var_2_21:trigger("on_achievement_event", arg_2_1, var_2_4)
	end
end

AchievementManager.register_timed_event = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = Managers.time:time("game")
	local var_3_1 = {
		arg_3_1,
		arg_3_2,
		arg_3_3,
		arg_3_4,
		valid = true
	}

	arg_3_0._timed_events[var_3_1] = var_3_0 + (arg_3_3 or 0)

	return var_3_1
end

AchievementManager.cancel_timed_event = function (arg_4_0, arg_4_1)
	if arg_4_0._timed_events[arg_4_1] then
		arg_4_1.valid = false

		local var_4_0 = arg_4_0._canceled_timed_events_n + 1

		arg_4_0._canceled_timed_events[var_4_0] = arg_4_1
		arg_4_0._canceled_timed_events_n = var_4_0
	end
end

AchievementManager.get_registered_timed_event = function (arg_5_0, arg_5_1)
	return arg_5_0._timed_events[arg_5_1]
end

AchievementManager.reset_timed_event = function (arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0._timed_events[arg_6_1]

	if var_6_0 and arg_6_1.valid then
		var_6_0[arg_6_1] = Managers.time:time("game") + var_6_0[var_0_7]

		return true
	end

	return false
end

AchievementManager._update_timed_events = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0._timed_events
	local var_7_1 = arg_7_0._canceled_timed_events

	for iter_7_0 = 1, arg_7_0._canceled_timed_events_n do
		var_7_0[var_7_1[iter_7_0]] = nil
		var_7_1[iter_7_0] = nil
	end

	arg_7_0._canceled_timed_events_n = 0

	local var_7_2 = Managers.player:local_player():stats_id()
	local var_7_3 = arg_7_0._statistics_db

	for iter_7_1, iter_7_2 in pairs(var_7_0) do
		if iter_7_2 <= arg_7_2 then
			local var_7_4 = iter_7_1[var_0_5]
			local var_7_5 = iter_7_1[var_0_6]
			local var_7_6 = iter_7_1[var_0_8]
			local var_7_7 = AchievementTemplates.achievements[var_7_4]
			local var_7_8 = arg_7_0._template_event_data[var_7_7.id]

			var_7_7[var_7_5](var_7_3, var_7_2, var_7_8, var_7_6)
			arg_7_0:cancel_timed_event(iter_7_1)
		end
	end
end

AchievementManager.destroy = function (arg_8_0)
	Managers.state.event:unregister("event_enable_achievements", arg_8_0)

	if arg_8_0.gui then
		var_0_1.destroy_gui(arg_8_0.world, arg_8_0.gui)

		arg_8_0.gui = nil
	end

	arg_8_0._timed_events = nil
end

AchievementManager.event_enable_achievements = function (arg_9_0, arg_9_1)
	arg_9_0._enabled = arg_9_1
end

AchievementManager.is_enabled = function (arg_10_0)
	return arg_10_0._enabled
end

AchievementManager.num_achievement_categories = function (arg_11_0)
	return #var_0_0.categories
end

AchievementManager.update = function (arg_12_0, arg_12_1, arg_12_2)
	if not arg_12_0._enabled or not arg_12_0:_check_version_number() or not arg_12_0:_check_initialized_achievements() or not arg_12_0:_verify_platform_achievements() or var_0_2["eac-untrusted"] then
		return
	end

	if arg_12_0._error_timeout then
		arg_12_0._error_timeout = arg_12_0._error_timeout - arg_12_1

		if arg_12_0._error_timeout < 0 then
			arg_12_0._error_timeout = nil
		end

		return
	end

	local var_12_0 = arg_12_0._platform_functions
	local var_12_1 = var_12_0.update

	if var_12_1 and var_12_1(arg_12_0) then
		return
	end

	local var_12_2 = Managers.player:local_player()

	if not var_12_2 then
		return
	end

	local var_12_3 = arg_12_0._unlock_tasks
	local var_12_4 = arg_12_0._unlocked_achievements

	for iter_12_0, iter_12_1 in pairs(var_12_3) do
		local var_12_5 = iter_12_1.token
		local var_12_6, var_12_7 = var_12_0.unlock_result(var_12_5, iter_12_0)

		if var_12_6 then
			var_12_3[iter_12_0] = nil

			if var_12_7 == nil then
				if iter_12_1.achievement_completed then
					var_12_4[iter_12_0] = true
				end
			else
				Application.warning("Unlocking achievement with id %s failed due to error message %s", iter_12_0, tostring(var_12_7))

				arg_12_0._error_timeout = 5

				return
			end
		end
	end

	if arg_12_0._console_achievement_check_delay and arg_12_2 < arg_12_0._console_achievement_check_delay then
		arg_12_0:_update_timed_events(arg_12_1, arg_12_2)

		return
	end

	local var_12_8 = arg_12_0._curr_template_idx
	local var_12_9 = arg_12_0._templates[var_12_8]
	local var_12_10 = var_12_9.id
	local var_12_11 = arg_12_0._statistics_db
	local var_12_12 = var_12_2:stats_id()
	local var_12_13 = arg_12_0._template_event_data

	if not var_12_4[var_12_10] and not var_12_3[var_12_10] then
		local var_12_14
		local var_12_15
		local var_12_16
		local var_12_17 = arg_12_0._backend_interface_loot:achievement_rewards_claimed(var_12_9.id)

		if var_12_0.set_progress and var_12_9.progress then
			local var_12_18 = arg_12_0:_achievement_progress(var_12_9.id, var_12_17)
			local var_12_19 = var_12_18[1]
			local var_12_20 = var_12_18[2]

			var_12_14, var_12_15, var_12_16 = var_12_0.set_progress(var_12_9, var_12_19, var_12_20)
		else
			var_12_16 = arg_12_0:_achievement_completed(var_12_9.id, var_12_17)

			if var_12_16 then
				var_12_14, var_12_15 = var_12_0.unlock(var_12_9)
			end
		end

		if var_12_14 then
			if IS_XB1 then
				arg_12_0._console_achievement_check_delay = arg_12_2 + var_0_15
			end

			var_12_3[var_12_10] = {
				token = var_12_14,
				achievement_completed = var_12_16
			}
		elseif var_12_15 then
			Crashify.print_exception("[AchievementManager]", "ERROR: %s", var_12_15)
		end
	end

	local var_12_21 = var_12_8 + 1

	if var_12_21 > arg_12_0._template_count then
		var_12_21 = 1
	end

	arg_12_0._curr_template_idx = var_12_21

	arg_12_0:_check_for_completed_achievements()
	arg_12_0:_update_timed_events(arg_12_1, arg_12_2)
end

AchievementManager.reset = function (arg_13_0)
	arg_13_0._platform_functions.reset()

	arg_13_0._unlocked_achievements = {}
	arg_13_0._unlock_tasks = {}
end

AchievementManager.outline = function (arg_14_0)
	if not arg_14_0.initialized then
		return nil, "AchievementManager not initialized"
	end

	return var_0_0
end

AchievementManager._search_sub_categories = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	if not arg_15_1 then
		return
	end

	local var_15_0 = arg_15_3 or {}

	for iter_15_0 = 1, #arg_15_1 do
		local var_15_1 = arg_15_1[iter_15_0]
		local var_15_2 = var_15_1.name

		if arg_15_4 or var_15_2 == arg_15_2 then
			local var_15_3 = true
			local var_15_4 = var_15_1.entries

			if var_15_4 then
				table.append(var_15_0, var_15_4)
			end

			arg_15_0:_search_sub_categories(var_15_1.categories, arg_15_2, var_15_0, var_15_3)
		else
			arg_15_0:_search_sub_categories(var_15_1.categories, arg_15_2, var_15_0)
		end
	end

	return var_15_0
end

AchievementManager.get_entries_from_category = function (arg_16_0, arg_16_1)
	return arg_16_0:_search_sub_categories(var_0_0.categories, arg_16_1)
end

AchievementManager.get_data_by_id = function (arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0._achievement_data[arg_17_1]

	fassert(var_17_0, "Have not set up achievement (%s) yet.", arg_17_1)

	return var_17_0
end

AchievementManager.setup_achievement_data = function (arg_18_0)
	if not arg_18_0._enabled then
		return
	end

	if not arg_18_0.initialized then
		return nil, "AchievementManager not initialized"
	end

	local function var_18_0(arg_19_0, arg_19_1)
		for iter_19_0, iter_19_1 in ipairs(arg_19_1) do
			if iter_19_1.categories then
				var_18_0(arg_19_0, iter_19_1.categories)
			end

			if iter_19_1.entries then
				local var_19_0 = true

				arg_19_0:setup_achievement_data_from_list(iter_19_1.entries, var_19_0)
			end
		end

		if not table.is_empty(arg_19_0._state_completed_achievements) then
			Managers.backend:get_interface("statistics"):save_state_completed_achievements(arg_19_0._state_completed_achievements)
			Managers.backend:commit(true)
		end
	end

	var_18_0(arg_18_0, var_0_0.categories)
end

AchievementManager.setup_achievement_data_from_list = function (arg_20_0, arg_20_1, arg_20_2)
	if not arg_20_0._enabled then
		return
	end

	local var_20_0 = Managers.backend:get_interface("statistics")
	local var_20_1 = var_20_0:get_achievement_reward_levels()

	for iter_20_0, iter_20_1 in ipairs(arg_20_1) do
		arg_20_0:_setup_achievement_data(iter_20_1, var_20_1)
	end

	if not arg_20_2 and not table.is_empty(arg_20_0._state_completed_achievements) then
		var_20_0:save_state_completed_achievements(arg_20_0._state_completed_achievements)
		Managers.backend:commit(true)

		arg_20_0._state_completed_achievements = {}
	end
end

AchievementManager.can_claim_achievement_rewards = function (arg_21_0, arg_21_1)
	if not arg_21_0._enabled then
		return nil, "AchievementManager not enabled"
	end

	if not arg_21_0.initialized then
		return nil, "AchievementManager not initialized"
	end

	local var_21_0 = arg_21_0._backend_interface_loot

	if not var_21_0:can_claim_achievement_rewards(arg_21_1) then
		return nil, "Achievement already claimed."
	end

	if var_21_0:polling_reward() then
		return nil, "Achievement reward polling in progress."
	end

	return true
end

AchievementManager.can_claim_all_achievement_rewards = function (arg_22_0, arg_22_1)
	if not arg_22_0._enabled then
		return nil, nil, "AchievementManager not enabled"
	end

	if not arg_22_0.initialized then
		return nil, nil, "AchievementManager not initialized"
	end

	local var_22_0, var_22_1, var_22_2 = arg_22_0._backend_interface_loot:can_claim_all_achievement_rewards(arg_22_1)

	if var_22_0 and #var_22_2 > 1 then
		return var_22_1, var_22_2, "Some of the achievements have already been claimed!"
	end

	if not var_22_0 then
		return nil, nil, "None of the achievements could be claimed."
	end

	return var_22_1, nil, nil
end

AchievementManager.claim_reward = function (arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0._backend_interface_loot
	local var_23_1 = var_23_0:generate_reward_loot_id()

	var_23_0:claim_achievement_rewards(arg_23_1, var_23_1)

	return var_23_1
end

AchievementManager.claim_multiple_rewards = function (arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0._backend_interface_loot
	local var_24_1 = var_24_0:generate_reward_loot_id()

	var_24_0:claim_multiple_achievement_rewards(arg_24_1, var_24_1)

	return var_24_1
end

AchievementManager.polling_reward = function (arg_25_0)
	return arg_25_0._backend_interface_loot:polling_reward()
end

AchievementManager.has_any_unclaimed_achievement = function (arg_26_0)
	local var_26_0 = Managers.unlock

	for iter_26_0, iter_26_1 in pairs(arg_26_0._achievement_data) do
		if iter_26_1.completed and not iter_26_1.claimed then
			local var_26_1 = iter_26_1.required_dlc
			local var_26_2 = iter_26_1.required_dlc_extra

			if (not var_26_1 or var_26_0:is_dlc_unlocked(var_26_1)) and (not var_26_2 or var_26_0:is_dlc_unlocked(var_26_2)) then
				return true
			end
		end
	end

	return false
end

AchievementManager.evaluate_end_of_level_achievements = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	local var_27_0 = AchievementTemplates.end_of_level_achievement_evaluations

	for iter_27_0, iter_27_1 in pairs(var_27_0) do
		local var_27_1 = iter_27_1.levels

		if not var_27_1 or table.contains(var_27_1, arg_27_3) then
			local var_27_2 = iter_27_1.evaluation_func
			local var_27_3 = iter_27_1.allowed_difficulties

			if (not var_27_3 or var_27_3[arg_27_4]) and var_27_2(arg_27_1, arg_27_2) then
				local var_27_4 = iter_27_1.stat_to_increment

				arg_27_1:increment_stat(arg_27_2, var_27_4)
			end
		end
	end
end

AchievementManager._check_version_number = function (arg_28_0)
	if not arg_28_0._checked_version_number then
		if not arg_28_0._version_token then
			local var_28_0, var_28_1 = arg_28_0._platform_functions.check_version_number()

			if var_28_0 then
				arg_28_0._checked_version_number = true
			else
				arg_28_0._version_token = var_28_1
			end
		else
			local var_28_2, var_28_3 = arg_28_0._platform_functions.version_result(arg_28_0._version_token)

			if var_28_2 then
				arg_28_0._version_token = nil

				if var_28_3 then
					print("[AchievementManager] Couldn't update achievement version number stat")
				else
					arg_28_0._checked_version_number = true
				end
			end
		end
	end

	return arg_28_0._checked_version_number
end

AchievementManager._check_initialized_achievements = function (arg_29_0)
	if not arg_29_0._initialized_achievements then
		arg_29_0._initialized_achievements = true

		local var_29_0
		local var_29_1

		for iter_29_0 = 1, arg_29_0._template_count do
			local var_29_2 = arg_29_0._templates[iter_29_0]
			local var_29_3, var_29_4 = arg_29_0._platform_functions.is_unlocked(var_29_2)

			if var_29_3 then
				arg_29_0._unlocked_achievements[var_29_2.id] = true
			elseif var_29_4 then
				Application.warning(string.format("[AchievementManager] ERROR: %s", var_29_4))

				arg_29_0._unlocked_achievements[var_29_2.id] = true
			end
		end
	end

	return arg_29_0._initialized_achievements
end

AchievementManager._display_completion_ui = function (arg_30_0, arg_30_1)
	local var_30_0 = Localize(AchievementTemplates.achievements[arg_30_1].name)
	local var_30_1 = string.format(Localize("finish_level_to_complete_challenge"), var_30_0)
	local var_30_2 = true

	Managers.chat:add_local_system_message(1, var_30_1, var_30_2)
end

local function var_0_16(arg_31_0, arg_31_1, arg_31_2)
	arg_31_0[arg_31_1] = arg_31_0[arg_31_2]
	arg_31_0[arg_31_2] = nil
end

AchievementManager._check_for_completed_achievements = function (arg_32_0)
	if arg_32_0._incompleted_template_count > 0 then
		local var_32_0 = arg_32_0._incompleted_template_curr_idx
		local var_32_1 = arg_32_0._incompleted_achievements[var_32_0]
		local var_32_2 = var_32_1.id

		fassert(var_32_2, "incompleted_template_id is nil on %s ", var_32_1.name)

		if arg_32_0:_achievement_completed(var_32_2) then
			arg_32_0:_display_completion_ui(var_32_2)

			if AchievementManager.STORE_COMPLETED_LEVEL then
				arg_32_0._state_completed_achievements[#arg_32_0._state_completed_achievements + 1] = var_32_2

				Managers.backend:get_interface("statistics"):save_state_completed_achievements(arg_32_0._state_completed_achievements)
			end

			var_0_16(arg_32_0._incompleted_achievements, var_32_0, arg_32_0._incompleted_template_count)

			arg_32_0._incompleted_template_count = arg_32_0._incompleted_template_count - 1
		end

		local var_32_3 = var_32_0 + 1

		if var_32_3 > arg_32_0._incompleted_template_count then
			var_32_3 = 1
		end

		arg_32_0._incompleted_template_curr_idx = var_32_3
	end
end

AchievementManager._achievement_completed = function (arg_33_0, arg_33_1, arg_33_2)
	if arg_33_2 then
		return true
	end

	local var_33_0 = AchievementTemplates.achievements[arg_33_1]

	if type(var_33_0.completed) == "boolean" then
		return var_33_0.completed
	elseif type(var_33_0.completed) == "function" then
		local var_33_1 = Managers.player:local_player()

		return var_33_0.completed(arg_33_0._statistics_db, var_33_1:stats_id())
	end
end

AchievementManager._achievement_progress = function (arg_34_0, arg_34_1, arg_34_2)
	local var_34_0
	local var_34_1 = AchievementTemplates.achievements[arg_34_1]

	if type(var_34_1.progress) == "table" then
		var_34_0 = var_34_1.progress
	elseif type(var_34_1.progress) == "function" then
		local var_34_2 = Managers.player:local_player():stats_id()

		var_34_0 = var_34_1.progress(arg_34_0._statistics_db, var_34_2, var_34_1)
	end

	if not var_34_0 then
		return
	end

	if arg_34_2 then
		return {
			var_34_0[2],
			var_34_0[2]
		}
	end

	return var_34_0
end

AchievementManager.setup_incompleted_achievements = function (arg_35_0)
	if not arg_35_0._enabled then
		return
	end

	local var_35_0 = 0
	local var_35_1 = arg_35_0._backend_interface_loot

	for iter_35_0, iter_35_1 in pairs(AchievementTemplates.achievements) do
		local var_35_2 = var_35_1:achievement_rewards_claimed(iter_35_0)

		if not arg_35_0:_achievement_completed(iter_35_0, var_35_2) and iter_35_1.display_completion_ui then
			local var_35_3 = var_35_0 + 1

			arg_35_0._incompleted_achievements[var_35_3] = iter_35_1
			var_35_0 = var_35_3
		end
	end

	arg_35_0._incompleted_template_count = var_35_0
	arg_35_0._incompleted_template_curr_idx = 1
end

AchievementManager._setup_achievement_data = function (arg_36_0, arg_36_1, arg_36_2)
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
	local var_36_9 = Managers.player:local_player()

	if not var_36_9 then
		return nil, "Missing player"
	end

	local var_36_10 = var_36_9:stats_id()

	if type(var_36_0.name) == "function" then
		local var_36_11, var_36_12 = pcall(var_36_0.name)

		if var_36_11 then
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

		if var_36_13 then
			var_36_2 = var_36_14
		else
			Application.warning("Failed to evaluate achievement desc for %s: %s", arg_36_1, var_36_14)

			var_36_2 = "<Error>"
		end
	elseif type(var_36_0.desc) == "string" then
		var_36_2 = Localize(var_36_0.desc)
	end

	local var_36_15 = arg_36_0._backend_interface_loot
	local var_36_16 = var_36_15:achievement_rewards_claimed(arg_36_1)
	local var_36_17 = arg_36_0:_achievement_completed(arg_36_1, var_36_16)
	local var_36_18 = arg_36_0:_achievement_progress(arg_36_1, var_36_16)

	if var_36_17 or var_36_18 == 100 then
		local var_36_19 = arg_36_0._platform_functions

		if var_36_19.is_platform_achievement(var_36_0) and not var_36_19.is_unlocked(var_36_0) then
			arg_36_0:_add_achievement_to_platform_unlock_verification(arg_36_1)
		end
	end

	if type(var_36_0.requirements) == "table" then
		var_36_5 = var_36_0.requirements
	elseif type(var_36_0.requirements) == "function" then
		var_36_5 = var_36_0.requirements(arg_36_0._statistics_db, var_36_10)
	end

	if var_36_5 then
		for iter_36_0, iter_36_1 in ipairs(var_36_5) do
			if type(iter_36_1.name) == "string" then
				iter_36_1.name = Localize(iter_36_1.name)
			elseif type(iter_36_1.name) == "function" then
				local var_36_20, var_36_21 = pcall(iter_36_1.name)

				if var_36_20 then
					iter_36_1.name = var_36_21
				else
					Application.warning("Failed to evaluate requirement name for %s: %s", arg_36_1, var_36_21)

					iter_36_1.name = "<Error>"
				end
			end

			if var_36_16 then
				var_36_5[iter_36_0].completed = true
			end
		end
	end

	if AchievementManager.STORE_COMPLETED_LEVEL and var_36_17 and not var_36_16 and (not arg_36_2 or not arg_36_2[arg_36_1]) then
		arg_36_0._state_completed_achievements[#arg_36_0._state_completed_achievements + 1] = arg_36_1
	end

	local var_36_22 = var_36_15:get_achievement_rewards(arg_36_1)
	local var_36_23 = {
		id = arg_36_1,
		name = var_36_1,
		desc = var_36_2,
		desc_value = var_36_8,
		icon = var_36_0.icon,
		required_dlc = var_36_0.required_dlc,
		required_dlc_extra = var_36_0.required_dlc_extra,
		completed = var_36_17,
		progress = var_36_18,
		requirements = var_36_5,
		reward = var_36_22,
		claimed = var_36_16 or false
	}

	arg_36_0._achievement_data[arg_36_1] = var_36_23
end

AchievementManager._add_achievement_to_platform_unlock_verification = function (arg_37_0, arg_37_1)
	local var_37_0 = AchievementTemplates.achievements[arg_37_1]

	arg_37_0._platform_achievements_to_verify[#arg_37_0._platform_achievements_to_verify + 1] = var_37_0
end

AchievementManager._verify_platform_achievements = function (arg_38_0)
	local var_38_0 = arg_38_0._platform_functions
	local var_38_1 = arg_38_0._verify_platform_achievements_data or {}

	if var_38_1.in_progress then
		if var_38_0.unlock_result(var_38_1.token, var_38_1.template_id) then
			var_38_1.in_progress = false
		end

		return
	end

	local var_38_2 = arg_38_0._platform_achievements_to_verify
	local var_38_3 = var_38_2[#var_38_2]

	if not var_38_3 then
		return true
	end

	local var_38_4, var_38_5 = arg_38_0._platform_functions.verify_platform_unlocked(var_38_3)

	if not var_38_4 then
		return
	end

	if var_38_5 then
		var_38_1.token = var_38_5
		var_38_1.template_id = var_38_3.id
		var_38_1.in_progress = true
	end

	arg_38_0._platform_achievements_to_verify[#arg_38_0._platform_achievements_to_verify] = nil
end

local var_0_17 = 16
local var_0_18 = "arial"
local var_0_19 = "materials/fonts/" .. var_0_18

AchievementManager.debug_draw = function (arg_39_0)
	if not var_0_2.achievement_debug then
		return
	end

	if not arg_39_0.gui then
		arg_39_0.gui = var_0_1.create_screen_gui(arg_39_0.world, "material", "materials/fonts/gw_fonts", "immediate")
	end

	local var_39_0 = arg_39_0.gui
	local var_39_1 = RESOLUTION_LOOKUP.res_w
	local var_39_2 = RESOLUTION_LOOKUP.res_h
	local var_39_3 = var_0_3(250, 255, 255, 100)
	local var_39_4 = var_0_3(240, 25, 50, 25)
	local var_39_5 = var_0_3(250, 255, 120, 0)
	local var_39_6 = var_0_3(255, 255, 255, 100)
	local var_39_7 = var_0_3(100, 255, 255, 0)
	local var_39_8 = Vector3(var_39_1 / 2, var_39_2 - 100, 200)
	local var_39_9 = Vector3.copy(var_39_8)
	local var_39_10 = string.format("Achievements v2 [%s]", arg_39_0.platform)

	var_0_4.text(var_39_0, var_39_10, var_0_19, var_0_17, var_0_18, var_39_9, var_39_3)

	for iter_39_0 = 1, arg_39_0._template_count do
		local var_39_11 = arg_39_0._templates[iter_39_0].id

		var_39_9.y = var_39_9.y - 20

		local var_39_12 = var_39_5

		var_0_4.text(var_39_0, var_39_11, var_0_19, var_0_17, var_0_18, var_39_9, var_39_12)

		if arg_39_0._unlocked_achievements[var_39_11] then
			var_0_4.rect(var_39_0, var_39_9 + Vector3(-10, 2, 0), Vector2(220, 2), var_39_7)
		elseif arg_39_0._unlock_tasks[var_39_11] then
			var_0_4.text(var_39_0, "unlocking...", var_0_19, var_0_17, var_0_18, var_39_9 + Vector3(240, 0, 0), var_39_6)
		end
	end

	var_0_4.rect(var_39_0, Vector3(var_39_8.x - 20, var_39_9.y - 20, 100), Vector2(300, var_39_8.y - var_39_9.y + 40), var_39_4)
end

AchievementManager.get_challenge_progression = function (arg_40_0, arg_40_1)
	local var_40_0 = Managers.player:local_player():stats_id()
	local var_40_1 = arg_40_0._statistics_db
	local var_40_2 = {}

	if arg_40_1 then
		local var_40_3 = arg_40_0:get_entries_from_category(arg_40_1)

		for iter_40_0, iter_40_1 in ipairs(var_40_3) do
			local var_40_4 = AchievementTemplates.achievements[iter_40_1]

			if var_40_4 and var_40_4.progress then
				local var_40_5 = var_40_4.progress(var_40_1, var_40_0)

				var_40_2[iter_40_1] = var_40_5[1] / var_40_5[2]
			elseif var_40_4 then
				var_40_2[iter_40_1] = var_40_4.completed(var_40_1, var_40_0) and 1 or 0
			end
		end
	else
		for iter_40_2, iter_40_3 in pairs(AchievementTemplates.achievements) do
			if iter_40_3.progress then
				local var_40_6 = iter_40_3.progress(var_40_1, var_40_0)

				var_40_2[iter_40_2] = var_40_6[1] / var_40_6[2]
			elseif iter_40_3 then
				var_40_2[iter_40_2] = iter_40_3.completed(var_40_1, var_40_0) and 1 or 0
			end
		end
	end

	return var_40_2
end
