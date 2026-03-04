-- chunkname: @scripts/managers/achievements/achievement_templates_carousel.lua

local var_0_0 = require("scripts/entity_system/systems/objective/objective_tags")
local var_0_1 = require("scripts/managers/achievements/achievement_event_parameters")
local var_0_2 = AchievementTemplates.achievements
local var_0_3 = 1
local var_0_4 = 2
local var_0_5 = 3
local var_0_6 = 4
local var_0_7 = 1
local var_0_8 = 2
local var_0_9 = 3
local var_0_10 = 4
local var_0_11 = 1
local var_0_12 = 2
local var_0_13 = 3
local var_0_14 = 4
local var_0_15 = 5
local var_0_16 = 1
local var_0_17 = 1
local var_0_18 = 2
local var_0_19 = 1
local var_0_20 = 2
local var_0_21 = 1
local var_0_22 = 2
local var_0_23 = 3
local var_0_24 = 1
local var_0_25 = 2

var_0_2.vs_disable_reviving_hero = {
	required_dlc = "carousel",
	name = "achv_disable_reviving_hero_vs_name",
	display_completion_ui = true,
	icon = "revive_interrupt",
	desc = "achv_disable_reviving_hero_vs_desc",
	events = {
		"register_player_disabled"
	},
	on_event = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_1_0 = arg_1_4[var_0_16]

		if not ALIVE[var_1_0] then
			return
		end

		local var_1_1 = Managers.player:local_player().player_unit
		local var_1_2 = ScriptUnit.extension(var_1_0, "status_system"):get_disabler_unit()

		if not ALIVE[var_1_1] or var_1_1 ~= var_1_2 then
			return
		end

		local var_1_3, var_1_4 = ScriptUnit.extension(var_1_0, "interactor_system"):is_interacting()

		if not var_1_3 or var_1_4 ~= "revive" then
			return
		end

		arg_1_0:increment_stat(arg_1_1, "vs_disable_reviving_hero")
	end,
	completed = function (arg_2_0, arg_2_1)
		return arg_2_0:get_persistent_stat(arg_2_1, "vs_disable_reviving_hero") >= 1
	end
}
var_0_2.vs_kill_invisible_hero = {
	required_dlc = "carousel",
	name = "achv_kill_invisible_hero_vs_name",
	display_completion_ui = true,
	icon = "kill_invisible",
	desc = "achv_kill_invisible_hero_vs_desc",
	events = {
		"register_knockdown"
	},
	on_event = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_3_0 = arg_3_4[var_0_8]
		local var_3_1 = arg_3_4[var_0_9]
		local var_3_2 = var_3_1 and var_3_1.player_unit
		local var_3_3 = Managers.player:local_player()
		local var_3_4 = var_3_3.player_unit
		local var_3_5 = ScriptUnit.has_extension(var_3_0, "health_system")

		if var_3_5 then
			local var_3_6 = var_3_3:unique_id()

			if var_3_5:was_attacked_by(var_3_6) then
				var_3_2 = var_3_4
			end
		end

		if not var_3_2 or var_3_4 ~= var_3_2 then
			return
		end

		local var_3_7 = Unit.get_data(var_3_2, "breed")

		if not var_3_7 or not var_3_7.special and not var_3_7.boss then
			return
		end

		local var_3_8 = ScriptUnit.has_extension(var_3_0, "status_system")

		if var_3_8 and var_3_8:is_invisible() then
			arg_3_0:increment_stat(arg_3_1, "vs_kill_invisible_hero")
		end
	end,
	completed = function (arg_4_0, arg_4_1)
		return arg_4_0:get_persistent_stat(arg_4_1, "vs_kill_invisible_hero") >= 1
	end
}

local var_0_26 = {
	50,
	500,
	1250,
	2500,
	5000
}

