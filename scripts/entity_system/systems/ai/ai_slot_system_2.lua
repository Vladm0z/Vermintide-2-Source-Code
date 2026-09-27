-- chunkname: @scripts/entity_system/systems/ai/ai_slot_system_2.lua

require("scripts/unit_extensions/human/ai_player_unit/ai_utils")
require("scripts/settings/slot_templates")
require("scripts/settings/slot_settings")
require("scripts/settings/infighting_settings")
require("scripts/entity_system/systems/ai/ai_enemy_slot_extension")
require("scripts/entity_system/systems/ai/ai_player_slot_extension")
require("scripts/entity_system/systems/ai/ai_aggroable_slot_extension")

local str = "normal"
local tbl = {
	"AIEnemySlotExtension",
	"AIPlayerSlotExtension",
	"AIAggroableSlotExtension"
}

AISlotSystem2 = class(AISlotSystem2, ExtensionSystemBase)

local SlotTypeSettings = SlotTypeSettings
local var_0_3
local var_0_4

AISlotSystem2.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	AISlotSystem2.super.init(self, arg_1_1, arg_1_2, tbl)

	self.nav_world = Managers.state.entity:system("ai_system"):nav_world()
	self.unit_extension_data = {}
	self.frozen_unit_extension_data = {}
	self.update_slots_ai_units = {}
	self.update_slots_ai_units_prioritized = {}
	self.target_units = {}
	self.current_ai_index = 1
	self.next_total_slot_count_update = 0
	self.next_disabled_slot_count_update = 0
	self.next_slot_sound_update = 0
	self.network_transmit = arg_1_1.network_transmit
	self.num_total_enemies = 0
	self.num_occupied_slots = 0

	local tbl_2 = {
		bot_poison_wind = 1,
		bot_ratling_gun_fire = 1,
		fire_grenade = 1
	}

	table.merge(tbl_2, NAV_TAG_VOLUME_LAYER_COST_AI)

	local var_1_1 = GwNavTagLayerCostTable.create()

	self._navtag_layer_cost_table = var_1_1

	AiUtils.initialize_cost_table(var_1_1, tbl_2)

	local create_tag_cost_table = GwNavCostMap.create_tag_cost_table()

	self._nav_cost_map_cost_table = create_tag_cost_table

	AiUtils.initialize_nav_cost_map_cost_table(create_tag_cost_table, nil, 1)

	self._traverse_logic = GwNavTraverseLogic.create(self.nav_world, create_tag_cost_table)

	GwNavTraverseLogic.set_navtag_layer_cost_table(self._traverse_logic, var_1_1)
end

AISlotSystem2.destroy = function (self)
	-- function 2
	if self._traverse_logic ~= nil then
		GwNavTagLayerCostTable.destroy(self._navtag_layer_cost_table)
		GwNavCostMap.destroy_tag_cost_table(self._nav_cost_map_cost_table)
		GwNavTraverseLogic.destroy(self._traverse_logic)
	end
end

AISlotSystem2.hot_join_sync = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	return
end

local num = 1

AISlotSystem2.do_slot_search = function (self, arg_4_1, arg_4_2)
	-- function 4
	local var_4_0 = self.unit_extension_data[arg_4_1]

	if not var_4_0 then
		var_4_0.do_search = arg_4_2
	end
end

AISlotSystem2.ai_unit_have_slot = function (self, arg_5_1)
	-- function 5
	local var_5_0 = self.unit_extension_data[arg_5_1]

	if not var_5_0 then
		return false
	end

	local gathering_ball = var_5_0.gathering_ball

	gathering_ball = gathering_ball or var_5_0.sloid_id

	if not gathering_ball then
		return true
	end

	if not var_5_0.slot then
		return false
	end

	return true
end

AISlotSystem2.ai_unit_have_wait_slot = function (self, arg_6_1)
	-- function 6
	local var_6_0 = self.unit_extension_data[arg_6_1]

	if not var_6_0 then
		return false
	end

	if not var_6_0.waiting_on_slot then
		return false
	end

	return true
end

AISlotSystem2.ai_unit_wait_slot_distance = function (self, arg_7_1)
	-- function 7
	local var_7_0 = self.unit_extension_data[arg_7_1]

	if not var_7_0 then
		return math.huge
	end

	if not var_7_0.slot then
		return math.huge
	end

	if not var_7_0.waiting_on_slot then
		return math.huge
	end

	local wait_slot_distance = var_7_0.wait_slot_distance

	wait_slot_distance = wait_slot_distance or math.huge

	return wait_slot_distance
end

