-- chunkname: @scripts/entity_system/systems/ai/ai_group_templates/ai_group_templates_patrol.lua

require("scripts/settings/patrol_formation_settings")
require("scripts/helpers/navigation_utils")

local var_0_0 = POSITION_LOOKUP
local var_0_1 = BLACKBOARDS
local var_0_2 = Vector3.distance_squared
local var_0_3 = GwNavQueries.triangle_from_position
local var_0_4 = GwNavQueries.raycast
local var_0_5 = GwNavQueries.inside_position_from_outside_position

local function var_0_6(...)
	if script_data.debug_patrols then
		print(...)
	end
end

local var_0_7 = math.pi * 0.7
local var_0_8 = 2.77
local var_0_9 = 5
local var_0_10 = 25
local var_0_11 = {
	planks = 10,
	ledges_with_fence = 10,
	doors = 10,
	jumps = 10,
	ledges = 10,
	bot_poison_wind = 15,
	fire_grenade = 15,
	bot_ratling_gun_fire = 15
}
local var_0_12 = {
	plague_wave = 15,
	troll_bile = 15,
	lamp_oil_fire = 15,
	warpfire_thrower_warpfire = 15,
	stormfiend_warpfire = 20
}
local var_0_13 = 20
local var_0_14 = 8
local var_0_15 = 5
local var_0_16 = var_0_15^2
local var_0_17
local var_0_18
local var_0_19
local var_0_20
local var_0_21
local var_0_22
local var_0_23
local var_0_24
local var_0_25
local var_0_26
local var_0_27
local var_0_28
local var_0_29
local var_0_30
local var_0_31
local var_0_32
local var_0_33
local var_0_34
local var_0_35
local var_0_36
local var_0_37
local var_0_38
local var_0_39
local var_0_40
local var_0_41
local var_0_42
local var_0_43
local var_0_44
local var_0_45
local var_0_46
local var_0_47
local var_0_48
local var_0_49
local var_0_50