for iter_0_0 = 1, #var_0_26 do
	local var_0_27 = false
	local var_0_28
	local var_0_29

	if iter_0_0 == 1 then
		var_0_27 = true
		var_0_28 = {
			"register_kill"
		}

		function var_0_29(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
			if Managers.mechanism:current_mechanism_name() ~= "versus" then
				return
			end

			local var_5_0 = arg_5_4[var_0_4]
			local var_5_1 = arg_5_4[var_0_5][DamageDataIndex.ATTACKER]
			local var_5_2 = Managers.player:local_player()
			local var_5_3 = var_5_2.player_unit
			local var_5_4 = ScriptUnit.has_extension(var_5_0, "health_system")

			if var_5_4 then
				local var_5_5 = var_5_2:unique_id()

				if var_5_4:was_attacked_by(var_5_5) then
					var_5_1 = var_5_3
				end
			end

			if not var_5_1 or var_5_3 ~= var_5_1 then
				return
			end

			if not arg_5_4[var_0_6].special then
				return
			end

			arg_5_0:increment_stat(arg_5_1, "vs_hero_eliminations")
		end
	end

	var_0_2["vs_hero_eliminations_" .. string.format("%02d", iter_0_0)] = {
		group = "vs_hero_eliminations",
		display_completion_ui = true,
		required_dlc = "carousel",
		name = "achv_hero_eliminations_" .. string.format("%02d", iter_0_0) .. "_vs_name",
		desc = function ()
			return string.format(Localize("achv_hero_eliminations_" .. string.format("%02d", iter_0_0) .. "_vs_desc"), var_0_26[iter_0_0])
		end,
		icon = "hero_eliminations_" .. iter_0_0,
		always_run = var_0_27,
		events = var_0_28,
		on_event = var_0_29,
		completed = function (arg_7_0, arg_7_1)
			return arg_7_0:get_persistent_stat(arg_7_1, "vs_hero_eliminations") >= var_0_26[iter_0_0]
		end,
		progress = function (arg_8_0, arg_8_1)
			local var_8_0 = var_0_26[iter_0_0]
			local var_8_1 = math.min(arg_8_0:get_persistent_stat(arg_8_1, "vs_hero_eliminations"), var_8_0)

			return {
				var_8_1,
				var_8_0
			}
		end
	}
end

local var_0_30 = 50

var_0_2.vs_hero_monster_kills = {
	name = "achv_hero_monster_kills_vs_name",
	display_completion_ui = true,
	icon = "kill_x_monsters",
	required_dlc = "carousel",
	desc = function ()
		return string.format(Localize("achv_hero_monster_kills_vs_desc"), var_0_30)
	end,
	events = {
		"register_kill"
	},
	on_event = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_10_0 = arg_10_4[var_0_4]
		local var_10_1 = arg_10_4[var_0_5][DamageDataIndex.ATTACKER]
		local var_10_2 = Managers.player:local_player()
		local var_10_3 = var_10_2.player_unit
		local var_10_4 = ScriptUnit.has_extension(var_10_0, "health_system")

		if var_10_4 then
			local var_10_5 = var_10_2:unique_id()

			if var_10_4:was_attacked_by(var_10_5) then
				var_10_1 = var_10_3
			end
		end

		if not var_10_1 or var_10_3 ~= var_10_1 then
			return
		end

		if not arg_10_4[var_0_6].boss then
			return
		end

		arg_10_0:increment_stat(arg_10_1, "vs_hero_monster_kill")
	end,
	completed = function (arg_11_0, arg_11_1)
		return arg_11_0:get_persistent_stat(arg_11_1, "vs_hero_monster_kill") >= var_0_30
	end,
	progress = function (arg_12_0, arg_12_1)
		local var_12_0 = var_0_30
		local var_12_1 = math.min(arg_12_0:get_persistent_stat(arg_12_1, "vs_hero_monster_kill"), var_12_0)

		return {
			var_12_1,
			var_12_0
		}
	end
}

local var_0_31 = 50

var_0_2.vs_hero_obj_barrels = {
	name = "achv_hero_obj_barrels_vs_name",
	display_completion_ui = true,
	icon = "socket_x_items",
	required_dlc = "carousel",
	desc = function ()
		return string.format(Localize("achv_hero_obj_barrels_vs_desc"), var_0_31)
	end,
	events = {
		"register_objective_completed"
	},
	on_event = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		if arg_14_4[var_0_21].objective_type ~= "objective_socket" then
			return
		end

		local var_14_0 = arg_14_4[var_0_22]
		local var_14_1 = Managers.player:local_player():unique_id()

		if var_14_0 == Managers.party:get_party_from_unique_id(var_14_1).party_id then
			arg_14_0:increment_stat(arg_14_1, "vs_hero_obj_barrels")
		end
	end,
	progress = function (arg_15_0, arg_15_1)
		local var_15_0 = var_0_31
		local var_15_1 = math.min(arg_15_0:get_persistent_stat(arg_15_1, "vs_hero_obj_barrels"), var_15_0)

		return {
			var_15_1,
			var_15_0
		}
	end,
	completed = function (arg_16_0, arg_16_1)
		return arg_16_0:get_persistent_stat(arg_16_1, "vs_hero_obj_barrels") >= var_0_31
	end
}

local var_0_32 = 50

var_0_2.vs_hero_obj_chains = {
	name = "achv_hero_obj_chains_vs_name",
	display_completion_ui = true,
	icon = "destroy_x_chains_as_team",
	required_dlc = "carousel",
	desc = function ()
		return string.format(Localize("achv_hero_obj_chains_vs_desc"), var_0_32)
	end,
	events = {
		"register_objective_completed"
	},
	on_event = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		if arg_18_4[var_0_23]:objective_tag() ~= var_0_0.objective_tag_chains then
			return
		end

		local var_18_0 = arg_18_4[var_0_22]
		local var_18_1 = Managers.player:local_player():unique_id()

		if var_18_0 == Managers.party:get_party_from_unique_id(var_18_1).party_id then
			arg_18_0:increment_stat(arg_18_1, "vs_hero_obj_chains")
		end
	end,
	progress = function (arg_19_0, arg_19_1)
		local var_19_0 = var_0_32
		local var_19_1 = math.min(arg_19_0:get_persistent_stat(arg_19_1, "vs_hero_obj_chains"), var_19_0)

		return {
			var_19_1,
			var_19_0
		}
	end,
	completed = function (arg_20_0, arg_20_1)
		return arg_20_0:get_persistent_stat(arg_20_1, "vs_hero_obj_chains") >= var_0_32
	end
}

local var_0_33 = 25

var_0_2.vs_hero_obj_capture = {
	name = "achv_hero_obj_capture_vs_name",
	display_completion_ui = true,
	icon = "contribute_x_to_capture_points",
	required_dlc = "carousel",
	desc = function ()
		return string.format(Localize("achv_hero_obj_capture_vs_desc"), var_0_33)
	end,
	events = {
		"register_objective_completed"
	},
	on_event = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		if arg_22_4[var_0_21].objective_type ~= "objective_capture_point" then
			return
		end

		local var_22_0 = arg_22_4[var_0_22]
		local var_22_1 = Managers.player:local_player():unique_id()

		if var_22_0 == Managers.party:get_party_from_unique_id(var_22_1).party_id then
			arg_22_0:increment_stat(arg_22_1, "vs_hero_obj_capture")
		end
	end,
	progress = function (arg_23_0, arg_23_1)
		local var_23_0 = var_0_33
		local var_23_1 = math.min(arg_23_0:get_persistent_stat(arg_23_1, "vs_hero_obj_capture"), var_23_0)

		return {
			var_23_1,
			var_23_0
		}
	end,
	completed = function (arg_24_0, arg_24_1)
		return arg_24_0:get_persistent_stat(arg_24_1, "vs_hero_obj_capture") >= var_0_33
	end
}

local var_0_34 = {
	5,
	25,
	50,
	100,
	250
}

for iter_0_1 = 1, #var_0_34 do
	var_0_2["vs_wins_" .. string.format("%02d", iter_0_1)] = {
		required_dlc = "carousel",
		display_completion_ui = true,
		group = "vs_wins",
		name = "achv_wins_" .. string.format("%02d", iter_0_1) .. "_vs_name",
		desc = function ()
			return string.format(Localize("achv_wins_" .. string.format("%02d", iter_0_1) .. "_vs_desc"), var_0_34[iter_0_1])
		end,
		icon = "wins_" .. iter_0_1,
		completed = function (arg_26_0, arg_26_1)
			return arg_26_0:get_persistent_stat(arg_26_1, "vs_game_won") >= var_0_34[iter_0_1]
		end,
		progress = function (arg_27_0, arg_27_1)
			local var_27_0 = var_0_34[iter_0_1]
			local var_27_1 = math.min(arg_27_0:get_persistent_stat(arg_27_1, "vs_game_won"), var_27_0)

			return {
				var_27_1,
				var_27_0
			}
		end
	}
end

local var_0_35 = 50

var_0_2.vs_hero_obj_safezone = {
	name = "achv_hero_obj_safezone_vs_name",
	display_completion_ui = true,
	icon = "safe_zone",
	required_dlc = "carousel",
	desc = function ()
		return string.format(Localize("achv_hero_obj_safezone_vs_desc"), var_0_35)
	end,
	events = {
		"register_objective_completed"
	},
	on_event = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		if arg_29_4[var_0_21].objective_type ~= "objective_safehouse" then
			return
		end

		local var_29_0 = arg_29_4[var_0_22]
		local var_29_1 = Managers.player:local_player():unique_id()

		if var_29_0 == Managers.party:get_party_from_unique_id(var_29_1).party_id then
			arg_29_0:increment_stat(arg_29_1, "vs_hero_obj_safezone")
		end
	end,
	progress = function (arg_30_0, arg_30_1)
		local var_30_0 = var_0_35
		local var_30_1 = math.min(arg_30_0:get_persistent_stat(arg_30_1, "vs_hero_obj_safezone"), var_30_0)

		return {
			var_30_1,
			var_30_0
		}
	end,
	completed = function (arg_31_0, arg_31_1)
		return arg_31_0:get_persistent_stat(arg_31_1, "vs_hero_obj_safezone") >= var_0_35
	end
}

local var_0_36 = 50

var_0_2.vs_hero_revive = {
	name = "achv_hero_revive_vs_name",
	display_completion_ui = true,
	icon = "revive",
	required_dlc = "carousel",
	desc = function ()
		return string.format(Localize("achv_hero_revive_vs_desc"), var_0_36)
	end,
	events = {
		"register_revive"
	},
	on_event = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_33_0 = arg_33_4[var_0_17]
		local var_33_1 = Managers.player:local_player().player_unit

		if not var_33_0 or var_33_1 ~= var_33_0 then
			return
		end

		arg_33_0:increment_stat(arg_33_1, "vs_hero_revive")
	end,
	completed = function (arg_34_0, arg_34_1)
		return arg_34_0:get_persistent_stat(arg_34_1, "vs_hero_revive") >= var_0_36
	end,
	progress = function (arg_35_0, arg_35_1)
		local var_35_0 = var_0_36
		local var_35_1 = math.min(arg_35_0:get_persistent_stat(arg_35_1, "vs_hero_revive"), var_35_0)

		return {
			var_35_1,
			var_35_0
		}
	end
}

local var_0_37 = 100

var_0_2.vs_hero_obj_reach = {
	name = "achv_hero_obj_reach_vs_name",
	display_completion_ui = true,
	icon = "hero_objective_reach",
	required_dlc = "carousel",
	desc = function ()
		return string.format(Localize("achv_hero_obj_reach_vs_desc"), var_0_37)
	end,
	events = {
		"register_objective_completed"
	},
	on_event = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_37_0 = arg_37_4[var_0_21]

		if var_37_0.objective_type ~= "objective_reach" or var_37_0.score_for_completion == 0 then
			return
		end

		local var_37_1 = arg_37_4[var_0_22]
		local var_37_2 = Managers.player:local_player():unique_id()

		if var_37_1 == Managers.party:get_party_from_unique_id(var_37_2).party_id then
			arg_37_0:increment_stat(arg_37_1, "vs_hero_obj_reach")
		end
	end,
	progress = function (arg_38_0, arg_38_1)
		local var_38_0 = var_0_37
		local var_38_1 = math.min(arg_38_0:get_persistent_stat(arg_38_1, "vs_hero_obj_reach"), var_38_0)

		return {
			var_38_1,
			var_38_0
		}
	end,
	completed = function (arg_39_0, arg_39_1)
		return arg_39_0:get_persistent_stat(arg_39_1, "vs_hero_obj_reach") >= var_0_37
	end
}

local var_0_38 = 50

var_0_2.vs_hero_rescue = {
	name = "achv_hero_rescue_vs_name",
	display_completion_ui = true,
	icon = "rescue_prisoners",
	required_dlc = "carousel",
	desc = function ()
		return string.format(Localize("achv_hero_rescue_vs_desc"), var_0_38)
	end,
	events = {
		"register_objective_completed"
	},
	on_event = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		if arg_41_4[var_0_23]:objective_tag() ~= var_0_0.objective_tag_prisoner then
			return
		end

		local var_41_0 = arg_41_4[var_0_22]
		local var_41_1 = Managers.player:local_player():unique_id()

		if var_41_0 == Managers.party:get_party_from_unique_id(var_41_1).party_id then
			arg_41_0:increment_stat(arg_41_1, "vs_hero_rescue")
		end
	end,
	completed = function (arg_42_0, arg_42_1)
		return arg_42_0:get_persistent_stat(arg_42_1, "vs_hero_rescue") >= var_0_38
	end,
	progress = function (arg_43_0, arg_43_1)
		local var_43_0 = var_0_38
		local var_43_1 = math.min(arg_43_0:get_persistent_stat(arg_43_1, "vs_hero_rescue"), var_43_0)

		return {
			var_43_1,
			var_43_0
		}
	end
}
var_0_2.vs_air_gutter_runner = {
	required_dlc = "carousel",
	name = "achv_air_gutter_runner_vs_name",
	display_completion_ui = true,
	icon = "air_gutter_runner",
	desc = "achv_air_gutter_runner_vs_desc",
	events = {
		"register_kill"
	},
	on_event = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_44_0 = arg_44_4[var_0_5][DamageDataIndex.ATTACKER]
		local var_44_1 = Managers.player:local_player().player_unit

		if not var_44_0 or var_44_1 ~= var_44_0 then
			return
		end

		local var_44_2 = arg_44_4[var_0_6]

		if not var_44_2 or not var_44_2.name or var_44_2.name ~= "vs_gutter_runner" then
			return
		end

		local var_44_3 = arg_44_4[var_0_4]
		local var_44_4 = ScriptUnit.has_extension(var_44_3, "status_system")

		if var_44_4 and var_44_4:is_gutter_runner_leaping() then
			arg_44_0:increment_stat(arg_44_1, "vs_air_gutter_runner")
		end
	end,
	completed = function (arg_45_0, arg_45_1)
		return arg_45_0:get_persistent_stat(arg_45_1, "vs_air_gutter_runner") >= 1
	end
}
var_0_2.vs_clutch_revive = {
	required_dlc = "carousel",
	name = "achv_clutch_revive_vs_name",
	display_completion_ui = true,
	icon = "clutch_revive",
	desc = "achv_clutch_revive_vs_desc",
	events = {
		"register_revive"
	},
	on_event = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4)
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_46_0 = arg_46_4[var_0_17]
		local var_46_1 = Managers.player:local_player().player_unit

		if not var_46_0 or var_46_1 ~= var_46_0 then
			return
		end

		local var_46_2 = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS

		for iter_46_0, iter_46_1 in pairs(var_46_2) do
			if ALIVE[iter_46_1] and iter_46_1 ~= var_46_1 then
				local var_46_3 = ScriptUnit.has_extension(iter_46_1, "status_system")

				if var_46_3 and not var_46_3:is_knocked_down() and not var_46_3:is_ready_for_assisted_respawn() and not var_46_3:is_dead() then
					return
				end
			end
		end

		arg_46_0:increment_stat(arg_46_1, "vs_clutch_revive")
	end,
	completed = function (arg_47_0, arg_47_1)
		return arg_47_0:get_persistent_stat(arg_47_1, "vs_clutch_revive") >= 1
	end
}

