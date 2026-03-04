-- chunkname: @scripts/entity_system/systems/tutorial/tutorial_templates.lua

local function var_0_0(arg_1_0)
	return
end

local function var_0_1(arg_2_0)
	local var_2_0 = ScriptUnit.extension(arg_2_0, "inventory_system")
	local var_2_1 = var_2_0:get_wielded_slot_name()
	local var_2_2 = var_2_0:get_slot_data(var_2_1)

	if var_2_2 == nil then
		return false
	end

	local var_2_3 = var_2_2.right_unit_1p

	if ScriptUnit.has_extension(var_2_3, "ammo_system") then
		return false
	end

	return true
end

local var_0_2 = POSITION_LOOKUP

TutorialTemplates = {}
TutorialTemplates.core_needs_help = {
	priority = 50,
	action = "interact",
	needed_points = 0,
	text = "player_in_need_of_help",
	display_type = "tooltip",
	icon = "hud_tutorial_icon_attention",
	is_mission_tutorial = true,
	init_data = function(arg_3_0)
		return
	end,
	clear_data = function(arg_4_0)
		return
	end,
	update_data = function(arg_5_0, arg_5_1, arg_5_2)
		return
	end,
	can_show = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		local var_6_0 = Managers.player:human_and_bot_players()
		local var_6_1 = Unit.local_position(arg_6_1, 0)
		local var_6_2 = math.huge
		local var_6_3
		local var_6_4
		local var_6_5
		local var_6_6

		for iter_6_0, iter_6_1 in pairs(var_6_0) do
			local var_6_7 = iter_6_1.player_unit

			if Unit.alive(var_6_7) and arg_6_1 ~= var_6_7 then
				local var_6_8 = ScriptUnit.extension(var_6_7, "status_system")

				if not var_6_8:is_dead() and (var_6_8:is_pounced_down() or var_6_8:get_is_ledge_hanging() or var_6_8:is_grabbed_by_pack_master()) then
					local var_6_9 = Unit.local_position(var_6_7, 0)
					local var_6_10 = Vector3.distance_squared(var_6_1, var_6_9)

					if var_6_7 == arg_6_3 then
						var_6_4 = true
						var_6_5 = var_6_9
						var_6_6 = var_6_10
					end

					if var_6_10 < var_6_2 then
						var_6_2 = var_6_10
						var_6_3 = var_6_9
					end
				end
			end
		end

		if var_6_4 and var_6_6 < 400 then
			return true, var_6_5
		elseif var_6_3 then
			return true, var_6_3
		end

		return false
	end,
	is_completed = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
		return false
	end
}
TutorialTemplates.core_revive = {
	priority = 45,
	action = "interact",
	do_not_verify = true,
	needed_points = 0,
	text = "tutorial_tooltip_core_revive",
	display_type = "tooltip",
	icon = "hud_tutorial_icon_attention",
	is_mission_tutorial = true,
	init_data = function(arg_8_0)
		return
	end,
	clear_data = function(arg_9_0)
		return
	end,
	update_data = function(arg_10_0, arg_10_1, arg_10_2)
		return
	end,
	can_show = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
		local var_11_0 = Managers.player:human_and_bot_players()
		local var_11_1 = Unit.local_position(arg_11_1, 0)
		local var_11_2 = math.huge
		local var_11_3
		local var_11_4
		local var_11_5
		local var_11_6

		for iter_11_0, iter_11_1 in pairs(var_11_0) do
			local var_11_7 = iter_11_1.player_unit

			if Unit.alive(var_11_7) and arg_11_1 ~= var_11_7 then
				local var_11_8 = ScriptUnit.extension(var_11_7, "status_system")

				if var_11_8:is_knocked_down() and not var_11_8:is_dead() then
					local var_11_9 = Unit.local_position(var_11_7, 0)
					local var_11_10 = Vector3.distance_squared(var_11_1, var_11_9)

					if var_11_7 == arg_11_3 then
						var_11_4 = true
						var_11_5 = var_11_9
						var_11_6 = var_11_10
					end

					if var_11_10 < var_11_2 then
						var_11_2 = var_11_10
						var_11_3 = var_11_9
					end
				end
			end
		end

		local var_11_11 = 14400

		if var_11_4 and var_11_6 < 400 then
			return true, var_11_5
		elseif var_11_3 and var_11_2 < var_11_11 then
			return true, var_11_3
		end

		return false
	end,
	is_completed = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
		return false
	end
}

