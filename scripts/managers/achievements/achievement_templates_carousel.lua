-- chunkname: @scripts/managers/achievements/achievement_templates_carousel.lua

local scripts_entity_system_systems_objective_objective_tags = require("scripts/entity_system/systems/objective/objective_tags")
local scripts_managers_achievements_achievement_event_parameters = require("scripts/managers/achievements/achievement_event_parameters")
local achievements = AchievementTemplates.achievements
local num = 1
local num_2 = 2
local num_3 = 3
local num_4 = 4
local num_5 = 1
local num_6 = 2
local num_7 = 3
local num_8 = 4
local num_9 = 1
local num_10 = 2
local num_11 = 3
local num_12 = 4
local num_13 = 5
local num_14 = 1
local num_15 = 1
local num_16 = 2
local num_17 = 1
local num_18 = 2
local num_19 = 1
local num_20 = 2
local num_21 = 3
local num_22 = 1
local num_23 = 2

achievements.vs_disable_reviving_hero = {
	required_dlc = "carousel",
	name = "achv_disable_reviving_hero_vs_name",
	display_completion_ui = true,
	icon = "revive_interrupt",
	desc = "achv_disable_reviving_hero_vs_desc",
	events = {
		"register_player_disabled"
	},
	on_event = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
		-- function 1
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_1_0 = arg_1_4[num_14]

		if not ALIVE[var_1_0] then
			return
		end

		local player_unit = Managers.player:local_player().player_unit
		local get_disabler_unit = ScriptUnit.extension(var_1_0, "status_system"):get_disabler_unit()

		if not (not ALIVE[player_unit] and player_unit == get_disabler_unit) then
			return
		end

		local is_interacting, var_1_4 = ScriptUnit.extension(var_1_0, "interactor_system"):is_interacting()

		if not (not is_interacting and var_1_4 == "revive") then
			return
		end

		self:increment_stat(arg_1_1, "vs_disable_reviving_hero")
	end,
	completed = function (self, arg_2_1)
		-- function 2
		return self:get_persistent_stat(arg_2_1, "vs_disable_reviving_hero") >= 1
	end
}
achievements.vs_kill_invisible_hero = {
	required_dlc = "carousel",
	name = "achv_kill_invisible_hero_vs_name",
	display_completion_ui = true,
	icon = "kill_invisible",
	desc = "achv_kill_invisible_hero_vs_desc",
	events = {
		"register_knockdown"
	},
	on_event = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		-- function 3
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_3_0 = arg_3_4[num_6]
		local var_3_1 = arg_3_4[num_7]
		local flag = not var_3_1 and var_3_1.player_unit
		local local_player = Managers.player:local_player()
		local player_unit = local_player.player_unit
		local has_extension = ScriptUnit.has_extension(var_3_0, "health_system")

		if not has_extension then
			local unique_id = local_player:unique_id()

			if not has_extension:was_attacked_by(unique_id) then
				flag = player_unit
			end
		end

		if not (not flag and player_unit == flag) then
			return
		end

		local get_data = Unit.get_data(flag, "breed")

		if not (not get_data and get_data.special and get_data.boss) then
			return
		end

		local has_extension_2 = ScriptUnit.has_extension(var_3_0, "status_system")

		if not has_extension_2 and not has_extension_2:is_invisible() then
			self:increment_stat(arg_3_1, "vs_kill_invisible_hero")
		end
	end,
	completed = function (self, arg_4_1)
		-- function 4
		return self:get_persistent_stat(arg_4_1, "vs_kill_invisible_hero") >= 1
	end
}

local tbl = {
	50,
	500,
	1250,
	2500,
	5000
}

