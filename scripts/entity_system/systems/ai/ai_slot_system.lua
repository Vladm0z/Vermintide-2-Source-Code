-- chunkname: @scripts/entity_system/systems/ai/ai_slot_system.lua

require("scripts/unit_extensions/human/ai_player_unit/ai_utils")
require("scripts/settings/slot_templates")
require("scripts/settings/slot_settings")

local str = "normal"
local tbl = {
	"AIEnemySlotExtension",
	"AIPlayerSlotExtension",
	"AIAggroableSlotExtension"
}

AISlotSystem = class(AISlotSystem, ExtensionSystemBase)

local SlotTemplates = SlotTemplates
local SlotTypeSettings = SlotTypeSettings

AISlotSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	local entity_manager = arg_1_1.entity_manager

	entity_manager:register_system(self, arg_1_2, tbl)

	self.entity_manager = entity_manager
	self.is_server = arg_1_1.is_server
	self.world = arg_1_1.world
	self.unit_storage = arg_1_1.unit_storage
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

	local var_1_2 = GwNavTagLayerCostTable.create()

	self._navtag_layer_cost_table = var_1_2

	AiUtils.initialize_cost_table(var_1_2, tbl_2)

	local create_tag_cost_table = GwNavCostMap.create_tag_cost_table()

	self._nav_cost_map_cost_table = create_tag_cost_table

	AiUtils.initialize_nav_cost_map_cost_table(create_tag_cost_table, nil, 1)

	self._traverse_logic = GwNavTraverseLogic.create(self.nav_world, create_tag_cost_table)

	GwNavTraverseLogic.set_navtag_layer_cost_table(self._traverse_logic, var_1_2)
end

local var_0_4

AISlotSystem.destroy = function (self)
	-- function 2
	if self._traverse_logic ~= nil then
		GwNavTagLayerCostTable.destroy(self._navtag_layer_cost_table)
		GwNavCostMap.destroy_tag_cost_table(self._nav_cost_map_cost_table)
		GwNavTraverseLogic.destroy(self._traverse_logic)
	end
end

local num = 0.5
local tbl_2 = {
	CHECK_LEFT = 0,
	CHECK_RIGHT = 2,
	CHECK_MIDDLE = 1
}
local size = table.size(tbl_2)
local tbl_3 = {
	[tbl_2.CHECK_LEFT] = math.degrees_to_radians(-90),
	[tbl_2.CHECK_RIGHT] = math.degrees_to_radians(90)
}
local distance_squared = Vector3.distance_squared
local distance = Vector3.distance
local copy = Vector3.copy
local length = Vector3.length
local length_squared = Vector3.length_squared
local normalize = Vector3.normalize
local dot = Vector3.dot
local flat = Vector3.flat
local tbl_4 = {}

