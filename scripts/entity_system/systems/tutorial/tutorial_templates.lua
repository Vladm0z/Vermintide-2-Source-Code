-- chunkname: @scripts/entity_system/systems/tutorial/tutorial_templates.lua

local function fn(arg_1_0)
	-- function 1
	return
end

local function fn_2(arg_2_0)
	-- function 2
	local extension = ScriptUnit.extension(arg_2_0, "inventory_system")
	local get_wielded_slot_name = extension:get_wielded_slot_name()
	local get_slot_data = extension:get_slot_data(get_wielded_slot_name)

	if get_slot_data == nil then
		return false
	end

	local right_unit_1p = get_slot_data.right_unit_1p

	if not ScriptUnit.has_extension(right_unit_1p, "ammo_system") then
		return false
	end

	return true
end

local POSITION_LOOKUP = POSITION_LOOKUP

TutorialTemplates = {}
TutorialTemplates.core_needs_help = {
	priority = 50,
	action = "interact",
	needed_points = 0,
	text = "player_in_need_of_help",
	display_type = "tooltip",
	icon = "hud_tutorial_icon_attention",
	is_mission_tutorial = true,
	init_data = function (arg_3_0)
		-- function 3
		return
	end,
	clear_data = function (arg_4_0)
		-- function 4
		return
	end,
	update_data = function (arg_5_0, arg_5_1, arg_5_2)
		-- function 5
		return
	end,
	can_show = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		-- function 6
		local human_and_bot_players = Managers.player:human_and_bot_players()
		local local_position = Unit.local_position(arg_6_1, 0)
		local huge = math.huge
		local var_6_3
		local var_6_4
		local var_6_5
		local var_6_6

		for k, v in pairs(human_and_bot_players) do
			local player_unit = v.player_unit

			if not (not Unit.alive(player_unit) and arg_6_1 == player_unit) then
				local extension = ScriptUnit.extension(player_unit, "status_system")

				if extension:is_dead() or extension:is_pounced_down() or extension:get_is_ledge_hanging() or not extension:is_grabbed_by_pack_master() then
					local local_position_2 = Unit.local_position(player_unit, 0)
					local distance_squared = Vector3.distance_squared(local_position, local_position_2)

					if player_unit == arg_6_3 then
						var_6_4 = true
						var_6_5 = local_position_2
						var_6_6 = distance_squared
					end

					if distance_squared < huge then
						huge = distance_squared
						var_6_3 = local_position_2
					end
				end
			end
		end

		if not (not var_6_4 and not (var_6_6 < 400)) then
			return true, var_6_5
		elseif not var_6_3 then
			return true, var_6_3
		end

		return false
	end,
	is_completed = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
		-- function 7
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
	init_data = function (arg_8_0)
		-- function 8
		return
	end,
	clear_data = function (arg_9_0)
		-- function 9
		return
	end,
	update_data = function (arg_10_0, arg_10_1, arg_10_2)
		-- function 10
		return
	end,
	can_show = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
		-- function 11
		local human_and_bot_players = Managers.player:human_and_bot_players()
		local local_position = Unit.local_position(arg_11_1, 0)
		local huge = math.huge
		local var_11_3
		local var_11_4
		local var_11_5
		local var_11_6

		for k, v in pairs(human_and_bot_players) do
			local player_unit = v.player_unit

			if not (not Unit.alive(player_unit) and arg_11_1 == player_unit) then
				local extension = ScriptUnit.extension(player_unit, "status_system")

				if not (not extension:is_knocked_down() and extension:is_dead()) then
					local local_position_2 = Unit.local_position(player_unit, 0)
					local distance_squared = Vector3.distance_squared(local_position, local_position_2)

					if player_unit == arg_11_3 then
						var_11_4 = true
						var_11_5 = local_position_2
						var_11_6 = distance_squared
					end

					if distance_squared < huge then
						huge = distance_squared
						var_11_3 = local_position_2
					end
				end
			end
		end

		local num = 14400

		if not (not var_11_4 and not (var_11_6 < 400)) then
			return true, var_11_5
		elseif not (not var_11_3 and not (huge < num)) then
			return true, var_11_3
		end

		return false
	end,
	is_completed = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
		-- function 12
		return false
	end
}

