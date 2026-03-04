-- chunkname: @scripts/managers/debug/debug_text_manager.lua

DebugTextManager = class(DebugTextManager)

function DebugTextManager.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0._world = arg_1_1
	arg_1_0._gui = arg_1_2
	arg_1_0._world_gui = World.create_world_gui(arg_1_1, Matrix4x4.identity(), 1, 1, "material", "materials/fonts/gw_fonts", "immediate")
	arg_1_0._time = 0
	arg_1_0._screen_text_size = 50
	arg_1_0._screen_text_time = 5
	arg_1_0._screen_text_bgr = nil
	arg_1_0._screen_text = nil
	arg_1_0._unit_text_size = 0.2
	arg_1_0._unit_text_time = math.huge
	arg_1_0._unit_texts = {}
	arg_1_0._world_text_size = 0.6
	arg_1_0._world_text_time = math.huge
	arg_1_0._world_texts = {}
end

function DebugTextManager.update(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._time = arg_2_0._time + arg_2_1

	if script_data and script_data.disable_debug_draw then
		return
	end

	arg_2_0:_update_unit_texts(arg_2_2, arg_2_1)
	arg_2_0:_update_world_texts(arg_2_2)
	arg_2_0:_update_screen_text()
end

function DebugTextManager._update_unit_texts(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = Managers.state.camera:camera_rotation(arg_3_1)
	local var_3_1 = arg_3_0._world_gui
	local var_3_2 = "arial"
	local var_3_3 = arg_3_0._unit_text_size
	local var_3_4 = "materials/fonts/" .. var_3_2

	for iter_3_0, iter_3_1 in pairs(arg_3_0._unit_texts) do
		if Unit.alive(iter_3_0) then
			for iter_3_2, iter_3_3 in pairs(iter_3_1) do
				for iter_3_4, iter_3_5 in ipairs(iter_3_3) do
					if arg_3_0._time > iter_3_5.time then
						Gui.destroy_text_3d(arg_3_0._world_gui, iter_3_5.id)
						table.remove(iter_3_3, iter_3_4)
					else
						local var_3_5 = Vector3(iter_3_5.offset.x, iter_3_5.offset.y, iter_3_5.offset.z)
						local var_3_6 = Matrix4x4.from_quaternion_position(var_3_0, Unit.world_position(iter_3_0, iter_3_5.node_index) + var_3_5)
						local var_3_7 = Vector3(iter_3_5.text_offset.x, iter_3_5.text_offset.y, iter_3_5.text_offset.z)
						local var_3_8

						if iter_3_5.fade then
							local var_3_9 = (iter_3_5.time - arg_3_0._time) / (iter_3_5.time - iter_3_5.starting_time) * 255

							var_3_8 = Color(var_3_9, iter_3_5.color.r, iter_3_5.color.g, iter_3_5.color.b)
						else
							var_3_8 = Color(iter_3_5.color.r, iter_3_5.color.g, iter_3_5.color.b)
						end

						local var_3_10 = iter_3_5.floating_position_box

						if var_3_10 then
							local var_3_11 = var_3_10:unbox() + Vector3.forward() * arg_3_2 * 0.5

							var_3_7 = var_3_7 + var_3_11

							iter_3_5.floating_position_box:store(var_3_11)
						end

						Gui.update_text_3d(var_3_1, iter_3_5.id, iter_3_5.text, var_3_4, iter_3_5.text_size, var_3_2, var_3_6, var_3_7, 0, var_3_8)
					end
				end
			end
		else
			arg_3_0:_destroy_unit_texts(iter_3_0)
		end
	end
end

function DebugTextManager._update_world_texts(arg_4_0, arg_4_1)
	local var_4_0 = Managers.state.camera:camera_rotation(arg_4_1)
	local var_4_1 = arg_4_0._world_gui
	local var_4_2 = arg_4_0._world_text_size
	local var_4_3 = "arial"
	local var_4_4 = "materials/fonts/" .. var_4_3

	for iter_4_0, iter_4_1 in pairs(arg_4_0._world_texts) do
		for iter_4_2, iter_4_3 in ipairs(iter_4_1) do
			if arg_4_0._time > iter_4_3.time then
				Gui.destroy_text_3d(arg_4_0._world_gui, iter_4_3.id)
				table.remove(iter_4_1, iter_4_2)
			else
				local var_4_5 = Vector3(iter_4_3.position.x, iter_4_3.position.y, iter_4_3.position.z)
				local var_4_6 = Vector3(iter_4_3.text_offset.x, iter_4_3.text_offset.y, iter_4_3.text_offset.z)
				local var_4_7 = Matrix4x4.from_quaternion_position(var_4_0, var_4_5)
				local var_4_8 = Color(iter_4_3.color.r, iter_4_3.color.g, iter_4_3.color.b)

				Gui.update_text_3d(var_4_1, iter_4_3.id, iter_4_3.text, var_4_4, iter_4_3.text_size, var_4_3, var_4_7, var_4_6, 0, var_4_8)
			end
		end
	end
end

function DebugTextManager._update_screen_text(arg_5_0)
	if arg_5_0._screen_text and arg_5_0._time > arg_5_0._screen_text.time then
		Gui.destroy_text(arg_5_0._gui, arg_5_0._screen_text.text_id)
		Gui.destroy_rect(arg_5_0._gui, arg_5_0._screen_text.bgr_id)

		arg_5_0._screen_text = nil
	end
end

function DebugTextManager.output_unit_text(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7, arg_6_8, arg_6_9, arg_6_10, arg_6_11)
	if script_data and script_data.disable_debug_draw then
		return
	end

	arg_6_4 = arg_6_4 or 0
	arg_6_2 = arg_6_2 or arg_6_0._unit_text_size

	local var_6_0 = arg_6_0._world_gui
	local var_6_1 = "arial"
	local var_6_2 = "materials/fonts/" .. var_6_1
	local var_6_3

	if arg_6_9 then
		local var_6_4 = Managers.state.camera:camera_rotation(arg_6_9)

		var_6_3 = Matrix4x4.from_quaternion_position(var_6_4, Unit.world_position(arg_6_3, arg_6_4) + arg_6_5)
	else
		var_6_3 = Unit.world_pose(arg_6_3, arg_6_4)
	end

	local var_6_5, var_6_6 = Gui.text_extents(var_6_0, arg_6_1, var_6_2, arg_6_2)
	local var_6_7 = var_6_6[1] - var_6_5[1]
	local var_6_8 = var_6_6[2] - var_6_5[2]
	local var_6_9 = Vector3(-var_6_7 / 2, -var_6_8 / 2, 0)

	arg_6_5 = arg_6_5 or Vector3(0, 0, 0)
	arg_6_7 = arg_6_7 or "none"
	arg_6_8 = arg_6_8 or Vector3(255, 255, 255)

	local var_6_10

	if arg_6_10 then
		var_6_10 = Vector3Box(Vector3.zero())
	end

	local var_6_11 = {
		alpha = 255,
		id = Gui.text_3d(var_6_0, arg_6_1, var_6_2, arg_6_2, var_6_1, var_6_3, var_6_9, 0, Color(arg_6_8.x, arg_6_8.y, arg_6_8.z)),
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
		time = arg_6_0._time + (arg_6_6 or arg_6_0._unit_text_time),
		floating_position_box = var_6_10,
		fade = arg_6_11,
		starting_time = arg_6_0._time
	}

	arg_6_0._unit_texts[arg_6_3] = arg_6_0._unit_texts[arg_6_3] or {}
	arg_6_0._unit_texts[arg_6_3][arg_6_7] = arg_6_0._unit_texts[arg_6_3][arg_6_7] or {}
	arg_6_0._unit_texts[arg_6_3][arg_6_7][#arg_6_0._unit_texts[arg_6_3][arg_6_7] + 1] = var_6_11
end

function DebugTextManager.clear_unit_text(arg_7_0, arg_7_1, arg_7_2)
	for iter_7_0, iter_7_1 in pairs(arg_7_0._unit_texts) do
		if not arg_7_1 or arg_7_1 == iter_7_0 then
			for iter_7_2, iter_7_3 in pairs(iter_7_1) do
				if not arg_7_2 or iter_7_2 == "none" or arg_7_2 == iter_7_2 then
					for iter_7_4 = #iter_7_3, 1, -1 do
						local var_7_0 = iter_7_3[iter_7_4]

						Gui.destroy_text_3d(arg_7_0._world_gui, var_7_0.id)
						table.remove(iter_7_3, iter_7_4)
					end
				end
			end
		end
	end
end

function DebugTextManager.output_world_text(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7, arg_8_8)
	if script_data and script_data.disable_debug_draw then
		return
	end

	arg_8_2 = arg_8_2 or arg_8_0._world_text_size

	local var_8_0 = arg_8_0._world_gui
	local var_8_1 = "arial"
	local var_8_2 = "materials/fonts/" .. var_8_1
	local var_8_3

	if arg_8_7 then
		local var_8_4 = Managers.state.camera:camera_rotation(arg_8_7)

		var_8_3 = Matrix4x4.from_quaternion_position(var_8_4, arg_8_3)
	else
		var_8_3 = Matrix4x4.from_quaternion_position(arg_8_8 and Quaternion.inverse(arg_8_8) or Quaternion.identity(), arg_8_3)
	end

	local var_8_5, var_8_6 = Gui.text_extents(var_8_0, arg_8_1, var_8_2, arg_8_2)
	local var_8_7 = var_8_6[1] - var_8_5[1]
	local var_8_8 = var_8_6[2] - var_8_5[2]
	local var_8_9 = Vector3(-var_8_7 / 2, -var_8_8 / 2, 0)

	arg_8_5 = arg_8_5 or "none"
	arg_8_6 = arg_8_6 or Vector3(255, 255, 255)

	local var_8_10 = {
		id = Gui.text_3d(var_8_0, arg_8_1, var_8_2, arg_8_2, var_8_1, var_8_3, var_8_9, 0, Color(arg_8_6.x, arg_8_6.y, arg_8_6.z)),
		text = arg_8_1,
		text_size = arg_8_2,
		position = {
			x = arg_8_3.x,
			y = arg_8_3.y,
			z = arg_8_3.z
		},
		text_offset = {
			x = var_8_9.x,
			y = var_8_9.y,
			z = var_8_9.z
		},
		color = {
			r = arg_8_6.x,
			g = arg_8_6.y,
			b = arg_8_6.z
		},
		time = arg_8_0._time + (arg_8_4 or arg_8_0._world_text_time)
	}

	arg_8_0._world_texts[arg_8_5] = arg_8_0._world_texts[arg_8_5] or {}
	arg_8_0._world_texts[arg_8_5][#arg_8_0._world_texts[arg_8_5] + 1] = var_8_10
end

function DebugTextManager.clear_world_text(arg_9_0, arg_9_1)
	for iter_9_0, iter_9_1 in pairs(arg_9_0._world_texts) do
		if not arg_9_1 or iter_9_0 == "none" or arg_9_1 == iter_9_0 then
			for iter_9_2 = #iter_9_1, 1, -1 do
				local var_9_0 = iter_9_1[iter_9_2]

				Gui.destroy_text_3d(arg_9_0._world_gui, var_9_0.id)
				table.remove(iter_9_1, iter_9_2)
			end
		end
	end
end

function DebugTextManager.output_screen_text(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	if script_data and script_data.disable_debug_draw then
		return
	end

	arg_10_2 = arg_10_2 or arg_10_0._screen_text_size
	arg_10_4 = arg_10_4 or Vector3(255, 255, 255)

	local var_10_0 = arg_10_0._gui
	local var_10_1 = Vector2(RESOLUTION_LOOKUP.res_w, RESOLUTION_LOOKUP.res_h)
	local var_10_2 = "arial"
	local var_10_3 = "materials/fonts/" .. var_10_2
	local var_10_4, var_10_5 = Gui.text_extents(var_10_0, arg_10_1, var_10_3, arg_10_2)
	local var_10_6 = var_10_5[1] - var_10_4[1]
	local var_10_7 = var_10_5[2] - var_10_4[2]
	local var_10_8 = Vector3(var_10_1.x / 2 - var_10_6 / 2, var_10_1.y / 2 - var_10_7 / 2, 11)
	local var_10_9 = 10
	local var_10_10 = var_10_8.x - var_10_9
	local var_10_11 = var_10_8.y - var_10_9
	local var_10_12 = var_10_6 + var_10_9 * 2
	local var_10_13 = var_10_7 + var_10_9 * 2
	local var_10_14 = Vector3(var_10_10, var_10_11, 10)
	local var_10_15 = Vector2(var_10_12, var_10_13)

	if arg_10_0._screen_text then
		Gui.update_text(var_10_0, arg_10_0._screen_text.text_id, arg_10_1, var_10_3, arg_10_2, var_10_2, var_10_8, Color(arg_10_4.x, arg_10_4.y, arg_10_4.z))
		Gui.update_rect(var_10_0, arg_10_0._screen_text.bgr_id, var_10_14, var_10_15, Color(120, 0, 0, 0))

		arg_10_0._screen_text.time = arg_10_0._time + (arg_10_3 or arg_10_0._screen_text_time)
	else
		arg_10_0._screen_text = {
			text_id = Gui.text(var_10_0, arg_10_1, var_10_3, arg_10_2, var_10_2, var_10_8, Color(arg_10_4.x, arg_10_4.y, arg_10_4.z)),
			bgr_id = Gui.rect(var_10_0, var_10_14, var_10_15, Color(120, 0, 0, 0)),
			time = arg_10_0._time + (arg_10_3 or arg_10_0._screen_text_time)
		}
	end
end

function DebugTextManager.destroy(arg_11_0)
	if arg_11_0._screen_text then
		Gui.destroy_text(arg_11_0._gui, arg_11_0._screen_text.text_id)
		Gui.destroy_rect(arg_11_0._gui, arg_11_0._screen_text.bgr_id)

		arg_11_0._screen_text = nil
	end

	for iter_11_0, iter_11_1 in pairs(arg_11_0._unit_texts) do
		arg_11_0:_destroy_unit_texts(iter_11_0)
	end

	for iter_11_2, iter_11_3 in pairs(arg_11_0._world_texts) do
		for iter_11_4, iter_11_5 in ipairs(iter_11_3) do
			Gui.destroy_text_3d(arg_11_0._world_gui, iter_11_5.id)
		end
	end
end

function DebugTextManager._destroy_unit_texts(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0._unit_texts[arg_12_1]

	for iter_12_0, iter_12_1 in pairs(var_12_0) do
		for iter_12_2, iter_12_3 in ipairs(iter_12_1) do
			Gui.destroy_text_3d(arg_12_0._world_gui, iter_12_3.id)
		end
	end

	arg_12_0._unit_texts[arg_12_1] = nil
end
