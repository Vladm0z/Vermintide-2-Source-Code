-- chunkname: @scripts/entity_system/systems/ai/ai_group_system.lua

require("scripts/entity_system/systems/ai/ai_group_templates/ai_group_templates")
require("scripts/entity_system/systems/ai/ai_group_templates/ai_group_templates_patrol")

AIGroupSystem = class(AIGroupSystem, ExtensionSystemBase)

local var_0_0 = AIGroupTemplates
local var_0_1 = {
	"AIGroupMember"
}

AIGroupSystem.invalid_group_uid = 0

function AIGroupSystem.init(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = arg_1_1.entity_manager

	var_1_0:register_system(arg_1_0, arg_1_2, var_0_1)

	arg_1_0.entity_manager = var_1_0
	arg_1_0.is_server = arg_1_1.is_server
	arg_1_0._world = arg_1_1.world
	arg_1_0.unit_storage = arg_1_1.unit_storage
	arg_1_0.nav_world = Managers.state.entity:system("ai_system"):nav_world()
	arg_1_0.groups = {}
	arg_1_0.groups_to_initialize = {}
	arg_1_0.groups_to_update = {}
	arg_1_0.unit_extension_data = {}
	arg_1_0.frozen_unit_extension_data = {}
	arg_1_0.group_uid = AIGroupSystem.invalid_group_uid
	arg_1_0._spline_properties = {}
	arg_1_0._spline_lookup = {}
	arg_1_0._cached_splines = {}
	arg_1_0._last_recycler_group_id = nil
end

function boxify_table_pos_array(arg_2_0)
	for iter_2_0 = 1, #arg_2_0 do
		local var_2_0 = arg_2_0[iter_2_0]

		arg_2_0[iter_2_0] = Vector3Box(var_2_0[1], var_2_0[2], var_2_0[3])
	end
end

function remove_duplicates(arg_3_0)
	local var_3_0 = #arg_3_0
	local var_3_1 = Vector3.equal

	for iter_3_0 = var_3_0, 2, -1 do
		local var_3_2 = arg_3_0[iter_3_0]:unbox()
		local var_3_3 = arg_3_0[iter_3_0 - 1]:unbox()

		if var_3_1(var_3_2, var_3_3) then
			table.remove(arg_3_0, iter_3_0)
		end
	end
end

function AIGroupSystem.add_ready_splines(arg_4_0, arg_4_1, arg_4_2)
	if not arg_4_1 then
		return
	end

	for iter_4_0 = 1, #arg_4_1 do
		local var_4_0 = arg_4_1[iter_4_0]
		local var_4_1 = var_4_0.astar_points

		if var_4_1 then
			boxify_table_pos_array(var_4_1)
			remove_duplicates(var_4_1)

			local var_4_2 = var_4_1[1]
			local var_4_3 = var_4_2:unbox()

			if #var_4_1 == 2 then
				table.insert(var_4_1, 2, Vector3Box((var_4_3 + var_4_1[2]:unbox()) / 2))
			end

			local var_4_4 = Vector3.normalize(var_4_1[3]:unbox() - var_4_3)
			local var_4_5 = {
				start_position = var_4_2,
				start_direction = Vector3Box(var_4_4),
				spline_points = var_4_1
			}

			arg_4_0:_add_spline(var_4_0.id, var_4_5, arg_4_2)
		end
	end
end

function AIGroupSystem.destroy(arg_5_0)
	return
end

function AIGroupSystem.ai_ready(arg_6_0, arg_6_1)
	arg_6_0.patrol_analysis = arg_6_1
end

function AIGroupSystem.on_add_extension(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = {}

	if arg_7_4.id ~= nil then
		arg_7_0:init_extension(arg_7_2, var_7_0, arg_7_4)
	end

	ScriptUnit.set_extension(arg_7_2, "ai_group_system", var_7_0)

	arg_7_0.unit_extension_data[arg_7_2] = var_7_0

	return var_7_0
end

function AIGroupSystem.init_extension(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_3.id
	local var_8_1 = arg_8_3.template
	local var_8_2 = arg_8_0.groups[var_8_0]
	local var_8_3 = arg_8_3.formation
	local var_8_4 = var_8_3 and var_8_3.settings or PatrolFormationSettings.default_settings
	local var_8_5 = arg_8_3.despawn_at_end

	if var_8_2 == nil then
		var_8_2 = {
			members_n = 0,
			start_forward = true,
			num_spawned_members = 0,
			id = var_8_0,
			members = {},
			size = arg_8_3.size,
			template = var_8_1,
			spline_name = arg_8_3.spline_name,
			formation = var_8_3,
			formation_settings = var_8_4,
			group_type = arg_8_3.group_type,
			group_start_position = arg_8_3.group_start_position,
			despawn_at_end = var_8_5,
			side_id = arg_8_3.side_id,
			side = arg_8_3.side,
			commanding_player = arg_8_3.commanding_player,
			group_data = arg_8_3.group_data
		}

		local var_8_6 = var_8_2.spline_name
		local var_8_7 = arg_8_0._patrol_splines[var_8_6] or arg_8_0._roaming_splines[var_8_6] or arg_8_0._event_splines[var_8_6]

		if var_8_7 then
			var_8_2.spline_points = var_8_7.spline_points
			var_8_2.cached_splines = arg_8_0._cached_splines[var_8_6]
		end

		fassert(var_8_2.size, "Created group without size!")
		fassert(var_8_1, "Created group without template!")

		arg_8_0.groups[var_8_0] = var_8_2
		arg_8_0.groups_to_initialize[var_8_0] = var_8_2

		local var_8_8 = var_0_0[var_8_1].setup_group

		if var_8_8 then
			var_8_8(arg_8_0.world, arg_8_0.nav_world, var_8_2, arg_8_1)
		end
	elseif arg_8_3.insert_into_group then
		var_8_2.size = var_8_2.size + 1
	end

	local var_8_9 = arg_8_3.breed
	local var_8_10 = var_8_2.formation

	if var_8_9 and var_8_10 then
		local var_8_11 = arg_8_3.group_position

		arg_8_2.group_row = var_8_11.row
		arg_8_2.group_column = var_8_11.column
	end

	var_8_2.members[arg_8_1] = arg_8_2
	var_8_2.members_n = var_8_2.members_n + 1
	var_8_2.num_spawned_members = var_8_2.num_spawned_members + 1
	arg_8_2.group = var_8_2
	arg_8_2.template = var_8_1
	arg_8_2.id = var_8_0

	local var_8_12 = var_0_0[var_8_1]

	arg_8_2.in_patrol = var_8_12.in_patrol, var_8_12.use_patrol_perception
	arg_8_2.use_patrol_perception = arg_8_3.group_type == "spline_patrol"

	fassert(var_8_2.num_spawned_members <= var_8_2.size, "An AI group was initialized with size=%d but %d AIs was assigned to it.", var_8_2.size, var_8_2.num_spawned_members)
end

function AIGroupSystem.extensions_ready(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = arg_9_0.unit_extension_data[arg_9_2]
	local var_9_1 = var_0_0[var_9_0.template] and var_0_0[var_9_0.template].pre_unit_init

	if var_9_1 then
		var_9_1(arg_9_2, var_9_0.group)
	end
end

function AIGroupSystem.on_remove_extension(arg_10_0, arg_10_1, arg_10_2)
	arg_10_0.frozen_unit_extension_data[arg_10_1] = nil

	arg_10_0:_cleanup_extension(arg_10_1, arg_10_2)
	ScriptUnit.remove_extension(arg_10_1, arg_10_0.NAME)
end

function AIGroupSystem.on_freeze_extension(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0.unit_extension_data[arg_11_1]

	fassert(var_11_0, "Unit was already frozen.")

	if var_11_0 == nil then
		return
	end

	arg_11_0.frozen_unit_extension_data[arg_11_1] = var_11_0

	arg_11_0:_cleanup_extension(arg_11_1, arg_11_2)
end

function AIGroupSystem.freeze(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = arg_12_0.frozen_unit_extension_data

	if var_12_0[arg_12_1] then
		return
	end

	local var_12_1 = arg_12_0.unit_extension_data[arg_12_1]

	fassert(var_12_1, "Unit to freeze didn't have unfrozen extension")
	arg_12_0:_cleanup_extension(arg_12_1, arg_12_2)

	arg_12_0.unit_extension_data[arg_12_1] = nil
	var_12_0[arg_12_1] = var_12_1
end

function AIGroupSystem.unfreeze(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = arg_13_0.frozen_unit_extension_data[arg_13_1]

	fassert(var_13_0, "Unit to unfreeze didn't have frozen extension")

	arg_13_0.frozen_unit_extension_data[arg_13_1] = nil
	arg_13_0.unit_extension_data[arg_13_1] = var_13_0

	local var_13_1 = arg_13_3[8]

	if var_13_1 and var_13_1.id then
		arg_13_0:init_extension(arg_13_1, var_13_0, var_13_1)
	end
end

function AIGroupSystem._cleanup_extension(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0.unit_extension_data[arg_14_1]

	if var_14_0 == nil then
		return
	end

	arg_14_0.unit_extension_data[arg_14_1] = nil

	local var_14_1 = var_14_0.id

	if not var_14_1 then
		return
	end

	local var_14_2 = arg_14_0.groups[var_14_1]

	fassert(var_14_2 ~= nil, "Trying to remove group extension for unit %s that does not belong to a group.", arg_14_1)

	var_14_2.members[arg_14_1] = nil
	var_14_2.members_n = var_14_2.members_n - 1

	if var_14_2.members_n == 0 and var_14_2.num_spawned_members == var_14_2.size then
		local var_14_3 = arg_14_0._world
		local var_14_4 = arg_14_0.nav_world

		if arg_14_0.groups_to_initialize[var_14_1] == nil then
			local var_14_5 = var_14_2.template

			var_0_0[var_14_5].destroy(var_14_3, var_14_4, var_14_2, arg_14_1)
		end

		arg_14_0.groups[var_14_1] = nil
		arg_14_0.groups_to_initialize[var_14_1] = nil
		arg_14_0.groups_to_update[var_14_1] = nil

		if var_14_1 == arg_14_0._last_recycler_group_id then
			arg_14_0._last_recycler_group_id = nil
		end
	end

	var_14_0.id = nil
	var_14_0.group = nil
	var_14_0.template = nil
	var_14_0.in_patrol = nil
	var_14_0.use_patrol_perception = nil
end

local var_0_2 = 100
local var_0_3 = 100
local var_0_4 = 100
local var_0_5 = "patrol_"
local var_0_6 = "roaming_"
local var_0_7 = "event_"

function AIGroupSystem.set_level(arg_15_0, arg_15_1)
	arg_15_0._level = arg_15_1
	arg_15_0._patrol_splines = {}
	arg_15_0._roaming_splines = {}
	arg_15_0._event_splines = {}

	local var_15_0 = arg_15_0._world

	for iter_15_0 = 1, var_0_2 do
		repeat
			local var_15_1 = var_0_5 .. iter_15_0
			local var_15_2 = Level.spline(arg_15_1, var_15_1)

			if #var_15_2 == 0 then
				break
			end

			local var_15_3 = var_15_2[1]
			local var_15_4 = Vector3.normalize(var_15_2[3] - var_15_2[1])
			local var_15_5 = {
				start_position = Vector3Box(var_15_3),
				start_direction = Vector3Box(var_15_4)
			}

			arg_15_0._patrol_splines[var_15_1] = var_15_5
			arg_15_0._spline_lookup[var_15_1] = var_15_5
		until true
	end

	for iter_15_1 = 1, var_0_3 do
		repeat
			local var_15_6 = var_0_6 .. iter_15_1
			local var_15_7 = Level.spline(arg_15_1, var_15_6)

			if #var_15_7 == 0 then
				break
			end

			local var_15_8 = var_15_7[1]
			local var_15_9 = Vector3.normalize(var_15_7[3] - var_15_7[1])
			local var_15_10 = {
				start_position = Vector3Box(var_15_8),
				start_direction = Vector3Box(var_15_9)
			}

			arg_15_0._roaming_splines[var_15_6] = var_15_10
			arg_15_0._spline_lookup[var_15_6] = var_15_10
		until true
	end

	for iter_15_2 = 1, var_0_4 do
		repeat
			local var_15_11 = var_0_7 .. iter_15_2
			local var_15_12 = Level.spline(arg_15_1, var_15_11)

			if #var_15_12 == 0 then
				break
			end

			local var_15_13 = var_15_12[1]
			local var_15_14 = Vector3.normalize(var_15_12[3] - var_15_12[1])
			local var_15_15 = {
				start_position = Vector3Box(var_15_13),
				start_direction = Vector3Box(var_15_14)
			}

			arg_15_0._event_splines[var_15_11] = var_15_15
			arg_15_0._spline_lookup[var_15_11] = var_15_15
		until true
	end
end

local var_0_8 = 25
local var_0_9 = 25

function AIGroupSystem.get_best_spline(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0
	local var_16_1
	local var_16_2 = math.huge
	local var_16_3
	local var_16_4

	if arg_16_2 == "patrol" then
		var_16_3 = arg_16_0._patrol_splines
		var_16_4 = math.huge
	elseif arg_16_2 == "roaming" then
		var_16_3 = arg_16_0._roaming_splines
		var_16_4 = var_0_9
	elseif arg_16_2 == "event" then
		var_16_3 = arg_16_0._event_splines
		var_16_4 = math.huge
	end

	for iter_16_0, iter_16_1 in pairs(var_16_3) do
		repeat
			local var_16_5 = math.random(1, var_0_8)
			local var_16_6 = iter_16_1.start_position:unbox()
			local var_16_7 = Vector3.distance(arg_16_1, var_16_6)

			if var_16_4 < var_16_7 then
				break
			end

			local var_16_8 = var_16_7 - var_16_5

			if var_16_2 < var_16_8 then
				break
			end

			var_16_2 = var_16_8
			var_16_0 = iter_16_0
			var_16_1 = iter_16_1
		until true
	end

	return var_16_0, var_16_1
end

function AIGroupSystem.spline_start_position(arg_17_0, arg_17_1)
	return (arg_17_0._spline_lookup[arg_17_1].start_position:unbox())
end

function AIGroupSystem.spline_start_direction(arg_18_0, arg_18_1)
	return (arg_18_0._spline_lookup[arg_18_1].start_direction:unbox())
end

function AIGroupSystem.spline(arg_19_0, arg_19_1)
	return arg_19_0._spline_lookup[arg_19_1]
end

function AIGroupSystem.level_has_splines(arg_20_0, arg_20_1)
	local var_20_0

	if arg_20_1 == "patrol" then
		var_20_0 = arg_20_0._patrol_splines
	elseif arg_20_1 == "roaming" then
		var_20_0 = arg_20_0._roaming_splines
	elseif arg_20_1 == "event" then
		var_20_0 = arg_20_0._event_splines
	else
		error("no such spline_type: " .. arg_20_1)
	end

	return table.size(var_20_0) > 0
end

function AIGroupSystem.get_available_spline_type(arg_21_0)
	local var_21_0

	if arg_21_0._patrol_splines then
		local var_21_1 = arg_21_0._patrol_splines
	elseif arg_21_0._roaming_splines then
		local var_21_2 = arg_21_0._roaming_splines
	elseif arg_21_0._event_splines then
		local var_21_3 = arg_21_0._event_splines
	end

	return next(arg_21_0._patrol_splines) and "patrol" or next(arg_21_0._roaming_splines) and "roaming" or next(arg_21_0._event_splines) and "event"
end

function AIGroupSystem.hot_join_sync(arg_22_0, arg_22_1, arg_22_2)
	return
end

local var_0_10 = POSITION_LOOKUP

function AIGroupSystem.check_recycler_despawn(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	local var_23_0 = arg_23_0.groups_to_update
	local var_23_1, var_23_2 = next(var_23_0, arg_23_0._last_recycler_group_id)

	arg_23_0._last_recycler_group_id = var_23_1

	if not var_23_1 or var_23_2.group_type ~= "roaming_patrol" or var_23_2.patrol_in_combat then
		return
	end

	local var_23_3 = var_23_2.indexed_members[1]
	local var_23_4 = var_0_10[var_23_3]

	if not var_23_4 then
		return
	end

	local var_23_5 = Managers.state.conflict
	local var_23_6 = var_23_5.navigation_group_manager
	local var_23_7 = var_23_6:get_group_from_position(var_23_4)

	if not var_23_7 then
		return
	end

	local var_23_8 = CurrentRoamingSettings
	local var_23_9 = var_23_8.despawn_path_distance
	local var_23_10 = var_23_8.despawn_distance + 8
	local var_23_11 = var_23_8.despawn_distance_z or 8
	local var_23_12 = false
	local var_23_13 = #arg_23_1
	local var_23_14 = math.abs

	if var_23_13 >= 0 then
		for iter_23_0 = 1, var_23_13 do
			local var_23_15 = var_23_4 - arg_23_1[iter_23_0]
			local var_23_16 = var_23_15.z

			Vector3.set_z(var_23_15, 0)

			if var_23_10 > Vector3.length(var_23_15) and var_23_11 > var_23_14(var_23_16) then
				local var_23_17 = arg_23_2[iter_23_0]

				if arg_23_3 and var_23_17 then
					local var_23_18, var_23_19, var_23_20 = var_23_6:a_star_cached(var_23_17, var_23_7)

					if not var_23_19 or var_23_19 < var_23_9 then
						var_23_12 = true

						break
					end
				else
					var_23_12 = true

					break
				end
			end
		end
	else
		var_23_12 = true
	end

	if not var_23_12 then
		local var_23_21 = var_23_2.indexed_members
		local var_23_22 = var_23_2.num_indexed_members
		local var_23_23 = var_23_5.enemy_recycler
		local var_23_24 = BLACKBOARDS

		for iter_23_1 = 1, var_23_22 do
			local var_23_25 = var_23_21[iter_23_1]
			local var_23_26 = var_23_24[var_23_25]
			local var_23_27 = Vector3Box(POSITION_LOOKUP[var_23_25])
			local var_23_28 = QuaternionBox(Unit.local_rotation(var_23_25, 0))

			var_23_23:add_breed(var_23_26.breed.name, var_23_27, var_23_28)
			Managers.state.conflict:destroy_unit(var_23_25, var_23_26, "patrol_finished")
		end
	end
end

local var_0_11 = {
	mode = "retained",
	name = "AIGroupTemplates_retained"
}

function AIGroupSystem.update(arg_24_0, arg_24_1, arg_24_2)
	if not arg_24_0.is_server then
		return
	end

	local var_24_0 = arg_24_0._world
	local var_24_1 = arg_24_0.nav_world
	local var_24_2 = var_0_0

	for iter_24_0, iter_24_1 in pairs(arg_24_0.groups_to_initialize) do
		if iter_24_1.num_spawned_members == iter_24_1.size then
			if iter_24_1.members_n > 0 then
				local var_24_3 = iter_24_1.template
				local var_24_4 = var_24_2[var_24_3].init

				printf("Init group template: %s", var_24_3)
				var_24_4(var_24_0, var_24_1, iter_24_1, arg_24_2)

				arg_24_0.groups_to_initialize[iter_24_1.id] = nil
				arg_24_0.groups_to_update[iter_24_1.id] = iter_24_1
			else
				arg_24_0.groups_to_initialize[iter_24_1.id] = nil
			end
		end
	end

	for iter_24_2, iter_24_3 in pairs(arg_24_0.groups_to_update) do
		var_24_2[iter_24_3.template].update(var_24_0, var_24_1, iter_24_3, arg_24_2, arg_24_1.dt)
	end

	if arg_24_0.patrol_analysis and arg_24_0._computing_splines then
		arg_24_0.patrol_analysis:run()

		for iter_24_4, iter_24_5 in pairs(arg_24_0._computing_splines) do
			repeat
				if not arg_24_0:_spline_ready(iter_24_4) then
					break
				end

				local var_24_5 = arg_24_0.patrol_analysis:spline(iter_24_4)
				local var_24_6 = var_24_5.spline_points
				local var_24_7 = var_24_6[1]

				fassert(var_24_7, "missing starting spline point, for spline %s", var_24_5.id)

				local var_24_8 = var_24_7:unbox()

				if #var_24_6 == 2 then
					table.insert(var_24_6, 2, Vector3Box((var_24_8 + var_24_6[2]:unbox()) / 2))
				end

				local var_24_9 = Vector3.normalize(var_24_6[3]:unbox() - var_24_8)

				for iter_24_6 = #var_24_6, 2, -1 do
					local var_24_10 = var_24_6[iter_24_6]:unbox()
					local var_24_11 = var_24_6[iter_24_6 - 1]:unbox()

					if Vector3.equal(var_24_10, var_24_11) then
						table.remove(var_24_6, iter_24_6)
					end
				end

				local var_24_12 = {
					start_position = var_24_7,
					start_direction = Vector3Box(var_24_9),
					spline_points = var_24_6,
					failed = var_24_5.failed
				}

				arg_24_0:_add_spline(iter_24_4, var_24_12, iter_24_5)

				arg_24_0._computing_splines[iter_24_4] = nil
			until true
		end
	end

	local var_24_13 = Managers.state.conflict

	if arg_24_0._update_recycler then
		arg_24_0:check_recycler_despawn(arg_24_0._player_positions, arg_24_0._player_areas, arg_24_0._use_player_areas)
	end

	arg_24_0._update_recycler = false
end

function AIGroupSystem.prepare_update_recycler(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	arg_25_0._update_recycler = true
	arg_25_0._player_positions = arg_25_1
	arg_25_0._player_areas = arg_25_2
	arg_25_0._use_player_areas = arg_25_3
end

function AIGroupSystem.get_ai_group(arg_26_0, arg_26_1)
	return arg_26_0.groups[arg_26_1]
end

function AIGroupSystem.run_func_on_all_members(arg_27_0, arg_27_1, arg_27_2, ...)
	local var_27_0 = arg_27_1.members

	for iter_27_0, iter_27_1 in pairs(var_27_0) do
		arg_27_2(iter_27_0, iter_27_1, ...)
	end
end

function AIGroupSystem.generate_group_id(arg_28_0)
	arg_28_0.group_uid = arg_28_0.group_uid + 1

	return arg_28_0.group_uid
end

function AIGroupSystem.set_allowed_layer(arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = LAYER_ID_MAPPING[arg_29_1]

	for iter_29_0, iter_29_1 in pairs(arg_29_0.groups_to_update) do
		if iter_29_1.nav_data and iter_29_1.nav_data.navtag_layer_cost_table then
			if arg_29_2 then
				GwNavTagLayerCostTable.allow_layer(iter_29_1.nav_data.navtag_layer_cost_table, var_29_0)
			else
				GwNavTagLayerCostTable.forbid_layer(iter_29_1.nav_data.navtag_layer_cost_table, var_29_0)
			end
		end
	end
end

function AIGroupSystem.create_spline_from_way_points(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	local var_30_0 = arg_30_3 == "roaming" and "roaming" or "standard"

	arg_30_0.patrol_analysis:compute_spline_path(arg_30_1, arg_30_2, var_30_0)

	arg_30_0._computing_splines = arg_30_0._computing_splines or {}
	arg_30_0._computing_splines[arg_30_1] = arg_30_3
end

function AIGroupSystem.spline_ready(arg_31_0, arg_31_1)
	return arg_31_0._spline_lookup[arg_31_1]
end

function AIGroupSystem._spline_ready(arg_32_0, arg_32_1)
	local var_32_0 = arg_32_0.patrol_analysis

	if not var_32_0 then
		return false
	end

	return (var_32_0:spline(arg_32_1))
end

function AIGroupSystem._add_spline(arg_33_0, arg_33_1, arg_33_2, arg_33_3)
	arg_33_0._spline_lookup[arg_33_1] = arg_33_2

	if GameSettingsDevelopment.pre_calculate_patrol_splines then
		arg_33_0._cached_splines[arg_33_1] = arg_33_0:_calculate_splines(arg_33_1, arg_33_2)
	end

	if arg_33_3 == "patrol" or string.find(arg_33_1, var_0_5) then
		arg_33_0._patrol_splines[arg_33_1] = arg_33_2

		return
	end

	if arg_33_3 == "roaming" or string.find(arg_33_1, var_0_6) then
		arg_33_0._roaming_splines[arg_33_1] = arg_33_2

		return
	end

	if arg_33_3 == "event" or string.find(arg_33_1, var_0_7) then
		arg_33_0._event_splines[arg_33_1] = arg_33_2

		return
	end

	error("unsupported spline type for spline: " .. arg_33_1 .. ". Spline name should start with 'patrol_', 'roaming_' or 'event_' which defines the spline type")
end

function AIGroupSystem._calculate_splines(arg_34_0, arg_34_1, arg_34_2)
	if not arg_34_2.spline_points then
		return
	end

	local var_34_0 = {}
	local var_34_1 = arg_34_2.spline_points
	local var_34_2 = AiUtils.remove_bad_boxed_spline_points(var_34_1, arg_34_1)

	return SplineCurve:new(var_34_2, "Hermite", "SplineMovementHermiteInterpolatedMetered", arg_34_1, 3):splines()
end

function AIGroupSystem.draw_active_spline_paths(arg_35_0)
	local var_35_0 = QuickDrawerStay
	local var_35_1 = arg_35_0._patrol_splines
	local var_35_2 = Color(255, 255, 0)

	for iter_35_0, iter_35_1 in pairs(var_35_1) do
		arg_35_0:draw_spline(iter_35_1.spline_points, var_35_0, var_35_2)
	end

	local var_35_3 = arg_35_0._roaming_splines
	local var_35_4 = Color(255, 255, 0)

	for iter_35_2, iter_35_3 in pairs(var_35_3) do
		arg_35_0:draw_spline(iter_35_3.spline_points, var_35_0, var_35_4)
	end

	local var_35_5 = arg_35_0._event_splines
	local var_35_6 = Color(255, 255, 0)

	for iter_35_4, iter_35_5 in pairs(var_35_5) do
		arg_35_0:draw_spline(iter_35_5.spline_points, var_35_0, var_35_6)
	end
end

function AIGroupSystem.draw_spline(arg_36_0, arg_36_1, arg_36_2, arg_36_3)
	local var_36_0 = arg_36_1[1]:unbox()
	local var_36_1 = Vector3(0, 0, 1)

	for iter_36_0 = 2, #arg_36_1 do
		local var_36_2 = arg_36_1[iter_36_0]
		local var_36_3 = arg_36_1[iter_36_0]:unbox()

		arg_36_2:line(var_36_0 + var_36_1, var_36_3 + var_36_1, arg_36_3)

		var_36_0 = var_36_3
	end
end

function AIGroupSystem.create_formation_data(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5)
	local var_37_0 = PatrolFormationSettings.default_settings.offsets.ANCHOR_OFFSET.y
	local var_37_1 = PatrolFormationSettings.default_settings.speeds.SPLINE_SPEED
	local var_37_2 = arg_37_0:spline_start_direction(arg_37_3)
	local var_37_3 = table.clone(arg_37_2)
	local var_37_4 = #arg_37_2
	local var_37_5 = (var_37_4 - 1) * var_37_1
	local var_37_6 = 0
	local var_37_7 = arg_37_0._spline_lookup[arg_37_3]
	local var_37_8

	if var_37_7.spline_points then
		local var_37_9 = arg_37_0._cached_splines[arg_37_3]
		local var_37_10 = var_37_7.spline_points
		local var_37_11 = AiUtils.remove_bad_boxed_spline_points(var_37_10, arg_37_3)

		var_37_8 = SplineCurve:new(var_37_11, "Hermite", "SplineMovementHermiteInterpolatedMetered", arg_37_3, 3, var_37_9)
	else
		local var_37_12 = arg_37_0._level
		local var_37_13 = Level.spline(var_37_12, arg_37_3)
		local var_37_14 = AiUtils.remove_bad_spline_points(var_37_13, arg_37_3)

		var_37_8 = SplineCurve:new(var_37_14, "Bezier", "SplineMovementHermiteInterpolatedMetered", arg_37_3, 10)
	end

	local var_37_15 = NavigationUtils.get_closest_index_on_spline(var_37_8, arg_37_1)
	local var_37_16 = 1
	local var_37_17 = 1
	local var_37_18 = GwNavQueries.inside_position_from_outside_position
	local var_37_19 = arg_37_0.nav_world
	local var_37_20
	local var_37_21
	local var_37_22
	local var_37_23

	if arg_37_4 then
		local var_37_24

		var_37_20, var_37_24 = arg_37_0:_get_position_on_spline_by_distance(0, var_37_8, var_37_15)

		if var_37_20 == nil then
			var_37_20 = arg_37_1
			var_37_24 = var_37_2
		end

		var_37_23 = Vector3(var_37_24.y, -var_37_24.x, 0)
		var_37_22 = Vector3.flat(var_37_24)
	end

	local var_37_25 = 1

	for iter_37_0, iter_37_1 in ipairs(arg_37_2) do
		table.clear(var_37_3[iter_37_0])

		if not arg_37_4 then
			local var_37_26 = var_37_5 - (var_37_25 - 1) * var_37_1
			local var_37_27

			var_37_20, var_37_27 = arg_37_0:_get_position_on_spline_by_distance(var_37_26, var_37_8, var_37_15)

			if var_37_20 == nil then
				var_37_20 = arg_37_1
				var_37_27 = var_37_2
			end

			var_37_23 = Vector3(var_37_27.y, -var_37_27.x, 0)
			var_37_22 = Vector3.flat(var_37_27)
		end

		for iter_37_2, iter_37_3 in ipairs(iter_37_1) do
			local var_37_28 = var_37_20 + var_37_23 * (-((#iter_37_1 - 1) * (var_37_0 * 2)) / 2 + var_37_0 * 2 * (iter_37_2 - 1))

			if Breeds[iter_37_3] then
				local var_37_29 = LocomotionUtils.pos_on_mesh(var_37_19, var_37_28, var_37_16, var_37_17) or LocomotionUtils.pos_on_mesh(var_37_19, var_37_20, var_37_16, var_37_17)

				var_37_29 = var_37_29 or var_37_18(var_37_19, var_37_28, var_37_16, var_37_17, 0.5, 0.2)

				if var_37_29 then
					var_37_3[var_37_25][iter_37_2] = {
						breed_name = iter_37_3,
						start_position = Vector3Box(var_37_29),
						start_direction = Vector3Box(var_37_22)
					}
					var_37_6 = var_37_6 + 1
				else
					if arg_37_5 then
						printf("Patrol formation outside navmesh. template_name: %s, spline_name: %s group_type: %s, wanted_spawn_pos: %s", arg_37_5.template, arg_37_3, arg_37_5.group_type, tostring(var_37_28))
					end

					var_37_3[var_37_25][iter_37_2] = {
						start_position = Vector3Box(var_37_28),
						start_direction = Vector3Box(var_37_22)
					}
				end
			else
				var_37_3[var_37_25][iter_37_2] = {
					start_position = Vector3Box(var_37_28),
					start_direction = Vector3Box(var_37_22)
				}
			end
		end

		if #var_37_3[var_37_25] > 0 then
			var_37_25 = var_37_25 + 1
		end
	end

	for iter_37_4 = var_37_25, var_37_4 do
		local var_37_30 = var_37_3[iter_37_4]

		var_37_3[iter_37_4] = nil
	end

	var_37_3.group_size = var_37_6

	return var_37_3
end

function AIGroupSystem._get_position_on_spline_by_distance(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	local var_38_0 = 0
	local var_38_1 = arg_38_2:movement()

	var_38_1:reset_to_start()
	var_38_1:set_speed(2)

	if arg_38_3 then
		var_38_1:set_spline_index(arg_38_3, 1, 0)
	end

	local var_38_2, var_38_3 = var_38_1:current_position(), var_38_1:current_spline_curve_distance()
	local var_38_4 = 0.1

	while true do
		local var_38_5, var_38_6, var_38_7 = Script.temp_count()

		if var_38_1:update(var_38_4) == "end" then
			return nil
		end

		local var_38_8 = var_38_1:current_position()
		local var_38_9 = var_38_1:current_spline_curve_distance()
		local var_38_10 = math.abs(var_38_9 - var_38_3)

		var_38_0 = var_38_10 + var_38_0

		if arg_38_1 <= var_38_0 or var_38_10 <= 0 then
			local var_38_11 = Vector3.normalize(var_38_8 - var_38_2)

			return var_38_8, var_38_11
		end

		Vector3.set_xyz(var_38_2, var_38_8.x, var_38_8.y, var_38_8.z)

		var_38_3 = var_38_9

		Script.set_temp_count(var_38_5, var_38_6, var_38_7)
	end
end

function AIGroupSystem.register_spline_properties(arg_39_0, arg_39_1, arg_39_2)
	arg_39_0._spline_properties[arg_39_1] = arg_39_2
end

function AIGroupSystem.get_group_id(arg_40_0, arg_40_1)
	local var_40_0 = arg_40_0.unit_extension_data[arg_40_1]

	return var_40_0 and var_40_0.id
end