local var_0_39 = {
	10,
	50,
	100,
	250,
	500
}

for iter_0_2 = 1, #var_0_39 do
	var_0_2["vs_packmaster_eliminations_" .. string.format("%02d", iter_0_2)] = {
		required_dlc = "carousel",
		display_completion_ui = true,
		group = "vs_packmaster_eliminations",
		name = "achv_packmaster_" .. string.format("%02d", iter_0_2) .. "_vs_name",
		desc = function ()
			return string.format(Localize("achv_packmaster_" .. string.format("%02d", iter_0_2) .. "_vs_desc"), var_0_39[iter_0_2])
		end,
		icon = "packmaster_" .. iter_0_2,
		completed = function (arg_49_0, arg_49_1)
			return arg_49_0:get_persistent_stat(arg_49_1, "eliminations_as_breed", "vs_packmaster") >= var_0_39[iter_0_2]
		end,
		progress = function (arg_50_0, arg_50_1)
			local var_50_0 = var_0_39[iter_0_2]
			local var_50_1 = math.min(arg_50_0:get_persistent_stat(arg_50_1, "eliminations_as_breed", "vs_packmaster"), var_50_0)

			return {
				var_50_1,
				var_50_0
			}
		end
	}
end

local var_0_40 = 50

var_0_2.vs_hoist_heroes = {
	name = "achv_hoist_heroes_vs_name",
	display_completion_ui = true,
	icon = "hoist_heroes",
	required_dlc = "carousel",
	desc = function ()
		return string.format(Localize("achv_hoist_heroes_vs_desc"), var_0_40)
	end,
	events = {
		"register_player_disabled"
	},
	on_event = function (arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4)
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_52_0 = arg_52_4[var_0_16]

		if not ALIVE[var_52_0] then
			return
		end

		if not Unit.get_data(var_52_0, "breed").is_hero then
			return
		end

		local var_52_1 = ScriptUnit.has_extension(var_52_0, "status_system")

		if not var_52_1 then
			return
		end

		if not var_52_1:is_hanging_from_hook() then
			return
		end

		local var_52_2 = var_52_1:get_pack_master_grabber()
		local var_52_3 = Managers.player:local_player().player_unit

		if var_52_3 and var_52_3 == var_52_2 then
			arg_52_0:increment_stat(arg_52_1, "vs_hoist_heroes")
		end
	end,
	completed = function (arg_53_0, arg_53_1)
		return arg_53_0:get_persistent_stat(arg_53_1, "vs_hoist_heroes") >= var_0_40
	end,
	progress = function (arg_54_0, arg_54_1)
		local var_54_0 = math.min(arg_54_0:get_persistent_stat(arg_54_1, "vs_hoist_heroes"), var_0_40)

		return {
			var_54_0,
			var_0_40
		}
	end
}

