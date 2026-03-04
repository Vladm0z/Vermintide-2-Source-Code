-- chunkname: @scripts/ui/views/team_previewer.lua

require("scripts/ui/views/world_hero_previewer")

TeamPreviewer = class(TeamPreviewer)

TeamPreviewer.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.hero_previewers = {}
	arg_1_0._context = arg_1_1
	arg_1_0.world = arg_1_2
	arg_1_0.camera = ScriptViewport.camera(arg_1_3)
end

TeamPreviewer.setup_team = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0:destroy_previewers()

	local var_2_0 = arg_2_0.hero_previewers

	for iter_2_0 = 1, #arg_2_1 do
		local var_2_1 = HeroPreviewer:new(arg_2_0._context)

		if arg_2_1[iter_2_0] ~= true and arg_2_3 ~= false then
			arg_2_0:_spawn_hero(var_2_1, arg_2_1[iter_2_0])
		end

		var_2_0[#var_2_0 + 1] = var_2_1
	end

	local var_2_2 = true
	local var_2_3 = Vector3Aux.box(nil, ScriptCamera.position(arg_2_0.camera))

	arg_2_0:update_hero_arrangement(arg_2_2, var_2_3, var_2_2)
end

TeamPreviewer.on_enter = function (arg_3_0)
	return
end

TeamPreviewer.loading_done = function (arg_4_0)
	local var_4_0 = arg_4_0.hero_previewers

	for iter_4_0 = 1, #var_4_0 do
		if not var_4_0[iter_4_0]:loading_done() then
			return false
		end
	end

	return true
end

TeamPreviewer.update = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0.hero_previewers

	for iter_5_0 = 1, #var_5_0 do
		var_5_0[iter_5_0]:update(arg_5_1, arg_5_2)
	end
end

TeamPreviewer.post_update = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0.hero_previewers

	for iter_6_0 = 1, #var_6_0 do
		var_6_0[iter_6_0]:post_update(arg_6_1, arg_6_2)
	end
end

TeamPreviewer.on_exit = function (arg_7_0)
	arg_7_0:destroy_previewers()
end

TeamPreviewer.clear_team = function (arg_8_0)
	local var_8_0 = arg_8_0.hero_previewers

	for iter_8_0 = 1, #var_8_0 do
		local var_8_1 = var_8_0[iter_8_0]

		if var_8_1 then
			var_8_1:clear_units()
		end
	end
end

TeamPreviewer.destroy_previewers = function (arg_9_0)
	local var_9_0 = arg_9_0.hero_previewers

	for iter_9_0 = 1, #var_9_0 do
		local var_9_1 = var_9_0[iter_9_0]

		if var_9_1 then
			var_9_1:prepare_exit()
			var_9_1:on_exit()
			var_9_1:destroy()
		end
	end

	arg_9_0.hero_previewers = {}
end

TeamPreviewer._spawn_hero = function (arg_10_0, arg_10_1, arg_10_2)
	arg_10_1:on_enter(arg_10_0.world)

	local var_10_0 = callback(arg_10_0, "cb_hero_unit_spawned_skin_preview", arg_10_1, arg_10_2)

	arg_10_1:request_spawn_hero_unit(arg_10_2.hero_name, arg_10_2.career_index, var_10_0, arg_10_2.skin_name, arg_10_2.breed)
end

local var_0_0 = {}

TeamPreviewer.cb_hero_unit_spawned_skin_preview = function (arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_2.preview_items
	local var_11_1 = arg_11_2.weapon_slot

	for iter_11_0 = 1, #var_11_0 do
		local var_11_2 = var_11_0[iter_11_0]

		if var_11_2 then
			local var_11_3 = var_11_2.item_name

			if var_11_3 then
				local var_11_4 = ItemMasterList[var_11_3].slot_type
				local var_11_5 = InventorySettings.slot_names_by_type[var_11_4][1]
				local var_11_6 = InventorySettings.slots_by_name[var_11_5]

				arg_11_1:equip_item(var_11_3, var_11_6, nil, var_11_2.skin_name ~= "n/a" and var_11_2.skin_name)
			end
		end
	end

	if var_11_1 then
		arg_11_1:wield_weapon_slot(var_11_1, arg_11_2)
	end

	local var_11_7 = "idle"
	local var_11_8 = arg_11_2.weapon_pose_anim_event

	if var_11_8 and table.is_empty(arg_11_2.breed or var_0_0) then
		arg_11_1:play_character_animation(var_11_8)
	elseif arg_11_2.breed and not table.is_empty(arg_11_2.breed or var_0_0) then
		local var_11_9 = Math.random(6)

		if arg_11_2.random_seed then
			local var_11_10
			local var_11_11

			var_11_11, var_11_9 = Math.next_random(arg_11_2.random_seed, 1, 6)
		end

		local var_11_12 = string.format("parading_pose_%02d", var_11_9)

		arg_11_1:play_character_animation(var_11_12)
	elseif arg_11_2.preview_animation then
		arg_11_1:play_character_animation(arg_11_2.preview_animation)
	else
		arg_11_1:play_character_animation(var_11_7)
	end
end

TeamPreviewer.update_hero_arrangement = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = arg_12_1
	local var_12_1 = arg_12_0.hero_previewers
	local var_12_2 = ScriptCamera.position(arg_12_0.camera)

	for iter_12_0 = 1, #var_12_1 do
		local var_12_3 = var_12_1[iter_12_0]

		if var_12_3 then
			var_12_3:set_hero_location(var_12_0[iter_12_0])
			var_12_3:set_hero_look_target(arg_12_2)

			if arg_12_3 then
				local var_12_4 = Vector3Aux.unbox(var_12_0[iter_12_0])
				local var_12_5 = Vector3.flat(var_12_2 - var_12_4)
				local var_12_6 = -math.atan2(var_12_5[1], var_12_5[2])

				var_12_3:set_hero_rotation(var_12_6)
			end
		end
	end
end

TeamPreviewer.set_camera_orientation = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = Vector3Aux.unbox(arg_13_1)
	local var_13_1 = Vector3Aux.unbox(arg_13_2)
	local var_13_2 = Vector3.normalize(var_13_1 - var_13_0)
	local var_13_3 = Quaternion.look(var_13_2)

	ScriptCamera.set_local_rotation(arg_13_0.camera, var_13_3)
	ScriptCamera.set_local_position(arg_13_0.camera, var_13_0)
end

TeamPreviewer.set_camera_fov = function (arg_14_0, arg_14_1)
	Camera.set_vertical_fov(arg_14_0.camera, math.degrees_to_radians(arg_14_1))
end

TeamPreviewer.get_hero_previewer = function (arg_15_0, arg_15_1)
	fassert(arg_15_0.hero_previewers[arg_15_1], "[TeamPreviewer] The hero previewer at the index %d you are trying to access does not exist!", arg_15_1)

	return arg_15_0.hero_previewers[arg_15_1] or nil
end
