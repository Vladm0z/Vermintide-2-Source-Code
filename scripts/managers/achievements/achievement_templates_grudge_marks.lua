-- chunkname: @scripts/managers/achievements/achievement_templates_grudge_marks.lua

local achievements = AchievementTemplates.achievements
local grudge_marks = DLCSettings.grudge_marks
local add_weapon_kill_challenge = AchievementTemplateHelper.add_weapon_kill_challenge
local add_meta_challenge = AchievementTemplateHelper.add_meta_challenge
local add_multi_stat_count_challenge = AchievementTemplateHelper.add_multi_stat_count_challenge
local add_event_challenge = AchievementTemplateHelper.add_event_challenge
local add_stat_count_challenge = AchievementTemplateHelper.add_stat_count_challenge

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local unit_owner = Managers.player:unit_owner(arg_1_0)

	if not (not unit_owner and unit_owner.bot_player) then
		local network_id = unit_owner:network_id()
		local network = Managers.state.network
		local var_1_3 = NetworkLookup.statistics[arg_1_1]

		network.network_transmit:send_rpc("rpc_increment_stat", network_id, var_1_3)
	end
end

local tbl = {}
local tbl_2 = {}
local num = 1
local num_2 = 2
local num_3 = 3
local num_4 = 4
local num_5 = 1
local num_6 = 2
local num_7 = 3
local num_8 = 4
local num_9 = 5
local mirror_array_inplace = table.mirror_array_inplace({
	"skaven_rat_ogre",
	"skaven_stormfiend",
	"chaos_spawn",
	"beastmen_minotaur",
	"chaos_troll"
})
local tbl_3 = {
	"journey_ruin",
	"journey_ice",
	"journey_cave",
	"journey_citadel"
}
local tbl_4 = {}

achievements.grudge_marks_on_kill_util = {
	display_completion_ui = false,
	events = {
		"register_kill"
	},
	completed = function (arg_2_0, arg_2_1, arg_2_2)
		-- function 2
		local get_interface = Managers.backend:get_interface("loot")

		for i = 1, #tbl_4 do
			local var_2_1 = tbl_4[i]
			local completed = achievements[var_2_1].completed(arg_2_0, arg_2_1)

			completed = completed or get_interface:achievement_rewards_claimed(var_2_1)

			if not completed then
				return false
			end
		end

		return true
	end,
	on_event = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		-- function 3
		local var_3_0 = arg_3_4[num_4]

		if not (not var_3_0 and var_3_0.boss) then
			return
		end

		local name = var_3_0.name

		if not (not name and mirror_array_inplace[name]) then
			return
		end

		local var_3_2 = arg_3_4[num_2]

		if not var_3_2 then
			return
		end

		if not Managers.state.entity:system("ai_system"):get_attributes(var_3_2).grudge_marked then
			return
		end

		local player_unit = Managers.player:local_player().player_unit
		local has_extension = ScriptUnit.has_extension(player_unit, "career_system")
		local flag = not has_extension and has_extension:career_name()

		if not flag then
			return
		end

		self:increment_stat(arg_3_1, "grudge_mark_kills", flag)

		local game_mechanism = Managers.mechanism:game_mechanism()

		if not game_mechanism then
			-- Nothing
		end

		::label_3_0::

		local get_deus_run_controller = game_mechanism.get_deus_run_controller

		get_deus_run_controller = not get_deus_run_controller and game_mechanism:get_deus_run_controller()

		::label_3_1::

		local flag_2 = not get_deus_run_controller and get_deus_run_controller:get_journey_name()

		if not flag_2 then
			self:increment_stat(arg_3_1, "grudge_marks_kills_per_career_per_expedition", flag, flag_2)
		end

		self:increment_stat(arg_3_1, "grudge_marks_kills_per_career_per_monster", flag, name)
	end
}

for k, v in pairs(CareerSettings) do
	if k ~= "empire_soldier_tutorial" then
		local breed = v.breed

		if not breed and not breed.is_hero then
			local required_dlc = v.required_dlc

			for k_2 = 1, #tbl_3 do
				local var_0_24 = tbl_3[k_2]
				local str = "grudge_mark_kills_" .. k .. "_per_" .. var_0_24

				achievements[str] = {
					display_completion_ui = false,
					name = var_0_24 .. "_name",
					icon = "achievement_trophy_" .. str,
					required_dlc = required_dlc,
					completed = function (self, arg_4_1, arg_4_2)
						-- function 4
						return self:get_persistent_stat(arg_4_1, "grudge_marks_kills_per_career_per_expedition", k, var_0_24) >= 1
					end
				}
			end

			for l = 1, #mirror_array_inplace do
				local var_0_26 = mirror_array_inplace[l]
				local str_2 = "grudge_mark_kills_" .. k .. "_per_" .. var_0_26

				achievements[str_2] = {
					display_completion_ui = false,
					name = var_0_26,
					icon = "achievement_trophy_" .. str_2,
					required_dlc = required_dlc,
					completed = function (self, arg_5_1, arg_5_2)
						-- function 5
						return self:get_persistent_stat(arg_5_1, "grudge_marks_kills_per_career_per_monster", k, var_0_26) >= 1
					end
				}
			end

			local str_3 = "grudge_mark_kills_grind_" .. k

			achievements[str_3] = {
				display_completion_ui = true,
				name = "achv_" .. str_3 .. "_name",
				desc = "achv_" .. str_3 .. "_desc",
				icon = "achievement_trophy_" .. str_3,
				required_dlc = required_dlc,
				progress = function (self, arg_6_1, arg_6_2)
					-- function 6
					local get_persistent_stat = self:get_persistent_stat(arg_6_1, "grudge_mark_kills", k)

					return {
						get_persistent_stat,
						5
					}
				end,
				completed = function (self, arg_7_1, arg_7_2)
					-- function 7
					return self:get_persistent_stat(arg_7_1, "grudge_mark_kills", k) >= 5
				end
			}

			local tbl_5 = {}

			for i4 = 1, #mirror_array_inplace do
				local var_0_30 = mirror_array_inplace[i4]
				local str_4 = "grudge_mark_kills_" .. k .. "_per_" .. var_0_30

				table.insert(tbl_5, str_4)
			end

			local str_5 = "kill_each_monster_grudge_" .. k
			local str_6 = "achievement_trophy_" .. str_5

			add_meta_challenge(achievements, str_5, tbl_5, icon, required_dlc, nil, nil)

			local tbl_6 = {}

			for i5 = 1, #tbl_3 do
				local var_0_35 = tbl_3[i5]
				local str_7 = "grudge_mark_kills_" .. k .. "_per_" .. var_0_35

				table.insert(tbl_6, str_7)
			end

			local str_8 = "kill_grudge_each_expedition_" .. k
			local str_9 = "achievement_trophy_" .. str_8, add_meta_challenge(achievements, str_8, tbl_6, str_6, required_dlc, nil, nil)
			local tbl_7 = {
				"kill_grudge_each_expedition_" .. k,
				"kill_each_monster_grudge_" .. k,
				"grudge_mark_kills_grind_" .. k
			}
			local str_10 = "complete_all_career_grudge_challenges_" .. k
			local str_11 = "achievement_trophy_" .. str_10, add_meta_challenge(achievements, str_10, tbl_7, str_9, required_dlc, nil, nil)

			table.insert(tbl_4, str_10)
		end
	end
end