local var_0_41 = 500

var_0_2.vs_drag_heroes = {
	required_dlc = "carousel",
	name = "achv_drag_heroes_vs_name",
	display_completion_ui = true,
	icon = "drag_heroes",
	desc = function ()
		return string.format(Localize("achv_drag_heroes_vs_desc"), var_0_41)
	end,
	completed = function (arg_56_0, arg_56_1)
		return arg_56_0:get_persistent_stat(arg_56_1, "vs_drag_heroes") >= var_0_41
	end,
	progress = function (arg_57_0, arg_57_1)
		local var_57_0 = math.min(arg_57_0:get_persistent_stat(arg_57_1, "vs_drag_heroes"), var_0_41)

		return {
			var_57_0,
			var_0_41
		}
	end
}

local var_0_42 = {
	10,
	50,
	100,
	250,
	500
}

for iter_0_3 = 1, #var_0_42 do
	var_0_2["vs_gutter_runner_eliminations_" .. string.format("%02d", iter_0_3)] = {
		required_dlc = "carousel",
		display_completion_ui = true,
		group = "vs_gutter_runner_eliminations",
		name = "achv_gutter_runner_" .. string.format("%02d", iter_0_3) .. "_vs_name",
		desc = function ()
			return string.format(Localize("achv_gutter_runner_" .. string.format("%02d", iter_0_3) .. "_vs_desc"), var_0_42[iter_0_3])
		end,
		icon = "gutter_runner_" .. iter_0_3,
		completed = function (arg_59_0, arg_59_1)
			return arg_59_0:get_persistent_stat(arg_59_1, "eliminations_as_breed", "vs_gutter_runner") >= var_0_42[iter_0_3]
		end,
		progress = function (arg_60_0, arg_60_1)
			local var_60_0 = var_0_42[iter_0_3]
			local var_60_1 = math.min(arg_60_0:get_persistent_stat(arg_60_1, "eliminations_as_breed", "vs_gutter_runner"), var_60_0)

			return {
				var_60_1,
				var_60_0
			}
		end
	}
end

local var_0_43 = 100

