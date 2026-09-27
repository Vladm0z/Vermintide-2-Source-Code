-- chunkname: @scripts/ui/views/team_previewer.lua

require("scripts/ui/views/world_hero_previewer")

TeamPreviewer = class(TeamPreviewer)

TeamPreviewer.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.hero_previewers = {}
	self._context = arg_1_1
	self.world = arg_1_2
	self.camera = ScriptViewport.camera(arg_1_3)
end

TeamPreviewer.setup_team = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	self:destroy_previewers()

	local hero_previewers = self.hero_previewers

	for i = 1, #arg_2_1 do
		local var_2_1 = HeroPreviewer:new(self._context)

		if not (arg_2_1[i] == true or arg_2_3 == false) then
			self:_spawn_hero(var_2_1, arg_2_1[i])
		end

		hero_previewers[#hero_previewers + 1] = var_2_1
	end

	local flag = true
	local box = Vector3Aux.box(nil, ScriptCamera.position(self.camera))

	self:update_hero_arrangement(arg_2_2, box, flag)
end

TeamPreviewer.on_enter = function (arg_3_0)
	-- function 3
	return
end

TeamPreviewer.loading_done = function (self)
	-- function 4
	local hero_previewers = self.hero_previewers

	for i = 1, #hero_previewers do
		if not hero_previewers[i]:loading_done() then
			return false
		end
	end

	return true
end

TeamPreviewer.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	local hero_previewers = self.hero_previewers

	for i = 1, #hero_previewers do
		hero_previewers[i]:update(arg_5_1, arg_5_2)
	end
end

TeamPreviewer.post_update = function (self, arg_6_1, arg_6_2)
	-- function 6
	local hero_previewers = self.hero_previewers

	for i = 1, #hero_previewers do
		hero_previewers[i]:post_update(arg_6_1, arg_6_2)
	end
end

TeamPreviewer.on_exit = function (self)
	-- function 7
	self:destroy_previewers()
end

TeamPreviewer.clear_team = function (self)
	-- function 8
	local hero_previewers = self.hero_previewers

	for i = 1, #hero_previewers do
		local var_8_1 = hero_previewers[i]

		if not var_8_1 then
			var_8_1:clear_units()
		end
	end
end

TeamPreviewer.destroy_previewers = function (self)
	-- function 9
	local hero_previewers = self.hero_previewers

	for i = 1, #hero_previewers do
		local var_9_1 = hero_previewers[i]

		if not var_9_1 then
			var_9_1:prepare_exit()
			var_9_1:on_exit()
			var_9_1:destroy()
		end
	end

	self.hero_previewers = {}
end

TeamPreviewer._spawn_hero = function (self, arg_10_1, arg_10_2)
	-- function 10
	arg_10_1:on_enter(self.world)

	local var_10_0 = callback(self, "cb_hero_unit_spawned_skin_preview", arg_10_1, arg_10_2)

	arg_10_1:request_spawn_hero_unit(arg_10_2.hero_name, arg_10_2.career_index, var_10_0, arg_10_2.skin_name, arg_10_2.breed)
end

local tbl = {}

TeamPreviewer.cb_hero_unit_spawned_skin_preview = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	local preview_items = arg_11_2.preview_items
	local weapon_slot = arg_11_2.weapon_slot

	for i = 1, #preview_items do
		local var_11_2 = preview_items[i]

		if not var_11_2 then
			local item_name = var_11_2.item_name

			if not item_name then
				local slot_type = ItemMasterList[item_name].slot_type
				local var_11_5 = InventorySettings.slot_names_by_type[slot_type][1]
				local var_11_6 = InventorySettings.slots_by_name[var_11_5]

				arg_11_1:equip_item(item_name, var_11_6, nil, var_11_2.skin_name == "n/a" or var_11_2.skin_name)
			end
		end
	end

	if not weapon_slot then
		arg_11_1:wield_weapon_slot(weapon_slot, arg_11_2)
	end

	local str = "idle"
	local weapon_pose_anim_event = arg_11_2.weapon_pose_anim_event

	if not weapon_pose_anim_event then
		local is_empty = table.is_empty
		local breed = arg_11_2.breed

		breed = breed or tbl

		if not is_empty(breed) then
			arg_11_1:play_character_animation(weapon_pose_anim_event)

			goto label_11_0
		end
	end

	if not arg_11_2.breed then
		local is_empty_2 = table.is_empty
		local breed_2 = arg_11_2.breed

		breed_2 = breed_2 or tbl

		if not is_empty_2(breed_2) then
			local random = Math.random(6)

			if not arg_11_2.random_seed then
				local var_11_14
				local next_random

				next_random, random = Math.next_random(arg_11_2.random_seed, 1, 6)
			end

			local format = string.format("parading_pose_%02d", random)

			arg_11_1:play_character_animation(format)

			goto label_11_0
		end
	end

	if not arg_11_2.preview_animation then
		arg_11_1:play_character_animation(arg_11_2.preview_animation)
	else
		arg_11_1:play_character_animation(str)
	end

	::label_11_0::
end

TeamPreviewer.update_hero_arrangement = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local var_12_0 = arg_12_1
	local hero_previewers = self.hero_previewers
	local position = ScriptCamera.position(self.camera)

	for i = 1, #hero_previewers do
		local var_12_3 = hero_previewers[i]

		if not var_12_3 then
			var_12_3:set_hero_location(var_12_0[i])
			var_12_3:set_hero_look_target(arg_12_2)

			if not arg_12_3 then
				local unbox = Vector3Aux.unbox(var_12_0[i])
				local flat = Vector3.flat(position - unbox)
				local num = -math.atan2(flat[1], flat[2])

				var_12_3:set_hero_rotation(num)
			end
		end
	end
end

TeamPreviewer.set_camera_orientation = function (self, arg_13_1, arg_13_2)
	-- function 13
	local unbox = Vector3Aux.unbox(arg_13_1)
	local unbox_2 = Vector3Aux.unbox(arg_13_2)
	local normalize = Vector3.normalize(unbox_2 - unbox)
	local look = Quaternion.look(normalize)

	ScriptCamera.set_local_rotation(self.camera, look)
	ScriptCamera.set_local_position(self.camera, unbox)
end

TeamPreviewer.set_camera_fov = function (self, arg_14_1)
	-- function 14
	Camera.set_vertical_fov(self.camera, math.degrees_to_radians(arg_14_1))
end

TeamPreviewer.get_hero_previewer = function (self, arg_15_1)
	-- function 15
	fassert(self.hero_previewers[arg_15_1], "[TeamPreviewer] The hero previewer at the index %d you are trying to access does not exist!", arg_15_1)

	local var_15_0 = self.hero_previewers[arg_15_1]

	var_15_0 = var_15_0 or nil

	return var_15_0
end