AIGroupTemplates = AIGroupTemplates or {}
AIGroupTemplates.spline_patrol = {
	in_patrol = true,
	pre_unit_init = function (arg_2_0, arg_2_1)
		var_0_1[arg_2_0].ignore_interest_points = true
	end,
	init = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		var_0_20(arg_3_1, arg_3_2, arg_3_0, arg_3_3)
		var_0_29(arg_3_1, arg_3_2, nil)
	end,
	destroy = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
		local var_4_0 = arg_4_2.nav_data

		GwNavTagLayerCostTable.destroy(var_4_0.navtag_layer_cost_table)
		GwNavCostMap.destroy_tag_cost_table(var_4_0.nav_cost_map_cost_table)
		GwNavTraverseLogic.destroy(var_4_0.traverse_logic)
	end,
	update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
		var_0_22(arg_5_2)
		var_0_40(arg_5_2, arg_5_1, arg_5_3, arg_5_4)

		if arg_5_2.num_indexed_members == 0 or arg_5_2.patrol_path_broken then
			return
		end

		local var_5_0 = arg_5_2.state

		if var_5_0 == "find_path_entry" then
			-- Nothing
		elseif var_5_0 == "forming" then
			var_0_34(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
			var_0_33(arg_5_2, arg_5_4)
			var_0_42(arg_5_2, arg_5_3)
		elseif var_5_0 == "patrolling" then
			if var_0_41(arg_5_2) then
				return
			end

			var_0_37(arg_5_1, arg_5_2, arg_5_4)
			var_0_39(arg_5_1, arg_5_2, arg_5_4)
			var_0_38(arg_5_1, arg_5_2)
			var_0_34(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
			var_0_19(arg_5_2, arg_5_3)
			var_0_42(arg_5_2, arg_5_3)
		elseif var_5_0 == "opening_door" then
			var_0_44(arg_5_2)
		elseif var_5_0 == "controlled_advance" then
			var_0_19(arg_5_2, arg_5_3)
			var_0_47(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
		elseif var_5_0 == "in_combat" then
			-- Nothing
		end
	end,
	setup_group = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		arg_6_2.target_units = {}
	end,
	BT_debug = function (arg_7_0)
		return {
			"GROUP_SYSTEM:",
			tostring(arg_7_0.template),
			"state:" .. (arg_7_0.state or ""),
			"previous_state:" .. (arg_7_0.previous_state or ""),
			"num members: " .. (arg_7_0.members_n or 1)
		}
	end
}

local function var_0_51(arg_8_0, arg_8_1)
	var_0_18(arg_8_0)

	local var_8_0 = Managers.state.entity:system("audio_system")
	local var_8_1 = arg_8_0.formation_settings.sounds[arg_8_1]

	var_8_0:play_audio_unit_event(var_8_1, arg_8_0.wwise_source_unit)
end

function var_0_18(arg_9_0)
	local var_9_0 = math.ceil(arg_9_0.num_indexed_members * 0.5)

	arg_9_0.wwise_source_unit = arg_9_0.indexed_members[var_9_0]
end

function var_0_19(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0.wwise_source_unit

	if not HEALTH_ALIVE[var_10_0] then
		var_0_18(arg_10_0)

		var_10_0 = arg_10_0.wwise_source_unit
	end

	local var_10_1 = var_0_1[var_10_0]

	if arg_10_1 > arg_10_0.patrol_sound_at_t then
		local var_10_2 = Managers.state.entity:system("audio_system")
		local var_10_3 = arg_10_0.formation_settings.sounds
		local var_10_4 = var_10_3.FOLEY

		var_10_2:play_audio_unit_event(var_10_4, var_10_0)

		if arg_10_0.has_extra_breed then
			local var_10_5 = var_10_3.FOLEY_EXTRA

			var_10_2:play_audio_unit_event(var_10_5, var_10_0)
		end

		local var_10_6 = var_10_3.VOICE

		var_10_2:play_audio_unit_event(var_10_6, var_10_0)

		arg_10_0.patrol_sound_at_t = arg_10_1 + 0.5
	end
end

local function var_0_52(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_1 * (arg_11_2.nav_data.node_direction == "reversed" and -1 or 1)

	arg_11_0:movement():set_speed(var_11_0)
end

local function var_0_53(arg_12_0, arg_12_1)
	var_0_6("[Patrol] Entered state:", arg_12_1)

	arg_12_0.previous_state = arg_12_0.state
	arg_12_0.state = arg_12_1
end

local var_0_54 = {}

function var_0_22(arg_13_0)
	local var_13_0 = false
	local var_13_1
	local var_13_2 = Unit.alive
	local var_13_3 = arg_13_0.indexed_members
	local var_13_4 = arg_13_0.num_indexed_members

	for iter_13_0 = var_13_4, 1, -1 do
		local var_13_5 = var_13_3[iter_13_0]

		if not HEALTH_ALIVE[var_13_5] then
			table.remove(var_13_3, iter_13_0)

			var_13_4 = var_13_4 - 1
			var_0_54[var_13_5] = true
			var_13_0 = true

			if not var_13_1 and var_13_2(var_13_5) then
				local var_13_6 = var_0_1[var_13_5].previous_attacker

				if HEALTH_ALIVE[var_13_6] then
					var_13_1 = var_13_6
				end
			end
		end
	end

	arg_13_0.num_indexed_members = var_13_4

	if var_13_0 then
		local var_13_7 = arg_13_0.anchors

		for iter_13_1 = #var_13_7, 1, -1 do
			local var_13_8 = var_13_7[iter_13_1].units
			local var_13_9 = true

			for iter_13_2, iter_13_3 in pairs(var_13_8) do
				if var_0_54[iter_13_3] then
					var_13_8[iter_13_2] = nil
				else
					var_13_9 = false

					if var_13_1 then
						var_0_1[iter_13_3].previous_attacker = var_13_1
					end
				end
			end

			if var_13_9 then
				table.remove(var_13_7, iter_13_1)
			end
		end

		table.clear(var_0_54)
	end
end

local function var_0_55(arg_14_0)
	local var_14_0 = Vector3(0, 0, 0)
	local var_14_1 = arg_14_0.indexed_members
	local var_14_2 = arg_14_0.num_indexed_members

	for iter_14_0 = 1, var_14_2 do
		local var_14_3 = var_14_1[iter_14_0]

		var_14_0 = var_14_0 + var_0_0[var_14_3]
	end

	return var_14_0 / var_14_2
end

local function var_0_56(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8, arg_15_9)
	local var_15_0
	local var_15_1, var_15_2 = var_0_3(arg_15_0, arg_15_2, arg_15_3, arg_15_4)

	if var_15_1 then
		arg_15_2 = Vector3(arg_15_2.x, arg_15_2.y, var_15_2)

		local var_15_3, var_15_4 = var_0_4(arg_15_0, arg_15_2, arg_15_1)

		var_15_0 = var_15_4
	else
		local var_15_5
		local var_15_6 = 12
		local var_15_7 = Vector3.normalize(Vector3.flat(arg_15_9))

		for iter_15_0 = 0, var_15_6 - 1 do
			local var_15_8 = arg_15_1 + var_15_7 * (0.5 * iter_15_0)
			local var_15_9, var_15_10 = var_0_3(arg_15_0, var_15_8, arg_15_3, arg_15_4)

			if var_15_9 then
				var_15_5 = Vector3(var_15_8.x, var_15_8.y, var_15_10)

				break
			else
				local var_15_11 = var_0_5(arg_15_0, var_15_8, arg_15_5, arg_15_6, arg_15_7, arg_15_8)

				if var_15_11 then
					var_15_5 = var_15_11

					break
				end
			end
		end

		if var_15_5 then
			var_15_0 = var_15_5
		else
			var_15_0 = arg_15_2
		end
	end

	return var_15_0
end

local function var_0_57(arg_16_0)
	local var_16_0 = arg_16_0.nav_data.node_direction
	local var_16_1 = var_16_0 == "reversed" and "forward" or "reversed"

	var_0_28(arg_16_0, var_16_1, var_16_0)
end

local function var_0_58(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_1.spline_name
	local var_17_1 = LevelHelper:current_level(arg_17_0)
	local var_17_2 = arg_17_1.spline_points
	local var_17_3

	if var_17_2 then
		local var_17_4 = arg_17_1.spline_points

		var_17_3 = AiUtils.remove_bad_boxed_spline_points(var_17_4, var_17_0)
	else
		local var_17_5 = Level.spline(var_17_1, var_17_0)

		var_17_3 = AiUtils.remove_bad_spline_points(var_17_5, var_17_0)
	end

	local var_17_6 = #var_17_3

	if var_17_6 == 0 then
		return false
	end

	local var_17_7 = {
		forward_list = {},
		reversed_list = {}
	}

	for iter_17_0 = 1, var_17_6 do
		local var_17_8 = var_17_3[iter_17_0]

		var_17_7.forward_list[iter_17_0] = Vector3Box(var_17_8)

		local var_17_9 = var_17_6 - iter_17_0 + 1

		var_17_7.reversed_list[var_17_9] = Vector3Box(var_17_8)
	end

	local var_17_10 = var_17_3[1]
	local var_17_11 = var_17_3[var_17_6]
	local var_17_12 = var_0_2(var_17_10, var_17_11) < var_0_16
	local var_17_13 = arg_17_1.anchors
	local var_17_14 = #var_17_13

	for iter_17_1 = 1, var_17_14 do
		local var_17_15 = var_17_13[iter_17_1]
		local var_17_16 = var_17_0 .. ":" .. iter_17_1

		if var_17_2 then
			var_17_15.spline = SplineCurve:new(var_17_3, "Hermite", "SplineMovementHermiteInterpolatedMetered", var_17_16, 3, arg_17_1.cached_splines)
		else
			var_17_15.spline = SplineCurve:new(var_17_3, "Bezier", "SplineMovementHermiteInterpolatedMetered", var_17_16, 10)
		end

		var_17_15.is_circular_spline = var_17_12
	end

	return var_17_7
end

local function var_0_59(arg_18_0)
	local var_18_0 = arg_18_0.anchors
	local var_18_1 = #var_18_0

	for iter_18_0 = 1, var_18_1 do
		local var_18_2 = var_18_0[iter_18_0]
		local var_18_3 = var_18_2.point:unbox()
		local var_18_4 = var_18_2.spline
		local var_18_5, var_18_6, var_18_7 = NavigationUtils.get_position_on_interpolated_spline(var_18_4, var_18_3)

		var_18_4:movement():set_spline_index(var_18_5, var_18_6, var_18_7)
	end
end

local function var_0_60(arg_19_0, arg_19_1)
	local var_19_0 = {}
	local var_19_1 = arg_19_1.anchors[1].spline
	local var_19_2 = var_19_1:movement()
	local var_19_3 = 2
	local var_19_4 = 3
	local var_19_5 = 1
	local var_19_6 = 1
	local var_19_7 = var_19_1:splines()
	local var_19_8 = #var_19_7

	for iter_19_0 = 1, var_19_8 do
		local var_19_9 = var_19_7[iter_19_0]
		local var_19_10 = var_19_9.points
		local var_19_11 = (var_19_10[var_19_3]:unbox() + var_19_10[var_19_4]:unbox()) / 2

		if not var_0_3(arg_19_0, var_19_11, var_19_5, var_19_6) then
			local var_19_12 = #var_19_9.subdivisions

			var_19_0[iter_19_0] = {
				forward = {
					next_t = 1,
					start_subdivision_index = 1,
					next_subdivsion_index = var_19_12
				},
				reversed = {
					next_t = 0,
					next_subdivsion_index = 1,
					start_subdivision_index = var_19_12
				}
			}
		end
	end

	arg_19_1.jump_points = var_19_0
end

function var_0_20(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	fassert(arg_20_1.members_n > 0, "Group was initialized with zero members!")

	arg_20_1.nav_data = {}

	local var_20_0 = GwNavTagLayerCostTable.create()

	table.merge(var_0_11, NAV_TAG_VOLUME_LAYER_COST_AI)
	AiUtils.initialize_cost_table(var_20_0, var_0_11)

	local var_20_1 = GwNavCostMap.create_tag_cost_table()

	AiUtils.initialize_nav_cost_map_cost_table(var_20_1, var_0_12)

	local var_20_2 = GwNavTraverseLogic.create(arg_20_0, var_20_1)

	GwNavTraverseLogic.set_navtag_layer_cost_table(var_20_2, var_20_0)

	arg_20_1.nav_data.navtag_layer_cost_table = var_20_0
	arg_20_1.nav_data.nav_cost_map_cost_table = var_20_1
	arg_20_1.nav_data.traverse_logic = var_20_2

	local var_20_3 = arg_20_1.formation_settings
	local var_20_4 = var_20_3.offsets.ANCHOR_OFFSET
	local var_20_5 = {}
	local var_20_6 = #arg_20_1.formation

	for iter_20_0 = 1, var_20_6 do
		var_20_5[iter_20_0] = {
			point = Vector3Box(),
			wanted_direction = Vector3Box(),
			current_direction = Vector3Box(),
			units = {}
		}

		local var_20_7 = arg_20_1.formation[iter_20_0]
		local var_20_8 = #var_20_7
		local var_20_9 = {}
		local var_20_10 = Vector3.zero()
		local var_20_11

		for iter_20_1 = 1, var_20_8 do
			local var_20_12 = var_20_7[iter_20_1]
			local var_20_13 = var_20_12.start_position

			var_20_9[iter_20_1] = var_20_13
			var_20_10 = var_20_10 + var_20_13:unbox()
			var_20_11 = var_20_11 or var_20_12.start_direction:unbox()
		end

		local var_20_14 = var_20_10 / var_20_8

		var_20_5[iter_20_0].point:store(var_20_14)

		var_20_5[iter_20_0].positions = var_20_9

		var_20_5[iter_20_0].current_direction:store(var_20_11)
		var_20_5[iter_20_0].wanted_direction:store(var_20_11)

		local var_20_15 = var_20_4.y * math.max(var_20_8 - 1, 1)

		var_20_5[iter_20_0].wanted_offset = {
			var_20_15,
			var_20_15
		}
	end

	arg_20_1.anchors = var_20_5

	local var_20_16 = var_20_3.extra_breed_name
	local var_20_17 = false
	local var_20_18 = 0
	local var_20_19 = {}
	local var_20_20 = arg_20_1.group_type == "spline_patrol"

	for iter_20_2, iter_20_3 in pairs(arg_20_1.members) do
		if HEALTH_ALIVE[iter_20_2] then
			local var_20_21 = var_0_1[iter_20_2]

			var_20_21.only_trust_your_own_eyes = var_20_20

			local var_20_22 = var_20_21.breed

			if var_20_22.name == var_20_16 then
				var_20_17 = true
			end

			local var_20_23 = var_20_21.navigation_extension

			var_20_23:set_far_pathing_allowed(false)

			if var_20_22.use_navigation_path_splines then
				GwNavBot.set_use_channel(var_20_23._nav_bot, false)
			end

			local var_20_24 = ScriptUnit.extension(iter_20_2, "ai_group_system")
			local var_20_25 = var_20_24.group_row
			local var_20_26 = var_20_24.group_column
			local var_20_27 = var_20_5[var_20_25]

			var_20_27.units[var_20_26] = iter_20_2
			var_20_24.anchor = var_20_27
			var_20_18 = var_20_18 + 1
			var_20_19[var_20_18] = iter_20_2
			var_20_21.preferred_door_action = "open"

			var_20_23:allow_layer("planks", false)
			GwNavTagLayerCostTable.forbid_layer(arg_20_1.nav_data.navtag_layer_cost_table, LAYER_ID_MAPPING.planks)

			if var_20_24.use_patrol_perception then
				local var_20_28 = ScriptUnit.extension(iter_20_2, "ai_system")
				local var_20_29 = var_20_21.breed
				local var_20_30 = var_20_29.patrol_passive_perception
				local var_20_31 = var_20_29.patrol_passive_target_selection

				fassert(var_20_30, "Missing patrol passive perception!")
				fassert(var_20_31, "Missing patrol passive target selection!")
				var_20_28:set_perception(var_20_30, var_20_31)
			end
		end
	end

	arg_20_1.indexed_members = var_20_19
	arg_20_1.num_indexed_members = var_20_18
	arg_20_1.has_extra_breed = var_20_17
	arg_20_1.attack_latest_t = 0
	arg_20_1.controlled_advance_distance_check_t = 0
	arg_20_1.door_unit = nil
	arg_20_1.use_controlled_advance = var_20_3.use_controlled_advance
	arg_20_1.patrol_sound_at_t = arg_20_3
	arg_20_1.end_of_spline_forming_positions_function = var_20_20 and var_0_31 or var_0_30

	local var_20_32 = var_0_58(arg_20_2, arg_20_1)

	arg_20_1.nav_data.node_data = var_20_32

	var_0_28(arg_20_1, "forward")
	var_0_59(arg_20_1)
	var_0_60(arg_20_0, arg_20_1)
end

local function var_0_61(arg_21_0, arg_21_1)
	var_0_53(arg_21_1, "find_path_entry")

	local var_21_0 = arg_21_1.nav_data.node_list
	local var_21_1 = var_0_55(arg_21_1)
	local var_21_2 = MainPathUtils.closest_node_in_node_list(var_21_0, var_21_1)

	if var_0_30(arg_21_0, arg_21_1, var_21_2) then
		var_0_59(arg_21_1)
	end

	var_0_36(arg_21_1)
end

function var_0_28(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_0.nav_data
	local var_22_1 = arg_22_0.anchors
	local var_22_2 = #var_22_1

	if arg_22_1 == "forward" then
		var_22_0.node_direction = "forward"
		var_22_0.node_list = var_22_0.node_data.forward_list

		if arg_22_2 then
			for iter_22_0 = 1, var_22_2 do
				local var_22_3 = var_22_1[iter_22_0].spline

				var_22_3:movement():reset_to_start()
				var_0_52(var_22_3, 0, arg_22_0)
			end
		end
	else
		var_22_0.node_direction = "reversed"
		var_22_0.node_list = var_22_0.node_data.reversed_list

		if arg_22_2 then
			for iter_22_1 = 1, var_22_2 do
				local var_22_4 = var_22_1[iter_22_1].spline

				var_22_4:movement():reset_to_end()
				var_0_52(var_22_4, 0, arg_22_0)
			end
		end
	end
end

function var_0_29(arg_23_0, arg_23_1, arg_23_2)
	var_0_53(arg_23_1, "forming")

	local var_23_0 = arg_23_1.nav_data
	local var_23_1 = #var_23_0.node_list
	local var_23_2 = var_23_0.node_list[var_23_1]:unbox()
	local var_23_3 = 1
	local var_23_4 = 1
	local var_23_5, var_23_6 = var_0_3(arg_23_0, var_23_2, var_23_3, var_23_4)

	if not var_23_5 then
		return
	end

	var_23_2.z = var_23_6

	local var_23_7 = arg_23_1.indexed_members
	local var_23_8 = arg_23_1.num_indexed_members

	for iter_23_0 = 1, var_23_8 do
		local var_23_9 = var_23_7[iter_23_0]
		local var_23_10 = var_0_1[var_23_9]
		local var_23_11 = var_23_10.navigation_extension
		local var_23_12 = arg_23_1.formation_settings.speeds.WALK_SPEED

		var_23_11:set_max_speed(var_23_12)

		var_23_10.goal_destination = nil
		var_23_10.stored_goal_destination = Vector3Box(var_23_2)
	end

	if arg_23_2 then
		local var_23_13, var_23_14 = arg_23_2(arg_23_0, arg_23_1)

		if not var_23_13 then
			var_0_26(arg_23_1)
		elseif var_23_14 then
			var_0_59(arg_23_1)
		end
	end

	var_0_51(arg_23_1, "FORMATE")
	var_0_51(arg_23_1, "FORMING")
end

local function var_0_62(arg_24_0)
	local var_24_0 = Managers.state.debug:drawer({
		mode = "retained",
		name = "patrol_retained"
	})
	local var_24_1 = Managers.state.debug_text
	local var_24_2 = arg_24_0.nav_data
	local var_24_3 = var_24_2.node_list

	for iter_24_0 = 1, #var_24_3 do
		local var_24_4 = var_24_3[iter_24_0]:unbox()

		var_24_0:sphere(var_24_4, 0.1, Colors.get("yellow"))
		var_24_1:output_world_text(iter_24_0, 0.3, var_24_4 + Vector3(0, 0, 0.3), nil, "patrol_world_text", Vector3(255, 255, 0))

		local var_24_5 = var_24_2.node_list[iter_24_0 + 1]

		if var_24_5 then
			local var_24_6 = var_24_5:unbox()

			var_24_0:line(var_24_4, var_24_6, Colors.get("yellow"))
		end
	end

	local var_24_7 = arg_24_0.anchors

	for iter_24_1 = 1, #var_24_7 do
		local var_24_8 = var_24_7[iter_24_1]
		local var_24_9 = var_24_8.point:unbox()
		local var_24_10 = Vector3(0, 0, 0.2 + iter_24_1 * 0.04)

		var_24_0:sphere(var_24_9, 0.08, Colors.get("pink"))
		var_24_0:line(var_24_9, var_24_9 + var_24_10, Colors.get("pink"))
		var_24_0:vector(var_24_9 + var_24_10, var_24_8.wanted_direction:unbox() * 0.2, Colors.get("pink"))
	end
end

function var_0_31(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_1.nav_data.node_list
	local var_25_1 = arg_25_1.anchors
	local var_25_2 = #var_25_1
	local var_25_3 = var_25_0[1]:unbox()
	local var_25_4 = var_25_0[2]:unbox()
	local var_25_5 = Vector3.normalize(var_25_4 - var_25_3)

	for iter_25_0 = 1, var_25_2 do
		local var_25_6 = var_25_1[iter_25_0]

		var_25_6.point:store(var_25_3)
		var_25_6.wanted_direction:store(var_25_5)
		var_25_6.current_direction:store(var_25_5)
	end

	return true, false
end

function var_0_30(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = arg_26_1.nav_data.node_list
	local var_26_1 = arg_26_1.anchors
	local var_26_2 = #var_26_1
	local var_26_3 = arg_26_2 or 2
	local var_26_4 = math.max(var_26_3 - 1, 2)
	local var_26_5 = arg_26_1.formation_settings.offsets.ANCHOR_OFFSET
	local var_26_6 = (var_26_2 - 1) * var_26_5.x
	local var_26_7 = MainPathUtils.ray_along_node_list(arg_26_0, var_26_0, var_26_4, -1, var_26_6)
	local var_26_8
	local var_26_9

	if var_26_7 == var_26_6 then
		var_26_8 = var_26_5.x

		local var_26_10 = -1
	else
		local var_26_11 = MainPathUtils.ray_along_node_list(arg_26_0, var_26_0, var_26_4, 1, var_26_6)

		if var_26_11 <= var_26_7 then
			var_26_8 = var_26_7 / var_26_6 * var_26_5.x

			local var_26_12 = -1
		else
			var_26_8 = var_26_11 / var_26_6 * var_26_5.x

			local var_26_13 = 1
		end
	end

	local var_26_14 = 1
	local var_26_15 = FrameTable.alloc_table()

	MainPathUtils.find_equidistant_points_in_node_list(var_26_0, var_26_4, var_26_14, var_26_8, var_26_2, var_26_15)

	if var_26_2 > #var_26_15 then
		return false, false
	else
		table.reverse(var_26_15)

		for iter_26_0 = 1, var_26_2 do
			local var_26_16 = var_26_15[iter_26_0]
			local var_26_17 = var_26_16[1]
			local var_26_18 = var_26_16[2]
			local var_26_19 = var_26_1[iter_26_0]

			var_26_19.point:store(var_26_17)
			var_26_19.wanted_direction:store(var_26_18)
			var_26_19.current_direction:store(var_26_18)
		end

		return true, true
	end
end

local var_0_63 = 1
local var_0_64 = 0.25
local var_0_65 = PatrolFormationSettings.default_settings.speeds.SPLINE_SPEED
local var_0_66 = var_0_65 + 1.5
local var_0_67 = var_0_65 / 2
local var_0_68 = (var_0_65 * 0.5)^2

local function var_0_69(arg_27_0, arg_27_1)
	local var_27_0 = arg_27_0.spline
	local var_27_1 = arg_27_1.spline
	local var_27_2 = arg_27_0.spline:movement()
	local var_27_3 = arg_27_1.spline:movement()
	local var_27_4 = var_27_2:current_spline_curve_distance()
	local var_27_5 = var_27_3:current_spline_curve_distance()

	return (math.abs(var_27_4 - var_27_5))
end

function var_0_34(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	local var_28_0 = arg_28_1.indexed_members
	local var_28_1 = arg_28_1.num_indexed_members
	local var_28_2 = arg_28_1.anchors

	for iter_28_0 = 1, var_28_1 do
		repeat
			local var_28_3 = var_28_0[iter_28_0]
			local var_28_4 = var_0_1[var_28_3]
			local var_28_5 = var_0_0[var_28_3]
			local var_28_6 = var_28_4.navigation_extension
			local var_28_7 = ScriptUnit.extension(var_28_3, "ai_group_system")
			local var_28_8 = var_28_7.anchor
			local var_28_9 = var_28_7.group_column
			local var_28_10 = var_28_8.positions[var_28_9]:unbox()
			local var_28_11 = var_0_2(var_28_5, var_28_10)

			if var_28_11 > var_0_63 then
				local var_28_12 = arg_28_1.formation_settings.speeds.FAST_WALK_SPEED

				var_28_6:set_max_speed(var_28_12)
			elseif var_28_11 > var_0_64 then
				local var_28_13 = arg_28_1.formation_settings.speeds.MEDIUM_WALK_SPEED

				var_28_6:set_max_speed(var_28_13)
			else
				local var_28_14 = arg_28_1.formation_settings.speeds.WALK_SPEED

				var_28_6:set_max_speed(var_28_14)
			end

			if var_28_11 > var_0_68 then
				var_28_8.unit_is_lagging_behind = true
			end

			if var_28_8.spline:movement():speed() == 0 and var_28_6:has_reached_destination() then
				var_28_4.goal_destination = nil
			elseif not var_28_4.goal_destination then
				var_28_4.goal_destination = var_28_4.stored_goal_destination
			end

			local var_28_15, var_28_16 = var_0_3(arg_28_0, var_28_10, 1, 1)

			if var_28_15 then
				var_28_6:move_to(var_28_10)
			end
		until true
	end

	local var_28_17 = #var_28_2
	local var_28_18 = arg_28_1.nav_data.node_direction

	if arg_28_1.state == "patrolling" then
		for iter_28_1 = 1, var_28_17 do
			local var_28_19 = var_28_2[iter_28_1]
			local var_28_20 = var_28_19.spline:movement():current_spline_index()
			local var_28_21 = var_28_19.point:unbox()
			local var_28_22 = var_28_2[iter_28_1 + 1]
			local var_28_23 = var_28_19.spline
			local var_28_24 = false

			if var_28_19.unit_is_lagging_behind then
				var_28_24 = true
				var_28_19.unit_is_lagging_behind = false
			end

			if var_28_22 then
				local var_28_25 = var_28_22.spline:movement():current_spline_index()
				local var_28_26 = var_28_18 == "forward"

				if var_28_26 and var_28_25 <= var_28_20 or not var_28_26 and var_28_20 <= var_28_25 then
					local var_28_27 = var_0_69(var_28_19, var_28_22)

					if var_28_27 > var_0_66 or var_28_19.behind_slow_mode and var_28_27 > var_0_65 then
						var_28_24 = true
						var_28_19.behind_slow_mode = true
					else
						var_28_19.behind_slow_mode = false
					end
				end
			end

			local var_28_28 = var_28_2[iter_28_1 - 1]

			if var_28_28 and not var_28_24 then
				local var_28_29 = var_0_69(var_28_19, var_28_28)

				if var_28_29 < var_0_67 or var_28_19.ahead_slow_mode and var_28_29 < var_0_65 then
					var_28_24 = true
					var_28_19.ahead_slow_mode = true
				else
					var_28_19.ahead_slow_mode = false
				end
			end

			if var_28_24 then
				var_0_52(var_28_23, 0, arg_28_1)
			else
				var_0_52(var_28_23, arg_28_1.formation_settings.speeds.SPLINE_SPEED, arg_28_1)
			end
		end
	end
end

local var_0_70 = 0

function var_0_33(arg_29_0, arg_29_1)
	var_0_70 = var_0_70 + arg_29_1

	local var_29_0 = true

	if var_0_70 < var_0_13 then
		local var_29_1 = arg_29_0.indexed_members
		local var_29_2 = arg_29_0.num_indexed_members

		for iter_29_0 = 1, var_29_2 do
			local var_29_3 = var_29_1[iter_29_0]
			local var_29_4 = var_0_1[var_29_3]

			var_29_0 = var_29_4.navigation_extension:has_reached_destination() and not var_29_4.climb_state

			if not var_29_0 then
				break
			end
		end
	end

	if not arg_29_0.first_formation_done or var_0_70 >= var_0_14 and var_29_0 then
		var_0_36(arg_29_0)

		arg_29_0.first_formation_done = true
	end
end

function var_0_36(arg_30_0)
	var_0_53(arg_30_0, "patrolling")

	var_0_70 = 0

	local var_30_0 = arg_30_0.formation_settings.speeds.WALK_SPEED
	local var_30_1 = arg_30_0.indexed_members
	local var_30_2 = arg_30_0.num_indexed_members

	for iter_30_0 = 1, var_30_2 do
		local var_30_3 = var_30_1[iter_30_0]
		local var_30_4 = var_0_1[var_30_3]

		var_30_4.navigation_extension:set_max_speed(var_30_0)

		var_30_4.stored_goal_destination = var_30_4.goal_destination or var_30_4.stored_goal_destination
		var_30_4.goal_destination = var_30_4.stored_goal_destination
		var_30_4.patrolling = true
	end

	var_0_51(arg_30_0, "FORMATED")
end

function var_0_37(arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = arg_31_1.nav_data
	local var_31_1
	local var_31_2 = Vector3.length_squared
	local var_31_3 = arg_31_1.anchors[1].is_circular_spline
	local var_31_4 = var_31_0.node_direction
	local var_31_5 = arg_31_1.despawn_at_end
	local var_31_6 = arg_31_1.anchors
	local var_31_7 = #var_31_6

	for iter_31_0 = 1, var_31_7 do
		repeat
			local var_31_8 = var_31_6[iter_31_0]
			local var_31_9 = arg_31_1.anchors[iter_31_0 - 1]
			local var_31_10 = var_31_8.point:unbox()
			local var_31_11 = var_31_8.spline:movement()
			local var_31_12 = var_31_11:update(arg_31_2)

			if not var_31_9 then
				var_31_1 = var_31_12
			end

			local var_31_13 = var_31_11:current_position()
			local var_31_14 = var_31_13 - var_31_10

			var_31_8.point:store(var_31_13)

			if var_31_2(var_31_14) > 0 then
				var_31_8.wanted_direction:store(var_31_14)
			end

			if var_31_12 == "end" then
				if var_31_3 then
					var_31_11:reset_to_start()

					break
				end

				if var_31_5 then
					local var_31_15 = var_31_8.units
					local var_31_16 = Managers.state.conflict

					for iter_31_1, iter_31_2 in pairs(var_31_15) do
						local var_31_17 = var_0_1[iter_31_2]

						var_31_16:destroy_unit(iter_31_2, var_31_17, "patrol_finished")
					end
				end
			end
		until true
	end

	if (var_31_4 == "forward" and var_31_1 == "end" or var_31_4 == "reversed" and var_31_1 == "start") and not var_31_5 and not var_31_3 then
		var_0_57(arg_31_1)
		var_0_29(arg_31_0, arg_31_1, arg_31_1.end_of_spline_forming_positions_function)
	end
end

function var_0_38(arg_32_0, arg_32_1)
	local var_32_0 = arg_32_1.formation_settings.offsets.ANCHOR_OFFSET
	local var_32_1 = 0.6
	local var_32_2 = 1
	local var_32_3 = 1.2
	local var_32_4 = 1
	local var_32_5 = 1
	local var_32_6 = 1
	local var_32_7 = arg_32_1.anchors
	local var_32_8 = #var_32_7
	local var_32_9 = arg_32_1.nav_data.node_direction
	local var_32_10 = arg_32_1.jump_points

	for iter_32_0 = 1, var_32_8 do
		local var_32_11 = var_32_7[iter_32_0]
		local var_32_12 = var_32_11.spline:movement()
		local var_32_13 = var_32_12:current_spline_index()
		local var_32_14 = var_32_12:current_subdivision_index()
		local var_32_15 = var_32_10[var_32_13]
		local var_32_16 = var_32_15 and var_32_15[var_32_9]

		if var_32_16 and var_32_16.start_subdivision_index == var_32_14 then
			local var_32_17 = var_32_16.next_subdivsion_index
			local var_32_18 = var_32_16.next_t

			var_32_12:set_spline_index(var_32_13, var_32_17, var_32_18)
		else
			local var_32_19 = var_32_11.point:unbox()
			local var_32_20 = var_32_11.current_direction:unbox()
			local var_32_21 = Vector3(var_32_20.y, -var_32_20.x, 0)
			local var_32_22 = #var_32_11.positions
			local var_32_23 = var_32_0.y * math.max(var_32_22 - 1, 1)
			local var_32_24 = var_32_11.wanted_offset[1]
			local var_32_25 = var_32_19 - var_32_24 * var_32_21
			local var_32_26 = var_32_11.wanted_offset[2]
			local var_32_27 = var_32_19 + var_32_26 * var_32_21
			local var_32_28 = var_0_56(arg_32_0, var_32_25, var_32_19, var_32_1, var_32_2, var_32_3, var_32_4, var_32_5, var_32_6, var_32_20)
			local var_32_29 = var_0_56(arg_32_0, var_32_27, var_32_19, var_32_1, var_32_2, var_32_3, var_32_4, var_32_5, var_32_6, var_32_20)
			local var_32_30 = math.sqrt((var_32_28.x - var_32_19.x)^2 + (var_32_28.y - var_32_19.y)^2)
			local var_32_31 = math.sqrt((var_32_29.x - var_32_19.x)^2 + (var_32_29.y - var_32_19.y)^2)
			local var_32_32 = var_32_30 + var_32_31

			if var_32_32 > 0 then
				local var_32_33 = var_32_30 / var_32_32
				local var_32_34 = var_32_31 / var_32_32
				local var_32_35 = var_32_33 * var_32_23 * 2
				local var_32_36 = var_32_34 * var_32_23 * 2

				var_32_11.wanted_offset[1] = var_32_35
				var_32_11.wanted_offset[2] = var_32_36
			else
				var_32_11.wanted_offset[1] = var_32_23
				var_32_11.wanted_offset[2] = var_32_23
			end

			if var_32_22 == 1 then
				local var_32_37 = var_32_19 + (var_32_24 - var_32_26) / 2 * var_32_21
				local var_32_38 = var_0_56(arg_32_0, var_32_37, var_32_19, var_32_1, var_32_2, var_32_3, var_32_4, var_32_5, var_32_6, var_32_20)

				var_32_11.positions[1]:store(var_32_38)
			else
				for iter_32_1 = 1, var_32_22 do
					if iter_32_1 == 1 then
						var_32_11.positions[iter_32_1]:store(var_32_28)
					elseif iter_32_1 == var_32_22 then
						var_32_11.positions[iter_32_1]:store(var_32_29)
					else
						local var_32_39 = var_32_19 - (var_32_24 - var_32_23 * 2 * (iter_32_1 - 1) / (var_32_22 - 1)) * var_32_21
						local var_32_40 = var_0_56(arg_32_0, var_32_39, var_32_19, var_32_1, var_32_2, var_32_3, var_32_4, var_32_5, var_32_6, var_32_20)

						var_32_11.positions[iter_32_1]:store(var_32_40)
					end
				end
			end
		end
	end
end

function var_0_39(arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = arg_33_1.nav_data
	local var_33_1 = arg_33_1.anchors
	local var_33_2 = #var_33_1

	for iter_33_0 = 1, var_33_2 do
		local var_33_3 = var_33_1[iter_33_0]
		local var_33_4 = var_33_3.wanted_direction:unbox()
		local var_33_5 = math.atan2(var_33_4.y, var_33_4.x)
		local var_33_6
		local var_33_7 = arg_33_1.anchors[iter_33_0 - 1]

		if var_33_7 then
			local var_33_8 = var_33_7.current_direction:unbox()

			var_33_6 = math.atan2(var_33_8.y, var_33_8.x)
		else
			var_33_6 = var_33_5
		end

		local var_33_9 = math.abs(var_33_5) + math.abs(var_33_6)
		local var_33_10 = var_33_5 * var_33_6
		local var_33_11 = (var_33_5 + var_33_6) / 2

		if var_33_9 > math.pi and var_33_10 < 0 then
			if var_33_11 < 0 then
				var_33_11 = var_33_11 + math.pi
			else
				var_33_11 = var_33_11 - math.pi
			end
		end

		local var_33_12 = var_33_3.current_direction
		local var_33_13 = var_33_12:unbox()
		local var_33_14 = math.atan2(var_33_13.y, var_33_13.x)
		local var_33_15 = var_33_11 - var_33_14

		if math.abs(var_33_15) > 0.0001 then
			local var_33_16 = var_0_7 * arg_33_2

			if var_33_15 > math.pi then
				var_33_15 = var_33_15 - math.pi * 2
			elseif var_33_15 < -math.pi then
				var_33_15 = var_33_15 + math.pi * 2
			end

			if var_33_15 < 0 then
				var_33_16 = -var_33_16
			end

			local var_33_17 = var_33_14 + var_33_16

			if math.abs(var_33_16) >= math.abs(var_33_15) then
				var_33_17 = var_33_11
			end

			var_33_13.x = math.cos(var_33_17)
			var_33_13.y = math.sin(var_33_17)
		end

		var_33_12:store(var_33_13)

		local var_33_18 = var_33_3.units

		for iter_33_1, iter_33_2 in pairs(var_33_18) do
			var_0_1[iter_33_2].anchor_direction = var_33_12
		end
	end
end

function var_0_40(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	local var_34_0 = arg_34_0.target_units
	local var_34_1 = arg_34_0.indexed_members
	local var_34_2 = arg_34_0.num_indexed_members
	local var_34_3 = arg_34_0.use_controlled_advance
	local var_34_4 = false
	local var_34_5 = arg_34_0.side
	local var_34_6 = var_34_5.enemy_units_lookup
	local var_34_7 = var_34_5.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS

	for iter_34_0 = 1, var_34_2 do
		local var_34_8 = var_34_1[iter_34_0]
		local var_34_9 = var_0_1[var_34_8]
		local var_34_10 = var_34_9.target_unit or var_34_9.previous_attacker

		if var_34_3 and var_34_9.climb_state then
			var_34_4 = true
		end

		local var_34_11 = var_0_1[var_34_10]
		local var_34_12 = var_34_11 and var_34_11.is_player
		local var_34_13

		if var_34_12 then
			var_34_13 = var_34_7[var_34_10]
		else
			var_34_13 = var_34_6[var_34_10] and HEALTH_ALIVE[var_34_10]
		end

		if var_34_13 then
			var_34_0[var_34_10] = true
		elseif var_34_10 then
			var_34_0[var_34_10] = nil
			var_34_9.target_unit = nil
			var_34_9.previous_attacker = nil
		end
	end

	local var_34_14 = next(var_34_0) ~= nil

	if arg_34_0.has_targets and not var_34_14 then
		var_0_49(arg_34_0)
		var_0_61(arg_34_1, arg_34_0)
	end

	arg_34_0.someone_is_climbing = var_34_4
	arg_34_0.has_targets = var_34_14
end

function var_0_42(arg_35_0, arg_35_1)
	if arg_35_0.has_targets then
		var_0_48(arg_35_0)

		local var_35_0 = arg_35_0.group_type == "roaming_patrol"

		if arg_35_0.use_controlled_advance and not var_35_0 and not arg_35_0.someone_is_climbing then
			var_0_45(arg_35_0, arg_35_1)
		else
			var_0_50(arg_35_0, arg_35_1)
		end
	end
end

function var_0_41(arg_36_0)
	local var_36_0 = arg_36_0.indexed_members
	local var_36_1 = arg_36_0.num_indexed_members

	for iter_36_0 = 1, var_36_1 do
		local var_36_2 = var_36_0[iter_36_0]
		local var_36_3 = var_0_1[var_36_2]

		if var_36_3.is_opening_door then
			local var_36_4 = var_36_3.smash_door.target_unit

			var_0_43(arg_36_0, var_36_4)

			return true
		end
	end
end

function var_0_43(arg_37_0, arg_37_1)
	var_0_53(arg_37_0, "opening_door")

	arg_37_0.door_unit = arg_37_1

	local var_37_0 = arg_37_0.indexed_members
	local var_37_1 = arg_37_0.num_indexed_members

	for iter_37_0 = 1, var_37_1 do
		local var_37_2 = var_37_0[iter_37_0]
		local var_37_3 = var_0_1[var_37_2]

		var_37_3.goal_destination = nil

		var_37_3.navigation_extension:reset_destination()
	end

	local var_37_4 = arg_37_0.anchors
	local var_37_5 = #var_37_4

	for iter_37_1 = 1, var_37_5 do
		local var_37_6 = var_37_4[iter_37_1].spline
		local var_37_7 = arg_37_0.formation_settings.speeds.SLOW_SPLINE_SPEED

		var_0_52(var_37_6, var_37_7, arg_37_0)
	end
end

function var_0_44(arg_38_0)
	if not ScriptUnit.extension(arg_38_0.door_unit, "door_system"):is_opening() then
		arg_38_0.door_unit = nil

		local var_38_0 = arg_38_0.indexed_members
		local var_38_1 = arg_38_0.num_indexed_members

		for iter_38_0 = 1, var_38_1 do
			local var_38_2 = var_38_0[iter_38_0]
			local var_38_3 = var_0_1[var_38_2]

			var_38_3.goal_destination = var_38_3.stored_goal_destination
		end

		local var_38_4 = arg_38_0.anchors
		local var_38_5 = #var_38_4

		for iter_38_1 = 1, var_38_5 do
			local var_38_6 = var_38_4[iter_38_1].spline
			local var_38_7 = arg_38_0.formation_settings.speeds.SPLINE_SPEED

			var_0_52(var_38_6, var_38_7, arg_38_0)
		end

		var_0_53(arg_38_0, "patrolling")
	end
end

function var_0_45(arg_39_0, arg_39_1)
	arg_39_0.attack_latest_t = arg_39_1 + var_0_9

	local var_39_0 = arg_39_0.indexed_members
	local var_39_1 = arg_39_0.num_indexed_members

	for iter_39_0 = 1, var_39_1 do
		local var_39_2 = var_39_0[iter_39_0]
		local var_39_3 = var_0_1[var_39_2]

		var_39_3.navigation_extension:set_max_speed(var_0_8)
		AiUtils.enter_combat(var_39_2, var_39_3)
	end

	var_0_53(arg_39_0, "controlled_advance")
	var_0_51(arg_39_0, "PLAYER_SPOTTED")
end

local function var_0_71(arg_40_0)
	local var_40_0 = arg_40_0.target_units
	local var_40_1 = 0

	for iter_40_0, iter_40_1 in pairs(var_40_0) do
		var_40_1 = var_40_1 + 1
	end

	local var_40_2 = arg_40_0.anchors
	local var_40_3 = #var_40_2
	local var_40_4 = math.max(1, var_40_3 / var_40_1)

	for iter_40_2 = 1, var_40_3 do
		local var_40_5 = var_40_2[iter_40_2]
		local var_40_6 = math.ceil(iter_40_2 / var_40_4)
		local var_40_7 = 1
		local var_40_8

		for iter_40_3, iter_40_4 in pairs(var_40_0) do
			if var_40_6 <= var_40_7 then
				var_40_8 = iter_40_3

				break
			end

			var_40_7 = var_40_7 + 1
		end

		fassert(var_40_8, "No target from aquire_targets")

		var_40_5.target_unit = var_40_8
	end
end

function var_0_47(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	local var_41_0 = false

	if arg_41_2 > arg_41_1.controlled_advance_distance_check_t then
		arg_41_1.controlled_advance_distance_check_t = arg_41_2 + 0.5

		local var_41_1 = arg_41_1.indexed_members
		local var_41_2 = arg_41_1.num_indexed_members

		for iter_41_0 = 1, var_41_2 do
			local var_41_3 = var_41_1[iter_41_0]
			local var_41_4 = var_0_0[var_41_3]
			local var_41_5 = arg_41_1.target_units

			for iter_41_1, iter_41_2 in pairs(var_41_5) do
				if HEALTH_ALIVE[iter_41_1] then
					local var_41_6 = var_0_0[iter_41_1]

					if var_0_2(var_41_4, var_41_6) < var_0_10 then
						var_41_0 = true

						break
					end
				else
					var_41_5[iter_41_1] = nil
				end
			end

			if var_41_0 then
				break
			end
		end
	end

	if var_41_0 or arg_41_2 > arg_41_1.attack_latest_t then
		var_0_50(arg_41_1, arg_41_2)
	end
end

function var_0_48(arg_42_0)
	var_0_71(arg_42_0)

	local var_42_0 = Managers.state.network
	local var_42_1 = arg_42_0.indexed_members
	local var_42_2 = arg_42_0.num_indexed_members

	for iter_42_0 = 1, var_42_2 do
		local var_42_3 = var_42_1[iter_42_0]
		local var_42_4 = var_0_1[var_42_3]

		if ScriptUnit.has_extension(var_42_3, "ai_inventory_system") then
			local var_42_5 = var_42_0:unit_game_object_id(var_42_3)

			var_42_0.network_transmit:send_rpc_all("rpc_ai_inventory_wield", var_42_5, 1)
		end

		if ScriptUnit.has_extension(var_42_3, "ai_slot_system") then
			Managers.state.entity:system("ai_slot_system"):do_slot_search(var_42_3, true)
		end

		if ScriptUnit.extension(var_42_3, "ai_group_system").use_patrol_perception then
			local var_42_6 = ScriptUnit.extension(var_42_3, "ai_system")
			local var_42_7 = var_42_4.breed
			local var_42_8 = var_42_7.patrol_active_perception
			local var_42_9 = var_42_7.patrol_active_target_selection

			var_42_6:set_perception(var_42_8, var_42_9)
		end

		var_42_4.preferred_door_action = "smash"

		var_42_4.navigation_extension:allow_layer("planks", true)
		GwNavTagLayerCostTable.allow_layer(arg_42_0.nav_data.navtag_layer_cost_table, LAYER_ID_MAPPING.planks)
	end
end

function var_0_49(arg_43_0)
	local var_43_0 = arg_43_0.indexed_members
	local var_43_1 = arg_43_0.num_indexed_members
	local var_43_2 = Managers.state.network

	for iter_43_0 = 1, var_43_1 do
		local var_43_3 = var_43_0[iter_43_0]
		local var_43_4 = var_0_1[var_43_3]

		AiUtils.deactivate_unit(var_43_4)

		local var_43_5 = var_43_4.breed

		if not var_43_4.confirmed_player_sighting and (var_43_5.passive_in_patrol == nil or var_43_5.passive_in_patrol) then
			AiUtils.enter_passive(var_43_3, var_43_4)
		end

		if ScriptUnit.has_extension(var_43_3, "ai_slot_system") then
			Managers.state.entity:system("ai_slot_system"):do_slot_search(var_43_3, false)
		end

		if ScriptUnit.extension(var_43_3, "ai_group_system").use_patrol_perception then
			local var_43_6 = ScriptUnit.extension(var_43_3, "ai_system")
			local var_43_7 = var_43_5.patrol_passive_perception
			local var_43_8 = var_43_5.patrol_passive_target_selection

			var_43_6:set_perception(var_43_7, var_43_8)
		end

		if var_43_4.breed.use_navigation_path_splines then
			GwNavBot.set_use_channel(var_43_4.navigation_extension._nav_bot, false)
		end

		var_43_4.preferred_door_action = "open"

		var_43_4.navigation_extension:allow_layer("planks", false)
		GwNavTagLayerCostTable.forbid_layer(arg_43_0.nav_data.navtag_layer_cost_table, LAYER_ID_MAPPING.planks)
	end

	arg_43_0.patrol_in_combat = false
end

function var_0_50(arg_44_0, arg_44_1)
	var_0_53(arg_44_0, "in_combat")

	arg_44_0.patrol_in_combat = true

	local var_44_0 = arg_44_0.anchors
	local var_44_1 = #var_44_0

	for iter_44_0 = 1, var_44_1 do
		local var_44_2 = var_44_0[iter_44_0]
		local var_44_3 = var_44_2.target_unit

		if HEALTH_ALIVE[var_44_3] then
			local var_44_4 = var_44_2.units

			for iter_44_1, iter_44_2 in pairs(var_44_4) do
				local var_44_5 = var_0_1[iter_44_2]

				var_44_5.goal_destination = nil
				var_44_5.target_unit = var_44_3
				var_44_5.target_unit_found_time = arg_44_1

				AiUtils.activate_unit(var_44_5)

				if var_44_5.breed.use_navigation_path_splines then
					GwNavBot.set_use_channel(var_44_5.navigation_extension._nav_bot, true)
				end
			end
		end

		var_44_2.target_unit = nil
	end

	var_0_51(arg_44_0, "CHARGE")

	if arg_44_0.has_extra_breed then
		var_0_51(arg_44_0, "CHARGE_EXTRA")
	end
end

function var_0_26(arg_45_0)
	arg_45_0.patrol_path_broken = true

	local var_45_0 = arg_45_0.spline_name or ""

	print("[Patrol] Broken patrol path, spline_name", var_45_0)

	local var_45_1 = arg_45_0.indexed_members
	local var_45_2 = arg_45_0.num_indexed_members

	for iter_45_0 = 1, var_45_2 do
		local var_45_3 = var_45_1[iter_45_0]
		local var_45_4 = var_0_1[var_45_3]

		Managers.state.conflict:destroy_unit(var_45_3, var_45_4, "patrol_path_broken")
	end
end