AISlotSystem2.ai_unit_slot_position = function (self, arg_8_1)
	-- function 8
	local var_8_0 = self.unit_extension_data[arg_8_1]

	if not var_8_0 then
		return nil
	end

	local slot = var_8_0.slot

	slot = slot or var_8_0.waiting_on_slot

	if not slot then
		return slot.absolute_position:unbox()
	end

	return nil
end

AISlotSystem2.ai_unit_blocked_attack = function (self, arg_9_1)
	-- function 9
	local var_9_0 = self.unit_extension_data[arg_9_1]

	if not var_9_0 and not var_9_0.on_unit_blocked_attack then
		var_9_0:on_unit_blocked_attack(arg_9_1, self)
	end
end

AISlotSystem2.ai_unit_staggered = function (self, arg_10_1)
	-- function 10
	local var_10_0 = self.unit_extension_data[arg_10_1]

	if not var_10_0 and not var_10_0.ai_unit_staggered then
		var_10_0:ai_unit_staggered(arg_10_1, self)
	end
end

AISlotSystem2.get_target_unit_slot_data = function (self, arg_11_1, arg_11_2)
	-- function 11
	local var_11_0 = self.unit_extension_data[arg_11_1].all_slots[arg_11_2]

	if not var_11_0 then
		return
	end

	return var_11_0.slots
end

AISlotSystem2.slots_count = function (self, arg_12_1, arg_12_2)
	-- function 12
	local var_12_0 = self.unit_extension_data[arg_12_1]

	arg_12_2 = arg_12_2 or str

	return var_12_0.all_slots[arg_12_2].slots_count
end

AISlotSystem2.total_slots_count = function (self, arg_13_1, arg_13_2)
	-- function 13
	local var_13_0 = self.unit_extension_data[arg_13_1]

	arg_13_2 = arg_13_2 or str

	return var_13_0.all_slots[arg_13_2].total_slots_count
end

AISlotSystem2.disabled_slots_count = function (self, arg_14_1, arg_14_2)
	-- function 14
	local var_14_0 = self.unit_extension_data[arg_14_1]

	arg_14_2 = arg_14_2 or str

	return var_14_0.all_slots[arg_14_2].disabled_slots_count
end

AISlotSystem2.set_release_slot_lock = function (self, arg_15_1, arg_15_2)
	-- function 15
	local var_15_0 = self.unit_extension_data[arg_15_1]

	if not var_15_0 then
		var_15_0.release_slot_lock = arg_15_2
	end
end

AISlotSystem2.update_target_slots = function (self, arg_16_1)
	-- function 16
	local target_units = self.target_units

	for i = 1, #target_units do
		if not target_units[i]:update_target_slots(arg_16_1, target_units, self.nav_world, self._traverse_logic) then
			break
		end
	end
end

AISlotSystem2.update_disabled_slots_count = function (self, arg_17_1)
	-- function 17
	local target_units = self.target_units

	for i = 1, #target_units do
		target_units[i]:update_disabled_slots_count(arg_17_1)
	end
end

AISlotSystem2.update_slot_sound = function (self, arg_18_1)
	-- function 18
	local target_units = self.target_units

	for i = 1, #target_units do
		target_units[i]:update_slot_sound(arg_18_1)
	end
end

AISlotSystem2.update = function (self, arg_19_1, arg_19_2, arg_19_3)
	-- function 19
	if not script_data.navigation_thread_disabled then
		local nav_world = self.nav_world

		GwNavWorld.join_async_update(nav_world)

		NAVIGATION_RUNNING_IN_THREAD = false
	end
end

local num_2 = 1
local num_3 = 1
local num_4 = 1

AISlotSystem2.update_slot_providers = function (self, arg_20_1)
	-- function 20
	if #self.target_units == 0 then
		return
	end

	self:update_target_slots(arg_20_1)

	if arg_20_1 > self.next_total_slot_count_update then
		self:update_total_slots_count(arg_20_1)

		self.next_total_slot_count_update = arg_20_1 + num_2
	end

	if arg_20_1 > self.next_disabled_slot_count_update then
		self:update_disabled_slots_count(arg_20_1)

		self.next_disabled_slot_count_update = arg_20_1 + num_3
	end

	if arg_20_1 > self.next_slot_sound_update then
		self:update_slot_sound(arg_20_1)

		self.next_slot_sound_update = arg_20_1 + num_4
	end
end

AISlotSystem2.traverse_logic = function (self)
	-- function 21
	return self._traverse_logic
end

