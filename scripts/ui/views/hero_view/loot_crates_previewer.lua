-- chunkname: @scripts/ui/views/hero_view/loot_crates_previewer.lua

LootCratesPreviewer = class(LootCratesPreviewer)

LootCratesPreviewer.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6)
	arg_1_0.background_world = arg_1_5
	arg_1_0.background_viewport = arg_1_6
	arg_1_0.spawn_positions = arg_1_3
	arg_1_0.end_positions = arg_1_4
	arg_1_0.units = arg_1_2
	arg_1_0._rewards = arg_1_1
	arg_1_0._spawned_units = arg_1_0:spawn_units(arg_1_2)

	local var_1_0 = {}

	for iter_1_0, iter_1_1 in ipairs(arg_1_1) do
		local var_1_1 = iter_1_1.key

		var_1_0[arg_1_0._spawned_units[iter_1_0]] = var_1_1
	end

	arg_1_0._item_key_by_unit = var_1_0
end

LootCratesPreviewer.destroy = function (arg_2_0)
	arg_2_0:_destroy_units()
end

LootCratesPreviewer._destroy_units = function (arg_3_0)
	local var_3_0 = arg_3_0.background_world
	local var_3_1 = arg_3_0._spawned_units

	if var_3_1 then
		for iter_3_0, iter_3_1 in ipairs(var_3_1) do
			World.destroy_unit(var_3_0, iter_3_1)
		end
	end

	arg_3_0.units_spawned = nil
end

LootCratesPreviewer.update = function (arg_4_0, arg_4_1, arg_4_2)
	return
end

LootCratesPreviewer.post_update = function (arg_5_0, arg_5_1, arg_5_2)
	if not arg_5_0._entry_animation_complete then
		arg_5_0:_animate_entry_positions(arg_5_1, arg_5_2)
	end
end

LootCratesPreviewer._animate_entry_positions = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0.spawn_positions
	local var_6_1 = arg_6_0.end_positions
	local var_6_2 = 1
	local var_6_3 = arg_6_0._entry_progress or 0
	local var_6_4 = math.min(var_6_3 + arg_6_1 * var_6_2, 1)
	local var_6_5 = math.easeInCubic(var_6_4)
	local var_6_6 = arg_6_0.background_world
	local var_6_7 = arg_6_0._spawned_units
	local var_6_8 = true

	for iter_6_0, iter_6_1 in ipairs(var_6_7) do
		local var_6_9 = var_6_1[iter_6_0]
		local var_6_10 = var_6_0[iter_6_0]
		local var_6_11 = Unit.local_position(iter_6_1, 0)
		local var_6_12 = var_6_10[3] - var_6_9[3]
		local var_6_13 = var_6_11[3] - var_6_9[3]

		var_6_11[3] = var_6_10[3] - var_6_5 * var_6_12

		Unit.set_local_position(iter_6_1, 0, var_6_11)
	end

	if var_6_4 == 1 then
		arg_6_0._entry_animation_complete = true
	end

	arg_6_0._entry_progress = var_6_4
end

LootCratesPreviewer._trigger_unit_flow_event = function (arg_7_0, arg_7_1, arg_7_2)
	if arg_7_1 and Unit.alive(arg_7_1) then
		Unit.flow_event(arg_7_1, arg_7_2)
	end
end

LootCratesPreviewer._get_world = function (arg_8_0)
	return arg_8_0.background_world, arg_8_0.background_viewport
end

LootCratesPreviewer._get_camera_position = function (arg_9_0)
	local var_9_0 = arg_9_0.background_viewport
	local var_9_1 = ScriptViewport.camera(var_9_0)

	return ScriptCamera.position(var_9_1)
end

LootCratesPreviewer._get_camera_rotation = function (arg_10_0)
	local var_10_0 = arg_10_0.background_viewport
	local var_10_1 = ScriptViewport.camera(var_10_0)

	return ScriptCamera.rotation(var_10_1)
end

LootCratesPreviewer.get_units = function (arg_11_0)
	return arg_11_0._spawned_units
end

LootCratesPreviewer.has_units = function (arg_12_0)
	return arg_12_0._spawned_units and #arg_12_0._spawned_units > 0
end

LootCratesPreviewer.get_item_key_by_unit = function (arg_13_0, arg_13_1)
	return arg_13_0._item_key_by_unit[arg_13_1]
end

LootCratesPreviewer.delete_unit = function (arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0.background_world
	local var_14_1 = arg_14_0._spawned_units

	for iter_14_0, iter_14_1 in ipairs(var_14_1) do
		if arg_14_1 == iter_14_1 then
			table.remove(var_14_1, iter_14_0)
			World.destroy_unit(var_14_0, iter_14_1)

			return
		end
	end
end

LootCratesPreviewer.spawn_units = function (arg_15_0, arg_15_1)
	local var_15_0 = {}
	local var_15_1 = arg_15_0.spawn_positions

	if arg_15_1 then
		local var_15_2 = {}
		local var_15_3 = arg_15_0.background_world

		for iter_15_0 = 1, #arg_15_1 do
			local var_15_4 = var_15_1[iter_15_0]
			local var_15_5 = arg_15_1[iter_15_0]
			local var_15_6 = World.spawn_unit(var_15_3, var_15_5)
			local var_15_7 = arg_15_0:_get_camera_rotation()
			local var_15_8 = Quaternion.forward(var_15_7)
			local var_15_9 = Quaternion.look(var_15_8, Vector3.up())
			local var_15_10 = Quaternion.axis_angle(Vector3.up(), math.pi * 1)
			local var_15_11 = Quaternion.multiply(var_15_9, var_15_10)
			local var_15_12 = arg_15_0:_get_camera_position()
			local var_15_13 = Vector3(var_15_4[1], var_15_4[2], var_15_4[3])
			local var_15_14, var_15_15 = Unit.box(var_15_6)
			local var_15_16 = Matrix4x4.translation(var_15_14) - Unit.world_position(var_15_6, 0)

			if var_15_15 then
				local var_15_17 = 0.3
				local var_15_18 = 0

				if var_15_18 < var_15_15.x then
					var_15_18 = var_15_15.x
				end

				if var_15_18 < var_15_15.z then
					var_15_18 = var_15_15.z
				end

				if var_15_18 < var_15_15.y then
					var_15_18 = var_15_15.y
				end

				if var_15_17 < var_15_18 then
					local var_15_19 = 1 - (var_15_18 - var_15_17) / var_15_18
					local var_15_20 = Vector3(var_15_19, var_15_19, var_15_19)

					Unit.set_local_scale(var_15_6, 0, var_15_20)

					var_15_16 = var_15_16 * var_15_19
				end

				local var_15_21 = var_15_13 - var_15_16

				Unit.set_local_position(var_15_6, 0, var_15_21)
			end

			Unit.set_unit_visibility(var_15_6, true)

			var_15_0[#var_15_0 + 1] = var_15_6
		end

		arg_15_0.units_spawned = true
	end

	return var_15_0
end

LootCratesPreviewer._enable_units_visibility = function (arg_16_0)
	local var_16_0 = arg_16_0._spawned_units

	for iter_16_0, iter_16_1 in ipairs(var_16_0) do
		if iter_16_1 and Unit.alive(iter_16_1) then
			Unit.set_unit_visibility(iter_16_1, true)

			local var_16_1 = "lua_presentation"

			arg_16_0:_trigger_unit_flow_event(iter_16_1, var_16_1)
		end
	end
end
