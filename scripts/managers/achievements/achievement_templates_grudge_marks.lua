-- chunkname: @scripts/managers/achievements/achievement_templates_grudge_marks.lua

local achievements = AchievementTemplates.achievements
local achievement_settings = DLCSettings.grudge_marks
local add_weapon_kill_challenge = AchievementTemplateHelper.add_weapon_kill_challenge
local add_meta_challenge = AchievementTemplateHelper.add_meta_challenge
local add_multi_stat_count_challenge = AchievementTemplateHelper.add_multi_stat_count_challenge
local add_event_challenge = AchievementTemplateHelper.add_event_challenge
local add_stat_count_challenge = AchievementTemplateHelper.add_stat_count_challenge

local function rpc_increment_stat(unit, stat_name)
	-- function 1
	local player = Managers.player:unit_owner(unit)

	if player and not player.bot_player then
		local peer_id = player:network_id()
		local network_manager = Managers.state.network
		local stat_id = NetworkLookup.statistics[stat_name]

		network_manager.network_transmit:send_rpc("rpc_increment_stat", peer_id, stat_id)
	end
end

local XB1_ACHIEVEMENT_ID = {}
local PS4_ACHIEVEMENT_ID = {}
local register_kill_stats_id = 1
local register_kill_victim_unit = 2
local register_kill_damage_data = 3
local register_kill_victim_breed = 4
local register_damage_stats_id = 1
local register_damage_victim_unit = 2
local register_damage_damage_data = 3
local register_damage_attacker_unit = 4
local register_damage_target_breed = 5
local relevant_bosses = table.mirror_array_inplace({
	"skaven_rat_ogre",
	"skaven_stormfiend",
	"chaos_spawn",
	"beastmen_minotaur",
	"chaos_troll"
})
local expeditions = {
	"journey_ruin",
	"journey_ice",
	"journey_cave",
	"journey_citadel"
}
local achievement_to_check = {}

achievements.grudge_marks_on_kill_util = {
	display_completion_ui = false,
	events = {
		"register_kill"
	},
	completed = function (statistics_db, stats_id, template_data)
		-- function 2
		local backend_interface_loot = Managers.backend:get_interface("loot")

		for i = 1, #achievement_to_check do
			local achievement_id = achievement_to_check[i]
			local completed = achievements[achievement_id].completed(statistics_db, stats_id)

			completed = not not completed or not not backend_interface_loot:achievement_rewards_claimed(achievement_id)

			if not completed then
				return false
			end
		end

		return true
	end,
	on_event = function (statistics_db, stats_id, template_data, event_name, event_data)
		-- function 3
		local target_breed = event_data[register_kill_victim_breed]

		if not target_breed or not target_breed.boss then
			return
		end

		local killed_breed_name = target_breed.name

		if not killed_breed_name or not relevant_bosses[killed_breed_name] then
			return
		end

		local killed_unit = event_data[register_kill_victim_unit]

		if not killed_unit then
			return
		end

		local ai_system = Managers.state.entity:system("ai_system")
		local attributes = ai_system:get_attributes(killed_unit)

		if not attributes.grudge_marked then
			return
		end

		local local_player_unit = Managers.player:local_player().player_unit
		local career_extension = ScriptUnit.has_extension(local_player_unit, "career_system")
		local career_name = not not career_extension and not not career_extension:career_name()

		if not career_name then
			return
		end

		statistics_db:increment_stat(stats_id, "grudge_mark_kills", career_name)

		local mechanism = Managers.mechanism:game_mechanism()

		if mechanism then
			-- Nothing
		end

		::label_3_0::

		local get_deus_run_controller = mechanism.get_deus_run_controller

		if get_deus_run_controller then
			-- Nothing
		end

		get_deus_run_controller = mechanism:get_deus_run_controller()

		local deus_run_controller = get_deus_run_controller

		::label_3_1::

		local journey_name = not not deus_run_controller and not not deus_run_controller:get_journey_name()

		if journey_name then
			statistics_db:increment_stat(stats_id, "grudge_marks_kills_per_career_per_expedition", career_name, journey_name)
		end

		statistics_db:increment_stat(stats_id, "grudge_marks_kills_per_career_per_monster", career_name, killed_breed_name)
	end
}

