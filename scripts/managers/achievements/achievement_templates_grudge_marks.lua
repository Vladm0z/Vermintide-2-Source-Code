-- chunkname: @scripts/managers/achievements/achievement_templates_grudge_marks.lua

local var_0_0 = AchievementTemplates.achievements
local var_0_1 = DLCSettings.grudge_marks
local var_0_2 = AchievementTemplateHelper.add_weapon_kill_challenge
local var_0_3 = AchievementTemplateHelper.add_meta_challenge
local var_0_4 = AchievementTemplateHelper.add_multi_stat_count_challenge
local var_0_5 = AchievementTemplateHelper.add_event_challenge
local var_0_6 = AchievementTemplateHelper.add_stat_count_challenge

local function var_0_7(arg_1_0, arg_1_1)
	local var_1_0 = Managers.player:unit_owner(arg_1_0)

	if var_1_0 and not var_1_0.bot_player then
		local var_1_1 = var_1_0:network_id()
		local var_1_2 = Managers.state.network
		local var_1_3 = NetworkLookup.statistics[arg_1_1]

		var_1_2.network_transmit:send_rpc("rpc_increment_stat", var_1_1, var_1_3)
	end
end

local var_0_8 = {}
local var_0_9 = {}
local var_0_10 = 1
local var_0_11 = 2
local var_0_12 = 3
local var_0_13 = 4
local var_0_14 = 1
local var_0_15 = 2
local var_0_16 = 3
local var_0_17 = 4
local var_0_18 = 5
local var_0_19 = table.mirror_array_inplace({
	"skaven_rat_ogre",
	"skaven_stormfiend",
	"chaos_spawn",
	"beastmen_minotaur",
	"chaos_troll"
})
local var_0_20 = {
	"journey_ruin",
	"journey_ice",
	"journey_cave",
	"journey_citadel"
}
local var_0_21 = {}

var_0_0.grudge_marks_on_kill_util = {
	display_completion_ui = false,
	events = {
		"register_kill"
	},
	completed = function (arg_2_0, arg_2_1, arg_2_2)
		local var_2_0 = Managers.backend:get_interface("loot")

		for iter_2_0 = 1, #var_0_21 do
			local var_2_1 = var_0_21[iter_2_0]

			if not (var_0_0[var_2_1].completed(arg_2_0, arg_2_1) or var_2_0:achievement_rewards_claimed(var_2_1)) then
				return false
			end
		end

		return true
	end,
	on_event = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		local var_3_0 = arg_3_4[var_0_13]

		if not var_3_0 or not var_3_0.boss then
			return
		end

		local var_3_1 = var_3_0.name

		if not var_3_1 or not var_0_19[var_3_1] then
			return
		end

		local var_3_2 = arg_3_4[var_0_11]

		if not var_3_2 then
			return
		end

		if not Managers.state.entity:system("ai_system"):get_attributes(var_3_2).grudge_marked then
			return
		end

		local var_3_3 = Managers.player:local_player().player_unit
		local var_3_4 = ScriptUnit.has_extension(var_3_3, "career_system")
		local var_3_5 = var_3_4 and var_3_4:career_name()

		if not var_3_5 then
			return
		end

		arg_3_0:increment_stat(arg_3_1, "grudge_mark_kills", var_3_5)

		local var_3_6 = Managers.mechanism:game_mechanism()
		local var_3_7 = var_3_6 and var_3_6.get_deus_run_controller and var_3_6:get_deus_run_controller()
		local var_3_8 = var_3_7 and var_3_7:get_journey_name()

		if var_3_8 then
			arg_3_0:increment_stat(arg_3_1, "grudge_marks_kills_per_career_per_expedition", var_3_5, var_3_8)
		end

		arg_3_0:increment_stat(arg_3_1, "grudge_marks_kills_per_career_per_monster", var_3_5, var_3_1)
	end
}