local function fn_3(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	-- function 13
	for k, v in pairs(arg_13_2) do
		if not (not v.projectile_info.show_warning_icon and v.owner_unit == arg_13_0) then
			local local_position = Unit.local_position(k, 0)
			local distance_squared = Vector3.distance_squared(arg_13_1, local_position)

			if distance_squared < arg_13_4 then
				arg_13_4 = distance_squared
				arg_13_3 = local_position
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
	init_data = function (arg_14_0)
		-- function 14
		return
	end,
	clear_data = function (arg_15_0)
		-- function 15
		return
	end,
	update_data = function (arg_16_0, arg_16_1, arg_16_2)
		-- function 16
		return
	end,
	can_show = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
		-- function 17
		local local_position = Unit.local_position(arg_17_1, 0)
		local entity = Managers.state.entity
		local var_17_2
		local num = 400
		local var_17_4, var_17_5 = fn_3(arg_17_1, local_position, entity:get_entities("PlayerProjectileUnitExtension"), var_17_2, num)
		local var_17_6 = fn_3(arg_17_1, local_position, entity:get_entities("PlayerProjectileHuskExtension"), var_17_4, var_17_5)

		if var_17_6 == nil then
			return false
		end

		return true, var_17_6
	end,
	is_completed = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
		-- function 18
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
	get_text = function (self, arg_19_1)
		-- function 19
		return self.text
	end,
	get_inputs = function (self)
		-- function 20
		return self.inputs
	end,
	get_gamepad_inputs = function (self)
		-- function 21
		return self.gamepad_inputs
	end,
	get_force_update = function (self)
		-- function 22
		return self.force_update
	end,
	init_data = function (arg_23_0)
		-- function 23
		return
	end,
	clear_data = function (arg_24_0)
		-- function 24
		return
	end,
	update_data = function (arg_25_0, arg_25_1, arg_25_2)
		-- function 25
		if not arg_25_2.force_update then
			arg_25_2.force_update = false
		end
	end,
	can_show = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
		-- function 26
		local get_missions, var_26_1 = Managers.state.entity:system("mission_system"):get_missions()

		for k, v in pairs(get_missions) do
			if get_missions[k].mission_data.tooltip_text ~= nil then
				if not (arg_26_2.text == nil or get_missions[k].mission_data.tooltip_text == arg_26_2.text) then
					arg_26_2.text = get_missions[k].mission_data.tooltip_text

					local mission_data = get_missions[k].mission_data

					arg_26_2.inputs = mission_data.tooltip_inputs
					arg_26_2.gamepad_inputs = mission_data.tooltip_gamepad_inputs
					arg_26_2.force_update = true
				end

				arg_26_2.text = get_missions[k].mission_data.tooltip_text

				local mission_data_2 = get_missions[k].mission_data

				arg_26_2.inputs = mission_data_2.tooltip_inputs
				arg_26_2.gamepad_inputs = mission_data_2.tooltip_gamepad_inputs

				return true
			end
		end

		return false
	end,
	is_completed = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
		-- function 27
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
	init_data = function (arg_28_0)
		-- function 28
		return
	end,
	clear_data = function (arg_29_0)
		-- function 29
		return
	end,
	update_data = function (arg_30_0, arg_30_1, arg_30_2)
		-- function 30
		return
	end,
	can_show = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
		-- function 31
		local human_and_bot_players = Managers.player:human_and_bot_players()
		local local_position = Unit.local_position(arg_31_1, 0)
		local huge = math.huge
		local var_31_3

		for k, v in pairs(human_and_bot_players) do
			local player_unit = v.player_unit

			if not Unit.alive(player_unit) and arg_31_1 == player_unit or not ScriptUnit.extension(player_unit, "status_system"):is_ready_for_assisted_respawn() then
				local local_position_2 = Unit.local_position(player_unit, 0)
				local distance_squared = Vector3.distance_squared(local_position, local_position_2)

				if distance_squared < huge then
					huge = distance_squared
					var_31_3 = local_position_2
				end
			end
		end

		if not var_31_3 then
			return true, var_31_3 + Vector3.up()
		end

		return false
	end,
	is_completed = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
		-- function 32
		return false
	end
}