var_0_2.vs_pounce_heroes = {
	name = "achv_pounce_heroes_vs_name",
	display_completion_ui = true,
	icon = "pounce_heroes",
	required_dlc = "carousel",
	desc = function ()
		return string.format(Localize("achv_pounce_heroes_vs_desc"), var_0_43)
	end,
	events = {
		"register_player_disabled"
	},
	on_event = function (arg_62_0, arg_62_1, arg_62_2, arg_62_3, arg_62_4)
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_62_0 = arg_62_4[var_0_16]

		if not ALIVE[var_62_0] then
			return
		end

		if not Unit.get_data(var_62_0, "breed").is_hero then
			return
		end

		local var_62_1 = ScriptUnit.has_extension(var_62_0, "status_system")

		if not var_62_1 then
			return
		end

		local var_62_2, var_62_3 = var_62_1:is_pounced_down()

		if not var_62_2 then
			return
		end

		local var_62_4 = Managers.player:local_player().player_unit

		if var_62_4 and var_62_4 == var_62_3 then
			arg_62_0:increment_stat(arg_62_1, "vs_pounce_heroes")
		end
	end,
	completed = function (arg_63_0, arg_63_1)
		return arg_63_0:get_persistent_stat(arg_63_1, "vs_pounce_heroes") >= var_0_43
	end,
	progress = function (arg_64_0, arg_64_1)
		local var_64_0 = math.min(arg_64_0:get_persistent_stat(arg_64_1, "vs_pounce_heroes"), var_0_43)

		return {
			var_64_0,
			var_0_43
		}
	end
}
var_0_2.vs_gas_combo_pounce = {
	required_dlc = "carousel",
	name = "achv_gas_combo_pounce_vs_name",
	display_completion_ui = true,
	icon = "gas_combo_pounce",
	desc = "achv_gas_combo_pounce_vs_desc",
	events = {
		"register_player_disabled"
	},
	on_event = function (arg_65_0, arg_65_1, arg_65_2, arg_65_3, arg_65_4)
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_65_0 = arg_65_4[var_0_16]

		if not ALIVE[var_65_0] then
			return
		end

		if not Unit.get_data(var_65_0, "breed").is_hero then
			return
		end

		local var_65_1 = ScriptUnit.has_extension(var_65_0, "status_system")

		if not var_65_1 then
			return
		end

		local var_65_2, var_65_3 = var_65_1:is_pounced_down()

		if not var_65_2 then
			return
		end

		local var_65_4 = Managers.player:local_player().player_unit

		if not ALIVE[var_65_4] or var_65_4 ~= var_65_3 then
			return
		end

		local var_65_5 = Managers.state.entity:system("area_damage_system"):get_extensions_from_extension_name("AreaDamageExtension")

		for iter_65_0, iter_65_1 in pairs(var_65_5) do
			local var_65_6 = iter_65_1.radius
			local var_65_7 = POSITION_LOOKUP[var_65_0]
			local var_65_8 = Unit.local_position(iter_65_0, 0)

			if Vector3.distance_squared(var_65_7, var_65_8) < var_65_6 * var_65_6 then
				arg_65_0:increment_stat(arg_65_1, "vs_gas_combo_pounce")

				return
			end
		end
	end,
	completed = function (arg_66_0, arg_66_1)
		return arg_66_0:get_persistent_stat(arg_66_1, "vs_gas_combo_pounce") >= 1
	end
}

local var_0_44 = {
	500,
	2500,
	5000,
	10000,
	25000
}

for iter_0_4 = 1, #var_0_44 do
	var_0_2["vs_warpfire_thrower_damage_" .. string.format("%02d", iter_0_4)] = {
		required_dlc = "carousel",
		display_completion_ui = true,
		group = "vs_warpfire_thrower_damage",
		name = "achv_warpfire_thrower_" .. string.format("%02d", iter_0_4) .. "_vs_name",
		desc = function ()
			return string.format(Localize("achv_warpfire_thrower_" .. string.format("%02d", iter_0_4) .. "_vs_desc"), var_0_44[iter_0_4])
		end,
		icon = "warpfire_thrower_" .. iter_0_4,
		completed = function (arg_68_0, arg_68_1)
			return arg_68_0:get_persistent_stat(arg_68_1, "damage_dealt_as_breed", "vs_warpfire_thrower") >= var_0_44[iter_0_4]
		end,
		progress = function (arg_69_0, arg_69_1)
			local var_69_0 = var_0_44[iter_0_4]
			local var_69_1 = math.min(arg_69_0:get_persistent_stat(arg_69_1, "damage_dealt_as_breed", "vs_warpfire_thrower"), var_69_0)

			return {
				var_69_1,
				var_69_0
			}
		end
	}
end

local var_0_45 = 3
local var_0_46 = 6
local var_0_47 = 4

local function var_0_48(arg_70_0, arg_70_1)
	local var_70_0 = arg_70_0.knockback_position:unbox()
	local var_70_1 = Unit.is_valid(arg_70_1) and not Unit.is_frozen(arg_70_1) and Unit.local_position(arg_70_1, 0)

	if not var_70_1 or var_70_0[3] - var_70_1[3] < var_0_47 then
		return false
	end

	return true
end

