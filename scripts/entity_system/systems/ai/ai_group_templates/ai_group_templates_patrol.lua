-- chunkname: @scripts/entity_system/systems/ai/ai_group_templates/ai_group_templates_patrol.lua

require("scripts/settings/patrol_formation_settings")
require("scripts/helpers/navigation_utils")

local POSITION_LOOKUP = POSITION_LOOKUP
local BLACKBOARDS = BLACKBOARDS
local distance_squared = Vector3.distance_squared
local triangle_from_position = GwNavQueries.triangle_from_position
local raycast = GwNavQueries.raycast
local inside_position_from_outside_position = GwNavQueries.inside_position_from_outside_position

local function fn(...)
	-- function 1
	if not script_data.debug_patrols then
		print(...)
	end
end

local num = math.pi * 0.7
local num_2 = 2.77
local num_3 = 5
local num_4 = 25
local tbl = {
	planks = 10,
	ledges_with_fence = 10,
	doors = 10,
	jumps = 10,
	ledges = 10,
	bot_poison_wind = 15,
	fire_grenade = 15,
	bot_ratling_gun_fire = 15
}
local tbl_2 = {
	plague_wave = 15,
	troll_bile = 15,
	lamp_oil_fire = 15,
	warpfire_thrower_warpfire = 15,
	stormfiend_warpfire = 20
}
local num_5 = 20
local num_6 = 8
local num_7 = 5
local num_8 = num_7^2
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
local AIGroupTemplates = AIGroupTemplates

