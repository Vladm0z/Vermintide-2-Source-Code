-- chunkname: @scripts/managers/debug/debug_text_manager.lua

DebugTextManager = class(DebugTextManager)

DebugTextManager.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	self._world = arg_1_1
	self._gui = arg_1_2
	self._world_gui = World.create_world_gui(arg_1_1, Matrix4x4.identity(), 1, 1, "material", "materials/fonts/gw_fonts", "immediate")
	self._time = 0
	self._screen_text_size = 50
	self._screen_text_time = 5
	self._screen_text_bgr = nil
	self._screen_text = nil
	self._unit_text_size = 0.2
	self._unit_text_time = math.huge
	self._unit_texts = {}
	self._world_text_size = 0.6
	self._world_text_time = math.huge
	self._world_texts = {}
end

DebugTextManager.update = function (self, arg_2_1, arg_2_2)
	-- function 2
	self._time = self._time + arg_2_1

	if not script_data and not script_data.disable_debug_draw then
		return
	end

	self:_update_unit_texts(arg_2_2, arg_2_1)
	self:_update_world_texts(arg_2_2)
	self:_update_screen_text()
end

DebugTextManager._update_unit_texts = function (self, arg_3_1, arg_3_2)
	-- function 3
	local camera_rotation = Managers.state.camera:camera_rotation(arg_3_1)
	local _world_gui = self._world_gui
	local str = "arial"
	local _unit_text_size = self._unit_text_size
	local str_2 = "materials/fonts/" .. str

	for k, v in pairs(self._unit_texts) do
		if not Unit.alive(k) then
			for k_2, v_2 in pairs(v) do
				for i, v_3 in ipairs(v_2) do
					if self._time > v_3.time then
						Gui.destroy_text_3d(self._world_gui, v_3.id)
						table.remove(v_2, i)
					else
						local var_3_5 = Vector3(v_3.offset.x, v_3.offset.y, v_3.offset.z)
						local from_quaternion_position = Matrix4x4.from_quaternion_position(camera_rotation, Unit.world_position(k, v_3.node_index) + var_3_5)
						local var_3_7 = Vector3(v_3.text_offset.x, v_3.text_offset.y, v_3.text_offset.z)
						local var_3_8

						if not v_3.fade then
							local num = (v_3.time - self._time) / (v_3.time - v_3.starting_time) * 255

							var_3_8 = Color(num, v_3.color.r, v_3.color.g, v_3.color.b)
						else
							var_3_8 = Color(v_3.color.r, v_3.color.g, v_3.color.b)
						end

						local floating_position_box = v_3.floating_position_box

						if not floating_position_box then
							local num_2 = floating_position_box:unbox() + Vector3.forward() * arg_3_2 * 0.5

							var_3_7 = var_3_7 + num_2

							v_3.floating_position_box:store(num_2)
						end

						Gui.update_text_3d(_world_gui, v_3.id, v_3.text, str_2, v_3.text_size, str, from_quaternion_position, var_3_7, 0, var_3_8)
					end
				end
			end
		else
			self:_destroy_unit_texts(k)
		end
	end
end

DebugTextManager._update_world_texts = function (self, arg_4_1)
	-- function 4
	local camera_rotation = Managers.state.camera:camera_rotation(arg_4_1)
	local _world_gui = self._world_gui
	local _world_text_size = self._world_text_size
	local str = "arial"
	local str_2 = "materials/fonts/" .. str

	for k, v in pairs(self._world_texts) do
		for i, v_2 in ipairs(v) do
			if self._time > v_2.time then
				Gui.destroy_text_3d(self._world_gui, v_2.id)
				table.remove(v, i)
			else
				local var_4_5 = Vector3(v_2.position.x, v_2.position.y, v_2.position.z)
				local var_4_6 = Vector3(v_2.text_offset.x, v_2.text_offset.y, v_2.text_offset.z)
				local from_quaternion_position = Matrix4x4.from_quaternion_position(camera_rotation, var_4_5)
				local var_4_8 = Color(v_2.color.r, v_2.color.g, v_2.color.b)

				Gui.update_text_3d(_world_gui, v_2.id, v_2.text, str_2, v_2.text_size, str, from_quaternion_position, var_4_6, 0, var_4_8)
			end
		end
	end
end

DebugTextManager._update_screen_text = function (self)
	-- function 5
	if not (not self._screen_text and not (self._time > self._screen_text.time)) then
		Gui.destroy_text(self._gui, self._screen_text.text_id)
		Gui.destroy_rect(self._gui, self._screen_text.bgr_id)

		self._screen_text = nil
	end
end

