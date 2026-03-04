-- chunkname: @scripts/entity_system/systems/ai/ai_slot_system_2.lua

require("scripts/unit_extensions/human/ai_player_unit/ai_utils")
require("scripts/settings/slot_templates")
require("scripts/settings/slot_settings")
require("scripts/settings/infighting_settings")
require("scripts/entity_system/systems/ai/ai_enemy_slot_extension")
require("scripts/entity_system/systems/ai/ai_player_slot_extension")
require("scripts/entity_system/systems/ai/ai_aggroable_slot_extension")

local var_0_0 = "normal"
local var_0_1 = {
	"AIEnemySlotExtension",
	"AIPlayerSlotExtension",
	"AIAggroableSlotExtension"
}

AISlotSystem2 = class(AISlotSystem2, ExtensionSystemBase)

local var_0_2 = SlotTypeSettings
local var_0_3
local var_0_4

AISlotSystem2.init = function (arg_1_0, arg_1_1, arg_1_2)
	AISlotSystem2.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_1)

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

	local var_1_0 = {
		bot_poison_wind = 1,
		bot_ratling_gun_fire = 1,
		fire_grenade = 1
	}

	table.merge(var_1_0, NAV_TAG_VOLUME_LAYER_COST_AI)

	local var_1_1 = GwNavTagLayerCostTable.create()

	arg_1_0._navtag_layer_cost_table = var_1_1

	AiUtils.initialize_cost_table(var_1_1, var_1_0)

	local var_1_2 = GwNavCostMap.create_tag_cost_table()

	arg_1_0._nav_cost_map_cost_table = var_1_2

	AiUtils.initialize_nav_cost_map_cost_table(var_1_2, nil, 1)

	arg_1_0._traverse_logic = GwNavTraverseLogic.create(arg_1_0.nav_world, var_1_2)

	GwNavTraverseLogic.set_navtag_layer_cost_table(arg_1_0._traverse_logic, var_1_1)
end

AISlotSystem2.destroy = function (arg_2_0)
	if arg_2_0._traverse_logic ~= nil then
		GwNavTagLayerCostTable.destroy(arg_2_0._navtag_layer_cost_table)
		GwNavCostMap.destroy_tag_cost_table(arg_2_0._nav_cost_map_cost_table)
		GwNavTraverseLogic.destroy(arg_2_0._traverse_logic)
	end
end

AISlotSystem2.hot_join_sync = function (arg_3_0, arg_3_1, arg_3_2)
	return
end

local var_0_5 = 1

