-- chunkname: @scripts/entity_system/systems/ai/ai_player_slot_extension.lua

AIPlayerSlotExtension = class(AIPlayerSlotExtension)

local scripts_entity_system_systems_ai_ai_slot_utils = require("scripts/entity_system/systems/ai/ai_slot_utils")
local distance = Vector3.distance
local distance_squared = Vector3.distance_squared
local length = Vector3.length
local length_squared = Vector3.length_squared
local normalize = Vector3.normalize
local dot = Vector3.dot
local flat = Vector3.flat
local triangle_from_position = GwNavQueries.triangle_from_position
local raycango = GwNavQueries.raycango
local num = 0.5
local tbl = {
	CHECK_LEFT = 0,
	CHECK_RIGHT = 2,
	CHECK_MIDDLE = 1
}
local size = table.size(tbl)
local tbl_2 = {
	[tbl.CHECK_LEFT] = math.degrees_to_radians(-90),
	[tbl.CHECK_RIGHT] = math.degrees_to_radians(90)
}
local num_2 = 0.5
local num_3 = num_2 + 0.6
local num_4 = 7.5
local num_5 = 4
local num_6 = 0.5
local num_7 = 0.25
local num_8 = 1
local num_9 = 1.5
local num_10 = 1.5
local num_11 = 2
local num_12 = 0.5
local num_13 = 0.25
local num_14 = 9
local num_15 = 5
local num_16 = 1.5
local num_17 = 2
local num_18 = 3
local num_19 = 3
local tbl_3 = {
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
local tbl_4 = {}
local SlotTypeSettings = SlotTypeSettings

for k, v in pairs(SlotTypeSettings) do
	tbl_4[#tbl_4 + 1] = k
end

local count = #tbl_4

AIPlayerSlotExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.unit = arg_1_2
	self.all_slots = {}

	for k, v in pairs(SlotTypeSettings) do
		local flag

		flag = k ~= "normal" or not "ai_slots_count" or "ai_slots_count_" .. k

		local get_data = Unit.get_data(arg_1_2, flag)

		get_data = get_data or v.count

		local tbl = {
			total_slots_count = get_data,
			slot_radians = math.degrees_to_radians(360 / get_data)
		}

		tbl.slots_count = 0
		tbl.use_wait_slots = v.use_wait_slots
		tbl.priority = v.priority
		tbl.disabled_slots_count = 0
		tbl.slots = {}
		self.all_slots[k] = tbl
	end

	local profile_index = arg_1_3.profile_index

	profile_index = profile_index or num_14
	self.dogpile = 0
	self.position = Vector3Box(POSITION_LOOKUP[arg_1_2])
	self.moved_at = 0
	self.next_slot_status_update_at = 0
	self.valid_target = true
	self.debug_color_name = tbl_3[profile_index][1]
	self.num_occupied_slots = 0
	self.has_slots_attached = true
	self.delayed_num_occupied_slots = 0
	self.delayed_slot_decay_t = 0
	self.full_slots_at_t = {}

	self:_create_target_slots(arg_1_2, profile_index)

	self._is_server = arg_1_1.is_server
	self._network_transmit = arg_1_1.network_transmit
	self._audio_system = Managers.state.entity:system("audio_system")
	self._audio_parameter_id = NetworkLookup.global_parameter_names.occupied_slots_percentage

	local unit_owner = Managers.player:unit_owner(arg_1_2)

	self:_update_assigned_player(unit_owner, arg_1_2)

	self.belongs_to_player = true
end

AIPlayerSlotExtension._create_target_slots = function (self, arg_2_1, arg_2_2)
	-- function 2
	local all_slots = self.all_slots

	for k, v in pairs(all_slots) do
		local total_slots_count = v.total_slots_count
		local slots = v.slots

		for k_2 = 1, total_slots_count do
			local tbl_2 = {
				target_unit = arg_2_1,
				owner_extension = self,
				queue = {},
				original_absolute_position = Vector3Box(0, 0, 0),
				absolute_position = Vector3Box(0, 0, 0),
				ghost_position = Vector3Box(0, 0, 0),
				queue_direction = Vector3Box(0, 0, 0),
				position_right = Vector3Box(0, 0, 0),
				position_left = Vector3Box(0, 0, 0),
				index = k_2
			}

			tbl_2.anchor_weight = 0
			tbl_2.type = k
			tbl_2.radians = math.degrees_to_radians(360 / total_slots_count)
			tbl_2.priority = v.priority
			tbl_2.position_check_index = tbl.CHECK_MIDDLE
			tbl_2.debug_color_name = SlotTypeSettings[k].debug_color
			slots[k_2] = tbl_2
		end
	end
end

AIPlayerSlotExtension._update_assigned_player = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	if self.unit ~= arg_3_2 then
		return
	end

	if not arg_3_1 then
		local _is_server = self._is_server

		_is_server = not _is_server and arg_3_1:is_player_controlled()
		self._is_server_player = _is_server
		self._is_local_player = arg_3_1.local_player
		self._peer_id = arg_3_1:network_id()

		if not self._waiting_for_player then
			Managers.state.event:unregister("new_player_unit", self)

			self._waiting_for_player = nil
		end
	elseif not self._waiting_for_player then
		Managers.state.event:register(self, "new_player_unit", "_update_assigned_player")

		self._waiting_for_player = true
	end
end

AIPlayerSlotExtension.extensions_ready = function (self, arg_4_1, arg_4_2)
	-- function 4
	self._status_ext = ScriptUnit.has_extension(arg_4_2, "status_system")
	self._locomotion_ext = ScriptUnit.has_extension(arg_4_2, "locomotion_system")
end

local function fn(self)
	-- function 5
	if not self.ai_unit then
		local ai_unit_slot_extension = self.ai_unit_slot_extension

		if not ai_unit_slot_extension then
			ai_unit_slot_extension.slot = nil
		end
	end

	local queue = self.queue
	local count = #queue

	for i = 1, count do
		local var_5_3 = queue[i]

		if not var_5_3 then
			var_5_3:on_slot_lost()
		end
	end

	local owner_extension = self.owner_extension

	if not owner_extension then
		local all_slots = owner_extension.all_slots

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

AIPlayerSlotExtension.cleanup_extension = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	if not self.slots then
		local slots = self.slots

		for i = #slots, 1, -1 do
			local var_6_1 = slots[i]

			fn(var_6_1)
		end
	end

	for j = 1, arg_6_3 do
		local var_6_2 = arg_6_4[arg_6_2[j]]

		if var_6_2.target == arg_6_1 then
			var_6_2.target = nil
		end
	end

	if not self._waiting_for_player then
		Managers.state.event:unregister("new_player_unit", self)

		self._waiting_for_player = nil
	end
end

AIPlayerSlotExtension.update_total_slots_count = function (self, arg_7_1)
	-- function 7
	local all_slots = self.all_slots
	local num = 0
	local num_2 = 0

	for i = 1, count do
		local var_7_3 = all_slots[tbl_4[i]]

		num = num + var_7_3.slots_count

		local slots = var_7_3.slots
		local total_slots_count = var_7_3.total_slots_count

		for j = 1, total_slots_count do
			local var_7_6 = slots[j]

			if not (not not var_7_6.released or var_7_6.ai_unit) then
				num_2 = num_2 + 1
			end
		end
	end

	if num_2 >= self.delayed_num_occupied_slots then
		self.delayed_num_occupied_slots = num_2
		self.delayed_slot_decay_t = arg_7_1 + num_15
	elseif arg_7_1 >= self.delayed_slot_decay_t then
		self.delayed_num_occupied_slots = num_2
	end

	self.num_occupied_slots = num_2

	return num, num_2
end

AIPlayerSlotExtension.update_disabled_slots_count = function (self, arg_8_1)
	-- function 8
	local all_slots = self.all_slots

	for i = 1, count do
		local var_8_1 = all_slots[tbl_4[i]]
		local slots = var_8_1.slots
		local count_2 = #slots
		local num = 0

		for j = 1, count_2 do
			if not slots[j].disabled then
				num = num + 1
			end
		end

		var_8_1.disabled_slots_count = num
	end
end

AIPlayerSlotExtension.update_slot_sound = function (self, arg_9_1)
	-- function 9
	local unit = self.unit
	local all_slots = self.all_slots
	local _is_server_player = self._is_server_player
	local num = 0

	for i = 1, count do
		local var_9_4 = tbl_4[i]
		local var_9_5 = all_slots[var_9_4]
		local dialogue_surrounded_count = SlotTypeSettings[var_9_4].dialogue_surrounded_count
		local slots_count = var_9_5.slots_count

		if not _is_server_player then
			local disabled_slots_count = var_9_5.disabled_slots_count
			local num_2 = var_9_5.total_slots_count - disabled_slots_count
			local num_3

			if num_2 > 0 then
				num_3 = slots_count / num_2

				if not num_3 then
					-- Nothing
				end
			end

			num_3 = 0

			::label_9_0::

			local clamp = math.clamp(num_3, 0, 1)

			if num < clamp then
				num = clamp
			end
		end

		if not (dialogue_surrounded_count <= slots_count) or not ScriptUnit.has_extension(unit, "dialogue_system") then
			local extension_input = ScriptUnit.extension_input(unit, "dialogue_system")
			local alloc_table = FrameTable.alloc_table()

			alloc_table.current_amount = slots_count
			alloc_table.has_shield = Managers.state.entity:system("dialogue_system"):player_shield_check(unit)

			extension_input:trigger_networked_dialogue_event("surrounded", alloc_table)
		end
	end

	if not _is_server_player then
		if not self._is_local_player then
			self._audio_system:set_global_parameter_with_lerp("occupied_slots_percentage", num * 100)
		else
			self._network_transmit:send_rpc("rpc_client_audio_set_global_parameter_with_lerp", self._peer_id, self._audio_parameter_id, num)
		end
	end
end

local function fn_2(self)
	-- function 10
	local slots = self.slots
	local total_slots_count = self.total_slots_count
	local var_10_2 = slots[1]
	local anchor_weight = var_10_2.anchor_weight

	for i = 1, total_slots_count do
		repeat
			local var_10_4 = slots[i]

			if not var_10_4.disabled then
				break
			end

			local anchor_weight_2 = var_10_4.anchor_weight

			if not (anchor_weight < anchor_weight_2 or anchor_weight_2 ~= anchor_weight or not (var_10_4.index < var_10_2.index)) then
				var_10_2 = var_10_4
				anchor_weight = anchor_weight_2
			end
		until true
	end

	return var_10_2
end

local rotate = Quaternion.rotate

local function fn_3(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local var_11_0 = normalize(flat(arg_11_1 - arg_11_0))
	local var_11_1 = Quaternion(-Vector3.up(), arg_11_2)

	return arg_11_0 + rotate(var_11_1, var_11_0) * arg_11_3
end

local function fn_4(self, arg_12_1)
	-- function 12
	local unbox = self.original_absolute_position:unbox()
	local type = self.type
	local distance = SlotTypeSettings[type].distance
	local radians = self.radians
	local var_12_4 = fn_3(arg_12_1, unbox, radians, distance)
	local var_12_5 = fn_3(arg_12_1, unbox, -radians, distance)

	self.position_right:store(var_12_4)
	self.position_left:store(var_12_5)
end

local function fn_5(self)
	-- function 13
	self.disabled = false
end

local function fn_6(self)
	-- function 14
	local ai_unit_slot_extension = self.ai_unit_slot_extension

	if not ai_unit_slot_extension then
		ai_unit_slot_extension:on_slot_lost()
	end

	self.ai_unit = nil
	self.ai_unit_slot_extension = nil

	local queue = self.queue

	for i = 1, #queue do
		queue[i]:on_slot_lost()
	end

	table.clear(self.queue)

	self.disabled = true
	self.released = false
end

local function fn_7(self, arg_15_1)
	-- function 15
	local owner_extension = self.owner_extension
	local unbox = self.absolute_position:unbox()
	local count_2 = #arg_15_1

	for i = 1, count_2 do
		repeat
			local var_15_3 = arg_15_1[i]

			if var_15_3 == owner_extension then
				break
			end

			local all_slots = var_15_3.all_slots

			for j = 1, count do
				local var_15_5 = tbl_4[j]
				local var_15_6 = all_slots[var_15_5]
				local radius = SlotTypeSettings[var_15_5].radius
				local num = radius * radius
				local slots = var_15_6.slots
				local total_slots_count = var_15_6.total_slots_count

				for k = 1, total_slots_count do
					repeat
						local var_15_11 = slots[k]

						if not var_15_11.disabled then
							break
						end

						local unbox_2 = var_15_11.absolute_position:unbox()

						if num > distance_squared(unbox, unbox_2) then
							return var_15_11
						end
					until true
				end
			end
		until true
	end

	return false
end

local num_20 = 1.2
local num_21 = num_20 * num_20

local function fn_8(self, arg_16_1)
	-- function 16
	local owner_extension = self.owner_extension
	local unbox = self.absolute_position:unbox()
	local count = #arg_16_1
	local var_16_3 = distance_squared

	for i = 1, count do
		repeat
			local var_16_4 = arg_16_1[i]

			if var_16_4 == owner_extension then
				break
			end

			local unbox_2 = var_16_4.position:unbox()

			if var_16_3(unbox, unbox_2) < num_21 then
				return true
			end
		until true
	end

	return false
end

local function fn_9(self, arg_17_1)
	-- function 17
	local priority = self.priority
	local priority_2 = arg_17_1.priority
	local index = self.owner_extension.index
	local index_2 = self.index
	local index_3 = arg_17_1.owner_extension.index
	local index_4 = arg_17_1.index

	if not (not (priority < priority_2) or self.ai_unit) then
		return
	elseif not (not (priority_2 < priority) or arg_17_1.ai_unit) then
		return
	end

	if priority < priority_2 then
		fn_6(arg_17_1)

		return false
	elseif priority_2 < priority then
		fn_6(self)

		return true
	end

	if index_4 < index_2 then
		fn_6(self)

		return true
	end

	if index_2 < index_4 then
		fn_6(arg_17_1)

		return false
	end

	if index_3 < index then
		fn_6(self)

		return true
	else
		fn_6(arg_17_1)

		return false
	end
end

local function fn_10(self)
	-- function 18
	local unbox = self.absolute_position:unbox()
	local type = self.type
	local all_slots = self.owner_extension.all_slots
	local var_18_3 = distance_squared

	for i = 1, count do
		repeat
			local var_18_4 = tbl_4[i]
			local var_18_5 = all_slots[var_18_4]

			if type == var_18_4 then
				break
			end

			local radius = SlotTypeSettings[var_18_4].radius
			local num = radius * radius
			local slots = var_18_5.slots
			local total_slots_count = var_18_5.total_slots_count

			for j = 1, total_slots_count do
				repeat
					local var_18_10 = slots[j]

					if not var_18_10.disabled then
						break
					end

					if not var_18_10.ai_unit then
						break
					end

					local unbox_2 = var_18_10.absolute_position:unbox()

					if num > var_18_3(unbox, unbox_2) then
						return var_18_10
					end
				until true
			end
		until true
	end

	return false
end

local num_22 = 3
local num_23 = num_22 * num_22

local function fn_11(self)
	-- function 19
	if not self.disabled then
		return
	end

	local ai_unit = self.ai_unit

	if not ai_unit then
		self.released = false

		return
	end

	if not self.ai_unit_slot_extension.release_slot_lock then
		local local_position = Unit.local_position(ai_unit, 0)

		if not local_position then
			local unbox = self.absolute_position:unbox()

			self.released = distance_squared(local_position, unbox) > num_23
		else
			self.released = true
		end
	else
		self.released = false
	end
end

local function fn_12(arg_20_0, arg_20_1, arg_20_2)
	-- function 20
	if not arg_20_1 then
		fn_5(arg_20_0)
	else
		fn_6(arg_20_0)

		return false
	end

	if not fn_8(arg_20_0, arg_20_2) then
		fn_5(arg_20_0)
	else
		fn_6(arg_20_0)

		return false
	end

	local var_20_0 = fn_7(arg_20_0, arg_20_2)

	if not var_20_0 then
		if not fn_9(arg_20_0, var_20_0) then
			fn_5(arg_20_0)
		else
			return false
		end
	end

	local var_20_1 = fn_10(arg_20_0)

	if not var_20_1 then
		if not fn_9(arg_20_0, var_20_1) then
			fn_5(arg_20_0)
		else
			return false
		end
	end

	fn_11(arg_20_0)

	return true
end

local function fn_13(self, arg_21_1)
	-- function 21
	local slots = arg_21_1.slots
	local index = self.index
	local total_slots_count = arg_21_1.total_slots_count
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

		local var_21_7 = slots[num_2]
		local disabled = var_21_7.disabled
		local released = var_21_7.released
		local ai_unit_2 = var_21_7.ai_unit

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

		local var_21_13 = slots[num_4]
		local disabled_2 = var_21_13.disabled
		local released_2 = var_21_13.released
		local ai_unit_3 = var_21_13.ai_unit

		if not (disabled_2 or ai_unit_3) then
			break
		end

		if not released_2 then
			self.anchor_weight = self.anchor_weight + num_3
			num_3 = num_3 / 2
		end
	end
end

local function fn_14(self)
	-- function 22
	for i = 1, count do
		local var_22_0 = self[tbl_4[i]]
		local slots = var_22_0.slots
		local total_slots_count = var_22_0.total_slots_count

		for j = 1, total_slots_count do
			local var_22_3 = slots[j]

			fn_13(var_22_3, var_22_0)
		end
	end
end

local function fn_15(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6)
	-- function 23
	local var_23_0
	local num = 10
	local num_2 = 0.15

	if not arg_23_2 then
		local var_23_3 = Quaternion(-Vector3.up(), arg_23_2)

		arg_23_1 = rotate(var_23_3, arg_23_1)
	end

	for i = 0, num - 1 do
		local num_3 = arg_23_0 + arg_23_1 * (i * num_2 + arg_23_3)

		var_23_0 = scripts_entity_system_systems_ai_ai_slot_utils.clamp_position_on_navmesh(num_3, arg_23_4, arg_23_5, arg_23_6)

		if not var_23_0 then
			break
		end
	end

	return var_23_0, var_23_0
end

local function fn_16(self, arg_24_1, arg_24_2)
	-- function 24
	local var_24_0

	if not self then
		var_24_0 = self:current_velocity()
	else
		var_24_0 = Vector3(0, 0, 0)
	end

	if length(var_24_0) > 0.1 then
		local var_24_1 = length(var_24_0)
		local var_24_2 = normalize(var_24_0)
		local num = var_24_2 * var_24_1
		local var_24_4 = normalize(arg_24_2 - arg_24_1)
		local var_24_5 = dot(var_24_4, var_24_2)

		return arg_24_1 + num * math.max(2 * (var_24_5 - 0.5), 0)
	else
		return arg_24_1
	end
end

local function fn_17(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6, arg_25_7, arg_25_8)
	-- function 25
	local var_25_0

	if not arg_25_3 then
		var_25_0 = fn_3(arg_25_1, arg_25_2, arg_25_3, arg_25_4)

		if not var_25_0 then
			-- Nothing
		end
	end

	var_25_0 = arg_25_2

	do
		local var_25_1
	end

	::label_25_0::

	if not arg_25_5 then
		var_25_1 = fn_16(arg_25_0, var_25_0, arg_25_1)

		if not var_25_1 then
			-- Nothing
		end
	end

	var_25_1 = var_25_0

	::label_25_1::

	return scripts_entity_system_systems_ai_ai_slot_utils.clamp_position_on_navmesh(var_25_1, arg_25_6, arg_25_7, arg_25_8), var_25_0
end

local function fn_18(self, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6, arg_26_7, arg_26_8, arg_26_9, arg_26_10)
	-- function 26
	local var_26_0, var_26_1 = fn_17(arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6, arg_26_7, arg_26_9, arg_26_10)
	local position_check_index = self.position_check_index
	local flag = position_check_index == tbl.CHECK_MIDDLE
	local var_26_4

	if not flag then
		var_26_4 = tbl_2[position_check_index]

		if not var_26_4 then
			-- Nothing
		end
	end

	var_26_4 = nil

	::label_26_0::

	local var_26_5 = num_3

	if not var_26_0 then
		local var_26_6

		if not flag then
			var_26_6 = var_26_0
		else
			var_26_6 = fn_3(var_26_0, arg_26_2, var_26_4, num)
		end

		local num_2 = arg_26_2 + normalize(var_26_6 - arg_26_2) * var_26_5

		if not raycango(arg_26_7, var_26_6, num_2, arg_26_8) then
			var_26_0 = nil
		end
	elseif not flag then
		local var_26_8 = fn_3(arg_26_3, arg_26_2, var_26_4, num)

		var_26_0, var_26_1 = fn_17(arg_26_1, arg_26_2, var_26_8, arg_26_4, arg_26_5, arg_26_6, arg_26_7, arg_26_9, arg_26_10)

		if not var_26_0 then
			local num_4 = arg_26_2 + normalize(var_26_0 - arg_26_2) * var_26_5

			if not raycango(arg_26_7, var_26_0, num_4, arg_26_8) then
				self.position_check_index = tbl.CHECK_MIDDLE
			else
				var_26_0 = nil
			end
		end
	end

	if not var_26_0 then
		self.position_check_index = (self.position_check_index + 1) % size
	end

	return var_26_0, var_26_1
end

AIPlayerSlotExtension.update_target_slots = function (self, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	-- function 27
	local var_27_0
	local var_27_1
	local var_27_2
	local var_27_3
	local was_on_ladder = self.was_on_ladder
	local _status_ext = self._status_ext

	if not _status_ext then
		var_27_0, var_27_1 = _status_ext:get_is_on_ladder()

		if not var_27_0 then
			local var_27_6
			local var_27_7

			var_27_2, var_27_3, var_27_7 = Managers.state.bot_nav_transition:get_ladder_coordinates(var_27_1)
			var_27_0 = not var_27_7
		end

		self.was_on_ladder = var_27_0
	end

	local unit = self.unit
	local local_position = Unit.local_position(unit, 0)
	local flag = not var_27_0 and local_position and scripts_entity_system_systems_ai_ai_slot_utils.get_target_pos_on_navmesh(local_position, arg_27_3)
	local unbox = self.position:unbox()
	local outside_navmesh_at_t = self.outside_navmesh_at_t
	local flag_2 = false
	local num = 0

	if not flag then
		num = distance_squared(flag, unbox)
		self.outside_navmesh_at_t = nil
	elseif not (outside_navmesh_at_t == nil or not (arg_27_1 < outside_navmesh_at_t + num_11)) then
		if outside_navmesh_at_t == nil then
			self.outside_navmesh_at_t = arg_27_1
		end

		flag = unbox
	else
		flag_2 = true
		flag = local_position
		num = distance_squared(flag, unbox)
	end

	if not ((num > num_6 or var_27_0 ~= was_on_ladder or not var_27_0) and not (arg_27_1 > self.next_slot_status_update_at)) then
		local flag_3 = true

		self.position:store(flag)
		self:_update_target_slots_positions(arg_27_2, flag_3, arg_27_3, arg_27_4, var_27_0, var_27_1, var_27_2, var_27_3, flag_2)

		self.moved_at = arg_27_1
		self.next_slot_status_update_at = arg_27_1 + num_12

		return true
	end

	local moved_at = self.moved_at
	local _locomotion_ext = self._locomotion_ext
	local var_27_18

	if not _locomotion_ext then
		var_27_18 = length_squared(_locomotion_ext:current_velocity())

		if not var_27_18 then
			-- Nothing
		end
	end

	var_27_18 = 0

	::label_27_0::

	if not (var_27_0 or not moved_at and not (arg_27_1 - moved_at > num_7) or var_27_18 <= num_13 or not (arg_27_1 - moved_at > num_8)) then
		local flag_4 = false

		self:_update_target_slots_positions(arg_27_2, flag_4, arg_27_3, arg_27_4, var_27_0, var_27_1, var_27_2, var_27_3, flag_2)

		self.moved_at = nil
		self.next_slot_status_update_at = arg_27_1 + num_12

		return true
	end

	if arg_27_1 > self.next_slot_status_update_at then
		self:_update_target_slots_status(arg_27_2, arg_27_3, arg_27_4, flag_2, arg_27_1)

		self.next_slot_status_update_at = arg_27_1 + num_12

		return true
	end

	return false
end

AIPlayerSlotExtension._set_slot_absolute_position = function (self, arg_28_1, arg_28_2)
	-- function 28
	local unbox = self.position:unbox()
	local var_28_1 = normalize(flat(arg_28_2 - unbox))

	arg_28_1.absolute_position:store(arg_28_2)
	arg_28_1.queue_direction:store(var_28_1)
	fn_4(arg_28_1, unbox)
end

AIPlayerSlotExtension._update_target_slots_status = function (self, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5)
	-- function 29
	local all_slots = self.all_slots

	for i = 1, count do
		local var_29_1 = tbl_4[i]
		local var_29_2 = all_slots[var_29_1]
		local slots = var_29_2.slots
		local total_slots_count = var_29_2.total_slots_count
		local flag = false

		for j = 1, total_slots_count do
			local var_29_6 = slots[j]
			local unbox = var_29_6.absolute_position:unbox()
			local _update_slot_position = self:_update_slot_position(var_29_6, unbox, flag, arg_29_2, arg_29_3, nil, nil, arg_29_4)

			fn_12(var_29_6, _update_slot_position, arg_29_1)
		end

		fn_14(all_slots)

		local disabled_slots_count = var_29_2.disabled_slots_count
		local flag_2 = self.num_occupied_slots >= total_slots_count - disabled_slots_count

		if not (not flag_2 and self.full_slots_at_t[var_29_1]) then
			self.full_slots_at_t[var_29_1] = arg_29_5
		elseif not flag_2 then
			self.full_slots_at_t[var_29_1] = nil
		end
	end
end

AIPlayerSlotExtension._update_target_slots_positions = function (self, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5, arg_30_6, arg_30_7, arg_30_8, arg_30_9)
	-- function 30
	if not arg_30_5 then
		self:_update_target_slots_positions_on_ladder(arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_6, arg_30_7, arg_30_8)

		return
	end

	local var_30_0
	local var_30_1

	if not arg_30_9 then
		var_30_0, var_30_1 = num_5, num_4
	else
		var_30_0, var_30_1 = num_9, num_10
	end

	local all_slots = self.all_slots

	for i = 1, count do
		local var_30_3 = all_slots[tbl_4[i]]
		local slots = var_30_3.slots
		local var_30_5 = fn_2(var_30_3)
		local total_slots_count = var_30_3.total_slots_count
		local index = var_30_5.index
		local _update_anchor_slot_position = self:_update_anchor_slot_position(var_30_5, arg_30_2, arg_30_3, arg_30_4, var_30_0, var_30_1, arg_30_9)

		fn_12(var_30_5, _update_anchor_slot_position, arg_30_1)

		for j = index + 1, total_slots_count do
			local var_30_9 = slots[j]
			local unbox = slots[j - 1].position_right:unbox()
			local _update_slot_position = self:_update_slot_position(var_30_9, unbox, arg_30_2, arg_30_3, arg_30_4, var_30_0, var_30_1, arg_30_9)

			fn_12(var_30_9, _update_slot_position, arg_30_1)
		end

		for k = index - 1, 1, -1 do
			local var_30_12 = slots[k]
			local unbox_2 = slots[k + 1].position_left:unbox()
			local _update_slot_position_2 = self:_update_slot_position(var_30_12, unbox_2, arg_30_2, arg_30_3, arg_30_4, var_30_0, var_30_1, arg_30_9)

			fn_12(var_30_12, _update_slot_position_2, arg_30_1)
		end

		fn_14(all_slots)
	end

	fn_14(all_slots)
end

AIPlayerSlotExtension._update_slot_position = function (self, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5, arg_31_6, arg_31_7, arg_31_8)
	-- function 31
	local _locomotion_ext = self._locomotion_ext
	local unbox = self.position:unbox()
	local var_31_2
	local var_31_3
	local type = arg_31_1.type
	local distance = SlotTypeSettings[type].distance

	if not arg_31_8 then
		var_31_2, var_31_3 = fn_15(unbox, normalize(arg_31_2 - unbox), nil, distance, arg_31_4, arg_31_6, arg_31_7)
	else
		var_31_2, var_31_3 = fn_18(arg_31_1, _locomotion_ext, unbox, arg_31_2, nil, nil, arg_31_3, arg_31_4, arg_31_5, arg_31_6, arg_31_7)
	end

	if not var_31_2 then
		arg_31_1.original_absolute_position:store(var_31_3)
		self:_set_slot_absolute_position(arg_31_1, var_31_2)

		return true, var_31_2
	else
		arg_31_1.original_absolute_position:store(arg_31_2)
		self:_set_slot_absolute_position(arg_31_1, arg_31_2)

		return false, arg_31_2
	end
end

local num_24 = 24

AIPlayerSlotExtension._update_anchor_slot_position = function (self, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6, arg_32_7)
	-- function 32
	local _locomotion_ext = self._locomotion_ext
	local unbox = self.position:unbox()
	local ai_unit = arg_32_1.ai_unit
	local flag = not ai_unit and Unit.local_position(ai_unit, 0)
	local var_32_4

	if not ai_unit then
		var_32_4 = normalize(flag - unbox)

		if not var_32_4 then
			-- Nothing
		end
	end

	var_32_4 = Vector3.forward()

	::label_32_0::

	local type = arg_32_1.type
	local distance = SlotTypeSettings[type].distance
	local num = unbox + var_32_4 * distance
	local var_32_8
	local var_32_9

	if not arg_32_7 then
		var_32_8, var_32_9 = fn_15(unbox, var_32_4, nil, distance, arg_32_3, arg_32_5, arg_32_6)
	else
		var_32_8, var_32_9 = fn_18(arg_32_1, _locomotion_ext, unbox, num, nil, nil, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6)
	end

	local num_2 = 0

	while not (not (num_2 <= num_24) or var_32_8) do
		local flag_2

		flag_2 = not (num_2 % 2 > 0) or not -1 or 1

		local num_3 = math.ceil(num_2 / 2) * flag_2

		if not arg_32_7 then
			var_32_8, var_32_9 = fn_15(unbox, var_32_4, num_3, distance, arg_32_3, arg_32_5, arg_32_6)
		else
			var_32_8, var_32_9 = fn_18(arg_32_1, _locomotion_ext, unbox, num, num_3, distance, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6)
		end

		num_2 = num_2 + 1
	end

	if not var_32_8 then
		arg_32_1.original_absolute_position:store(var_32_9)
		self:_set_slot_absolute_position(arg_32_1, var_32_8)

		return true, var_32_8
	else
		arg_32_1.original_absolute_position:store(num)
		self:_set_slot_absolute_position(arg_32_1, num)

		return false, num
	end
end

AIPlayerSlotExtension._update_target_slots_positions_on_ladder = function (self, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5, arg_33_6, arg_33_7)
	-- function 33
	local all_slots = self.all_slots

	for k, v in pairs(all_slots) do
		local slots = v.slots
		local total_slots_count = v.total_slots_count
		local num = 1
		local var_33_4 = normalize(flat(Quaternion.forward(Unit.world_rotation(arg_33_5, 0))))
		local cross = Vector3.cross(var_33_4, Vector3.up())
		local floor = math.floor(total_slots_count / 2)
		local ceil = math.ceil(floor / 2)
		local var_33_8 = slots[ceil]

		var_33_8.original_absolute_position:store(arg_33_7)
		self:_set_slot_absolute_position(var_33_8, arg_33_7)
		fn_12(var_33_8, true, arg_33_1)

		local var_33_9 = arg_33_7
		local flag = true

		for k_2 = ceil - 1, 1, -1 do
			local var_33_11 = slots[k_2]
			local num_2 = var_33_9 - cross * num

			flag = not flag and raycango(arg_33_3, var_33_9, num_2, arg_33_4)

			var_33_11.original_absolute_position:store(num_2)
			self:_set_slot_absolute_position(var_33_11, num_2)
			fn_12(var_33_11, flag, arg_33_1)

			var_33_9 = num_2
		end

		local var_33_13 = arg_33_7
		local flag_2 = true

		for l = ceil + 1, floor do
			local var_33_15 = slots[l]
			local num_3 = var_33_13 + cross * num

			flag_2 = not flag_2 and raycango(arg_33_3, var_33_13, num_3, arg_33_4)

			var_33_15.original_absolute_position:store(num_3)
			self:_set_slot_absolute_position(var_33_15, num_3)
			fn_12(var_33_15, flag_2, arg_33_1)
		end

		local num_4 = floor + math.ceil((total_slots_count - floor) / 2)
		local var_33_18 = slots[num_4]

		var_33_18.original_absolute_position:store(arg_33_6)
		self:_set_slot_absolute_position(var_33_18, arg_33_6)
		fn_12(var_33_18, true, arg_33_1)

		local var_33_19 = arg_33_6
		local num_5 = 1
		local num_6 = 1
		local num_7 = 1
		local num_8 = arg_33_6 + num_7 * var_33_4
		local num_9 = num_4 - 1 - floor
		local num_10 = math.pi / 2.5 / num_9
		local num_11 = 1

		for i4 = num_4 - 1, floor + 1, -1 do
			local var_33_27 = slots[i4]
			local num_12 = math.pi * 1.5 + num_11 * num_10
			local num_13 = num_8 + num_7 * (cross * math.cos(num_12) + var_33_4 * math.sin(num_12))
			local var_33_30
			local var_33_31, var_33_32 = triangle_from_position(arg_33_3, var_33_19, num_5, num_6)

			if not var_33_31 then
				num_13.z = var_33_32
			end

			var_33_27.original_absolute_position:store(num_13)
			self:_set_slot_absolute_position(var_33_27, num_13)
			fn_12(var_33_27, var_33_31, arg_33_1)

			num_11 = num_11 + 1
		end

		local num_14 = total_slots_count - num_4
		local num_15 = math.pi / 2.5 / num_14
		local num_16 = 1
		local var_33_36 = arg_33_6

		for i5 = num_4 + 1, total_slots_count do
			local var_33_37 = slots[i5]
			local num_17 = math.pi * 1.5 - num_16 * num_15
			local num_18 = num_8 + num_7 * (cross * math.cos(num_17) + var_33_4 * math.sin(num_17))
			local var_33_40
			local var_33_41, var_33_42 = triangle_from_position(arg_33_3, var_33_36, num_5, num_6)

			if not var_33_41 then
				num_18.z = var_33_42
			end

			var_33_37.original_absolute_position:store(num_18)
			self:_set_slot_absolute_position(var_33_37, num_18)
			fn_12(var_33_37, var_33_41, arg_33_1)

			num_16 = num_16 + 1
		end

		fn_14(all_slots)
	end
end

local num_25 = 3
local num_26 = 2
local num_27 = 3
local num_28 = 1.75
local num_29 = 100

local function fn_19(self, arg_34_1, arg_34_2, arg_34_3)
	-- function 34
	local target_unit = self.target_unit
	local ai_unit = self.ai_unit

	if not (not HEALTH_ALIVE[target_unit] and ALIVE[ai_unit]) then
		return
	end

	local slot_template = self.ai_unit_slot_extension.slot_template
	local type = self.type
	local distance_2 = SlotTypeSettings[type].distance
	local owner_extension = self.owner_extension
	local var_34_6 = owner_extension.full_slots_at_t[type]
	local min_wait_queue_distance = slot_template.min_wait_queue_distance

	min_wait_queue_distance = min_wait_queue_distance or num_25

	local num = min_wait_queue_distance * min_wait_queue_distance
	local num_2 = 0

	if not var_34_6 and not slot_template.min_queue_offset_distance then
		local min_queue_offset_distance = slot_template.min_queue_offset_distance
		local full_offset_time = slot_template.full_offset_time
		local num_3 = arg_34_3 - var_34_6

		num_2 = min_queue_offset_distance * math.min(num_3 / full_offset_time, 1)
	end

	local unbox = owner_extension.position:unbox()
	local local_position = Unit.local_position(ai_unit, 0)
	local unbox_2 = self.queue_direction:unbox()
	local flag = arg_34_2 or 0
	local var_34_17 = distance(unbox, local_position)
	local queue_distance = SlotTypeSettings[type].queue_distance
	local num_4 = unbox + unbox_2 * math.max(var_34_17 + queue_distance + flag - num_2, min_wait_queue_distance)
	local clamp_position_on_navmesh = scripts_entity_system_systems_ai_ai_slot_utils.clamp_position_on_navmesh(num_4, arg_34_1, num_26, num_27)
	local num_5 = 5
	local num_6 = 1

	while not (clamp_position_on_navmesh or not (num_6 <= num_5)) do
		local max = math.max(math.max(var_34_17 * (1 - num_6 / num_5), distance_2) + queue_distance + flag - num_2, min_wait_queue_distance)
		local num_7 = unbox + unbox_2 * math.max(max, 0.5)

		clamp_position_on_navmesh = scripts_entity_system_systems_ai_ai_slot_utils.clamp_position_on_navmesh(num_7, arg_34_1, num_26, num_27)
		num_6 = num_6 + 1
	end

	local num_8 = 0
	local var_34_26

	if not clamp_position_on_navmesh then
		local clamp_position_on_navmesh_2 = scripts_entity_system_systems_ai_ai_slot_utils.clamp_position_on_navmesh(unbox, arg_34_1, num_26, num_27)

		if not clamp_position_on_navmesh_2 then
			var_34_26 = raycango(arg_34_1, clamp_position_on_navmesh, clamp_position_on_navmesh_2)
		end
	end

	if not (not clamp_position_on_navmesh and var_34_26) then
		num_8 = num_29

		local num_9 = unbox + unbox_2 * queue_distance

		if not slot_template.restricted_queue_distance then
			if num <= distance_squared(unbox, num_9) then
				return num_9, num_8
			else
				local var_34_29
				local var_34_30 = normalize(local_position - unbox)
				local num_10 = 1

				while not (var_34_29 or not (num_10 <= num_5)) do
					local max_2 = math.max(math.max(var_34_17 * (1 - num_10 / num_5), distance_2) + queue_distance + flag - num_2, min_wait_queue_distance)

					num_9 = unbox + var_34_30 * math.max(max_2, 0.5)
					var_34_29 = scripts_entity_system_systems_ai_ai_slot_utils.clamp_position_on_navmesh(num_9, arg_34_1, num_26, num_27)
					num_10 = num_10 + 1
				end

				if not var_34_29 then
					return var_34_29, 0
				else
					return num_9, num_8
				end
			end
		else
			return num_9, num_8
		end
	else
		return clamp_position_on_navmesh, num_8
	end
end

AIPlayerSlotExtension.debug_draw = function (self, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
	-- function 35
	local num_2 = Vector3.up() * 0.1
	local all_slots = self.all_slots

	for k, v in pairs(all_slots) do
		local slots = v.slots
		local count = #slots
		local unbox = self.position:unbox()
		local get = Colors.get(self.debug_color_name)

		arg_35_1:circle(unbox + num_2, 0.5, Vector3.up(), get)
		arg_35_1:circle(unbox + num_2, 0.45, Vector3.up(), get)

		if not self.next_slot_status_update_at then
			local num_4 = (arg_35_2 - self.next_slot_status_update_at) / num_12

			arg_35_1:circle(unbox + num_2, 0.45 * num_4, Vector3.up(), get)
		end

		for k_2 = 1, count do
			repeat
				local var_35_7 = slots[k_2]
				local flag

				flag = var_35_7 == fn_2(v)

				local ai_unit = var_35_7.ai_unit
				local flag_2

				flag_2 = not ai_unit and 255 and 150

				local get_color_with_alpha

				if not var_35_7.disabled then
					get_color_with_alpha = Colors.get_color_with_alpha("gray", flag_2)

					if not get_color_with_alpha then
						-- Nothing
					end
				end

				get_color_with_alpha = Colors.get_color_with_alpha(var_35_7.debug_color_name, flag_2)

				::label_35_0::

				if not var_35_7.absolute_position then
					local unbox_2 = var_35_7.absolute_position:unbox()
					local unbox_3 = var_35_7.original_absolute_position:unbox()

					if not ALIVE[ai_unit] then
						local local_position = Unit.local_position(ai_unit, 0)

						arg_35_1:circle(local_position + num_2, 0.35, Vector3.up(), get_color_with_alpha)
						arg_35_1:circle(local_position + num_2, 0.3, Vector3.up(), get_color_with_alpha)

						local node = Unit.node(ai_unit, "c_head")
						local str = "player_1"
						local get_table

						if not var_35_7.disabled then
							get_table = Colors.get_table("gray")

							if not get_table then
								-- Nothing
							end
						end

						get_table = Colors.get_table(var_35_7.debug_color_name)

						::label_35_1::

						local var_35_18 = Vector3(get_table[2], get_table[3], get_table[4])
						local var_35_19 = Vector3(0, 0, -1)
						local num_5 = 0.4
						local index = var_35_7.index
						local str_2 = "slot_index"

						Managers.state.debug_text:clear_unit_text(ai_unit, str_2)
						Managers.state.debug_text:output_unit_text(index, num_5, ai_unit, node, var_35_19, nil, str_2, var_35_18, str)

						if not (var_35_7.ghost_position.x == 0 or var_35_7.disable_at) then
							local unbox_4 = var_35_7.ghost_position:unbox()

							arg_35_1:line(unbox_4 + num_2, unbox_2 + num_2, get_color_with_alpha)
							arg_35_1:sphere(unbox_4 + num_2, 0.3, get_color_with_alpha)
							arg_35_1:line(unbox_4 + num_2, local_position + num_2, get_color_with_alpha)
						else
							arg_35_1:line(unbox_2 + num_2, local_position + num_2, get_color_with_alpha)
						end
					end

					local num_6 = 0.4
					local get_table_2

					if not var_35_7.disabled then
						get_table_2 = Colors.get_table("gray")

						if not get_table_2 then
							-- Nothing
						end
					end

					get_table_2 = Colors.get_table(var_35_7.debug_color_name)

					::label_35_2::

					local var_35_26 = Vector3(get_table_2[2], get_table_2[3], get_table_2[4])
					local str_3 = "slot_index_" .. k .. "_" .. var_35_7.index .. "_" .. self.index

					Managers.state.debug_text:clear_world_text(str_3)
					Managers.state.debug_text:output_world_text(var_35_7.index, num_6, unbox_2 + num_2, nil, str_3, var_35_26)

					local radius = SlotTypeSettings[k].radius

					arg_35_1:circle(unbox_2 + num_2, radius, Vector3.up(), get_color_with_alpha)
					arg_35_1:circle(unbox_2 + num_2, radius - 0.05, Vector3.up(), get_color_with_alpha)

					local var_35_29 = fn_19(var_35_7, arg_35_3, nil, arg_35_2)

					if not var_35_29 then
						arg_35_1:circle(var_35_29 + num_2, num_28, Vector3.up(), get_color_with_alpha)
						arg_35_1:circle(var_35_29 + num_2, num_28 - 0.05, Vector3.up(), get_color_with_alpha)
						arg_35_1:line(unbox_2 + num_2, var_35_29 + num_2, get_color_with_alpha)

						local queue = var_35_7.queue
						local count_2 = #queue

						for l = 1, count_2 do
							local unit = queue[l].unit
							local local_position_2 = Unit.local_position(unit, 0)

							if not local_position_2 then
								arg_35_1:circle(local_position_2 + num_2, 0.35, Vector3.up(), get_color_with_alpha)
								arg_35_1:circle(local_position_2 + num_2, 0.3, Vector3.up(), get_color_with_alpha)
								arg_35_1:line(var_35_29 + num_2, local_position_2, get_color_with_alpha)
							end
						end
					end

					local num_7 = 0.2
					local get_table_3

					if not var_35_7.disabled then
						get_table_3 = Colors.get_table("gray")

						if not get_table_3 then
							-- Nothing
						end
					end

					get_table_3 = Colors.get_table(var_35_7.debug_color_name)

					::label_35_3::

					local var_35_36 = Vector3(get_table_3[2], get_table_3[3], get_table_3[4])
					local str_4 = "wait_slot_index_" .. k .. "_" .. var_35_7.index .. "_" .. k_2

					Managers.state.debug_text:clear_world_text(str_4)

					if not var_35_29 then
						Managers.state.debug_text:output_world_text("wait " .. var_35_7.index, num_7, var_35_29 + num_2, nil, str_4, var_35_36)
					end

					local position_check_index = var_35_7.position_check_index
					local var_35_39 = unbox_2

					if position_check_index == tbl.CHECK_MIDDLE then
						-- Nothing
					else
						local var_35_40 = tbl_2[position_check_index]

						var_35_39 = fn_3(var_35_39, unbox, var_35_40, num)
					end

					local num_8 = unbox + normalize(var_35_39 - unbox) * num_3

					arg_35_1:line(num_8 + num_2, var_35_39 + num_2, get_color_with_alpha)
					arg_35_1:circle(var_35_39 + num_2, 0.1, Vector3.up(), Color(255, 0, 255))

					break
				end

				local str_5 = "wait_slot_index_" .. k .. "_" .. var_35_7.index .. "_" .. k_2

				Managers.state.debug_text:clear_world_text(str_5)
			until true
		end
	end
end

local function fn_20(self)
	-- function 36
	local num = 0
	local slots = self.slots
	local total_slots_count = self.total_slots_count

	for i = 1, total_slots_count do
		local var_36_3 = slots[i]

		if not var_36_3.ai_unit then
			num = num + 1
		end

		num = num + #var_36_3.queue
	end

	self.slots_count = num

	return num
end

local function fn_21(self, arg_37_1, arg_37_2)
	-- function 37
	local unbox = self.original_absolute_position:unbox()
	local var_37_1 = flat(unbox - arg_37_2)
	local var_37_2 = normalize(var_37_1)
	local var_37_3 = flat(arg_37_1 - arg_37_2)
	local var_37_4 = normalize(var_37_3)
	local var_37_5 = dot(var_37_2, var_37_4)

	return var_37_5 < 0.6, var_37_5
end

local num_30 = -3
local num_31 = -2

local function fn_22(self)
	-- function 38
	local disabled_slots_count = self.disabled_slots_count
	local slots_count = self.slots_count
	local num = self.total_slots_count - disabled_slots_count

	return not (disabled_slots_count >= 2) or num <= slots_count
end

local function fn_23(self)
	-- function 39
	self.ghost_position:store(Vector3(0, 0, 0))
end

local num_32 = 90
local degrees_to_radians = math.degrees_to_radians(num_32)

local function fn_24(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
	-- function 40
	local unbox = arg_40_2.absolute_position:unbox()
	local min = math.min(distance(arg_40_1, arg_40_0), 8)
	local var_40_2 = fn_3(unbox, arg_40_0, -degrees_to_radians, min)
	local var_40_3 = fn_3(unbox, arg_40_0, degrees_to_radians, min)
	local flag = not (distance_squared(arg_40_1, var_40_2) > distance_squared(arg_40_1, var_40_3)) and var_40_2 and var_40_3
	local clamp_position_on_navmesh = scripts_entity_system_systems_ai_ai_slot_utils.clamp_position_on_navmesh(flag, arg_40_3)
	local var_40_6

	if not clamp_position_on_navmesh then
		var_40_6 = normalize(clamp_position_on_navmesh - unbox)
	else
		var_40_6 = normalize(flag - unbox)
	end

	local num = 5

	for i = 1, num do
		if not clamp_position_on_navmesh and not raycango(arg_40_3, clamp_position_on_navmesh, unbox, arg_40_4) then
			arg_40_2.ghost_position:store(clamp_position_on_navmesh)

			return
		end

		local type = arg_40_2.type
		local distance_2 = SlotTypeSettings[type].distance
		local num_2 = arg_40_1 + var_40_6 * (distance_2 + (min - distance_2) * (num - i) / num)

		clamp_position_on_navmesh = scripts_entity_system_systems_ai_ai_slot_utils.clamp_position_on_navmesh(num_2, arg_40_3)
	end

	fn_23(arg_40_2)
end

TEST_SLOT = 0

AIPlayerSlotExtension._get_best_slot = function (self, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
	-- function 41
	local local_position = Unit.local_position(arg_41_1, 0)
	local unbox = self.position:unbox()
	local var_41_2 = self.all_slots[arg_41_2]
	local slots = var_41_2.slots
	local total_slots_count = var_41_2.total_slots_count
	local flag = not arg_41_4 and fn_22(var_41_2)
	local var_41_6
	local huge = math.huge

	if TEST_SLOT > 0 then
		return slots[TEST_SLOT]
	end

	for i = 1, total_slots_count do
		local var_41_8 = slots[i]

		if not var_41_8.disabled then
			-- Nothing
		elseif arg_41_3 or not flag or not fn_21(var_41_8, local_position, unbox) then
			-- Nothing
		else
			local ai_unit = var_41_8.ai_unit
			local unbox_2 = var_41_8.original_absolute_position:unbox()
			local var_41_11 = distance_squared(unbox_2, local_position)
			local huge_2 = math.huge

			if not ALIVE[ai_unit] then
				if ai_unit == arg_41_1 then
					huge_2 = var_41_11 + num_30
				elseif not var_41_8.released then
					local local_position_2 = Unit.local_position(ai_unit, 0)

					if var_41_11 < distance_squared(unbox_2, local_position_2) + num_31 then
						huge_2 = var_41_11
					end
				end
			else
				huge_2 = var_41_11
			end

			if huge_2 < huge then
				var_41_6 = var_41_8
				huge = huge_2
			end
		end
	end

	return var_41_6
end

AIPlayerSlotExtension._get_best_slot_to_wait_on = function (self, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5, arg_42_6)
	-- function 42
	local local_position = Unit.local_position(arg_42_1, 0)
	local unbox = self.position:unbox()
	local all_slots = self.all_slots
	local var_42_3 = all_slots[arg_42_2]
	local flag = not arg_42_4 and fn_22(var_42_3)
	local huge = math.huge
	local var_42_6

	for i = 1, count do
		local var_42_7 = all_slots[tbl_4[i]]
		local slots = var_42_7.slots
		local total_slots_count = var_42_7.total_slots_count

		for j = 1, total_slots_count do
			local var_42_10 = slots[j]
			local count_2 = #var_42_10.queue
			local num = 0

			if arg_42_3 or not flag or not fn_21(var_42_10, local_position, unbox) then
				num = 100
			end

			local var_42_13, var_42_14 = fn_19(var_42_10, arg_42_5, 0, arg_42_6)

			if not var_42_13 then
				-- Nothing
			else
				local num_2 = distance_squared(var_42_13, local_position) + count_2 * count_2 * num_19 + var_42_14 + num

				if num_2 < huge then
					huge = num_2
					var_42_6 = var_42_10
				end
			end
		end
	end

	return var_42_6
end

AIPlayerSlotExtension._update_slot = function (self, arg_43_1, arg_43_2, arg_43_3, arg_43_4)
	-- function 43
	fn_11(arg_43_1)

	local local_position = Unit.local_position(arg_43_2, 0)
	local unbox = self.position:unbox()

	if not fn_21(arg_43_1, local_position, unbox) then
		fn_24(local_position, unbox, arg_43_1, arg_43_3, arg_43_4)
	else
		fn_23(arg_43_1)
	end
end

AIPlayerSlotExtension._assign_slot = function (self, arg_44_1, arg_44_2)
	-- function 44
	if arg_44_1.ai_unit_slot_extension == arg_44_2 then
		return
	end

	local ai_unit_slot_extension = arg_44_1.ai_unit_slot_extension

	if not ai_unit_slot_extension then
		ai_unit_slot_extension:on_slot_lost()
	end

	arg_44_1.ai_unit = arg_44_2.unit
	arg_44_1.ai_unit_slot_extension = arg_44_2

	arg_44_2:on_slot_gained(self, arg_44_1)

	local all_slots = self.all_slots
	local var_44_2 = all_slots[arg_44_1.type]

	var_44_2.slots_count = fn_20(var_44_2)

	fn_14(all_slots)
end

AIPlayerSlotExtension.request_best_slot = function (self, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6)
	-- function 45
	local flag = false
	local get_preferred_slot_type = arg_45_1:get_preferred_slot_type()
	local unit = arg_45_1.unit
	local _get_best_slot = self:_get_best_slot(unit, get_preferred_slot_type, arg_45_2, arg_45_3)

	if not _get_best_slot then
		self:_assign_slot(_get_best_slot, arg_45_1)
		self:_update_slot(_get_best_slot, unit, arg_45_4, arg_45_5)
	else
		local get_current_slot, var_45_5 = arg_45_1:get_current_slot()
		local local_position = Unit.local_position(unit, 0)
		local unbox = self.position:unbox()
		local flag_2 = (not not var_45_5 or not get_current_slot) and get_current_slot.owner_extension == self
		local flag_3 = not get_current_slot and fn_21(get_current_slot, local_position, unbox)

		if not flag_2 and not arg_45_2 and not flag_3 then
			print("[AIPlayerSlotExtension] force releaseing slot", arg_45_1._debug_id, get_current_slot.index)
			self:free_slot(arg_45_1, get_current_slot, false)

			local extension_input = ScriptUnit.extension_input(unit, "dialogue_system")
			local alloc_table = FrameTable.alloc_table()

			extension_input:trigger_networked_dialogue_event("flanking", alloc_table)
		elseif not var_45_5 then
			_get_best_slot = self:_get_best_slot_to_wait_on(unit, get_preferred_slot_type, arg_45_2, arg_45_3, arg_45_4, arg_45_6)
			flag = true

			if not _get_best_slot then
				if _get_best_slot == get_current_slot then
					self:free_slot(arg_45_1, get_current_slot, false)
				else
					local queue = _get_best_slot.queue

					queue[#queue + 1] = arg_45_1

					arg_45_1:on_entered_slot_queue(self, _get_best_slot)
				end
			end
		elseif not flag_3 then
			local var_45_13 = self.all_slots[get_preferred_slot_type]

			if not arg_45_3 and fn_22(var_45_13) or not arg_45_2 then
				self:free_slot(arg_45_1, get_current_slot, true)
			end
		end
	end

	return _get_best_slot, flag
end

AIPlayerSlotExtension.get_destination = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4, arg_46_5)
	-- function 46
	local var_46_0

	if not arg_46_3 then
		if arg_46_2.ghost_position.x ~= 0 then
			var_46_0 = arg_46_2.ghost_position:unbox()
		else
			var_46_0 = arg_46_2.absolute_position:unbox()

			if not script_data.ai_debug_slots then
				QuickDrawer:sphere(var_46_0, 0.3, Color(255, 255, 255))
			end
		end
	else
		local unit = arg_46_1.unit
		local local_position = Unit.local_position(unit, 0)
		local flag

		flag = arg_46_2.queue[1] ~= arg_46_1 or not -0.5 or 0.5

		local var_46_4 = fn_19(arg_46_2, arg_46_4, flag, arg_46_5)
		local var_46_5 = num_16
		local var_46_6 = num_17
		local var_46_7 = num_18
		local num = 0
		local var_46_9 = num_28
		local num_2 = 2
		local new_random_goal_uniformly_distributed_with_inside_from_outside_on_last = LocomotionUtils.new_random_goal_uniformly_distributed_with_inside_from_outside_on_last
		local var_46_12

		if not var_46_4 then
			var_46_12 = new_random_goal_uniformly_distributed_with_inside_from_outside_on_last(arg_46_4, nil, var_46_4, num, var_46_9, num_2, nil, var_46_5, var_46_6, var_46_7)

			if not var_46_12 then
				-- Nothing
			end
		end

		var_46_12 = nil

		do
			local abs
		end

		::label_46_0::

		if not var_46_12 then
			abs = math.abs(local_position.z - var_46_12.z)

			if not abs then
				-- Nothing
			end
		end

		abs = 0

		::label_46_1::

		local flag_2 = abs > num_9
		local var_46_15

		if not var_46_12 then
			var_46_15 = distance(var_46_12, local_position)

			if not var_46_15 then
				-- Nothing
			end
		end

		var_46_15 = math.huge

		::label_46_2::

		local flag_3 = var_46_15 < 5

		var_46_0 = var_46_12

		if not flag_2 and not flag_3 then
			var_46_0 = nil
		end
	end

	return var_46_0
end

AIPlayerSlotExtension.free_slot = function (self, arg_47_1, arg_47_2, arg_47_3)
	-- function 47
	arg_47_1:on_slot_lost()

	if not arg_47_3 then
		local queue = arg_47_2.queue
		local count = #queue

		for i = count, 1, -1 do
			if queue[i] == arg_47_1 then
				queue[i] = queue[count]
				queue[count] = nil

				break
			end
		end
	else
		fassert(arg_47_2.target_unit == self.unit, "this slot is does not belog here")
		fassert(arg_47_2.ai_unit_slot_extension == arg_47_1, "wrong unit tried to leave slot %d, current slot owner id %d, but freed by %d", arg_47_2.index, arg_47_2.ai_unit_slot_extension._debug_id, arg_47_1._debug_id)

		local queue_2 = arg_47_2.queue
		local count_2 = #queue_2

		if count_2 > 0 then
			local var_47_4 = queue_2[count_2]
			local unit = var_47_4.unit

			if var_47_4:get_preferred_slot_type() == arg_47_2.type then
				arg_47_2.ai_unit = unit
				arg_47_2.ai_unit_slot_extension = var_47_4
				queue_2[count_2] = nil

				var_47_4:on_slot_lost()
				var_47_4:on_slot_gained(self, arg_47_2)
			else
				print("[AIPlayerSlotExtension] dispersing queue due to wrong slot type preference got -> expected", arg_47_2.index, arg_47_2.type, var_47_4:get_preferred_slot_type())

				for j = #queue_2, 1, -1 do
					queue_2[j]:on_slot_lost()

					queue_2[j] = nil
				end

				arg_47_2.ai_unit = nil
				arg_47_2.ai_unit_slot_extension = nil
			end
		else
			arg_47_2.ai_unit = nil
			arg_47_2.ai_unit_slot_extension = nil
		end
	end

	local type = arg_47_2.type
	local var_47_7 = self.all_slots[type]

	var_47_7.slots_count = fn_20(var_47_7)
end