var_0_2.vs_push_hero_off_map = {
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
	completed = function (arg_71_0, arg_71_1, arg_71_2)
		return arg_71_0:get_persistent_stat(arg_71_1, "vs_push_hero_off_map") >= 1
	end,
	on_event = function (arg_72_0, arg_72_1, arg_72_2, arg_72_3, arg_72_4)
		local var_72_0 = Managers.time:time("game")

		if arg_72_3 == "register_kill" then
			local var_72_1 = arg_72_4[var_0_4]
			local var_72_2 = arg_72_2.tracked_units and arg_72_2.tracked_units[var_72_1]

			if not var_72_2 then
				return
			end

			if var_72_0 - var_72_2.knockback_time > var_0_46 then
				return false
			end

			if var_0_48(var_72_2, var_72_1) then
				arg_72_0:increment_stat(arg_72_1, "vs_push_hero_off_map")

				return
			end
		elseif arg_72_3 == "register_damage" then
			local var_72_3 = arg_72_4[var_0_12]
			local var_72_4 = Unit.get_data(var_72_3, "breed")

			if not var_72_4 or not var_72_4.is_hero then
				return
			end

			local var_72_5 = Managers.player:local_player()
			local var_72_6 = var_72_5 and var_72_5.player_unit
			local var_72_7 = arg_72_4[var_0_14]

			if not ALIVE[var_72_6] or var_72_6 ~= var_72_7 then
				return
			end

			local var_72_8 = Unit.get_data(var_72_7, "breed")

			if not var_72_8 or var_72_8.name ~= "vs_warpfire_thrower" then
				return
			end

			arg_72_2.tracked_units = arg_72_2.tracked_units or {}

			local var_72_9 = arg_72_2.tracked_units[var_72_3]

			if var_72_9 then
				var_72_9.knockback_time = var_72_0

				var_72_9.knockback_position:store(POSITION_LOOKUP[var_72_3])
			else
				arg_72_2.tracked_units[var_72_3] = {
					knockback_time = var_72_0,
					knockback_position = Vector3Box(POSITION_LOOKUP[var_72_3])
				}
			end
		elseif arg_72_3 == "register_player_disabled" then
			local var_72_10 = arg_72_4[var_0_16]

			if not ALIVE[var_72_10] then
				return
			end

			local var_72_11 = arg_72_2.tracked_units and arg_72_2.tracked_units[var_72_10]

			if not var_72_11 then
				return
			end

			local var_72_12 = ScriptUnit.has_extension(var_72_10, "status_system")

			if not var_72_12 or not var_72_12:get_is_ledge_hanging() then
				return
			end

			if var_72_0 - var_72_11.knockback_time > var_0_45 then
				return false
			end

			arg_72_0:increment_stat(arg_72_1, "vs_push_hero_off_map")
		end
	end
}
var_0_2.vs_kill_hoisted_hero = {
	required_dlc = "carousel",
	name = "achv_kill_hoisted_hero_vs_name",
	display_completion_ui = true,
	icon = "kill_hoisted_hero",
	desc = "achv_kill_hoisted_hero_vs_desc",
	events = {
		"register_kill"
	},
	on_event = function (arg_73_0, arg_73_1, arg_73_2, arg_73_3, arg_73_4)
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_73_0 = arg_73_4[var_0_4]
		local var_73_1 = arg_73_4[var_0_5][DamageDataIndex.ATTACKER]
		local var_73_2 = Managers.player:local_player()
		local var_73_3 = var_73_2.player_unit
		local var_73_4 = ScriptUnit.has_extension(var_73_0, "health_system")

		if var_73_4 then
			local var_73_5 = var_73_2:unique_id()

			if var_73_4:was_attacked_by(var_73_5) then
				var_73_1 = var_73_3
			end
		end

		if not var_73_1 or var_73_3 ~= var_73_1 then
			return
		end

		if not arg_73_4[var_0_6].is_hero then
			return
		end

		if Unit.get_data(var_73_1, "breed").name ~= "vs_warpfire_thrower" then
			return
		end

		local var_73_6 = ScriptUnit.has_extension(var_73_0, "status_system")

		if var_73_6 and (var_73_6:is_hanging_from_hook() or var_73_6:is_dropping_from_hook()) then
			arg_73_0:increment_stat(arg_73_1, "vs_kill_hoisted_hero")
		end
	end,
	completed = function (arg_74_0, arg_74_1)
		return arg_74_0:get_persistent_stat(arg_74_1, "vs_kill_hoisted_hero") >= 1
	end
}

local var_0_49 = {
	500,
	2500,
	5000,
	10000,
	25000
}

for iter_0_5 = 1, #var_0_49 do
	var_0_2["vs_ratling_gunner_damage_" .. string.format("%02d", iter_0_5)] = {
		required_dlc = "carousel",
		display_completion_ui = true,
		group = "vs_ratling_gunner_damage",
		name = "achv_ratling_gunner_" .. string.format("%02d", iter_0_5) .. "_vs_name",
		desc = function ()
			return string.format(Localize("achv_ratling_gunner_" .. string.format("%02d", iter_0_5) .. "_vs_desc"), var_0_49[iter_0_5])
		end,
		icon = "ratling_gunner_" .. iter_0_5,
		completed = function (arg_76_0, arg_76_1)
			return arg_76_0:get_persistent_stat(arg_76_1, "damage_dealt_as_breed", "vs_ratling_gunner") >= var_0_49[iter_0_5]
		end,
		progress = function (arg_77_0, arg_77_1)
			local var_77_0 = var_0_49[iter_0_5]
			local var_77_1 = math.min(arg_77_0:get_persistent_stat(arg_77_1, "damage_dealt_as_breed", "vs_ratling_gunner"), var_77_0)

			return {
				var_77_1,
				var_77_0
			}
		end
	}
end

var_0_2.vs_break_hero_shield = {
	required_dlc = "carousel",
	name = "achv_break_hero_shield_vs_name",
	display_completion_ui = true,
	icon = "break_hero_shield",
	desc = "achv_break_hero_shield_vs_desc",
	events = {
		"register_block_broken"
	},
	on_event = function (arg_78_0, arg_78_1, arg_78_2, arg_78_3, arg_78_4)
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_78_0 = arg_78_4[var_0_20]
		local var_78_1 = Managers.player:local_player().player_unit

		if not var_78_0 or var_78_1 ~= var_78_0 then
			return
		end

		local var_78_2 = arg_78_4[var_0_19]

		if not ALIVE[var_78_2] then
			return
		end

		if not Unit.get_data(var_78_2, "breed").is_hero then
			return
		end

		if Unit.get_data(var_78_0, "breed").name ~= "vs_ratling_gunner" then
			return
		end

		arg_78_0:increment_stat(arg_78_1, "vs_break_hero_shield")
	end,
	completed = function (arg_79_0, arg_79_1)
		return arg_79_0:get_persistent_stat(arg_79_1, "vs_break_hero_shield") >= 1
	end
}
var_0_2.vs_kill_ko_hero = {
	required_dlc = "carousel",
	name = "achv_kill_ko_hero_vs_name",
	display_completion_ui = true,
	icon = "kill_ko_hero",
	desc = "achv_kill_ko_hero_vs_desc",
	events = {
		"register_kill"
	},
	on_event = function (arg_80_0, arg_80_1, arg_80_2, arg_80_3, arg_80_4)
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_80_0 = arg_80_4[var_0_4]
		local var_80_1 = arg_80_4[var_0_5][DamageDataIndex.ATTACKER]
		local var_80_2 = Managers.player:local_player()
		local var_80_3 = var_80_2.player_unit
		local var_80_4 = ScriptUnit.has_extension(var_80_0, "health_system")

		if var_80_4 then
			local var_80_5 = var_80_2:unique_id()

			if var_80_4:was_attacked_by(var_80_5) then
				var_80_1 = var_80_3
			end
		end

		if not var_80_1 or var_80_3 ~= var_80_1 then
			return
		end

		if not arg_80_4[var_0_6].is_hero then
			return
		end

		if Unit.get_data(var_80_1, "breed").name ~= "vs_ratling_gunner" then
			return
		end

		local var_80_6 = arg_80_4[var_0_4]

		if not ALIVE[var_80_6] then
			return
		end

		local var_80_7 = ScriptUnit.has_extension(var_80_6, "status_system")

		if var_80_7 and var_80_7:is_knocked_down() then
			arg_80_0:increment_stat(arg_80_1, "vs_kill_ko_hero")
		end
	end,
	completed = function (arg_81_0, arg_81_1)
		return arg_81_0:get_persistent_stat(arg_81_1, "vs_kill_ko_hero") >= 1
	end
}

