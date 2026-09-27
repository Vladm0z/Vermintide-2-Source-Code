-- chunkname: @scripts/managers/achievements/achievement_templates_karak_azgaraz_part_1.lua

local add_event_challenge = AchievementTemplateHelper.add_event_challenge
local add_levels_complete_challenge = AchievementTemplateHelper.add_levels_complete_challenge
local add_meta_challenge = AchievementTemplateHelper.add_meta_challenge
local achievements = AchievementTemplates.achievements
local add_console_achievements = AchievementTemplateHelper.add_console_achievements
local tbl = {
	dwarf_valaya_emote = 113,
	dwarf_barrel_carry = 112,
	karak_azgaraz_complete_dlc_dwarf_interior_legend = 119
}
local tbl_2 = {
	dwarf_valaya_emote = "092"
}
local tbl_3 = {}
local tbl_4 = {
	LevelSettings.dlc_dwarf_interior
}
local tbl_5 = {
	"normal",
	"hard",
	"harder",
	"hardest",
	"cataclysm"
}
local tbl_6 = {
	hardest = "legend",
	hard = "veteran",
	harder = "champion",
	cataclysm = "cataclysm",
	normal = "recruit"
}

for i = 1, #tbl_5 do
	local var_0_11 = tbl_5[i]
	local str = "karak_azgaraz_complete_dlc_dwarf_interior_" .. tbl_6[var_0_11]
	local str_2 = "achievement_interior_" .. tbl_6[var_0_11]

	tbl_3[i] = str

	add_levels_complete_challenge(achievements, str, tbl_4, DifficultySettings[var_0_11].rank, str_2, nil, tbl[str], tbl_2[str])
end

achievements.dwarf_valaya_emote = {
	name = "achv_dwarf_valaya_emote_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_valaya_emote",
	desc = "achv_dwarf_valaya_emote_desc",
	events = {
		"dwarf_valaya_emote"
	},
	completed = function (self, arg_1_1, arg_1_2)
		-- function 1
		return self:get_persistent_stat(arg_1_1, "dwarf_valaya_emote") >= 1
	end,
	on_event = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
		-- function 2
		if not arg_2_4[1] then
			arg_2_2.end_t = nil

			return
		end

		local local_player = Managers.player:local_player()
		local flag = not local_player and local_player.player_unit

		if not flag then
			return
		end

		local state_machine = ScriptUnit.extension(flag, "character_state_machine_system").state_machine
		local flag_2 = not state_machine and state_machine.state_current

		if not (not flag_2 and flag_2.name ~= "emote" or flag_2.current_emote == "anim_pose_unarmed_05") then
			arg_2_2.end_t = nil

			return
		end

		local time = Managers.time:time("game")

		if not arg_2_2.end_t then
			arg_2_2.end_t = time + 5
			arg_2_2.completed = false

			return
		end

		if not (not (time > arg_2_2.end_t) or arg_2_2.completed) then
			Managers.state.entity:system("audio_system"):_play_event("Play_hud_small_puzzle_cue", flag)

			local num = ScriptUnit.extension(flag, "health_system"):get_max_health() / 2

			if not Managers.player.is_server then
				DamageUtils.heal_network(flag, flag, num, "healing_draught")
			else
				local network = Managers.state.network
				local network_transmit = network.network_transmit
				local unit_game_object_id = network:unit_game_object_id(flag)
				local healing_draught = NetworkLookup.heal_types.healing_draught

				network_transmit:send_rpc_server("rpc_request_heal", unit_game_object_id, num, healing_draught)
			end

			self:increment_stat(arg_2_1, "dwarf_valaya_emote")

			arg_2_2.completed = true
		end
	end
}
achievements.dwarf_rune = {
	name = "achv_dwarf_rune_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_rune",
	desc = "achv_dwarf_rune_desc",
	events = {
		"dwarf_rune"
	},
	completed = function (self, arg_3_1, arg_3_2)
		-- function 3
		return self:get_persistent_stat(arg_3_1, "dwarf_rune") >= 1
	end,
	on_event = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		-- function 4
		self:increment_stat(arg_4_1, "dwarf_rune")
	end
}
achievements.dwarf_barrel_carry = {
	name = "achv_dwarf_barrel_carry_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_barrel_carry",
	desc = "achv_dwarf_barrel_carry_desc",
	events = {
		"objective_entered_socket_zone",
		"dwarf_barrel_carry"
	},
	completed = function (self, arg_5_1, arg_5_2)
		-- function 5
		return self:get_persistent_stat(arg_5_1, "dwarf_barrel_carry") >= 1
	end,
	on_event = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
		-- function 6
		local level_key = Managers.state.game_mode:level_key()

		if not (not level_key and level_key == "dlc_dwarf_interior") then
			return
		end

		if not arg_6_2.failed then
			return
		end

		if not arg_6_4[2] then
			arg_6_2.failed = true

			return
		end

		if not arg_6_4[1] then
			self:increment_stat(arg_6_1, "dwarf_barrel_carry")
		end
	end
}
achievements.dwarf_bells = {
	name = "achv_dwarf_bells_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_bells",
	desc = "achv_dwarf_bells_desc",
	events = {
		"dwarf_bells"
	},
	completed = function (self, arg_7_1, arg_7_2)
		-- function 7
		return self:get_persistent_stat(arg_7_1, "dwarf_bells") >= 1
	end,
	on_event = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
		-- function 8
		self:increment_stat(arg_8_1, "dwarf_bells")
	end
}

local num = 8

achievements.dwarf_pressure = {
	name = "achv_dwarf_pressure_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_pressure",
	desc = function ()
		-- function 9
		return string.format(Localize("achv_dwarf_pressure_desc"), num)
	end,
	events = {
		"dwarf_pressure"
	},
	completed = function (self, arg_10_1, arg_10_2)
		-- function 10
		return self:get_persistent_stat(arg_10_1, "dwarf_pressure") >= 1
	end,
	on_event = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
		-- function 11
		if not arg_11_2.failed then
			return
		end

		local var_11_0 = arg_11_4[1]
		local time = Managers.time:time("game")

		if not arg_11_2.num_valves then
			arg_11_2.num_valves = 0
		end

		if not var_11_0 then
			arg_11_2.start_t = time

			return
		end

		arg_11_2.num_valves = arg_11_2.num_valves + 1

		if arg_11_2.num_valves >= 4 then
			local network_transmit = Managers.state.network.network_transmit
			local dwarf_pressure = NetworkLookup.statistics.dwarf_pressure

			if not Managers.state.network.is_server then
				network_transmit:send_rpc_clients("rpc_increment_stat_party", dwarf_pressure)
			else
				network_transmit:send_rpc_server("rpc_increment_stat_party", dwarf_pressure)
			end
		end

		if not (not arg_11_2.start_t and not (time > arg_11_2.start_t + num)) then
			arg_11_2.failed = true

			return
		end
	end
}
interior_all_challenges = table.clone(tbl_3)

table.remove(interior_all_challenges, #interior_all_challenges)

interior_all_challenges[#interior_all_challenges + 1] = "dwarf_valaya_emote"
interior_all_challenges[#interior_all_challenges + 1] = "dwarf_rune"
interior_all_challenges[#interior_all_challenges + 1] = "dwarf_barrel_carry"
interior_all_challenges[#interior_all_challenges + 1] = "dwarf_bells"
interior_all_challenges[#interior_all_challenges + 1] = "dwarf_pressure"

add_meta_challenge(achievements, "interior_all_challenges", interior_all_challenges, "achievement_interior_meta", nil, tbl[name], tbl_2[name])
add_console_achievements(tbl, tbl_2)