AISlotSystem2.update_slot_consumers = function (self, arg_22_1)
	-- function 22
	local nav_world = self.nav_world
	local unit_extension_data = self.unit_extension_data
	local update_slots_ai_units = self.update_slots_ai_units
	local count = #update_slots_ai_units

	if count < self.current_ai_index then
		self.current_ai_index = 1
	end

	local current_ai_index = self.current_ai_index
	local min = math.min(current_ai_index + num - 1, count)

	self.current_ai_index = min + 1

	local update_slots_ai_units_prioritized = self.update_slots_ai_units_prioritized

	for i = current_ai_index, min do
		local var_22_7 = update_slots_ai_units[i]

		unit_extension_data[var_22_7]:update(var_22_7, unit_extension_data, nav_world, arg_22_1, self._traverse_logic, self)

		update_slots_ai_units_prioritized[var_22_7] = nil
	end

	for k, v in pairs(update_slots_ai_units_prioritized) do
		local var_22_8 = unit_extension_data[k]

		if not var_22_8 then
			var_22_8:update(k, unit_extension_data, nav_world, arg_22_1, self._traverse_logic, self)
		end

		update_slots_ai_units_prioritized[k] = nil
	end
end

AISlotSystem2.physics_async_update = function (self, arg_23_1, arg_23_2)
	-- function 23
	self.t = arg_23_2

	if #self.target_units == 0 then
		return
	end

	local nav_world = self.nav_world
	local unit_extension_data = self.unit_extension_data

	self:update_slot_providers(arg_23_2)
	self:update_slot_consumers(arg_23_2)
end

AISlotSystem2.update_total_slots_count = function (self, arg_24_1)
	-- function 24
	local target_units = self.target_units
	local num = 0
	local num_2 = 0

	for i = 1, #target_units do
		local update_total_slots_count, var_24_4 = target_units[i]:update_total_slots_count(arg_24_1)

		num = num + update_total_slots_count
		num_2 = num_2 + var_24_4
	end

	self.num_total_enemies = num
	self.num_occupied_slots = num_2
end

AISlotSystem2.register_prioritized_ai_unit_update = function (arg_25_0, arg_25_1)
	-- function 25
	arg_25_0.update_slots_ai_units_prioritized[arg_25_1] = true
end

AISlotSystem2.prioritize_queued_units_on_slot = function (self, arg_26_1)
	-- function 26
	if not arg_26_1 and not arg_26_1.queue then
		local queue = arg_26_1.queue
		local count = #queue

		for i = 1, count do
			local unit = queue[i].unit

			self:register_prioritized_ai_unit_update(unit)
		end
	end
end