local tbl = {
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
local tbl_2 = {}

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
	get_text = function (self)
		-- function 33
		return self.objective_text
	end,
	init_data = function (arg_34_0)
		-- function 34
		return
	end,
	clear_data = function (arg_35_0)
		-- function 35
		return
	end,
	update_data = function (arg_36_0, arg_36_1, arg_36_2)
		-- function 36
		return
	end,
	can_show = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
		-- function 37
		local extension = ScriptUnit.extension(arg_37_1, "inventory_system")
		local get_wielded_slot_name = extension:get_wielded_slot_name()
		local get_slot_data = extension:get_slot_data(get_wielded_slot_name)
		local get_entities = Managers.state.entity:get_entities("ObjectivePickupTutorialExtension")

		if not (get_wielded_slot_name ~= "slot_level_event" or get_slot_data == nil) then
			for k, v in pairs(get_entities) do
				local get_data = Unit.get_data(k, "interaction_data", "item_name")
				local var_37_5 = ItemMasterList[get_data]
				local left_hand_unit = var_37_5.left_hand_unit
				local right_hand_unit = var_37_5.right_hand_unit
				local flag = not left_hand_unit and left_hand_unit == get_slot_data.left_hand_unit_name

				flag = not flag and right_hand_unit == get_slot_data.right_hand_unit_name

				if not flag then
					return false
				end
			end
		end

		local local_position = Unit.local_position(arg_37_1, 0)
		local num = 10000
		local num_2 = 0

		for k_2, v_2 in pairs(get_entities) do
			if not (not ALIVE[k_2] and arg_37_1 == k_2) then
				local disregard = v_2.disregard

				if (disregard or not ScriptUnit.has_extension(k_2, "death_system")) and not ScriptUnit.extension(k_2, "death_system"):has_death_started() then
					disregard = true
				end

				local local_position_2 = Unit.local_position(k_2, 0)
				local distance_squared = Vector3.distance_squared(local_position, local_position_2)

				if not (disregard or not (distance_squared < num)) then
					local get_data_2 = Unit.get_data(k_2, "required_mission_type")

					if not (not get_data_2 and get_data_2 == "") then
						local flag_2 = false
						local get_missions = Managers.state.entity:system("mission_system"):get_missions()

						for k_3, v_3 in pairs(get_missions) do
							if v_3.mission_type == get_data_2 then
								flag_2 = true

								break
							end
						end

						if not flag_2 then
							num_2 = num_2 + 1
							tbl_2[num_2] = k_2
						end
					else
						num_2 = num_2 + 1
						tbl_2[num_2] = k_2
					end
				end
			end
		end

		if num_2 > 0 then
			local var_37_18 = tbl_2[1]
			local get_data_3 = Unit.get_data(var_37_18, "tutorial_text_id")

			get_data_3 = get_data_3 or "tutorial_no_text"
			arg_37_2.objective_text = get_data_3

			return true, tbl_2, num_2
		end

		return false
	end,
	is_completed = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3)
		-- function 38
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
	get_text = function (self)
		-- function 39
		return self.objective_text
	end,
	init_data = function (arg_40_0)
		-- function 40
		return
	end,
	clear_data = function (arg_41_0)
		-- function 41
		return
	end,
	update_data = function (arg_42_0, arg_42_1, arg_42_2)
		-- function 42
		return
	end,
	can_show = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4)
		-- function 43
		local local_position = Unit.local_position(arg_43_1, 0)
		local extension = ScriptUnit.extension(arg_43_1, "inventory_system")
		local get_wielded_slot_name = extension:get_wielded_slot_name()
		local get_slot_data = extension:get_slot_data(get_wielded_slot_name)

		if not (get_wielded_slot_name ~= "slot_level_event" or get_slot_data == nil) then
			local get_entities = Managers.state.entity:get_entities("ObjectiveSocketUnitExtension")
			local right_unit_1p = get_slot_data.right_unit_1p

			right_unit_1p = right_unit_1p or get_slot_data.left_unit_1p

			if not ScriptUnit.has_extension(right_unit_1p, "limited_item_track_system") then
				return false
			end

			local get_data = Unit.get_data
			local num = 0
			local var_43_8 = get_data(right_unit_1p, "socket_type")

			for k, v in pairs(get_entities) do
				local var_43_9 = get_data(k, "socket_type")

				if not (not var_43_8 and not var_43_9 and var_43_8 ~= var_43_9) then
					local flag = get_data(k, "sockets_enabled") ~= false
					local var_43_11 = get_data(k, "tutorial_text_enabled")

					if not flag and not var_43_11 then
						local distance_squared = Vector3.distance_squared(local_position, Unit.local_position(k, 0))

						if not (not (v.num_closed_sockets < v.num_sockets) or not (distance_squared < v.distance)) then
							num = num + 1
							tbl_2[num] = k
						end
					end
				end
			end

			if num == 0 then
				return false
			end

			local var_43_13 = tbl_2[1]
			local get_data_2 = Unit.get_data(var_43_13, "tutorial_text_id")

			get_data_2 = get_data_2 or "tutorial_no_text"
			arg_43_2.objective_text = get_data_2

			return true, tbl_2, num
		end

		return false
	end,
	is_completed = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
		-- function 44
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
	get_text = function (self)
		-- function 45
		return self.objective_text
	end,
	get_icon = function (self)
		-- function 46
		return self.objective_icon
	end,
	get_alert = function (self)
		-- function 47
		return self.alerts_horde
	end,
	get_wave = function (self)
		-- function 48
		return self.objective_wave
	end,
	init_data = function (arg_49_0)
		-- function 49
		return
	end,
	clear_data = function (arg_50_0)
		-- function 50
		return
	end,
	update_data = function (arg_51_0, arg_51_1, arg_51_2)
		-- function 51
		return
	end,
	can_show = function (arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4)
		-- function 52
		local local_position = Unit.local_position(arg_52_1, 0)
		local get_entities = Managers.state.entity:get_entities("ObjectiveUnitExtension")
		local distance_squared = Vector3.distance_squared
		local var_52_3
		local huge = math.huge
		local num = 0

		for k, v in pairs(get_entities) do
			if not v.active then
				local var_52_6 = distance_squared(local_position, Unit.local_position(k, 0))

				if var_52_6 < huge then
					var_52_3 = k
					huge = var_52_6
				end

				if not v.always_show then
					num = num + 1
					tbl_2[num] = k
				end
			end
		end

		if not (not var_52_3 and get_entities[var_52_3].always_show) then
			num = num + 1
			tbl_2[num] = var_52_3
		end

		if num > 0 then
			local get_data = Unit.get_data
			local var_52_8 = get_data(var_52_3, "tutorial_text_id")

			var_52_8 = var_52_8 or "tutorial_no_text"
			arg_52_2.objective_text = var_52_8

			local var_52_9 = get_data(var_52_3, "alerts_horde")

			var_52_9 = var_52_9 or false
			arg_52_2.alerts_horde = var_52_9

			local var_52_10 = get_data(var_52_3, "icon")

			var_52_10 = var_52_10 or "hud_tutorial_icon_mission"
			arg_52_2.objective_icon = var_52_10

			local var_52_11 = get_data(var_52_3, "tutorial_wave")

			var_52_11 = var_52_11 or false
			arg_52_2.objective_wave = var_52_11

			return true, tbl_2, num
		end

		return false
	end,
	is_completed = function (arg_53_0, arg_53_1, arg_53_2, arg_53_3)
		-- function 53
		return false
	end
}
TutorialTooltipTemplates = {}
TutorialTooltipTemplates_n = 0
TutorialInfoSlateTemplates = {}
TutorialInfoSlateTemplates_n = 0
TutorialObjectiveTooltipTemplates = {}
TutorialObjectiveTooltipTemplates_n = 0

for k, v in pairs(TutorialTemplates) do
	v.name = k

	if v.display_type == "tooltip" then
		local priority = v.priority

		priority = priority or 0
		v.priority = priority
		TutorialTooltipTemplates_n = TutorialTooltipTemplates_n + 1
		TutorialTooltipTemplates[TutorialTooltipTemplates_n] = v
	elseif v.display_type == "info_slate" then
		TutorialInfoSlateTemplates_n = TutorialInfoSlateTemplates_n + 1
		TutorialInfoSlateTemplates[TutorialInfoSlateTemplates_n] = v
	elseif v.display_type == "objective_tooltip" then
		TutorialObjectiveTooltipTemplates_n = TutorialObjectiveTooltipTemplates_n + 1
		TutorialObjectiveTooltipTemplates[TutorialObjectiveTooltipTemplates_n] = v
	end
end

local function fn_4(self, arg_54_1)
	-- function 54
	return self.priority > arg_54_1.priority
end

table.sort(TutorialTooltipTemplates, fn_4)
table.sort(TutorialObjectiveTooltipTemplates, fn_4)