AISlotSystem2.do_slot_search = function (arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0.unit_extension_data[arg_4_1]

	if var_4_0 then
		var_4_0.do_search = arg_4_2
	end
end

AISlotSystem2.ai_unit_have_slot = function (arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0.unit_extension_data[arg_5_1]

	if not var_5_0 then
		return false
	end

	if var_5_0.gathering_ball or var_5_0.sloid_id then
		return true
	end

	if not var_5_0.slot then
		return false
	end

	return true
end

AISlotSystem2.ai_unit_have_wait_slot = function (arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.unit_extension_data[arg_6_1]

	if not var_6_0 then
		return false
	end

	if not var_6_0.waiting_on_slot then
		return false
	end

	return true
end

AISlotSystem2.ai_unit_wait_slot_distance = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.unit_extension_data[arg_7_1]

	if not var_7_0 then
		return math.huge
	end

	if var_7_0.slot then
		return math.huge
	end

	if not var_7_0.waiting_on_slot then
		return math.huge
	end

	return var_7_0.wait_slot_distance or math.huge
end

AISlotSystem2.ai_unit_slot_position = function (arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.unit_extension_data[arg_8_1]

	if not var_8_0 then
		return nil
	end

	local var_8_1 = var_8_0.slot or var_8_0.waiting_on_slot

	if var_8_1 then
		return var_8_1.absolute_position:unbox()
	end

	return nil
end

AISlotSystem2.ai_unit_blocked_attack = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0.unit_extension_data[arg_9_1]

	if var_9_0 and var_9_0.on_unit_blocked_attack then
		var_9_0:on_unit_blocked_attack(arg_9_1, arg_9_0)
	end
end

AISlotSystem2.ai_unit_staggered = function (arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0.unit_extension_data[arg_10_1]

	if var_10_0 and var_10_0.ai_unit_staggered then
		var_10_0:ai_unit_staggered(arg_10_1, arg_10_0)
	end
end

AISlotSystem2.get_target_unit_slot_data = function (arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0.unit_extension_data[arg_11_1].all_slots[arg_11_2]

	if not var_11_0 then
		return
	end

	return var_11_0.slots
end

AISlotSystem2.slots_count = function (arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0.unit_extension_data[arg_12_1]

	arg_12_2 = arg_12_2 or var_0_0

	return var_12_0.all_slots[arg_12_2].slots_count
end

AISlotSystem2.total_slots_count = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0.unit_extension_data[arg_13_1]

	arg_13_2 = arg_13_2 or var_0_0

	return var_13_0.all_slots[arg_13_2].total_slots_count
end

AISlotSystem2.disabled_slots_count = function (arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0.unit_extension_data[arg_14_1]

	arg_14_2 = arg_14_2 or var_0_0

	return var_14_0.all_slots[arg_14_2].disabled_slots_count
end

AISlotSystem2.set_release_slot_lock = function (arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_0.unit_extension_data[arg_15_1]

	if var_15_0 then
		var_15_0.release_slot_lock = arg_15_2
	end
end

AISlotSystem2.update_target_slots = function (arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0.target_units

	for iter_16_0 = 1, #var_16_0 do
		if var_16_0[iter_16_0]:update_target_slots(arg_16_1, var_16_0, arg_16_0.nav_world, arg_16_0._traverse_logic) then
			break
		end
	end
end

AISlotSystem2.update_disabled_slots_count = function (arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0.target_units

	for iter_17_0 = 1, #var_17_0 do
		var_17_0[iter_17_0]:update_disabled_slots_count(arg_17_1)
	end
end

AISlotSystem2.update_slot_sound = function (arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0.target_units

	for iter_18_0 = 1, #var_18_0 do
		var_18_0[iter_18_0]:update_slot_sound(arg_18_1)
	end
end

AISlotSystem2.update = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	if not script_data.navigation_thread_disabled then
		local var_19_0 = arg_19_0.nav_world

		GwNavWorld.join_async_update(var_19_0)

		NAVIGATION_RUNNING_IN_THREAD = false
	end
end

local var_0_6 = 1
local var_0_7 = 1
local var_0_8 = 1

AISlotSystem2.update_slot_providers = function (arg_20_0, arg_20_1)
	if #arg_20_0.target_units == 0 then
		return
	end

	arg_20_0:update_target_slots(arg_20_1)

	if arg_20_1 > arg_20_0.next_total_slot_count_update then
		arg_20_0:update_total_slots_count(arg_20_1)

		arg_20_0.next_total_slot_count_update = arg_20_1 + var_0_6
	end

	if arg_20_1 > arg_20_0.next_disabled_slot_count_update then
		arg_20_0:update_disabled_slots_count(arg_20_1)

		arg_20_0.next_disabled_slot_count_update = arg_20_1 + var_0_7
	end

	if arg_20_1 > arg_20_0.next_slot_sound_update then
		arg_20_0:update_slot_sound(arg_20_1)

		arg_20_0.next_slot_sound_update = arg_20_1 + var_0_8
	end
end

AISlotSystem2.traverse_logic = function (arg_21_0)
	return arg_21_0._traverse_logic
end

AISlotSystem2.update_slot_consumers = function (arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0.nav_world
	local var_22_1 = arg_22_0.unit_extension_data
	local var_22_2 = arg_22_0.update_slots_ai_units
	local var_22_3 = #var_22_2

	if var_22_3 < arg_22_0.current_ai_index then
		arg_22_0.current_ai_index = 1
	end

	local var_22_4 = arg_22_0.current_ai_index
	local var_22_5 = math.min(var_22_4 + var_0_5 - 1, var_22_3)

	arg_22_0.current_ai_index = var_22_5 + 1

	local var_22_6 = arg_22_0.update_slots_ai_units_prioritized

	for iter_22_0 = var_22_4, var_22_5 do
		local var_22_7 = var_22_2[iter_22_0]

		var_22_1[var_22_7]:update(var_22_7, var_22_1, var_22_0, arg_22_1, arg_22_0._traverse_logic, arg_22_0)

		var_22_6[var_22_7] = nil
	end

	for iter_22_1, iter_22_2 in pairs(var_22_6) do
		local var_22_8 = var_22_1[iter_22_1]

		if var_22_8 then
			var_22_8:update(iter_22_1, var_22_1, var_22_0, arg_22_1, arg_22_0._traverse_logic, arg_22_0)
		end

		var_22_6[iter_22_1] = nil
	end
end

AISlotSystem2.physics_async_update = function (arg_23_0, arg_23_1, arg_23_2)
	arg_23_0.t = arg_23_2

	if #arg_23_0.target_units == 0 then
		return
	end

	local var_23_0 = arg_23_0.nav_world
	local var_23_1 = arg_23_0.unit_extension_data

	arg_23_0:update_slot_providers(arg_23_2)
	arg_23_0:update_slot_consumers(arg_23_2)
end

AISlotSystem2.update_total_slots_count = function (arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0.target_units
	local var_24_1 = 0
	local var_24_2 = 0

	for iter_24_0 = 1, #var_24_0 do
		local var_24_3, var_24_4 = var_24_0[iter_24_0]:update_total_slots_count(arg_24_1)

		var_24_1 = var_24_1 + var_24_3
		var_24_2 = var_24_2 + var_24_4
	end

	arg_24_0.num_total_enemies = var_24_1
	arg_24_0.num_occupied_slots = var_24_2
end

AISlotSystem2.register_prioritized_ai_unit_update = function (arg_25_0, arg_25_1)
	arg_25_0.update_slots_ai_units_prioritized[arg_25_1] = true
end

AISlotSystem2.prioritize_queued_units_on_slot = function (arg_26_0, arg_26_1)
	if arg_26_1 and arg_26_1.queue then
		local var_26_0 = arg_26_1.queue
		local var_26_1 = #var_26_0

		for iter_26_0 = 1, var_26_1 do
			local var_26_2 = var_26_0[iter_26_0].unit

			arg_26_0:register_prioritized_ai_unit_update(var_26_2)
		end
	end
end

AISlotSystem2.on_add_extension = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	local var_27_0

	if arg_27_3 == "AIPlayerSlotExtension" or arg_27_3 == "AIAggroableSlotExtension" then
		var_27_0 = AISlotSystem2.super.on_add_extension(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
		arg_27_0.unit_extension_data[arg_27_2] = var_27_0

		local var_27_1 = arg_27_0.target_units
		local var_27_2 = #var_27_1 + 1

		var_27_0.index = var_27_2
		var_27_1[var_27_2] = var_27_0

		local var_27_3 = arg_27_0.nav_world
		local var_27_4 = arg_27_0._traverse_logic

		var_27_0:update_target_slots(0, var_27_1, var_27_3, var_27_4)
	end

	if arg_27_3 == "AIEnemySlotExtension" then
		var_27_0 = AISlotSystem2.super.on_add_extension(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
		arg_27_0.update_slots_ai_units[#arg_27_0.update_slots_ai_units + 1] = arg_27_2
		arg_27_0.unit_extension_data[arg_27_2] = var_27_0
	end

	return var_27_0
end

AISlotSystem2.on_remove_extension = function (arg_28_0, arg_28_1, arg_28_2)
	arg_28_0.frozen_unit_extension_data[arg_28_1] = nil

	arg_28_0:_cleanup_extension(arg_28_1, arg_28_2)
	ScriptUnit.remove_extension(arg_28_1, arg_28_0.NAME)
end

AISlotSystem2.on_freeze_extension = function (arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = arg_29_0.unit_extension_data[arg_29_1]

	fassert(var_29_0, "Unit was already frozen.")

	if var_29_0 == nil then
		return
	end

	local var_29_1 = var_29_0.slot_template

	if var_29_1 and var_29_1.prioritize_queued_units_on_death then
		local var_29_2 = var_29_0.slot

		if var_29_1.prioritize_queued_units_on_death_time then
			var_29_0.delayed_prioritized_ai_unit_update_time = Managers.time:time("game") + var_29_1.prioritize_queued_units_on_death_time
		else
			arg_29_0:prioritize_queued_units_on_slot(var_29_2)
		end
	end

	arg_29_0.frozen_unit_extension_data[arg_29_1] = var_29_0

	arg_29_0:_cleanup_extension(arg_29_1, arg_29_2)
end

AISlotSystem2._cleanup_extension = function (arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = arg_30_0.unit_extension_data[arg_30_1]

	if var_30_0 == nil then
		return
	end

	local var_30_1 = arg_30_0.update_slots_ai_units
	local var_30_2 = #var_30_1

	if arg_30_2 == "AIEnemySlotExtension" then
		arg_30_0.update_slots_ai_units_prioritized[arg_30_1] = nil

		var_30_0:cleanup_extension(arg_30_1, var_30_1, var_30_2)
	end

	if arg_30_2 == "AIPlayerSlotExtension" or arg_30_2 == "AIAggroableSlotExtension" then
		var_30_0:cleanup_extension(arg_30_1, var_30_1, var_30_2, arg_30_0.unit_extension_data)

		local var_30_3 = arg_30_0.target_units
		local var_30_4 = #var_30_3

		for iter_30_0 = 1, var_30_4 do
			if var_30_3[iter_30_0] == var_30_0 then
				var_30_3[iter_30_0] = var_30_3[var_30_4]
				var_30_3[var_30_4] = nil

				break
			end
		end
	end

	arg_30_0.unit_extension_data[arg_30_1] = nil
end

AISlotSystem2.freeze = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	local var_31_0 = arg_31_0.frozen_unit_extension_data

	if var_31_0[arg_31_1] then
		return
	end

	local var_31_1 = arg_31_0.unit_extension_data[arg_31_1]

	fassert(var_31_1, "Unit to freeze didn't have unfrozen extension")
	arg_31_0:_cleanup_extension(arg_31_1, arg_31_2)

	var_31_0[arg_31_1] = var_31_1
end

AISlotSystem2.unfreeze = function (arg_32_0, arg_32_1)
	local var_32_0 = arg_32_0.frozen_unit_extension_data[arg_32_1]

	arg_32_0.frozen_unit_extension_data[arg_32_1] = nil
	arg_32_0.unit_extension_data[arg_32_1] = var_32_0

	fassert(var_32_0, "Unit to freeze didn't have unfrozen extension")

	if var_32_0.unfreeze then
		var_32_0:unfreeze(arg_32_1)
	end

	arg_32_0.update_slots_ai_units[#arg_32_0.update_slots_ai_units + 1] = arg_32_1
end

local function var_0_9(arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = Managers.state.debug:drawer({
		mode = "immediate",
		name = "AISlotSystem2_immediate"
	})

	for iter_33_0, iter_33_1 in pairs(arg_33_0) do
		if iter_33_1.debug_draw then
			iter_33_1:debug_draw(var_33_0, arg_33_2, arg_33_1)
		end
	end
end

local function var_0_10(arg_34_0)
	local var_34_0 = #arg_34_0

	Debug.text("OCCUPIED SLOTS")

	for iter_34_0 = 1, var_34_0 do
		local var_34_1 = arg_34_0[iter_34_0]
		local var_34_2 = var_34_1.unit
		local var_34_3 = Managers.player:owner(var_34_2)
		local var_34_4

		if var_34_3 then
			var_34_4 = var_34_3:profile_display_name()
		else
			var_34_4 = tostring(var_34_2)
		end

		local var_34_5 = var_34_4 .. "-> "
		local var_34_6 = var_34_1.all_slots
		local var_34_7 = 0
		local var_34_8 = 0

		for iter_34_1, iter_34_2 in pairs(var_34_6) do
			local var_34_9 = iter_34_2.disabled_slots_count
			local var_34_10 = iter_34_2.slots_count
			local var_34_11 = iter_34_2.total_slots_count
			local var_34_12 = var_34_11 - var_34_9

			var_34_7 = var_34_7 + var_34_11
			var_34_8 = var_34_8 + var_34_12
			var_34_5 = var_34_5 .. string.format("%s: [%d|%d(%d)]. ", iter_34_1, var_34_10, var_34_12, var_34_11)
		end

		local var_34_13 = var_34_1.num_occupied_slots
		local var_34_14 = var_34_1.delayed_num_occupied_slots
		local var_34_15 = var_34_5 .. string.format("total: [%d(%d)|%d(%d)]. ", var_34_13, var_34_14, var_34_8, var_34_7)

		Debug.text(var_34_15)
	end
end

AISlotSystem2.set_allowed_layer = function (arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = LAYER_ID_MAPPING[arg_35_1]

	if arg_35_2 then
		GwNavTagLayerCostTable.allow_layer(arg_35_0._navtag_layer_cost_table, var_35_0)
	else
		GwNavTagLayerCostTable.forbid_layer(arg_35_0._navtag_layer_cost_table, var_35_0)
	end
end