for career, career_settings in pairs(CareerSettings) do
	if career ~= "empire_soldier_tutorial" then
		local career_breed = career_settings.breed

		if career_breed and career_breed.is_hero then
			local required_dlc = career_settings.required_dlc

			for i = 1, #expeditions do
				local expedition_name = expeditions[i]
				local achievement_id = "grudge_mark_kills_" .. career .. "_per_" .. expedition_name

				achievements[achievement_id] = {
					display_completion_ui = false,
					name = expedition_name .. "_name",
					icon = "achievement_trophy_" .. achievement_id,
					required_dlc = required_dlc,
					completed = function (statistics_db, stats_id, template_data)
						-- function 4
						return statistics_db:get_persistent_stat(stats_id, "grudge_marks_kills_per_career_per_expedition", career, expedition_name) >= 1
					end
				}
			end

			for i = 1, #relevant_bosses do
				local breed_name = relevant_bosses[i]
				local achievement_id = "grudge_mark_kills_" .. career .. "_per_" .. breed_name

				achievements[achievement_id] = {
					display_completion_ui = false,
					name = breed_name,
					icon = "achievement_trophy_" .. achievement_id,
					required_dlc = required_dlc,
					completed = function (statistics_db, stats_id, template_data)
						-- function 5
						return statistics_db:get_persistent_stat(stats_id, "grudge_marks_kills_per_career_per_monster", career, breed_name) >= 1
					end
				}
			end

			local achievement_id = "grudge_mark_kills_grind_" .. career

			achievements[achievement_id] = {
				display_completion_ui = true,
				name = "achv_" .. achievement_id .. "_name",
				desc = "achv_" .. achievement_id .. "_desc",
				icon = "achievement_trophy_" .. achievement_id,
				required_dlc = required_dlc,
				progress = function (statistics_db, stats_id, template_data)
					-- function 6
					local completed = statistics_db:get_persistent_stat(stats_id, "grudge_mark_kills", career)

					return {
						completed,
						5
					}
				end,
				completed = function (statistics_db, stats_id, template_data)
					-- function 7
					return statistics_db:get_persistent_stat(stats_id, "grudge_mark_kills", career) >= 5
				end
			}

			local achievement_group = {}

			for i = 1, #relevant_bosses do
				local breed_name = relevant_bosses[i]
				local stat_count_achv = "grudge_mark_kills_" .. career .. "_per_" .. breed_name

				table.insert(achievement_group, stat_count_achv)
			end

			local achievement_id = "kill_each_monster_grudge_" .. career
			local icon = "achievement_trophy_" .. achievement_id, add_meta_challenge(achievements, achievement_id, achievement_group, icon, required_dlc, nil, nil)

			achievement_group = {}

			for i = 1, #expeditions do
				local expedition_name = expeditions[i]
				local stat_count_achv = "grudge_mark_kills_" .. career .. "_per_" .. expedition_name

				table.insert(achievement_group, stat_count_achv)
			end

			achievement_id = "kill_grudge_each_expedition_" .. career
			icon = "achievement_trophy_" .. achievement_id, add_meta_challenge(achievements, achievement_id, achievement_group, icon, required_dlc, nil, nil)
			achievement_group = {
				"kill_grudge_each_expedition_" .. career,
				"kill_each_monster_grudge_" .. career,
				"grudge_mark_kills_grind_" .. career
			}
			achievement_id = "complete_all_career_grudge_challenges_" .. career
			icon = "achievement_trophy_" .. achievement_id, add_meta_challenge(achievements, achievement_id, achievement_group, icon, required_dlc, nil, nil)

			table.insert(achievement_to_check, achievement_id)
		end
	end
end