for i = 1, #tbl do
	local flag = false
	local var_0_28
	local var_0_29

	if i == 1 then
		flag = true
		var_0_28 = {
			"register_kill"
		}

		function var_0_29(self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
			-- function 5
			if Managers.mechanism:current_mechanism_name() ~= "versus" then
				return
			end

			local var_5_0 = arg_5_4[num_2]
			local var_5_1 = arg_5_4[num_3][DamageDataIndex.ATTACKER]
			local local_player = Managers.player:local_player()
			local player_unit = local_player.player_unit
			local has_extension = ScriptUnit.has_extension(var_5_0, "health_system")

			if not has_extension then
				local unique_id = local_player:unique_id()

				if not has_extension:was_attacked_by(unique_id) then
					var_5_1 = player_unit
				end
			end

			if not (not var_5_1 and player_unit == var_5_1) then
				return
			end

			if not arg_5_4[num_4].special then
				return
			end

			self:increment_stat(arg_5_1, "vs_hero_eliminations")
		end
	end

	achievements["vs_hero_eliminations_" .. string.format("%02d", i)] = {
		group = "vs_hero_eliminations",
		display_completion_ui = true,
		required_dlc = "carousel",
		name = "achv_hero_eliminations_" .. string.format("%02d", i) .. "_vs_name",
		desc = function ()
			-- function 6
			return string.format(Localize("achv_hero_eliminations_" .. string.format("%02d", i) .. "_vs_desc"), tbl[i])
		end,
		icon = "hero_eliminations_" .. i,
		always_run = flag,
		events = var_0_28,
		on_event = var_0_29,
		completed = function (self, arg_7_1)
			-- function 7
			return self:get_persistent_stat(arg_7_1, "vs_hero_eliminations") >= tbl[i]
		end,
		progress = function (self, arg_8_1)
			-- function 8
			local var_8_0 = tbl[i]
			local min = math.min(self:get_persistent_stat(arg_8_1, "vs_hero_eliminations"), var_8_0)

			return {
				min,
				var_8_0
			}
		end
	}
end

local num_24 = 50

achievements.vs_hero_monster_kills = {
	name = "achv_hero_monster_kills_vs_name",
	display_completion_ui = true,
	icon = "kill_x_monsters",
	required_dlc = "carousel",
	desc = function ()
		-- function 9
		return string.format(Localize("achv_hero_monster_kills_vs_desc"), num_24)
	end,
	events = {
		"register_kill"
	},
	on_event = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
		-- function 10
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_10_0 = arg_10_4[num_2]
		local var_10_1 = arg_10_4[num_3][DamageDataIndex.ATTACKER]
		local local_player = Managers.player:local_player()
		local player_unit = local_player.player_unit
		local has_extension = ScriptUnit.has_extension(var_10_0, "health_system")

		if not has_extension then
			local unique_id = local_player:unique_id()

			if not has_extension:was_attacked_by(unique_id) then
				var_10_1 = player_unit
			end
		end

		if not (not var_10_1 and player_unit == var_10_1) then
			return
		end

		if not arg_10_4[num_4].boss then
			return
		end

		self:increment_stat(arg_10_1, "vs_hero_monster_kill")
	end,
	completed = function (self, arg_11_1)
		-- function 11
		return self:get_persistent_stat(arg_11_1, "vs_hero_monster_kill") >= num_24
	end,
	progress = function (self, arg_12_1)
		-- function 12
		local var_12_0 = num_24
		local min = math.min(self:get_persistent_stat(arg_12_1, "vs_hero_monster_kill"), var_12_0)

		return {
			min,
			var_12_0
		}
	end
}

local num_25 = 50

achievements.vs_hero_obj_barrels = {
	name = "achv_hero_obj_barrels_vs_name",
	display_completion_ui = true,
	icon = "socket_x_items",
	required_dlc = "carousel",
	desc = function ()
		-- function 13
		return string.format(Localize("achv_hero_obj_barrels_vs_desc"), num_25)
	end,
	events = {
		"register_objective_completed"
	},
	on_event = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
		-- function 14
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		if arg_14_4[num_19].objective_type ~= "objective_socket" then
			return
		end

		local var_14_0 = arg_14_4[num_20]
		local unique_id = Managers.player:local_player():unique_id()

		if var_14_0 == Managers.party:get_party_from_unique_id(unique_id).party_id then
			self:increment_stat(arg_14_1, "vs_hero_obj_barrels")
		end
	end,
	progress = function (self, arg_15_1)
		-- function 15
		local var_15_0 = num_25
		local min = math.min(self:get_persistent_stat(arg_15_1, "vs_hero_obj_barrels"), var_15_0)

		return {
			min,
			var_15_0
		}
	end,
	completed = function (self, arg_16_1)
		-- function 16
		return self:get_persistent_stat(arg_16_1, "vs_hero_obj_barrels") >= num_25
	end
}

local num_26 = 50

achievements.vs_hero_obj_chains = {
	name = "achv_hero_obj_chains_vs_name",
	display_completion_ui = true,
	icon = "destroy_x_chains_as_team",
	required_dlc = "carousel",
	desc = function ()
		-- function 17
		return string.format(Localize("achv_hero_obj_chains_vs_desc"), num_26)
	end,
	events = {
		"register_objective_completed"
	},
	on_event = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
		-- function 18
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		if arg_18_4[num_21]:objective_tag() ~= scripts_entity_system_systems_objective_objective_tags.objective_tag_chains then
			return
		end

		local var_18_0 = arg_18_4[num_20]
		local unique_id = Managers.player:local_player():unique_id()

		if var_18_0 == Managers.party:get_party_from_unique_id(unique_id).party_id then
			self:increment_stat(arg_18_1, "vs_hero_obj_chains")
		end
	end,
	progress = function (self, arg_19_1)
		-- function 19
		local var_19_0 = num_26
		local min = math.min(self:get_persistent_stat(arg_19_1, "vs_hero_obj_chains"), var_19_0)

		return {
			min,
			var_19_0
		}
	end,
	completed = function (self, arg_20_1)
		-- function 20
		return self:get_persistent_stat(arg_20_1, "vs_hero_obj_chains") >= num_26
	end
}

local num_27 = 25

achievements.vs_hero_obj_capture = {
	name = "achv_hero_obj_capture_vs_name",
	display_completion_ui = true,
	icon = "contribute_x_to_capture_points",
	required_dlc = "carousel",
	desc = function ()
		-- function 21
		return string.format(Localize("achv_hero_obj_capture_vs_desc"), num_27)
	end,
	events = {
		"register_objective_completed"
	},
	on_event = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
		-- function 22
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		if arg_22_4[num_19].objective_type ~= "objective_capture_point" then
			return
		end

		local var_22_0 = arg_22_4[num_20]
		local unique_id = Managers.player:local_player():unique_id()

		if var_22_0 == Managers.party:get_party_from_unique_id(unique_id).party_id then
			self:increment_stat(arg_22_1, "vs_hero_obj_capture")
		end
	end,
	progress = function (self, arg_23_1)
		-- function 23
		local var_23_0 = num_27
		local min = math.min(self:get_persistent_stat(arg_23_1, "vs_hero_obj_capture"), var_23_0)

		return {
			min,
			var_23_0
		}
	end,
	completed = function (self, arg_24_1)
		-- function 24
		return self:get_persistent_stat(arg_24_1, "vs_hero_obj_capture") >= num_27
	end
}

local tbl_2 = {
	5,
	25,
	50,
	100,
	250
}

for j = 1, #tbl_2 do
	achievements["vs_wins_" .. string.format("%02d", j)] = {
		required_dlc = "carousel",
		display_completion_ui = true,
		group = "vs_wins",
		name = "achv_wins_" .. string.format("%02d", j) .. "_vs_name",
		desc = function ()
			-- function 25
			return string.format(Localize("achv_wins_" .. string.format("%02d", j) .. "_vs_desc"), tbl_2[j])
		end,
		icon = "wins_" .. j,
		completed = function (self, arg_26_1)
			-- function 26
			return self:get_persistent_stat(arg_26_1, "vs_game_won") >= tbl_2[j]
		end,
		progress = function (self, arg_27_1)
			-- function 27
			local var_27_0 = tbl_2[j]
			local min = math.min(self:get_persistent_stat(arg_27_1, "vs_game_won"), var_27_0)

			return {
				min,
				var_27_0
			}
		end
	}
end

local num_28 = 50

achievements.vs_hero_obj_safezone = {
	name = "achv_hero_obj_safezone_vs_name",
	display_completion_ui = true,
	icon = "safe_zone",
	required_dlc = "carousel",
	desc = function ()
		-- function 28
		return string.format(Localize("achv_hero_obj_safezone_vs_desc"), num_28)
	end,
	events = {
		"register_objective_completed"
	},
	on_event = function (self, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
		-- function 29
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		if arg_29_4[num_19].objective_type ~= "objective_safehouse" then
			return
		end

		local var_29_0 = arg_29_4[num_20]
		local unique_id = Managers.player:local_player():unique_id()

		if var_29_0 == Managers.party:get_party_from_unique_id(unique_id).party_id then
			self:increment_stat(arg_29_1, "vs_hero_obj_safezone")
		end
	end,
	progress = function (self, arg_30_1)
		-- function 30
		local var_30_0 = num_28
		local min = math.min(self:get_persistent_stat(arg_30_1, "vs_hero_obj_safezone"), var_30_0)

		return {
			min,
			var_30_0
		}
	end,
	completed = function (self, arg_31_1)
		-- function 31
		return self:get_persistent_stat(arg_31_1, "vs_hero_obj_safezone") >= num_28
	end
}

local num_29 = 50

achievements.vs_hero_revive = {
	name = "achv_hero_revive_vs_name",
	display_completion_ui = true,
	icon = "revive",
	required_dlc = "carousel",
	desc = function ()
		-- function 32
		return string.format(Localize("achv_hero_revive_vs_desc"), num_29)
	end,
	events = {
		"register_revive"
	},
	on_event = function (self, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
		-- function 33
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_33_0 = arg_33_4[num_15]
		local player_unit = Managers.player:local_player().player_unit

		if not (not var_33_0 and player_unit == var_33_0) then
			return
		end

		self:increment_stat(arg_33_1, "vs_hero_revive")
	end,
	completed = function (self, arg_34_1)
		-- function 34
		return self:get_persistent_stat(arg_34_1, "vs_hero_revive") >= num_29
	end,
	progress = function (self, arg_35_1)
		-- function 35
		local var_35_0 = num_29
		local min = math.min(self:get_persistent_stat(arg_35_1, "vs_hero_revive"), var_35_0)

		return {
			min,
			var_35_0
		}
	end
}

local num_30 = 100

achievements.vs_hero_obj_reach = {
	name = "achv_hero_obj_reach_vs_name",
	display_completion_ui = true,
	icon = "hero_objective_reach",
	required_dlc = "carousel",
	desc = function ()
		-- function 36
		return string.format(Localize("achv_hero_obj_reach_vs_desc"), num_30)
	end,
	events = {
		"register_objective_completed"
	},
	on_event = function (self, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
		-- function 37
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_37_0 = arg_37_4[num_19]

		if not (var_37_0.objective_type ~= "objective_reach" or var_37_0.score_for_completion ~= 0) then
			return
		end

		local var_37_1 = arg_37_4[num_20]
		local unique_id = Managers.player:local_player():unique_id()

		if var_37_1 == Managers.party:get_party_from_unique_id(unique_id).party_id then
			self:increment_stat(arg_37_1, "vs_hero_obj_reach")
		end
	end,
	progress = function (self, arg_38_1)
		-- function 38
		local var_38_0 = num_30
		local min = math.min(self:get_persistent_stat(arg_38_1, "vs_hero_obj_reach"), var_38_0)

		return {
			min,
			var_38_0
		}
	end,
	completed = function (self, arg_39_1)
		-- function 39
		return self:get_persistent_stat(arg_39_1, "vs_hero_obj_reach") >= num_30
	end
}

local num_31 = 50

achievements.vs_hero_rescue = {
	name = "achv_hero_rescue_vs_name",
	display_completion_ui = true,
	icon = "rescue_prisoners",
	required_dlc = "carousel",
	desc = function ()
		-- function 40
		return string.format(Localize("achv_hero_rescue_vs_desc"), num_31)
	end,
	events = {
		"register_objective_completed"
	},
	on_event = function (self, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
		-- function 41
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		if arg_41_4[num_21]:objective_tag() ~= scripts_entity_system_systems_objective_objective_tags.objective_tag_prisoner then
			return
		end

		local var_41_0 = arg_41_4[num_20]
		local unique_id = Managers.player:local_player():unique_id()

		if var_41_0 == Managers.party:get_party_from_unique_id(unique_id).party_id then
			self:increment_stat(arg_41_1, "vs_hero_rescue")
		end
	end,
	completed = function (self, arg_42_1)
		-- function 42
		return self:get_persistent_stat(arg_42_1, "vs_hero_rescue") >= num_31
	end,
	progress = function (self, arg_43_1)
		-- function 43
		local var_43_0 = num_31
		local min = math.min(self:get_persistent_stat(arg_43_1, "vs_hero_rescue"), var_43_0)

		return {
			min,
			var_43_0
		}
	end
}
achievements.vs_air_gutter_runner = {
	required_dlc = "carousel",
	name = "achv_air_gutter_runner_vs_name",
	display_completion_ui = true,
	icon = "air_gutter_runner",
	desc = "achv_air_gutter_runner_vs_desc",
	events = {
		"register_kill"
	},
	on_event = function (self, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
		-- function 44
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_44_0 = arg_44_4[num_3][DamageDataIndex.ATTACKER]
		local player_unit = Managers.player:local_player().player_unit

		if not (not var_44_0 and player_unit == var_44_0) then
			return
		end

		local var_44_2 = arg_44_4[num_4]

		if not (not var_44_2 and not var_44_2.name and var_44_2.name == "vs_gutter_runner") then
			return
		end

		local var_44_3 = arg_44_4[num_2]
		local has_extension = ScriptUnit.has_extension(var_44_3, "status_system")

		if not has_extension and not has_extension:is_gutter_runner_leaping() then
			self:increment_stat(arg_44_1, "vs_air_gutter_runner")
		end
	end,
	completed = function (self, arg_45_1)
		-- function 45
		return self:get_persistent_stat(arg_45_1, "vs_air_gutter_runner") >= 1
	end
}
achievements.vs_clutch_revive = {
	required_dlc = "carousel",
	name = "achv_clutch_revive_vs_name",
	display_completion_ui = true,
	icon = "clutch_revive",
	desc = "achv_clutch_revive_vs_desc",
	events = {
		"register_revive"
	},
	on_event = function (self, arg_46_1, arg_46_2, arg_46_3, arg_46_4)
		-- function 46
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_46_0 = arg_46_4[num_15]
		local player_unit = Managers.player:local_player().player_unit

		if not (not var_46_0 and player_unit == var_46_0) then
			return
		end

		local PLAYER_AND_BOT_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS

		for k, v in pairs(PLAYER_AND_BOT_UNITS) do
			if not (not ALIVE[v] and v == player_unit) then
				local has_extension = ScriptUnit.has_extension(v, "status_system")

				if not (not has_extension and has_extension:is_knocked_down() or has_extension:is_ready_for_assisted_respawn() or has_extension:is_dead()) then
					return
				end
			end
		end

		self:increment_stat(arg_46_1, "vs_clutch_revive")
	end,
	completed = function (self, arg_47_1)
		-- function 47
		return self:get_persistent_stat(arg_47_1, "vs_clutch_revive") >= 1
	end
}

local tbl_3 = {
	10,
	50,
	100,
	250,
	500
}

for k = 1, #tbl_3 do
	achievements["vs_packmaster_eliminations_" .. string.format("%02d", k)] = {
		required_dlc = "carousel",
		display_completion_ui = true,
		group = "vs_packmaster_eliminations",
		name = "achv_packmaster_" .. string.format("%02d", k) .. "_vs_name",
		desc = function ()
			-- function 48
			return string.format(Localize("achv_packmaster_" .. string.format("%02d", k) .. "_vs_desc"), tbl_3[k])
		end,
		icon = "packmaster_" .. k,
		completed = function (self, arg_49_1)
			-- function 49
			return self:get_persistent_stat(arg_49_1, "eliminations_as_breed", "vs_packmaster") >= tbl_3[k]
		end,
		progress = function (self, arg_50_1)
			-- function 50
			local var_50_0 = tbl_3[k]
			local min = math.min(self:get_persistent_stat(arg_50_1, "eliminations_as_breed", "vs_packmaster"), var_50_0)

			return {
				min,
				var_50_0
			}
		end
	}
end

local num_32 = 50

achievements.vs_hoist_heroes = {
	name = "achv_hoist_heroes_vs_name",
	display_completion_ui = true,
	icon = "hoist_heroes",
	required_dlc = "carousel",
	desc = function ()
		-- function 51
		return string.format(Localize("achv_hoist_heroes_vs_desc"), num_32)
	end,
	events = {
		"register_player_disabled"
	},
	on_event = function (self, arg_52_1, arg_52_2, arg_52_3, arg_52_4)
		-- function 52
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_52_0 = arg_52_4[num_14]

		if not ALIVE[var_52_0] then
			return
		end

		if not Unit.get_data(var_52_0, "breed").is_hero then
			return
		end

		local has_extension = ScriptUnit.has_extension(var_52_0, "status_system")

		if not has_extension then
			return
		end

		if not has_extension:is_hanging_from_hook() then
			return
		end

		local get_pack_master_grabber = has_extension:get_pack_master_grabber()
		local player_unit = Managers.player:local_player().player_unit

		if not (not player_unit and player_unit ~= get_pack_master_grabber) then
			self:increment_stat(arg_52_1, "vs_hoist_heroes")
		end
	end,
	completed = function (self, arg_53_1)
		-- function 53
		return self:get_persistent_stat(arg_53_1, "vs_hoist_heroes") >= num_32
	end,
	progress = function (self, arg_54_1)
		-- function 54
		local min = math.min(self:get_persistent_stat(arg_54_1, "vs_hoist_heroes"), num_32)

		return {
			min,
			num_32
		}
	end
}

local num_33 = 500

achievements.vs_drag_heroes = {
	required_dlc = "carousel",
	name = "achv_drag_heroes_vs_name",
	display_completion_ui = true,
	icon = "drag_heroes",
	desc = function ()
		-- function 55
		return string.format(Localize("achv_drag_heroes_vs_desc"), num_33)
	end,
	completed = function (self, arg_56_1)
		-- function 56
		return self:get_persistent_stat(arg_56_1, "vs_drag_heroes") >= num_33
	end,
	progress = function (self, arg_57_1)
		-- function 57
		local min = math.min(self:get_persistent_stat(arg_57_1, "vs_drag_heroes"), num_33)

		return {
			min,
			num_33
		}
	end
}

local tbl_4 = {
	10,
	50,
	100,
	250,
	500
}

for l = 1, #tbl_4 do
	achievements["vs_gutter_runner_eliminations_" .. string.format("%02d", l)] = {
		required_dlc = "carousel",
		display_completion_ui = true,
		group = "vs_gutter_runner_eliminations",
		name = "achv_gutter_runner_" .. string.format("%02d", l) .. "_vs_name",
		desc = function ()
			-- function 58
			return string.format(Localize("achv_gutter_runner_" .. string.format("%02d", l) .. "_vs_desc"), tbl_4[l])
		end,
		icon = "gutter_runner_" .. l,
		completed = function (self, arg_59_1)
			-- function 59
			return self:get_persistent_stat(arg_59_1, "eliminations_as_breed", "vs_gutter_runner") >= tbl_4[l]
		end,
		progress = function (self, arg_60_1)
			-- function 60
			local var_60_0 = tbl_4[l]
			local min = math.min(self:get_persistent_stat(arg_60_1, "eliminations_as_breed", "vs_gutter_runner"), var_60_0)

			return {
				min,
				var_60_0
			}
		end
	}
end

local num_34 = 100

achievements.vs_pounce_heroes = {
	name = "achv_pounce_heroes_vs_name",
	display_completion_ui = true,
	icon = "pounce_heroes",
	required_dlc = "carousel",
	desc = function ()
		-- function 61
		return string.format(Localize("achv_pounce_heroes_vs_desc"), num_34)
	end,
	events = {
		"register_player_disabled"
	},
	on_event = function (self, arg_62_1, arg_62_2, arg_62_3, arg_62_4)
		-- function 62
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_62_0 = arg_62_4[num_14]

		if not ALIVE[var_62_0] then
			return
		end

		if not Unit.get_data(var_62_0, "breed").is_hero then
			return
		end

		local has_extension = ScriptUnit.has_extension(var_62_0, "status_system")

		if not has_extension then
			return
		end

		local is_pounced_down, var_62_3 = has_extension:is_pounced_down()

		if not is_pounced_down then
			return
		end

		local player_unit = Managers.player:local_player().player_unit

		if not (not player_unit and player_unit ~= var_62_3) then
			self:increment_stat(arg_62_1, "vs_pounce_heroes")
		end
	end,
	completed = function (self, arg_63_1)
		-- function 63
		return self:get_persistent_stat(arg_63_1, "vs_pounce_heroes") >= num_34
	end,
	progress = function (self, arg_64_1)
		-- function 64
		local min = math.min(self:get_persistent_stat(arg_64_1, "vs_pounce_heroes"), num_34)

		return {
			min,
			num_34
		}
	end
}
achievements.vs_gas_combo_pounce = {
	required_dlc = "carousel",
	name = "achv_gas_combo_pounce_vs_name",
	display_completion_ui = true,
	icon = "gas_combo_pounce",
	desc = "achv_gas_combo_pounce_vs_desc",
	events = {
		"register_player_disabled"
	},
	on_event = function (self, arg_65_1, arg_65_2, arg_65_3, arg_65_4)
		-- function 65
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_65_0 = arg_65_4[num_14]

		if not ALIVE[var_65_0] then
			return
		end

		if not Unit.get_data(var_65_0, "breed").is_hero then
			return
		end

		local has_extension = ScriptUnit.has_extension(var_65_0, "status_system")

		if not has_extension then
			return
		end

		local is_pounced_down, var_65_3 = has_extension:is_pounced_down()

		if not is_pounced_down then
			return
		end

		local player_unit = Managers.player:local_player().player_unit

		if not (not ALIVE[player_unit] and player_unit == var_65_3) then
			return
		end

		local get_extensions_from_extension_name = Managers.state.entity:system("area_damage_system"):get_extensions_from_extension_name("AreaDamageExtension")

		for k, v in pairs(get_extensions_from_extension_name) do
			local radius = v.radius
			local var_65_7 = POSITION_LOOKUP[var_65_0]
			local local_position = Unit.local_position(k, 0)

			if not (Vector3.distance_squared(var_65_7, local_position) < radius * radius) then
				self:increment_stat(arg_65_1, "vs_gas_combo_pounce")

				return
			end
		end
	end,
	completed = function (self, arg_66_1)
		-- function 66
		return self:get_persistent_stat(arg_66_1, "vs_gas_combo_pounce") >= 1
	end
}

local tbl_5 = {
	500,
	2500,
	5000,
	10000,
	25000
}

for i4 = 1, #tbl_5 do
	achievements["vs_warpfire_thrower_damage_" .. string.format("%02d", i4)] = {
		required_dlc = "carousel",
		display_completion_ui = true,
		group = "vs_warpfire_thrower_damage",
		name = "achv_warpfire_thrower_" .. string.format("%02d", i4) .. "_vs_name",
		desc = function ()
			-- function 67
			return string.format(Localize("achv_warpfire_thrower_" .. string.format("%02d", i4) .. "_vs_desc"), tbl_5[i4])
		end,
		icon = "warpfire_thrower_" .. i4,
		completed = function (self, arg_68_1)
			-- function 68
			return self:get_persistent_stat(arg_68_1, "damage_dealt_as_breed", "vs_warpfire_thrower") >= tbl_5[i4]
		end,
		progress = function (self, arg_69_1)
			-- function 69
			local var_69_0 = tbl_5[i4]
			local min = math.min(self:get_persistent_stat(arg_69_1, "damage_dealt_as_breed", "vs_warpfire_thrower"), var_69_0)

			return {
				min,
				var_69_0
			}
		end
	}
end

local num_35 = 3
local num_36 = 6
local num_37 = 4

local function fn(self, arg_70_1)
	-- function 70
	local unbox = self.knockback_position:unbox()
	local is_valid = Unit.is_valid(arg_70_1)

	is_valid = not is_valid and not not Unit.is_frozen(arg_70_1) or Unit.local_position(arg_70_1, 0)

	if not (not is_valid and not (unbox[3] - is_valid[3] < num_37)) then
		return false
	end

	return true
end

achievements.vs_push_hero_off_map = {
	name = "achv_push_hero_off_map_vs_name",
	display_completion_ui = true,
	required_dlc = "carousel",
	icon = "push_hero_off_map",
	desc = "achv_push_hero_off_map_vs_desc",
	events = {
		"register_kill",
		"register_damage",
		"register_player_disabled"
	},
	completed = function (self, arg_71_1, arg_71_2)
		-- function 71
		return self:get_persistent_stat(arg_71_1, "vs_push_hero_off_map") >= 1
	end,
	on_event = function (self, arg_72_1, arg_72_2, arg_72_3, arg_72_4)
		-- function 72
		local time = Managers.time:time("game")

		if arg_72_3 == "register_kill" then
			local var_72_1 = arg_72_4[num_2]
			local tracked_units = arg_72_2.tracked_units

			tracked_units = not tracked_units and arg_72_2.tracked_units[var_72_1]

			if not tracked_units then
				return
			end

			if time - tracked_units.knockback_time > num_36 then
				return false
			end

			if not fn(tracked_units, var_72_1) then
				self:increment_stat(arg_72_1, "vs_push_hero_off_map")

				return
			end
		elseif arg_72_3 == "register_damage" then
			local var_72_3 = arg_72_4[num_10]
			local get_data = Unit.get_data(var_72_3, "breed")

			if not (not get_data and get_data.is_hero) then
				return
			end

			local local_player = Managers.player:local_player()
			local flag = not local_player and local_player.player_unit
			local var_72_7 = arg_72_4[num_12]

			if not (not ALIVE[flag] and flag == var_72_7) then
				return
			end

			local get_data_2 = Unit.get_data(var_72_7, "breed")

			if not (not get_data_2 and get_data_2.name == "vs_warpfire_thrower") then
				return
			end

			local tracked_units_2 = arg_72_2.tracked_units

			tracked_units_2 = tracked_units_2 or {}
			arg_72_2.tracked_units = tracked_units_2

			local var_72_10 = arg_72_2.tracked_units[var_72_3]

			if not var_72_10 then
				var_72_10.knockback_time = time

				var_72_10.knockback_position:store(POSITION_LOOKUP[var_72_3])
			else
				arg_72_2.tracked_units[var_72_3] = {
					knockback_time = time,
					knockback_position = Vector3Box(POSITION_LOOKUP[var_72_3])
				}
			end
		elseif arg_72_3 == "register_player_disabled" then
			local var_72_11 = arg_72_4[num_14]

			if not ALIVE[var_72_11] then
				return
			end

			local tracked_units_3 = arg_72_2.tracked_units

			tracked_units_3 = not tracked_units_3 and arg_72_2.tracked_units[var_72_11]

			if not tracked_units_3 then
				return
			end

			local has_extension = ScriptUnit.has_extension(var_72_11, "status_system")

			if not (not has_extension and has_extension:get_is_ledge_hanging()) then
				return
			end

			if time - tracked_units_3.knockback_time > num_35 then
				return false
			end

			self:increment_stat(arg_72_1, "vs_push_hero_off_map")
		end
	end
}
achievements.vs_kill_hoisted_hero = {
	required_dlc = "carousel",
	name = "achv_kill_hoisted_hero_vs_name",
	display_completion_ui = true,
	icon = "kill_hoisted_hero",
	desc = "achv_kill_hoisted_hero_vs_desc",
	events = {
		"register_kill"
	},
	on_event = function (self, arg_73_1, arg_73_2, arg_73_3, arg_73_4)
		-- function 73
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_73_0 = arg_73_4[num_2]
		local var_73_1 = arg_73_4[num_3][DamageDataIndex.ATTACKER]
		local local_player = Managers.player:local_player()
		local player_unit = local_player.player_unit
		local has_extension = ScriptUnit.has_extension(var_73_0, "health_system")

		if not has_extension then
			local unique_id = local_player:unique_id()

			if not has_extension:was_attacked_by(unique_id) then
				var_73_1 = player_unit
			end
		end

		if not (not var_73_1 and player_unit == var_73_1) then
			return
		end

		if not arg_73_4[num_4].is_hero then
			return
		end

		if Unit.get_data(var_73_1, "breed").name ~= "vs_warpfire_thrower" then
			return
		end

		local has_extension_2 = ScriptUnit.has_extension(var_73_0, "status_system")

		if not has_extension_2 and has_extension_2:is_hanging_from_hook() and not has_extension_2:is_dropping_from_hook() then
			self:increment_stat(arg_73_1, "vs_kill_hoisted_hero")
		end
	end,
	completed = function (self, arg_74_1)
		-- function 74
		return self:get_persistent_stat(arg_74_1, "vs_kill_hoisted_hero") >= 1
	end
}

local tbl_6 = {
	500,
	2500,
	5000,
	10000,
	25000
}

for i5 = 1, #tbl_6 do
	achievements["vs_ratling_gunner_damage_" .. string.format("%02d", i5)] = {
		required_dlc = "carousel",
		display_completion_ui = true,
		group = "vs_ratling_gunner_damage",
		name = "achv_ratling_gunner_" .. string.format("%02d", i5) .. "_vs_name",
		desc = function ()
			-- function 75
			return string.format(Localize("achv_ratling_gunner_" .. string.format("%02d", i5) .. "_vs_desc"), tbl_6[i5])
		end,
		icon = "ratling_gunner_" .. i5,
		completed = function (self, arg_76_1)
			-- function 76
			return self:get_persistent_stat(arg_76_1, "damage_dealt_as_breed", "vs_ratling_gunner") >= tbl_6[i5]
		end,
		progress = function (self, arg_77_1)
			-- function 77
			local var_77_0 = tbl_6[i5]
			local min = math.min(self:get_persistent_stat(arg_77_1, "damage_dealt_as_breed", "vs_ratling_gunner"), var_77_0)

			return {
				min,
				var_77_0
			}
		end
	}
end

achievements.vs_break_hero_shield = {
	required_dlc = "carousel",
	name = "achv_break_hero_shield_vs_name",
	display_completion_ui = true,
	icon = "break_hero_shield",
	desc = "achv_break_hero_shield_vs_desc",
	events = {
		"register_block_broken"
	},
	on_event = function (self, arg_78_1, arg_78_2, arg_78_3, arg_78_4)
		-- function 78
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_78_0 = arg_78_4[num_18]
		local player_unit = Managers.player:local_player().player_unit

		if not (not var_78_0 and player_unit == var_78_0) then
			return
		end

		local var_78_2 = arg_78_4[num_17]

		if not ALIVE[var_78_2] then
			return
		end

		if not Unit.get_data(var_78_2, "breed").is_hero then
			return
		end

		if Unit.get_data(var_78_0, "breed").name ~= "vs_ratling_gunner" then
			return
		end

		self:increment_stat(arg_78_1, "vs_break_hero_shield")
	end,
	completed = function (self, arg_79_1)
		-- function 79
		return self:get_persistent_stat(arg_79_1, "vs_break_hero_shield") >= 1
	end
}
achievements.vs_kill_ko_hero = {
	required_dlc = "carousel",
	name = "achv_kill_ko_hero_vs_name",
	display_completion_ui = true,
	icon = "kill_ko_hero",
	desc = "achv_kill_ko_hero_vs_desc",
	events = {
		"register_kill"
	},
	on_event = function (self, arg_80_1, arg_80_2, arg_80_3, arg_80_4)
		-- function 80
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_80_0 = arg_80_4[num_2]
		local var_80_1 = arg_80_4[num_3][DamageDataIndex.ATTACKER]
		local local_player = Managers.player:local_player()
		local player_unit = local_player.player_unit
		local has_extension = ScriptUnit.has_extension(var_80_0, "health_system")

		if not has_extension then
			local unique_id = local_player:unique_id()

			if not has_extension:was_attacked_by(unique_id) then
				var_80_1 = player_unit
			end
		end

		if not (not var_80_1 and player_unit == var_80_1) then
			return
		end

		if not arg_80_4[num_4].is_hero then
			return
		end

		if Unit.get_data(var_80_1, "breed").name ~= "vs_ratling_gunner" then
			return
		end

		local var_80_6 = arg_80_4[num_2]

		if not ALIVE[var_80_6] then
			return
		end

		local has_extension_2 = ScriptUnit.has_extension(var_80_6, "status_system")

		if not has_extension_2 and not has_extension_2:is_knocked_down() then
			self:increment_stat(arg_80_1, "vs_kill_ko_hero")
		end
	end,
	completed = function (self, arg_81_1)
		-- function 81
		return self:get_persistent_stat(arg_81_1, "vs_kill_ko_hero") >= 1
	end
}

local tbl_7 = {
	500,
	2500,
	5000,
	10000,
	25000
}

for i6 = 1, #tbl_7 do
	achievements["vs_poison_wind_globadier_damage_" .. string.format("%02d", i6)] = {
		required_dlc = "carousel",
		display_completion_ui = true,
		group = "vs_poison_wind_globadier_damage",
		name = "achv_globadier_" .. string.format("%02d", i6) .. "_vs_name",
		desc = function ()
			-- function 82
			return string.format(Localize("achv_globadier_" .. string.format("%02d", i6) .. "_vs_desc"), tbl_7[i6])
		end,
		icon = "globadier_" .. i6,
		completed = function (self, arg_83_1)
			-- function 83
			return self:get_persistent_stat(arg_83_1, "damage_dealt_as_breed", "vs_poison_wind_globadier") >= tbl_7[i6]
		end,
		progress = function (self, arg_84_1)
			-- function 84
			local var_84_0 = tbl_7[i6]
			local min = math.min(self:get_persistent_stat(arg_84_1, "damage_dealt_as_breed", "vs_poison_wind_globadier"), var_84_0)

			return {
				min,
				var_84_0
			}
		end
	}
end

achievements.vs_gas_combo = {
	required_dlc = "carousel",
	name = "achv_gas_combo_vs_name",
	display_completion_ui = true,
	icon = "gas_combo",
	desc = "achv_gas_combo_vs_desc",
	events = {
		"register_damage"
	},
	on_event = function (self, arg_85_1, arg_85_2, arg_85_3, arg_85_4)
		-- function 85
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_85_0 = arg_85_4[num_11]
		local var_85_1 = var_85_0[DamageDataIndex.DAMAGE_TYPE]
		local var_85_2 = var_85_0[DamageDataIndex.DAMAGE_AMOUNT]

		if var_85_2 == 0 then
			return
		end

		if var_85_1 ~= "gas" then
			return
		end

		local var_85_3 = arg_85_4[num_12]
		local player_unit = Managers.player:local_player().player_unit

		if not (not var_85_3 and player_unit == var_85_3) then
			return
		end

		if Unit.get_data(var_85_3, "breed").name ~= "vs_poison_wind_globadier" then
			return
		end

		if not arg_85_4[num_13].is_hero then
			return
		end

		local var_85_5 = arg_85_4[num_10]

		if not ALIVE[var_85_5] then
			return
		end

		local has_extension = ScriptUnit.has_extension(var_85_5, "status_system")

		if not has_extension and not has_extension:is_disabled_by_pact_sworn() then
			self:modify_stat_by_amount(arg_85_1, "vs_gas_combo", var_85_2)
		end
	end,
	completed = function (self, arg_86_1)
		-- function 86
		return self:get_persistent_stat(arg_86_1, "vs_gas_combo") >= 1
	end
}

local num_38 = 100

achievements.vs_globe_damage = {
	required_dlc = "carousel",
	name = "achv_globe_damage_vs_name",
	display_completion_ui = true,
	icon = "globadier_damage",
	desc = function ()
		-- function 87
		return string.format(Localize("achv_globe_damage_vs_desc"), num_38)
	end,
	events = {
		"register_damage"
	},
	on_event = function (self, arg_88_1, arg_88_2, arg_88_3, arg_88_4)
		-- function 88
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_88_0 = arg_88_4[num_11]
		local var_88_1 = var_88_0[DamageDataIndex.DAMAGE_TYPE]
		local var_88_2 = var_88_0[DamageDataIndex.DAMAGE_AMOUNT]
		local var_88_3 = var_88_0[DamageDataIndex.ATTACKER]

		if var_88_2 == 0 then
			return
		end

		if var_88_1 ~= "gas" then
			return
		end

		local var_88_4 = arg_88_4[num_12]
		local player_unit = Managers.player:local_player().player_unit

		if not (not var_88_4 and player_unit == var_88_4) then
			return
		end

		if Unit.get_data(var_88_4, "breed").name ~= "vs_poison_wind_globadier" then
			return
		end

		if not arg_88_4[num_13].is_hero then
			return
		end

		local var_88_6 = arg_88_4[num_10]

		if not ALIVE[var_88_6] then
			return
		end

		if self:get_persistent_stat(arg_88_1, "vs_globe_damage") >= num_38 then
			return
		end

		if arg_88_2.current_unit ~= var_88_3 then
			self:set_stat(arg_88_1, "vs_globe_damage", 0)
		end

		arg_88_2.current_unit = var_88_3

		self:modify_stat_by_amount(arg_88_1, "vs_globe_damage", var_88_2)
	end,
	completed = function (self, arg_89_1)
		-- function 89
		return self:get_persistent_stat(arg_89_1, "vs_globe_damage") >= num_38
	end
}

local tbl_8 = {
	100,
	1000,
	2500
}

for i7 = 1, #tbl_8 do
	achievements["vs_chaos_troll_damage_" .. string.format("%02d", i7)] = {
		required_dlc = "carousel",
		display_completion_ui = true,
		group = "vs_chaos_troll_damage",
		name = "achv_bile_troll_" .. string.format("%02d", i7) .. "_vs_name",
		desc = function ()
			-- function 90
			return string.format(Localize("achv_bile_troll_" .. string.format("%02d", i7) .. "_vs_desc"), tbl_8[i7])
		end,
		icon = "bile_troll_" .. i7,
		completed = function (self, arg_91_1)
			-- function 91
			return self:get_persistent_stat(arg_91_1, "damage_dealt_as_breed", "vs_chaos_troll") >= tbl_8[i7]
		end,
		progress = function (self, arg_92_1)
			-- function 92
			local var_92_0 = tbl_8[i7]
			local min = math.min(self:get_persistent_stat(arg_92_1, "damage_dealt_as_breed", "vs_chaos_troll"), var_92_0)

			return {
				min,
				var_92_0
			}
		end
	}
end

local num_39 = 100

achievements.vs_bile_troll_vomit = {
	name = "achv_bile_troll_vomit_vs_name",
	display_completion_ui = true,
	icon = "bile_troll_vomit",
	required_dlc = "carousel",
	desc = function ()
		-- function 93
		return string.format(Localize("achv_bile_troll_vomit_vs_desc"), num_39)
	end,
	events = {
		"on_troll_vomit_hit"
	},
	on_event = function (self, arg_94_1, arg_94_2, arg_94_3, arg_94_4)
		-- function 94
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_94_0 = arg_94_4[num_22]
		local var_94_1 = arg_94_4[num_23]

		if Unit.get_data(var_94_1, "breed").name ~= "vs_chaos_troll" then
			return
		end

		local player_unit = Managers.player:local_player().player_unit

		if not (not var_94_1 and player_unit == var_94_1) then
			return
		end

		if not ALIVE[var_94_0] then
			return
		end

		if not Unit.get_data(var_94_0, "breed").is_hero then
			return
		end

		self:increment_stat(arg_94_1, "vs_bile_troll_vomit")
	end,
	completed = function (self, arg_95_1)
		-- function 95
		return self:get_persistent_stat(arg_95_1, "vs_bile_troll_vomit") >= num_39
	end,
	progress = function (self, arg_96_1)
		-- function 96
		local min = math.min(self:get_persistent_stat(arg_96_1, "vs_bile_troll_vomit"), num_39)

		return {
			min,
			num_39
		}
	end
}

local tbl_9 = {
	100,
	1000,
	2500
}

for i8 = 1, #tbl_9 do
	achievements["vs_rat_ogre_damage_" .. string.format("%02d", i8)] = {
		required_dlc = "carousel",
		display_completion_ui = true,
		group = "vs_rat_ogre_damage",
		name = "achv_rat_ogre_" .. string.format("%02d", i8) .. "_vs_name",
		desc = function ()
			-- function 97
			return string.format(Localize("achv_rat_ogre_" .. string.format("%02d", i8) .. "_vs_desc"), tbl_9[i8])
		end,
		icon = "rat_ogre_" .. i8,
		completed = function (self, arg_98_1)
			-- function 98
			return self:get_persistent_stat(arg_98_1, "damage_dealt_as_breed", "vs_rat_ogre") >= tbl_9[i8]
		end,
		progress = function (self, arg_99_1)
			-- function 99
			local var_99_0 = tbl_9[i8]
			local min = math.min(self:get_persistent_stat(arg_99_1, "damage_dealt_as_breed", "vs_rat_ogre"), var_99_0)

			return {
				min,
				var_99_0
			}
		end
	}
end

local num_40 = 100

achievements.vs_rat_ogre_hit_heroes_heavy = {
	name = "achv_rat_ogre_hit_heroes_vs_name",
	display_completion_ui = true,
	icon = "rat_ogre_attack",
	required_dlc = "carousel",
	desc = function ()
		-- function 100
		return string.format(Localize("achv_rat_ogre_hit_heroes_vs_desc"), num_40)
	end,
	events = {
		"on_hit"
	},
	on_event = function (self, arg_101_1, arg_101_2, arg_101_3, arg_101_4)
		-- function 101
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_101_0 = arg_101_4[scripts_managers_achievements_achievement_event_parameters.on_hit.unit]

		if not ALIVE[var_101_0] then
			return
		end

		if Managers.player:local_player().player_unit ~= var_101_0 then
			return
		end

		if arg_101_4[scripts_managers_achievements_achievement_event_parameters.on_hit.damage_source] ~= "vs_rat_ogre_hands" then
			return
		end

		if arg_101_4[scripts_managers_achievements_achievement_event_parameters.on_hit.attack_type] ~= "heavy_attack" then
			return
		end

		local var_101_1 = arg_101_4[scripts_managers_achievements_achievement_event_parameters.on_hit.hit_unit]
		local var_101_2 = ALIVE[var_101_1]

		var_101_2 = not var_101_2 and Unit.get_data(var_101_1, "breed")

		if not (not var_101_2 and var_101_2.is_player) then
			return
		end

		local cooldown = arg_101_2.cooldown

		cooldown = cooldown or {}
		arg_101_2.cooldown = cooldown

		local time = Managers.time:time("game")
		local var_101_5 = arg_101_2.cooldown[var_101_1]

		if not (not var_101_5 and not (time < var_101_5)) then
			return
		end

		arg_101_2.cooldown[var_101_1] = time + 0.5

		self:increment_stat(arg_101_1, "vs_rat_ogre_hit_heroes_heavy")
	end,
	completed = function (self, arg_102_1)
		-- function 102
		return self:get_persistent_stat(arg_102_1, "vs_rat_ogre_hit_heroes_heavy") >= num_40
	end,
	progress = function (self, arg_103_1)
		-- function 103
		local min = math.min(self:get_persistent_stat(arg_103_1, "vs_rat_ogre_hit_heroes_heavy"), num_40)

		return {
			min,
			num_40
		}
	end
}

local num_41 = 100

achievements.vs_rat_ogre_hit_leap = {
	name = "achv_rat_ogre_leap_vs_name",
	display_completion_ui = true,
	icon = "rat_ogre_leap",
	required_dlc = "carousel",
	desc = function ()
		-- function 104
		return string.format(Localize("achv_rat_ogre_leap_vs_desc"), num_41)
	end,
	events = {
		"on_hit"
	},
	on_event = function (self, arg_105_1, arg_105_2, arg_105_3, arg_105_4)
		-- function 105
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_105_0 = arg_105_4[scripts_managers_achievements_achievement_event_parameters.on_hit.unit]

		if not ALIVE[var_105_0] then
			return
		end

		if Managers.player:local_player().player_unit ~= var_105_0 then
			return
		end

		if arg_105_4[scripts_managers_achievements_achievement_event_parameters.on_hit.damage_source] ~= "vs_rat_ogre_hands" then
			return
		end

		if arg_105_4[scripts_managers_achievements_achievement_event_parameters.on_hit.attack_type] ~= "aoe" then
			return
		end

		local var_105_1 = arg_105_4[scripts_managers_achievements_achievement_event_parameters.on_hit.hit_unit]
		local var_105_2 = ALIVE[var_105_1]

		var_105_2 = not var_105_2 and Unit.get_data(var_105_1, "breed")

		if not (not var_105_2 and var_105_2.is_player) then
			return
		end

		self:increment_stat(arg_105_1, "vs_rat_ogre_hit_leap")
	end,
	completed = function (self, arg_106_1)
		-- function 106
		return self:get_persistent_stat(arg_106_1, "vs_rat_ogre_hit_leap") >= num_41
	end,
	progress = function (self, arg_107_1)
		-- function 107
		local min = math.min(self:get_persistent_stat(arg_107_1, "vs_rat_ogre_hit_leap"), num_41)

		return {
			min,
			num_41
		}
	end
}