for k, v in pairs(SlotTypeSettings) do
	tbl_4[#tbl_4 + 1] = k
end

local count = #tbl_4

local function fn(arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	local all_slots = arg_3_1.all_slots

	for k, v in pairs(all_slots) do
		local total_slots_count = v.total_slots_count
		local slots = v.slots

		for k_2 = 1, total_slots_count do
			local tbl = {
				target_unit = arg_3_0,
				queue = {},
				original_absolute_position = Vector3Box(0, 0, 0),
				absolute_position = Vector3Box(0, 0, 0),
				ghost_position = Vector3Box(0, 0, 0),
				queue_direction = Vector3Box(0, 0, 0),
				position_right = Vector3Box(0, 0, 0),
				position_left = Vector3Box(0, 0, 0),
				index = k_2
			}

			tbl.anchor_weight = 0
			tbl.type = k
			tbl.radians = math.degrees_to_radians(360 / total_slots_count)
			tbl.priority = v.priority
			tbl.position_check_index = tbl_2.CHECK_MIDDLE

			local num = (k_2 - 1) % 9 + 1

			tbl.debug_color_name = SlotTypeSettings[k].debug_color
			slots[k_2] = tbl
		end
	end
end

local function fn_2(self, arg_4_1)
	-- function 4
	if not self then
		return
	end

	local ai_unit = self.ai_unit

	if not ai_unit then
		local var_4_1 = arg_4_1[ai_unit]

		if not var_4_1 then
			var_4_1.slot = nil
		end

		Managers.state.debug_text:clear_unit_text(ai_unit, "slot_index")
	end

	local queue = self.queue
	local count = #queue

	for i = 1, count do
		local var_4_4 = arg_4_1[queue[i]]

		if not var_4_4 then
			var_4_4.waiting_on_slot = nil
		end
	end

	local var_4_5 = arg_4_1[self.target_unit]

	if not var_4_5 then
		local all_slots = var_4_5.all_slots

		for k, v in pairs(all_slots) do
			local slots = v.slots
			local count_2 = #slots

			for l = 1, count_2 do
				if slots[l] == self then
					slots[l] = slots[count_2]
					slots[l].index = l
					slots[count_2] = nil

					break
				end
			end
		end
	end
end

local function fn_3(self, arg_5_1)
	-- function 5
	local ai_unit = self.ai_unit

	if not ai_unit then
		arg_5_1[ai_unit].slot = nil
		self.ai_unit = nil
	end

	self.disabled = true
	self.released = false
end

local function fn_4(self)
	-- function 6
	self.disabled = false
end

local function fn_5(arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	local all_slots = arg_7_1[arg_7_0].all_slots
	local num = 0
	local var_7_2 = all_slots[arg_7_2]
	local slots = var_7_2.slots
	local total_slots_count = var_7_2.total_slots_count

	for i = 1, total_slots_count do
		local var_7_5 = slots[i]

		if not var_7_5.ai_unit then
			num = num + 1
		end

		num = num + #var_7_5.queue
	end

	return num
end

local function fn_6(arg_8_0, arg_8_1)
	-- function 8
	local var_8_0 = arg_8_1[arg_8_0]

	if not var_8_0 then
		return
	end

	local slot = var_8_0.slot
	local waiting_on_slot = var_8_0.waiting_on_slot

	if not slot then
		local queue = slot.queue
		local count = #queue

		if count > 0 then
			local var_8_5 = queue[count]
			local var_8_6 = arg_8_1[var_8_5]

			slot.ai_unit = var_8_5
			var_8_6.slot = slot
			var_8_6.waiting_on_slot = nil
			queue[count] = nil
		else
			slot.ai_unit = nil
		end

		Managers.state.debug_text:clear_unit_text(arg_8_0, "slot_index")

		local target_unit = slot.target_unit

		if not Unit.alive(target_unit) then
			local var_8_8 = arg_8_1[target_unit]
			local type = slot.type

			var_8_8.all_slots[type].slots_count = fn_5(target_unit, arg_8_1, type)
		end
	elseif not waiting_on_slot then
		local queue_2 = waiting_on_slot.queue
		local count_2 = #queue_2

		for i = 1, count_2 do
			if queue_2[i] == arg_8_0 then
				queue_2[i] = queue_2[count_2]
				queue_2[count_2] = nil
			end
		end
	end

	var_8_0.waiting_on_slot = nil
	var_8_0.slot = nil
end

AISlotSystem.hot_join_sync = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	return
end

local num_2 = 1
local num_3 = 1.75
local num_4 = num_3 * num_3
local num_5 = 1.5
local num_6 = 2
local num_7 = 3
local num_8 = 7.5
local num_9 = 4
local num_10 = 0.5
local num_11 = 0.25
local num_12 = 1
local num_13 = 1.5
local num_14 = 1.5
local num_15 = 0.5
local num_16 = num_15 + 0.6
local num_17 = 2

AISlotSystem.do_slot_search = function (self, arg_10_1, arg_10_2)
	-- function 10
	local var_10_0 = self.unit_extension_data[arg_10_1]

	if not var_10_0 then
		var_10_0.do_search = arg_10_2
	end
end

local triangle_from_position = GwNavQueries.triangle_from_position
local inside_position_from_outside_position = GwNavQueries.inside_position_from_outside_position
local raycango = GwNavQueries.raycango

local function fn_7(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	arg_11_3 = arg_11_3 or num_14
	arg_11_2 = arg_11_2 or num_13

	local var_11_0
	local var_11_1, var_11_2 = triangle_from_position(arg_11_1, arg_11_0, arg_11_2, arg_11_3)

	if not var_11_1 then
		var_11_0 = copy(arg_11_0)
		var_11_0.z = var_11_2
	end

	return not var_11_1 and var_11_0 and nil
end

function get_target_pos_on_navmesh(arg_12_0, arg_12_1)
	-- function 12
	local var_12_0 = fn_7(arg_12_0, arg_12_1)

	if not var_12_0 then
		return var_12_0
	end

	local var_12_1 = num_13
	local var_12_2 = num_14
	local num = 1
	local num_2 = 0.05
	local var_12_5 = inside_position_from_outside_position(arg_12_1, arg_12_0, var_12_1, var_12_2, num, num_2)

	if not var_12_5 then
		return var_12_5
	end

	local var_12_6 = num_13
	local var_12_7 = num_8
	local var_12_8 = fn_7(arg_12_0, arg_12_1, var_12_6, var_12_7)

	if not var_12_8 then
		return var_12_8
	end

	return nil
end

local num_18 = 100
local num_19 = 3
local num_20 = 2
local num_21 = 3

local function fn_8(self, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	-- function 13
	local target_unit = arg_13_1.target_unit
	local ai_unit = arg_13_1.ai_unit

	if not (not HEALTH_ALIVE[target_unit] and ALIVE[ai_unit]) then
		return
	end

	local slot_template = self[ai_unit].slot_template
	local type = arg_13_1.type
	local distance_2 = SlotTypeSettings[type].distance
	local var_13_5 = self[target_unit]
	local var_13_6 = var_13_5.full_slots_at_t[type]
	local min_wait_queue_distance = slot_template.min_wait_queue_distance

	min_wait_queue_distance = min_wait_queue_distance or num_19

	local num = min_wait_queue_distance * min_wait_queue_distance
	local num_2 = 0

	if not var_13_6 and not slot_template.min_queue_offset_distance then
		local min_queue_offset_distance = slot_template.min_queue_offset_distance
		local full_offset_time = slot_template.full_offset_time
		local num_3 = arg_13_4 - var_13_6

		num_2 = min_queue_offset_distance * math.min(num_3 / full_offset_time, 1)
	end

	local unbox = var_13_5.position:unbox()
	local var_13_14 = POSITION_LOOKUP[ai_unit]
	local unbox_2 = arg_13_1.queue_direction:unbox()
	local flag = arg_13_3 or 0
	local var_13_17 = distance(unbox, var_13_14)
	local queue_distance = SlotTypeSettings[type].queue_distance
	local num_4 = unbox + unbox_2 * math.max(var_13_17 + queue_distance + flag - num_2, min_wait_queue_distance)
	local var_13_20 = fn_7(num_4, arg_13_2, num_20, num_21)
	local num_5 = 5
	local num_6 = 1

	while not (var_13_20 or not (num_6 <= num_5)) do
		local max = math.max(math.max(var_13_17 * (1 - num_6 / num_5), distance_2) + queue_distance + flag - num_2, min_wait_queue_distance)
		local num_7 = unbox + unbox_2 * math.max(max, 0.5)

		var_13_20 = fn_7(num_7, arg_13_2, num_20, num_21)
		num_6 = num_6 + 1
	end

	local num_8 = 0
	local var_13_26

	if not var_13_20 then
		local var_13_27 = fn_7(unbox, arg_13_2, num_20, num_21)

		if not var_13_27 then
			var_13_26 = raycango(arg_13_2, var_13_20, var_13_27)
		end
	end

	if not (not var_13_20 and var_13_26) then
		num_8 = num_18

		local num_9 = unbox + unbox_2 * queue_distance

		if not slot_template.restricted_queue_distance then
			if num <= distance_squared(unbox, num_9) then
				return num_9, num_8
			else
				local var_13_29
				local var_13_30 = normalize(var_13_14 - unbox)
				local num_10 = 1

				while not (var_13_29 or not (num_10 <= num_5)) do
					local max_2 = math.max(math.max(var_13_17 * (1 - num_10 / num_5), distance_2) + queue_distance + flag - num_2, min_wait_queue_distance)

					num_9 = unbox + var_13_30 * math.max(max_2, 0.5)
					var_13_29 = fn_7(num_9, arg_13_2, num_20, num_21)
					num_10 = num_10 + 1
				end

				if not var_13_29 then
					return var_13_29, 0
				else
					return num_9, num_8
				end
			end
		else
			return num_9, num_8
		end
	else
		return var_13_20, num_8
	end
end

local function fn_9(arg_14_0, arg_14_1, arg_14_2)
	-- function 14
	local var_14_0

	if not ScriptUnit.has_extension(arg_14_0, "locomotion_system") then
		var_14_0 = ScriptUnit.extension(arg_14_0, "locomotion_system"):current_velocity()
	else
		var_14_0 = Vector3(0, 0, 0)
	end

	if length(var_14_0) > 0.1 then
		local var_14_1 = length(var_14_0)
		local var_14_2 = normalize(var_14_0)
		local num = var_14_2 * var_14_1
		local var_14_4 = normalize(arg_14_2 - arg_14_1)
		local var_14_5 = dot(var_14_4, var_14_2)

		return arg_14_1 + num * math.max(2 * (var_14_5 - 0.5), 0)
	else
		return arg_14_1
	end
end

AISlotSystem.improve_slot_position = function (self, arg_15_1, arg_15_2)
	-- function 15
	if not ALIVE[arg_15_1] then
		return
	end

	local var_15_0 = POSITION_LOOKUP[arg_15_1]
	local var_15_1 = self.unit_extension_data[arg_15_1]
	local slot = var_15_1.slot
	local waiting_on_slot = var_15_1.waiting_on_slot
	local var_15_4

	if not slot then
		if slot.ghost_position.x ~= 0 then
			var_15_4 = slot.ghost_position:unbox()
		else
			var_15_4 = slot.absolute_position:unbox()
		end
	elseif not (not waiting_on_slot and not (arg_15_2 > var_15_1.improve_wait_slot_position_t)) then
		local nav_world = self.nav_world
		local flag

		flag = waiting_on_slot.queue[1] ~= arg_15_1 or not -0.5 or 0.5

		local var_15_7 = fn_8(self.unit_extension_data, waiting_on_slot, nav_world, flag, arg_15_2)
		local var_15_8 = num_5
		local var_15_9 = num_6
		local var_15_10 = num_7
		local num = 0
		local var_15_12 = num_3
		local num_2 = 2
		local new_random_goal_uniformly_distributed_with_inside_from_outside_on_last = LocomotionUtils.new_random_goal_uniformly_distributed_with_inside_from_outside_on_last
		local var_15_15

		if not var_15_7 then
			var_15_15 = new_random_goal_uniformly_distributed_with_inside_from_outside_on_last(nav_world, nil, var_15_7, num, var_15_12, num_2, nil, var_15_8, var_15_9, var_15_10)

			if not var_15_15 then
				-- Nothing
			end
		end

		var_15_15 = nil

		do
			local abs
		end

		::label_15_0::

		if not var_15_15 then
			abs = math.abs(var_15_0.z - var_15_15.z)

			if not abs then
				-- Nothing
			end
		end

		abs = 0

		::label_15_1::

		local flag_2 = abs > num_13
		local var_15_18

		if not var_15_15 then
			var_15_18 = distance(var_15_15, var_15_0)

			if not var_15_18 then
				-- Nothing
			end
		end

		var_15_18 = math.huge

		::label_15_2::

		local flag_3 = var_15_18 < 5

		var_15_4 = var_15_15

		if not flag_2 and not flag_3 then
			var_15_4 = nil
		end

		var_15_1.wait_slot_distance = var_15_18
		var_15_1.improve_wait_slot_position_t = arg_15_2 + Math.random() * 0.4
	else
		return
	end

	if not var_15_4 then
		return
	end

	local var_15_20 = distance_squared(var_15_0, var_15_4)
	local extension = ScriptUnit.extension(arg_15_1, "ai_navigation_system")
	local destination = extension:destination()

	if not (var_15_20 > 1 or not (dot(var_15_4 - var_15_0, destination - var_15_0) < 0)) then
		extension:move_to(var_15_4)
	end
end

AISlotSystem.ai_unit_have_slot = function (self, arg_16_1)
	-- function 16
	local var_16_0 = self.unit_extension_data[arg_16_1]

	if not var_16_0 then
		return false
	end

	if not var_16_0.slot then
		return false
	end

	return true
end

AISlotSystem.ai_unit_have_wait_slot = function (self, arg_17_1)
	-- function 17
	local var_17_0 = self.unit_extension_data[arg_17_1]

	if not var_17_0 then
		return false
	end

	if not var_17_0.waiting_on_slot then
		return false
	end

	return true
end

AISlotSystem.ai_unit_wait_slot_distance = function (self, arg_18_1)
	-- function 18
	local var_18_0 = self.unit_extension_data[arg_18_1]

	if not var_18_0 then
		return math.huge
	end

	if not var_18_0.slot then
		return math.huge
	end

	if not var_18_0.waiting_on_slot then
		return math.huge
	end

	local wait_slot_distance = var_18_0.wait_slot_distance

	wait_slot_distance = wait_slot_distance or math.huge

	return wait_slot_distance
end

AISlotSystem.ai_unit_slot_position = function (self, arg_19_1)
	-- function 19
	local var_19_0 = self.unit_extension_data[arg_19_1]

	if not var_19_0 then
		return nil
	end

	local slot = var_19_0.slot

	slot = slot or var_19_0.waiting_on_slot

	if not slot then
		return slot.absolute_position:unbox()
	end

	return nil
end

AISlotSystem.ai_unit_blocked_attack = function (self, arg_20_1)
	-- function 20
	local var_20_0 = self.unit_extension_data[arg_20_1]

	if not var_20_0 and not var_20_0.waiting_on_slot then
		return nil
	end

	if not var_20_0.slot then
		return nil
	end

	local slot_template = var_20_0.slot_template

	if not slot_template.abandon_slot_when_blocked then
		if not slot_template.abandon_slot_when_blocked_time then
			var_20_0.delayed_prioritized_ai_unit_update_time = Managers.time:time("game") + slot_template.abandon_slot_when_blocked_time
		else
			fn_6(arg_20_1, self.unit_extension_data)
			self:register_prioritized_ai_unit_update(arg_20_1)
		end
	end
end

AISlotSystem.ai_unit_staggered = function (self, arg_21_1)
	-- function 21
	local var_21_0 = self.unit_extension_data[arg_21_1]

	if not var_21_0 and not var_21_0.waiting_on_slot then
		return nil
	end

	if not var_21_0.slot then
		return nil
	end

	local slot_template = var_21_0.slot_template

	if not slot_template.abandon_slot_when_staggered then
		if not slot_template.abandon_slot_when_staggered_time then
			var_21_0.delayed_prioritized_ai_unit_update_time = Managers.time:time("game") + slot_template.abandon_slot_when_staggered_time
		else
			fn_6(arg_21_1, self.unit_extension_data)
			self:register_prioritized_ai_unit_update(arg_21_1)
		end
	end
end

AISlotSystem.get_target_unit_slot_data = function (self, arg_22_1, arg_22_2)
	-- function 22
	local var_22_0 = self.unit_extension_data[arg_22_1].all_slots[arg_22_2]

	if not var_22_0 then
		return
	end

	return var_22_0.slots
end

AISlotSystem.slots_count = function (self, arg_23_1, arg_23_2)
	-- function 23
	local var_23_0 = self.unit_extension_data[arg_23_1]
	local flag = arg_23_2 or str

	return var_23_0.all_slots[flag].slots_count
end

AISlotSystem.total_slots_count = function (self, arg_24_1, arg_24_2)
	-- function 24
	local var_24_0 = self.unit_extension_data[arg_24_1]
	local flag = arg_24_2 or str

	return var_24_0.all_slots[flag].total_slots_count
end

AISlotSystem.disabled_slots_count = function (self, arg_25_1, arg_25_2)
	-- function 25
	local var_25_0 = self.unit_extension_data[arg_25_1]
	local flag = arg_25_2 or str

	return var_25_0.all_slots[flag].disabled_slots_count
end

AISlotSystem.set_release_slot_lock = function (self, arg_26_1, arg_26_2)
	-- function 26
	local var_26_0 = self.unit_extension_data[arg_26_1]

	if not var_26_0 then
		var_26_0.release_slot_lock = arg_26_2
	end
end

local function fn_10(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	-- function 27
	local var_27_0 = arg_27_3[arg_27_1]

	if not (not var_27_0.slot and var_27_0.slot.target_unit == arg_27_0) then
		fn_6(arg_27_1, arg_27_3)
	end

	if not Unit.alive(arg_27_0) then
		var_27_0.target = nil

		var_27_0.target_position:store(0, 0, 0)

		if not var_27_0.slot then
			fn_6(arg_27_1, arg_27_3)
		end

		return
	end

	local var_27_1 = POSITION_LOOKUP[arg_27_0]

	var_27_0.target_position:store(var_27_1)
end

local rotate = Quaternion.rotate

local function fn_11(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	-- function 28
	local var_28_0 = normalize(flat(arg_28_1 - arg_28_0))
	local var_28_1 = Quaternion(-Vector3.up(), arg_28_2)

	return arg_28_0 + rotate(var_28_1, var_28_0) * arg_28_3
end

local function fn_12(self, arg_29_1)
	-- function 29
	local unbox = arg_29_1.position:unbox()
	local unbox_2 = self.original_absolute_position:unbox()
	local type = self.type
	local distance = SlotTypeSettings[type].distance
	local radians = self.radians
	local var_29_5 = fn_11(unbox, unbox_2, radians, distance)
	local var_29_6 = fn_11(unbox, unbox_2, -radians, distance)

	self.position_right:store(var_29_5)
	self.position_left:store(var_29_6)
end

local function fn_13(self, arg_30_1, arg_30_2)
	-- function 30
	local unbox = arg_30_2.position:unbox()
	local var_30_1 = normalize(flat(arg_30_1 - unbox))

	self.absolute_position:store(arg_30_1)
	self.queue_direction:store(var_30_1)
	fn_12(self, arg_30_2)
end

function get_slot_position_on_navmesh(arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5, arg_31_6, arg_31_7, arg_31_8)
	-- function 31
	local var_31_0

	if not arg_31_3 then
		var_31_0 = fn_11(arg_31_1, arg_31_2, arg_31_3, arg_31_4)

		if not var_31_0 then
			-- Nothing
		end
	end

	var_31_0 = arg_31_2

	do
		local var_31_1
	end

	::label_31_0::

	if not arg_31_5 then
		var_31_1 = fn_9(arg_31_0, var_31_0, arg_31_1)

		if not var_31_1 then
			-- Nothing
		end
	end

	var_31_1 = var_31_0

	::label_31_1::

	return fn_7(var_31_1, arg_31_6, arg_31_7, arg_31_8), var_31_0
end

local function fn_14(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6)
	-- function 32
	local var_32_0
	local num = 10
	local num_2 = 0.15

	if not arg_32_2 then
		local var_32_3 = Quaternion(-Vector3.up(), arg_32_2)

		arg_32_1 = rotate(var_32_3, arg_32_1)
	end

	for i = 0, num - 1 do
		local num_3 = arg_32_0 + arg_32_1 * (i * num_2 + arg_32_3)

		var_32_0 = fn_7(num_3, arg_32_4, arg_32_5, arg_32_6)

		if not var_32_0 then
			break
		end
	end

	return var_32_0, var_32_0
end

local function fn_15(self, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5, arg_33_6, arg_33_7, arg_33_8, arg_33_9, arg_33_10)
	-- function 33
	local var_33_0, var_33_1 = get_slot_position_on_navmesh(arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5, arg_33_6, arg_33_7, arg_33_9, arg_33_10)
	local position_check_index = self.position_check_index
	local flag = position_check_index == tbl_2.CHECK_MIDDLE
	local var_33_4

	if not flag then
		var_33_4 = tbl_3[position_check_index]

		if not var_33_4 then
			-- Nothing
		end
	end

	var_33_4 = nil

	::label_33_0::

	local var_33_5 = num_16

	if not var_33_0 then
		local var_33_6

		if not flag then
			var_33_6 = var_33_0
		else
			var_33_6 = fn_11(var_33_0, arg_33_2, var_33_4, num)
		end

		local num_2 = arg_33_2 + normalize(var_33_6 - arg_33_2) * var_33_5

		if not raycango(arg_33_7, var_33_6, num_2, arg_33_8) then
			var_33_0 = nil
		end
	elseif not flag then
		local var_33_8 = fn_11(arg_33_3, arg_33_2, var_33_4, num)

		var_33_0, var_33_1 = get_slot_position_on_navmesh(arg_33_1, arg_33_2, var_33_8, arg_33_4, arg_33_5, arg_33_6, arg_33_7, arg_33_9, arg_33_10)

		if not var_33_0 then
			local num_3 = arg_33_2 + normalize(var_33_0 - arg_33_2) * var_33_5

			if not raycango(arg_33_7, var_33_0, num_3, arg_33_8) then
				self.position_check_index = tbl_2.CHECK_MIDDLE
			else
				var_33_0 = nil
			end
		end
	end

	if not var_33_0 then
		self.position_check_index = (self.position_check_index + 1) % size
	end

	return var_33_0, var_33_1
end

local function fn_16(self, arg_34_1, arg_34_2)
	-- function 34
	local target_unit = self.target_unit
	local unbox = self.absolute_position:unbox()
	local count_2 = #arg_34_1

	for i = 1, count_2 do
		repeat
			local var_34_3 = arg_34_1[i]

			if var_34_3 == target_unit then
				break
			end

			local all_slots = arg_34_2[var_34_3].all_slots

			for j = 1, count do
				local var_34_5 = tbl_4[j]
				local var_34_6 = all_slots[var_34_5]
				local radius = SlotTypeSettings[var_34_5].radius
				local num = radius * radius
				local slots = var_34_6.slots
				local total_slots_count = var_34_6.total_slots_count

				for k = 1, total_slots_count do
					repeat
						local var_34_11 = slots[k]

						if not var_34_11.disabled then
							break
						end

						local unbox_2 = var_34_11.absolute_position:unbox()

						if num > distance_squared(unbox, unbox_2) then
							return var_34_11
						end
					until true
				end
			end
		until true
	end

	return false
end

local function fn_17(self, arg_35_1)
	-- function 35
	local unbox = self.absolute_position:unbox()
	local type = self.type
	local all_slots = arg_35_1[self.target_unit].all_slots
	local var_35_3 = distance_squared

	for i = 1, count do
		repeat
			local var_35_4 = tbl_4[i]
			local var_35_5 = all_slots[var_35_4]

			if type == var_35_4 then
				break
			end

			local radius = SlotTypeSettings[var_35_4].radius
			local num = radius * radius
			local slots = var_35_5.slots
			local total_slots_count = var_35_5.total_slots_count

			for j = 1, total_slots_count do
				repeat
					local var_35_10 = slots[j]

					if not var_35_10.disabled then
						break
					end

					if not var_35_10.ai_unit then
						break
					end

					local unbox_2 = var_35_10.absolute_position:unbox()
					local priority = var_35_10.priority

					if num > var_35_3(unbox, unbox_2) then
						return var_35_10
					end
				until true
			end
		until true
	end

	return false
end

local num_22 = 1.2
local num_23 = num_22 * num_22

local function fn_18(self, arg_36_1, arg_36_2)
	-- function 36
	local target_unit = self.target_unit
	local unbox = self.absolute_position:unbox()
	local count = #arg_36_1
	local var_36_3 = distance_squared

	for i = 1, count do
		repeat
			local var_36_4 = arg_36_1[i]

			if var_36_4 == target_unit then
				break
			end

			local unbox_2 = arg_36_2[var_36_4].position:unbox()

			if var_36_3(unbox, unbox_2) < num_23 then
				return true
			end
		until true
	end

	return false
end

local function fn_19(self, arg_37_1, arg_37_2, arg_37_3)
	-- function 37
	local priority = self.priority
	local priority_2 = arg_37_1.priority
	local index = arg_37_2[self.target_unit].index
	local index_2 = self.index
	local index_3 = arg_37_2[arg_37_1.target_unit].index
	local index_4 = arg_37_1.index

	if not (not (priority < priority_2) or self.ai_unit) then
		return
	elseif not (not (priority_2 < priority) or arg_37_1.ai_unit) then
		return
	end

	if priority < priority_2 then
		fn_3(arg_37_1, arg_37_2)

		return false
	elseif priority_2 < priority then
		fn_3(self, arg_37_2)

		return true
	end

	if index_4 < index_2 then
		fn_3(self, arg_37_2)

		return true
	end

	if index_2 < index_4 then
		fn_3(arg_37_1, arg_37_2)

		return false
	end

	if index_3 < index then
		fn_3(self, arg_37_2)

		return true
	else
		fn_3(arg_37_1, arg_37_2)

		return false
	end
end

local function fn_20(self, arg_38_1, arg_38_2)
	-- function 38
	local unbox = self.original_absolute_position:unbox()
	local var_38_1 = POSITION_LOOKUP[arg_38_1]
	local target_unit = self.target_unit
	local unbox_2 = arg_38_2.position:unbox()
	local var_38_4 = flat(unbox - unbox_2)
	local var_38_5 = normalize(var_38_4)
	local var_38_6 = flat(var_38_1 - unbox_2)
	local var_38_7 = normalize(var_38_6)
	local var_38_8 = dot(var_38_5, var_38_7)

	return var_38_8 < 0.6, var_38_8
end

local function fn_21(self)
	-- function 39
	self.ghost_position:store(Vector3(0, 0, 0))
end

local num_24 = 90
local degrees_to_radians = math.degrees_to_radians(num_24)

local function fn_22(self, arg_40_1, arg_40_2, arg_40_3)
	-- function 40
	local unbox = arg_40_1.absolute_position:unbox()
	local ai_unit = arg_40_1.ai_unit
	local var_40_2 = POSITION_LOOKUP[ai_unit]
	local unbox_2 = self.position:unbox()
	local min = math.min(distance(unbox_2, var_40_2), 8)
	local var_40_5 = fn_11(unbox, var_40_2, -degrees_to_radians, min)
	local var_40_6 = fn_11(unbox, var_40_2, degrees_to_radians, min)
	local flag = not (distance_squared(unbox_2, var_40_5) > distance_squared(unbox_2, var_40_6)) and var_40_5 and var_40_6
	local var_40_8 = fn_7(flag, arg_40_2)
	local var_40_9

	if not var_40_8 then
		var_40_9 = normalize(var_40_8 - unbox)
	else
		var_40_9 = normalize(flag - unbox)
	end

	local num = 5

	for i = 1, num do
		if not var_40_8 and not raycango(arg_40_2, var_40_8, unbox, arg_40_3) then
			arg_40_1.ghost_position:store(var_40_8)

			return
		end

		local type = arg_40_1.type
		local distance_2 = SlotTypeSettings[type].distance
		local num_2 = unbox_2 + var_40_9 * (distance_2 + (min - distance_2) * (num - i) / num)

		var_40_8 = fn_7(num_2, arg_40_2)
	end

	fn_21(arg_40_1)
end

local function fn_23(self, arg_41_1, arg_41_2)
	-- function 41
	local var_41_0 = arg_41_2[arg_41_1]
	local type = self.type
	local var_41_2 = var_41_0.all_slots[type]
	local slots = var_41_2.slots
	local index = self.index
	local total_slots_count = var_41_2.total_slots_count
	local num = 128
	local ai_unit = self.ai_unit

	ai_unit = not ai_unit and not self.released

	local flag

	flag = not ai_unit and 256 and 0
	self.anchor_weight = flag

	for i = 1, total_slots_count do
		local num_2 = index + i

		if total_slots_count < num_2 then
			num_2 = num_2 - total_slots_count
		end

		local var_41_10 = slots[num_2]
		local disabled = var_41_10.disabled
		local released = var_41_10.released
		local ai_unit_2 = var_41_10.ai_unit

		if not (disabled or ai_unit_2) then
			break
		end

		if not released then
			self.anchor_weight = self.anchor_weight + num
			num = num / 2
		end
	end

	local num_3 = 128

	for j = 1, total_slots_count do
		local num_4 = index - j

		if num_4 < 1 then
			num_4 = num_4 + total_slots_count
		end

		local var_41_16 = slots[num_4]
		local disabled_2 = var_41_16.disabled
		local released_2 = var_41_16.released
		local ai_unit_3 = var_41_16.ai_unit

		if not (disabled_2 or ai_unit_3) then
			break
		end

		if not released_2 then
			self.anchor_weight = self.anchor_weight + num_3
			num_3 = num_3 / 2
		end
	end
end

local function fn_24(arg_42_0, arg_42_1)
	-- function 42
	local all_slots = arg_42_1[arg_42_0].all_slots

	for i = 1, count do
		local var_42_1 = all_slots[tbl_4[i]]
		local slots = var_42_1.slots
		local total_slots_count = var_42_1.total_slots_count

		for j = 1, total_slots_count do
			local var_42_4 = slots[j]

			fn_23(var_42_4, arg_42_0, arg_42_1)
		end
	end
end

local num_25 = 3
local num_26 = num_25 * num_25

local function fn_25(self, arg_43_1)
	-- function 43
	if not self.disabled then
		return
	end

	local ai_unit = self.ai_unit

	if not ai_unit then
		self.released = false

		return
	end

	if not arg_43_1[ai_unit].release_slot_lock then
		local var_43_1 = POSITION_LOOKUP[ai_unit]
		local unbox = self.absolute_position:unbox()

		self.released = distance_squared(var_43_1, unbox) > num_26
	else
		self.released = false
	end
end

local function fn_26(arg_44_0, arg_44_1, arg_44_2)
	-- function 44
	local var_44_0 = arg_44_2[arg_44_1].all_slots[arg_44_0]
	local slots = var_44_0.slots
	local total_slots_count = var_44_0.total_slots_count
	local var_44_3 = slots[1]
	local anchor_weight = var_44_3.anchor_weight

	for i = 1, total_slots_count do
		repeat
			local var_44_5 = slots[i]

			if not var_44_5.disabled then
				break
			end

			local anchor_weight_2 = var_44_5.anchor_weight

			if not (anchor_weight < anchor_weight_2 or anchor_weight_2 ~= anchor_weight or not (var_44_5.index < var_44_3.index)) then
				var_44_3 = var_44_5
				anchor_weight = anchor_weight_2
			end
		until true
	end

	return var_44_3
end

local num_27 = 24

local function fn_27(self, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6, arg_45_7)
	-- function 45
	local target_unit = self.target_unit
	local var_45_1 = arg_45_1[target_unit]
	local unbox = var_45_1.position:unbox()
	local ai_unit = self.ai_unit
	local flag = not ai_unit and POSITION_LOOKUP[ai_unit]
	local var_45_5

	if not ai_unit then
		var_45_5 = normalize(flag - unbox)

		if not var_45_5 then
			-- Nothing
		end
	end

	var_45_5 = Vector3.forward()

	::label_45_0::

	local type = self.type
	local distance = SlotTypeSettings[type].distance
	local num = unbox + var_45_5 * distance
	local var_45_9
	local var_45_10

	if not arg_45_7 then
		var_45_9, var_45_10 = fn_14(unbox, var_45_5, nil, distance, arg_45_3, arg_45_5, arg_45_6)
	else
		var_45_9, var_45_10 = fn_15(self, target_unit, unbox, num, nil, nil, arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6)
	end

	local num_2 = 0

	while not (not (num_2 <= num_27) or var_45_9) do
		local flag_2

		flag_2 = not (num_2 % 2 > 0) or not -1 or 1

		local num_3 = math.ceil(num_2 / 2) * flag_2

		if not arg_45_7 then
			var_45_9, var_45_10 = fn_14(unbox, var_45_5, num_3, distance, arg_45_3, arg_45_5, arg_45_6)
		else
			var_45_9, var_45_10 = fn_15(self, target_unit, unbox, num, num_3, distance, arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6)
		end

		num_2 = num_2 + 1
	end

	if not var_45_9 then
		self.original_absolute_position:store(var_45_10)
		fn_13(self, var_45_9, var_45_1)

		return true, var_45_9
	else
		self.original_absolute_position:store(num)
		fn_13(self, num, var_45_1)

		return false, num
	end
end

local function fn_28(arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4, arg_46_5, arg_46_6, arg_46_7, arg_46_8, arg_46_9)
	-- function 46
	local var_46_0 = arg_46_3[arg_46_0]
	local unbox = var_46_0.position:unbox()
	local var_46_2
	local var_46_3
	local type = arg_46_1.type
	local distance = SlotTypeSettings[type].distance

	if not arg_46_9 then
		var_46_2, var_46_3 = fn_14(unbox, normalize(arg_46_2 - unbox), nil, distance, arg_46_5, arg_46_7, arg_46_8)
	else
		var_46_2, var_46_3 = fn_15(arg_46_1, arg_46_0, unbox, arg_46_2, nil, nil, arg_46_4, arg_46_5, arg_46_6, arg_46_7, arg_46_8)
	end

	if not var_46_2 then
		arg_46_1.original_absolute_position:store(var_46_3)
		fn_13(arg_46_1, var_46_2, var_46_0)

		return true, var_46_2
	else
		arg_46_1.original_absolute_position:store(arg_46_2)
		fn_13(arg_46_1, arg_46_2, var_46_0)

		return false, arg_46_2
	end
end

local function fn_29(arg_47_0, arg_47_1)
	-- function 47
	local all_slots = arg_47_1[arg_47_0].all_slots

	for k, v in pairs(all_slots) do
		local slots = v.slots
		local total_slots_count = v.total_slots_count

		for k_2 = 1, total_slots_count do
			local var_47_3 = slots[k_2]

			fn_3(var_47_3, arg_47_1)
		end
	end
end

local function fn_30(arg_48_0, arg_48_1, arg_48_2, arg_48_3)
	-- function 48
	if not arg_48_1 then
		fn_4(arg_48_0)
	else
		fn_3(arg_48_0, arg_48_3)

		return false
	end

	if not fn_18(arg_48_0, arg_48_2, arg_48_3) then
		fn_4(arg_48_0)
	else
		fn_3(arg_48_0, arg_48_3)

		return false
	end

	local var_48_0 = fn_16(arg_48_0, arg_48_2, arg_48_3)

	if not var_48_0 then
		if not fn_19(arg_48_0, var_48_0, arg_48_3) then
			fn_4(arg_48_0)
		else
			return false
		end
	end

	local var_48_1 = fn_17(arg_48_0, arg_48_3)

	if not var_48_1 then
		if not fn_19(arg_48_0, var_48_1, arg_48_3) then
			fn_4(arg_48_0)
		else
			return false
		end
	end

	fn_25(arg_48_0, arg_48_3)

	return true
end

local function fn_31(arg_49_0, arg_49_1, arg_49_2, arg_49_3, arg_49_4, arg_49_5, arg_49_6)
	-- function 49
	local var_49_0 = arg_49_2[arg_49_0]
	local all_slots = var_49_0.all_slots

	for i = 1, count do
		local var_49_2 = tbl_4[i]
		local var_49_3 = all_slots[var_49_2]
		local slots = var_49_3.slots
		local total_slots_count = var_49_3.total_slots_count
		local flag = false

		for j = 1, total_slots_count do
			local var_49_7 = slots[j]
			local unbox = var_49_7.absolute_position:unbox()
			local var_49_9 = fn_28(arg_49_0, var_49_7, unbox, arg_49_2, flag, arg_49_3, arg_49_4, nil, nil, arg_49_5)

			fn_30(var_49_7, var_49_9, arg_49_1, arg_49_2)
		end

		fn_24(arg_49_0, arg_49_2)

		local disabled_slots_count = var_49_3.disabled_slots_count
		local flag_2 = var_49_0.num_occupied_slots >= total_slots_count - disabled_slots_count

		if not (not flag_2 and var_49_0.full_slots_at_t[var_49_2]) then
			var_49_0.full_slots_at_t[var_49_2] = arg_49_6
		elseif not flag_2 then
			var_49_0.full_slots_at_t[var_49_2] = nil
		end
	end
end

local function fn_32(arg_50_0, arg_50_1, arg_50_2, arg_50_3, arg_50_4, arg_50_5, arg_50_6, arg_50_7, arg_50_8)
	-- function 50
	local var_50_0 = arg_50_2[arg_50_0]
	local all_slots = var_50_0.all_slots

	for k, v in pairs(all_slots) do
		local slots = v.slots
		local total_slots_count = v.total_slots_count
		local num = 1
		local var_50_5 = normalize(flat(Quaternion.forward(Unit.world_rotation(arg_50_6, 0))))
		local cross = Vector3.cross(var_50_5, Vector3.up())
		local floor = math.floor(total_slots_count / 2)
		local ceil = math.ceil(floor / 2)
		local var_50_9 = slots[ceil]

		var_50_9.original_absolute_position:store(arg_50_8)
		fn_13(var_50_9, arg_50_8, var_50_0)
		fn_30(var_50_9, true, arg_50_1, arg_50_2)

		local var_50_10 = arg_50_8
		local flag = true

		for k_2 = ceil - 1, 1, -1 do
			local var_50_12 = slots[k_2]
			local num_2 = var_50_10 - cross * num

			flag = not flag and raycango(arg_50_4, var_50_10, num_2, arg_50_5)

			var_50_12.original_absolute_position:store(num_2)
			fn_13(var_50_12, num_2, var_50_0)
			fn_30(var_50_12, flag, arg_50_1, arg_50_2)

			var_50_10 = num_2
		end

		local var_50_14 = arg_50_8
		local flag_2 = true

		for l = ceil + 1, floor do
			local var_50_16 = slots[l]
			local num_3 = var_50_14 + cross * num

			flag_2 = not flag_2 and raycango(arg_50_4, var_50_14, num_3, arg_50_5)

			var_50_16.original_absolute_position:store(num_3)
			fn_13(var_50_16, num_3, var_50_0)
			fn_30(var_50_16, flag_2, arg_50_1, arg_50_2)
		end

		local num_4 = floor + math.ceil((total_slots_count - floor) / 2)
		local var_50_19 = slots[num_4]

		var_50_19.original_absolute_position:store(arg_50_7)
		fn_13(var_50_19, arg_50_7, var_50_0)
		fn_30(var_50_19, true, arg_50_1, arg_50_2)

		local var_50_20 = arg_50_7
		local num_5 = 1
		local num_6 = 1
		local num_7 = 1
		local num_8 = arg_50_7 + num_7 * var_50_5
		local num_9 = num_4 - 1 - floor
		local num_10 = math.pi / 2.5 / num_9
		local num_11 = 1

		for i4 = num_4 - 1, floor + 1, -1 do
			local var_50_28 = slots[i4]
			local num_12 = math.pi * 1.5 + num_11 * num_10
			local num_13 = num_8 + num_7 * (cross * math.cos(num_12) + var_50_5 * math.sin(num_12))
			local var_50_31
			local var_50_32, var_50_33 = triangle_from_position(arg_50_4, var_50_20, num_5, num_6)

			if not var_50_32 then
				num_13.z = var_50_33
			end

			var_50_28.original_absolute_position:store(num_13)
			fn_13(var_50_28, num_13, var_50_0)
			fn_30(var_50_28, var_50_32, arg_50_1, arg_50_2)

			num_11 = num_11 + 1
		end

		local num_14 = total_slots_count - num_4
		local num_15 = math.pi / 2.5 / num_14
		local num_16 = 1
		local var_50_37 = arg_50_7

		for i5 = num_4 + 1, total_slots_count do
			local var_50_38 = slots[i5]
			local num_17 = math.pi * 1.5 - num_16 * num_15
			local num_18 = num_8 + num_7 * (cross * math.cos(num_17) + var_50_5 * math.sin(num_17))
			local var_50_41
			local var_50_42, var_50_43 = triangle_from_position(arg_50_4, var_50_37, num_5, num_6)

			if not var_50_42 then
				num_18.z = var_50_43
			end

			var_50_38.original_absolute_position:store(num_18)
			fn_13(var_50_38, num_18, var_50_0)
			fn_30(var_50_38, var_50_42, arg_50_1, arg_50_2)

			num_16 = num_16 + 1
		end

		fn_24(arg_50_0, arg_50_2)
	end
end

local function fn_33(arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4, arg_51_5, arg_51_6, arg_51_7, arg_51_8, arg_51_9, arg_51_10)
	-- function 51
	if not arg_51_6 then
		fn_32(arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4, arg_51_5, arg_51_7, arg_51_8, arg_51_9)

		return
	end

	local var_51_0
	local var_51_1

	if not arg_51_10 then
		var_51_0, var_51_1 = num_9, num_8
	else
		var_51_0, var_51_1 = num_13, num_14
	end

	local all_slots = arg_51_2[arg_51_0].all_slots

	for i = 1, count do
		local var_51_3 = tbl_4[i]
		local var_51_4 = all_slots[var_51_3]
		local slots = var_51_4.slots
		local var_51_6 = fn_26(var_51_3, arg_51_0, arg_51_2)
		local total_slots_count = var_51_4.total_slots_count
		local index = var_51_6.index
		local var_51_9 = fn_27(var_51_6, arg_51_2, arg_51_3, arg_51_4, arg_51_5, var_51_0, var_51_1, arg_51_10)

		fn_30(var_51_6, var_51_9, arg_51_1, arg_51_2)

		for j = index + 1, total_slots_count do
			local var_51_10 = slots[j]
			local unbox = slots[j - 1].position_right:unbox()
			local var_51_12 = fn_28(arg_51_0, var_51_10, unbox, arg_51_2, arg_51_3, arg_51_4, arg_51_5, var_51_0, var_51_1, arg_51_10)

			fn_30(var_51_10, var_51_12, arg_51_1, arg_51_2)
		end

		for k = index - 1, 1, -1 do
			local var_51_13 = slots[k]
			local unbox_2 = slots[k + 1].position_left:unbox()
			local var_51_15 = fn_28(arg_51_0, var_51_13, unbox_2, arg_51_2, arg_51_3, arg_51_4, arg_51_5, var_51_0, var_51_1, arg_51_10)

			fn_30(var_51_13, var_51_15, arg_51_1, arg_51_2)
		end

		fn_24(arg_51_0, arg_51_2)
	end

	fn_24(arg_51_0, arg_51_2)
end

local num_28 = -3
local num_29 = -2

local function fn_34(arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4, arg_52_5, arg_52_6)
	-- function 52
	local var_52_0 = POSITION_LOOKUP[arg_52_2]
	local var_52_1 = arg_52_3[arg_52_2]
	local var_52_2 = arg_52_3[arg_52_0]
	local use_slot_type = var_52_1.use_slot_type

	use_slot_type = use_slot_type or str

	local var_52_4 = var_52_2.all_slots[use_slot_type]
	local slots = var_52_4.slots
	local var_52_6
	local huge = math.huge
	local slot = var_52_1.slot
	local disabled_slots_count = var_52_4.disabled_slots_count
	local slots_count = var_52_4.slots_count
	local total_slots_count = var_52_4.total_slots_count
	local num = total_slots_count - disabled_slots_count
	local slot_template = var_52_1.slot_template
	local avoid_slots_behind_overwhelmed_target = slot_template.avoid_slots_behind_overwhelmed_target
	local flag = not slot_template and not avoid_slots_behind_overwhelmed_target and not (disabled_slots_count >= 2) or num <= slots_count

	for i = 1, total_slots_count do
		repeat
			local var_52_16 = slots[i]

			if not var_52_16.disabled then
				break
			end

			if arg_52_6 or not flag or not fn_20(var_52_16, arg_52_2, var_52_2) then
				break
			end

			local ai_unit = var_52_16.ai_unit
			local released = var_52_16.released
			local unbox = var_52_16.original_absolute_position:unbox()
			local var_52_20 = distance_squared(unbox, var_52_0)
			local huge_2 = math.huge

			if not ai_unit then
				if ai_unit == arg_52_2 then
					huge_2 = var_52_20 + num_28
				elseif not released then
					local var_52_22 = POSITION_LOOKUP[ai_unit]

					if var_52_20 < distance_squared(unbox, var_52_22) + num_29 then
						huge_2 = var_52_20
					end
				end
			else
				huge_2 = var_52_20
			end

			if huge_2 < huge then
				var_52_6 = var_52_16
				huge = huge_2
			end
		until true
	end

	if not var_52_6 then
		repeat
			var_52_1.temporary_wait_position = nil

			local slot_2 = var_52_1.slot

			if not (not slot_2 and slot_2 ~= var_52_6) then
				break
			end

			local waiting_on_slot = var_52_1.waiting_on_slot

			if slot_2 or not waiting_on_slot then
				fn_6(arg_52_2, arg_52_3)
			end

			local ai_unit_2 = var_52_6.ai_unit

			if not ai_unit_2 then
				arg_52_3[ai_unit_2].slot = nil

				Managers.state.debug_text:clear_unit_text(ai_unit_2, "slot_index")
			end

			var_52_6.ai_unit = arg_52_2
			var_52_1.slot = var_52_6

			fn_24(arg_52_0, arg_52_3)
		until true
	end

	if slot ~= var_52_1.slot then
		var_52_4.slots_count = fn_5(arg_52_0, arg_52_3, use_slot_type)
	elseif (var_52_6 or not slot) and not arg_52_6 and not fn_20(slot, arg_52_2, var_52_2) then
		fn_6(arg_52_2, arg_52_3)

		var_52_4.slots_count = fn_5(arg_52_0, arg_52_3, use_slot_type)

		local extension_input = ScriptUnit.extension_input(arg_52_2, "dialogue_system")
		local alloc_table = FrameTable.alloc_table()

		extension_input:trigger_networked_dialogue_event("flanking", alloc_table)
	end
end

SLOT_QUEUE_PENALTY_MULTIPLIER = 3

local function fn_35(arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4, arg_53_5)
	-- function 53
	local var_53_0 = arg_53_2[arg_53_1]
	local waiting_on_slot = var_53_0.waiting_on_slot
	local var_53_2 = arg_53_2[arg_53_0]
	local use_slot_type = var_53_0.use_slot_type

	use_slot_type = use_slot_type or str

	local var_53_4 = var_53_2.all_slots[use_slot_type]
	local disabled_slots_count = var_53_4.disabled_slots_count
	local slots_count = var_53_4.slots_count
	local num = var_53_4.total_slots_count - disabled_slots_count
	local slot_template = var_53_0.slot_template
	local avoid_slots_behind_overwhelmed_target = slot_template.avoid_slots_behind_overwhelmed_target
	local flag = not slot_template and not avoid_slots_behind_overwhelmed_target and not (disabled_slots_count >= 2) or num <= slots_count

	if not waiting_on_slot then
		if arg_53_4 or not flag or not fn_20(waiting_on_slot, arg_53_1, var_53_2) then
			fn_6(arg_53_1, arg_53_2)
		else
			return
		end
	end

	local var_53_11 = POSITION_LOOKUP[arg_53_1]
	local huge = math.huge
	local var_53_13
	local all_slots = var_53_2.all_slots

	for i = 1, count do
		local var_53_15 = all_slots[tbl_4[i]]
		local slots = var_53_15.slots
		local total_slots_count = var_53_15.total_slots_count

		for j = 1, total_slots_count do
			repeat
				local var_53_18 = slots[j]
				local count_2 = #var_53_18.queue
				local num_2 = 0

				if arg_53_4 or not flag or not fn_20(var_53_18, arg_53_1, var_53_2) then
					num_2 = 100
				end

				local var_53_21, var_53_22 = fn_8(arg_53_2, var_53_18, arg_53_3, nil, arg_53_5)

				if not var_53_21 then
					break
				end

				local num_3 = distance_squared(var_53_21, var_53_11) + count_2 * count_2 * SLOT_QUEUE_PENALTY_MULTIPLIER + var_53_22 + num_2

				if num_3 < huge then
					huge = num_3
					var_53_13 = var_53_18
				end
			until true
		end
	end

	if not var_53_13 then
		local queue = var_53_13.queue

		queue[#queue + 1] = arg_53_1
		var_53_0.waiting_on_slot = var_53_13
	end
end

local function fn_36(self, arg_54_1)
	-- function 54
	local count_2 = #self

	for i = 1, count_2 do
		local all_slots = arg_54_1[self[i]].all_slots

		for j = 1, count do
			local var_54_2 = all_slots[tbl_4[j]]
			local slots = var_54_2.slots
			local count_3 = #slots
			local num = 0

			for k = 1, count_3 do
				if not slots[k].disabled then
					num = num + 1
				end
			end

			var_54_2.disabled_slots_count = num
		end
	end
end

local function fn_37(arg_55_0, arg_55_1, arg_55_2, arg_55_3)
	-- function 55
	local count_2 = #arg_55_2
	local var_55_1 = arg_55_3
	local player = Managers.player
	local system = Managers.state.entity:system("audio_system")
	local occupied_slots_percentage = NetworkLookup.global_parameter_names.occupied_slots_percentage

	for i = 1, count_2 do
		local var_55_5 = arg_55_2[i]
		local all_slots = var_55_1[var_55_5].all_slots
		local owner = player:owner(var_55_5)
		local flag = not arg_55_0 and not owner and owner:is_player_controlled()
		local num = 0

		for j = 1, count do
			local var_55_10 = tbl_4[j]
			local var_55_11 = all_slots[var_55_10]
			local dialogue_surrounded_count = SlotTypeSettings[var_55_10].dialogue_surrounded_count
			local slots_count = var_55_11.slots_count

			if not flag then
				local disabled_slots_count = var_55_11.disabled_slots_count
				local num_2 = var_55_11.total_slots_count - disabled_slots_count
				local num_3

				if num_2 > 0 then
					num_3 = slots_count / num_2

					if not num_3 then
						-- Nothing
					end
				end

				num_3 = 0

				::label_55_0::

				local clamp = math.clamp(num_3, 0, 1)

				if num < clamp then
					num = clamp
				end
			end

			if not (dialogue_surrounded_count <= slots_count) or not ScriptUnit.has_extension(var_55_5, "dialogue_system") then
				local extension_input = ScriptUnit.extension_input(var_55_5, "dialogue_system")
				local alloc_table = FrameTable.alloc_table()

				alloc_table.current_amount = slots_count
				alloc_table.has_shield = Managers.state.entity:system("dialogue_system"):player_shield_check(var_55_5)

				extension_input:trigger_networked_dialogue_event("surrounded", alloc_table)
			end
		end

		if not flag then
			if not owner.local_player then
				system:set_global_parameter_with_lerp("occupied_slots_percentage", num * 100)
			else
				local network_id = owner:network_id()

				arg_55_1:send_rpc("rpc_client_audio_set_global_parameter_with_lerp", network_id, occupied_slots_percentage, num)
			end
		end
	end
end

AISlotSystem.update = function (self, arg_56_1, arg_56_2, arg_56_3)
	-- function 56
	if not script_data.navigation_thread_disabled then
		local nav_world = self.nav_world

		GwNavWorld.join_async_update(nav_world)

		NAVIGATION_RUNNING_IN_THREAD = false
	end
end

local var_0_89
local var_0_90
local num_30 = 0.5
local num_31 = 1
local num_32 = 1
local num_33 = 1
local num_34 = 5
local num_35 = 0.25

AISlotSystem.physics_async_update = function (self, arg_57_1, arg_57_2)
	-- function 57
	self.t = arg_57_2

	local target_units = self.target_units
	local count = #target_units

	if count == 0 then
		return
	end

	local nav_world = self.nav_world
	local unit_extension_data = self.unit_extension_data

	for i = 1, count do
		local var_57_4 = target_units[i]
		local var_57_5 = unit_extension_data[var_57_4]

		if not self:update_target_slots(arg_57_2, var_57_4, target_units, unit_extension_data, var_57_5, nav_world, self._traverse_logic) then
			break
		end
	end

	if arg_57_2 > self.next_total_slot_count_update then
		self:update_total_slots_count(arg_57_2)

		self.next_total_slot_count_update = arg_57_2 + num_31
	end

	if arg_57_2 > self.next_disabled_slot_count_update then
		fn_36(target_units, unit_extension_data)

		self.next_disabled_slot_count_update = arg_57_2 + num_32
	end

	if arg_57_2 > self.next_slot_sound_update then
		fn_37(self.is_server, self.network_transmit, target_units, unit_extension_data)

		self.next_slot_sound_update = arg_57_2 + num_33
	end

	local update_slots_ai_units_prioritized = self.update_slots_ai_units_prioritized

	for k, v in pairs(update_slots_ai_units_prioritized) do
		self:update_ai_unit_slot(k, target_units, unit_extension_data, nav_world, arg_57_2)

		update_slots_ai_units_prioritized[k] = nil
	end

	local update_slots_ai_units = self.update_slots_ai_units
	local count_2 = #update_slots_ai_units

	if count_2 < self.current_ai_index then
		self.current_ai_index = 1
	end

	local current_ai_index = self.current_ai_index
	local min = math.min(current_ai_index + num_2 - 1, count_2)

	self.current_ai_index = min + 1

	for l = current_ai_index, min do
		local var_57_11 = update_slots_ai_units[l]

		self:update_ai_unit_slot(var_57_11, target_units, unit_extension_data, nav_world, arg_57_2)
	end
end

AISlotSystem.update_ai_unit_slot = function (self, arg_58_1, arg_58_2, arg_58_3, arg_58_4, arg_58_5)
	-- function 58
	if not not ALIVE[arg_58_1] then
		fn_6(arg_58_1, arg_58_3)

		return
	end

	local var_58_0 = arg_58_3[arg_58_1]
	local blackboard = ScriptUnit.extension(arg_58_1, "ai_system"):blackboard()
	local target_unit = blackboard.target_unit

	fn_10(target_unit, arg_58_1, blackboard, arg_58_3, arg_58_5)

	if not target_unit then
		return
	end

	local var_58_3 = arg_58_3[target_unit]

	if not var_58_3 then
		return
	end

	if not var_58_0.do_search then
		return
	end

	local using_override_target = blackboard.using_override_target

	fn_34(target_unit, arg_58_2, arg_58_1, arg_58_3, arg_58_4, arg_58_5, using_override_target)

	local slot = var_58_0.slot

	if not slot then
		fn_25(slot, arg_58_3)

		if not fn_20(slot, arg_58_1, var_58_3) then
			fn_22(var_58_3, slot, arg_58_4, self._traverse_logic)
		else
			fn_21(slot)
		end
	else
		fn_35(target_unit, arg_58_1, arg_58_3, arg_58_4, using_override_target, arg_58_5)
	end

	if not blackboard.disable_improve_slot_position then
		self:improve_slot_position(arg_58_1, arg_58_5)
	end

	local delayed_prioritized_ai_unit_update_time = var_58_0.delayed_prioritized_ai_unit_update_time

	if not (not delayed_prioritized_ai_unit_update_time and not (delayed_prioritized_ai_unit_update_time < arg_58_5)) then
		fn_6(arg_58_1, arg_58_3)
		self:register_prioritized_ai_unit_update(arg_58_1)

		var_58_0.delayed_prioritized_ai_unit_update_time = nil
	end
end

AISlotSystem.update_target_slots = function (arg_59_0, arg_59_1, arg_59_2, arg_59_3, arg_59_4, arg_59_5, arg_59_6, arg_59_7)
	-- function 59
	local num = 0
	local var_59_1
	local var_59_2
	local var_59_3
	local var_59_4
	local was_on_ladder = arg_59_5.was_on_ladder
	local has_extension = ScriptUnit.has_extension(arg_59_2, "status_system")

	if not has_extension then
		var_59_1, var_59_2 = has_extension:get_is_on_ladder()

		if not var_59_1 then
			local var_59_7
			local var_59_8

			var_59_3, var_59_4, var_59_8 = Managers.state.bot_nav_transition:get_ladder_coordinates(var_59_2)
			var_59_1 = not var_59_8
		end

		arg_59_5.was_on_ladder = var_59_1
	end

	local local_position = Unit.local_position(arg_59_2, 0)
	local flag = not var_59_1 and local_position and get_target_pos_on_navmesh(local_position, arg_59_6)
	local unbox = arg_59_5.position:unbox()
	local outside_navmesh_at_t = arg_59_5.outside_navmesh_at_t
	local flag_2 = false

	if not flag then
		num = distance_squared(flag, unbox)
		arg_59_5.outside_navmesh_at_t = nil
	elseif not (outside_navmesh_at_t == nil or not (arg_59_1 < outside_navmesh_at_t + num_17)) then
		if outside_navmesh_at_t == nil then
			arg_59_5.outside_navmesh_at_t = arg_59_1
		end

		flag = unbox
	else
		flag_2 = true
		flag = local_position
		num = distance_squared(flag, unbox)
	end

	if not ((num > num_10 or var_59_1 ~= was_on_ladder or not var_59_1) and not (arg_59_1 > arg_59_5.next_slot_status_update_at)) then
		local flag_3 = true

		arg_59_5.position:store(flag)
		fn_33(arg_59_2, arg_59_3, arg_59_4, flag_3, arg_59_6, arg_59_7, var_59_1, var_59_2, var_59_3, var_59_4, flag_2)

		arg_59_5.moved_at = arg_59_1
		arg_59_5.next_slot_status_update_at = arg_59_1 + num_30

		return true
	end

	local moved_at = arg_59_5.moved_at
	local has_extension_2 = ScriptUnit.has_extension(arg_59_2, "locomotion_system")

	has_extension_2 = not has_extension_2 and ScriptUnit.extension(arg_59_2, "locomotion_system")

	local var_59_17

	if not has_extension_2 then
		var_59_17 = length_squared(has_extension_2:current_velocity())

		if not var_59_17 then
			-- Nothing
		end
	end

	var_59_17 = 0

	::label_59_0::

	if not (var_59_1 or not moved_at and not (arg_59_1 - moved_at > num_11) or var_59_17 <= num_35 or not (arg_59_1 - moved_at > num_12)) then
		local flag_4 = false

		fn_33(arg_59_2, arg_59_3, arg_59_4, flag_4, arg_59_6, arg_59_7, var_59_1, var_59_2, var_59_3, var_59_4, flag_2)

		arg_59_5.moved_at = nil
		arg_59_5.next_slot_status_update_at = arg_59_1 + num_30

		return true
	end

	if arg_59_1 > arg_59_5.next_slot_status_update_at then
		fn_31(arg_59_2, arg_59_3, arg_59_4, arg_59_6, arg_59_7, flag_2, arg_59_1)

		arg_59_5.next_slot_status_update_at = arg_59_1 + num_30

		return true
	end

	return false
end

AISlotSystem.update_total_slots_count = function (self, arg_60_1)
	-- function 60
	local target_units = self.target_units
	local count_2 = #target_units
	local unit_extension_data = self.unit_extension_data
	local num = 0
	local num_2 = 0

	for i = 1, count_2 do
		local var_60_5 = unit_extension_data[target_units[i]]
		local all_slots = var_60_5.all_slots
		local num_3 = 0

		for j = 1, count do
			local var_60_8 = all_slots[tbl_4[j]]

			num = num + var_60_8.slots_count

			local slots = var_60_8.slots
			local total_slots_count = var_60_8.total_slots_count

			for k = 1, total_slots_count do
				local var_60_11 = slots[k]

				if not (not not var_60_11.released or var_60_11.ai_unit) then
					num_3 = num_3 + 1
				end
			end
		end

		if num_3 >= var_60_5.delayed_num_occupied_slots then
			var_60_5.delayed_num_occupied_slots = num_3
			var_60_5.delayed_slot_decay_t = arg_60_1 + num_34
		elseif arg_60_1 >= var_60_5.delayed_slot_decay_t then
			var_60_5.delayed_num_occupied_slots = num_3
		end

		var_60_5.num_occupied_slots = num_3
		num_2 = num_2 + num_3
	end

	self.num_total_enemies = num
	self.num_occupied_slots = num_2
end

AISlotSystem.register_prioritized_ai_unit_update = function (arg_61_0, arg_61_1)
	-- function 61
	arg_61_0.update_slots_ai_units_prioritized[arg_61_1] = true
end

AISlotSystem.prioritize_queued_units_on_slot = function (self, arg_62_1)
	-- function 62
	if not arg_62_1 and not arg_62_1.queue then
		local queue = arg_62_1.queue
		local count = #queue

		for i = 1, count do
			local var_62_2 = queue[i]

			self:register_prioritized_ai_unit_update(var_62_2)
		end
	end
end

local num_36 = 9
local tbl_5 = {}

AISlotSystem.on_add_extension = function (self, arg_63_1, arg_63_2, arg_63_3, arg_63_4)
	-- function 63
	local tbl = {}

	ScriptUnit.set_extension(arg_63_2, "ai_slot_system", tbl, tbl_5)

	self.unit_extension_data[arg_63_2] = tbl

	if not (arg_63_3 == "AIPlayerSlotExtension" or arg_63_3 ~= "AIAggroableSlotExtension") then
		local var_63_1

		if arg_63_3 == "AIPlayerSlotExtension" then
			var_63_1 = arg_63_4.profile_index
		elseif arg_63_3 == "AIAggroableSlotExtension" then
			var_63_1 = num_36

			local game_object_or_level_id, var_63_3 = Managers.state.network:game_object_or_level_id(arg_63_2)

			if not var_63_3 then
				POSITION_LOOKUP[arg_63_2] = Unit.world_position(arg_63_2, 0)
			end
		end

		tbl.all_slots = {}

		for k, v in pairs(SlotTypeSettings) do
			local flag

			flag = k ~= "normal" or not "ai_slots_count" or "ai_slots_count_" .. k

			local get_data = Unit.get_data(arg_63_2, flag)

			get_data = get_data or v.count

			local tbl_2 = {
				total_slots_count = get_data,
				slot_radians = math.degrees_to_radians(360 / get_data)
			}

			tbl_2.slots_count = 0
			tbl_2.use_wait_slots = v.use_wait_slots
			tbl_2.priority = v.priority
			tbl_2.disabled_slots_count = 0
			tbl_2.slots = {}
			tbl.all_slots[k] = tbl_2
		end

		local num = #self.target_units + 1

		tbl.dogpile = 0
		tbl.position = Vector3Box(POSITION_LOOKUP[arg_63_2])
		tbl.moved_at = 0
		tbl.next_slot_status_update_at = 0
		tbl.valid_target = true
		tbl.index = num
		tbl.debug_color_name = var_0_4[var_63_1][1]
		tbl.num_occupied_slots = 0
		tbl.has_slots_attached = true
		tbl.delayed_num_occupied_slots = 0
		tbl.delayed_slot_decay_t = 0
		tbl.full_slots_at_t = {}

		fn(arg_63_2, tbl, var_63_1)

		self.target_units[num] = arg_63_2

		local target_units = self.target_units
		local nav_world = self.nav_world
		local _traverse_logic = self._traverse_logic
		local unit_extension_data = self.unit_extension_data

		self:update_target_slots(0, arg_63_2, target_units, unit_extension_data, tbl, nav_world, _traverse_logic)
	end

	if arg_63_3 == "AIEnemySlotExtension" then
		tbl.target = nil
		tbl.target_position = Vector3Box()
		tbl.improve_wait_slot_position_t = 0
		self.update_slots_ai_units[#self.update_slots_ai_units + 1] = arg_63_2
	end

	return tbl
end

AISlotSystem.extensions_ready = function (self, arg_64_1, arg_64_2, arg_64_3)
	-- function 64
	if arg_64_3 == "AIEnemySlotExtension" then
		local var_64_0 = self.unit_extension_data[arg_64_2]
		local breed = ScriptUnit.extension(arg_64_2, "ai_system"):breed()

		var_64_0.breed = breed

		local slot_template = breed.slot_template
		local var_64_3 = Managers.state.difficulty:get_difficulty_value_from_table(SlotTemplates)[slot_template]

		fassert(slot_template, "Breed " .. breed.name .. " that uses slot system does not have a slot_template set in its breed.")
		fassert(var_64_3, "Breed " .. breed.name .. " that uses slot system does not have a slot_template setup in SlotTemplates.")

		var_64_0.slot_template = var_64_3
		var_64_0.slot_type_settings = SlotTypeSettings[var_64_3.slot_type]
		var_64_0.use_slot_type = var_64_3.slot_type
	end
end

AISlotSystem.on_remove_extension = function (self, arg_65_1, arg_65_2)
	-- function 65
	self.frozen_unit_extension_data[arg_65_1] = nil

	self:_cleanup_extension(arg_65_1, arg_65_2)
	ScriptUnit.remove_extension(arg_65_1, self.NAME)
end

AISlotSystem.on_freeze_extension = function (self, arg_66_1, arg_66_2)
	-- function 66
	local var_66_0 = self.unit_extension_data[arg_66_1]

	fassert(var_66_0, "Unit was already frozen.")

	if var_66_0 == nil then
		return
	end

	local slot_template = var_66_0.slot_template

	if not slot_template and not slot_template.prioritize_queued_units_on_death then
		local slot = var_66_0.slot

		if not slot_template.prioritize_queued_units_on_death_time then
			var_66_0.delayed_prioritized_ai_unit_update_time = Managers.time:time("game") + slot_template.prioritize_queued_units_on_death_time
		else
			self:prioritize_queued_units_on_slot(slot)
		end
	end

	self.frozen_unit_extension_data[arg_66_1] = var_66_0

	self:_cleanup_extension(arg_66_1, arg_66_2)
end

AISlotSystem._cleanup_extension = function (self, arg_67_1, arg_67_2)
	-- function 67
	local var_67_0 = self.unit_extension_data[arg_67_1]

	if var_67_0 == nil then
		return
	end

	local update_slots_ai_units = self.update_slots_ai_units
	local count = #update_slots_ai_units

	if arg_67_2 == "AIEnemySlotExtension" then
		if var_67_0.slot or not var_67_0.waiting_on_slot then
			fn_6(arg_67_1, self.unit_extension_data)
		end

		self.update_slots_ai_units_prioritized[arg_67_1] = nil

		for i = 1, count do
			if update_slots_ai_units[i] == arg_67_1 then
				update_slots_ai_units[i] = update_slots_ai_units[count]
				update_slots_ai_units[count] = nil

				break
			end
		end
	end

	if not (arg_67_2 == "AIPlayerSlotExtension" or arg_67_2 ~= "AIAggroableSlotExtension") then
		if not var_67_0.slots then
			local slots = var_67_0.slots

			for j = #slots, 0, -1 do
				local var_67_4 = slots[j]

				fn_2(var_67_4, self.unit_extension_data)
			end
		end

		local count_2 = #self.target_units

		for k = 1, count_2 do
			if self.target_units[k] == arg_67_1 then
				self.target_units[k] = self.target_units[count_2]
				self.target_units[count_2] = nil

				break
			end
		end

		for l = 1, count do
			local var_67_6 = self.unit_extension_data[update_slots_ai_units[l]]

			if var_67_6.target == arg_67_1 then
				var_67_6.target = nil
			end
		end
	end

	self.unit_extension_data[arg_67_1] = nil
end

AISlotSystem.freeze = function (self, arg_68_1, arg_68_2, arg_68_3)
	-- function 68
	local frozen_unit_extension_data = self.frozen_unit_extension_data

	if not frozen_unit_extension_data[arg_68_1] then
		return
	end

	local var_68_1 = self.unit_extension_data[arg_68_1]

	fassert(var_68_1, "Unit to freeze didn't have unfrozen extension")
	self:_cleanup_extension(arg_68_1, arg_68_2)

	self.unit_extension_data[arg_68_1] = nil
	frozen_unit_extension_data[arg_68_1] = var_68_1
end

AISlotSystem.unfreeze = function (self, arg_69_1)
	-- function 69
	local var_69_0 = self.frozen_unit_extension_data[arg_69_1]

	self.frozen_unit_extension_data[arg_69_1] = nil
	self.unit_extension_data[arg_69_1] = var_69_0

	fassert(var_69_0, "Unit to freeze didn't have unfrozen extension")

	var_69_0.target = nil
	var_69_0.improve_wait_slot_position_t = 0
	self.update_slots_ai_units[#self.update_slots_ai_units + 1] = arg_69_1
end

local function fn_38(arg_70_0, arg_70_1, arg_70_2, arg_70_3)
	-- function 70
	local drawer = Managers.state.debug:drawer({
		mode = "immediate",
		name = "AISlotSystem_immediate"
	})
	local num_2 = Vector3.up() * 0.1
	local sides = Managers.state.side:sides()

	for i = 1, #sides do
		local AI_TARGET_UNITS = sides[i].AI_TARGET_UNITS

		for k, v in pairs(AI_TARGET_UNITS) do
			repeat
				if not HEALTH_ALIVE[v] then
					break
				end

				local var_70_4 = arg_70_1[v]

				if not (not var_70_4 and var_70_4.valid_target) then
					break
				end

				local all_slots = var_70_4.all_slots

				for k_2, v_2 in pairs(all_slots) do
					local slots = v_2.slots
					local count = #slots
					local unbox = var_70_4.position:unbox()
					local get = Colors.get(var_70_4.debug_color_name)

					drawer:circle(unbox + num_2, 0.5, Vector3.up(), get)
					drawer:circle(unbox + num_2, 0.45, Vector3.up(), get)

					if not var_70_4.next_slot_status_update_at then
						local num_4 = (arg_70_3 - var_70_4.next_slot_status_update_at) / num_30

						drawer:circle(unbox + num_2, 0.45 * num_4, Vector3.up(), get)
					end

					for i5 = 1, count do
						repeat
							local var_70_11 = slots[i5]
							local flag = var_70_11 == fn_26(k_2, v, arg_70_1)
							local ai_unit = var_70_11.ai_unit
							local flag_2

							flag_2 = not ai_unit and 255 and 150

							local get_color_with_alpha

							if not var_70_11.disabled then
								get_color_with_alpha = Colors.get_color_with_alpha("gray", flag_2)

								if not get_color_with_alpha then
									-- Nothing
								end
							end

							get_color_with_alpha = Colors.get_color_with_alpha(var_70_11.debug_color_name, flag_2)

							::label_70_0::

							if not var_70_11.absolute_position then
								local unbox_2 = var_70_11.absolute_position:unbox()

								if not ALIVE[ai_unit] then
									local var_70_17 = POSITION_LOOKUP[ai_unit]

									drawer:circle(var_70_17 + num_2, 0.35, Vector3.up(), get_color_with_alpha)
									drawer:circle(var_70_17 + num_2, 0.3, Vector3.up(), get_color_with_alpha)

									local node = Unit.node(ai_unit, "c_head")
									local str = "player_1"
									local get_table

									if not var_70_11.disabled then
										get_table = Colors.get_table("gray")

										if not get_table then
											-- Nothing
										end
									end

									get_table = Colors.get_table(var_70_11.debug_color_name)

									::label_70_1::

									local var_70_21 = Vector3(get_table[2], get_table[3], get_table[4])
									local var_70_22 = Vector3(0, 0, -1)
									local num_5 = 0.4
									local index = var_70_11.index
									local str_2 = "slot_index"

									Managers.state.debug_text:clear_unit_text(ai_unit, str_2)
									Managers.state.debug_text:output_unit_text(index, num_5, ai_unit, node, var_70_22, nil, str_2, var_70_21, str)

									if not (var_70_11.ghost_position.x == 0 or var_70_11.disable_at) then
										local unbox_3 = var_70_11.ghost_position:unbox()

										drawer:line(unbox_3 + num_2, unbox_2 + num_2, get_color_with_alpha)
										drawer:sphere(unbox_3 + num_2, 0.3, get_color_with_alpha)
										drawer:line(unbox_3 + num_2, var_70_17 + num_2, get_color_with_alpha)
									else
										drawer:line(unbox_2 + num_2, var_70_17 + num_2, get_color_with_alpha)
									end
								end

								local num_6 = 0.4
								local get_table_2

								if not var_70_11.disabled then
									get_table_2 = Colors.get_table("gray")

									if not get_table_2 then
										-- Nothing
									end
								end

								get_table_2 = Colors.get_table(var_70_11.debug_color_name)

								::label_70_2::

								local var_70_29 = Vector3(get_table_2[2], get_table_2[3], get_table_2[4])
								local str_3 = "slot_index_" .. k_2 .. "_" .. var_70_11.index .. "_" .. k

								Managers.state.debug_text:clear_world_text(str_3)
								Managers.state.debug_text:output_world_text(var_70_11.index, num_6, unbox_2 + num_2, nil, str_3, var_70_29)

								local radius = SlotTypeSettings[k_2].radius

								drawer:circle(unbox_2 + num_2, radius, Vector3.up(), get_color_with_alpha)
								drawer:circle(unbox_2 + num_2, radius - 0.05, Vector3.up(), get_color_with_alpha)

								local var_70_32 = fn_8(arg_70_1, var_70_11, arg_70_2, nil, arg_70_3)

								if not var_70_32 then
									drawer:circle(var_70_32 + num_2, num_3, Vector3.up(), get_color_with_alpha)
									drawer:circle(var_70_32 + num_2, num_3 - 0.05, Vector3.up(), get_color_with_alpha)
									drawer:line(unbox_2 + num_2, var_70_32 + num_2, get_color_with_alpha)

									local queue = var_70_11.queue
									local count_2 = #queue

									for i6 = 1, count_2 do
										local var_70_35 = queue[i6]
										local var_70_36 = POSITION_LOOKUP[var_70_35]

										drawer:circle(var_70_36 + num_2, 0.35, Vector3.up(), get_color_with_alpha)
										drawer:circle(var_70_36 + num_2, 0.3, Vector3.up(), get_color_with_alpha)
										drawer:line(var_70_32 + num_2, var_70_36, get_color_with_alpha)
									end
								end

								local num_7 = 0.2
								local get_table_3

								if not var_70_11.disabled then
									get_table_3 = Colors.get_table("gray")

									if not get_table_3 then
										-- Nothing
									end
								end

								get_table_3 = Colors.get_table(var_70_11.debug_color_name)

								::label_70_3::

								local var_70_39 = Vector3(get_table_3[2], get_table_3[3], get_table_3[4])
								local str_4 = "wait_slot_index_" .. k_2 .. "_" .. var_70_11.index .. "_" .. i5

								Managers.state.debug_text:clear_world_text(str_4)

								if not var_70_32 then
									Managers.state.debug_text:output_world_text("wait " .. var_70_11.index, num_7, var_70_32 + num_2, nil, str_4, var_70_39)
								end

								if not var_70_11.released then
									local get_2 = Colors.get("green")

									drawer:sphere(unbox_2 + num_2, 0.2, get_2)
								end

								if not flag then
									local get_3 = Colors.get("red")

									drawer:sphere(unbox_2 + num_2, 0.3, get_3)
								end

								local position_check_index = var_70_11.position_check_index
								local var_70_44 = unbox_2

								if position_check_index == tbl_2.CHECK_MIDDLE then
									-- Nothing
								else
									local var_70_45 = tbl_3[position_check_index]

									var_70_44 = fn_11(var_70_44, unbox, var_70_45, num)
								end

								local num_8 = unbox + normalize(var_70_44 - unbox) * num_16

								drawer:line(num_8 + num_2, var_70_44 + num_2, get_color_with_alpha)
								drawer:circle(var_70_44 + num_2, 0.1, Vector3.up(), Color(255, 0, 255))

								break
							end

							local str_5 = "wait_slot_index_" .. k_2 .. "_" .. var_70_11.index .. "_" .. i5

							Managers.state.debug_text:clear_world_text(str_5)
						until true
					end
				end
			until true
		end
	end
end

local function fn_39(self, arg_71_1)
	-- function 71
	local count = #self
	local var_71_1 = arg_71_1

	Debug.text("OCCUPIED SLOTS")

	for i = 1, count do
		local var_71_2 = self[i]
		local var_71_3 = var_71_1[var_71_2]
		local owner = Managers.player:owner(var_71_2)
		local var_71_5

		if not owner then
			var_71_5 = owner:profile_display_name()
		else
			var_71_5 = tostring(var_71_2)
		end

		local str = var_71_5 .. "-> "
		local all_slots = var_71_3.all_slots
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

		local num_occupied_slots = var_71_3.num_occupied_slots
		local delayed_num_occupied_slots = var_71_3.delayed_num_occupied_slots
		local str_2 = str .. string.format("total: [%d(%d)|%d(%d)]. ", num_occupied_slots, delayed_num_occupied_slots, num_2, num)

		Debug.text(str_2)
	end
end

AISlotSystem.set_allowed_layer = function (self, arg_72_1, arg_72_2)
	-- function 72
	local var_72_0 = LAYER_ID_MAPPING[arg_72_1]

	if not arg_72_2 then
		GwNavTagLayerCostTable.allow_layer(self._navtag_layer_cost_table, var_72_0)
	else
		GwNavTagLayerCostTable.forbid_layer(self._navtag_layer_cost_table, var_72_0)
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