DebugTextManager.output_unit_text = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7, arg_6_8, arg_6_9, arg_6_10, arg_6_11)
	-- function 6
	if not script_data and not script_data.disable_debug_draw then
		return
	end

	arg_6_4 = arg_6_4 or 0
	arg_6_2 = arg_6_2 or self._unit_text_size

	local _world_gui = self._world_gui
	local str = "arial"
	local str_2 = "materials/fonts/" .. str
	local var_6_3

	if not arg_6_9 then
		local camera_rotation = Managers.state.camera:camera_rotation(arg_6_9)

		var_6_3 = Matrix4x4.from_quaternion_position(camera_rotation, Unit.world_position(arg_6_3, arg_6_4) + arg_6_5)
	else
		var_6_3 = Unit.world_pose(arg_6_3, arg_6_4)
	end

	local text_extents, var_6_6 = Gui.text_extents(_world_gui, arg_6_1, str_2, arg_6_2)
	local num = var_6_6[1] - text_extents[1]
	local num_2 = var_6_6[2] - text_extents[2]
	local var_6_9 = Vector3(-num / 2, -num_2 / 2, 0)

	arg_6_5 = arg_6_5 or Vector3(0, 0, 0)
	arg_6_7 = arg_6_7 or "none"
	arg_6_8 = arg_6_8 or Vector3(255, 255, 255)

	local var_6_10

	if not arg_6_10 then
		var_6_10 = Vector3Box(Vector3.zero())
	end

	local tbl = {
		alpha = 255,
		id = Gui.text_3d(_world_gui, arg_6_1, str_2, arg_6_2, str, var_6_3, var_6_9, 0, Color(arg_6_8.x, arg_6_8.y, arg_6_8.z)),
		text = arg_6_1,
		text_size = arg_6_2,
		node_index = arg_6_4,
		offset = {
			x = arg_6_5.x,
			y = arg_6_5.y,
			z = arg_6_5.z
		},
		text_offset = {
			x = var_6_9.x,
			y = var_6_9.y,
			z = var_6_9.z
		},
		color = {
			r = arg_6_8.x,
			g = arg_6_8.y,
			b = arg_6_8.z
		},
		time = self._time + (arg_6_6 or self._unit_text_time),
		floating_position_box = var_6_10,
		fade = arg_6_11,
		starting_time = self._time
	}
	local _unit_texts = self._unit_texts
	local var_6_13 = self._unit_texts[arg_6_3]

	var_6_13 = var_6_13 or {}
	_unit_texts[arg_6_3] = var_6_13

	local var_6_14 = self._unit_texts[arg_6_3]
	local var_6_15 = self._unit_texts[arg_6_3][arg_6_7]

	var_6_15 = var_6_15 or {}
	var_6_14[arg_6_7] = var_6_15
	self._unit_texts[arg_6_3][arg_6_7][#self._unit_texts[arg_6_3][arg_6_7] + 1] = tbl
end

DebugTextManager.clear_unit_text = function (self, arg_7_1, arg_7_2)
	-- function 7
	for k, v in pairs(self._unit_texts) do
		if not (not arg_7_1 and arg_7_1 ~= k) then
			for k_2, v_2 in pairs(v) do
				if not (not arg_7_2 and k_2 == "none" or arg_7_2 ~= k_2) then
					for i4 = #v_2, 1, -1 do
						local var_7_0 = v_2[i4]

						Gui.destroy_text_3d(self._world_gui, var_7_0.id)
						table.remove(v_2, i4)
					end
				end
			end
		end
	end
end

DebugTextManager.output_world_text = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7, arg_8_8)
	-- function 8
	if not script_data and not script_data.disable_debug_draw then
		return
	end

	arg_8_2 = arg_8_2 or self._world_text_size

	local _world_gui = self._world_gui
	local str = "arial"
	local str_2 = "materials/fonts/" .. str
	local var_8_3

	if not arg_8_7 then
		local camera_rotation = Managers.state.camera:camera_rotation(arg_8_7)

		var_8_3 = Matrix4x4.from_quaternion_position(camera_rotation, arg_8_3)
	else
		local from_quaternion_position = Matrix4x4.from_quaternion_position
		local inverse

		if not arg_8_8 then
			inverse = Quaternion.inverse(arg_8_8)

			if not inverse then
				-- Nothing
			end
		end

		inverse = Quaternion.identity()

		::label_8_0::

		var_8_3 = from_quaternion_position(inverse, arg_8_3)
	end

	local text_extents, var_8_8 = Gui.text_extents(_world_gui, arg_8_1, str_2, arg_8_2)
	local num = var_8_8[1] - text_extents[1]
	local num_2 = var_8_8[2] - text_extents[2]
	local var_8_11 = Vector3(-num / 2, -num_2 / 2, 0)

	arg_8_5 = arg_8_5 or "none"
	arg_8_6 = arg_8_6 or Vector3(255, 255, 255)

	local tbl = {
		id = Gui.text_3d(_world_gui, arg_8_1, str_2, arg_8_2, str, var_8_3, var_8_11, 0, Color(arg_8_6.x, arg_8_6.y, arg_8_6.z)),
		text = arg_8_1,
		text_size = arg_8_2,
		position = {
			x = arg_8_3.x,
			y = arg_8_3.y,
			z = arg_8_3.z
		},
		text_offset = {
			x = var_8_11.x,
			y = var_8_11.y,
			z = var_8_11.z
		},
		color = {
			r = arg_8_6.x,
			g = arg_8_6.y,
			b = arg_8_6.z
		},
		time = self._time + (arg_8_4 or self._world_text_time)
	}
	local _world_texts = self._world_texts
	local var_8_14 = self._world_texts[arg_8_5]

	var_8_14 = var_8_14 or {}
	_world_texts[arg_8_5] = var_8_14
	self._world_texts[arg_8_5][#self._world_texts[arg_8_5] + 1] = tbl
end

DebugTextManager.clear_world_text = function (self, arg_9_1)
	-- function 9
	for k, v in pairs(self._world_texts) do
		if not (not arg_9_1 and k == "none" or arg_9_1 ~= k) then
			for k_2 = #v, 1, -1 do
				local var_9_0 = v[k_2]

				Gui.destroy_text_3d(self._world_gui, var_9_0.id)
				table.remove(v, k_2)
			end
		end
	end
end

DebugTextManager.output_screen_text = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	if not script_data and not script_data.disable_debug_draw then
		return
	end

	arg_10_2 = arg_10_2 or self._screen_text_size
	arg_10_4 = arg_10_4 or Vector3(255, 255, 255)

	local _gui = self._gui
	local var_10_1 = Vector2(RESOLUTION_LOOKUP.res_w, RESOLUTION_LOOKUP.res_h)
	local str = "arial"
	local str_2 = "materials/fonts/" .. str
	local text_extents, var_10_5 = Gui.text_extents(_gui, arg_10_1, str_2, arg_10_2)
	local num = var_10_5[1] - text_extents[1]
	local num_2 = var_10_5[2] - text_extents[2]
	local var_10_8 = Vector3(var_10_1.x / 2 - num / 2, var_10_1.y / 2 - num_2 / 2, 11)
	local num_3 = 10
	local num_4 = var_10_8.x - num_3
	local num_5 = var_10_8.y - num_3
	local num_6 = num + num_3 * 2
	local num_7 = num_2 + num_3 * 2
	local var_10_14 = Vector3(num_4, num_5, 10)
	local var_10_15 = Vector2(num_6, num_7)

	if not self._screen_text then
		Gui.update_text(_gui, self._screen_text.text_id, arg_10_1, str_2, arg_10_2, str, var_10_8, Color(arg_10_4.x, arg_10_4.y, arg_10_4.z))
		Gui.update_rect(_gui, self._screen_text.bgr_id, var_10_14, var_10_15, Color(120, 0, 0, 0))

		self._screen_text.time = self._time + (arg_10_3 or self._screen_text_time)
	else
		self._screen_text = {
			text_id = Gui.text(_gui, arg_10_1, str_2, arg_10_2, str, var_10_8, Color(arg_10_4.x, arg_10_4.y, arg_10_4.z)),
			bgr_id = Gui.rect(_gui, var_10_14, var_10_15, Color(120, 0, 0, 0)),
			time = self._time + (arg_10_3 or self._screen_text_time)
		}
	end
end

DebugTextManager.destroy = function (self)
	-- function 11
	if not self._screen_text then
		Gui.destroy_text(self._gui, self._screen_text.text_id)
		Gui.destroy_rect(self._gui, self._screen_text.bgr_id)

		self._screen_text = nil
	end

	for k, v in pairs(self._unit_texts) do
		self:_destroy_unit_texts(k)
	end

	for k_2, v_2 in pairs(self._world_texts) do
		for i, v_3 in ipairs(v_2) do
			Gui.destroy_text_3d(self._world_gui, v_3.id)
		end
	end
end

DebugTextManager._destroy_unit_texts = function (self, arg_12_1)
	-- function 12
	local var_12_0 = self._unit_texts[arg_12_1]

	for k, v in pairs(var_12_0) do
		for i, v_2 in ipairs(v) do
			Gui.destroy_text_3d(self._world_gui, v_2.id)
		end
	end

	self._unit_texts[arg_12_1] = nil
end
