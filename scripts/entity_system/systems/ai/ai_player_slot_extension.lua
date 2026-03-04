-- chunkname: @scripts/entity_system/systems/ai/ai_player_slot_extension.lua

AIPlayerSlotExtension = class(AIPlayerSlotExtension)

local var_0_0 = require("scripts/entity_system/systems/ai/ai_slot_utils")
local var_0_1 = Vector3.distance
local var_0_2 = Vector3.distance_squared
local var_0_3 = Vector3.length
local var_0_4 = Vector3.length_squared
local var_0_5 = Vector3.normalize
local var_0_6 = Vector3.dot
local var_0_7 = Vector3.flat
local var_0_8 = GwNavQueries.triangle_from_position
local var_0_9 = GwNavQueries.raycango
local var_0_10 = 0.5
local var_0_11 = {
	CHECK_LEFT = 0,
	CHECK_RIGHT = 2,
	CHECK_MIDDLE = 1
}
local var_0_12 = table.size(var_0_11)
local var_0_13 = {
	[var_0_11.CHECK_LEFT] = math.degrees_to_radians(-90),
	[var_0_11.CHECK_RIGHT] = math.degrees_to_radians(90)
}
local var_0_14 = 0.5
local var_0_15 = var_0_14 + 0.6
local var_0_16 = 7.5
local var_0_17 = 4
local var_0_18 = 0.5
local var_0_19 = 0.25
local var_0_20 = 1
local var_0_21 = 1.5
local var_0_22 = 1.5
local var_0_23 = 2
local var_0_24 = 0.5
local var_0_25 = 0.25
local var_0_26 = 9
local var_0_27 = 5
local var_0_28 = 1.5
local var_0_29 = 2
local var_0_30 = 3
local var_0_31 = 3
local var_0_32 = {
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
local var_0_33 = {}
local var_0_34 = SlotTypeSettings

for iter_0_0, iter_0_1 in pairs(var_0_34) do
	var_0_33[#var_0_33 + 1] = iter_0_0
end

local var_0_35 = #var_0_33

AIPlayerSlotExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.unit = arg_1_2
	arg_1_0.all_slots = {}

	for iter_1_0, iter_1_1 in pairs(var_0_34) do
		local var_1_0 = iter_1_0 == "normal" and "ai_slots_count" or "ai_slots_count_" .. iter_1_0
		local var_1_1 = Unit.get_data(arg_1_2, var_1_0) or iter_1_1.count
		local var_1_2 = {
			total_slots_count = var_1_1,
			slot_radians = math.degrees_to_radians(360 / var_1_1)
		}

		var_1_2.slots_count = 0
		var_1_2.use_wait_slots = iter_1_1.use_wait_slots
		var_1_2.priority = iter_1_1.priority
		var_1_2.disabled_slots_count = 0
		var_1_2.slots = {}
		arg_1_0.all_slots[iter_1_0] = var_1_2
	end

	local var_1_3 = arg_1_3.profile_index or var_0_26

	arg_1_0.dogpile = 0
	arg_1_0.position = Vector3Box(POSITION_LOOKUP[arg_1_2])
	arg_1_0.moved_at = 0
	arg_1_0.next_slot_status_update_at = 0
	arg_1_0.valid_target = true
	arg_1_0.debug_color_name = var_0_32[var_1_3][1]
	arg_1_0.num_occupied_slots = 0
	arg_1_0.has_slots_attached = true
	arg_1_0.delayed_num_occupied_slots = 0
	arg_1_0.delayed_slot_decay_t = 0
	arg_1_0.full_slots_at_t = {}

	arg_1_0:_create_target_slots(arg_1_2, var_1_3)

	arg_1_0._is_server = arg_1_1.is_server
	arg_1_0._network_transmit = arg_1_1.network_transmit
	arg_1_0._audio_system = Managers.state.entity:system("audio_system")
	arg_1_0._audio_parameter_id = NetworkLookup.global_parameter_names.occupied_slots_percentage

	local var_1_4 = Managers.player:unit_owner(arg_1_2)

	arg_1_0:_update_assigned_player(var_1_4, arg_1_2)

	arg_1_0.belongs_to_player = true
end

AIPlayerSlotExtension._create_target_slots = function (arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_0.all_slots

	for iter_2_0, iter_2_1 in pairs(var_2_0) do
		local var_2_1 = iter_2_1.total_slots_count
		local var_2_2 = iter_2_1.slots

		for iter_2_2 = 1, var_2_1 do
			local var_2_3 = {
				target_unit = arg_2_1,
				owner_extension = arg_2_0,
				queue = {},
				original_absolute_position = Vector3Box(0, 0, 0),
				absolute_position = Vector3Box(0, 0, 0),
				ghost_position = Vector3Box(0, 0, 0),
				queue_direction = Vector3Box(0, 0, 0),
				position_right = Vector3Box(0, 0, 0),
				position_left = Vector3Box(0, 0, 0),
				index = iter_2_2
			}

			var_2_3.anchor_weight = 0
			var_2_3.type = iter_2_0
			var_2_3.radians = math.degrees_to_radians(360 / var_2_1)
			var_2_3.priority = iter_2_1.priority
			var_2_3.position_check_index = var_0_11.CHECK_MIDDLE
			var_2_3.debug_color_name = var_0_34[iter_2_0].debug_color
			var_2_2[iter_2_2] = var_2_3
		end
	end
end

AIPlayerSlotExtension._update_assigned_player = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	if arg_3_0.unit ~= arg_3_2 then
		return
	end

	if arg_3_1 then
		arg_3_0._is_server_player = arg_3_0._is_server and arg_3_1:is_player_controlled()
		arg_3_0._is_local_player = arg_3_1.local_player
		arg_3_0._peer_id = arg_3_1:network_id()

		if arg_3_0._waiting_for_player then
			Managers.state.event:unregister("new_player_unit", arg_3_0)

			arg_3_0._waiting_for_player = nil
		end
	elseif not arg_3_0._waiting_for_player then
		Managers.state.event:register(arg_3_0, "new_player_unit", "_update_assigned_player")

		arg_3_0._waiting_for_player = true
	end
end

AIPlayerSlotExtension.extensions_ready = function (arg_4_0, arg_4_1, arg_4_2)
	arg_4_0._status_ext = ScriptUnit.has_extension(arg_4_2, "status_system")
	arg_4_0._locomotion_ext = ScriptUnit.has_extension(arg_4_2, "locomotion_system")
end

local function var_0_36(arg_5_0)
	if arg_5_0.ai_unit then
		local var_5_0 = arg_5_0.ai_unit_slot_extension

		if var_5_0 then
			var_5_0.slot = nil
		end
	end

	local var_5_1 = arg_5_0.queue
	local var_5_2 = #var_5_1

	for iter_5_0 = 1, var_5_2 do
		local var_5_3 = var_5_1[iter_5_0]

		if var_5_3 then
			var_5_3:on_slot_lost()
		end
	end

	local var_5_4 = arg_5_0.owner_extension

	if var_5_4 then
		local var_5_5 = var_5_4.all_slots

		for iter_5_1, iter_5_2 in pairs(var_5_5) do
			local var_5_6 = iter_5_2.slots
			local var_5_7 = #var_5_6

			for iter_5_3 = 1, var_5_7 do
				if var_5_6[iter_5_3] == arg_5_0 then
					var_5_6[iter_5_3] = var_5_6[var_5_7]
					var_5_6[iter_5_3].index = iter_5_3
					var_5_6[var_5_7] = nil

					break
				end
			end
		end
	end
end

AIPlayerSlotExtension.cleanup_extension = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	if arg_6_0.slots then
		local var_6_0 = arg_6_0.slots

		for iter_6_0 = #var_6_0, 1, -1 do
			local var_6_1 = var_6_0[iter_6_0]

			var_0_36(var_6_1)
		end
	end

	for iter_6_1 = 1, arg_6_3 do
		local var_6_2 = arg_6_4[arg_6_2[iter_6_1]]

		if var_6_2.target == arg_6_1 then
			var_6_2.target = nil
		end
	end

	if arg_6_0._waiting_for_player then
		Managers.state.event:unregister("new_player_unit", arg_6_0)

		arg_6_0._waiting_for_player = nil
	end
end

AIPlayerSlotExtension.update_total_slots_count = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.all_slots
	local var_7_1 = 0
	local var_7_2 = 0

	for iter_7_0 = 1, var_0_35 do
		local var_7_3 = var_7_0[var_0_33[iter_7_0]]

		var_7_1 = var_7_1 + var_7_3.slots_count

		local var_7_4 = var_7_3.slots
		local var_7_5 = var_7_3.total_slots_count

		for iter_7_1 = 1, var_7_5 do
			local var_7_6 = var_7_4[iter_7_1]

			if not var_7_6.released and var_7_6.ai_unit then
				var_7_2 = var_7_2 + 1
			end
		end
	end

	if var_7_2 >= arg_7_0.delayed_num_occupied_slots then
		arg_7_0.delayed_num_occupied_slots = var_7_2
		arg_7_0.delayed_slot_decay_t = arg_7_1 + var_0_27
	elseif arg_7_1 >= arg_7_0.delayed_slot_decay_t then
		arg_7_0.delayed_num_occupied_slots = var_7_2
	end

	arg_7_0.num_occupied_slots = var_7_2

	return var_7_1, var_7_2
end

AIPlayerSlotExtension.update_disabled_slots_count = function (arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.all_slots

	for iter_8_0 = 1, var_0_35 do
		local var_8_1 = var_8_0[var_0_33[iter_8_0]]
		local var_8_2 = var_8_1.slots
		local var_8_3 = #var_8_2
		local var_8_4 = 0

		for iter_8_1 = 1, var_8_3 do
			if var_8_2[iter_8_1].disabled then
				var_8_4 = var_8_4 + 1
			end
		end

		var_8_1.disabled_slots_count = var_8_4
	end
end

AIPlayerSlotExtension.update_slot_sound = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0.unit
	local var_9_1 = arg_9_0.all_slots
	local var_9_2 = arg_9_0._is_server_player
	local var_9_3 = 0

	for iter_9_0 = 1, var_0_35 do
		local var_9_4 = var_0_33[iter_9_0]
		local var_9_5 = var_9_1[var_9_4]
		local var_9_6 = var_0_34[var_9_4].dialogue_surrounded_count
		local var_9_7 = var_9_5.slots_count

		if var_9_2 then
			local var_9_8 = var_9_5.disabled_slots_count
			local var_9_9 = var_9_5.total_slots_count - var_9_8
			local var_9_10 = var_9_9 > 0 and var_9_7 / var_9_9 or 0
			local var_9_11 = math.clamp(var_9_10, 0, 1)

			if var_9_3 < var_9_11 then
				var_9_3 = var_9_11
			end
		end

		if var_9_6 <= var_9_7 and ScriptUnit.has_extension(var_9_0, "dialogue_system") then
			local var_9_12 = ScriptUnit.extension_input(var_9_0, "dialogue_system")
			local var_9_13 = FrameTable.alloc_table()

			var_9_13.current_amount = var_9_7
			var_9_13.has_shield = Managers.state.entity:system("dialogue_system"):player_shield_check(var_9_0)

			var_9_12:trigger_networked_dialogue_event("surrounded", var_9_13)
		end
	end

	if var_9_2 then
		if arg_9_0._is_local_player then
			arg_9_0._audio_system:set_global_parameter_with_lerp("occupied_slots_percentage", var_9_3 * 100)
		else
			arg_9_0._network_transmit:send_rpc("rpc_client_audio_set_global_parameter_with_lerp", arg_9_0._peer_id, arg_9_0._audio_parameter_id, var_9_3)
		end
	end
end

local function var_0_37(arg_10_0)
	local var_10_0 = arg_10_0.slots
	local var_10_1 = arg_10_0.total_slots_count
	local var_10_2 = var_10_0[1]
	local var_10_3 = var_10_2.anchor_weight

	for iter_10_0 = 1, var_10_1 do
		repeat
			local var_10_4 = var_10_0[iter_10_0]

			if var_10_4.disabled then
				break
			end

			local var_10_5 = var_10_4.anchor_weight

			if var_10_3 < var_10_5 or var_10_5 == var_10_3 and var_10_4.index < var_10_2.index then
				var_10_2 = var_10_4
				var_10_3 = var_10_5
			end
		until true
	end

	return var_10_2
end

local var_0_38 = Quaternion.rotate

local function var_0_39(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = var_0_5(var_0_7(arg_11_1 - arg_11_0))
	local var_11_1 = Quaternion(-Vector3.up(), arg_11_2)

	return arg_11_0 + var_0_38(var_11_1, var_11_0) * arg_11_3
end

local function var_0_40(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0.original_absolute_position:unbox()
	local var_12_1 = arg_12_0.type
	local var_12_2 = var_0_34[var_12_1].distance
	local var_12_3 = arg_12_0.radians
	local var_12_4 = var_0_39(arg_12_1, var_12_0, var_12_3, var_12_2)
	local var_12_5 = var_0_39(arg_12_1, var_12_0, -var_12_3, var_12_2)

	arg_12_0.position_right:store(var_12_4)
	arg_12_0.position_left:store(var_12_5)
end

local function var_0_41(arg_13_0)
	arg_13_0.disabled = false
end

local function var_0_42(arg_14_0)
	local var_14_0 = arg_14_0.ai_unit_slot_extension

	if var_14_0 then
		var_14_0:on_slot_lost()
	end

	arg_14_0.ai_unit = nil
	arg_14_0.ai_unit_slot_extension = nil

	local var_14_1 = arg_14_0.queue

	for iter_14_0 = 1, #var_14_1 do
		var_14_1[iter_14_0]:on_slot_lost()
	end

	table.clear(arg_14_0.queue)

	arg_14_0.disabled = true
	arg_14_0.released = false
end

local function var_0_43(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0.owner_extension
	local var_15_1 = arg_15_0.absolute_position:unbox()
	local var_15_2 = #arg_15_1

	for iter_15_0 = 1, var_15_2 do
		repeat
			local var_15_3 = arg_15_1[iter_15_0]

			if var_15_3 == var_15_0 then
				break
			end

			local var_15_4 = var_15_3.all_slots

			for iter_15_1 = 1, var_0_35 do
				local var_15_5 = var_0_33[iter_15_1]
				local var_15_6 = var_15_4[var_15_5]
				local var_15_7 = var_0_34[var_15_5].radius
				local var_15_8 = var_15_7 * var_15_7
				local var_15_9 = var_15_6.slots
				local var_15_10 = var_15_6.total_slots_count

				for iter_15_2 = 1, var_15_10 do
					repeat
						local var_15_11 = var_15_9[iter_15_2]

						if var_15_11.disabled then
							break
						end

						local var_15_12 = var_15_11.absolute_position:unbox()

						if var_15_8 > var_0_2(var_15_1, var_15_12) then
							return var_15_11
						end
					until true
				end
			end
		until true
	end

	return false
end

local var_0_44 = 1.2
local var_0_45 = var_0_44 * var_0_44

local function var_0_46(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0.owner_extension
	local var_16_1 = arg_16_0.absolute_position:unbox()
	local var_16_2 = #arg_16_1
	local var_16_3 = var_0_2

	for iter_16_0 = 1, var_16_2 do
		repeat
			local var_16_4 = arg_16_1[iter_16_0]

			if var_16_4 == var_16_0 then
				break
			end

			local var_16_5 = var_16_4.position:unbox()

			if var_16_3(var_16_1, var_16_5) < var_0_45 then
				return true
			end
		until true
	end

	return false
end

local function var_0_47(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0.priority
	local var_17_1 = arg_17_1.priority
	local var_17_2 = arg_17_0.owner_extension.index
	local var_17_3 = arg_17_0.index
	local var_17_4 = arg_17_1.owner_extension.index
	local var_17_5 = arg_17_1.index

	if var_17_0 < var_17_1 and not arg_17_0.ai_unit then
		return
	elseif var_17_1 < var_17_0 and not arg_17_1.ai_unit then
		return
	end

	if var_17_0 < var_17_1 then
		var_0_42(arg_17_1)

		return false
	elseif var_17_1 < var_17_0 then
		var_0_42(arg_17_0)

		return true
	end

	if var_17_5 < var_17_3 then
		var_0_42(arg_17_0)

		return true
	end

	if var_17_3 < var_17_5 then
		var_0_42(arg_17_1)

		return false
	end

	if var_17_4 < var_17_2 then
		var_0_42(arg_17_0)

		return true
	else
		var_0_42(arg_17_1)

		return false
	end
end

local function var_0_48(arg_18_0)
	local var_18_0 = arg_18_0.absolute_position:unbox()
	local var_18_1 = arg_18_0.type
	local var_18_2 = arg_18_0.owner_extension.all_slots
	local var_18_3 = var_0_2

	for iter_18_0 = 1, var_0_35 do
		repeat
			local var_18_4 = var_0_33[iter_18_0]
			local var_18_5 = var_18_2[var_18_4]

			if var_18_1 == var_18_4 then
				break
			end

			local var_18_6 = var_0_34[var_18_4].radius
			local var_18_7 = var_18_6 * var_18_6
			local var_18_8 = var_18_5.slots
			local var_18_9 = var_18_5.total_slots_count

			for iter_18_1 = 1, var_18_9 do
				repeat
					local var_18_10 = var_18_8[iter_18_1]

					if var_18_10.disabled then
						break
					end

					if not var_18_10.ai_unit then
						break
					end

					local var_18_11 = var_18_10.absolute_position:unbox()

					if var_18_7 > var_18_3(var_18_0, var_18_11) then
						return var_18_10
					end
				until true
			end
		until true
	end

	return false
end

local var_0_49 = 3
local var_0_50 = var_0_49 * var_0_49

local function var_0_51(arg_19_0)
	if arg_19_0.disabled then
		return
	end

	local var_19_0 = arg_19_0.ai_unit

	if not var_19_0 then
		arg_19_0.released = false

		return
	end

	if not arg_19_0.ai_unit_slot_extension.release_slot_lock then
		local var_19_1 = Unit.local_position(var_19_0, 0)

		if var_19_1 then
			local var_19_2 = arg_19_0.absolute_position:unbox()

			arg_19_0.released = var_0_2(var_19_1, var_19_2) > var_0_50
		else
			arg_19_0.released = true
		end
	else
		arg_19_0.released = false
	end
end

local function var_0_52(arg_20_0, arg_20_1, arg_20_2)
	if arg_20_1 then
		var_0_41(arg_20_0)
	else
		var_0_42(arg_20_0)

		return false
	end

	if not var_0_46(arg_20_0, arg_20_2) then
		var_0_41(arg_20_0)
	else
		var_0_42(arg_20_0)

		return false
	end

	local var_20_0 = var_0_43(arg_20_0, arg_20_2)

	if var_20_0 then
		if not var_0_47(arg_20_0, var_20_0) then
			var_0_41(arg_20_0)
		else
			return false
		end
	end

	local var_20_1 = var_0_48(arg_20_0)

	if var_20_1 then
		if not var_0_47(arg_20_0, var_20_1) then
			var_0_41(arg_20_0)
		else
			return false
		end
	end

	var_0_51(arg_20_0)

	return true
end

local function var_0_53(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_1.slots
	local var_21_1 = arg_21_0.index
	local var_21_2 = arg_21_1.total_slots_count
	local var_21_3 = 128

	arg_21_0.anchor_weight = arg_21_0.ai_unit and not arg_21_0.released and 256 or 0

	for iter_21_0 = 1, var_21_2 do
		local var_21_4 = var_21_1 + iter_21_0

		if var_21_2 < var_21_4 then
			var_21_4 = var_21_4 - var_21_2
		end

		local var_21_5 = var_21_0[var_21_4]
		local var_21_6 = var_21_5.disabled
		local var_21_7 = var_21_5.released
		local var_21_8 = var_21_5.ai_unit

		if var_21_6 or not var_21_8 then
			break
		end

		if not var_21_7 then
			arg_21_0.anchor_weight = arg_21_0.anchor_weight + var_21_3
			var_21_3 = var_21_3 / 2
		end
	end

	local var_21_9 = 128

	for iter_21_1 = 1, var_21_2 do
		local var_21_10 = var_21_1 - iter_21_1

		if var_21_10 < 1 then
			var_21_10 = var_21_10 + var_21_2
		end

		local var_21_11 = var_21_0[var_21_10]
		local var_21_12 = var_21_11.disabled
		local var_21_13 = var_21_11.released
		local var_21_14 = var_21_11.ai_unit

		if var_21_12 or not var_21_14 then
			break
		end

		if not var_21_13 then
			arg_21_0.anchor_weight = arg_21_0.anchor_weight + var_21_9
			var_21_9 = var_21_9 / 2
		end
	end
end

local function var_0_54(arg_22_0)
	for iter_22_0 = 1, var_0_35 do
		local var_22_0 = arg_22_0[var_0_33[iter_22_0]]
		local var_22_1 = var_22_0.slots
		local var_22_2 = var_22_0.total_slots_count

		for iter_22_1 = 1, var_22_2 do
			local var_22_3 = var_22_1[iter_22_1]

			var_0_53(var_22_3, var_22_0)
		end
	end
end

local function var_0_55(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6)
	local var_23_0
	local var_23_1 = 10
	local var_23_2 = 0.15

	if arg_23_2 then
		local var_23_3 = Quaternion(-Vector3.up(), arg_23_2)

		arg_23_1 = var_0_38(var_23_3, arg_23_1)
	end

	for iter_23_0 = 0, var_23_1 - 1 do
		local var_23_4 = arg_23_0 + arg_23_1 * (iter_23_0 * var_23_2 + arg_23_3)

		var_23_0 = var_0_0.clamp_position_on_navmesh(var_23_4, arg_23_4, arg_23_5, arg_23_6)

		if var_23_0 then
			break
		end
	end

	return var_23_0, var_23_0
end

local function var_0_56(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0

	if arg_24_0 then
		var_24_0 = arg_24_0:current_velocity()
	else
		var_24_0 = Vector3(0, 0, 0)
	end

	if var_0_3(var_24_0) > 0.1 then
		local var_24_1 = var_0_3(var_24_0)
		local var_24_2 = var_0_5(var_24_0)
		local var_24_3 = var_24_2 * var_24_1
		local var_24_4 = var_0_5(arg_24_2 - arg_24_1)
		local var_24_5 = var_0_6(var_24_4, var_24_2)

		return arg_24_1 + var_24_3 * math.max(2 * (var_24_5 - 0.5), 0)
	else
		return arg_24_1
	end
end

local function var_0_57(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6, arg_25_7, arg_25_8)
	local var_25_0 = arg_25_3 and var_0_39(arg_25_1, arg_25_2, arg_25_3, arg_25_4) or arg_25_2
	local var_25_1 = arg_25_5 and var_0_56(arg_25_0, var_25_0, arg_25_1) or var_25_0

	return var_0_0.clamp_position_on_navmesh(var_25_1, arg_25_6, arg_25_7, arg_25_8), var_25_0
end

local function var_0_58(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6, arg_26_7, arg_26_8, arg_26_9, arg_26_10)
	local var_26_0, var_26_1 = var_0_57(arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6, arg_26_7, arg_26_9, arg_26_10)
	local var_26_2 = arg_26_0.position_check_index
	local var_26_3 = var_26_2 == var_0_11.CHECK_MIDDLE
	local var_26_4 = not var_26_3 and var_0_13[var_26_2] or nil
	local var_26_5 = var_0_15

	if var_26_0 then
		local var_26_6

		if var_26_3 then
			var_26_6 = var_26_0
		else
			var_26_6 = var_0_39(var_26_0, arg_26_2, var_26_4, var_0_10)
		end

		local var_26_7 = arg_26_2 + var_0_5(var_26_6 - arg_26_2) * var_26_5

		if not var_0_9(arg_26_7, var_26_6, var_26_7, arg_26_8) then
			var_26_0 = nil
		end
	elseif not var_26_3 then
		local var_26_8 = var_0_39(arg_26_3, arg_26_2, var_26_4, var_0_10)

		var_26_0, var_26_1 = var_0_57(arg_26_1, arg_26_2, var_26_8, arg_26_4, arg_26_5, arg_26_6, arg_26_7, arg_26_9, arg_26_10)

		if var_26_0 then
			local var_26_9 = arg_26_2 + var_0_5(var_26_0 - arg_26_2) * var_26_5

			if var_0_9(arg_26_7, var_26_0, var_26_9, arg_26_8) then
				arg_26_0.position_check_index = var_0_11.CHECK_MIDDLE
			else
				var_26_0 = nil
			end
		end
	end

	if not var_26_0 then
		arg_26_0.position_check_index = (arg_26_0.position_check_index + 1) % var_0_12
	end

	return var_26_0, var_26_1
end

AIPlayerSlotExtension.update_target_slots = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	local var_27_0
	local var_27_1
	local var_27_2
	local var_27_3
	local var_27_4 = arg_27_0.was_on_ladder
	local var_27_5 = arg_27_0._status_ext

	if var_27_5 then
		var_27_0, var_27_1 = var_27_5:get_is_on_ladder()

		if var_27_0 then
			local var_27_6
			local var_27_7

			var_27_2, var_27_3, var_27_7 = Managers.state.bot_nav_transition:get_ladder_coordinates(var_27_1)
			var_27_0 = not var_27_7
		end

		arg_27_0.was_on_ladder = var_27_0
	end

	local var_27_8 = arg_27_0.unit
	local var_27_9 = Unit.local_position(var_27_8, 0)
	local var_27_10 = var_27_0 and var_27_9 or var_0_0.get_target_pos_on_navmesh(var_27_9, arg_27_3)
	local var_27_11 = arg_27_0.position:unbox()
	local var_27_12 = arg_27_0.outside_navmesh_at_t
	local var_27_13 = false
	local var_27_14 = 0

	if var_27_10 then
		var_27_14 = var_0_2(var_27_10, var_27_11)
		arg_27_0.outside_navmesh_at_t = nil
	elseif var_27_12 == nil or arg_27_1 < var_27_12 + var_0_23 then
		if var_27_12 == nil then
			arg_27_0.outside_navmesh_at_t = arg_27_1
		end

		var_27_10 = var_27_11
	else
		var_27_13 = true
		var_27_10 = var_27_9
		var_27_14 = var_0_2(var_27_10, var_27_11)
	end

	if var_27_14 > var_0_18 or var_27_0 ~= var_27_4 or var_27_0 and arg_27_1 > arg_27_0.next_slot_status_update_at then
		local var_27_15 = true

		arg_27_0.position:store(var_27_10)
		arg_27_0:_update_target_slots_positions(arg_27_2, var_27_15, arg_27_3, arg_27_4, var_27_0, var_27_1, var_27_2, var_27_3, var_27_13)

		arg_27_0.moved_at = arg_27_1
		arg_27_0.next_slot_status_update_at = arg_27_1 + var_0_24

		return true
	end

	local var_27_16 = arg_27_0.moved_at
	local var_27_17 = arg_27_0._locomotion_ext
	local var_27_18 = var_27_17 and var_0_4(var_27_17:current_velocity()) or 0

	if not var_27_0 and var_27_16 and arg_27_1 - var_27_16 > var_0_19 and (var_27_18 <= var_0_25 or arg_27_1 - var_27_16 > var_0_20) then
		local var_27_19 = false

		arg_27_0:_update_target_slots_positions(arg_27_2, var_27_19, arg_27_3, arg_27_4, var_27_0, var_27_1, var_27_2, var_27_3, var_27_13)

		arg_27_0.moved_at = nil
		arg_27_0.next_slot_status_update_at = arg_27_1 + var_0_24

		return true
	end

	if arg_27_1 > arg_27_0.next_slot_status_update_at then
		arg_27_0:_update_target_slots_status(arg_27_2, arg_27_3, arg_27_4, var_27_13, arg_27_1)

		arg_27_0.next_slot_status_update_at = arg_27_1 + var_0_24

		return true
	end

	return false
end

AIPlayerSlotExtension._set_slot_absolute_position = function (arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = arg_28_0.position:unbox()
	local var_28_1 = var_0_5(var_0_7(arg_28_2 - var_28_0))

	arg_28_1.absolute_position:store(arg_28_2)
	arg_28_1.queue_direction:store(var_28_1)
	var_0_40(arg_28_1, var_28_0)
end

AIPlayerSlotExtension._update_target_slots_status = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5)
	local var_29_0 = arg_29_0.all_slots

	for iter_29_0 = 1, var_0_35 do
		local var_29_1 = var_0_33[iter_29_0]
		local var_29_2 = var_29_0[var_29_1]
		local var_29_3 = var_29_2.slots
		local var_29_4 = var_29_2.total_slots_count
		local var_29_5 = false

		for iter_29_1 = 1, var_29_4 do
			local var_29_6 = var_29_3[iter_29_1]
			local var_29_7 = var_29_6.absolute_position:unbox()
			local var_29_8 = arg_29_0:_update_slot_position(var_29_6, var_29_7, var_29_5, arg_29_2, arg_29_3, nil, nil, arg_29_4)

			var_0_52(var_29_6, var_29_8, arg_29_1)
		end

		var_0_54(var_29_0)

		local var_29_9 = var_29_2.disabled_slots_count
		local var_29_10 = arg_29_0.num_occupied_slots >= var_29_4 - var_29_9

		if var_29_10 and not arg_29_0.full_slots_at_t[var_29_1] then
			arg_29_0.full_slots_at_t[var_29_1] = arg_29_5
		elseif not var_29_10 then
			arg_29_0.full_slots_at_t[var_29_1] = nil
		end
	end
end

AIPlayerSlotExtension._update_target_slots_positions = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5, arg_30_6, arg_30_7, arg_30_8, arg_30_9)
	if arg_30_5 then
		arg_30_0:_update_target_slots_positions_on_ladder(arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_6, arg_30_7, arg_30_8)

		return
	end

	local var_30_0
	local var_30_1

	if arg_30_9 then
		var_30_0, var_30_1 = var_0_17, var_0_16
	else
		var_30_0, var_30_1 = var_0_21, var_0_22
	end

	local var_30_2 = arg_30_0.all_slots

	for iter_30_0 = 1, var_0_35 do
		local var_30_3 = var_30_2[var_0_33[iter_30_0]]
		local var_30_4 = var_30_3.slots
		local var_30_5 = var_0_37(var_30_3)
		local var_30_6 = var_30_3.total_slots_count
		local var_30_7 = var_30_5.index
		local var_30_8 = arg_30_0:_update_anchor_slot_position(var_30_5, arg_30_2, arg_30_3, arg_30_4, var_30_0, var_30_1, arg_30_9)

		var_0_52(var_30_5, var_30_8, arg_30_1)

		for iter_30_1 = var_30_7 + 1, var_30_6 do
			local var_30_9 = var_30_4[iter_30_1]
			local var_30_10 = var_30_4[iter_30_1 - 1].position_right:unbox()
			local var_30_11 = arg_30_0:_update_slot_position(var_30_9, var_30_10, arg_30_2, arg_30_3, arg_30_4, var_30_0, var_30_1, arg_30_9)

			var_0_52(var_30_9, var_30_11, arg_30_1)
		end

		for iter_30_2 = var_30_7 - 1, 1, -1 do
			local var_30_12 = var_30_4[iter_30_2]
			local var_30_13 = var_30_4[iter_30_2 + 1].position_left:unbox()
			local var_30_14 = arg_30_0:_update_slot_position(var_30_12, var_30_13, arg_30_2, arg_30_3, arg_30_4, var_30_0, var_30_1, arg_30_9)

			var_0_52(var_30_12, var_30_14, arg_30_1)
		end

		var_0_54(var_30_2)
	end

	var_0_54(var_30_2)
end

AIPlayerSlotExtension._update_slot_position = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5, arg_31_6, arg_31_7, arg_31_8)
	local var_31_0 = arg_31_0._locomotion_ext
	local var_31_1 = arg_31_0.position:unbox()
	local var_31_2
	local var_31_3
	local var_31_4 = arg_31_1.type
	local var_31_5 = var_0_34[var_31_4].distance

	if arg_31_8 then
		var_31_2, var_31_3 = var_0_55(var_31_1, var_0_5(arg_31_2 - var_31_1), nil, var_31_5, arg_31_4, arg_31_6, arg_31_7)
	else
		var_31_2, var_31_3 = var_0_58(arg_31_1, var_31_0, var_31_1, arg_31_2, nil, nil, arg_31_3, arg_31_4, arg_31_5, arg_31_6, arg_31_7)
	end

	if var_31_2 then
		arg_31_1.original_absolute_position:store(var_31_3)
		arg_31_0:_set_slot_absolute_position(arg_31_1, var_31_2)

		return true, var_31_2
	else
		arg_31_1.original_absolute_position:store(arg_31_2)
		arg_31_0:_set_slot_absolute_position(arg_31_1, arg_31_2)

		return false, arg_31_2
	end
end

local var_0_59 = 24

AIPlayerSlotExtension._update_anchor_slot_position = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6, arg_32_7)
	local var_32_0 = arg_32_0._locomotion_ext
	local var_32_1 = arg_32_0.position:unbox()
	local var_32_2 = arg_32_1.ai_unit
	local var_32_3 = var_32_2 and Unit.local_position(var_32_2, 0)
	local var_32_4 = var_32_2 and var_0_5(var_32_3 - var_32_1) or Vector3.forward()
	local var_32_5 = arg_32_1.type
	local var_32_6 = var_0_34[var_32_5].distance
	local var_32_7 = var_32_1 + var_32_4 * var_32_6
	local var_32_8
	local var_32_9

	if arg_32_7 then
		var_32_8, var_32_9 = var_0_55(var_32_1, var_32_4, nil, var_32_6, arg_32_3, arg_32_5, arg_32_6)
	else
		var_32_8, var_32_9 = var_0_58(arg_32_1, var_32_0, var_32_1, var_32_7, nil, nil, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6)
	end

	local var_32_10 = 0

	while var_32_10 <= var_0_59 and not var_32_8 do
		local var_32_11 = var_32_10 % 2 > 0 and -1 or 1
		local var_32_12 = math.ceil(var_32_10 / 2) * var_32_11

		if arg_32_7 then
			var_32_8, var_32_9 = var_0_55(var_32_1, var_32_4, var_32_12, var_32_6, arg_32_3, arg_32_5, arg_32_6)
		else
			var_32_8, var_32_9 = var_0_58(arg_32_1, var_32_0, var_32_1, var_32_7, var_32_12, var_32_6, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6)
		end

		var_32_10 = var_32_10 + 1
	end

	if var_32_8 then
		arg_32_1.original_absolute_position:store(var_32_9)
		arg_32_0:_set_slot_absolute_position(arg_32_1, var_32_8)

		return true, var_32_8
	else
		arg_32_1.original_absolute_position:store(var_32_7)
		arg_32_0:_set_slot_absolute_position(arg_32_1, var_32_7)

		return false, var_32_7
	end
end

AIPlayerSlotExtension._update_target_slots_positions_on_ladder = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5, arg_33_6, arg_33_7)
	local var_33_0 = arg_33_0.all_slots

	for iter_33_0, iter_33_1 in pairs(var_33_0) do
		local var_33_1 = iter_33_1.slots
		local var_33_2 = iter_33_1.total_slots_count
		local var_33_3 = 1
		local var_33_4 = var_0_5(var_0_7(Quaternion.forward(Unit.world_rotation(arg_33_5, 0))))
		local var_33_5 = Vector3.cross(var_33_4, Vector3.up())
		local var_33_6 = math.floor(var_33_2 / 2)
		local var_33_7 = math.ceil(var_33_6 / 2)
		local var_33_8 = var_33_1[var_33_7]

		var_33_8.original_absolute_position:store(arg_33_7)
		arg_33_0:_set_slot_absolute_position(var_33_8, arg_33_7)
		var_0_52(var_33_8, true, arg_33_1)

		local var_33_9 = arg_33_7
		local var_33_10 = true

		for iter_33_2 = var_33_7 - 1, 1, -1 do
			local var_33_11 = var_33_1[iter_33_2]
			local var_33_12 = var_33_9 - var_33_5 * var_33_3

			var_33_10 = var_33_10 and var_0_9(arg_33_3, var_33_9, var_33_12, arg_33_4)

			var_33_11.original_absolute_position:store(var_33_12)
			arg_33_0:_set_slot_absolute_position(var_33_11, var_33_12)
			var_0_52(var_33_11, var_33_10, arg_33_1)

			var_33_9 = var_33_12
		end

		local var_33_13 = arg_33_7
		local var_33_14 = true

		for iter_33_3 = var_33_7 + 1, var_33_6 do
			local var_33_15 = var_33_1[iter_33_3]
			local var_33_16 = var_33_13 + var_33_5 * var_33_3

			var_33_14 = var_33_14 and var_0_9(arg_33_3, var_33_13, var_33_16, arg_33_4)

			var_33_15.original_absolute_position:store(var_33_16)
			arg_33_0:_set_slot_absolute_position(var_33_15, var_33_16)
			var_0_52(var_33_15, var_33_14, arg_33_1)
		end

		local var_33_17 = var_33_6 + math.ceil((var_33_2 - var_33_6) / 2)
		local var_33_18 = var_33_1[var_33_17]

		var_33_18.original_absolute_position:store(arg_33_6)
		arg_33_0:_set_slot_absolute_position(var_33_18, arg_33_6)
		var_0_52(var_33_18, true, arg_33_1)

		local var_33_19 = arg_33_6
		local var_33_20 = 1
		local var_33_21 = 1
		local var_33_22 = 1
		local var_33_23 = arg_33_6 + var_33_22 * var_33_4
		local var_33_24 = var_33_17 - 1 - var_33_6
		local var_33_25 = math.pi / 2.5 / var_33_24
		local var_33_26 = 1

		for iter_33_4 = var_33_17 - 1, var_33_6 + 1, -1 do
			local var_33_27 = var_33_1[iter_33_4]
			local var_33_28 = math.pi * 1.5 + var_33_26 * var_33_25
			local var_33_29 = var_33_23 + var_33_22 * (var_33_5 * math.cos(var_33_28) + var_33_4 * math.sin(var_33_28))
			local var_33_30
			local var_33_31, var_33_32 = var_0_8(arg_33_3, var_33_19, var_33_20, var_33_21)

			if var_33_31 then
				var_33_29.z = var_33_32
			end

			var_33_27.original_absolute_position:store(var_33_29)
			arg_33_0:_set_slot_absolute_position(var_33_27, var_33_29)
			var_0_52(var_33_27, var_33_31, arg_33_1)

			var_33_26 = var_33_26 + 1
		end

		local var_33_33 = var_33_2 - var_33_17
		local var_33_34 = math.pi / 2.5 / var_33_33
		local var_33_35 = 1
		local var_33_36 = arg_33_6

		for iter_33_5 = var_33_17 + 1, var_33_2 do
			local var_33_37 = var_33_1[iter_33_5]
			local var_33_38 = math.pi * 1.5 - var_33_35 * var_33_34
			local var_33_39 = var_33_23 + var_33_22 * (var_33_5 * math.cos(var_33_38) + var_33_4 * math.sin(var_33_38))
			local var_33_40
			local var_33_41, var_33_42 = var_0_8(arg_33_3, var_33_36, var_33_20, var_33_21)

			if var_33_41 then
				var_33_39.z = var_33_42
			end

			var_33_37.original_absolute_position:store(var_33_39)
			arg_33_0:_set_slot_absolute_position(var_33_37, var_33_39)
			var_0_52(var_33_37, var_33_41, arg_33_1)

			var_33_35 = var_33_35 + 1
		end

		var_0_54(var_33_0)
	end
end

local var_0_60 = 3
local var_0_61 = 2
local var_0_62 = 3
local var_0_63 = 1.75
local var_0_64 = 100

local function var_0_65(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	local var_34_0 = arg_34_0.target_unit
	local var_34_1 = arg_34_0.ai_unit

	if not HEALTH_ALIVE[var_34_0] or not ALIVE[var_34_1] then
		return
	end

	local var_34_2 = arg_34_0.ai_unit_slot_extension.slot_template
	local var_34_3 = arg_34_0.type
	local var_34_4 = var_0_34[var_34_3].distance
	local var_34_5 = arg_34_0.owner_extension
	local var_34_6 = var_34_5.full_slots_at_t[var_34_3]
	local var_34_7 = var_34_2.min_wait_queue_distance or var_0_60
	local var_34_8 = var_34_7 * var_34_7
	local var_34_9 = 0

	if var_34_6 and var_34_2.min_queue_offset_distance then
		local var_34_10 = var_34_2.min_queue_offset_distance
		local var_34_11 = var_34_2.full_offset_time
		local var_34_12 = arg_34_3 - var_34_6

		var_34_9 = var_34_10 * math.min(var_34_12 / var_34_11, 1)
	end

	local var_34_13 = var_34_5.position:unbox()
	local var_34_14 = Unit.local_position(var_34_1, 0)
	local var_34_15 = arg_34_0.queue_direction:unbox()
	local var_34_16 = arg_34_2 or 0
	local var_34_17 = var_0_1(var_34_13, var_34_14)
	local var_34_18 = var_0_34[var_34_3].queue_distance
	local var_34_19 = var_34_13 + var_34_15 * math.max(var_34_17 + var_34_18 + var_34_16 - var_34_9, var_34_7)
	local var_34_20 = var_0_0.clamp_position_on_navmesh(var_34_19, arg_34_1, var_0_61, var_0_62)
	local var_34_21 = 5
	local var_34_22 = 1

	while not var_34_20 and var_34_22 <= var_34_21 do
		local var_34_23 = math.max(math.max(var_34_17 * (1 - var_34_22 / var_34_21), var_34_4) + var_34_18 + var_34_16 - var_34_9, var_34_7)
		local var_34_24 = var_34_13 + var_34_15 * math.max(var_34_23, 0.5)

		var_34_20 = var_0_0.clamp_position_on_navmesh(var_34_24, arg_34_1, var_0_61, var_0_62)
		var_34_22 = var_34_22 + 1
	end

	local var_34_25 = 0
	local var_34_26

	if var_34_20 then
		local var_34_27 = var_0_0.clamp_position_on_navmesh(var_34_13, arg_34_1, var_0_61, var_0_62)

		if var_34_27 then
			var_34_26 = var_0_9(arg_34_1, var_34_20, var_34_27)
		end
	end

	if not var_34_20 or not var_34_26 then
		var_34_25 = var_0_64

		local var_34_28 = var_34_13 + var_34_15 * var_34_18

		if var_34_2.restricted_queue_distance then
			if var_34_8 <= var_0_2(var_34_13, var_34_28) then
				return var_34_28, var_34_25
			else
				local var_34_29
				local var_34_30 = var_0_5(var_34_14 - var_34_13)
				local var_34_31 = 1

				while not var_34_29 and var_34_31 <= var_34_21 do
					local var_34_32 = math.max(math.max(var_34_17 * (1 - var_34_31 / var_34_21), var_34_4) + var_34_18 + var_34_16 - var_34_9, var_34_7)

					var_34_28 = var_34_13 + var_34_30 * math.max(var_34_32, 0.5)
					var_34_29 = var_0_0.clamp_position_on_navmesh(var_34_28, arg_34_1, var_0_61, var_0_62)
					var_34_31 = var_34_31 + 1
				end

				if var_34_29 then
					return var_34_29, 0
				else
					return var_34_28, var_34_25
				end
			end
		else
			return var_34_28, var_34_25
		end
	else
		return var_34_20, var_34_25
	end
end

AIPlayerSlotExtension.debug_draw = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
	local var_35_0 = Vector3.up() * 0.1
	local var_35_1 = arg_35_0.all_slots

	for iter_35_0, iter_35_1 in pairs(var_35_1) do
		local var_35_2 = iter_35_1.slots
		local var_35_3 = #var_35_2
		local var_35_4 = arg_35_0.position:unbox()
		local var_35_5 = Colors.get(arg_35_0.debug_color_name)

		arg_35_1:circle(var_35_4 + var_35_0, 0.5, Vector3.up(), var_35_5)
		arg_35_1:circle(var_35_4 + var_35_0, 0.45, Vector3.up(), var_35_5)

		if arg_35_0.next_slot_status_update_at then
			local var_35_6 = (arg_35_2 - arg_35_0.next_slot_status_update_at) / var_0_24

			arg_35_1:circle(var_35_4 + var_35_0, 0.45 * var_35_6, Vector3.up(), var_35_5)
		end

		for iter_35_2 = 1, var_35_3 do
			repeat
				local var_35_7 = var_35_2[iter_35_2]
				local var_35_8

				var_35_8 = var_35_7 == var_0_37(iter_35_1)

				local var_35_9 = var_35_7.ai_unit
				local var_35_10 = var_35_9 and 255 or 150
				local var_35_11 = var_35_7.disabled and Colors.get_color_with_alpha("gray", var_35_10) or Colors.get_color_with_alpha(var_35_7.debug_color_name, var_35_10)

				if var_35_7.absolute_position then
					local var_35_12 = var_35_7.absolute_position:unbox()
					local var_35_13 = var_35_7.original_absolute_position:unbox()

					if ALIVE[var_35_9] then
						local var_35_14 = Unit.local_position(var_35_9, 0)

						arg_35_1:circle(var_35_14 + var_35_0, 0.35, Vector3.up(), var_35_11)
						arg_35_1:circle(var_35_14 + var_35_0, 0.3, Vector3.up(), var_35_11)

						local var_35_15 = Unit.node(var_35_9, "c_head")
						local var_35_16 = "player_1"
						local var_35_17 = var_35_7.disabled and Colors.get_table("gray") or Colors.get_table(var_35_7.debug_color_name)
						local var_35_18 = Vector3(var_35_17[2], var_35_17[3], var_35_17[4])
						local var_35_19 = Vector3(0, 0, -1)
						local var_35_20 = 0.4
						local var_35_21 = var_35_7.index
						local var_35_22 = "slot_index"

						Managers.state.debug_text:clear_unit_text(var_35_9, var_35_22)
						Managers.state.debug_text:output_unit_text(var_35_21, var_35_20, var_35_9, var_35_15, var_35_19, nil, var_35_22, var_35_18, var_35_16)

						if var_35_7.ghost_position.x ~= 0 and not var_35_7.disable_at then
							local var_35_23 = var_35_7.ghost_position:unbox()

							arg_35_1:line(var_35_23 + var_35_0, var_35_12 + var_35_0, var_35_11)
							arg_35_1:sphere(var_35_23 + var_35_0, 0.3, var_35_11)
							arg_35_1:line(var_35_23 + var_35_0, var_35_14 + var_35_0, var_35_11)
						else
							arg_35_1:line(var_35_12 + var_35_0, var_35_14 + var_35_0, var_35_11)
						end
					end

					local var_35_24 = 0.4
					local var_35_25 = var_35_7.disabled and Colors.get_table("gray") or Colors.get_table(var_35_7.debug_color_name)
					local var_35_26 = Vector3(var_35_25[2], var_35_25[3], var_35_25[4])
					local var_35_27 = "slot_index_" .. iter_35_0 .. "_" .. var_35_7.index .. "_" .. arg_35_0.index

					Managers.state.debug_text:clear_world_text(var_35_27)
					Managers.state.debug_text:output_world_text(var_35_7.index, var_35_24, var_35_12 + var_35_0, nil, var_35_27, var_35_26)

					local var_35_28 = var_0_34[iter_35_0].radius

					arg_35_1:circle(var_35_12 + var_35_0, var_35_28, Vector3.up(), var_35_11)
					arg_35_1:circle(var_35_12 + var_35_0, var_35_28 - 0.05, Vector3.up(), var_35_11)

					local var_35_29 = var_0_65(var_35_7, arg_35_3, nil, arg_35_2)

					if var_35_29 then
						arg_35_1:circle(var_35_29 + var_35_0, var_0_63, Vector3.up(), var_35_11)
						arg_35_1:circle(var_35_29 + var_35_0, var_0_63 - 0.05, Vector3.up(), var_35_11)
						arg_35_1:line(var_35_12 + var_35_0, var_35_29 + var_35_0, var_35_11)

						local var_35_30 = var_35_7.queue
						local var_35_31 = #var_35_30

						for iter_35_3 = 1, var_35_31 do
							local var_35_32 = var_35_30[iter_35_3].unit
							local var_35_33 = Unit.local_position(var_35_32, 0)

							if var_35_33 then
								arg_35_1:circle(var_35_33 + var_35_0, 0.35, Vector3.up(), var_35_11)
								arg_35_1:circle(var_35_33 + var_35_0, 0.3, Vector3.up(), var_35_11)
								arg_35_1:line(var_35_29 + var_35_0, var_35_33, var_35_11)
							end
						end
					end

					local var_35_34 = 0.2
					local var_35_35 = var_35_7.disabled and Colors.get_table("gray") or Colors.get_table(var_35_7.debug_color_name)
					local var_35_36 = Vector3(var_35_35[2], var_35_35[3], var_35_35[4])
					local var_35_37 = "wait_slot_index_" .. iter_35_0 .. "_" .. var_35_7.index .. "_" .. iter_35_2

					Managers.state.debug_text:clear_world_text(var_35_37)

					if var_35_29 then
						Managers.state.debug_text:output_world_text("wait " .. var_35_7.index, var_35_34, var_35_29 + var_35_0, nil, var_35_37, var_35_36)
					end

					local var_35_38 = var_35_7.position_check_index
					local var_35_39 = var_35_12

					if var_35_38 == var_0_11.CHECK_MIDDLE then
						-- Nothing
					else
						local var_35_40 = var_0_13[var_35_38]

						var_35_39 = var_0_39(var_35_39, var_35_4, var_35_40, var_0_10)
					end

					local var_35_41 = var_35_4 + var_0_5(var_35_39 - var_35_4) * var_0_15

					arg_35_1:line(var_35_41 + var_35_0, var_35_39 + var_35_0, var_35_11)
					arg_35_1:circle(var_35_39 + var_35_0, 0.1, Vector3.up(), Color(255, 0, 255))

					break
				end

				local var_35_42 = "wait_slot_index_" .. iter_35_0 .. "_" .. var_35_7.index .. "_" .. iter_35_2

				Managers.state.debug_text:clear_world_text(var_35_42)
			until true
		end
	end
end

local function var_0_66(arg_36_0)
	local var_36_0 = 0
	local var_36_1 = arg_36_0.slots
	local var_36_2 = arg_36_0.total_slots_count

	for iter_36_0 = 1, var_36_2 do
		local var_36_3 = var_36_1[iter_36_0]

		if var_36_3.ai_unit then
			var_36_0 = var_36_0 + 1
		end

		var_36_0 = var_36_0 + #var_36_3.queue
	end

	arg_36_0.slots_count = var_36_0

	return var_36_0
end

local function var_0_67(arg_37_0, arg_37_1, arg_37_2)
	local var_37_0 = arg_37_0.original_absolute_position:unbox()
	local var_37_1 = var_0_7(var_37_0 - arg_37_2)
	local var_37_2 = var_0_5(var_37_1)
	local var_37_3 = var_0_7(arg_37_1 - arg_37_2)
	local var_37_4 = var_0_5(var_37_3)
	local var_37_5 = var_0_6(var_37_2, var_37_4)

	return var_37_5 < 0.6, var_37_5
end

local var_0_68 = -3
local var_0_69 = -2

local function var_0_70(arg_38_0)
	local var_38_0 = arg_38_0.disabled_slots_count
	local var_38_1 = arg_38_0.slots_count
	local var_38_2 = arg_38_0.total_slots_count - var_38_0

	return var_38_0 >= 2 and var_38_2 <= var_38_1
end

local function var_0_71(arg_39_0)
	arg_39_0.ghost_position:store(Vector3(0, 0, 0))
end

local var_0_72 = 90
local var_0_73 = math.degrees_to_radians(var_0_72)

local function var_0_74(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
	local var_40_0 = arg_40_2.absolute_position:unbox()
	local var_40_1 = math.min(var_0_1(arg_40_1, arg_40_0), 8)
	local var_40_2 = var_0_39(var_40_0, arg_40_0, -var_0_73, var_40_1)
	local var_40_3 = var_0_39(var_40_0, arg_40_0, var_0_73, var_40_1)
	local var_40_4 = var_0_2(arg_40_1, var_40_2) > var_0_2(arg_40_1, var_40_3) and var_40_2 or var_40_3
	local var_40_5 = var_0_0.clamp_position_on_navmesh(var_40_4, arg_40_3)
	local var_40_6

	if var_40_5 then
		var_40_6 = var_0_5(var_40_5 - var_40_0)
	else
		var_40_6 = var_0_5(var_40_4 - var_40_0)
	end

	local var_40_7 = 5

	for iter_40_0 = 1, var_40_7 do
		if var_40_5 and var_0_9(arg_40_3, var_40_5, var_40_0, arg_40_4) then
			arg_40_2.ghost_position:store(var_40_5)

			return
		end

		local var_40_8 = arg_40_2.type
		local var_40_9 = var_0_34[var_40_8].distance
		local var_40_10 = arg_40_1 + var_40_6 * (var_40_9 + (var_40_1 - var_40_9) * (var_40_7 - iter_40_0) / var_40_7)

		var_40_5 = var_0_0.clamp_position_on_navmesh(var_40_10, arg_40_3)
	end

	var_0_71(arg_40_2)
end

TEST_SLOT = 0

AIPlayerSlotExtension._get_best_slot = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
	local var_41_0 = Unit.local_position(arg_41_1, 0)
	local var_41_1 = arg_41_0.position:unbox()
	local var_41_2 = arg_41_0.all_slots[arg_41_2]
	local var_41_3 = var_41_2.slots
	local var_41_4 = var_41_2.total_slots_count
	local var_41_5 = arg_41_4 and var_0_70(var_41_2)
	local var_41_6
	local var_41_7 = math.huge

	if TEST_SLOT > 0 then
		return var_41_3[TEST_SLOT]
	end

	for iter_41_0 = 1, var_41_4 do
		local var_41_8 = var_41_3[iter_41_0]

		if var_41_8.disabled then
			-- Nothing
		elseif (arg_41_3 or var_41_5) and var_0_67(var_41_8, var_41_0, var_41_1) then
			-- Nothing
		else
			local var_41_9 = var_41_8.ai_unit
			local var_41_10 = var_41_8.original_absolute_position:unbox()
			local var_41_11 = var_0_2(var_41_10, var_41_0)
			local var_41_12 = math.huge

			if ALIVE[var_41_9] then
				if var_41_9 == arg_41_1 then
					var_41_12 = var_41_11 + var_0_68
				elseif var_41_8.released then
					local var_41_13 = Unit.local_position(var_41_9, 0)

					if var_41_11 < var_0_2(var_41_10, var_41_13) + var_0_69 then
						var_41_12 = var_41_11
					end
				end
			else
				var_41_12 = var_41_11
			end

			if var_41_12 < var_41_7 then
				var_41_6 = var_41_8
				var_41_7 = var_41_12
			end
		end
	end

	return var_41_6
end

AIPlayerSlotExtension._get_best_slot_to_wait_on = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5, arg_42_6)
	local var_42_0 = Unit.local_position(arg_42_1, 0)
	local var_42_1 = arg_42_0.position:unbox()
	local var_42_2 = arg_42_0.all_slots
	local var_42_3 = var_42_2[arg_42_2]
	local var_42_4 = arg_42_4 and var_0_70(var_42_3)
	local var_42_5 = math.huge
	local var_42_6

	for iter_42_0 = 1, var_0_35 do
		local var_42_7 = var_42_2[var_0_33[iter_42_0]]
		local var_42_8 = var_42_7.slots
		local var_42_9 = var_42_7.total_slots_count

		for iter_42_1 = 1, var_42_9 do
			local var_42_10 = var_42_8[iter_42_1]
			local var_42_11 = #var_42_10.queue
			local var_42_12 = 0

			if (arg_42_3 or var_42_4) and var_0_67(var_42_10, var_42_0, var_42_1) then
				var_42_12 = 100
			end

			local var_42_13, var_42_14 = var_0_65(var_42_10, arg_42_5, 0, arg_42_6)

			if not var_42_13 then
				-- Nothing
			else
				local var_42_15 = var_0_2(var_42_13, var_42_0) + var_42_11 * var_42_11 * var_0_31 + var_42_14 + var_42_12

				if var_42_15 < var_42_5 then
					var_42_5 = var_42_15
					var_42_6 = var_42_10
				end
			end
		end
	end

	return var_42_6
end

AIPlayerSlotExtension._update_slot = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4)
	var_0_51(arg_43_1)

	local var_43_0 = Unit.local_position(arg_43_2, 0)
	local var_43_1 = arg_43_0.position:unbox()

	if var_0_67(arg_43_1, var_43_0, var_43_1) then
		var_0_74(var_43_0, var_43_1, arg_43_1, arg_43_3, arg_43_4)
	else
		var_0_71(arg_43_1)
	end
end

AIPlayerSlotExtension._assign_slot = function (arg_44_0, arg_44_1, arg_44_2)
	if arg_44_1.ai_unit_slot_extension == arg_44_2 then
		return
	end

	local var_44_0 = arg_44_1.ai_unit_slot_extension

	if var_44_0 then
		var_44_0:on_slot_lost()
	end

	arg_44_1.ai_unit = arg_44_2.unit
	arg_44_1.ai_unit_slot_extension = arg_44_2

	arg_44_2:on_slot_gained(arg_44_0, arg_44_1)

	local var_44_1 = arg_44_0.all_slots
	local var_44_2 = var_44_1[arg_44_1.type]

	var_44_2.slots_count = var_0_66(var_44_2)

	var_0_54(var_44_1)
end

AIPlayerSlotExtension.request_best_slot = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6)
	local var_45_0 = false
	local var_45_1 = arg_45_1:get_preferred_slot_type()
	local var_45_2 = arg_45_1.unit
	local var_45_3 = arg_45_0:_get_best_slot(var_45_2, var_45_1, arg_45_2, arg_45_3)

	if var_45_3 then
		arg_45_0:_assign_slot(var_45_3, arg_45_1)
		arg_45_0:_update_slot(var_45_3, var_45_2, arg_45_4, arg_45_5)
	else
		local var_45_4, var_45_5 = arg_45_1:get_current_slot()
		local var_45_6 = Unit.local_position(var_45_2, 0)
		local var_45_7 = arg_45_0.position:unbox()
		local var_45_8 = not var_45_5 and var_45_4 and var_45_4.owner_extension == arg_45_0
		local var_45_9 = var_45_4 and var_0_67(var_45_4, var_45_6, var_45_7)

		if var_45_8 and arg_45_2 and var_45_9 then
			print("[AIPlayerSlotExtension] force releaseing slot", arg_45_1._debug_id, var_45_4.index)
			arg_45_0:free_slot(arg_45_1, var_45_4, false)

			local var_45_10 = ScriptUnit.extension_input(var_45_2, "dialogue_system")
			local var_45_11 = FrameTable.alloc_table()

			var_45_10:trigger_networked_dialogue_event("flanking", var_45_11)
		elseif not var_45_5 then
			var_45_3 = arg_45_0:_get_best_slot_to_wait_on(var_45_2, var_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_6)
			var_45_0 = true

			if var_45_3 then
				if var_45_3 == var_45_4 then
					arg_45_0:free_slot(arg_45_1, var_45_4, false)
				else
					local var_45_12 = var_45_3.queue

					var_45_12[#var_45_12 + 1] = arg_45_1

					arg_45_1:on_entered_slot_queue(arg_45_0, var_45_3)
				end
			end
		elseif var_45_9 then
			local var_45_13 = arg_45_0.all_slots[var_45_1]

			if arg_45_3 and var_0_70(var_45_13) or arg_45_2 then
				arg_45_0:free_slot(arg_45_1, var_45_4, true)
			end
		end
	end

	return var_45_3, var_45_0
end

AIPlayerSlotExtension.get_destination = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4, arg_46_5)
	local var_46_0

	if not arg_46_3 then
		if arg_46_2.ghost_position.x ~= 0 then
			var_46_0 = arg_46_2.ghost_position:unbox()
		else
			var_46_0 = arg_46_2.absolute_position:unbox()

			if script_data.ai_debug_slots then
				QuickDrawer:sphere(var_46_0, 0.3, Color(255, 255, 255))
			end
		end
	else
		local var_46_1 = arg_46_1.unit
		local var_46_2 = Unit.local_position(var_46_1, 0)
		local var_46_3 = arg_46_2.queue[1] == arg_46_1 and -0.5 or 0.5
		local var_46_4 = var_0_65(arg_46_2, arg_46_4, var_46_3, arg_46_5)
		local var_46_5 = var_0_28
		local var_46_6 = var_0_29
		local var_46_7 = var_0_30
		local var_46_8 = 0
		local var_46_9 = var_0_63
		local var_46_10 = 2
		local var_46_11 = LocomotionUtils.new_random_goal_uniformly_distributed_with_inside_from_outside_on_last
		local var_46_12 = var_46_4 and var_46_11(arg_46_4, nil, var_46_4, var_46_8, var_46_9, var_46_10, nil, var_46_5, var_46_6, var_46_7) or nil
		local var_46_13 = (var_46_12 and math.abs(var_46_2.z - var_46_12.z) or 0) > var_0_21
		local var_46_14 = (var_46_12 and var_0_1(var_46_12, var_46_2) or math.huge) < 5

		var_46_0 = var_46_12

		if var_46_13 and var_46_14 then
			var_46_0 = nil
		end
	end

	return var_46_0
end

AIPlayerSlotExtension.free_slot = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3)
	arg_47_1:on_slot_lost()

	if arg_47_3 then
		local var_47_0 = arg_47_2.queue
		local var_47_1 = #var_47_0

		for iter_47_0 = var_47_1, 1, -1 do
			if var_47_0[iter_47_0] == arg_47_1 then
				var_47_0[iter_47_0] = var_47_0[var_47_1]
				var_47_0[var_47_1] = nil

				break
			end
		end
	else
		fassert(arg_47_2.target_unit == arg_47_0.unit, "this slot is does not belog here")
		fassert(arg_47_2.ai_unit_slot_extension == arg_47_1, "wrong unit tried to leave slot %d, current slot owner id %d, but freed by %d", arg_47_2.index, arg_47_2.ai_unit_slot_extension._debug_id, arg_47_1._debug_id)

		local var_47_2 = arg_47_2.queue
		local var_47_3 = #var_47_2

		if var_47_3 > 0 then
			local var_47_4 = var_47_2[var_47_3]
			local var_47_5 = var_47_4.unit

			if var_47_4:get_preferred_slot_type() == arg_47_2.type then
				arg_47_2.ai_unit = var_47_5
				arg_47_2.ai_unit_slot_extension = var_47_4
				var_47_2[var_47_3] = nil

				var_47_4:on_slot_lost()
				var_47_4:on_slot_gained(arg_47_0, arg_47_2)
			else
				print("[AIPlayerSlotExtension] dispersing queue due to wrong slot type preference got -> expected", arg_47_2.index, arg_47_2.type, var_47_4:get_preferred_slot_type())

				for iter_47_1 = #var_47_2, 1, -1 do
					var_47_2[iter_47_1]:on_slot_lost()

					var_47_2[iter_47_1] = nil
				end

				arg_47_2.ai_unit = nil
				arg_47_2.ai_unit_slot_extension = nil
			end
		else
			arg_47_2.ai_unit = nil
			arg_47_2.ai_unit_slot_extension = nil
		end
	end

	local var_47_6 = arg_47_2.type
	local var_47_7 = arg_47_0.all_slots[var_47_6]

	var_47_7.slots_count = var_0_66(var_47_7)
end