AISlotSystem2.on_add_extension = function (self, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	-- function 27
	local var_27_0

	if not (arg_27_3 == "AIPlayerSlotExtension" or arg_27_3 ~= "AIAggroableSlotExtension") then
		var_27_0 = AISlotSystem2.super.on_add_extension(self, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
		self.unit_extension_data[arg_27_2] = var_27_0

		local target_units = self.target_units
		local num = #target_units + 1

		var_27_0.index = num
		target_units[num] = var_27_0

		local nav_world = self.nav_world
		local _traverse_logic = self._traverse_logic

		var_27_0:update_target_slots(0, target_units, nav_world, _traverse_logic)
	end

	if arg_27_3 == "AIEnemySlotExtension" then
		var_27_0 = AISlotSystem2.super.on_add_extension(self, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
		self.update_slots_ai_units[#self.update_slots_ai_units + 1] = arg_27_2
		self.unit_extension_data[arg_27_2] = var_27_0
	end

	return var_27_0
end

AISlotSystem2.on_remove_extension = function (self, arg_28_1, arg_28_2)
	-- function 28
	self.frozen_unit_extension_data[arg_28_1] = nil

	self:_cleanup_extension(arg_28_1, arg_28_2)
	ScriptUnit.remove_extension(arg_28_1, self.NAME)
end

AISlotSystem2.on_freeze_extension = function (self, arg_29_1, arg_29_2)
	-- function 29
	local var_29_0 = self.unit_extension_data[arg_29_1]

	fassert(var_29_0, "Unit was already frozen.")

	if var_29_0 == nil then
		return
	end

	local slot_template = var_29_0.slot_template

	if not slot_template and not slot_template.prioritize_queued_units_on_death then
		local slot = var_29_0.slot

		if not slot_template.prioritize_queued_units_on_death_time then
			var_29_0.delayed_prioritized_ai_unit_update_time = Managers.time:time("game") + slot_template.prioritize_queued_units_on_death_time
		else
			self:prioritize_queued_units_on_slot(slot)
		end
	end

	self.frozen_unit_extension_data[arg_29_1] = var_29_0

	self:_cleanup_extension(arg_29_1, arg_29_2)
end

AISlotSystem2._cleanup_extension = function (self, arg_30_1, arg_30_2)
	-- function 30
	local var_30_0 = self.unit_extension_data[arg_30_1]

	if var_30_0 == nil then
		return
	end

	local update_slots_ai_units = self.update_slots_ai_units
	local count = #update_slots_ai_units

	if arg_30_2 == "AIEnemySlotExtension" then
		self.update_slots_ai_units_prioritized[arg_30_1] = nil

		var_30_0:cleanup_extension(arg_30_1, update_slots_ai_units, count)
	end

	if not (arg_30_2 == "AIPlayerSlotExtension" or arg_30_2 ~= "AIAggroableSlotExtension") then
		var_30_0:cleanup_extension(arg_30_1, update_slots_ai_units, count, self.unit_extension_data)

		local target_units = self.target_units
		local count_2 = #target_units

		for i = 1, count_2 do
			if target_units[i] == var_30_0 then
				target_units[i] = target_units[count_2]
				target_units[count_2] = nil

				break
			end
		end
	end

	self.unit_extension_data[arg_30_1] = nil
end

AISlotSystem2.freeze = function (self, arg_31_1, arg_31_2, arg_31_3)
	-- function 31
	local frozen_unit_extension_data = self.frozen_unit_extension_data

	if not frozen_unit_extension_data[arg_31_1] then
		return
	end

	local var_31_1 = self.unit_extension_data[arg_31_1]

	fassert(var_31_1, "Unit to freeze didn't have unfrozen extension")
	self:_cleanup_extension(arg_31_1, arg_31_2)

	frozen_unit_extension_data[arg_31_1] = var_31_1
end

AISlotSystem2.unfreeze = function (self, arg_32_1)
	-- function 32
	local var_32_0 = self.frozen_unit_extension_data[arg_32_1]

	self.frozen_unit_extension_data[arg_32_1] = nil
	self.unit_extension_data[arg_32_1] = var_32_0

	fassert(var_32_0, "Unit to freeze didn't have unfrozen extension")

	if not var_32_0.unfreeze then
		var_32_0:unfreeze(arg_32_1)
	end

	self.update_slots_ai_units[#self.update_slots_ai_units + 1] = arg_32_1
end

local function fn(arg_33_0, arg_33_1, arg_33_2)
	-- function 33
	local drawer = Managers.state.debug:drawer({
		mode = "immediate",
		name = "AISlotSystem2_immediate"
	})

	for k, v in pairs(arg_33_0) do
		if not v.debug_draw then
			v:debug_draw(drawer, arg_33_2, arg_33_1)
		end
	end
end

local function fn_2(self)
	-- function 34
	local count = #self

	Debug.text("OCCUPIED SLOTS")

	for i = 1, count do
		local var_34_1 = self[i]
		local unit = var_34_1.unit
		local owner = Managers.player:owner(unit)
		local var_34_4

		if not owner then
			var_34_4 = owner:profile_display_name()
		else
			var_34_4 = tostring(unit)
		end

		local str = var_34_4 .. "-> "
		local all_slots = var_34_1.all_slots
		local num = 0
		local num_2 = 0

		for k, v in pairs(all_slots) do
			local disabled_slots_count = v.disabled_slots_count
			local slots_count = v.slots_count
			local total_slots_count = v.total_slots_count
			local num_3 = total_slots_count - disabled_slots_count

			num = num + total_slots_count
			num_2 = num_2 + num_3
			str = str .. string.format("%s: [%d|%d(%d)]. ", k, slots_count, num_3, total_slots_count)
		end

		local num_occupied_slots = var_34_1.num_occupied_slots
		local delayed_num_occupied_slots = var_34_1.delayed_num_occupied_slots
		local str_2 = str .. string.format("total: [%d(%d)|%d(%d)]. ", num_occupied_slots, delayed_num_occupied_slots, num_2, num)

		Debug.text(str_2)
	end
end

AISlotSystem2.set_allowed_layer = function (self, arg_35_1, arg_35_2)
	-- function 35
	local var_35_0 = LAYER_ID_MAPPING[arg_35_1]

	if not arg_35_2 then
		GwNavTagLayerCostTable.allow_layer(self._navtag_layer_cost_table, var_35_0)
	else
		GwNavTagLayerCostTable.forbid_layer(self._navtag_layer_cost_table, var_35_0)
	end
end