local var_0_50 = {
	500,
	2500,
	5000,
	10000,
	25000
}

for iter_0_6 = 1, #var_0_50 do
	var_0_2["vs_poison_wind_globadier_damage_" .. string.format("%02d", iter_0_6)] = {
		required_dlc = "carousel",
		display_completion_ui = true,
		group = "vs_poison_wind_globadier_damage",
		name = "achv_globadier_" .. string.format("%02d", iter_0_6) .. "_vs_name",
		desc = function ()
			return string.format(Localize("achv_globadier_" .. string.format("%02d", iter_0_6) .. "_vs_desc"), var_0_50[iter_0_6])
		end,
		icon = "globadier_" .. iter_0_6,
		completed = function (arg_83_0, arg_83_1)
			return arg_83_0:get_persistent_stat(arg_83_1, "damage_dealt_as_breed", "vs_poison_wind_globadier") >= var_0_50[iter_0_6]
		end,
		progress = function (arg_84_0, arg_84_1)
			local var_84_0 = var_0_50[iter_0_6]
			local var_84_1 = math.min(arg_84_0:get_persistent_stat(arg_84_1, "damage_dealt_as_breed", "vs_poison_wind_globadier"), var_84_0)

			return {
				var_84_1,
				var_84_0
			}
		end
	}
end

var_0_2.vs_gas_combo = {
	required_dlc = "carousel",
	name = "achv_gas_combo_vs_name",
	display_completion_ui = true,
	icon = "gas_combo",
	desc = "achv_gas_combo_vs_desc",
	events = {
		"register_damage"
	},
	on_event = function (arg_85_0, arg_85_1, arg_85_2, arg_85_3, arg_85_4)
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_85_0 = arg_85_4[var_0_13]
		local var_85_1 = var_85_0[DamageDataIndex.DAMAGE_TYPE]
		local var_85_2 = var_85_0[DamageDataIndex.DAMAGE_AMOUNT]

		if var_85_2 == 0 then
			return
		end

		if var_85_1 ~= "gas" then
			return
		end

		local var_85_3 = arg_85_4[var_0_14]
		local var_85_4 = Managers.player:local_player().player_unit

		if not var_85_3 or var_85_4 ~= var_85_3 then
			return
		end

		if Unit.get_data(var_85_3, "breed").name ~= "vs_poison_wind_globadier" then
			return
		end

		if not arg_85_4[var_0_15].is_hero then
			return
		end

		local var_85_5 = arg_85_4[var_0_12]

		if not ALIVE[var_85_5] then
			return
		end

		local var_85_6 = ScriptUnit.has_extension(var_85_5, "status_system")

		if var_85_6 and var_85_6:is_disabled_by_pact_sworn() then
			arg_85_0:modify_stat_by_amount(arg_85_1, "vs_gas_combo", var_85_2)
		end
	end,
	completed = function (arg_86_0, arg_86_1)
		return arg_86_0:get_persistent_stat(arg_86_1, "vs_gas_combo") >= 1
	end
}

local var_0_51 = 100

var_0_2.vs_globe_damage = {
	required_dlc = "carousel",
	name = "achv_globe_damage_vs_name",
	display_completion_ui = true,
	icon = "globadier_damage",
	desc = function ()
		return string.format(Localize("achv_globe_damage_vs_desc"), var_0_51)
	end,
	events = {
		"register_damage"
	},
	on_event = function (arg_88_0, arg_88_1, arg_88_2, arg_88_3, arg_88_4)
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_88_0 = arg_88_4[var_0_13]
		local var_88_1 = var_88_0[DamageDataIndex.DAMAGE_TYPE]
		local var_88_2 = var_88_0[DamageDataIndex.DAMAGE_AMOUNT]
		local var_88_3 = var_88_0[DamageDataIndex.ATTACKER]

		if var_88_2 == 0 then
			return
		end

		if var_88_1 ~= "gas" then
			return
		end

		local var_88_4 = arg_88_4[var_0_14]
		local var_88_5 = Managers.player:local_player().player_unit

		if not var_88_4 or var_88_5 ~= var_88_4 then
			return
		end

		if Unit.get_data(var_88_4, "breed").name ~= "vs_poison_wind_globadier" then
			return
		end

		if not arg_88_4[var_0_15].is_hero then
			return
		end

		local var_88_6 = arg_88_4[var_0_12]

		if not ALIVE[var_88_6] then
			return
		end

		if arg_88_0:get_persistent_stat(arg_88_1, "vs_globe_damage") >= var_0_51 then
			return
		end

		if arg_88_2.current_unit ~= var_88_3 then
			arg_88_0:set_stat(arg_88_1, "vs_globe_damage", 0)
		end

		arg_88_2.current_unit = var_88_3

		arg_88_0:modify_stat_by_amount(arg_88_1, "vs_globe_damage", var_88_2)
	end,
	completed = function (arg_89_0, arg_89_1)
		return arg_89_0:get_persistent_stat(arg_89_1, "vs_globe_damage") >= var_0_51
	end
}

local var_0_52 = {
	100,
	1000,
	2500
}

for iter_0_7 = 1, #var_0_52 do
	var_0_2["vs_chaos_troll_damage_" .. string.format("%02d", iter_0_7)] = {
		required_dlc = "carousel",
		display_completion_ui = true,
		group = "vs_chaos_troll_damage",
		name = "achv_bile_troll_" .. string.format("%02d", iter_0_7) .. "_vs_name",
		desc = function ()
			return string.format(Localize("achv_bile_troll_" .. string.format("%02d", iter_0_7) .. "_vs_desc"), var_0_52[iter_0_7])
		end,
		icon = "bile_troll_" .. iter_0_7,
		completed = function (arg_91_0, arg_91_1)
			return arg_91_0:get_persistent_stat(arg_91_1, "damage_dealt_as_breed", "vs_chaos_troll") >= var_0_52[iter_0_7]
		end,
		progress = function (arg_92_0, arg_92_1)
			local var_92_0 = var_0_52[iter_0_7]
			local var_92_1 = math.min(arg_92_0:get_persistent_stat(arg_92_1, "damage_dealt_as_breed", "vs_chaos_troll"), var_92_0)

			return {
				var_92_1,
				var_92_0
			}
		end
	}
end

local var_0_53 = 100