AIGroupTemplates = AIGroupTemplates or {}
AIGroupTemplates = AIGroupTemplates
AIGroupTemplates.spline_patrol = {
	in_patrol = true,
	pre_unit_init = function (arg_2_0, arg_2_1)
		-- function 2
		BLACKBOARDS[arg_2_0].ignore_interest_points = true
	end,
	init = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		-- function 3
		var_0_20(arg_3_1, arg_3_2, arg_3_0, arg_3_3)
		var_0_29(arg_3_1, arg_3_2, nil)
	end,
	destroy = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
		-- function 4
		local nav_data = arg_4_2.nav_data

		GwNavTagLayerCostTable.destroy(nav_data.navtag_layer_cost_table)
		GwNavCostMap.destroy_tag_cost_table(nav_data.nav_cost_map_cost_table)
		GwNavTraverseLogic.destroy(nav_data.traverse_logic)
	end,
	update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
		-- function 5
		var_0_22(arg_5_2)
		var_0_40(arg_5_2, arg_5_1, arg_5_3, arg_5_4)

		if arg_5_2.num_indexed_members == 0 or not arg_5_2.patrol_path_broken then
			return
		end

		local state = arg_5_2.state

		if state == "find_path_entry" then
			-- Nothing
		elseif state == "forming" then
			var_0_34(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
			var_0_33(arg_5_2, arg_5_4)
			var_0_42(arg_5_2, arg_5_3)
		elseif state == "patrolling" then
			if not var_0_41(arg_5_2) then
				return
			end

			var_0_37(arg_5_1, arg_5_2, arg_5_4)
			var_0_39(arg_5_1, arg_5_2, arg_5_4)
			var_0_38(arg_5_1, arg_5_2)
			var_0_34(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
			var_0_19(arg_5_2, arg_5_3)
			var_0_42(arg_5_2, arg_5_3)
		elseif state == "opening_door" then
			var_0_44(arg_5_2)
		elseif state == "controlled_advance" then
			var_0_19(arg_5_2, arg_5_3)
			var_0_47(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
		elseif state == "in_combat" then
			-- Nothing
		end
	end,
	setup_group = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		-- function 6
		arg_6_2.target_units = {}
	end,
	BT_debug = function (self)
		-- function 7
		local tbl = {
			"GROUP_SYSTEM:",
			(tostring(self.template))
		}
		local str = "state:"
		local state = self.state

		state = state or ""
		tbl[3] = str .. state

		local str_2 = "previous_state:"
		local previous_state = self.previous_state

		previous_state = previous_state or ""
		tbl[4] = str_2 .. previous_state

		local str_3 = "num members: "
		local members_n = self.members_n

		members_n = members_n or 1
		tbl[5] = str_3 .. members_n

		return tbl
	end
}

local function fn_2(self, arg_8_1)
	-- function 8
	var_0_18(self)

	local system = Managers.state.entity:system("audio_system")
	local var_8_1 = self.formation_settings.sounds[arg_8_1]

	system:play_audio_unit_event(var_8_1, self.wwise_source_unit)
end

function var_0_18(self)
	-- function 9
	local ceil = math.ceil(self.num_indexed_members * 0.5)

	self.wwise_source_unit = self.indexed_members[ceil]
end

function var_0_19(self, arg_10_1)
	-- function 10
	local wwise_source_unit = self.wwise_source_unit

	if not HEALTH_ALIVE[wwise_source_unit] then
		var_0_18(self)

		wwise_source_unit = self.wwise_source_unit
	end

	local var_10_1 = BLACKBOARDS[wwise_source_unit]

	if arg_10_1 > self.patrol_sound_at_t then
		local system = Managers.state.entity:system("audio_system")
		local sounds = self.formation_settings.sounds
		local FOLEY = sounds.FOLEY

		system:play_audio_unit_event(FOLEY, wwise_source_unit)

		if not self.has_extra_breed then
			local FOLEY_EXTRA = sounds.FOLEY_EXTRA

			system:play_audio_unit_event(FOLEY_EXTRA, wwise_source_unit)
		end

		local VOICE = sounds.VOICE

		system:play_audio_unit_event(VOICE, wwise_source_unit)

		self.patrol_sound_at_t = arg_10_1 + 0.5
	end
end

local function fn_3(self, arg_11_1, arg_11_2)
	-- function 11
	local flag

	flag = arg_11_2.nav_data.node_direction ~= "reversed" or not -1 or 1

	local num = arg_11_1 * flag

	self:movement():set_speed(num)
end

local function fn_4(self, arg_12_1)
	-- function 12
	fn("[Patrol] Entered state:", arg_12_1)

	self.previous_state = self.state
	self.state = arg_12_1
end

local tbl_3 = {}

function var_0_22(self)
	-- function 13
	local flag = false
	local var_13_1
	local alive = Unit.alive
	local indexed_members = self.indexed_members
	local num_indexed_members = self.num_indexed_members

	for i = num_indexed_members, 1, -1 do
		local var_13_5 = indexed_members[i]

		if not HEALTH_ALIVE[var_13_5] then
			table.remove(indexed_members, i)

			num_indexed_members = num_indexed_members - 1
			tbl_3[var_13_5] = true
			flag = true

			if var_13_1 or not alive(var_13_5) then
				local previous_attacker = BLACKBOARDS[var_13_5].previous_attacker

				if not HEALTH_ALIVE[previous_attacker] then
					var_13_1 = previous_attacker
				end
			end
		end
	end

	self.num_indexed_members = num_indexed_members

	if not flag then
		local anchors = self.anchors

		for j = #anchors, 1, -1 do
			local units = anchors[j].units
			local flag_2 = true

			for k, v in pairs(units) do
				if not tbl_3[v] then
					units[k] = nil
				else
					flag_2 = false

					if not var_13_1 then
						BLACKBOARDS[v].previous_attacker = var_13_1
					end
				end
			end

			if not flag_2 then
				table.remove(anchors, j)
			end
		end

		table.clear(tbl_3)
	end
end

local function fn_5(self)
	-- function 14
	local var_14_0 = Vector3(0, 0, 0)
	local indexed_members = self.indexed_members
	local num_indexed_members = self.num_indexed_members

	for i = 1, num_indexed_members do
		local var_14_3 = indexed_members[i]

		var_14_0 = var_14_0 + POSITION_LOOKUP[var_14_3]
	end

	return var_14_0 / num_indexed_members
end

local function fn_6(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8, arg_15_9)
	-- function 15
	local var_15_0
	local var_15_1, var_15_2 = triangle_from_position(arg_15_0, arg_15_2, arg_15_3, arg_15_4)

	if not var_15_1 then
		arg_15_2 = Vector3(arg_15_2.x, arg_15_2.y, var_15_2)

		local var_15_3, var_15_4 = raycast(arg_15_0, arg_15_2, arg_15_1)

		var_15_0 = var_15_4
	else
		local var_15_5
		local num = 12
		local normalize = Vector3.normalize(Vector3.flat(arg_15_9))

		for i = 0, num - 1 do
			local num_2 = arg_15_1 + normalize * (0.5 * i)
			local var_15_9, var_15_10 = triangle_from_position(arg_15_0, num_2, arg_15_3, arg_15_4)

			if not var_15_9 then
				var_15_5 = Vector3(num_2.x, num_2.y, var_15_10)

				break
			else
				local var_15_11 = inside_position_from_outside_position(arg_15_0, num_2, arg_15_5, arg_15_6, arg_15_7, arg_15_8)

				if not var_15_11 then
					var_15_5 = var_15_11

					break
				end
			end
		end

		if not var_15_5 then
			var_15_0 = var_15_5
		else
			var_15_0 = arg_15_2
		end
	end

	return var_15_0
end

local function fn_7(self)
	-- function 16
	local node_direction = self.nav_data.node_direction
	local flag

	flag = node_direction ~= "reversed" or not "forward" or "reversed"

	var_0_28(self, flag, node_direction)
end

local function fn_8(arg_17_0, arg_17_1)
	-- function 17
	local spline_name = arg_17_1.spline_name
	local current_level = LevelHelper:current_level(arg_17_0)
	local spline_points = arg_17_1.spline_points
	local var_17_3

	if not spline_points then
		local spline_points_2 = arg_17_1.spline_points

		var_17_3 = AiUtils.remove_bad_boxed_spline_points(spline_points_2, spline_name)
	else
		local spline = Level.spline(current_level, spline_name)

		var_17_3 = AiUtils.remove_bad_spline_points(spline, spline_name)
	end

	local count = #var_17_3

	if count == 0 then
		return false
	end

	local tbl = {
		forward_list = {},
		reversed_list = {}
	}

	for i = 1, count do
		local var_17_8 = var_17_3[i]

		tbl.forward_list[i] = Vector3Box(var_17_8)

		local num = count - i + 1

		tbl.reversed_list[num] = Vector3Box(var_17_8)
	end

	local var_17_10 = var_17_3[1]
	local var_17_11 = var_17_3[count]
	local flag = distance_squared(var_17_10, var_17_11) < num_8
	local anchors = arg_17_1.anchors
	local count_2 = #anchors

	for j = 1, count_2 do
		local var_17_15 = anchors[j]
		local str = spline_name .. ":" .. j

		if not spline_points then
			var_17_15.spline = SplineCurve:new(var_17_3, "Hermite", "SplineMovementHermiteInterpolatedMetered", str, 3, arg_17_1.cached_splines)
		else
			var_17_15.spline = SplineCurve:new(var_17_3, "Bezier", "SplineMovementHermiteInterpolatedMetered", str, 10)
		end

		var_17_15.is_circular_spline = flag
	end

	return tbl
end

local function fn_9(self)
	-- function 18
	local anchors = self.anchors
	local count = #anchors

	for i = 1, count do
		local var_18_2 = anchors[i]
		local unbox = var_18_2.point:unbox()
		local spline = var_18_2.spline
		local get_position_on_interpolated_spline, var_18_6, var_18_7 = NavigationUtils.get_position_on_interpolated_spline(spline, unbox)

		spline:movement():set_spline_index(get_position_on_interpolated_spline, var_18_6, var_18_7)
	end
end

local function fn_10(arg_19_0, arg_19_1)
	-- function 19
	local tbl = {}
	local spline = arg_19_1.anchors[1].spline
	local movement = spline:movement()
	local num = 2
	local num_2 = 3
	local num_3 = 1
	local num_4 = 1
	local splines = spline:splines()
	local count = #splines

	for i = 1, count do
		local var_19_9 = splines[i]
		local points = var_19_9.points
		local num_5 = (points[num]:unbox() + points[num_2]:unbox()) / 2

		if not triangle_from_position(arg_19_0, num_5, num_3, num_4) then
			local count_2 = #var_19_9.subdivisions

			tbl[i] = {
				forward = {
					next_t = 1,
					start_subdivision_index = 1,
					next_subdivsion_index = count_2
				},
				reversed = {
					next_t = 0,
					next_subdivsion_index = 1,
					start_subdivision_index = count_2
				}
			}
		end
	end

	arg_19_1.jump_points = tbl
end

function var_0_20(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	-- function 20
	fassert(arg_20_1.members_n > 0, "Group was initialized with zero members!")

	arg_20_1.nav_data = {}

	local var_20_0 = GwNavTagLayerCostTable.create()

	table.merge(tbl, NAV_TAG_VOLUME_LAYER_COST_AI)
	AiUtils.initialize_cost_table(var_20_0, tbl)

	local create_tag_cost_table = GwNavCostMap.create_tag_cost_table()

	AiUtils.initialize_nav_cost_map_cost_table(create_tag_cost_table, tbl_2)

	local var_20_2 = GwNavTraverseLogic.create(arg_20_0, create_tag_cost_table)

	GwNavTraverseLogic.set_navtag_layer_cost_table(var_20_2, var_20_0)

	arg_20_1.nav_data.navtag_layer_cost_table = var_20_0
	arg_20_1.nav_data.nav_cost_map_cost_table = create_tag_cost_table
	arg_20_1.nav_data.traverse_logic = var_20_2

	local formation_settings = arg_20_1.formation_settings
	local ANCHOR_OFFSET = formation_settings.offsets.ANCHOR_OFFSET
	local tbl_3 = {}
	local count = #arg_20_1.formation

	for i = 1, count do
		tbl_3[i] = {
			point = Vector3Box(),
			wanted_direction = Vector3Box(),
			current_direction = Vector3Box(),
			units = {}
		}

		local var_20_7 = arg_20_1.formation[i]
		local count_2 = #var_20_7
		local tbl_4 = {}
		local zero = Vector3.zero()
		local var_20_11

		for j = 1, count_2 do
			local var_20_12 = var_20_7[j]
			local start_position = var_20_12.start_position

			tbl_4[j] = start_position
			zero = zero + start_position:unbox()
			var_20_11 = var_20_11 or var_20_12.start_direction:unbox()
		end

		local num = zero / count_2

		tbl_3[i].point:store(num)

		tbl_3[i].positions = tbl_4

		tbl_3[i].current_direction:store(var_20_11)
		tbl_3[i].wanted_direction:store(var_20_11)

		local num_2 = ANCHOR_OFFSET.y * math.max(count_2 - 1, 1)

		tbl_3[i].wanted_offset = {
			num_2,
			num_2
		}
	end

	arg_20_1.anchors = tbl_3

	local extra_breed_name = formation_settings.extra_breed_name
	local flag = false
	local num_3 = 0
	local tbl_5 = {}
	local flag_2 = arg_20_1.group_type == "spline_patrol"

	for k, v in pairs(arg_20_1.members) do
		if not HEALTH_ALIVE[k] then
			local var_20_21 = BLACKBOARDS[k]

			var_20_21.only_trust_your_own_eyes = flag_2

			local breed = var_20_21.breed

			if breed.name == extra_breed_name then
				flag = true
			end

			local navigation_extension = var_20_21.navigation_extension

			navigation_extension:set_far_pathing_allowed(false)

			if not breed.use_navigation_path_splines then
				GwNavBot.set_use_channel(navigation_extension._nav_bot, false)
			end

			local extension = ScriptUnit.extension(k, "ai_group_system")
			local group_row = extension.group_row
			local group_column = extension.group_column
			local var_20_27 = tbl_3[group_row]

			var_20_27.units[group_column] = k
			extension.anchor = var_20_27
			num_3 = num_3 + 1
			tbl_5[num_3] = k
			var_20_21.preferred_door_action = "open"

			navigation_extension:allow_layer("planks", false)
			GwNavTagLayerCostTable.forbid_layer(arg_20_1.nav_data.navtag_layer_cost_table, LAYER_ID_MAPPING.planks)

			if not extension.use_patrol_perception then
				local extension_2 = ScriptUnit.extension(k, "ai_system")
				local breed_2 = var_20_21.breed
				local patrol_passive_perception = breed_2.patrol_passive_perception
				local patrol_passive_target_selection = breed_2.patrol_passive_target_selection

				fassert(patrol_passive_perception, "Missing patrol passive perception!")
				fassert(patrol_passive_target_selection, "Missing patrol passive target selection!")
				extension_2:set_perception(patrol_passive_perception, patrol_passive_target_selection)
			end
		end
	end

	arg_20_1.indexed_members = tbl_5
	arg_20_1.num_indexed_members = num_3
	arg_20_1.has_extra_breed = flag
	arg_20_1.attack_latest_t = 0
	arg_20_1.controlled_advance_distance_check_t = 0
	arg_20_1.door_unit = nil
	arg_20_1.use_controlled_advance = formation_settings.use_controlled_advance
	arg_20_1.patrol_sound_at_t = arg_20_3

	local var_20_32

	if not flag_2 then
		var_20_32 = var_0_31

		if not var_20_32 then
			-- Nothing
		end
	end

	var_20_32 = var_0_30

	::label_20_0::

	arg_20_1.end_of_spline_forming_positions_function = var_20_32

	local var_20_33 = fn_8(arg_20_2, arg_20_1)

	arg_20_1.nav_data.node_data = var_20_33

	var_0_28(arg_20_1, "forward")
	fn_9(arg_20_1)
	fn_10(arg_20_0, arg_20_1)
end

local function fn_11(arg_21_0, arg_21_1)
	-- function 21
	fn_4(arg_21_1, "find_path_entry")

	local node_list = arg_21_1.nav_data.node_list
	local var_21_1 = fn_5(arg_21_1)
	local closest_node_in_node_list = MainPathUtils.closest_node_in_node_list(node_list, var_21_1)

	if not var_0_30(arg_21_0, arg_21_1, closest_node_in_node_list) then
		fn_9(arg_21_1)
	end

	var_0_36(arg_21_1)
end

function var_0_28(self, arg_22_1, arg_22_2)
	-- function 22
	local nav_data = self.nav_data
	local anchors = self.anchors
	local count = #anchors

	if arg_22_1 == "forward" then
		nav_data.node_direction = "forward"
		nav_data.node_list = nav_data.node_data.forward_list

		if not arg_22_2 then
			for i = 1, count do
				local spline = anchors[i].spline

				spline:movement():reset_to_start()
				fn_3(spline, 0, self)
			end
		end
	else
		nav_data.node_direction = "reversed"
		nav_data.node_list = nav_data.node_data.reversed_list

		if not arg_22_2 then
			for j = 1, count do
				local spline_2 = anchors[j].spline

				spline_2:movement():reset_to_end()
				fn_3(spline_2, 0, self)
			end
		end
	end
end

function var_0_29(arg_23_0, arg_23_1, arg_23_2)
	-- function 23
	fn_4(arg_23_1, "forming")

	local nav_data = arg_23_1.nav_data
	local count = #nav_data.node_list
	local unbox = nav_data.node_list[count]:unbox()
	local num = 1
	local num_2 = 1
	local var_23_5, var_23_6 = triangle_from_position(arg_23_0, unbox, num, num_2)

	if not var_23_5 then
		return
	end

	unbox.z = var_23_6

	local indexed_members = arg_23_1.indexed_members
	local num_indexed_members = arg_23_1.num_indexed_members

	for i = 1, num_indexed_members do
		local var_23_9 = indexed_members[i]
		local var_23_10 = BLACKBOARDS[var_23_9]
		local navigation_extension = var_23_10.navigation_extension
		local WALK_SPEED = arg_23_1.formation_settings.speeds.WALK_SPEED

		navigation_extension:set_max_speed(WALK_SPEED)

		var_23_10.goal_destination = nil
		var_23_10.stored_goal_destination = Vector3Box(unbox)
	end

	if not arg_23_2 then
		local var_23_13, var_23_14 = arg_23_2(arg_23_0, arg_23_1)

		if not var_23_13 then
			var_0_26(arg_23_1)
		elseif not var_23_14 then
			fn_9(arg_23_1)
		end
	end

	fn_2(arg_23_1, "FORMATE")
	fn_2(arg_23_1, "FORMING")
end

local function fn_12(self)
	-- function 24
	local drawer = Managers.state.debug:drawer({
		mode = "retained",
		name = "patrol_retained"
	})
	local debug_text = Managers.state.debug_text
	local nav_data = self.nav_data
	local node_list = nav_data.node_list

	for i = 1, #node_list do
		local unbox = node_list[i]:unbox()

		drawer:sphere(unbox, 0.1, Colors.get("yellow"))
		debug_text:output_world_text(i, 0.3, unbox + Vector3(0, 0, 0.3), nil, "patrol_world_text", Vector3(255, 255, 0))

		local var_24_5 = nav_data.node_list[i + 1]

		if not var_24_5 then
			local unbox_2 = var_24_5:unbox()

			drawer:line(unbox, unbox_2, Colors.get("yellow"))
		end
	end

	local anchors = self.anchors

	for j = 1, #anchors do
		local var_24_8 = anchors[j]
		local unbox_3 = var_24_8.point:unbox()
		local var_24_10 = Vector3(0, 0, 0.2 + j * 0.04)

		drawer:sphere(unbox_3, 0.08, Colors.get("pink"))
		drawer:line(unbox_3, unbox_3 + var_24_10, Colors.get("pink"))
		drawer:vector(unbox_3 + var_24_10, var_24_8.wanted_direction:unbox() * 0.2, Colors.get("pink"))
	end
end

function var_0_31(arg_25_0, arg_25_1)
	-- function 25
	local node_list = arg_25_1.nav_data.node_list
	local anchors = arg_25_1.anchors
	local count = #anchors
	local unbox = node_list[1]:unbox()
	local unbox_2 = node_list[2]:unbox()
	local normalize = Vector3.normalize(unbox_2 - unbox)

	for i = 1, count do
		local var_25_6 = anchors[i]

		var_25_6.point:store(unbox)
		var_25_6.wanted_direction:store(normalize)
		var_25_6.current_direction:store(normalize)
	end

	return true, false
end

function var_0_30(arg_26_0, arg_26_1, arg_26_2)
	-- function 26
	local node_list = arg_26_1.nav_data.node_list
	local anchors = arg_26_1.anchors
	local count = #anchors
	local flag = arg_26_2 or 2
	local max = math.max(flag - 1, 2)
	local ANCHOR_OFFSET = arg_26_1.formation_settings.offsets.ANCHOR_OFFSET
	local num = (count - 1) * ANCHOR_OFFSET.x
	local ray_along_node_list = MainPathUtils.ray_along_node_list(arg_26_0, node_list, max, -1, num)
	local var_26_8
	local var_26_9

	if ray_along_node_list == num then
		var_26_8 = ANCHOR_OFFSET.x

		local num_2 = -1
	else
		local ray_along_node_list_2 = MainPathUtils.ray_along_node_list(arg_26_0, node_list, max, 1, num)

		if ray_along_node_list_2 <= ray_along_node_list then
			var_26_8 = ray_along_node_list / num * ANCHOR_OFFSET.x

			local num_3 = -1
		else
			var_26_8 = ray_along_node_list_2 / num * ANCHOR_OFFSET.x

			local num_4 = 1
		end
	end

	local num_5 = 1
	local alloc_table = FrameTable.alloc_table()

	MainPathUtils.find_equidistant_points_in_node_list(node_list, max, num_5, var_26_8, count, alloc_table)

	if not (count > #alloc_table) then
		return false, false
	else
		table.reverse(alloc_table)

		for i = 1, count do
			local var_26_16 = alloc_table[i]
			local var_26_17 = var_26_16[1]
			local var_26_18 = var_26_16[2]
			local var_26_19 = anchors[i]

			var_26_19.point:store(var_26_17)
			var_26_19.wanted_direction:store(var_26_18)
			var_26_19.current_direction:store(var_26_18)
		end

		return true, true
	end
end

local num_9 = 1
local num_10 = 0.25
local SPLINE_SPEED = PatrolFormationSettings.default_settings.speeds.SPLINE_SPEED
local num_11 = SPLINE_SPEED + 1.5
local num_12 = SPLINE_SPEED / 2
local num_13 = (SPLINE_SPEED * 0.5)^2

local function fn_13(self, arg_27_1)
	-- function 27
	local spline = self.spline
	local spline_2 = arg_27_1.spline
	local movement = self.spline:movement()
	local movement_2 = arg_27_1.spline:movement()
	local current_spline_curve_distance = movement:current_spline_curve_distance()
	local current_spline_curve_distance_2 = movement_2:current_spline_curve_distance()

	return (math.abs(current_spline_curve_distance - current_spline_curve_distance_2))
end

function var_0_34(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	-- function 28
	local indexed_members = arg_28_1.indexed_members
	local num_indexed_members = arg_28_1.num_indexed_members
	local anchors = arg_28_1.anchors

	for i = 1, num_indexed_members do
		repeat
			local var_28_3 = indexed_members[i]
			local var_28_4 = BLACKBOARDS[var_28_3]
			local var_28_5 = POSITION_LOOKUP[var_28_3]
			local navigation_extension = var_28_4.navigation_extension
			local extension = ScriptUnit.extension(var_28_3, "ai_group_system")
			local anchor = extension.anchor
			local group_column = extension.group_column
			local unbox = anchor.positions[group_column]:unbox()
			local var_28_11 = distance_squared(var_28_5, unbox)

			if var_28_11 > num_9 then
				local FAST_WALK_SPEED = arg_28_1.formation_settings.speeds.FAST_WALK_SPEED

				navigation_extension:set_max_speed(FAST_WALK_SPEED)
			elseif var_28_11 > num_10 then
				local MEDIUM_WALK_SPEED = arg_28_1.formation_settings.speeds.MEDIUM_WALK_SPEED

				navigation_extension:set_max_speed(MEDIUM_WALK_SPEED)
			else
				local WALK_SPEED = arg_28_1.formation_settings.speeds.WALK_SPEED

				navigation_extension:set_max_speed(WALK_SPEED)
			end

			if var_28_11 > num_13 then
				anchor.unit_is_lagging_behind = true
			end

			if not (anchor.spline:movement():speed() == 0) and not navigation_extension:has_reached_destination() then
				var_28_4.goal_destination = nil
			elseif not var_28_4.goal_destination then
				var_28_4.goal_destination = var_28_4.stored_goal_destination
			end

			local var_28_15, var_28_16 = triangle_from_position(arg_28_0, unbox, 1, 1)

			if not var_28_15 then
				navigation_extension:move_to(unbox)
			end
		until true
	end

	local count = #anchors
	local node_direction = arg_28_1.nav_data.node_direction

	if arg_28_1.state == "patrolling" then
		for j = 1, count do
			local var_28_19 = anchors[j]
			local current_spline_index = var_28_19.spline:movement():current_spline_index()
			local unbox_2 = var_28_19.point:unbox()
			local var_28_22 = anchors[j + 1]
			local spline = var_28_19.spline
			local flag = false

			if not var_28_19.unit_is_lagging_behind then
				flag = true
				var_28_19.unit_is_lagging_behind = false
			end

			if not var_28_22 then
				local current_spline_index_2 = var_28_22.spline:movement():current_spline_index()
				local flag_2 = node_direction == "forward"

				if not (not flag_2 and current_spline_index_2 <= current_spline_index or flag_2 or not (current_spline_index <= current_spline_index_2)) then
					local var_28_27 = fn_13(var_28_19, var_28_22)

					if not ((var_28_27 > num_11 or not var_28_19.behind_slow_mode) and not (var_28_27 > SPLINE_SPEED)) then
						flag = true
						var_28_19.behind_slow_mode = true
					else
						var_28_19.behind_slow_mode = false
					end
				end
			end

			local var_28_28 = anchors[j - 1]

			if not (not var_28_28 and flag) then
				local var_28_29 = fn_13(var_28_19, var_28_28)

				if not ((var_28_29 < num_12 or not var_28_19.ahead_slow_mode) and not (var_28_29 < SPLINE_SPEED)) then
					flag = true
					var_28_19.ahead_slow_mode = true
				else
					var_28_19.ahead_slow_mode = false
				end
			end

			if not flag then
				fn_3(spline, 0, arg_28_1)
			else
				fn_3(spline, arg_28_1.formation_settings.speeds.SPLINE_SPEED, arg_28_1)
			end
		end
	end
end

local num_14 = 0

function var_0_33(self, arg_29_1)
	-- function 29
	num_14 = num_14 + arg_29_1

	local flag = true

	if num_14 < num_5 then
		local indexed_members = self.indexed_members
		local num_indexed_members = self.num_indexed_members

		for i = 1, num_indexed_members do
			local var_29_3 = indexed_members[i]
			local var_29_4 = BLACKBOARDS[var_29_3]

			flag = not var_29_4.navigation_extension:has_reached_destination() and not var_29_4.climb_state

			if not flag then
				break
			end
		end
	end

	if not self.first_formation_done and not (num_14 >= num_6) or not flag then
		var_0_36(self)

		self.first_formation_done = true
	end
end

function var_0_36(self)
	-- function 30
	fn_4(self, "patrolling")

	num_14 = 0

	local WALK_SPEED = self.formation_settings.speeds.WALK_SPEED
	local indexed_members = self.indexed_members
	local num_indexed_members = self.num_indexed_members

	for i = 1, num_indexed_members do
		local var_30_3 = indexed_members[i]
		local var_30_4 = BLACKBOARDS[var_30_3]

		var_30_4.navigation_extension:set_max_speed(WALK_SPEED)

		local goal_destination = var_30_4.goal_destination

		goal_destination = goal_destination or var_30_4.stored_goal_destination
		var_30_4.stored_goal_destination = goal_destination
		var_30_4.goal_destination = var_30_4.stored_goal_destination
		var_30_4.patrolling = true
	end

	fn_2(self, "FORMATED")
end

function var_0_37(arg_31_0, arg_31_1, arg_31_2)
	-- function 31
	local nav_data = arg_31_1.nav_data
	local var_31_1
	local length_squared = Vector3.length_squared
	local is_circular_spline = arg_31_1.anchors[1].is_circular_spline
	local node_direction = nav_data.node_direction
	local despawn_at_end = arg_31_1.despawn_at_end
	local anchors = arg_31_1.anchors
	local count = #anchors

	for i = 1, count do
		repeat
			local var_31_8 = anchors[i]
			local var_31_9 = arg_31_1.anchors[i - 1]
			local unbox = var_31_8.point:unbox()
			local movement = var_31_8.spline:movement()
			local update = movement:update(arg_31_2)

			if not var_31_9 then
				var_31_1 = update
			end

			local current_position = movement:current_position()
			local num = current_position - unbox

			var_31_8.point:store(current_position)

			if length_squared(num) > 0 then
				var_31_8.wanted_direction:store(num)
			end

			if update == "end" then
				if not is_circular_spline then
					movement:reset_to_start()

					break
				end

				if not despawn_at_end then
					local units = var_31_8.units
					local conflict = Managers.state.conflict

					for k, v in pairs(units) do
						local var_31_17 = BLACKBOARDS[v]

						conflict:destroy_unit(v, var_31_17, "patrol_finished")
					end
				end
			end
		until true
	end

	if not ((node_direction ~= "forward" or var_31_1 ~= "end" or node_direction ~= "reversed") and var_31_1 ~= "start" or despawn_at_end or is_circular_spline) then
		fn_7(arg_31_1)
		var_0_29(arg_31_0, arg_31_1, arg_31_1.end_of_spline_forming_positions_function)
	end
end

function var_0_38(arg_32_0, arg_32_1)
	-- function 32
	local ANCHOR_OFFSET = arg_32_1.formation_settings.offsets.ANCHOR_OFFSET
	local num = 0.6
	local num_2 = 1
	local num_3 = 1.2
	local num_4 = 1
	local num_5 = 1
	local num_6 = 1
	local anchors = arg_32_1.anchors
	local count = #anchors
	local node_direction = arg_32_1.nav_data.node_direction
	local jump_points = arg_32_1.jump_points

	for i = 1, count do
		local var_32_11 = anchors[i]
		local movement = var_32_11.spline:movement()
		local current_spline_index = movement:current_spline_index()
		local current_subdivision_index = movement:current_subdivision_index()
		local var_32_15 = jump_points[current_spline_index]
		local flag = not var_32_15 and var_32_15[node_direction]

		if not (not flag and flag.start_subdivision_index ~= current_subdivision_index) then
			local next_subdivsion_index = flag.next_subdivsion_index
			local next_t = flag.next_t

			movement:set_spline_index(current_spline_index, next_subdivsion_index, next_t)
		else
			local unbox = var_32_11.point:unbox()
			local unbox_2 = var_32_11.current_direction:unbox()
			local var_32_21 = Vector3(unbox_2.y, -unbox_2.x, 0)
			local count_2 = #var_32_11.positions
			local num_7 = ANCHOR_OFFSET.y * math.max(count_2 - 1, 1)
			local var_32_24 = var_32_11.wanted_offset[1]
			local num_8 = unbox - var_32_24 * var_32_21
			local var_32_26 = var_32_11.wanted_offset[2]
			local num_9 = unbox + var_32_26 * var_32_21
			local var_32_28 = fn_6(arg_32_0, num_8, unbox, num, num_2, num_3, num_4, num_5, num_6, unbox_2)
			local var_32_29 = fn_6(arg_32_0, num_9, unbox, num, num_2, num_3, num_4, num_5, num_6, unbox_2)
			local sqrt = math.sqrt((var_32_28.x - unbox.x)^2 + (var_32_28.y - unbox.y)^2)
			local sqrt_2 = math.sqrt((var_32_29.x - unbox.x)^2 + (var_32_29.y - unbox.y)^2)
			local num_10 = sqrt + sqrt_2

			if num_10 > 0 then
				local num_11 = sqrt / num_10
				local num_12 = sqrt_2 / num_10
				local num_13 = num_11 * num_7 * 2
				local num_14 = num_12 * num_7 * 2

				var_32_11.wanted_offset[1] = num_13
				var_32_11.wanted_offset[2] = num_14
			else
				var_32_11.wanted_offset[1] = num_7
				var_32_11.wanted_offset[2] = num_7
			end

			if count_2 == 1 then
				local num_15 = unbox + (var_32_24 - var_32_26) / 2 * var_32_21
				local var_32_38 = fn_6(arg_32_0, num_15, unbox, num, num_2, num_3, num_4, num_5, num_6, unbox_2)

				var_32_11.positions[1]:store(var_32_38)
			else
				for j = 1, count_2 do
					if j == 1 then
						var_32_11.positions[j]:store(var_32_28)
					elseif j == count_2 then
						var_32_11.positions[j]:store(var_32_29)
					else
						local num_16 = unbox - (var_32_24 - num_7 * 2 * (j - 1) / (count_2 - 1)) * var_32_21
						local var_32_40 = fn_6(arg_32_0, num_16, unbox, num, num_2, num_3, num_4, num_5, num_6, unbox_2)

						var_32_11.positions[j]:store(var_32_40)
					end
				end
			end
		end
	end
end

function var_0_39(arg_33_0, arg_33_1, arg_33_2)
	-- function 33
	local nav_data = arg_33_1.nav_data
	local anchors = arg_33_1.anchors
	local count = #anchors

	for i = 1, count do
		local var_33_3 = anchors[i]
		local unbox = var_33_3.wanted_direction:unbox()
		local atan2 = math.atan2(unbox.y, unbox.x)
		local var_33_6
		local var_33_7 = arg_33_1.anchors[i - 1]

		if not var_33_7 then
			local unbox_2 = var_33_7.current_direction:unbox()

			var_33_6 = math.atan2(unbox_2.y, unbox_2.x)
		else
			var_33_6 = atan2
		end

		local num_2 = math.abs(atan2) + math.abs(var_33_6)
		local num_3 = atan2 * var_33_6
		local num_4 = (atan2 + var_33_6) / 2

		if not (not (num_2 > math.pi) or not (num_3 < 0)) then
			if num_4 < 0 then
				num_4 = num_4 + math.pi
			else
				num_4 = num_4 - math.pi
			end
		end

		local current_direction = var_33_3.current_direction
		local unbox_3 = current_direction:unbox()
		local atan2_2 = math.atan2(unbox_3.y, unbox_3.x)
		local num_5 = num_4 - atan2_2

		if math.abs(num_5) > 0.0001 then
			local num_6 = num * arg_33_2

			if num_5 > math.pi then
				num_5 = num_5 - math.pi * 2
			elseif num_5 < -math.pi then
				num_5 = num_5 + math.pi * 2
			end

			if num_5 < 0 then
				num_6 = -num_6
			end

			local num_7 = atan2_2 + num_6

			if math.abs(num_6) >= math.abs(num_5) then
				num_7 = num_4
			end

			unbox_3.x = math.cos(num_7)
			unbox_3.y = math.sin(num_7)
		end

		current_direction:store(unbox_3)

		local units = var_33_3.units

		for k, v in pairs(units) do
			BLACKBOARDS[v].anchor_direction = current_direction
		end
	end
end

function var_0_40(self, arg_34_1, arg_34_2, arg_34_3)
	-- function 34
	local target_units = self.target_units
	local indexed_members = self.indexed_members
	local num_indexed_members = self.num_indexed_members
	local use_controlled_advance = self.use_controlled_advance
	local flag = false
	local side = self.side
	local enemy_units_lookup = side.enemy_units_lookup
	local VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS = side.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS

	for i = 1, num_indexed_members do
		local var_34_8 = indexed_members[i]
		local var_34_9 = BLACKBOARDS[var_34_8]
		local target_unit = var_34_9.target_unit

		target_unit = target_unit or var_34_9.previous_attacker

		if not use_controlled_advance and not var_34_9.climb_state then
			flag = true
		end

		local var_34_11 = BLACKBOARDS[target_unit]
		local flag_2 = not var_34_11 and var_34_11.is_player
		local var_34_13

		if not flag_2 then
			var_34_13 = VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[target_unit]
		else
			var_34_13 = not enemy_units_lookup[target_unit] and HEALTH_ALIVE[target_unit]
		end

		if not var_34_13 then
			target_units[target_unit] = true
		elseif not target_unit then
			target_units[target_unit] = nil
			var_34_9.target_unit = nil
			var_34_9.previous_attacker = nil
		end
	end

	local flag_3 = next(target_units) ~= nil

	if not (not self.has_targets and flag_3) then
		var_0_49(self)
		fn_11(arg_34_1, self)
	end

	self.someone_is_climbing = flag
	self.has_targets = flag_3
end

function var_0_42(self, arg_35_1)
	-- function 35
	if not self.has_targets then
		var_0_48(self)

		local flag = self.group_type == "roaming_patrol"

		if not (not self.use_controlled_advance and flag or self.someone_is_climbing) then
			var_0_45(self, arg_35_1)
		else
			var_0_50(self, arg_35_1)
		end
	end
end

function var_0_41(self)
	-- function 36
	local indexed_members = self.indexed_members
	local num_indexed_members = self.num_indexed_members

	for i = 1, num_indexed_members do
		local var_36_2 = indexed_members[i]
		local var_36_3 = BLACKBOARDS[var_36_2]

		if not var_36_3.is_opening_door then
			local target_unit = var_36_3.smash_door.target_unit

			var_0_43(self, target_unit)

			return true
		end
	end
end

function var_0_43(self, arg_37_1)
	-- function 37
	fn_4(self, "opening_door")

	self.door_unit = arg_37_1

	local indexed_members = self.indexed_members
	local num_indexed_members = self.num_indexed_members

	for i = 1, num_indexed_members do
		local var_37_2 = indexed_members[i]
		local var_37_3 = BLACKBOARDS[var_37_2]

		var_37_3.goal_destination = nil

		var_37_3.navigation_extension:reset_destination()
	end

	local anchors = self.anchors
	local count = #anchors

	for j = 1, count do
		local spline = anchors[j].spline
		local SLOW_SPLINE_SPEED = self.formation_settings.speeds.SLOW_SPLINE_SPEED

		fn_3(spline, SLOW_SPLINE_SPEED, self)
	end
end

function var_0_44(self)
	-- function 38
	if not ScriptUnit.extension(self.door_unit, "door_system"):is_opening() then
		self.door_unit = nil

		local indexed_members = self.indexed_members
		local num_indexed_members = self.num_indexed_members

		for i = 1, num_indexed_members do
			local var_38_2 = indexed_members[i]
			local var_38_3 = BLACKBOARDS[var_38_2]

			var_38_3.goal_destination = var_38_3.stored_goal_destination
		end

		local anchors = self.anchors
		local count = #anchors

		for j = 1, count do
			local spline = anchors[j].spline
			local SPLINE_SPEED = self.formation_settings.speeds.SPLINE_SPEED

			fn_3(spline, SPLINE_SPEED, self)
		end

		fn_4(self, "patrolling")
	end
end

function var_0_45(self, arg_39_1)
	-- function 39
	self.attack_latest_t = arg_39_1 + num_3

	local indexed_members = self.indexed_members
	local num_indexed_members = self.num_indexed_members

	for i = 1, num_indexed_members do
		local var_39_2 = indexed_members[i]
		local var_39_3 = BLACKBOARDS[var_39_2]

		var_39_3.navigation_extension:set_max_speed(num_2)
		AiUtils.enter_combat(var_39_2, var_39_3)
	end

	fn_4(self, "controlled_advance")
	fn_2(self, "PLAYER_SPOTTED")
end

local function fn_14(self)
	-- function 40
	local target_units = self.target_units
	local num = 0

	for k, v in pairs(target_units) do
		num = num + 1
	end

	local anchors = self.anchors
	local count = #anchors
	local max = math.max(1, count / num)

	for k_2 = 1, count do
		local var_40_5 = anchors[k_2]
		local ceil = math.ceil(k_2 / max)
		local num_2 = 1
		local var_40_8

		for k_3, v_2 in pairs(target_units) do
			if ceil <= num_2 then
				var_40_8 = k_3

				break
			end

			num_2 = num_2 + 1
		end

		fassert(var_40_8, "No target from aquire_targets")

		var_40_5.target_unit = var_40_8
	end
end

function var_0_47(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	-- function 41
	local flag = false

	if arg_41_2 > arg_41_1.controlled_advance_distance_check_t then
		arg_41_1.controlled_advance_distance_check_t = arg_41_2 + 0.5

		local indexed_members = arg_41_1.indexed_members
		local num_indexed_members = arg_41_1.num_indexed_members

		for i = 1, num_indexed_members do
			local var_41_3 = indexed_members[i]
			local var_41_4 = POSITION_LOOKUP[var_41_3]
			local target_units = arg_41_1.target_units

			for k, v in pairs(target_units) do
				if not HEALTH_ALIVE[k] then
					local var_41_6 = POSITION_LOOKUP[k]

					if distance_squared(var_41_4, var_41_6) < num_4 then
						flag = true

						break
					end
				else
					target_units[k] = nil
				end
			end

			if not flag then
				break
			end
		end
	end

	if not (flag or not (arg_41_2 > arg_41_1.attack_latest_t)) then
		var_0_50(arg_41_1, arg_41_2)
	end
end

function var_0_48(self)
	-- function 42
	fn_14(self)

	local network = Managers.state.network
	local indexed_members = self.indexed_members
	local num_indexed_members = self.num_indexed_members

	for i = 1, num_indexed_members do
		local var_42_3 = indexed_members[i]
		local var_42_4 = BLACKBOARDS[var_42_3]

		if not ScriptUnit.has_extension(var_42_3, "ai_inventory_system") then
			local unit_game_object_id = network:unit_game_object_id(var_42_3)

			network.network_transmit:send_rpc_all("rpc_ai_inventory_wield", unit_game_object_id, 1)
		end

		if not ScriptUnit.has_extension(var_42_3, "ai_slot_system") then
			Managers.state.entity:system("ai_slot_system"):do_slot_search(var_42_3, true)
		end

		if not ScriptUnit.extension(var_42_3, "ai_group_system").use_patrol_perception then
			local extension = ScriptUnit.extension(var_42_3, "ai_system")
			local breed = var_42_4.breed
			local patrol_active_perception = breed.patrol_active_perception
			local patrol_active_target_selection = breed.patrol_active_target_selection

			extension:set_perception(patrol_active_perception, patrol_active_target_selection)
		end

		var_42_4.preferred_door_action = "smash"

		var_42_4.navigation_extension:allow_layer("planks", true)
		GwNavTagLayerCostTable.allow_layer(self.nav_data.navtag_layer_cost_table, LAYER_ID_MAPPING.planks)
	end
end

function var_0_49(self)
	-- function 43
	local indexed_members = self.indexed_members
	local num_indexed_members = self.num_indexed_members
	local network = Managers.state.network

	for i = 1, num_indexed_members do
		local var_43_3 = indexed_members[i]
		local var_43_4 = BLACKBOARDS[var_43_3]

		AiUtils.deactivate_unit(var_43_4)

		local breed = var_43_4.breed

		if var_43_4.confirmed_player_sighting or breed.passive_in_patrol == nil or not breed.passive_in_patrol then
			AiUtils.enter_passive(var_43_3, var_43_4)
		end

		if not ScriptUnit.has_extension(var_43_3, "ai_slot_system") then
			Managers.state.entity:system("ai_slot_system"):do_slot_search(var_43_3, false)
		end

		if not ScriptUnit.extension(var_43_3, "ai_group_system").use_patrol_perception then
			local extension = ScriptUnit.extension(var_43_3, "ai_system")
			local patrol_passive_perception = breed.patrol_passive_perception
			local patrol_passive_target_selection = breed.patrol_passive_target_selection

			extension:set_perception(patrol_passive_perception, patrol_passive_target_selection)
		end

		if not var_43_4.breed.use_navigation_path_splines then
			GwNavBot.set_use_channel(var_43_4.navigation_extension._nav_bot, false)
		end

		var_43_4.preferred_door_action = "open"

		var_43_4.navigation_extension:allow_layer("planks", false)
		GwNavTagLayerCostTable.forbid_layer(self.nav_data.navtag_layer_cost_table, LAYER_ID_MAPPING.planks)
	end

	self.patrol_in_combat = false
end

function var_0_50(self, arg_44_1)
	-- function 44
	fn_4(self, "in_combat")

	self.patrol_in_combat = true

	local anchors = self.anchors
	local count = #anchors

	for i = 1, count do
		local var_44_2 = anchors[i]
		local target_unit = var_44_2.target_unit

		if not HEALTH_ALIVE[target_unit] then
			local units = var_44_2.units

			for k, v in pairs(units) do
				local var_44_5 = BLACKBOARDS[v]

				var_44_5.goal_destination = nil
				var_44_5.target_unit = target_unit
				var_44_5.target_unit_found_time = arg_44_1

				AiUtils.activate_unit(var_44_5)

				if not var_44_5.breed.use_navigation_path_splines then
					GwNavBot.set_use_channel(var_44_5.navigation_extension._nav_bot, true)
				end
			end
		end

		var_44_2.target_unit = nil
	end

	fn_2(self, "CHARGE")

	if not self.has_extra_breed then
		fn_2(self, "CHARGE_EXTRA")
	end
end

function var_0_26(self)
	-- function 45
	self.patrol_path_broken = true

	local spline_name = self.spline_name

	spline_name = spline_name or ""

	print("[Patrol] Broken patrol path, spline_name", spline_name)

	local indexed_members = self.indexed_members
	local num_indexed_members = self.num_indexed_members

	for i = 1, num_indexed_members do
		local var_45_3 = indexed_members[i]
		local var_45_4 = BLACKBOARDS[var_45_3]

		Managers.state.conflict:destroy_unit(var_45_3, var_45_4, "patrol_path_broken")
	end
end