local function var_0_3(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	for iter_13_0, iter_13_1 in pairs(arg_13_2) do
		if iter_13_1.projectile_info.show_warning_icon and iter_13_1.owner_unit ~= arg_13_0 then
			local var_13_0 = Unit.local_position(iter_13_0, 0)
			local var_13_1 = Vector3.distance_squared(arg_13_1, var_13_0)

			if var_13_1 < arg_13_4 then
				arg_13_4 = var_13_1
				arg_13_3 = var_13_0
			end
		end
	end

	return arg_13_3, arg_13_4
end

TutorialTemplates.advanced_grenade = {
	priority = 60,
	needed_points = 3,
	allowed_in_tutorial = true,
	display_type = "tooltip",
	icon = "grenade_icon",
	is_mission_tutorial = true,
	init_data = function(arg_14_0)
		return
	end,
	clear_data = function(arg_15_0)
		return
	end,
	update_data = function(arg_16_0, arg_16_1, arg_16_2)
		return
	end,
	can_show = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
		local var_17_0 = Unit.local_position(arg_17_1, 0)
		local var_17_1 = Managers.state.entity
		local var_17_2
		local var_17_3 = 400
		local var_17_4, var_17_5 = var_0_3(arg_17_1, var_17_0, var_17_1:get_entities("PlayerProjectileUnitExtension"), var_17_2, var_17_3)
		local var_17_6 = var_0_3(arg_17_1, var_17_0, var_17_1:get_entities("PlayerProjectileHuskExtension"), var_17_4, var_17_5)

		if var_17_6 == nil then
			return false
		end

		return true, var_17_6
	end,
	is_completed = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
		return false
	end
}
TutorialTemplates.play_go_tutorial_tooltip = {
	do_not_verify = true,
	needed_points = 3,
	allowed_in_tutorial = true,
	text = "none",
	display_type = "tooltip",
	icon = "hud_tutorial_icon_info",
	alt_action_icons = {
		move_left = "left_stick",
		move_forward = "left_stick",
		action_instant_heal_other_hold = "d_up",
		move_back = "left_stick",
		move_right = "left_stick",
		action_instant_drink_potion = "d_right",
		action_instant_grenade_throw = "right_shoulder"
	},
	get_text = function(arg_19_0, arg_19_1)
		return arg_19_0.text
	end,
	get_inputs = function(arg_20_0)
		return arg_20_0.inputs
	end,
	get_gamepad_inputs = function(arg_21_0)
		return arg_21_0.gamepad_inputs
	end,
	get_force_update = function(arg_22_0)
		return arg_22_0.force_update
	end,
	init_data = function(arg_23_0)
		return
	end,
	clear_data = function(arg_24_0)
		return
	end,
	update_data = function(arg_25_0, arg_25_1, arg_25_2)
		if arg_25_2.force_update then
			arg_25_2.force_update = false
		end
	end,
	can_show = function(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
		local var_26_0, var_26_1 = Managers.state.entity:system("mission_system"):get_missions()

		for iter_26_0, iter_26_1 in pairs(var_26_0) do
			if var_26_0[iter_26_0].mission_data.tooltip_text ~= nil then
				if arg_26_2.text ~= nil and var_26_0[iter_26_0].mission_data.tooltip_text ~= arg_26_2.text then
					arg_26_2.text = var_26_0[iter_26_0].mission_data.tooltip_text

					local var_26_2 = var_26_0[iter_26_0].mission_data

					arg_26_2.inputs = var_26_2.tooltip_inputs
					arg_26_2.gamepad_inputs = var_26_2.tooltip_gamepad_inputs
					arg_26_2.force_update = true
				end

				arg_26_2.text = var_26_0[iter_26_0].mission_data.tooltip_text

				local var_26_3 = var_26_0[iter_26_0].mission_data

				arg_26_2.inputs = var_26_3.tooltip_inputs
				arg_26_2.gamepad_inputs = var_26_3.tooltip_gamepad_inputs

				return true
			end
		end

		return false
	end,
	is_completed = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
		return false
	end
}
TutorialTemplates.elite_cage_respawn = {
	priority = 30,
	needed_points = 3,
	text = "tutorial_tooltip_elite_cage_respawn",
	display_type = "tooltip",
	icon = "hud_tutorial_icon_rescue",
	is_mission_tutorial = true,
	init_data = function(arg_28_0)
		return
	end,
	clear_data = function(arg_29_0)
		return
	end,
	update_data = function(arg_30_0, arg_30_1, arg_30_2)
		return
	end,
	can_show = function(arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
		local var_31_0 = Managers.player:human_and_bot_players()
		local var_31_1 = Unit.local_position(arg_31_1, 0)
		local var_31_2 = math.huge
		local var_31_3

		for iter_31_0, iter_31_1 in pairs(var_31_0) do
			local var_31_4 = iter_31_1.player_unit

			if Unit.alive(var_31_4) and arg_31_1 ~= var_31_4 and ScriptUnit.extension(var_31_4, "status_system"):is_ready_for_assisted_respawn() then
				local var_31_5 = Unit.local_position(var_31_4, 0)
				local var_31_6 = Vector3.distance_squared(var_31_1, var_31_5)

				if var_31_6 < var_31_2 then
					var_31_2 = var_31_6
					var_31_3 = var_31_5
				end
			end
		end

		if var_31_3 then
			return true, var_31_3 + Vector3.up()
		end

		return false
	end,
	is_completed = function(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
		return false
	end
}

local var_0_4 = {
	skaven_loot_rat = "tutorial_infoslate_elite_enemy_loot_rat",
	skaven_storm_vermin = "tutorial_infoslate_elite_enemy_storm_vermin",
	skaven_ratling_gunner = {
		"tutorial_infoslate_elite_enemy_ratling_gunner",
		"tutorial_infoslate_elite_enemy_ratling_gunner_02"
	},
	skaven_storm_vermin_commander = {
		"tutorial_infoslate_elite_enemy_storm_vermin_commander",
		"tutorial_infoslate_elite_enemy_storm_vermin_commander_02"
	},
	skaven_poison_wind_globadier = {
		"tutorial_infoslate_elite_enemy_poison_wind_globadier",
		"tutorial_infoslate_elite_enemy_poison_wind_globadier_02"
	},
	skaven_gutter_runner = {
		"tutorial_infoslate_elite_enemy_gutter_runner",
		"tutorial_infoslate_elite_enemy_gutter_runner_smoke_bomb"
	},
	skaven_rat_ogre = {
		"tutorial_infoslate_elite_enemy_rat_ogre",
		"tutorial_infoslate_elite_enemy_rat_ogre_02"
	},
	skaven_pack_master = {
		"tutorial_infoslate_elite_enemy_pack_master",
		"tutorial_infoslate_elite_enemy_pack_master_02"
	}
}
local var_0_5 = {}

TutorialTemplates.objective_pickup = {
	priority = 4,
	action = "interact",
	needed_points = 4,
	display_type = "objective_tooltip",
	icon = "hud_tutorial_icon_mission",
	is_mission_tutorial = true,
	game_mode_icons = {
		weave = "hud_weaves_icon_mission"
	},
	get_text = function(arg_33_0)
		return arg_33_0.objective_text
	end,
	init_data = function(arg_34_0)
		return
	end,
	clear_data = function(arg_35_0)
		return
	end,
	update_data = function(arg_36_0, arg_36_1, arg_36_2)
		return
	end,
	can_show = function(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
		local var_37_0 = ScriptUnit.extension(arg_37_1, "inventory_system")
		local var_37_1 = var_37_0:get_wielded_slot_name()
		local var_37_2 = var_37_0:get_slot_data(var_37_1)
		local var_37_3 = Managers.state.entity:get_entities("ObjectivePickupTutorialExtension")

		if var_37_1 == "slot_level_event" and var_37_2 ~= nil then
			for iter_37_0, iter_37_1 in pairs(var_37_3) do
				local var_37_4 = Unit.get_data(iter_37_0, "interaction_data", "item_name")
				local var_37_5 = ItemMasterList[var_37_4]
				local var_37_6 = var_37_5.left_hand_unit
				local var_37_7 = var_37_5.right_hand_unit
				local var_37_8 = var_37_6 and var_37_6 == var_37_2.left_hand_unit_name

				var_37_8 = var_37_8 and var_37_7 == var_37_2.right_hand_unit_name

				if var_37_8 then
					return false
				end
			end
		end

		local var_37_9 = Unit.local_position(arg_37_1, 0)
		local var_37_10 = 10000
		local var_37_11 = 0

		for iter_37_2, iter_37_3 in pairs(var_37_3) do
			if ALIVE[iter_37_2] and arg_37_1 ~= iter_37_2 then
				local var_37_12 = iter_37_3.disregard

				if not var_37_12 and ScriptUnit.has_extension(iter_37_2, "death_system") and ScriptUnit.extension(iter_37_2, "death_system"):has_death_started() then
					var_37_12 = true
				end

				local var_37_13 = Unit.local_position(iter_37_2, 0)
				local var_37_14 = Vector3.distance_squared(var_37_9, var_37_13)

				if not var_37_12 and var_37_14 < var_37_10 then
					local var_37_15 = Unit.get_data(iter_37_2, "required_mission_type")

					if var_37_15 and var_37_15 ~= "" then
						local var_37_16 = false
						local var_37_17 = Managers.state.entity:system("mission_system"):get_missions()

						for iter_37_4, iter_37_5 in pairs(var_37_17) do
							if iter_37_5.mission_type == var_37_15 then
								var_37_16 = true

								break
							end
						end

						if var_37_16 then
							var_37_11 = var_37_11 + 1
							var_0_5[var_37_11] = iter_37_2
						end
					else
						var_37_11 = var_37_11 + 1
						var_0_5[var_37_11] = iter_37_2
					end
				end
			end
		end

		if var_37_11 > 0 then
			local var_37_18 = var_0_5[1]

			arg_37_2.objective_text = Unit.get_data(var_37_18, "tutorial_text_id") or "tutorial_no_text"

			return true, var_0_5, var_37_11
		end

		return false
	end,
	is_completed = function(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
		return false
	end
}
TutorialTemplates.objective_socket = {
	priority = 5,
	action = "interact",
	needed_points = 0,
	display_type = "objective_tooltip",
	icon = "hud_tutorial_icon_mission",
	is_mission_tutorial = true,
	game_mode_icons = {
		weave = "hud_weaves_icon_mission"
	},
	get_text = function(arg_39_0)
		return arg_39_0.objective_text
	end,
	init_data = function(arg_40_0)
		return
	end,
	clear_data = function(arg_41_0)
		return
	end,
	update_data = function(arg_42_0, arg_42_1, arg_42_2)
		return
	end,
	can_show = function(arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4)
		local var_43_0 = Unit.local_position(arg_43_1, 0)
		local var_43_1 = ScriptUnit.extension(arg_43_1, "inventory_system")
		local var_43_2 = var_43_1:get_wielded_slot_name()
		local var_43_3 = var_43_1:get_slot_data(var_43_2)

		if var_43_2 == "slot_level_event" and var_43_3 ~= nil then
			local var_43_4 = Managers.state.entity:get_entities("ObjectiveSocketUnitExtension")
			local var_43_5 = var_43_3.right_unit_1p or var_43_3.left_unit_1p

			if not ScriptUnit.has_extension(var_43_5, "limited_item_track_system") then
				return false
			end

			local var_43_6 = Unit.get_data
			local var_43_7 = 0
			local var_43_8 = var_43_6(var_43_5, "socket_type")

			for iter_43_0, iter_43_1 in pairs(var_43_4) do
				local var_43_9 = var_43_6(iter_43_0, "socket_type")

				if not var_43_8 or not var_43_9 or var_43_8 == var_43_9 then
					local var_43_10 = var_43_6(iter_43_0, "sockets_enabled") ~= false
					local var_43_11 = var_43_6(iter_43_0, "tutorial_text_enabled")

					if var_43_10 and var_43_11 then
						local var_43_12 = Vector3.distance_squared(var_43_0, Unit.local_position(iter_43_0, 0))

						if iter_43_1.num_closed_sockets < iter_43_1.num_sockets and var_43_12 < iter_43_1.distance then
							var_43_7 = var_43_7 + 1
							var_0_5[var_43_7] = iter_43_0
						end
					end
				end
			end

			if var_43_7 == 0 then
				return false
			end

			local var_43_13 = var_0_5[1]

			arg_43_2.objective_text = Unit.get_data(var_43_13, "tutorial_text_id") or "tutorial_no_text"

			return true, var_0_5, var_43_7
		end

		return false
	end,
	is_completed = function(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
		return false
	end
}
TutorialTemplates.objective_unit = {
	priority = 1,
	action = "interact",
	needed_points = 0,
	display_type = "objective_tooltip",
	icon = "hud_tutorial_icon_mission",
	is_mission_tutorial = true,
	game_mode_icons = {
		weave = "hud_weaves_icon_mission"
	},
	get_text = function(arg_45_0)
		return arg_45_0.objective_text
	end,
	get_icon = function(arg_46_0)
		return arg_46_0.objective_icon
	end,
	get_alert = function(arg_47_0)
		return arg_47_0.alerts_horde
	end,
	get_wave = function(arg_48_0)
		return arg_48_0.objective_wave
	end,
	init_data = function(arg_49_0)
		return
	end,
	clear_data = function(arg_50_0)
		return
	end,
	update_data = function(arg_51_0, arg_51_1, arg_51_2)
		return
	end,
	can_show = function(arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4)
		local var_52_0 = Unit.local_position(arg_52_1, 0)
		local var_52_1 = Managers.state.entity:get_entities("ObjectiveUnitExtension")
		local var_52_2 = Vector3.distance_squared
		local var_52_3
		local var_52_4 = math.huge
		local var_52_5 = 0

		for iter_52_0, iter_52_1 in pairs(var_52_1) do
			if iter_52_1.active then
				local var_52_6 = var_52_2(var_52_0, Unit.local_position(iter_52_0, 0))

				if var_52_6 < var_52_4 then
					var_52_3 = iter_52_0
					var_52_4 = var_52_6
				end

				if iter_52_1.always_show then
					var_52_5 = var_52_5 + 1
					var_0_5[var_52_5] = iter_52_0
				end
			end
		end

		if var_52_3 and not var_52_1[var_52_3].always_show then
			var_52_5 = var_52_5 + 1
			var_0_5[var_52_5] = var_52_3
		end

		if var_52_5 > 0 then
			local var_52_7 = Unit.get_data

			arg_52_2.objective_text = var_52_7(var_52_3, "tutorial_text_id") or "tutorial_no_text"
			arg_52_2.alerts_horde = var_52_7(var_52_3, "alerts_horde") or false
			arg_52_2.objective_icon = var_52_7(var_52_3, "icon") or "hud_tutorial_icon_mission"
			arg_52_2.objective_wave = var_52_7(var_52_3, "tutorial_wave") or false

			return true, var_0_5, var_52_5
		end

		return false
	end,
	is_completed = function(arg_53_0, arg_53_1, arg_53_2, arg_53_3)
		return false
	end
}
TutorialTooltipTemplates = {}
TutorialTooltipTemplates_n = 0
TutorialInfoSlateTemplates = {}
TutorialInfoSlateTemplates_n = 0
TutorialObjectiveTooltipTemplates = {}
TutorialObjectiveTooltipTemplates_n = 0

for iter_0_0, iter_0_1 in pairs(TutorialTemplates) do
	iter_0_1.name = iter_0_0

	if iter_0_1.display_type == "tooltip" then
		iter_0_1.priority = iter_0_1.priority or 0
		TutorialTooltipTemplates_n = TutorialTooltipTemplates_n + 1
		TutorialTooltipTemplates[TutorialTooltipTemplates_n] = iter_0_1
	elseif iter_0_1.display_type == "info_slate" then
		TutorialInfoSlateTemplates_n = TutorialInfoSlateTemplates_n + 1
		TutorialInfoSlateTemplates[TutorialInfoSlateTemplates_n] = iter_0_1
	elseif iter_0_1.display_type == "objective_tooltip" then
		TutorialObjectiveTooltipTemplates_n = TutorialObjectiveTooltipTemplates_n + 1
		TutorialObjectiveTooltipTemplates[TutorialObjectiveTooltipTemplates_n] = iter_0_1
	end
end

local function var_0_6(arg_54_0, arg_54_1)
	return arg_54_0.priority > arg_54_1.priority
end

table.sort(TutorialTooltipTemplates, var_0_6)
table.sort(TutorialObjectiveTooltipTemplates, var_0_6)