for iter_0_0, iter_0_1 in pairs(CareerSettings) do
	if iter_0_0 ~= "empire_soldier_tutorial" then
		local var_0_22 = iter_0_1.breed

		if var_0_22 and var_0_22.is_hero then
			local var_0_23 = iter_0_1.required_dlc

			for iter_0_2 = 1, #var_0_20 do
				local var_0_24 = var_0_20[iter_0_2]
				local var_0_25 = "grudge_mark_kills_" .. iter_0_0 .. "_per_" .. var_0_24

				var_0_0[var_0_25] = {
					display_completion_ui = false,
					name = var_0_24 .. "_name",
					icon = "achievement_trophy_" .. var_0_25,
					required_dlc = var_0_23,
					completed = function (arg_4_0, arg_4_1, arg_4_2)
						return arg_4_0:get_persistent_stat(arg_4_1, "grudge_marks_kills_per_career_per_expedition", iter_0_0, var_0_24) >= 1
					end
				}
			end

			for iter_0_3 = 1, #var_0_19 do
				local var_0_26 = var_0_19[iter_0_3]
				local var_0_27 = "grudge_mark_kills_" .. iter_0_0 .. "_per_" .. var_0_26

				var_0_0[var_0_27] = {
					display_completion_ui = false,
					name = var_0_26,
					icon = "achievement_trophy_" .. var_0_27,
					required_dlc = var_0_23,
					completed = function (arg_5_0, arg_5_1, arg_5_2)
						return arg_5_0:get_persistent_stat(arg_5_1, "grudge_marks_kills_per_career_per_monster", iter_0_0, var_0_26) >= 1
					end
				}
			end

			local var_0_28 = "grudge_mark_kills_grind_" .. iter_0_0

			var_0_0[var_0_28] = {
				display_completion_ui = true,
				name = "achv_" .. var_0_28 .. "_name",
				desc = "achv_" .. var_0_28 .. "_desc",
				icon = "achievement_trophy_" .. var_0_28,
				required_dlc = var_0_23,
				progress = function (arg_6_0, arg_6_1, arg_6_2)
					local var_6_0 = arg_6_0:get_persistent_stat(arg_6_1, "grudge_mark_kills", iter_0_0)

					return {
						var_6_0,
						5
					}
				end,
				completed = function (arg_7_0, arg_7_1, arg_7_2)
					return arg_7_0:get_persistent_stat(arg_7_1, "grudge_mark_kills", iter_0_0) >= 5
				end
			}

			local var_0_29 = {}

			for iter_0_4 = 1, #var_0_19 do
				local var_0_30 = var_0_19[iter_0_4]
				local var_0_31 = "grudge_mark_kills_" .. iter_0_0 .. "_per_" .. var_0_30

				table.insert(var_0_29, var_0_31)
			end

			local var_0_32 = "kill_each_monster_grudge_" .. iter_0_0
			local var_0_33 = "achievement_trophy_" .. var_0_32

			var_0_3(var_0_0, var_0_32, var_0_29, icon, var_0_23, nil, nil)

			local var_0_34 = {}

			for iter_0_5 = 1, #var_0_20 do
				local var_0_35 = var_0_20[iter_0_5]
				local var_0_36 = "grudge_mark_kills_" .. iter_0_0 .. "_per_" .. var_0_35

				table.insert(var_0_34, var_0_36)
			end

			local var_0_37 = "kill_grudge_each_expedition_" .. iter_0_0
			local var_0_38 = "achievement_trophy_" .. var_0_37, var_0_3(var_0_0, var_0_37, var_0_34, var_0_33, var_0_23, nil, nil)
			local var_0_39 = {
				"kill_grudge_each_expedition_" .. iter_0_0,
				"kill_each_monster_grudge_" .. iter_0_0,
				"grudge_mark_kills_grind_" .. iter_0_0
			}
			local var_0_40 = "complete_all_career_grudge_challenges_" .. iter_0_0
			local var_0_41 = "achievement_trophy_" .. var_0_40, var_0_3(var_0_0, var_0_40, var_0_39, var_0_38, var_0_23, nil, nil)

			table.insert(var_0_21, var_0_40)
		end
	end
end
