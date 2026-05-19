-- chunkname: @scripts/entity_system/systems/ai/ai_slot_system.lua

require("scripts/unit_extensions/human/ai_player_unit/ai_utils")
require("scripts/settings/slot_templates")
require("scripts/settings/slot_settings")

local var_0_0 = "normal"
local var_0_1 = {
	"AIEnemySlotExtension",
	"AIPlayerSlotExtension",
	"AIAggroableSlotExtension"
}

AISlotSystem = class(AISlotSystem, ExtensionSystemBase)

local var_0_2 = SlotTemplates
local var_0_3 = SlotTypeSettings

function AISlotSystem.init(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = arg_1_1.entity_manager

	var_1_0:register_system(arg_1_0, arg_1_2, var_0_1)

	arg_1_0.entity_manager = var_1_0
	arg_1_0.is_server = arg_1_1.is_server
	arg_1_0.world = arg_1_1.world
	arg_1_0.unit_storage = arg_1_1.unit_storage
	arg_1_0.nav_world = Managers.state.entity:system("ai_system"):nav_world()
	arg_1_0.unit_extension_data = {}
	arg_1_0.frozen_unit_extension_data = {}
	arg_1_0.update_slots_ai_units = {}
	arg_1_0.update_slots_ai_units_prioritized = {}
	arg_1_0.target_units = {}
	arg_1_0.current_ai_index = 1
	arg_1_0.next_total_slot_count_update = 0
	arg_1_0.next_disabled_slot_count_update = 0
	arg_1_0.next_slot_sound_update = 0
	arg_1_0.network_transmit = arg_1_1.network_transmit
	arg_1_0.num_total_enemies = 0
	arg_1_0.num_occupied_slots = 0

	local var_1_1 = {
		bot_poison_wind = 1,
		bot_ratling_gun_fire = 1,
		fire_grenade = 1
	}

	table.merge(var_1_1, NAV_TAG_VOLUME_LAYER_COST_AI)

	local var_1_2 = GwNavTagLayerCostTable.create()

	arg_1_0._navtag_layer_cost_table = var_1_2

	AiUtils.initialize_cost_table(var_1_2, var_1_1)

	local var_1_3 = GwNavCostMap.create_tag_cost_table()

	arg_1_0._nav_cost_map_cost_table = var_1_3

	AiUtils.initialize_nav_cost_map_cost_table(var_1_3, nil, 1)

	arg_1_0._traverse_logic = GwNavTraverseLogic.create(arg_1_0.nav_world, var_1_3)

	GwNavTraverseLogic.set_navtag_layer_cost_table(arg_1_0._traverse_logic, var_1_2)
end

local var_0_4

function AISlotSystem.destroy(arg_2_0)
	if arg_2_0._traverse_logic ~= nil then
		GwNavTagLayerCostTable.destroy(arg_2_0._navtag_layer_cost_table)
		GwNavCostMap.destroy_tag_cost_table(arg_2_0._nav_cost_map_cost_table)
		GwNavTraverseLogic.destroy(arg_2_0._traverse_logic)
	end
end

local var_0_5 = 0.5
local var_0_6 = {
	CHECK_LEFT = 0,
	CHECK_RIGHT = 2,
	CHECK_MIDDLE = 1
}
local var_0_7 = table.size(var_0_6)
local var_0_8 = {
	[var_0_6.CHECK_LEFT] = math.degrees_to_radians(-90),
	[var_0_6.CHECK_RIGHT] = math.degrees_to_radians(90)
}
local var_0_9 = Vector3.distance_squared
local var_0_10 = Vector3.distance
local var_0_11 = Vector3.copy
local var_0_12 = Vector3.length
local var_0_13 = Vector3.length_squared
local var_0_14 = Vector3.normalize
local var_0_15 = Vector3.dot
local var_0_16 = Vector3.flat
local var_0_17 = {}

for iter_0_0, iter_0_1 in pairs(var_0_3) do
	var_0_17[#var_0_17 + 1] = iter_0_0
end

local var_0_18 = #var_0_17

local function var_0_19(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_1.all_slots

	for iter_3_0, iter_3_1 in pairs(var_3_0) do
		local var_3_1 = iter_3_1.total_slots_count
		local var_3_2 = iter_3_1.slots

		for iter_3_2 = 1, var_3_1 do
			local var_3_3 = {
				target_unit = arg_3_0,
				queue = {},
				original_absolute_position = Vector3Box(0, 0, 0),
				absolute_position = Vector3Box(0, 0, 0),
				ghost_position = Vector3Box(0, 0, 0),
				queue_direction = Vector3Box(0, 0, 0),
				position_right = Vector3Box(0, 0, 0),
				position_left = Vector3Box(0, 0, 0),
				index = iter_3_2
			}

			var_3_3.anchor_weight = 0
			var_3_3.type = iter_3_0
			var_3_3.radians = math.degrees_to_radians(360 / var_3_1)
			var_3_3.priority = iter_3_1.priority
			var_3_3.position_check_index = var_0_6.CHECK_MIDDLE

			local var_3_4 = (iter_3_2 - 1) % 9 + 1

			var_3_3.debug_color_name = var_0_3[iter_3_0].debug_color
			var_3_2[iter_3_2] = var_3_3
		end
	end
end

local function var_0_20(arg_4_0, arg_4_1)
	if not arg_4_0 then
		return
	end

	local var_4_0 = arg_4_0.ai_unit

	if var_4_0 then
		local var_4_1 = arg_4_1[var_4_0]

		if var_4_1 then
			var_4_1.slot = nil
		end

		Managers.state.debug_text:clear_unit_text(var_4_0, "slot_index")
	end

	local var_4_2 = arg_4_0.queue
	local var_4_3 = #var_4_2

	for iter_4_0 = 1, var_4_3 do
		local var_4_4 = arg_4_1[var_4_2[iter_4_0]]

		if var_4_4 then
			var_4_4.waiting_on_slot = nil
		end
	end

	local var_4_5 = arg_4_1[arg_4_0.target_unit]

	if var_4_5 then
		local var_4_6 = var_4_5.all_slots

		for iter_4_1, iter_4_2 in pairs(var_4_6) do
			local var_4_7 = iter_4_2.slots
			local var_4_8 = #var_4_7

			for iter_4_3 = 1, var_4_8 do
				if var_4_7[iter_4_3] == arg_4_0 then
					var_4_7[iter_4_3] = var_4_7[var_4_8]
					var_4_7[iter_4_3].index = iter_4_3
					var_4_7[var_4_8] = nil

					break
				end
			end
		end
	end
end

local function var_0_21(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0.ai_unit

	if var_5_0 then
		arg_5_1[var_5_0].slot = nil
		arg_5_0.ai_unit = nil
	end

	arg_5_0.disabled = true
	arg_5_0.released = false
end

local function var_0_22(arg_6_0)
	arg_6_0.disabled = false
end

local function var_0_23(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_1[arg_7_0].all_slots
	local var_7_1 = 0
	local var_7_2 = var_7_0[arg_7_2]
	local var_7_3 = var_7_2.slots
	local var_7_4 = var_7_2.total_slots_count

	for iter_7_0 = 1, var_7_4 do
		local var_7_5 = var_7_3[iter_7_0]

		if var_7_5.ai_unit then
			var_7_1 = var_7_1 + 1
		end

		var_7_1 = var_7_1 + #var_7_5.queue
	end

	return var_7_1
end

local function var_0_24(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_1[arg_8_0]

	if not var_8_0 then
		return
	end

	local var_8_1 = var_8_0.slot
	local var_8_2 = var_8_0.waiting_on_slot

	if var_8_1 then
		local var_8_3 = var_8_1.queue
		local var_8_4 = #var_8_3

		if var_8_4 > 0 then
			local var_8_5 = var_8_3[var_8_4]
			local var_8_6 = arg_8_1[var_8_5]

			var_8_1.ai_unit = var_8_5
			var_8_6.slot = var_8_1
			var_8_6.waiting_on_slot = nil
			var_8_3[var_8_4] = nil
		else
			var_8_1.ai_unit = nil
		end

		Managers.state.debug_text:clear_unit_text(arg_8_0, "slot_index")

		local var_8_7 = var_8_1.target_unit

		if Unit.alive(var_8_7) then
			local var_8_8 = arg_8_1[var_8_7]
			local var_8_9 = var_8_1.type

			var_8_8.all_slots[var_8_9].slots_count = var_0_23(var_8_7, arg_8_1, var_8_9)
		end
	elseif var_8_2 then
		local var_8_10 = var_8_2.queue
		local var_8_11 = #var_8_10

		for iter_8_0 = 1, var_8_11 do
			if var_8_10[iter_8_0] == arg_8_0 then
				var_8_10[iter_8_0] = var_8_10[var_8_11]
				var_8_10[var_8_11] = nil
			end
		end
	end

	var_8_0.waiting_on_slot = nil
	var_8_0.slot = nil
end

function AISlotSystem.hot_join_sync(arg_9_0, arg_9_1, arg_9_2)
	return
end

local var_0_25 = 1
local var_0_26 = 1.75
local var_0_27 = var_0_26 * var_0_26
local var_0_28 = 1.5
local var_0_29 = 2
local var_0_30 = 3
local var_0_31 = 7.5
local var_0_32 = 4
local var_0_33 = 0.5
local var_0_34 = 0.25
local var_0_35 = 1
local var_0_36 = 1.5
local var_0_37 = 1.5
local var_0_38 = 0.5
local var_0_39 = var_0_38 + 0.6
local var_0_40 = 2

function AISlotSystem.do_slot_search(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0.unit_extension_data[arg_10_1]

	if var_10_0 then
		var_10_0.do_search = arg_10_2
	end
end

local var_0_41 = GwNavQueries.triangle_from_position
local var_0_42 = GwNavQueries.inside_position_from_outside_position
local var_0_43 = GwNavQueries.raycango

local function var_0_44(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	arg_11_3 = arg_11_3 or var_0_37
	arg_11_2 = arg_11_2 or var_0_36

	local var_11_0
	local var_11_1, var_11_2 = var_0_41(arg_11_1, arg_11_0, arg_11_2, arg_11_3)

	if var_11_1 then
		var_11_0 = var_0_11(arg_11_0)
		var_11_0.z = var_11_2
	end

	return var_11_1 and var_11_0 or nil
end

function get_target_pos_on_navmesh(arg_12_0, arg_12_1)
	local var_12_0 = var_0_44(arg_12_0, arg_12_1)

	if var_12_0 then
		return var_12_0
	end

	local var_12_1 = var_0_36
	local var_12_2 = var_0_37
	local var_12_3 = 1
	local var_12_4 = 0.05
	local var_12_5 = var_0_42(arg_12_1, arg_12_0, var_12_1, var_12_2, var_12_3, var_12_4)

	if var_12_5 then
		return var_12_5
	end

	local var_12_6 = var_0_36
	local var_12_7 = var_0_31
	local var_12_8 = var_0_44(arg_12_0, arg_12_1, var_12_6, var_12_7)

	if var_12_8 then
		return var_12_8
	end

	return nil
end

local var_0_45 = 100
local var_0_46 = 3
local var_0_47 = 2
local var_0_48 = 3

local function var_0_49(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	local var_13_0 = arg_13_1.target_unit
	local var_13_1 = arg_13_1.ai_unit

	if not HEALTH_ALIVE[var_13_0] or not ALIVE[var_13_1] then
		return
	end

	local var_13_2 = arg_13_0[var_13_1].slot_template
	local var_13_3 = arg_13_1.type
	local var_13_4 = var_0_3[var_13_3].distance
	local var_13_5 = arg_13_0[var_13_0]
	local var_13_6 = var_13_5.full_slots_at_t[var_13_3]
	local var_13_7 = var_13_2.min_wait_queue_distance or var_0_46
	local var_13_8 = var_13_7 * var_13_7
	local var_13_9 = 0

	if var_13_6 and var_13_2.min_queue_offset_distance then
		local var_13_10 = var_13_2.min_queue_offset_distance
		local var_13_11 = var_13_2.full_offset_time
		local var_13_12 = arg_13_4 - var_13_6

		var_13_9 = var_13_10 * math.min(var_13_12 / var_13_11, 1)
	end

	local var_13_13 = var_13_5.position:unbox()
	local var_13_14 = POSITION_LOOKUP[var_13_1]
	local var_13_15 = arg_13_1.queue_direction:unbox()
	local var_13_16 = arg_13_3 or 0
	local var_13_17 = var_0_10(var_13_13, var_13_14)
	local var_13_18 = var_0_3[var_13_3].queue_distance
	local var_13_19 = var_13_13 + var_13_15 * math.max(var_13_17 + var_13_18 + var_13_16 - var_13_9, var_13_7)
	local var_13_20 = var_0_44(var_13_19, arg_13_2, var_0_47, var_0_48)
	local var_13_21 = 5
	local var_13_22 = 1

	while not var_13_20 and var_13_22 <= var_13_21 do
		local var_13_23 = math.max(math.max(var_13_17 * (1 - var_13_22 / var_13_21), var_13_4) + var_13_18 + var_13_16 - var_13_9, var_13_7)
		local var_13_24 = var_13_13 + var_13_15 * math.max(var_13_23, 0.5)

		var_13_20 = var_0_44(var_13_24, arg_13_2, var_0_47, var_0_48)
		var_13_22 = var_13_22 + 1
	end

	local var_13_25 = 0
	local var_13_26

	if var_13_20 then
		local var_13_27 = var_0_44(var_13_13, arg_13_2, var_0_47, var_0_48)

		if var_13_27 then
			var_13_26 = var_0_43(arg_13_2, var_13_20, var_13_27)
		end
	end

	if not var_13_20 or not var_13_26 then
		var_13_25 = var_0_45

		local var_13_28 = var_13_13 + var_13_15 * var_13_18

		if var_13_2.restricted_queue_distance then
			if var_13_8 <= var_0_9(var_13_13, var_13_28) then
				return var_13_28, var_13_25
			else
				local var_13_29
				local var_13_30 = var_0_14(var_13_14 - var_13_13)
				local var_13_31 = 1

				while not var_13_29 and var_13_31 <= var_13_21 do
					local var_13_32 = math.max(math.max(var_13_17 * (1 - var_13_31 / var_13_21), var_13_4) + var_13_18 + var_13_16 - var_13_9, var_13_7)

					var_13_28 = var_13_13 + var_13_30 * math.max(var_13_32, 0.5)
					var_13_29 = var_0_44(var_13_28, arg_13_2, var_0_47, var_0_48)
					var_13_31 = var_13_31 + 1
				end

				if var_13_29 then
					return var_13_29, 0
				else
					return var_13_28, var_13_25
				end
			end
		else
			return var_13_28, var_13_25
		end
	else
		return var_13_20, var_13_25
	end
end

local function var_0_50(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0

	if ScriptUnit.has_extension(arg_14_0, "locomotion_system") then
		var_14_0 = ScriptUnit.extension(arg_14_0, "locomotion_system"):current_velocity()
	else
		var_14_0 = Vector3(0, 0, 0)
	end

	if var_0_12(var_14_0) > 0.1 then
		local var_14_1 = var_0_12(var_14_0)
		local var_14_2 = var_0_14(var_14_0)
		local var_14_3 = var_14_2 * var_14_1
		local var_14_4 = var_0_14(arg_14_2 - arg_14_1)
		local var_14_5 = var_0_15(var_14_4, var_14_2)

		return arg_14_1 + var_14_3 * math.max(2 * (var_14_5 - 0.5), 0)
	else
		return arg_14_1
	end
end

function AISlotSystem.improve_slot_position(arg_15_0, arg_15_1, arg_15_2)
	if not ALIVE[arg_15_1] then
		return
	end

	local var_15_0 = POSITION_LOOKUP[arg_15_1]
	local var_15_1 = arg_15_0.unit_extension_data[arg_15_1]
	local var_15_2 = var_15_1.slot
	local var_15_3 = var_15_1.waiting_on_slot
	local var_15_4

	if var_15_2 then
		if var_15_2.ghost_position.x ~= 0 then
			var_15_4 = var_15_2.ghost_position:unbox()
		else
			var_15_4 = var_15_2.absolute_position:unbox()
		end
	elseif var_15_3 and arg_15_2 > var_15_1.improve_wait_slot_position_t then
		local var_15_5 = arg_15_0.nav_world
		local var_15_6 = var_15_3.queue[1] == arg_15_1 and -0.5 or 0.5
		local var_15_7 = var_0_49(arg_15_0.unit_extension_data, var_15_3, var_15_5, var_15_6, arg_15_2)
		local var_15_8 = var_0_28
		local var_15_9 = var_0_29
		local var_15_10 = var_0_30
		local var_15_11 = 0
		local var_15_12 = var_0_26
		local var_15_13 = 2
		local var_15_14 = LocomotionUtils.new_random_goal_uniformly_distributed_with_inside_from_outside_on_last
		local var_15_15 = var_15_7 and var_15_14(var_15_5, nil, var_15_7, var_15_11, var_15_12, var_15_13, nil, var_15_8, var_15_9, var_15_10) or nil
		local var_15_16 = (var_15_15 and math.abs(var_15_0.z - var_15_15.z) or 0) > var_0_36
		local var_15_17 = var_15_15 and var_0_10(var_15_15, var_15_0) or math.huge
		local var_15_18 = var_15_17 < 5

		var_15_4 = var_15_15

		if var_15_16 and var_15_18 then
			var_15_4 = nil
		end

		var_15_1.wait_slot_distance = var_15_17
		var_15_1.improve_wait_slot_position_t = arg_15_2 + Math.random() * 0.4
	else
		return
	end

	if not var_15_4 then
		return
	end

	local var_15_19 = var_0_9(var_15_0, var_15_4)
	local var_15_20 = ScriptUnit.extension(arg_15_1, "ai_navigation_system")
	local var_15_21 = var_15_20:destination()

	if var_15_19 > 1 or var_0_15(var_15_4 - var_15_0, var_15_21 - var_15_0) < 0 then
		var_15_20:move_to(var_15_4)
	end
end

function AISlotSystem.ai_unit_have_slot(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0.unit_extension_data[arg_16_1]

	if not var_16_0 then
		return false
	end

	if not var_16_0.slot then
		return false
	end

	return true
end

function AISlotSystem.ai_unit_have_wait_slot(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0.unit_extension_data[arg_17_1]

	if not var_17_0 then
		return false
	end

	if not var_17_0.waiting_on_slot then
		return false
	end

	return true
end

function AISlotSystem.ai_unit_wait_slot_distance(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0.unit_extension_data[arg_18_1]

	if not var_18_0 then
		return math.huge
	end

	if var_18_0.slot then
		return math.huge
	end

	if not var_18_0.waiting_on_slot then
		return math.huge
	end

	return var_18_0.wait_slot_distance or math.huge
end

function AISlotSystem.ai_unit_slot_position(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0.unit_extension_data[arg_19_1]

	if not var_19_0 then
		return nil
	end

	local var_19_1 = var_19_0.slot or var_19_0.waiting_on_slot

	if var_19_1 then
		return var_19_1.absolute_position:unbox()
	end

	return nil
end

function AISlotSystem.ai_unit_blocked_attack(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0.unit_extension_data[arg_20_1]

	if not var_20_0 or var_20_0.waiting_on_slot then
		return nil
	end

	if not var_20_0.slot then
		return nil
	end

	local var_20_1 = var_20_0.slot_template

	if var_20_1.abandon_slot_when_blocked then
		if var_20_1.abandon_slot_when_blocked_time then
			var_20_0.delayed_prioritized_ai_unit_update_time = Managers.time:time("game") + var_20_1.abandon_slot_when_blocked_time
		else
			var_0_24(arg_20_1, arg_20_0.unit_extension_data)
			arg_20_0:register_prioritized_ai_unit_update(arg_20_1)
		end
	end
end

function AISlotSystem.ai_unit_staggered(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0.unit_extension_data[arg_21_1]

	if not var_21_0 or var_21_0.waiting_on_slot then
		return nil
	end

	if not var_21_0.slot then
		return nil
	end

	local var_21_1 = var_21_0.slot_template

	if var_21_1.abandon_slot_when_staggered then
		if var_21_1.abandon_slot_when_staggered_time then
			var_21_0.delayed_prioritized_ai_unit_update_time = Managers.time:time("game") + var_21_1.abandon_slot_when_staggered_time
		else
			var_0_24(arg_21_1, arg_21_0.unit_extension_data)
			arg_21_0:register_prioritized_ai_unit_update(arg_21_1)
		end
	end
end

function AISlotSystem.get_target_unit_slot_data(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_0.unit_extension_data[arg_22_1].all_slots[arg_22_2]

	if not var_22_0 then
		return
	end

	return var_22_0.slots
end

function AISlotSystem.slots_count(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = arg_23_0.unit_extension_data[arg_23_1]
	local var_23_1 = arg_23_2 or var_0_0

	return var_23_0.all_slots[var_23_1].slots_count
end

function AISlotSystem.total_slots_count(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_0.unit_extension_data[arg_24_1]
	local var_24_1 = arg_24_2 or var_0_0

	return var_24_0.all_slots[var_24_1].total_slots_count
end

function AISlotSystem.disabled_slots_count(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_0.unit_extension_data[arg_25_1]
	local var_25_1 = arg_25_2 or var_0_0

	return var_25_0.all_slots[var_25_1].disabled_slots_count
end

function AISlotSystem.set_release_slot_lock(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = arg_26_0.unit_extension_data[arg_26_1]

	if var_26_0 then
		var_26_0.release_slot_lock = arg_26_2
	end
end

local function var_0_51(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	local var_27_0 = arg_27_3[arg_27_1]

	if var_27_0.slot and var_27_0.slot.target_unit ~= arg_27_0 then
		var_0_24(arg_27_1, arg_27_3)
	end

	if not Unit.alive(arg_27_0) then
		var_27_0.target = nil

		var_27_0.target_position:store(0, 0, 0)

		if var_27_0.slot then
			var_0_24(arg_27_1, arg_27_3)
		end

		return
	end

	local var_27_1 = POSITION_LOOKUP[arg_27_0]

	var_27_0.target_position:store(var_27_1)
end

local var_0_52 = Quaternion.rotate

local function var_0_53(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	local var_28_0 = var_0_14(var_0_16(arg_28_1 - arg_28_0))
	local var_28_1 = Quaternion(-Vector3.up(), arg_28_2)

	return arg_28_0 + var_0_52(var_28_1, var_28_0) * arg_28_3
end

local function var_0_54(arg_29_0, arg_29_1)
	local var_29_0 = arg_29_1.position:unbox()
	local var_29_1 = arg_29_0.original_absolute_position:unbox()
	local var_29_2 = arg_29_0.type
	local var_29_3 = var_0_3[var_29_2].distance
	local var_29_4 = arg_29_0.radians
	local var_29_5 = var_0_53(var_29_0, var_29_1, var_29_4, var_29_3)
	local var_29_6 = var_0_53(var_29_0, var_29_1, -var_29_4, var_29_3)

	arg_29_0.position_right:store(var_29_5)
	arg_29_0.position_left:store(var_29_6)
end

local function var_0_55(arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = arg_30_2.position:unbox()
	local var_30_1 = var_0_14(var_0_16(arg_30_1 - var_30_0))

	arg_30_0.absolute_position:store(arg_30_1)
	arg_30_0.queue_direction:store(var_30_1)
	var_0_54(arg_30_0, arg_30_2)
end

function get_slot_position_on_navmesh(arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5, arg_31_6, arg_31_7, arg_31_8)
	local var_31_0 = arg_31_3 and var_0_53(arg_31_1, arg_31_2, arg_31_3, arg_31_4) or arg_31_2
	local var_31_1 = arg_31_5 and var_0_50(arg_31_0, var_31_0, arg_31_1) or var_31_0

	return var_0_44(var_31_1, arg_31_6, arg_31_7, arg_31_8), var_31_0
end

local function var_0_56(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6)
	local var_32_0
	local var_32_1 = 10
	local var_32_2 = 0.15

	if arg_32_2 then
		local var_32_3 = Quaternion(-Vector3.up(), arg_32_2)

		arg_32_1 = var_0_52(var_32_3, arg_32_1)
	end

	for iter_32_0 = 0, var_32_1 - 1 do
		local var_32_4 = arg_32_0 + arg_32_1 * (iter_32_0 * var_32_2 + arg_32_3)

		var_32_0 = var_0_44(var_32_4, arg_32_4, arg_32_5, arg_32_6)

		if var_32_0 then
			break
		end
	end

	return var_32_0, var_32_0
end

local function var_0_57(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5, arg_33_6, arg_33_7, arg_33_8, arg_33_9, arg_33_10)
	local var_33_0, var_33_1 = get_slot_position_on_navmesh(arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5, arg_33_6, arg_33_7, arg_33_9, arg_33_10)
	local var_33_2 = arg_33_0.position_check_index
	local var_33_3 = var_33_2 == var_0_6.CHECK_MIDDLE
	local var_33_4 = not var_33_3 and var_0_8[var_33_2] or nil
	local var_33_5 = var_0_39

	if var_33_0 then
		local var_33_6

		if var_33_3 then
			var_33_6 = var_33_0
		else
			var_33_6 = var_0_53(var_33_0, arg_33_2, var_33_4, var_0_5)
		end

		local var_33_7 = arg_33_2 + var_0_14(var_33_6 - arg_33_2) * var_33_5

		if not var_0_43(arg_33_7, var_33_6, var_33_7, arg_33_8) then
			var_33_0 = nil
		end
	elseif not var_33_3 then
		local var_33_8 = var_0_53(arg_33_3, arg_33_2, var_33_4, var_0_5)

		var_33_0, var_33_1 = get_slot_position_on_navmesh(arg_33_1, arg_33_2, var_33_8, arg_33_4, arg_33_5, arg_33_6, arg_33_7, arg_33_9, arg_33_10)

		if var_33_0 then
			local var_33_9 = arg_33_2 + var_0_14(var_33_0 - arg_33_2) * var_33_5

			if var_0_43(arg_33_7, var_33_0, var_33_9, arg_33_8) then
				arg_33_0.position_check_index = var_0_6.CHECK_MIDDLE
			else
				var_33_0 = nil
			end
		end
	end

	if not var_33_0 then
		arg_33_0.position_check_index = (arg_33_0.position_check_index + 1) % var_0_7
	end

	return var_33_0, var_33_1
end

local function var_0_58(arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = arg_34_0.target_unit
	local var_34_1 = arg_34_0.absolute_position:unbox()
	local var_34_2 = #arg_34_1

	for iter_34_0 = 1, var_34_2 do
		repeat
			local var_34_3 = arg_34_1[iter_34_0]

			if var_34_3 == var_34_0 then
				break
			end

			local var_34_4 = arg_34_2[var_34_3].all_slots

			for iter_34_1 = 1, var_0_18 do
				local var_34_5 = var_0_17[iter_34_1]
				local var_34_6 = var_34_4[var_34_5]
				local var_34_7 = var_0_3[var_34_5].radius
				local var_34_8 = var_34_7 * var_34_7
				local var_34_9 = var_34_6.slots
				local var_34_10 = var_34_6.total_slots_count

				for iter_34_2 = 1, var_34_10 do
					repeat
						local var_34_11 = var_34_9[iter_34_2]

						if var_34_11.disabled then
							break
						end

						local var_34_12 = var_34_11.absolute_position:unbox()

						if var_34_8 > var_0_9(var_34_1, var_34_12) then
							return var_34_11
						end
					until true
				end
			end
		until true
	end

	return false
end

local function var_0_59(arg_35_0, arg_35_1)
	local var_35_0 = arg_35_0.absolute_position:unbox()
	local var_35_1 = arg_35_0.type
	local var_35_2 = arg_35_1[arg_35_0.target_unit].all_slots
	local var_35_3 = var_0_9

	for iter_35_0 = 1, var_0_18 do
		repeat
			local var_35_4 = var_0_17[iter_35_0]
			local var_35_5 = var_35_2[var_35_4]

			if var_35_1 == var_35_4 then
				break
			end

			local var_35_6 = var_0_3[var_35_4].radius
			local var_35_7 = var_35_6 * var_35_6
			local var_35_8 = var_35_5.slots
			local var_35_9 = var_35_5.total_slots_count

			for iter_35_1 = 1, var_35_9 do
				repeat
					local var_35_10 = var_35_8[iter_35_1]

					if var_35_10.disabled then
						break
					end

					if not var_35_10.ai_unit then
						break
					end

					local var_35_11 = var_35_10.absolute_position:unbox()
					local var_35_12 = var_35_10.priority

					if var_35_7 > var_35_3(var_35_0, var_35_11) then
						return var_35_10
					end
				until true
			end
		until true
	end

	return false
end

local var_0_60 = 1.2
local var_0_61 = var_0_60 * var_0_60

local function var_0_62(arg_36_0, arg_36_1, arg_36_2)
	local var_36_0 = arg_36_0.target_unit
	local var_36_1 = arg_36_0.absolute_position:unbox()
	local var_36_2 = #arg_36_1
	local var_36_3 = var_0_9

	for iter_36_0 = 1, var_36_2 do
		repeat
			local var_36_4 = arg_36_1[iter_36_0]

			if var_36_4 == var_36_0 then
				break
			end

			local var_36_5 = arg_36_2[var_36_4].position:unbox()

			if var_36_3(var_36_1, var_36_5) < var_0_61 then
				return true
			end
		until true
	end

	return false
end

local function var_0_63(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
	local var_37_0 = arg_37_0.priority
	local var_37_1 = arg_37_1.priority
	local var_37_2 = arg_37_2[arg_37_0.target_unit].index
	local var_37_3 = arg_37_0.index
	local var_37_4 = arg_37_2[arg_37_1.target_unit].index
	local var_37_5 = arg_37_1.index

	if var_37_0 < var_37_1 and not arg_37_0.ai_unit then
		return
	elseif var_37_1 < var_37_0 and not arg_37_1.ai_unit then
		return
	end

	if var_37_0 < var_37_1 then
		var_0_21(arg_37_1, arg_37_2)

		return false
	elseif var_37_1 < var_37_0 then
		var_0_21(arg_37_0, arg_37_2)

		return true
	end

	if var_37_5 < var_37_3 then
		var_0_21(arg_37_0, arg_37_2)

		return true
	end

	if var_37_3 < var_37_5 then
		var_0_21(arg_37_1, arg_37_2)

		return false
	end

	if var_37_4 < var_37_2 then
		var_0_21(arg_37_0, arg_37_2)

		return true
	else
		var_0_21(arg_37_1, arg_37_2)

		return false
	end
end

local function var_0_64(arg_38_0, arg_38_1, arg_38_2)
	local var_38_0 = arg_38_0.original_absolute_position:unbox()
	local var_38_1 = POSITION_LOOKUP[arg_38_1]
	local var_38_2 = arg_38_0.target_unit
	local var_38_3 = arg_38_2.position:unbox()
	local var_38_4 = var_0_16(var_38_0 - var_38_3)
	local var_38_5 = var_0_14(var_38_4)
	local var_38_6 = var_0_16(var_38_1 - var_38_3)
	local var_38_7 = var_0_14(var_38_6)
	local var_38_8 = var_0_15(var_38_5, var_38_7)

	return var_38_8 < 0.6, var_38_8
end

local function var_0_65(arg_39_0)
	arg_39_0.ghost_position:store(Vector3(0, 0, 0))
end

local var_0_66 = 90
local var_0_67 = math.degrees_to_radians(var_0_66)

local function var_0_68(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
	local var_40_0 = arg_40_1.absolute_position:unbox()
	local var_40_1 = arg_40_1.ai_unit
	local var_40_2 = POSITION_LOOKUP[var_40_1]
	local var_40_3 = arg_40_0.position:unbox()
	local var_40_4 = math.min(var_0_10(var_40_3, var_40_2), 8)
	local var_40_5 = var_0_53(var_40_0, var_40_2, -var_0_67, var_40_4)
	local var_40_6 = var_0_53(var_40_0, var_40_2, var_0_67, var_40_4)
	local var_40_7 = var_0_9(var_40_3, var_40_5) > var_0_9(var_40_3, var_40_6) and var_40_5 or var_40_6
	local var_40_8 = var_0_44(var_40_7, arg_40_2)
	local var_40_9

	if var_40_8 then
		var_40_9 = var_0_14(var_40_8 - var_40_0)
	else
		var_40_9 = var_0_14(var_40_7 - var_40_0)
	end

	local var_40_10 = 5

	for iter_40_0 = 1, var_40_10 do
		if var_40_8 and var_0_43(arg_40_2, var_40_8, var_40_0, arg_40_3) then
			arg_40_1.ghost_position:store(var_40_8)

			return
		end

		local var_40_11 = arg_40_1.type
		local var_40_12 = var_0_3[var_40_11].distance
		local var_40_13 = var_40_3 + var_40_9 * (var_40_12 + (var_40_4 - var_40_12) * (var_40_10 - iter_40_0) / var_40_10)

		var_40_8 = var_0_44(var_40_13, arg_40_2)
	end

	var_0_65(arg_40_1)
end

local function var_0_69(arg_41_0, arg_41_1, arg_41_2)
	local var_41_0 = arg_41_2[arg_41_1]
	local var_41_1 = arg_41_0.type
	local var_41_2 = var_41_0.all_slots[var_41_1]
	local var_41_3 = var_41_2.slots
	local var_41_4 = arg_41_0.index
	local var_41_5 = var_41_2.total_slots_count
	local var_41_6 = 128

	arg_41_0.anchor_weight = arg_41_0.ai_unit and not arg_41_0.released and 256 or 0

	for iter_41_0 = 1, var_41_5 do
		local var_41_7 = var_41_4 + iter_41_0

		if var_41_5 < var_41_7 then
			var_41_7 = var_41_7 - var_41_5
		end

		local var_41_8 = var_41_3[var_41_7]
		local var_41_9 = var_41_8.disabled
		local var_41_10 = var_41_8.released
		local var_41_11 = var_41_8.ai_unit

		if var_41_9 or not var_41_11 then
			break
		end

		if not var_41_10 then
			arg_41_0.anchor_weight = arg_41_0.anchor_weight + var_41_6
			var_41_6 = var_41_6 / 2
		end
	end

	local var_41_12 = 128

	for iter_41_1 = 1, var_41_5 do
		local var_41_13 = var_41_4 - iter_41_1

		if var_41_13 < 1 then
			var_41_13 = var_41_13 + var_41_5
		end

		local var_41_14 = var_41_3[var_41_13]
		local var_41_15 = var_41_14.disabled
		local var_41_16 = var_41_14.released
		local var_41_17 = var_41_14.ai_unit

		if var_41_15 or not var_41_17 then
			break
		end

		if not var_41_16 then
			arg_41_0.anchor_weight = arg_41_0.anchor_weight + var_41_12
			var_41_12 = var_41_12 / 2
		end
	end
end

local function var_0_70(arg_42_0, arg_42_1)
	local var_42_0 = arg_42_1[arg_42_0].all_slots

	for iter_42_0 = 1, var_0_18 do
		local var_42_1 = var_42_0[var_0_17[iter_42_0]]
		local var_42_2 = var_42_1.slots
		local var_42_3 = var_42_1.total_slots_count

		for iter_42_1 = 1, var_42_3 do
			local var_42_4 = var_42_2[iter_42_1]

			var_0_69(var_42_4, arg_42_0, arg_42_1)
		end
	end
end

local var_0_71 = 3
local var_0_72 = var_0_71 * var_0_71

local function var_0_73(arg_43_0, arg_43_1)
	if arg_43_0.disabled then
		return
	end

	local var_43_0 = arg_43_0.ai_unit

	if not var_43_0 then
		arg_43_0.released = false

		return
	end

	if not arg_43_1[var_43_0].release_slot_lock then
		local var_43_1 = POSITION_LOOKUP[var_43_0]
		local var_43_2 = arg_43_0.absolute_position:unbox()

		arg_43_0.released = var_0_9(var_43_1, var_43_2) > var_0_72
	else
		arg_43_0.released = false
	end
end

local function var_0_74(arg_44_0, arg_44_1, arg_44_2)
	local var_44_0 = arg_44_2[arg_44_1].all_slots[arg_44_0]
	local var_44_1 = var_44_0.slots
	local var_44_2 = var_44_0.total_slots_count
	local var_44_3 = var_44_1[1]
	local var_44_4 = var_44_3.anchor_weight

	for iter_44_0 = 1, var_44_2 do
		repeat
			local var_44_5 = var_44_1[iter_44_0]

			if var_44_5.disabled then
				break
			end

			local var_44_6 = var_44_5.anchor_weight

			if var_44_4 < var_44_6 or var_44_6 == var_44_4 and var_44_5.index < var_44_3.index then
				var_44_3 = var_44_5
				var_44_4 = var_44_6
			end
		until true
	end

	return var_44_3
end

local var_0_75 = 24

local function var_0_76(arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6, arg_45_7)
	local var_45_0 = arg_45_0.target_unit
	local var_45_1 = arg_45_1[var_45_0]
	local var_45_2 = var_45_1.position:unbox()
	local var_45_3 = arg_45_0.ai_unit
	local var_45_4 = var_45_3 and POSITION_LOOKUP[var_45_3]
	local var_45_5 = var_45_3 and var_0_14(var_45_4 - var_45_2) or Vector3.forward()
	local var_45_6 = arg_45_0.type
	local var_45_7 = var_0_3[var_45_6].distance
	local var_45_8 = var_45_2 + var_45_5 * var_45_7
	local var_45_9
	local var_45_10

	if arg_45_7 then
		var_45_9, var_45_10 = var_0_56(var_45_2, var_45_5, nil, var_45_7, arg_45_3, arg_45_5, arg_45_6)
	else
		var_45_9, var_45_10 = var_0_57(arg_45_0, var_45_0, var_45_2, var_45_8, nil, nil, arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6)
	end

	local var_45_11 = 0

	while var_45_11 <= var_0_75 and not var_45_9 do
		local var_45_12 = var_45_11 % 2 > 0 and -1 or 1
		local var_45_13 = math.ceil(var_45_11 / 2) * var_45_12

		if arg_45_7 then
			var_45_9, var_45_10 = var_0_56(var_45_2, var_45_5, var_45_13, var_45_7, arg_45_3, arg_45_5, arg_45_6)
		else
			var_45_9, var_45_10 = var_0_57(arg_45_0, var_45_0, var_45_2, var_45_8, var_45_13, var_45_7, arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6)
		end

		var_45_11 = var_45_11 + 1
	end

	if var_45_9 then
		arg_45_0.original_absolute_position:store(var_45_10)
		var_0_55(arg_45_0, var_45_9, var_45_1)

		return true, var_45_9
	else
		arg_45_0.original_absolute_position:store(var_45_8)
		var_0_55(arg_45_0, var_45_8, var_45_1)

		return false, var_45_8
	end
end

local function var_0_77(arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4, arg_46_5, arg_46_6, arg_46_7, arg_46_8, arg_46_9)
	local var_46_0 = arg_46_3[arg_46_0]
	local var_46_1 = var_46_0.position:unbox()
	local var_46_2
	local var_46_3
	local var_46_4 = arg_46_1.type
	local var_46_5 = var_0_3[var_46_4].distance

	if arg_46_9 then
		var_46_2, var_46_3 = var_0_56(var_46_1, var_0_14(arg_46_2 - var_46_1), nil, var_46_5, arg_46_5, arg_46_7, arg_46_8)
	else
		var_46_2, var_46_3 = var_0_57(arg_46_1, arg_46_0, var_46_1, arg_46_2, nil, nil, arg_46_4, arg_46_5, arg_46_6, arg_46_7, arg_46_8)
	end

	if var_46_2 then
		arg_46_1.original_absolute_position:store(var_46_3)
		var_0_55(arg_46_1, var_46_2, var_46_0)

		return true, var_46_2
	else
		arg_46_1.original_absolute_position:store(arg_46_2)
		var_0_55(arg_46_1, arg_46_2, var_46_0)

		return false, arg_46_2
	end
end

local function var_0_78(arg_47_0, arg_47_1)
	local var_47_0 = arg_47_1[arg_47_0].all_slots

	for iter_47_0, iter_47_1 in pairs(var_47_0) do
		local var_47_1 = iter_47_1.slots
		local var_47_2 = iter_47_1.total_slots_count

		for iter_47_2 = 1, var_47_2 do
			local var_47_3 = var_47_1[iter_47_2]

			var_0_21(var_47_3, arg_47_1)
		end
	end
end

local function var_0_79(arg_48_0, arg_48_1, arg_48_2, arg_48_3)
	if arg_48_1 then
		var_0_22(arg_48_0)
	else
		var_0_21(arg_48_0, arg_48_3)

		return false
	end

	if not var_0_62(arg_48_0, arg_48_2, arg_48_3) then
		var_0_22(arg_48_0)
	else
		var_0_21(arg_48_0, arg_48_3)

		return false
	end

	local var_48_0 = var_0_58(arg_48_0, arg_48_2, arg_48_3)

	if var_48_0 then
		if not var_0_63(arg_48_0, var_48_0, arg_48_3) then
			var_0_22(arg_48_0)
		else
			return false
		end
	end

	local var_48_1 = var_0_59(arg_48_0, arg_48_3)

	if var_48_1 then
		if not var_0_63(arg_48_0, var_48_1, arg_48_3) then
			var_0_22(arg_48_0)
		else
			return false
		end
	end

	var_0_73(arg_48_0, arg_48_3)

	return true
end

local function var_0_80(arg_49_0, arg_49_1, arg_49_2, arg_49_3, arg_49_4, arg_49_5, arg_49_6)
	local var_49_0 = arg_49_2[arg_49_0]
	local var_49_1 = var_49_0.all_slots

	for iter_49_0 = 1, var_0_18 do
		local var_49_2 = var_0_17[iter_49_0]
		local var_49_3 = var_49_1[var_49_2]
		local var_49_4 = var_49_3.slots
		local var_49_5 = var_49_3.total_slots_count
		local var_49_6 = false

		for iter_49_1 = 1, var_49_5 do
			local var_49_7 = var_49_4[iter_49_1]
			local var_49_8 = var_49_7.absolute_position:unbox()
			local var_49_9 = var_0_77(arg_49_0, var_49_7, var_49_8, arg_49_2, var_49_6, arg_49_3, arg_49_4, nil, nil, arg_49_5)

			var_0_79(var_49_7, var_49_9, arg_49_1, arg_49_2)
		end

		var_0_70(arg_49_0, arg_49_2)

		local var_49_10 = var_49_3.disabled_slots_count
		local var_49_11 = var_49_0.num_occupied_slots >= var_49_5 - var_49_10

		if var_49_11 and not var_49_0.full_slots_at_t[var_49_2] then
			var_49_0.full_slots_at_t[var_49_2] = arg_49_6
		elseif not var_49_11 then
			var_49_0.full_slots_at_t[var_49_2] = nil
		end
	end
end

local function var_0_81(arg_50_0, arg_50_1, arg_50_2, arg_50_3, arg_50_4, arg_50_5, arg_50_6, arg_50_7, arg_50_8)
	local var_50_0 = arg_50_2[arg_50_0]
	local var_50_1 = var_50_0.all_slots

	for iter_50_0, iter_50_1 in pairs(var_50_1) do
		local var_50_2 = iter_50_1.slots
		local var_50_3 = iter_50_1.total_slots_count
		local var_50_4 = 1
		local var_50_5 = var_0_14(var_0_16(Quaternion.forward(Unit.world_rotation(arg_50_6, 0))))
		local var_50_6 = Vector3.cross(var_50_5, Vector3.up())
		local var_50_7 = math.floor(var_50_3 / 2)
		local var_50_8 = math.ceil(var_50_7 / 2)
		local var_50_9 = var_50_2[var_50_8]

		var_50_9.original_absolute_position:store(arg_50_8)
		var_0_55(var_50_9, arg_50_8, var_50_0)
		var_0_79(var_50_9, true, arg_50_1, arg_50_2)

		local var_50_10 = arg_50_8
		local var_50_11 = true

		for iter_50_2 = var_50_8 - 1, 1, -1 do
			local var_50_12 = var_50_2[iter_50_2]
			local var_50_13 = var_50_10 - var_50_6 * var_50_4

			var_50_11 = var_50_11 and var_0_43(arg_50_4, var_50_10, var_50_13, arg_50_5)

			var_50_12.original_absolute_position:store(var_50_13)
			var_0_55(var_50_12, var_50_13, var_50_0)
			var_0_79(var_50_12, var_50_11, arg_50_1, arg_50_2)

			var_50_10 = var_50_13
		end

		local var_50_14 = arg_50_8
		local var_50_15 = true

		for iter_50_3 = var_50_8 + 1, var_50_7 do
			local var_50_16 = var_50_2[iter_50_3]
			local var_50_17 = var_50_14 + var_50_6 * var_50_4

			var_50_15 = var_50_15 and var_0_43(arg_50_4, var_50_14, var_50_17, arg_50_5)

			var_50_16.original_absolute_position:store(var_50_17)
			var_0_55(var_50_16, var_50_17, var_50_0)
			var_0_79(var_50_16, var_50_15, arg_50_1, arg_50_2)
		end

		local var_50_18 = var_50_7 + math.ceil((var_50_3 - var_50_7) / 2)
		local var_50_19 = var_50_2[var_50_18]

		var_50_19.original_absolute_position:store(arg_50_7)
		var_0_55(var_50_19, arg_50_7, var_50_0)
		var_0_79(var_50_19, true, arg_50_1, arg_50_2)

		local var_50_20 = arg_50_7
		local var_50_21 = 1
		local var_50_22 = 1
		local var_50_23 = 1
		local var_50_24 = arg_50_7 + var_50_23 * var_50_5
		local var_50_25 = var_50_18 - 1 - var_50_7
		local var_50_26 = math.pi / 2.5 / var_50_25
		local var_50_27 = 1

		for iter_50_4 = var_50_18 - 1, var_50_7 + 1, -1 do
			local var_50_28 = var_50_2[iter_50_4]
			local var_50_29 = math.pi * 1.5 + var_50_27 * var_50_26
			local var_50_30 = var_50_24 + var_50_23 * (var_50_6 * math.cos(var_50_29) + var_50_5 * math.sin(var_50_29))
			local var_50_31
			local var_50_32, var_50_33 = var_0_41(arg_50_4, var_50_20, var_50_21, var_50_22)

			if var_50_32 then
				var_50_30.z = var_50_33
			end

			var_50_28.original_absolute_position:store(var_50_30)
			var_0_55(var_50_28, var_50_30, var_50_0)
			var_0_79(var_50_28, var_50_32, arg_50_1, arg_50_2)

			var_50_27 = var_50_27 + 1
		end

		local var_50_34 = var_50_3 - var_50_18
		local var_50_35 = math.pi / 2.5 / var_50_34
		local var_50_36 = 1
		local var_50_37 = arg_50_7

		for iter_50_5 = var_50_18 + 1, var_50_3 do
			local var_50_38 = var_50_2[iter_50_5]
			local var_50_39 = math.pi * 1.5 - var_50_36 * var_50_35
			local var_50_40 = var_50_24 + var_50_23 * (var_50_6 * math.cos(var_50_39) + var_50_5 * math.sin(var_50_39))
			local var_50_41
			local var_50_42, var_50_43 = var_0_41(arg_50_4, var_50_37, var_50_21, var_50_22)

			if var_50_42 then
				var_50_40.z = var_50_43
			end

			var_50_38.original_absolute_position:store(var_50_40)
			var_0_55(var_50_38, var_50_40, var_50_0)
			var_0_79(var_50_38, var_50_42, arg_50_1, arg_50_2)

			var_50_36 = var_50_36 + 1
		end

		var_0_70(arg_50_0, arg_50_2)
	end
end

local function var_0_82(arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4, arg_51_5, arg_51_6, arg_51_7, arg_51_8, arg_51_9, arg_51_10)
	if arg_51_6 then
		var_0_81(arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4, arg_51_5, arg_51_7, arg_51_8, arg_51_9)

		return
	end

	local var_51_0
	local var_51_1

	if arg_51_10 then
		var_51_0, var_51_1 = var_0_32, var_0_31
	else
		var_51_0, var_51_1 = var_0_36, var_0_37
	end

	local var_51_2 = arg_51_2[arg_51_0].all_slots

	for iter_51_0 = 1, var_0_18 do
		local var_51_3 = var_0_17[iter_51_0]
		local var_51_4 = var_51_2[var_51_3]
		local var_51_5 = var_51_4.slots
		local var_51_6 = var_0_74(var_51_3, arg_51_0, arg_51_2)
		local var_51_7 = var_51_4.total_slots_count
		local var_51_8 = var_51_6.index
		local var_51_9 = var_0_76(var_51_6, arg_51_2, arg_51_3, arg_51_4, arg_51_5, var_51_0, var_51_1, arg_51_10)

		var_0_79(var_51_6, var_51_9, arg_51_1, arg_51_2)

		for iter_51_1 = var_51_8 + 1, var_51_7 do
			local var_51_10 = var_51_5[iter_51_1]
			local var_51_11 = var_51_5[iter_51_1 - 1].position_right:unbox()
			local var_51_12 = var_0_77(arg_51_0, var_51_10, var_51_11, arg_51_2, arg_51_3, arg_51_4, arg_51_5, var_51_0, var_51_1, arg_51_10)

			var_0_79(var_51_10, var_51_12, arg_51_1, arg_51_2)
		end

		for iter_51_2 = var_51_8 - 1, 1, -1 do
			local var_51_13 = var_51_5[iter_51_2]
			local var_51_14 = var_51_5[iter_51_2 + 1].position_left:unbox()
			local var_51_15 = var_0_77(arg_51_0, var_51_13, var_51_14, arg_51_2, arg_51_3, arg_51_4, arg_51_5, var_51_0, var_51_1, arg_51_10)

			var_0_79(var_51_13, var_51_15, arg_51_1, arg_51_2)
		end

		var_0_70(arg_51_0, arg_51_2)
	end

	var_0_70(arg_51_0, arg_51_2)
end

local var_0_83 = -3
local var_0_84 = -2

local function var_0_85(arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4, arg_52_5, arg_52_6)
	local var_52_0 = POSITION_LOOKUP[arg_52_2]
	local var_52_1 = arg_52_3[arg_52_2]
	local var_52_2 = arg_52_3[arg_52_0]
	local var_52_3 = var_52_1.use_slot_type or var_0_0
	local var_52_4 = var_52_2.all_slots[var_52_3]
	local var_52_5 = var_52_4.slots
	local var_52_6
	local var_52_7 = math.huge
	local var_52_8 = var_52_1.slot
	local var_52_9 = var_52_4.disabled_slots_count
	local var_52_10 = var_52_4.slots_count
	local var_52_11 = var_52_4.total_slots_count
	local var_52_12 = var_52_11 - var_52_9
	local var_52_13 = var_52_1.slot_template
	local var_52_14 = var_52_13.avoid_slots_behind_overwhelmed_target
	local var_52_15 = var_52_13 and var_52_14 and var_52_9 >= 2 and var_52_12 <= var_52_10

	for iter_52_0 = 1, var_52_11 do
		repeat
			local var_52_16 = var_52_5[iter_52_0]

			if var_52_16.disabled then
				break
			end

			if (arg_52_6 or var_52_15) and var_0_64(var_52_16, arg_52_2, var_52_2) then
				break
			end

			local var_52_17 = var_52_16.ai_unit
			local var_52_18 = var_52_16.released
			local var_52_19 = var_52_16.original_absolute_position:unbox()
			local var_52_20 = var_0_9(var_52_19, var_52_0)
			local var_52_21 = math.huge

			if var_52_17 then
				if var_52_17 == arg_52_2 then
					var_52_21 = var_52_20 + var_0_83
				elseif var_52_18 then
					local var_52_22 = POSITION_LOOKUP[var_52_17]

					if var_52_20 < var_0_9(var_52_19, var_52_22) + var_0_84 then
						var_52_21 = var_52_20
					end
				end
			else
				var_52_21 = var_52_20
			end

			if var_52_21 < var_52_7 then
				var_52_6 = var_52_16
				var_52_7 = var_52_21
			end
		until true
	end

	if var_52_6 then
		repeat
			var_52_1.temporary_wait_position = nil

			local var_52_23 = var_52_1.slot

			if var_52_23 and var_52_23 == var_52_6 then
				break
			end

			local var_52_24 = var_52_1.waiting_on_slot

			if var_52_23 or var_52_24 then
				var_0_24(arg_52_2, arg_52_3)
			end

			local var_52_25 = var_52_6.ai_unit

			if var_52_25 then
				arg_52_3[var_52_25].slot = nil

				Managers.state.debug_text:clear_unit_text(var_52_25, "slot_index")
			end

			var_52_6.ai_unit = arg_52_2
			var_52_1.slot = var_52_6

			var_0_70(arg_52_0, arg_52_3)
		until true
	end

	if var_52_8 ~= var_52_1.slot then
		var_52_4.slots_count = var_0_23(arg_52_0, arg_52_3, var_52_3)
	elseif not var_52_6 and var_52_8 and arg_52_6 and var_0_64(var_52_8, arg_52_2, var_52_2) then
		var_0_24(arg_52_2, arg_52_3)

		var_52_4.slots_count = var_0_23(arg_52_0, arg_52_3, var_52_3)

		local var_52_26 = ScriptUnit.extension_input(arg_52_2, "dialogue_system")
		local var_52_27 = FrameTable.alloc_table()

		var_52_26:trigger_networked_dialogue_event("flanking", var_52_27)
	end
end

SLOT_QUEUE_PENALTY_MULTIPLIER = 3

local function var_0_86(arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4, arg_53_5)
	local var_53_0 = arg_53_2[arg_53_1]
	local var_53_1 = var_53_0.waiting_on_slot
	local var_53_2 = arg_53_2[arg_53_0]
	local var_53_3 = var_53_0.use_slot_type or var_0_0
	local var_53_4 = var_53_2.all_slots[var_53_3]
	local var_53_5 = var_53_4.disabled_slots_count
	local var_53_6 = var_53_4.slots_count
	local var_53_7 = var_53_4.total_slots_count - var_53_5
	local var_53_8 = var_53_0.slot_template
	local var_53_9 = var_53_8.avoid_slots_behind_overwhelmed_target
	local var_53_10 = var_53_8 and var_53_9 and var_53_5 >= 2 and var_53_7 <= var_53_6

	if var_53_1 then
		if (arg_53_4 or var_53_10) and var_0_64(var_53_1, arg_53_1, var_53_2) then
			var_0_24(arg_53_1, arg_53_2)
		else
			return
		end
	end

	local var_53_11 = POSITION_LOOKUP[arg_53_1]
	local var_53_12 = math.huge
	local var_53_13
	local var_53_14 = var_53_2.all_slots

	for iter_53_0 = 1, var_0_18 do
		local var_53_15 = var_53_14[var_0_17[iter_53_0]]
		local var_53_16 = var_53_15.slots
		local var_53_17 = var_53_15.total_slots_count

		for iter_53_1 = 1, var_53_17 do
			repeat
				local var_53_18 = var_53_16[iter_53_1]
				local var_53_19 = #var_53_18.queue
				local var_53_20 = 0

				if (arg_53_4 or var_53_10) and var_0_64(var_53_18, arg_53_1, var_53_2) then
					var_53_20 = 100
				end

				local var_53_21, var_53_22 = var_0_49(arg_53_2, var_53_18, arg_53_3, nil, arg_53_5)

				if not var_53_21 then
					break
				end

				local var_53_23 = var_0_9(var_53_21, var_53_11) + var_53_19 * var_53_19 * SLOT_QUEUE_PENALTY_MULTIPLIER + var_53_22 + var_53_20

				if var_53_23 < var_53_12 then
					var_53_12 = var_53_23
					var_53_13 = var_53_18
				end
			until true
		end
	end

	if var_53_13 then
		local var_53_24 = var_53_13.queue

		var_53_24[#var_53_24 + 1] = arg_53_1
		var_53_0.waiting_on_slot = var_53_13
	end
end

local function var_0_87(arg_54_0, arg_54_1)
	local var_54_0 = #arg_54_0

	for iter_54_0 = 1, var_54_0 do
		local var_54_1 = arg_54_1[arg_54_0[iter_54_0]].all_slots

		for iter_54_1 = 1, var_0_18 do
			local var_54_2 = var_54_1[var_0_17[iter_54_1]]
			local var_54_3 = var_54_2.slots
			local var_54_4 = #var_54_3
			local var_54_5 = 0

			for iter_54_2 = 1, var_54_4 do
				if var_54_3[iter_54_2].disabled then
					var_54_5 = var_54_5 + 1
				end
			end

			var_54_2.disabled_slots_count = var_54_5
		end
	end
end

local function var_0_88(arg_55_0, arg_55_1, arg_55_2, arg_55_3)
	local var_55_0 = #arg_55_2
	local var_55_1 = arg_55_3
	local var_55_2 = Managers.player
	local var_55_3 = Managers.state.entity:system("audio_system")
	local var_55_4 = NetworkLookup.global_parameter_names.occupied_slots_percentage

	for iter_55_0 = 1, var_55_0 do
		local var_55_5 = arg_55_2[iter_55_0]
		local var_55_6 = var_55_1[var_55_5].all_slots
		local var_55_7 = var_55_2:owner(var_55_5)
		local var_55_8 = arg_55_0 and var_55_7 and var_55_7:is_player_controlled()
		local var_55_9 = 0

		for iter_55_1 = 1, var_0_18 do
			local var_55_10 = var_0_17[iter_55_1]
			local var_55_11 = var_55_6[var_55_10]
			local var_55_12 = var_0_3[var_55_10].dialogue_surrounded_count
			local var_55_13 = var_55_11.slots_count

			if var_55_8 then
				local var_55_14 = var_55_11.disabled_slots_count
				local var_55_15 = var_55_11.total_slots_count - var_55_14
				local var_55_16 = var_55_15 > 0 and var_55_13 / var_55_15 or 0
				local var_55_17 = math.clamp(var_55_16, 0, 1)

				if var_55_9 < var_55_17 then
					var_55_9 = var_55_17
				end
			end

			if var_55_12 <= var_55_13 and ScriptUnit.has_extension(var_55_5, "dialogue_system") then
				local var_55_18 = ScriptUnit.extension_input(var_55_5, "dialogue_system")
				local var_55_19 = FrameTable.alloc_table()

				var_55_19.current_amount = var_55_13
				var_55_19.has_shield = Managers.state.entity:system("dialogue_system"):player_shield_check(var_55_5)

				var_55_18:trigger_networked_dialogue_event("surrounded", var_55_19)
			end
		end

		if var_55_8 then
			if var_55_7.local_player then
				var_55_3:set_global_parameter_with_lerp("occupied_slots_percentage", var_55_9 * 100)
			else
				local var_55_20 = var_55_7:network_id()

				arg_55_1:send_rpc("rpc_client_audio_set_global_parameter_with_lerp", var_55_20, var_55_4, var_55_9)
			end
		end
	end
end

function AISlotSystem.update(arg_56_0, arg_56_1, arg_56_2, arg_56_3)
	if not script_data.navigation_thread_disabled then
		local var_56_0 = arg_56_0.nav_world

		GwNavWorld.join_async_update(var_56_0)

		NAVIGATION_RUNNING_IN_THREAD = false
	end
end

local var_0_89
local var_0_90
local var_0_91 = 0.5
local var_0_92 = 1
local var_0_93 = 1
local var_0_94 = 1
local var_0_95 = 5
local var_0_96 = 0.25

function AISlotSystem.physics_async_update(arg_57_0, arg_57_1, arg_57_2)
	arg_57_0.t = arg_57_2

	local var_57_0 = arg_57_0.target_units
	local var_57_1 = #var_57_0

	if var_57_1 == 0 then
		return
	end

	local var_57_2 = arg_57_0.nav_world
	local var_57_3 = arg_57_0.unit_extension_data

	for iter_57_0 = 1, var_57_1 do
		local var_57_4 = var_57_0[iter_57_0]
		local var_57_5 = var_57_3[var_57_4]

		if arg_57_0:update_target_slots(arg_57_2, var_57_4, var_57_0, var_57_3, var_57_5, var_57_2, arg_57_0._traverse_logic) then
			break
		end
	end

	if arg_57_2 > arg_57_0.next_total_slot_count_update then
		arg_57_0:update_total_slots_count(arg_57_2)

		arg_57_0.next_total_slot_count_update = arg_57_2 + var_0_92
	end

	if arg_57_2 > arg_57_0.next_disabled_slot_count_update then
		var_0_87(var_57_0, var_57_3)

		arg_57_0.next_disabled_slot_count_update = arg_57_2 + var_0_93
	end

	if arg_57_2 > arg_57_0.next_slot_sound_update then
		var_0_88(arg_57_0.is_server, arg_57_0.network_transmit, var_57_0, var_57_3)

		arg_57_0.next_slot_sound_update = arg_57_2 + var_0_94
	end

	local var_57_6 = arg_57_0.update_slots_ai_units_prioritized

	for iter_57_1, iter_57_2 in pairs(var_57_6) do
		arg_57_0:update_ai_unit_slot(iter_57_1, var_57_0, var_57_3, var_57_2, arg_57_2)

		var_57_6[iter_57_1] = nil
	end

	local var_57_7 = arg_57_0.update_slots_ai_units
	local var_57_8 = #var_57_7

	if var_57_8 < arg_57_0.current_ai_index then
		arg_57_0.current_ai_index = 1
	end

	local var_57_9 = arg_57_0.current_ai_index
	local var_57_10 = math.min(var_57_9 + var_0_25 - 1, var_57_8)

	arg_57_0.current_ai_index = var_57_10 + 1

	for iter_57_3 = var_57_9, var_57_10 do
		local var_57_11 = var_57_7[iter_57_3]

		arg_57_0:update_ai_unit_slot(var_57_11, var_57_0, var_57_3, var_57_2, arg_57_2)
	end
end

function AISlotSystem.update_ai_unit_slot(arg_58_0, arg_58_1, arg_58_2, arg_58_3, arg_58_4, arg_58_5)
	if not ALIVE[arg_58_1] then
		var_0_24(arg_58_1, arg_58_3)

		return
	end

	local var_58_0 = arg_58_3[arg_58_1]
	local var_58_1 = ScriptUnit.extension(arg_58_1, "ai_system"):blackboard()
	local var_58_2 = var_58_1.target_unit

	var_0_51(var_58_2, arg_58_1, var_58_1, arg_58_3, arg_58_5)

	if not var_58_2 then
		return
	end

	local var_58_3 = arg_58_3[var_58_2]

	if not var_58_3 then
		return
	end

	if not var_58_0.do_search then
		return
	end

	local var_58_4 = var_58_1.using_override_target

	var_0_85(var_58_2, arg_58_2, arg_58_1, arg_58_3, arg_58_4, arg_58_5, var_58_4)

	local var_58_5 = var_58_0.slot

	if var_58_5 then
		var_0_73(var_58_5, arg_58_3)

		if var_0_64(var_58_5, arg_58_1, var_58_3) then
			var_0_68(var_58_3, var_58_5, arg_58_4, arg_58_0._traverse_logic)
		else
			var_0_65(var_58_5)
		end
	else
		var_0_86(var_58_2, arg_58_1, arg_58_3, arg_58_4, var_58_4, arg_58_5)
	end

	if not var_58_1.disable_improve_slot_position then
		arg_58_0:improve_slot_position(arg_58_1, arg_58_5)
	end

	local var_58_6 = var_58_0.delayed_prioritized_ai_unit_update_time

	if var_58_6 and var_58_6 < arg_58_5 then
		var_0_24(arg_58_1, arg_58_3)
		arg_58_0:register_prioritized_ai_unit_update(arg_58_1)

		var_58_0.delayed_prioritized_ai_unit_update_time = nil
	end
end

function AISlotSystem.update_target_slots(arg_59_0, arg_59_1, arg_59_2, arg_59_3, arg_59_4, arg_59_5, arg_59_6, arg_59_7)
	local var_59_0 = 0
	local var_59_1
	local var_59_2
	local var_59_3
	local var_59_4
	local var_59_5 = arg_59_5.was_on_ladder
	local var_59_6 = ScriptUnit.has_extension(arg_59_2, "status_system")

	if var_59_6 then
		var_59_1, var_59_2 = var_59_6:get_is_on_ladder()

		if var_59_1 then
			local var_59_7
			local var_59_8

			var_59_3, var_59_4, var_59_8 = Managers.state.bot_nav_transition:get_ladder_coordinates(var_59_2)
			var_59_1 = not var_59_8
		end

		arg_59_5.was_on_ladder = var_59_1
	end

	local var_59_9 = Unit.local_position(arg_59_2, 0)
	local var_59_10 = var_59_1 and var_59_9 or get_target_pos_on_navmesh(var_59_9, arg_59_6)
	local var_59_11 = arg_59_5.position:unbox()
	local var_59_12 = arg_59_5.outside_navmesh_at_t
	local var_59_13 = false

	if var_59_10 then
		var_59_0 = var_0_9(var_59_10, var_59_11)
		arg_59_5.outside_navmesh_at_t = nil
	elseif var_59_12 == nil or arg_59_1 < var_59_12 + var_0_40 then
		if var_59_12 == nil then
			arg_59_5.outside_navmesh_at_t = arg_59_1
		end

		var_59_10 = var_59_11
	else
		var_59_13 = true
		var_59_10 = var_59_9
		var_59_0 = var_0_9(var_59_10, var_59_11)
	end

	if var_59_0 > var_0_33 or var_59_1 ~= var_59_5 or var_59_1 and arg_59_1 > arg_59_5.next_slot_status_update_at then
		local var_59_14 = true

		arg_59_5.position:store(var_59_10)
		var_0_82(arg_59_2, arg_59_3, arg_59_4, var_59_14, arg_59_6, arg_59_7, var_59_1, var_59_2, var_59_3, var_59_4, var_59_13)

		arg_59_5.moved_at = arg_59_1
		arg_59_5.next_slot_status_update_at = arg_59_1 + var_0_91

		return true
	end

	local var_59_15 = arg_59_5.moved_at
	local var_59_16 = ScriptUnit.has_extension(arg_59_2, "locomotion_system") and ScriptUnit.extension(arg_59_2, "locomotion_system")
	local var_59_17 = var_59_16 and var_0_13(var_59_16:current_velocity()) or 0

	if not var_59_1 and var_59_15 and arg_59_1 - var_59_15 > var_0_34 and (var_59_17 <= var_0_96 or arg_59_1 - var_59_15 > var_0_35) then
		local var_59_18 = false

		var_0_82(arg_59_2, arg_59_3, arg_59_4, var_59_18, arg_59_6, arg_59_7, var_59_1, var_59_2, var_59_3, var_59_4, var_59_13)

		arg_59_5.moved_at = nil
		arg_59_5.next_slot_status_update_at = arg_59_1 + var_0_91

		return true
	end

	if arg_59_1 > arg_59_5.next_slot_status_update_at then
		var_0_80(arg_59_2, arg_59_3, arg_59_4, arg_59_6, arg_59_7, var_59_13, arg_59_1)

		arg_59_5.next_slot_status_update_at = arg_59_1 + var_0_91

		return true
	end

	return false
end

function AISlotSystem.update_total_slots_count(arg_60_0, arg_60_1)
	local var_60_0 = arg_60_0.target_units
	local var_60_1 = #var_60_0
	local var_60_2 = arg_60_0.unit_extension_data
	local var_60_3 = 0
	local var_60_4 = 0

	for iter_60_0 = 1, var_60_1 do
		local var_60_5 = var_60_2[var_60_0[iter_60_0]]
		local var_60_6 = var_60_5.all_slots
		local var_60_7 = 0

		for iter_60_1 = 1, var_0_18 do
			local var_60_8 = var_60_6[var_0_17[iter_60_1]]

			var_60_3 = var_60_3 + var_60_8.slots_count

			local var_60_9 = var_60_8.slots
			local var_60_10 = var_60_8.total_slots_count

			for iter_60_2 = 1, var_60_10 do
				local var_60_11 = var_60_9[iter_60_2]

				if not var_60_11.released and var_60_11.ai_unit then
					var_60_7 = var_60_7 + 1
				end
			end
		end

		if var_60_7 >= var_60_5.delayed_num_occupied_slots then
			var_60_5.delayed_num_occupied_slots = var_60_7
			var_60_5.delayed_slot_decay_t = arg_60_1 + var_0_95
		elseif arg_60_1 >= var_60_5.delayed_slot_decay_t then
			var_60_5.delayed_num_occupied_slots = var_60_7
		end

		var_60_5.num_occupied_slots = var_60_7
		var_60_4 = var_60_4 + var_60_7
	end

	arg_60_0.num_total_enemies = var_60_3
	arg_60_0.num_occupied_slots = var_60_4
end

function AISlotSystem.register_prioritized_ai_unit_update(arg_61_0, arg_61_1)
	arg_61_0.update_slots_ai_units_prioritized[arg_61_1] = true
end

function AISlotSystem.prioritize_queued_units_on_slot(arg_62_0, arg_62_1)
	if arg_62_1 and arg_62_1.queue then
		local var_62_0 = arg_62_1.queue
		local var_62_1 = #var_62_0

		for iter_62_0 = 1, var_62_1 do
			local var_62_2 = var_62_0[iter_62_0]

			arg_62_0:register_prioritized_ai_unit_update(var_62_2)
		end
	end
end

local var_0_97 = 9
local var_0_98 = {}

function AISlotSystem.on_add_extension(arg_63_0, arg_63_1, arg_63_2, arg_63_3, arg_63_4)
	local var_63_0 = {}

	ScriptUnit.set_extension(arg_63_2, "ai_slot_system", var_63_0, var_0_98)

	arg_63_0.unit_extension_data[arg_63_2] = var_63_0

	if arg_63_3 == "AIPlayerSlotExtension" or arg_63_3 == "AIAggroableSlotExtension" then
		local var_63_1

		if arg_63_3 == "AIPlayerSlotExtension" then
			var_63_1 = arg_63_4.profile_index
		elseif arg_63_3 == "AIAggroableSlotExtension" then
			var_63_1 = var_0_97

			local var_63_2, var_63_3 = Managers.state.network:game_object_or_level_id(arg_63_2)

			if var_63_3 then
				POSITION_LOOKUP[arg_63_2] = Unit.world_position(arg_63_2, 0)
			end
		end

		var_63_0.all_slots = {}

		for iter_63_0, iter_63_1 in pairs(var_0_3) do
			local var_63_4 = iter_63_0 == "normal" and "ai_slots_count" or "ai_slots_count_" .. iter_63_0
			local var_63_5 = Unit.get_data(arg_63_2, var_63_4) or iter_63_1.count
			local var_63_6 = {
				total_slots_count = var_63_5,
				slot_radians = math.degrees_to_radians(360 / var_63_5)
			}

			var_63_6.slots_count = 0
			var_63_6.use_wait_slots = iter_63_1.use_wait_slots
			var_63_6.priority = iter_63_1.priority
			var_63_6.disabled_slots_count = 0
			var_63_6.slots = {}
			var_63_0.all_slots[iter_63_0] = var_63_6
		end

		local var_63_7 = #arg_63_0.target_units + 1

		var_63_0.dogpile = 0
		var_63_0.position = Vector3Box(POSITION_LOOKUP[arg_63_2])
		var_63_0.moved_at = 0
		var_63_0.next_slot_status_update_at = 0
		var_63_0.valid_target = true
		var_63_0.index = var_63_7
		var_63_0.debug_color_name = var_0_4[var_63_1][1]
		var_63_0.num_occupied_slots = 0
		var_63_0.has_slots_attached = true
		var_63_0.delayed_num_occupied_slots = 0
		var_63_0.delayed_slot_decay_t = 0
		var_63_0.full_slots_at_t = {}

		var_0_19(arg_63_2, var_63_0, var_63_1)

		arg_63_0.target_units[var_63_7] = arg_63_2

		local var_63_8 = arg_63_0.target_units
		local var_63_9 = arg_63_0.nav_world
		local var_63_10 = arg_63_0._traverse_logic
		local var_63_11 = arg_63_0.unit_extension_data

		arg_63_0:update_target_slots(0, arg_63_2, var_63_8, var_63_11, var_63_0, var_63_9, var_63_10)
	end

	if arg_63_3 == "AIEnemySlotExtension" then
		var_63_0.target = nil
		var_63_0.target_position = Vector3Box()
		var_63_0.improve_wait_slot_position_t = 0
		arg_63_0.update_slots_ai_units[#arg_63_0.update_slots_ai_units + 1] = arg_63_2
	end

	return var_63_0
end

function AISlotSystem.extensions_ready(arg_64_0, arg_64_1, arg_64_2, arg_64_3)
	if arg_64_3 == "AIEnemySlotExtension" then
		local var_64_0 = arg_64_0.unit_extension_data[arg_64_2]
		local var_64_1 = ScriptUnit.extension(arg_64_2, "ai_system"):breed()

		var_64_0.breed = var_64_1

		local var_64_2 = var_64_1.slot_template
		local var_64_3 = Managers.state.difficulty:get_difficulty_value_from_table(var_0_2)[var_64_2]

		fassert(var_64_2, "Breed " .. var_64_1.name .. " that uses slot system does not have a slot_template set in its breed.")
		fassert(var_64_3, "Breed " .. var_64_1.name .. " that uses slot system does not have a slot_template setup in SlotTemplates.")

		var_64_0.slot_template = var_64_3
		var_64_0.slot_type_settings = var_0_3[var_64_3.slot_type]
		var_64_0.use_slot_type = var_64_3.slot_type
	end
end

function AISlotSystem.on_remove_extension(arg_65_0, arg_65_1, arg_65_2)
	arg_65_0.frozen_unit_extension_data[arg_65_1] = nil

	arg_65_0:_cleanup_extension(arg_65_1, arg_65_2)
	ScriptUnit.remove_extension(arg_65_1, arg_65_0.NAME)
end

function AISlotSystem.on_freeze_extension(arg_66_0, arg_66_1, arg_66_2)
	local var_66_0 = arg_66_0.unit_extension_data[arg_66_1]

	fassert(var_66_0, "Unit was already frozen.")

	if var_66_0 == nil then
		return
	end

	local var_66_1 = var_66_0.slot_template

	if var_66_1 and var_66_1.prioritize_queued_units_on_death then
		local var_66_2 = var_66_0.slot

		if var_66_1.prioritize_queued_units_on_death_time then
			var_66_0.delayed_prioritized_ai_unit_update_time = Managers.time:time("game") + var_66_1.prioritize_queued_units_on_death_time
		else
			arg_66_0:prioritize_queued_units_on_slot(var_66_2)
		end
	end

	arg_66_0.frozen_unit_extension_data[arg_66_1] = var_66_0

	arg_66_0:_cleanup_extension(arg_66_1, arg_66_2)
end

function AISlotSystem._cleanup_extension(arg_67_0, arg_67_1, arg_67_2)
	local var_67_0 = arg_67_0.unit_extension_data[arg_67_1]

	if var_67_0 == nil then
		return
	end

	local var_67_1 = arg_67_0.update_slots_ai_units
	local var_67_2 = #var_67_1

	if arg_67_2 == "AIEnemySlotExtension" then
		if var_67_0.slot or var_67_0.waiting_on_slot then
			var_0_24(arg_67_1, arg_67_0.unit_extension_data)
		end

		arg_67_0.update_slots_ai_units_prioritized[arg_67_1] = nil

		for iter_67_0 = 1, var_67_2 do
			if var_67_1[iter_67_0] == arg_67_1 then
				var_67_1[iter_67_0] = var_67_1[var_67_2]
				var_67_1[var_67_2] = nil

				break
			end
		end
	end

	if arg_67_2 == "AIPlayerSlotExtension" or arg_67_2 == "AIAggroableSlotExtension" then
		if var_67_0.slots then
			local var_67_3 = var_67_0.slots

			for iter_67_1 = #var_67_3, 0, -1 do
				local var_67_4 = var_67_3[iter_67_1]

				var_0_20(var_67_4, arg_67_0.unit_extension_data)
			end
		end

		local var_67_5 = #arg_67_0.target_units

		for iter_67_2 = 1, var_67_5 do
			if arg_67_0.target_units[iter_67_2] == arg_67_1 then
				arg_67_0.target_units[iter_67_2] = arg_67_0.target_units[var_67_5]
				arg_67_0.target_units[var_67_5] = nil

				break
			end
		end

		for iter_67_3 = 1, var_67_2 do
			local var_67_6 = arg_67_0.unit_extension_data[var_67_1[iter_67_3]]

			if var_67_6.target == arg_67_1 then
				var_67_6.target = nil
			end
		end
	end

	arg_67_0.unit_extension_data[arg_67_1] = nil
end

function AISlotSystem.freeze(arg_68_0, arg_68_1, arg_68_2, arg_68_3)
	local var_68_0 = arg_68_0.frozen_unit_extension_data

	if var_68_0[arg_68_1] then
		return
	end

	local var_68_1 = arg_68_0.unit_extension_data[arg_68_1]

	fassert(var_68_1, "Unit to freeze didn't have unfrozen extension")
	arg_68_0:_cleanup_extension(arg_68_1, arg_68_2)

	arg_68_0.unit_extension_data[arg_68_1] = nil
	var_68_0[arg_68_1] = var_68_1
end

function AISlotSystem.unfreeze(arg_69_0, arg_69_1)
	local var_69_0 = arg_69_0.frozen_unit_extension_data[arg_69_1]

	arg_69_0.frozen_unit_extension_data[arg_69_1] = nil
	arg_69_0.unit_extension_data[arg_69_1] = var_69_0

	fassert(var_69_0, "Unit to freeze didn't have unfrozen extension")

	var_69_0.target = nil
	var_69_0.improve_wait_slot_position_t = 0
	arg_69_0.update_slots_ai_units[#arg_69_0.update_slots_ai_units + 1] = arg_69_1
end

local function var_0_99(arg_70_0, arg_70_1, arg_70_2, arg_70_3)
	local var_70_0 = Managers.state.debug:drawer({
		mode = "immediate",
		name = "AISlotSystem_immediate"
	})
	local var_70_1 = Vector3.up() * 0.1
	local var_70_2 = Managers.state.side:sides()

	for iter_70_0 = 1, #var_70_2 do
		local var_70_3 = var_70_2[iter_70_0].AI_TARGET_UNITS

		for iter_70_1, iter_70_2 in pairs(var_70_3) do
			repeat
				if not HEALTH_ALIVE[iter_70_2] then
					break
				end

				local var_70_4 = arg_70_1[iter_70_2]

				if not var_70_4 or not var_70_4.valid_target then
					break
				end

				local var_70_5 = var_70_4.all_slots

				for iter_70_3, iter_70_4 in pairs(var_70_5) do
					local var_70_6 = iter_70_4.slots
					local var_70_7 = #var_70_6
					local var_70_8 = var_70_4.position:unbox()
					local var_70_9 = Colors.get(var_70_4.debug_color_name)

					var_70_0:circle(var_70_8 + var_70_1, 0.5, Vector3.up(), var_70_9)
					var_70_0:circle(var_70_8 + var_70_1, 0.45, Vector3.up(), var_70_9)

					if var_70_4.next_slot_status_update_at then
						local var_70_10 = (arg_70_3 - var_70_4.next_slot_status_update_at) / var_0_91

						var_70_0:circle(var_70_8 + var_70_1, 0.45 * var_70_10, Vector3.up(), var_70_9)
					end

					for iter_70_5 = 1, var_70_7 do
						repeat
							local var_70_11 = var_70_6[iter_70_5]
							local var_70_12 = var_70_11 == var_0_74(iter_70_3, iter_70_2, arg_70_1)
							local var_70_13 = var_70_11.ai_unit
							local var_70_14 = var_70_13 and 255 or 150
							local var_70_15 = var_70_11.disabled and Colors.get_color_with_alpha("gray", var_70_14) or Colors.get_color_with_alpha(var_70_11.debug_color_name, var_70_14)

							if var_70_11.absolute_position then
								local var_70_16 = var_70_11.absolute_position:unbox()

								if ALIVE[var_70_13] then
									local var_70_17 = POSITION_LOOKUP[var_70_13]

									var_70_0:circle(var_70_17 + var_70_1, 0.35, Vector3.up(), var_70_15)
									var_70_0:circle(var_70_17 + var_70_1, 0.3, Vector3.up(), var_70_15)

									local var_70_18 = Unit.node(var_70_13, "c_head")
									local var_70_19 = "player_1"
									local var_70_20 = var_70_11.disabled and Colors.get_table("gray") or Colors.get_table(var_70_11.debug_color_name)
									local var_70_21 = Vector3(var_70_20[2], var_70_20[3], var_70_20[4])
									local var_70_22 = Vector3(0, 0, -1)
									local var_70_23 = 0.4
									local var_70_24 = var_70_11.index
									local var_70_25 = "slot_index"

									Managers.state.debug_text:clear_unit_text(var_70_13, var_70_25)
									Managers.state.debug_text:output_unit_text(var_70_24, var_70_23, var_70_13, var_70_18, var_70_22, nil, var_70_25, var_70_21, var_70_19)

									if var_70_11.ghost_position.x ~= 0 and not var_70_11.disable_at then
										local var_70_26 = var_70_11.ghost_position:unbox()

										var_70_0:line(var_70_26 + var_70_1, var_70_16 + var_70_1, var_70_15)
										var_70_0:sphere(var_70_26 + var_70_1, 0.3, var_70_15)
										var_70_0:line(var_70_26 + var_70_1, var_70_17 + var_70_1, var_70_15)
									else
										var_70_0:line(var_70_16 + var_70_1, var_70_17 + var_70_1, var_70_15)
									end
								end

								local var_70_27 = 0.4
								local var_70_28 = var_70_11.disabled and Colors.get_table("gray") or Colors.get_table(var_70_11.debug_color_name)
								local var_70_29 = Vector3(var_70_28[2], var_70_28[3], var_70_28[4])
								local var_70_30 = "slot_index_" .. iter_70_3 .. "_" .. var_70_11.index .. "_" .. iter_70_1

								Managers.state.debug_text:clear_world_text(var_70_30)
								Managers.state.debug_text:output_world_text(var_70_11.index, var_70_27, var_70_16 + var_70_1, nil, var_70_30, var_70_29)

								local var_70_31 = var_0_3[iter_70_3].radius

								var_70_0:circle(var_70_16 + var_70_1, var_70_31, Vector3.up(), var_70_15)
								var_70_0:circle(var_70_16 + var_70_1, var_70_31 - 0.05, Vector3.up(), var_70_15)

								local var_70_32 = var_0_49(arg_70_1, var_70_11, arg_70_2, nil, arg_70_3)

								if var_70_32 then
									var_70_0:circle(var_70_32 + var_70_1, var_0_26, Vector3.up(), var_70_15)
									var_70_0:circle(var_70_32 + var_70_1, var_0_26 - 0.05, Vector3.up(), var_70_15)
									var_70_0:line(var_70_16 + var_70_1, var_70_32 + var_70_1, var_70_15)

									local var_70_33 = var_70_11.queue
									local var_70_34 = #var_70_33

									for iter_70_6 = 1, var_70_34 do
										local var_70_35 = var_70_33[iter_70_6]
										local var_70_36 = POSITION_LOOKUP[var_70_35]

										var_70_0:circle(var_70_36 + var_70_1, 0.35, Vector3.up(), var_70_15)
										var_70_0:circle(var_70_36 + var_70_1, 0.3, Vector3.up(), var_70_15)
										var_70_0:line(var_70_32 + var_70_1, var_70_36, var_70_15)
									end
								end

								local var_70_37 = 0.2
								local var_70_38 = var_70_11.disabled and Colors.get_table("gray") or Colors.get_table(var_70_11.debug_color_name)
								local var_70_39 = Vector3(var_70_38[2], var_70_38[3], var_70_38[4])
								local var_70_40 = "wait_slot_index_" .. iter_70_3 .. "_" .. var_70_11.index .. "_" .. iter_70_5

								Managers.state.debug_text:clear_world_text(var_70_40)

								if var_70_32 then
									Managers.state.debug_text:output_world_text("wait " .. var_70_11.index, var_70_37, var_70_32 + var_70_1, nil, var_70_40, var_70_39)
								end

								if var_70_11.released then
									local var_70_41 = Colors.get("green")

									var_70_0:sphere(var_70_16 + var_70_1, 0.2, var_70_41)
								end

								if var_70_12 then
									local var_70_42 = Colors.get("red")

									var_70_0:sphere(var_70_16 + var_70_1, 0.3, var_70_42)
								end

								local var_70_43 = var_70_11.position_check_index
								local var_70_44 = var_70_16

								if var_70_43 == var_0_6.CHECK_MIDDLE then
									-- block empty
								else
									local var_70_45 = var_0_8[var_70_43]

									var_70_44 = var_0_53(var_70_44, var_70_8, var_70_45, var_0_5)
								end

								local var_70_46 = var_70_8 + var_0_14(var_70_44 - var_70_8) * var_0_39

								var_70_0:line(var_70_46 + var_70_1, var_70_44 + var_70_1, var_70_15)
								var_70_0:circle(var_70_44 + var_70_1, 0.1, Vector3.up(), Color(255, 0, 255))

								break
							end

							local var_70_47 = "wait_slot_index_" .. iter_70_3 .. "_" .. var_70_11.index .. "_" .. iter_70_5

							Managers.state.debug_text:clear_world_text(var_70_47)
						until true
					end
				end
			until true
		end
	end
end

local function var_0_100(arg_71_0, arg_71_1)
	local var_71_0 = #arg_71_0
	local var_71_1 = arg_71_1

	Debug.text("OCCUPIED SLOTS")

	for iter_71_0 = 1, var_71_0 do
		local var_71_2 = arg_71_0[iter_71_0]
		local var_71_3 = var_71_1[var_71_2]
		local var_71_4 = Managers.player:owner(var_71_2)
		local var_71_5

		if var_71_4 then
			var_71_5 = var_71_4:profile_display_name()
		else
			var_71_5 = tostring(var_71_2)
		end

		local var_71_6 = var_71_5 .. "-> "
		local var_71_7 = var_71_3.all_slots
		local var_71_8 = 0
		local var_71_9 = 0

		for iter_71_1, iter_71_2 in pairs(var_71_7) do
			local var_71_10 = iter_71_2.disabled_slots_count
			local var_71_11 = iter_71_2.slots_count
			local var_71_12 = iter_71_2.total_slots_count
			local var_71_13 = var_71_12 - var_71_10

			var_71_8 = var_71_8 + var_71_12
			var_71_9 = var_71_9 + var_71_13
			var_71_6 = var_71_6 .. string.format("%s: [%d|%d(%d)]. ", iter_71_1, var_71_11, var_71_13, var_71_12)
		end

		local var_71_14 = var_71_3.num_occupied_slots
		local var_71_15 = var_71_3.delayed_num_occupied_slots
		local var_71_16 = var_71_6 .. string.format("total: [%d(%d)|%d(%d)]. ", var_71_14, var_71_15, var_71_9, var_71_8)

		Debug.text(var_71_16)
	end
end

function AISlotSystem.set_allowed_layer(arg_72_0, arg_72_1, arg_72_2)
	local var_72_0 = LAYER_ID_MAPPING[arg_72_1]

	if arg_72_2 then
		GwNavTagLayerCostTable.allow_layer(arg_72_0._navtag_layer_cost_table, var_72_0)
	else
		GwNavTagLayerCostTable.forbid_layer(arg_72_0._navtag_layer_cost_table, var_72_0)
	end
end

var_0_4 = {
	{
		"aqua_marine",
		"cadet_blue",
		"corn_flower_blue",
		"dodger_blue",
		"sky_blue",
		"midnight_blue",
		"medium_purple",
		"blue_violet",
		"dark_slate_blue"
	},
	{
		"dark_green",
		"green",
		"lime",
		"light_green",
		"dark_sea_green",
		"spring_green",
		"sea_green",
		"medium_aqua_marine",
		"light_sea_green"
	},
	{
		"maroon",
		"dark_red",
		"brown",
		"firebrick",
		"crimson",
		"red",
		"tomato",
		"coral",
		"indian_red",
		"light_coral"
	},
	{
		"orange",
		"gold",
		"dark_golden_rod",
		"golden_rod",
		"pale_golden_rod",
		"dark_khaki",
		"khaki",
		"olive",
		"yellow"
	},
	{
		"orange",
		"gold",
		"dark_golden_rod",
		"golden_rod",
		"pale_golden_rod",
		"dark_khaki",
		"khaki",
		"olive",
		"yellow"
	},
	{
		"orange",
		"gold",
		"dark_golden_rod",
		"golden_rod",
		"pale_golden_rod",
		"dark_khaki",
		"khaki",
		"olive",
		"yellow"
	},
	{
		"orange",
		"gold",
		"dark_golden_rod",
		"golden_rod",
		"pale_golden_rod",
		"dark_khaki",
		"khaki",
		"olive",
		"yellow"
	},
	{
		"orange",
		"gold",
		"dark_golden_rod",
		"golden_rod",
		"pale_golden_rod",
		"dark_khaki",
		"khaki",
		"olive",
		"yellow"
	},
	{
		"orange",
		"gold",
		"dark_golden_rod",
		"golden_rod",
		"pale_golden_rod",
		"dark_khaki",
		"khaki",
		"olive",
		"yellow"
	},
	{
		"orange",
		"gold",
		"dark_golden_rod",
		"golden_rod",
		"pale_golden_rod",
		"dark_khaki",
		"khaki",
		"olive",
		"yellow"
	},
	{
		"orange",
		"gold",
		"dark_golden_rod",
		"golden_rod",
		"pale_golden_rod",
		"dark_khaki",
		"khaki",
		"olive",
		"yellow"
	},
	{
		"orange",
		"gold",
		"dark_golden_rod",
		"golden_rod",
		"pale_golden_rod",
		"dark_khaki",
		"khaki",
		"olive",
		"yellow"
	},
	{
		"orange",
		"gold",
		"dark_golden_rod",
		"golden_rod",
		"pale_golden_rod",
		"dark_khaki",
		"khaki",
		"olive",
		"yellow"
	},
	{
		"orange",
		"gold",
		"dark_golden_rod",
		"golden_rod",
		"pale_golden_rod",
		"dark_khaki",
		"khaki",
		"olive",
		"yellow"
	},
	{
		"orange",
		"gold",
		"dark_golden_rod",
		"golden_rod",
		"pale_golden_rod",
		"dark_khaki",
		"khaki",
		"olive",
		"yellow"
	},
	{
		"orange",
		"gold",
		"dark_golden_rod",
		"golden_rod",
		"pale_golden_rod",
		"dark_khaki",
		"khaki",
		"olive",
		"yellow"
	},
	{
		"orange",
		"gold",
		"dark_golden_rod",
		"golden_rod",
		"pale_golden_rod",
		"dark_khaki",
		"khaki",
		"olive",
		"yellow"
	},
	{
		"orange",
		"gold",
		"dark_golden_rod",
		"golden_rod",
		"pale_golden_rod",
		"dark_khaki",
		"khaki",
		"olive",
		"yellow"
	},
	{
		"orange",
		"gold",
		"dark_golden_rod",
		"golden_rod",
		"pale_golden_rod",
		"dark_khaki",
		"khaki",
		"olive",
		"yellow"
	},
	{
		"orange",
		"gold",
		"dark_golden_rod",
		"golden_rod",
		"pale_golden_rod",
		"dark_khaki",
		"khaki",
		"olive",
		"yellow"
	}
}