var_0_2.vs_bile_troll_vomit = {
	name = "achv_bile_troll_vomit_vs_name",
	display_completion_ui = true,
	icon = "bile_troll_vomit",
	required_dlc = "carousel",
	desc = function ()
		return string.format(Localize("achv_bile_troll_vomit_vs_desc"), var_0_53)
	end,
	events = {
		"on_troll_vomit_hit"
	},
	on_event = function (arg_94_0, arg_94_1, arg_94_2, arg_94_3, arg_94_4)
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_94_0 = arg_94_4[var_0_24]
		local var_94_1 = arg_94_4[var_0_25]

		if Unit.get_data(var_94_1, "breed").name ~= "vs_chaos_troll" then
			return
		end

		local var_94_2 = Managers.player:local_player().player_unit

		if not var_94_1 or var_94_2 ~= var_94_1 then
			return
		end

		if not ALIVE[var_94_0] then
			return
		end

		if not Unit.get_data(var_94_0, "breed").is_hero then
			return
		end

		arg_94_0:increment_stat(arg_94_1, "vs_bile_troll_vomit")
	end,
	completed = function (arg_95_0, arg_95_1)
		return arg_95_0:get_persistent_stat(arg_95_1, "vs_bile_troll_vomit") >= var_0_53
	end,
	progress = function (arg_96_0, arg_96_1)
		local var_96_0 = math.min(arg_96_0:get_persistent_stat(arg_96_1, "vs_bile_troll_vomit"), var_0_53)

		return {
			var_96_0,
			var_0_53
		}
	end
}

local var_0_54 = {
	100,
	1000,
	2500
}

for iter_0_8 = 1, #var_0_54 do
	var_0_2["vs_rat_ogre_damage_" .. string.format("%02d", iter_0_8)] = {
		required_dlc = "carousel",
		display_completion_ui = true,
		group = "vs_rat_ogre_damage",
		name = "achv_rat_ogre_" .. string.format("%02d", iter_0_8) .. "_vs_name",
		desc = function ()
			return string.format(Localize("achv_rat_ogre_" .. string.format("%02d", iter_0_8) .. "_vs_desc"), var_0_54[iter_0_8])
		end,
		icon = "rat_ogre_" .. iter_0_8,
		completed = function (arg_98_0, arg_98_1)
			return arg_98_0:get_persistent_stat(arg_98_1, "damage_dealt_as_breed", "vs_rat_ogre") >= var_0_54[iter_0_8]
		end,
		progress = function (arg_99_0, arg_99_1)
			local var_99_0 = var_0_54[iter_0_8]
			local var_99_1 = math.min(arg_99_0:get_persistent_stat(arg_99_1, "damage_dealt_as_breed", "vs_rat_ogre"), var_99_0)

			return {
				var_99_1,
				var_99_0
			}
		end
	}
end

local var_0_55 = 100

var_0_2.vs_rat_ogre_hit_heroes_heavy = {
	name = "achv_rat_ogre_hit_heroes_vs_name",
	display_completion_ui = true,
	icon = "rat_ogre_attack",
	required_dlc = "carousel",
	desc = function ()
		return string.format(Localize("achv_rat_ogre_hit_heroes_vs_desc"), var_0_55)
	end,
	events = {
		"on_hit"
	},
	on_event = function (arg_101_0, arg_101_1, arg_101_2, arg_101_3, arg_101_4)
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_101_0 = arg_101_4[var_0_1.on_hit.unit]

		if not ALIVE[var_101_0] then
			return
		end

		if Managers.player:local_player().player_unit ~= var_101_0 then
			return
		end

		if arg_101_4[var_0_1.on_hit.damage_source] ~= "vs_rat_ogre_hands" then
			return
		end

		if arg_101_4[var_0_1.on_hit.attack_type] ~= "heavy_attack" then
			return
		end

		local var_101_1 = arg_101_4[var_0_1.on_hit.hit_unit]
		local var_101_2 = ALIVE[var_101_1] and Unit.get_data(var_101_1, "breed")

		if not var_101_2 or not var_101_2.is_player then
			return
		end

		arg_101_2.cooldown = arg_101_2.cooldown or {}

		local var_101_3 = Managers.time:time("game")
		local var_101_4 = arg_101_2.cooldown[var_101_1]

		if var_101_4 and var_101_3 < var_101_4 then
			return
		end

		arg_101_2.cooldown[var_101_1] = var_101_3 + 0.5

		arg_101_0:increment_stat(arg_101_1, "vs_rat_ogre_hit_heroes_heavy")
	end,
	completed = function (arg_102_0, arg_102_1)
		return arg_102_0:get_persistent_stat(arg_102_1, "vs_rat_ogre_hit_heroes_heavy") >= var_0_55
	end,
	progress = function (arg_103_0, arg_103_1)
		local var_103_0 = math.min(arg_103_0:get_persistent_stat(arg_103_1, "vs_rat_ogre_hit_heroes_heavy"), var_0_55)

		return {
			var_103_0,
			var_0_55
		}
	end
}

local var_0_56 = 100

var_0_2.vs_rat_ogre_hit_leap = {
	name = "achv_rat_ogre_leap_vs_name",
	display_completion_ui = true,
	icon = "rat_ogre_leap",
	required_dlc = "carousel",
	desc = function ()
		return string.format(Localize("achv_rat_ogre_leap_vs_desc"), var_0_56)
	end,
	events = {
		"on_hit"
	},
	on_event = function (arg_105_0, arg_105_1, arg_105_2, arg_105_3, arg_105_4)
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return
		end

		local var_105_0 = arg_105_4[var_0_1.on_hit.unit]

		if not ALIVE[var_105_0] then
			return
		end

		if Managers.player:local_player().player_unit ~= var_105_0 then
			return
		end

		if arg_105_4[var_0_1.on_hit.damage_source] ~= "vs_rat_ogre_hands" then
			return
		end

		if arg_105_4[var_0_1.on_hit.attack_type] ~= "aoe" then
			return
		end

		local var_105_1 = arg_105_4[var_0_1.on_hit.hit_unit]
		local var_105_2 = ALIVE[var_105_1] and Unit.get_data(var_105_1, "breed")

		if not var_105_2 or not var_105_2.is_player then
			return
		end

		arg_105_0:increment_stat(arg_105_1, "vs_rat_ogre_hit_leap")
	end,
	completed = function (arg_106_0, arg_106_1)
		return arg_106_0:get_persistent_stat(arg_106_1, "vs_rat_ogre_hit_leap") >= var_0_56
	end,
	progress = function (arg_107_0, arg_107_1)
		local var_107_0 = math.min(arg_107_0:get_persistent_stat(arg_107_1, "vs_rat_ogre_hit_leap"), var_0_56)

		return {
			var_107_0,
			var_0_56
		}
	end
}
