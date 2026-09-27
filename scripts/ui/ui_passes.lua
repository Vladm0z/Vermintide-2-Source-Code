-- chunkname: @scripts/ui/ui_passes.lua

require("scripts/utils/colors")
require("scripts/settings/ui_settings")
require("scripts/settings/inventory_settings")
require("scripts/settings/ui_frame_settings")
require("scripts/utils/utf8_utils")
require("scripts/ui/ui_passes_tooltips")

local UIRenderer = UIRenderer
local draw_texture = UIRenderer.draw_texture
local draw_texture_uv = UIRenderer.draw_texture_uv
local UIInverseScaleVectorToResolution = UIInverseScaleVectorToResolution
local UIGetFontHeight = UIGetFontHeight
local UIScaleVectorToResolution = UIScaleVectorToResolution
local ScaleVectorToResolution = ScaleVectorToResolution
local string = string
local math = math
local UIPasses = UIPasses

UIPasses = UIPasses or {}
UIPasses = UIPasses
UIPasses.nop = {
	init = NOP,
	draw = NOP,
	update = NOP
}
UIPasses.rect = {
	init = function (self)
		-- function 1
		if not self.retained_mode then
			return {
				dirty = true
			}
		end
	end,
	destroy = function (arg_2_0, arg_2_1, arg_2_2)
		-- function 2
		assert(arg_2_2.retained_mode, "why u destroy immediate pass?")

		if not arg_2_1.retained_id then
			UIRenderer.destroy_bitmap(arg_2_0, arg_2_1.retained_id)

			arg_2_1.retained_id = nil
		end
	end,
	draw = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7, arg_3_8, arg_3_9)
		-- function 3
		local white = Colors.color_definitions.white

		if not arg_3_4 then
			local texture_size = arg_3_4.texture_size

			if not texture_size then
				UIUtils.align_box_inplace(arg_3_4, arg_3_6, arg_3_7, texture_size)

				arg_3_7 = texture_size
			end

			white = arg_3_4.color or white
		end

		if not arg_3_3.retained_mode then
			local retained_mode = arg_3_3.retained_mode

			if not retained_mode then
				if not arg_3_1.retained_id then
					retained_mode = arg_3_1.retained_id

					if not retained_mode then
						-- Nothing
					end
				end

				retained_mode = true
			end

			::label_3_0::

			local draw_rect = UIRenderer.draw_rect(arg_3_0, arg_3_6, arg_3_7, white, retained_mode)

			arg_3_1.retained_id = not draw_rect and draw_rect and arg_3_1.retained_id
			arg_3_1.dirty = false
		else
			UIRenderer.draw_rect(arg_3_0, arg_3_6, arg_3_7, white)
		end
	end
}
UIPasses.texture = {
	init = function (self, arg_4_1, arg_4_2, arg_4_3)
		-- function 4
		if not self.clone and not arg_4_3 then
			local gui = arg_4_3.gui

			if not self.retained_mode then
				gui = arg_4_3.gui_retained
			end

			local texture_id = self.texture_id

			texture_id = texture_id or "texture_id"

			local var_4_2 = arg_4_1[texture_id]
			local guid = Application.guid()

			Gui.clone_material_from_template(gui, guid, var_4_2)

			self.cloned_material = guid

			local texture_id_2 = self.texture_id

			texture_id_2 = texture_id_2 or "texture_id"
			arg_4_1[texture_id_2] = guid
		end

		if not self.material_func and not arg_4_3 then
			local gui_2 = arg_4_3.gui

			if not self.retained_mode then
				gui_2 = arg_4_3.gui_retained
			end

			local context = self.context
			local texture_id_3 = self.texture_id

			texture_id_3 = texture_id_3 or "texture_id"

			local var_4_8 = arg_4_1[texture_id_3]

			self.material_func(gui_2, var_4_8, context)
		end

		if not self.retained_mode then
			return {
				dirty = true
			}
		end
	end,
	destroy = function (arg_5_0, arg_5_1, arg_5_2)
		-- function 5
		assert(arg_5_2.retained_mode, "Attempted to destroy an immediate mode pass")

		if not arg_5_1.retained_id then
			UIRenderer.destroy_bitmap(arg_5_0, arg_5_1.retained_id)

			arg_5_1.retained_id = nil
		end
	end,
	draw = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7, arg_6_8, arg_6_9)
		-- function 6
		local texture_id = arg_6_3.texture_id

		texture_id = texture_id or "texture_id"

		local var_6_1 = arg_6_5[texture_id]
		local var_6_2
		local var_6_3
		local var_6_4
		local var_6_5
		local var_6_6

		if not arg_6_4 then
			local texture_size = arg_6_4.texture_size

			if not texture_size then
				UIUtils.align_box_inplace(arg_6_4, arg_6_6, arg_6_7, texture_size)

				arg_6_7 = texture_size
			end

			var_6_2 = arg_6_4.color
			var_6_3 = arg_6_4.masked
			var_6_4 = arg_6_4.saturated
			var_6_5 = arg_6_4.point_sample
			var_6_6 = arg_6_4.viewport_mask
		end

		if not arg_6_3.retained_mode then
			local retained_mode = arg_6_3.retained_mode

			if not retained_mode then
				retained_mode = arg_6_1.retained_id
				retained_mode = retained_mode or true
			end

			arg_6_1.retained_id = draw_texture(arg_6_0, var_6_1, arg_6_6, arg_6_7, var_6_2, var_6_3, var_6_4, retained_mode, var_6_5, var_6_6) or arg_6_1.retained_id
			arg_6_1.dirty = false
		else
			draw_texture(arg_6_0, var_6_1, arg_6_6, arg_6_7, var_6_2, var_6_3, var_6_4, nil, var_6_5, var_6_6)
		end
	end
}
UIPasses.texture_uv = {
	init = function (self)
		-- function 7
		if not self.retained_mode then
			return {
				dirty = true
			}
		end

		return self.content_id
	end,
	destroy = function (arg_8_0, arg_8_1, arg_8_2)
		-- function 8
		assert(arg_8_2.retained_mode, "why u destroy immediate pass?")

		if not arg_8_1.retained_id then
			UIRenderer.destroy_bitmap(arg_8_0, arg_8_1.retained_id)

			arg_8_1.retained_id = nil
		end
	end,
	draw = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7, arg_9_8, arg_9_9)
		-- function 9
		local uvs = arg_9_5.uvs
		local texture_id = arg_9_3.texture_id

		texture_id = texture_id or "texture_id"

		local var_9_2 = arg_9_5[texture_id]
		local var_9_3
		local var_9_4
		local var_9_5
		local var_9_6
		local var_9_7

		if not arg_9_4 then
			local texture_size = arg_9_4.texture_size

			if not texture_size then
				if arg_9_4.horizontal_alignment == "right" then
					arg_9_6[1] = arg_9_6[1] + arg_9_7[1] - texture_size[1]
				elseif arg_9_4.horizontal_alignment == "center" then
					arg_9_6[1] = arg_9_6[1] + (arg_9_7[1] - texture_size[1]) / 2
				end

				if arg_9_4.vertical_alignment == "center" then
					arg_9_6[2] = arg_9_6[2] + (arg_9_7[2] - texture_size[2]) / 2
				elseif arg_9_4.vertical_alignment == "top" then
					arg_9_6[2] = arg_9_6[2] + arg_9_7[2] - texture_size[2]
				end

				arg_9_7 = texture_size
			end

			var_9_3 = arg_9_4.color
			var_9_4 = arg_9_4.masked
			var_9_5 = arg_9_4.saturated
			var_9_7 = arg_9_4.point_sample
			var_9_6 = arg_9_4.viewport_mask
		end

		if not arg_9_3.retained_mode then
			local retained_mode = arg_9_3.retained_mode

			if not retained_mode then
				if not arg_9_1.retained_id then
					retained_mode = arg_9_1.retained_id

					if not retained_mode then
						-- Nothing
					end
				end

				retained_mode = true
			end

			::label_9_0::

			local var_9_10 = draw_texture_uv(arg_9_0, var_9_2, arg_9_6, arg_9_7, uvs, var_9_3, var_9_4, var_9_5, retained_mode, var_9_7, var_9_6)

			arg_9_1.retained_id = not var_9_10 and var_9_10 and arg_9_1.retained_id
			arg_9_1.dirty = false
		else
			draw_texture_uv(arg_9_0, var_9_2, arg_9_6, arg_9_7, uvs, var_9_3, var_9_4, var_9_5, nil, var_9_7, var_9_6)
		end
	end
}

local tbl = {
	0,
	0,
	0
}

UIPasses.texture_uv_dynamic_color_uvs_size_offset = {
	init = function (self)
		-- function 10
		if not self.retained_mode then
			return {
				dirty = true
			}
		end

		return nil
	end,
	destroy = function (arg_11_0, arg_11_1, arg_11_2)
		-- function 11
		assert(arg_11_2.retained_mode, "why u destroy immediate pass?")

		if not arg_11_1.retained_id then
			UIRenderer.destroy_bitmap(arg_11_0, arg_11_1.retained_id)

			arg_11_1.retained_id = nil
		end
	end,
	draw = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6, arg_12_7, arg_12_8, arg_12_9)
		-- function 12
		arg_12_5 = not arg_12_3.content_id and arg_12_5[arg_12_3.content_id] and arg_12_5
		arg_12_4 = not arg_12_3.style_id and arg_12_4[arg_12_3.style_id] and arg_12_4

		local dynamic_function, var_12_1, var_12_2, var_12_3 = arg_12_3.dynamic_function(arg_12_5, arg_12_4, arg_12_7, arg_12_9, arg_12_0)
		local texture_index = arg_12_5.texture_index
		local var_12_6

		if not texture_index then
			local texture_id = arg_12_3.texture_id

			texture_id = texture_id or "texture_id"
			var_12_6 = arg_12_5[texture_id][texture_index]

			if not var_12_6 then
				-- Nothing
			end
		end

		do
			local texture_id_2 = arg_12_3.texture_id

			texture_id_2 = texture_id_2 or "texture_id"
			var_12_6 = arg_12_5[texture_id_2]
		end

		::label_12_0::

		if not var_12_3 then
			arg_12_6 = arg_12_6 + Vector3(var_12_3[1], var_12_3[2], var_12_3[3])
		end

		if not arg_12_3.retained_mode then
			local retained_mode = arg_12_3.retained_mode

			if not retained_mode then
				if not arg_12_1.retained_id then
					retained_mode = arg_12_1.retained_id

					if not retained_mode then
						-- Nothing
					end
				end

				retained_mode = true
			end

			::label_12_1::

			local var_12_9 = draw_texture_uv(arg_12_0, var_12_6, arg_12_6, var_12_2, var_12_1, dynamic_function, not arg_12_4 and arg_12_4.masked, not arg_12_4 and arg_12_4.saturated, retained_mode)

			arg_12_1.retained_id = not var_12_9 and var_12_9 and arg_12_1.retained_id
			arg_12_1.dirty = false
		else
			return draw_texture_uv(arg_12_0, var_12_6, arg_12_6, var_12_2, var_12_1, dynamic_function, not arg_12_4 and arg_12_4.masked, not arg_12_4 and arg_12_4.saturated)
		end

		return draw_texture_uv(arg_12_0, var_12_6, arg_12_6, var_12_2, var_12_1, dynamic_function, not arg_12_4 and arg_12_4.masked, not arg_12_4 and arg_12_4.saturated)
	end
}

local tbl_2 = {
	0,
	0,
	0
}

UIPasses.list_pass = {
	init = function (self)
		-- function 13
		local passes = self.passes
		local count = #passes
		local tbl = {}

		for i = 1, count do
			tbl[i] = UIPasses[passes[i].pass_type].init(passes[i])
		end

		return {
			num_passes = count,
			sub_pass_datas = tbl
		}
	end,
	draw = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6, arg_14_7, arg_14_8, arg_14_9)
		-- function 14
		local num_list_elements = arg_14_1.num_list_elements

		if not num_list_elements then
			num_list_elements = #arg_14_5
			arg_14_1.num_list_elements = num_list_elements
		end

		local num_passes = arg_14_1.num_passes
		local passes = arg_14_3.passes
		local sub_pass_datas = arg_14_1.sub_pass_datas
		local list_member_offset = arg_14_4.list_member_offset
		local alloc_table = FrameTable.alloc_table()
		local alloc_table_2 = FrameTable.alloc_table()
		local columns = arg_14_4.columns
		local column_offset = arg_14_4.column_offset

		tbl_2[1] = arg_14_6[1]
		tbl_2[2] = arg_14_6[2]
		tbl_2[3] = arg_14_6[3]

		local start_index = arg_14_4.start_index
		local num = arg_14_4.num_draws - 1
		local min = math.min(start_index + num, num_list_elements)

		if not arg_14_4.scenegraph_id then
			local size = arg_14_2[arg_14_4.scenegraph_id].size
			local num_2 = num * list_member_offset[1] + arg_14_7[1]
			local num_3 = num * list_member_offset[2] + arg_14_7[2]

			if arg_14_4.horizontal_alignment == "center" then
				tbl_2[1] = arg_14_6[1] + size[1] / 2 - num_2 / 2
			elseif arg_14_4.horizontal_alignment == "right" then
				tbl_2[1] = arg_14_6[1] + size[1] - num_2
			end

			if arg_14_4.vertical_alignment == "center" then
				tbl_2[2] = arg_14_6[2] + size[2] / 2 - num_3 / 2
			elseif arg_14_4.vertical_alignment == "top" then
				tbl_2[2] = arg_14_6[2] + size[2] - math.abs(list_member_offset[2])
			end
		end

		alloc_table[1] = tbl_2[1]
		alloc_table[2] = tbl_2[2]
		alloc_table[3] = tbl_2[3]

		local num_4 = 0
		local num_5 = 0

		if not IS_PS4 then
			num_4, num_5 = 0, math.max(start_index - 1, 0)
		end

		local var_14_17

		for i = start_index, min do
			num_4 = num_4 + 1

			local var_14_18 = arg_14_5[i]

			var_14_18.parent = arg_14_5.parent

			local var_14_19

			if not arg_14_4.item_styles then
				var_14_19 = arg_14_4.item_styles[i]

				if not var_14_19 then
					-- Nothing
				end
			end

			var_14_19 = arg_14_4

			::label_14_0::

			local list_member_offset_2 = var_14_19.list_member_offset
			local var_14_21
			local flag

			if not columns then
				var_14_21 = num_4 % columns

				if var_14_21 == 0 then
					var_14_21 = columns - 1
					flag = true
				else
					var_14_21 = var_14_21 - 1
					flag = false
				end
			else
				flag = true
			end

			if not list_member_offset_2 then
				if not var_14_21 then
					alloc_table[1] = tbl_2[1] + column_offset * var_14_21
					alloc_table[2] = tbl_2[2] + list_member_offset_2[2] * num_5
					alloc_table[3] = tbl_2[3] + list_member_offset_2[3]
				else
					alloc_table[1] = tbl_2[1] + list_member_offset_2[1] * num_5
					alloc_table[2] = tbl_2[2] + list_member_offset_2[2] * num_5
					alloc_table[3] = tbl_2[3] + list_member_offset_2[3]
				end
			elseif not var_14_21 then
				alloc_table[1] = tbl_2[1] + column_offset * var_14_21
				alloc_table[2] = tbl_2[2] + list_member_offset[2] * num_5
				alloc_table[3] = tbl_2[3] + list_member_offset[3]
			else
				alloc_table[1] = tbl_2[1] + list_member_offset[1] * num_5
				alloc_table[2] = tbl_2[2] + list_member_offset[2] * num_5
				alloc_table[3] = tbl_2[3] + list_member_offset[3]
			end

			for j = 1, num_passes do
				alloc_table_2[1] = alloc_table[1]
				alloc_table_2[2] = alloc_table[2]
				alloc_table_2[3] = alloc_table[3]

				local var_14_23 = passes[j]
				local content_id = var_14_23.content_id
				local var_14_25

				if not content_id then
					var_14_25 = var_14_18[content_id]
					var_14_25.parent = var_14_18
				else
					var_14_25 = var_14_18
				end

				local style_id = var_14_23.style_id
				local var_14_27

				if not style_id then
					var_14_27 = var_14_19[style_id]

					if not var_14_27 then
						-- Nothing
					end
				end

				var_14_27 = var_14_19

				do
					local var_14_28
				end

				::label_14_1::

				if not var_14_27 and not var_14_27.size then
					var_14_28 = Vector2(unpack(var_14_27.size))

					if not var_14_28 then
						-- Nothing
					end
				end

				var_14_28 = arg_14_7

				::label_14_2::

				local flag_2 = not var_14_27 and var_14_27.offset

				if not flag_2 then
					alloc_table_2[1] = alloc_table_2[1] + flag_2[1]
					alloc_table_2[2] = alloc_table_2[2] + flag_2[2]
					alloc_table_2[3] = alloc_table_2[3] + flag_2[3]
				end

				local var_14_30 = sub_pass_datas[j]
				local flag_3 = var_14_25.visible ~= false
				local content_check_function = var_14_23.content_check_function

				if not (not content_check_function and content_check_function(var_14_25, var_14_27, i)) then
					flag_3 = false
				end

				local content_change_function = var_14_23.content_change_function

				if not flag_3 and not content_change_function then
					content_change_function(var_14_25, var_14_27, i)
				end

				if not flag_3 then
					UIPasses[var_14_23.pass_type].draw(arg_14_0, var_14_30, arg_14_2, var_14_23, var_14_27, var_14_25, Vector3(unpack(alloc_table_2)), var_14_28, arg_14_8, arg_14_9)
				end
			end

			if not flag then
				num_5 = num_5 + 1
			end
		end
	end
}
UIPasses.gradient_mask_texture = {
	init = function (self, arg_15_1, arg_15_2, arg_15_3)
		-- function 15
		if not self.clone and not arg_15_3 then
			local gui = arg_15_3.gui

			if not self.retained_mode then
				gui = arg_15_3.gui_retained
			end

			local texture_id = self.texture_id

			texture_id = texture_id or "texture_id"

			local var_15_2 = arg_15_1[texture_id]
			local guid = Application.guid()

			Gui.clone_material_from_template(gui, guid, var_15_2)

			self.cloned_material = guid

			local texture_id_2 = self.texture_id

			texture_id_2 = texture_id_2 or "texture_id"
			arg_15_1[texture_id_2] = guid

			if not UIAtlasHelper.has_atlas_settings_by_texture_name(var_15_2) then
				UIAtlasHelper.add_standalone_texture_by_name(guid)
			end
		end

		if not self.retained_mode then
			return {
				dirty = true
			}
		end
	end,
	destroy = function (arg_16_0, arg_16_1, arg_16_2)
		-- function 16
		assert(arg_16_2.retained_mode, "why u destroy immediate pass?")

		if not arg_16_1.retained_id then
			UIRenderer.destroy_bitmap(arg_16_0, arg_16_1.retained_id)

			arg_16_1.retained_id = nil
		end
	end,
	draw = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, arg_17_9)
		-- function 17
		local var_17_0
		local flag = false
		local num = 1

		if not arg_17_4 then
			local texture_size = arg_17_4.texture_size

			if not texture_size then
				if arg_17_4.horizontal_alignment == "right" then
					arg_17_6[1] = arg_17_6[1] + arg_17_7[1] - texture_size[1]
				elseif arg_17_4.horizontal_alignment == "center" then
					arg_17_6[1] = arg_17_6[1] + (arg_17_7[1] - texture_size[1]) / 2
				end

				if arg_17_4.vertical_alignment == "center" then
					arg_17_6[2] = arg_17_6[2] + (arg_17_7[2] - texture_size[2]) / 2
				elseif arg_17_4.vertical_alignment == "top" then
					arg_17_6[2] = arg_17_6[2] + arg_17_7[2] - texture_size[2]
				end

				arg_17_7 = texture_size
			end

			var_17_0 = arg_17_4.color
			flag = arg_17_4.masked
			num = arg_17_4.gradient_threshold or num
		end

		local texture_id = arg_17_3.texture_id

		texture_id = texture_id or "texture_id"

		if not arg_17_3.retained_mode then
			local retained_mode = arg_17_3.retained_mode

			if not retained_mode then
				if not arg_17_1.retained_id then
					retained_mode = arg_17_1.retained_id

					if not retained_mode then
						-- Nothing
					end
				end

				retained_mode = true
			end

			::label_17_0::

			local draw_gradient_mask_texture = UIRenderer.draw_gradient_mask_texture(arg_17_0, arg_17_5[texture_id], arg_17_6, arg_17_7, var_17_0, flag, num, retained_mode)

			arg_17_1.retained_id = not draw_gradient_mask_texture and draw_gradient_mask_texture and arg_17_1.retained_id
			arg_17_1.dirty = false
		else
			UIRenderer.draw_gradient_mask_texture(arg_17_0, arg_17_5[texture_id], arg_17_6, arg_17_7, var_17_0, flag, num)
		end
	end
}
UIPasses.texture_frame = {
	init = function (self, arg_18_1, arg_18_2)
		-- function 18
		if not self.retained_mode then
			return {
				dirty = true
			}
		end

		return nil
	end,
	destroy = function (arg_19_0, arg_19_1, arg_19_2)
		-- function 19
		assert(arg_19_2.retained_mode, "why u destroy immediate pass?")

		local retained_ids = arg_19_1.retained_ids

		if not retained_ids then
			for i = 1, #retained_ids do
				UIRenderer.destroy_bitmap(arg_19_0, retained_ids[i])
			end

			arg_19_1.retained_ids = nil
		end
	end,
	draw = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6, arg_20_7, arg_20_8, arg_20_9)
		-- function 20
		local var_20_0
		local var_20_1
		local var_20_2
		local var_20_3
		local var_20_4
		local var_20_5
		local var_20_6
		local var_20_7
		local var_20_8
		local var_20_9
		local var_20_10
		local texture_id = arg_20_3.texture_id

		texture_id = texture_id or "texture_id"

		if not arg_20_4 then
			local area_size = arg_20_4.area_size

			if not area_size then
				if arg_20_4.horizontal_alignment == "right" then
					arg_20_6[1] = arg_20_6[1] + arg_20_7[1] - area_size[1]
				elseif arg_20_4.horizontal_alignment == "center" then
					arg_20_6[1] = arg_20_6[1] + (arg_20_7[1] - area_size[1]) / 2
				end

				if arg_20_4.vertical_alignment == "center" then
					arg_20_6[2] = arg_20_6[2] + (arg_20_7[2] - area_size[2]) / 2
				elseif arg_20_4.vertical_alignment == "top" then
					arg_20_6[2] = arg_20_6[2] + arg_20_7[2] - area_size[2]
				end

				var_20_10 = Vector2(area_size[1], area_size[2])
			end

			local frame_margins = arg_20_4.frame_margins

			if not frame_margins then
				var_20_9 = Vector3(arg_20_6[1] + frame_margins[1], arg_20_6[2] + frame_margins[2], arg_20_6[3])

				if not var_20_10 then
					var_20_10[1] = var_20_10[1] - frame_margins[1] * 2
					var_20_10[2] = var_20_10[2] - frame_margins[2] * 2
				else
					var_20_10 = Vector2(arg_20_7[1] - frame_margins[1] * 2, arg_20_7[2] - frame_margins[2] * 2)
				end
			end

			var_20_9 = var_20_9 or arg_20_6
			var_20_10 = var_20_10 or arg_20_7
			var_20_0 = arg_20_4.texture_size
			var_20_1 = arg_20_4.texture_sizes
			var_20_2 = arg_20_4.color
			var_20_3 = arg_20_4.masked
			var_20_4 = arg_20_4.saturated
			var_20_5 = arg_20_4.only_corners
			var_20_6 = arg_20_4.skip_background
			var_20_7 = arg_20_4.use_tiling
			var_20_8 = arg_20_4.mirrored_tiling
		end

		if not arg_20_3.retained_mode then
			local retained_mode = arg_20_3.retained_mode

			if not retained_mode then
				if not arg_20_1.retained_ids then
					retained_mode = arg_20_1.retained_ids

					if not retained_mode then
						-- Nothing
					end
				end

				retained_mode = true
			end

			::label_20_0::

			local draw_texture_frame = UIRenderer.draw_texture_frame(arg_20_0, var_20_9, var_20_10, arg_20_5[texture_id], var_20_0, var_20_1, var_20_2, var_20_3, var_20_4, var_20_5, var_20_7, var_20_8, var_20_6, retained_mode)

			arg_20_1.retained_ids = not draw_texture_frame and draw_texture_frame and arg_20_1.retained_ids
			arg_20_1.dirty = false
		else
			return UIRenderer.draw_texture_frame(arg_20_0, var_20_9, var_20_10, arg_20_5[texture_id], var_20_0, var_20_1, var_20_2, var_20_3, var_20_4, var_20_5, var_20_7, var_20_8, var_20_6)
		end
	end
}
UIPasses.shader_tiled_texture = {
	init = function (self)
		-- function 21
		if not self.retained_mode then
			return {
				dirty = true
			}
		end
	end,
	destroy = function (arg_22_0, arg_22_1, arg_22_2)
		-- function 22
		assert(arg_22_2.retained_mode, "why u destroy immediate pass?")

		if not arg_22_1.retained_id then
			UIRenderer.destroy_bitmap(arg_22_0, arg_22_1.retained_id)

			arg_22_1.retained_id = nil
		end
	end,
	draw = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6, arg_23_7, arg_23_8, arg_23_9)
		-- function 23
		local var_23_0
		local var_23_1
		local var_23_2
		local texture_id = arg_23_3.texture_id

		texture_id = texture_id or "texture_id"

		if not arg_23_4 then
			local texture_size = arg_23_4.texture_size

			if not texture_size then
				if arg_23_4.horizontal_alignment == "right" then
					arg_23_6[1] = arg_23_6[1] + arg_23_7[1] - texture_size[1]
				elseif arg_23_4.horizontal_alignment == "center" then
					arg_23_6[1] = arg_23_6[1] + (arg_23_7[1] - texture_size[1]) / 2
				end

				if arg_23_4.vertical_alignment == "center" then
					arg_23_6[2] = arg_23_6[2] + (arg_23_7[2] - texture_size[2]) / 2
				elseif arg_23_4.vertical_alignment == "top" then
					arg_23_6[2] = arg_23_6[2] + arg_23_7[2] - texture_size[2]
				end

				arg_23_7 = texture_size
			end

			local tile_size = arg_23_4.tile_size
			local var_23_6 = Vector2(arg_23_7[1] / tile_size[1], arg_23_7[2] / tile_size[2])
			local gui_retained

			if not arg_23_3.retained_mode then
				gui_retained = self.gui_retained

				if not gui_retained then
					-- Nothing
				end
			end

			gui_retained = self.gui

			::label_23_0::

			local material = Gui.material(gui_retained, arg_23_5[texture_id])

			Material.set_vector2(material, "tile_multiplier", var_23_6)

			local var_23_9 = Vector2(0, 0)

			if not arg_23_4.tile_offset then
				if not arg_23_4.tile_offset[1] then
					var_23_9[1] = arg_23_6[1] / tile_size[1]
				end

				if not arg_23_4.tile_offset[2] then
					var_23_9[2] = arg_23_6[2] / tile_size[2]
				end
			end

			Material.set_vector2(material, "tile_offset", var_23_9)

			var_23_0 = arg_23_4.color
			var_23_1 = arg_23_4.masked
			var_23_2 = arg_23_4.saturated
		end

		if not arg_23_3.retained_mode then
			local retained_mode = arg_23_3.retained_mode

			if not retained_mode then
				if not arg_23_1.retained_id then
					retained_mode = arg_23_1.retained_id

					if not retained_mode then
						-- Nothing
					end
				end

				retained_mode = true
			end

			::label_23_1::

			local var_23_11 = draw_texture(self, arg_23_5[texture_id], arg_23_6, arg_23_7, var_23_0, var_23_1, var_23_2, retained_mode)

			arg_23_1.retained_id = not var_23_11 and var_23_11 and arg_23_1.retained_id
			arg_23_1.dirty = false
		else
			draw_texture(self, arg_23_5[texture_id], arg_23_6, arg_23_7, var_23_0, var_23_1, var_23_2)
		end
	end
}
UIPasses.tiled_texture = {
	init = function (arg_24_0)
		-- function 24
		return nil
	end,
	draw = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6, arg_25_7, arg_25_8, arg_25_9)
		-- function 25
		local var_25_0
		local var_25_1
		local var_25_2
		local var_25_3

		if not arg_25_4 then
			local texture_size = arg_25_4.texture_size

			if not texture_size then
				if arg_25_4.horizontal_alignment == "right" then
					arg_25_6[1] = arg_25_6[1] + arg_25_7[1] - texture_size[1]
				elseif arg_25_4.horizontal_alignment == "center" then
					arg_25_6[1] = arg_25_6[1] + (arg_25_7[1] - texture_size[1]) / 2
				end

				if arg_25_4.vertical_alignment == "center" then
					arg_25_6[2] = arg_25_6[2] + (arg_25_7[2] - texture_size[2]) / 2
				elseif arg_25_4.vertical_alignment == "top" then
					arg_25_6[2] = arg_25_6[2] + arg_25_7[2] - texture_size[2]
				end

				arg_25_7 = texture_size
			end

			var_25_0 = arg_25_4.texture_tiling_size
			var_25_1 = arg_25_4.color
			var_25_2 = arg_25_4.masked
			var_25_3 = arg_25_4.saturated
		end

		assert(var_25_0, "Missing texture_tiling_size")

		local texture_id = arg_25_3.texture_id

		texture_id = texture_id or "texture_id"

		return UIRenderer.draw_tiled_texture(arg_25_0, arg_25_5[texture_id], arg_25_6, arg_25_7, var_25_0, var_25_1, var_25_2, var_25_3)
	end
}
UIPasses.multi_texture = {
	init = function (self, arg_26_1, arg_26_2)
		-- function 26
		if not self.retained_mode then
			return {
				dirty = true
			}
		end

		return nil
	end,
	destroy = function (arg_27_0, arg_27_1, arg_27_2)
		-- function 27
		assert(arg_27_2.retained_mode, "why u destroy immediate pass?")

		local retained_ids = arg_27_1.retained_ids

		if not retained_ids then
			for i = 1, #retained_ids do
				UIRenderer.destroy_bitmap(arg_27_0, retained_ids[i])
			end

			arg_27_1.retained_ids = nil
		end
	end,
	draw = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6, arg_28_7, arg_28_8, arg_28_9)
		-- function 28
		local texture_size = arg_28_4.texture_size
		local texture_sizes = arg_28_4.texture_sizes
		local texture_offsets = arg_28_4.texture_offsets

		assert(texture_size or texture_sizes, "Missing texture_sizes")

		if not arg_28_3.retained_mode then
			local retained_mode = arg_28_3.retained_mode

			if not retained_mode then
				if not arg_28_1.retained_ids then
					retained_mode = arg_28_1.retained_ids

					if not retained_mode then
						-- Nothing
					end
				end

				retained_mode = true
			end

			::label_28_0::

			local draw_multi_texture = UIRenderer.draw_multi_texture(arg_28_0, arg_28_5[arg_28_3.texture_id], arg_28_6, texture_size, texture_sizes, texture_offsets, arg_28_4.tile_sizes, arg_28_4.axis, arg_28_4.spacing, arg_28_4.direction, arg_28_4.draw_count, arg_28_4.texture_colors, arg_28_4.color, arg_28_4.masked, not arg_28_4 and arg_28_4.texture_saturation, not arg_28_4 and arg_28_4.saturated, retained_mode)

			arg_28_1.retained_ids = not draw_multi_texture and draw_multi_texture and arg_28_1.retained_ids
			arg_28_1.dirty = false
		else
			return UIRenderer.draw_multi_texture(arg_28_0, arg_28_5[arg_28_3.texture_id], arg_28_6, texture_size, texture_sizes, texture_offsets, arg_28_4.tile_sizes, arg_28_4.axis, arg_28_4.spacing, arg_28_4.direction, arg_28_4.draw_count, arg_28_4.texture_colors, arg_28_4.color, arg_28_4.masked, not arg_28_4 and arg_28_4.texture_saturation, not arg_28_4 and arg_28_4.saturated)
		end
	end
}
UIPasses.centered_texture_amount = {
	init = function (self)
		-- function 29
		if not self.retained_mode then
			return {
				dirty = true
			}
		end

		return nil
	end,
	destroy = function (arg_30_0, arg_30_1, arg_30_2)
		-- function 30
		assert(arg_30_2.retained_mode, "why u destroy immediate pass?")

		local retained_ids = arg_30_1.retained_ids

		if not retained_ids then
			for i = 1, #retained_ids do
				UIRenderer.destroy_bitmap(arg_30_0, retained_ids[i])
			end

			arg_30_1.retained_ids = nil
		end
	end,
	draw = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5, arg_31_6, arg_31_7, arg_31_8, arg_31_9)
		-- function 31
		local texture_size = arg_31_4.texture_size

		assert(texture_size, "Missing texture_size")

		local texture_axis = arg_31_4.texture_axis

		assert(texture_axis, "Missing texture_axis")

		local texture_amount = arg_31_4.texture_amount

		assert(texture_amount, "Missing texture_amount")

		if not arg_31_3.retained_mode then
			local retained_mode = arg_31_3.retained_mode

			if not retained_mode then
				if not arg_31_1.retained_ids then
					retained_mode = arg_31_1.retained_ids

					if not retained_mode then
						-- Nothing
					end
				end

				retained_mode = true
			end

			::label_31_0::

			local draw_centered_texture_amount = UIRenderer.draw_centered_texture_amount(arg_31_0, arg_31_5[arg_31_3.texture_id], arg_31_6, arg_31_7, texture_size, texture_amount, texture_axis, not arg_31_4 and arg_31_4.spacing, not arg_31_4 and arg_31_4.color, not arg_31_4 and arg_31_4.texture_colors, not arg_31_4 and arg_31_4.masked, retained_mode)

			arg_31_1.retained_ids = not draw_centered_texture_amount and draw_centered_texture_amount and arg_31_1.retained_ids
			arg_31_1.dirty = false
		else
			return UIRenderer.draw_centered_texture_amount(arg_31_0, arg_31_5[arg_31_3.texture_id], arg_31_6, arg_31_7, texture_size, texture_amount, texture_axis, not arg_31_4 and arg_31_4.spacing, not arg_31_4 and arg_31_4.color, not arg_31_4 and arg_31_4.texture_colors, not arg_31_4 and arg_31_4.masked)
		end
	end
}
UIPasses.rotated_texture = {
	init = function (self)
		-- function 32
		if not self.retained_mode then
			return {
				dirty = true
			}
		end
	end,
	destroy = function (arg_33_0, arg_33_1, arg_33_2)
		-- function 33
		assert(arg_33_2.retained_mode, "why u destroy immediate pass?")

		if not arg_33_1.retained_id then
			UIRenderer.destroy_bitmap(arg_33_0, arg_33_1.retained_id)

			arg_33_1.retained_id = nil
		end
	end,
	draw = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5, arg_34_6, arg_34_7, arg_34_8, arg_34_9)
		-- function 34
		local texture_id = arg_34_3.texture_id

		texture_id = texture_id or "texture_id"

		local var_34_1 = arg_34_5[texture_id]
		local var_34_2
		local var_34_3
		local var_34_4
		local var_34_5
		local flag = false

		if not arg_34_4 then
			local texture_size = arg_34_4.texture_size

			if not texture_size then
				if arg_34_4.horizontal_alignment == "right" then
					arg_34_6[1] = arg_34_6[1] + arg_34_7[1] - texture_size[1]
				elseif arg_34_4.horizontal_alignment == "center" then
					arg_34_6[1] = arg_34_6[1] + (arg_34_7[1] - texture_size[1]) / 2
				end

				if arg_34_4.vertical_alignment == "center" then
					arg_34_6[2] = arg_34_6[2] + (arg_34_7[2] - texture_size[2]) / 2
				elseif arg_34_4.vertical_alignment == "top" then
					arg_34_6[2] = arg_34_6[2] + arg_34_7[2] - texture_size[2]
				end

				arg_34_7 = texture_size
			end

			var_34_2 = arg_34_4.angle
			var_34_3 = arg_34_4.pivot
			var_34_4 = arg_34_4.color
			var_34_5 = arg_34_4.uvs
			flag = arg_34_4.masked
		end

		if not arg_34_3.retained_mode then
			local retained_mode = arg_34_3.retained_mode

			if not retained_mode then
				if not arg_34_1.retained_id then
					retained_mode = arg_34_1.retained_id

					if not retained_mode then
						-- Nothing
					end
				end

				retained_mode = true
			end

			::label_34_0::

			local draw_texture_rotated = UIRenderer.draw_texture_rotated(arg_34_0, var_34_1, arg_34_7, arg_34_6, var_34_2, var_34_3, var_34_4, var_34_5, flag, retained_mode)

			arg_34_1.retained_id = not draw_texture_rotated and draw_texture_rotated and arg_34_1.retained_id
			arg_34_1.dirty = false
		else
			UIRenderer.draw_texture_rotated(arg_34_0, var_34_1, arg_34_7, arg_34_6, var_34_2, var_34_3, var_34_4, var_34_5, flag)
		end
	end
}
UIPasses.rounded_background = {
	init = function (arg_35_0)
		-- function 35
		return nil
	end,
	draw = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6, arg_36_7, arg_36_8, arg_36_9)
		-- function 36
		local var_36_0
		local var_36_1

		if not arg_36_4 then
			local rect_size = arg_36_4.rect_size

			if not rect_size then
				if arg_36_4.horizontal_alignment == "right" then
					arg_36_6[1] = arg_36_6[1] + arg_36_7[1] - rect_size[1]
				elseif arg_36_4.horizontal_alignment == "center" then
					arg_36_6[1] = arg_36_6[1] + (arg_36_7[1] - rect_size[1]) / 2
				end

				if arg_36_4.vertical_alignment == "center" then
					arg_36_6[2] = arg_36_6[2] + (arg_36_7[2] - rect_size[2]) / 2
				elseif arg_36_4.vertical_alignment == "top" then
					arg_36_6[2] = arg_36_6[2] + arg_36_7[2] - rect_size[2]
				end

				arg_36_7 = rect_size
			end

			var_36_0 = arg_36_4.corner_radius
			var_36_1 = arg_36_4.color
		end

		return UIRenderer.draw_rounded_rect(arg_36_0, arg_36_6, arg_36_7, var_36_0, var_36_1)
	end
}
UIPasses.triangle = {
	init = function (self)
		-- function 37
		if not self.retained_mode then
			return {
				dirty = true
			}
		end
	end,
	destroy = function (arg_38_0, arg_38_1, arg_38_2)
		-- function 38
		assert(arg_38_2.retained_mode, "why u destroy immediate pass?")

		if not arg_38_1.retained_id then
			UIRenderer.destroy_bitmap(arg_38_0, arg_38_1.retained_id)

			arg_38_1.retained_id = nil
		end
	end,
	draw = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6, arg_39_7, arg_39_8, arg_39_9)
		-- function 39
		if not arg_39_4 then
			local texture_size = arg_39_4.texture_size

			if not texture_size then
				if arg_39_4.horizontal_alignment == "right" then
					arg_39_6[1] = arg_39_6[1] + arg_39_7[1] - texture_size[1]
				elseif arg_39_4.horizontal_alignment == "center" then
					arg_39_6[1] = arg_39_6[1] + (arg_39_7[1] - texture_size[1]) / 2
				end

				if arg_39_4.vertical_alignment == "center" then
					arg_39_6[2] = arg_39_6[2] + (arg_39_7[2] - texture_size[2]) / 2
				elseif arg_39_4.vertical_alignment == "top" then
					arg_39_6[2] = arg_39_6[2] + arg_39_7[2] - texture_size[2]
				end

				arg_39_7 = texture_size
			end
		end

		if not arg_39_3.retained_mode then
			local retained_mode = arg_39_3.retained_mode

			if not retained_mode then
				if not arg_39_1.retained_id then
					retained_mode = arg_39_1.retained_id

					if not retained_mode then
						-- Nothing
					end
				end

				retained_mode = true
			end

			::label_39_0::

			local draw_triangle = UIRenderer.draw_triangle(arg_39_0, arg_39_6, arg_39_7, arg_39_4, retained_mode)

			arg_39_1.retained_id = not draw_triangle and draw_triangle and arg_39_1.retained_id
			arg_39_1.dirty = false
		else
			UIRenderer.draw_triangle(arg_39_0, arg_39_6, arg_39_7, arg_39_4)
		end
	end
}

local str = "Vector3"

UIPasses.scrollbar_hotspot = {
	init = function (self)
		-- function 40
		return {
			content_id = self.content_id,
			scrollbar_size = {
				0,
				0
			},
			scrollbar_position = {
				0,
				0,
				0
			},
			hotspot_size = {
				0,
				0
			},
			hotspot_position = {
				0,
				0,
				0
			},
			scroll_area_position = {
				0,
				0,
				0
			},
			start_move_pos = {
				math.huge,
				math.huge
			}
		}
	end,
	draw = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4, arg_41_5, arg_41_6, arg_41_7, arg_41_8, arg_41_9)
		-- function 41
		local var_41_0
		local str_2 = "cursor"
		local stack_depth = ShowCursorStack.stack_depth
		local flag = not arg_41_8 and arg_41_8:has(str_2)
		local flag_2 = (not (stack_depth > 0) or not flag) and arg_41_8:get(str_2)

		if not (not flag_2 and Script.type_name(flag_2) == str) then
			flag_2 = tbl
		end

		local is_device_active = Managers.input:is_device_active("gamepad")
		local var_41_6

		if not is_device_active then
			var_41_6 = flag_2
		else
			var_41_6 = UIInverseScaleVectorToResolution(flag_2)
		end

		local hotspot_position = arg_41_1.hotspot_position

		hotspot_position[1] = arg_41_6[1]
		hotspot_position[2] = arg_41_6[2]
		hotspot_position[3] = arg_41_6[3]

		local hotspot_size = arg_41_1.hotspot_size

		hotspot_size[1] = arg_41_7[1]
		hotspot_size[2] = arg_41_7[2]

		if not arg_41_4.hotspot_width_modifier then
			local num = hotspot_size[1] * arg_41_4.hotspot_width_modifier

			hotspot_size[1] = num
			hotspot_position[1] = hotspot_position[1] - num / 2 + arg_41_7[1] / 2
		end

		local point_is_inside_2d_box = math.point_is_inside_2d_box(var_41_6, hotspot_position, hotspot_size)

		arg_41_5.is_hover = point_is_inside_2d_box

		local percentage = arg_41_5.percentage
		local scrollbar_size = arg_41_1.scrollbar_size

		scrollbar_size[1] = hotspot_size[1]

		local max = math.max(arg_41_4.min_scrollbar_height, hotspot_size[2] * percentage)

		scrollbar_size[2] = max

		local scroll_value = arg_41_5.scroll_value
		local num_2 = hotspot_size[2] - max
		local num_3 = num_2 * scroll_value
		local scrollbar_position = arg_41_1.scrollbar_position

		scrollbar_position[1] = hotspot_position[1]
		scrollbar_position[2] = hotspot_position[2] + num_3
		scrollbar_position[3] = hotspot_position[3] + 1

		local point_is_inside_2d_box_2 = math.point_is_inside_2d_box(var_41_6, scrollbar_position, scrollbar_size)

		arg_41_5.is_hover_scrollbar = point_is_inside_2d_box_2

		local flag_3 = not arg_41_8 and arg_41_8:get("left_hold")

		if not point_is_inside_2d_box_2 then
			if not flag_3 then
				arg_41_5.holding = true

				if arg_41_1.start_move_pos[2] == math.huge then
					arg_41_1.start_move_pos[2] = flag_2[2]
					arg_41_5.og_scroll_value = arg_41_5.scroll_value
				end
			end
		elseif not point_is_inside_2d_box and not flag_3 then
			arg_41_5.holding = true
		end

		local var_41_20

		if not arg_41_5.holding then
			if not flag_3 then
				arg_41_5.holding = false
				arg_41_1.start_move_pos[2] = math.huge
			elseif arg_41_1.start_move_pos[2] < math.huge then
				local var_41_21 = arg_41_1.start_move_pos[2]
				local num_4 = (flag_2[2] - var_41_21) / num_2
				local og_scroll_value = arg_41_5.og_scroll_value

				var_41_20 = math.clamp(og_scroll_value + num_4, 0, 1)
			else
				local num_5 = flag_2[2] - hotspot_position[2]

				var_41_20 = math.clamp(num_5 / num_2, 0, 1)
			end
		end

		local flag_4 = false
		local scroll_area_position = arg_41_1.scroll_area_position
		local scroll_area_size = arg_41_4.scroll_area_size

		if var_41_20 or not scroll_area_size then
			local scroll_area_offset = arg_41_4.scroll_area_offset

			scroll_area_position[1] = hotspot_position[1] + scroll_area_offset[1]
			scroll_area_position[2] = hotspot_position[2] + scroll_area_offset[2]
			scroll_area_position[3] = hotspot_position[3] + scroll_area_offset[3]
			flag_4 = math.point_is_inside_2d_box(var_41_6, scroll_area_position, scroll_area_size)

			if not flag_4 then
				local var_41_29 = arg_41_8:get("scroll_axis")[2]
				local num_6 = arg_41_5.scroll_amount * var_41_29

				var_41_20 = math.clamp(arg_41_5.scroll_value + num_6, 0, 1)
			end
		end

		if not var_41_20 then
			arg_41_5.scroll_value = var_41_20
		end

		if not script_data.ui_debug_hover then
			if not point_is_inside_2d_box then
				UIRenderer.draw_rect(arg_41_0, Vector3(hotspot_position[1], hotspot_position[2], 999), hotspot_size, {
					128,
					0,
					255,
					0
				})
			else
				UIRenderer.draw_rect(arg_41_0, Vector3(hotspot_position[1], hotspot_position[2], hotspot_position[3] + 1), hotspot_size, {
					60,
					255,
					0,
					0
				})
			end

			if not point_is_inside_2d_box_2 then
				UIRenderer.draw_rect(arg_41_0, Vector3(scrollbar_position[1], scrollbar_position[2], 999), scrollbar_size, {
					128,
					0,
					255,
					0
				})
			else
				UIRenderer.draw_rect(arg_41_0, Vector3(scrollbar_position[1], scrollbar_position[2], scrollbar_position[3] + 1), scrollbar_size, {
					60,
					255,
					0,
					0
				})
			end

			if not flag_4 then
				UIRenderer.draw_rect(arg_41_0, Vector3(scroll_area_position[1], scroll_area_position[2], 999), scroll_area_size, {
					128,
					0,
					255,
					0
				})
			else
				UIRenderer.draw_rect(arg_41_0, Vector3(scroll_area_position[1], scroll_area_position[2], scroll_area_position[3] + 1), scroll_area_size, {
					60,
					255,
					0,
					0
				})
			end
		end
	end
}
UIPasses.scrollbar = {
	init = function (self)
		-- function 42
		return {
			content_id = self.content_id,
			scrollbar_size = {
				0,
				0
			},
			scrollbar_position = {
				0,
				0,
				0
			}
		}
	end,
	draw = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5, arg_43_6, arg_43_7, arg_43_8, arg_43_9)
		-- function 43
		UIRenderer.draw_rect(arg_43_0, arg_43_6, arg_43_7, arg_43_4.background_color)

		local percentage = arg_43_5.percentage
		local scrollbar_size = arg_43_1.scrollbar_size

		scrollbar_size[1] = arg_43_7[1]

		local max = math.max(arg_43_4.min_scrollbar_height, arg_43_7[2] * percentage)

		scrollbar_size[2] = max

		local scroll_value = arg_43_5.scroll_value
		local num = (arg_43_7[2] - max) * scroll_value
		local scrollbar_position = arg_43_1.scrollbar_position

		scrollbar_position[1] = arg_43_6[1]
		scrollbar_position[2] = arg_43_6[2] + num
		scrollbar_position[3] = arg_43_6[3] + 1

		UIRenderer.draw_rect(arg_43_0, scrollbar_position, scrollbar_size, arg_43_4.scrollbar_color)
	end
}
UIPasses.rect_rotated = {
	init = function (arg_44_0)
		-- function 44
		return nil
	end,
	draw = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6, arg_45_7, arg_45_8, arg_45_9)
		-- function 45
		local num = 0
		local var_45_1
		local var_45_2

		if not arg_45_4 then
			local texture_size = arg_45_4.texture_size

			if not texture_size then
				if arg_45_4.horizontal_alignment == "right" then
					arg_45_6[1] = arg_45_6[1] + arg_45_7[1] - texture_size[1]
				elseif arg_45_4.horizontal_alignment == "center" then
					arg_45_6[1] = arg_45_6[1] + (arg_45_7[1] - texture_size[1]) / 2
				end

				if arg_45_4.vertical_alignment == "center" then
					arg_45_6[2] = arg_45_6[2] + (arg_45_7[2] - texture_size[2]) / 2
				elseif arg_45_4.vertical_alignment == "top" then
					arg_45_6[2] = arg_45_6[2] + arg_45_7[2] - texture_size[2]
				end

				arg_45_7 = texture_size
			end

			num = arg_45_4.angle
			var_45_1 = arg_45_4.pivot
			var_45_2 = arg_45_4.color
		end

		return UIRenderer.draw_rect_rotated(arg_45_0, arg_45_7, arg_45_6, num, var_45_1, var_45_2)
	end
}
UIPasses.video = {
	init = function (arg_46_0)
		-- function 46
		return nil
	end,
	draw = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4, arg_47_5, arg_47_6, arg_47_7, arg_47_8, arg_47_9)
		-- function 47
		arg_47_5.video_completed = UIRenderer.draw_video(arg_47_0, arg_47_5.material_name, arg_47_6, arg_47_7, arg_47_4.color, arg_47_5.video_player_reference, arg_47_5.video_player)
	end
}
UIPasses.splash_video = {
	init = function (arg_48_0)
		-- function 48
		return nil
	end,
	draw = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3, arg_49_4, arg_49_5, arg_49_6, arg_49_7, arg_49_8, arg_49_9)
		-- function 49
		arg_49_5.video_completed = UIRenderer.draw_splash_video(arg_49_0, arg_49_5.material_name, arg_49_6, arg_49_7, arg_49_4.color, arg_49_5.video_player_reference, arg_49_5.video_player)
	end
}
UIPasses.border = {
	init = function (arg_50_0)
		-- function 50
		return nil
	end,
	draw = function (arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4, arg_51_5, arg_51_6, arg_51_7, arg_51_8, arg_51_9)
		-- function 51
		local var_51_0 = arg_51_6
		local thickness = arg_51_4.thickness

		thickness = thickness or 1

		UIRenderer.draw_rect(arg_51_0, var_51_0, Vector3(thickness, arg_51_7.y, 0), arg_51_4.color)
		UIRenderer.draw_rect(arg_51_0, var_51_0, Vector3(arg_51_7.x, thickness, 0), arg_51_4.color)
		UIRenderer.draw_rect(arg_51_0, var_51_0 + Vector3(arg_51_7.x - thickness, 0, 0), Vector3(thickness, arg_51_7.y, 0), arg_51_4.color)
		UIRenderer.draw_rect(arg_51_0, var_51_0 + Vector3(0, arg_51_7.y - thickness, 0), Vector3(arg_51_7.x, thickness, 0), arg_51_4.color)
	end
}

local function fn(arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4, arg_52_5, arg_52_6)
	-- function 52
	local var_52_0 = Vector3(0, 0, 0)

	if arg_52_6.horizontal_alignment == "right" then
		var_52_0 = Vector3(arg_52_4[1] - arg_52_0, 0, 0)
	elseif arg_52_6.horizontal_alignment == "center" then
		local num = (arg_52_4[1] - arg_52_0) / 2

		var_52_0 = Vector3(num - arg_52_5.x, 0, 0)
	end

	local inv_scale = RESOLUTION_LOOKUP.inv_scale

	if arg_52_6.vertical_alignment == "center" then
		local num_2 = (arg_52_4[2] - arg_52_1 * inv_scale * 0.5) / 2

		var_52_0 = var_52_0 + Vector3(0, num_2, 0)
	elseif arg_52_6.vertical_alignment == "top" then
		local num_3 = arg_52_4[2] - arg_52_3 * inv_scale

		var_52_0 = var_52_0 + Vector3(0, num_3, 0)
	else
		var_52_0.y = var_52_0.y + math.abs(arg_52_2) * inv_scale
	end

	return var_52_0
end

local tbl_3 = {}
local tbl_4 = {}
local tbl_5 = {}
local tbl_6 = {}
local tbl_7 = {}
local tbl_8 = {}
local tbl_9 = {}
local tbl_10 = {}
local str_2 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890"
local str_3 = "{#color(%d,%d,%d)}"

UIPasses.text_area_chat = {
	init = function (self)
		-- function 53
		assert(self.text_id)

		return {
			irc_channel_colors = table.clone(IRC_CHANNEL_COLORS),
			text_id = self.text_id
		}
	end,
	draw = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5, arg_54_6, arg_54_7, arg_54_8, arg_54_9)
		-- function 54
		if #arg_54_5.message_tables == 0 then
			return
		end

		table.clear_array(tbl_4, #tbl_4)
		table.clear(tbl_5)
		table.clear(tbl_6)
		table.clear(tbl_7)
		table.clear(tbl_8)
		table.clear(tbl_3)
		table.clear(tbl_9)
		table.clear(tbl_10)

		local resolution, var_54_1 = Gui.resolution()
		local str = resolution .. ":" .. var_54_1 .. "-" .. arg_54_4.font_size
		local var_54_3
		local var_54_4
		local var_54_5

		if not arg_54_4.font_type then
			local var_54_6, var_54_7 = UIFontByResolution(arg_54_4)

			var_54_3, var_54_4, var_54_5 = var_54_6[1], var_54_7, arg_54_4.font_type
		end

		local var_54_8 = Vector3(arg_54_7.x, var_54_4, arg_54_7.z)
		local offset = arg_54_4.offset

		if not offset then
			local Vector3 = Vector3
			local var_54_11 = offset[1]
			local var_54_12 = offset[2]
			local var_54_13 = offset[3]

			var_54_13 = var_54_13 or 0
			arg_54_6 = arg_54_6 + Vector3(var_54_11, var_54_12, var_54_13)
		end

		local var_54_14 = arg_54_4.text_color[1]
		local irc_channel_colors = arg_54_1.irc_channel_colors

		for k, v in pairs(irc_channel_colors) do
			v[1] = var_54_14
		end

		local inv_scale = RESOLUTION_LOOKUP.inv_scale
		local var_54_17, var_54_18 = UIFontByResolution(arg_54_4, inv_scale)
		local var_54_19 = unpack(var_54_17)
		local text_size, var_54_21, var_54_22 = UIRenderer.text_size(arg_54_0, str_2, var_54_19, arg_54_4.font_size)
		local text_color = arg_54_4.text_color
		local default_color = arg_54_4.default_color
		local name_color = arg_54_4.name_color
		local name_color_dev = arg_54_4.name_color_dev
		local name_color_system = arg_54_4.name_color_system
		local num = 0

		for k_2 = 1, #arg_54_5.message_tables do
			local var_54_29 = arg_54_5.message_tables[k_2]
			local is_dev = var_54_29.is_dev
			local is_bot = var_54_29.is_bot
			local is_system = var_54_29.is_system
			local is_enemy = var_54_29.is_enemy
			local trimmed_sender = var_54_29.trimmed_sender

			trimmed_sender = trimmed_sender or var_54_29.sender

			local message = var_54_29.message
			local type = var_54_29.type
			local link = var_54_29.link
			local emojis = var_54_29.emojis
			local formatted = var_54_29.formatted
			local channel_string = var_54_29.channel_string

			channel_string = channel_string or ""

			if formatted ~= str then
				local var_54_41

				if channel_string ~= "" then
					local tbl_2

					if not is_enemy then
						tbl_2 = {
							255,
							237,
							48,
							48
						}

						if not tbl_2 then
							-- Nothing
						end
					end

					tbl_2 = {
						255,
						53,
						161,
						212
					}

					::label_54_0::

					channel_string = string.format(str_3, tbl_2[2], tbl_2[3], tbl_2[4]) .. channel_string
				end

				if not (not default_color and type(default_color) ~= "table") then
					default_color = string.format(str_3, default_color[2], default_color[3], default_color[4])
				else
					default_color = default_color or string.format(str_3, text_color[2], text_color[3], text_color[4])
				end

				if not is_system then
					if not (not name_color_system and type(name_color_system) ~= "table") then
						name_color_system = string.format(str_3, name_color_system[2], name_color_system[3], name_color_system[4])
					end

					var_54_41 = name_color_system .. trimmed_sender .. default_color .. message
				elseif not is_dev then
					if not (not name_color_dev and type(name_color_dev) ~= "table") then
						name_color_dev = string.format(str_3, name_color_dev[2], name_color_dev[3], name_color_dev[4])
					end

					var_54_41 = channel_string .. name_color_dev .. trimmed_sender .. default_color .. message
				else
					if not (not name_color and type(name_color) ~= "table") then
						name_color = string.format(str_3, name_color[2], name_color[3], name_color[4])
					end

					local flag

					flag = channel_string == "" or not "" or name_color
					var_54_41 = channel_string .. flag .. trimmed_sender .. default_color .. message
				end

				local str_4 = "${e};"
				local var_54_45 = var_54_41

				if not emojis then
					for i, v_2 in ipairs(emojis) do
						var_54_45 = string.gsub(var_54_45, v_2.keys, str_4)
					end
				end

				local word_wrap = UIRenderer.word_wrap(arg_54_0, var_54_45, var_54_3, var_54_4, arg_54_7[1], nil, var_54_5)
				local var_54_47
				local clone = table.clone(word_wrap)

				if not emojis then
					local var_54_49
					local var_54_50

					var_54_47 = {}

					for i_2, v_3 in ipairs(emojis) do
						for i_3, v_4 in ipairs(clone) do
							local find = string.find(v_4, str_4)

							if not find then
								local sub = string.sub(v_4, 0, math.max(find - 1, 0))

								if not Utf8.valid(sub) then
									print(string.format("%q is not a valid utf-8 string", sub))

									break
								end

								local str_5 = "      "
								local gsub = string.gsub(sub, "{#.-}", "")
								local get_text_width = UIUtils.get_text_width(arg_54_0, arg_54_4, gsub)
								local var_54_56 = var_54_47[i_3]

								var_54_56 = var_54_56 or {}
								var_54_47[i_3] = var_54_56
								var_54_47[i_3][#var_54_47[i_3] + 1] = {
									data = v_3,
									offset_x = get_text_width,
									offset_y = -arg_54_4.emoji_size[2] * 0.3,
									size = arg_54_4.emoji_size
								}
								var_54_49 = string.gsub(v_4, str_4, str_5, 1)
								var_54_50 = i_3

								break
							end
						end

						if not var_54_49 then
							clone[var_54_50] = var_54_49
						end
					end
				end

				var_54_29.formatted_emojis = var_54_47
				var_54_29.formatted_message_array = clone
				var_54_29.formatted = str
			end

			local formatted_message_array = var_54_29.formatted_message_array
			local formatted_emojis = var_54_29.formatted_emojis
			local count = #formatted_message_array

			num = num + count

			local num_2 = #tbl_4 + 1

			for i9 = 1, count do
				tbl_4[num_2] = formatted_message_array[i9]

				if not is_system then
					tbl_8[num_2] = formatted_message_array[i9]
				end

				if i9 == 1 then
					if not is_dev then
						tbl_7[#tbl_4] = trimmed_sender
					elseif not is_bot then
						tbl_5[num_2] = trimmed_sender
						tbl_6[num_2] = Colors.get_color_table_with_alpha("dark_gray", var_54_14)
					else
						tbl_5[num_2] = trimmed_sender

						local var_54_61 = tbl_6
						local var_54_62 = irc_channel_colors[type]

						var_54_62 = var_54_62 or Colors.get_color_table_with_alpha("gray", var_54_14)
						var_54_61[num_2] = var_54_62
					end

					local text_size_2, var_54_64, var_54_65 = UIRenderer.text_size(arg_54_0, channel_string, var_54_3, var_54_4)

					tbl_10[num_2] = text_size_2
				end

				if not link then
					tbl_3[num_2] = link
				end

				if not formatted_emojis and not formatted_emojis[i9] then
					local var_54_66 = formatted_emojis[i9]

					tbl_9[num_2] = var_54_66
				end

				num_2 = num_2 + 1
			end
		end

		local spacing = arg_54_4.spacing

		spacing = spacing or 0

		local floor = math.floor(arg_54_7[2] / (arg_54_4.font_size + spacing))
		local num_3 = floor * arg_54_4.font_size
		local num_4 = 12

		if num_3 > arg_54_7[2] + num_4 then
			floor = floor - 1
		end

		local min = math.min(floor, num)
		local vertical_alignment = arg_54_4.vertical_alignment

		if vertical_alignment == "top" then
			arg_54_6 = arg_54_6 + Vector3(0, arg_54_7[2], 0)
		elseif vertical_alignment == "bottom" then
			local num_5 = (arg_54_4.font_size + spacing) * (min - 1)

			arg_54_6 = arg_54_6 + Vector3(0, num_5 - var_54_22[2], 0)
		end

		local num_6 = min / num
		local text_start_offset = arg_54_5.text_start_offset
		local num_7 = (1 - num_6) * num
		local modf = math.modf((1 + num_7) * text_start_offset)
		local min_2 = math.min(num, modf + min)

		for i10 = math.max(1, min_2 - min + 1), min_2 do
			local var_54_79 = tbl_4[i10]

			UIRenderer.draw_text(arg_54_0, var_54_79, var_54_3, var_54_4, var_54_5, arg_54_6, text_color)

			if not tbl_3[i10] then
				local get = arg_54_8:get("cursor")

				get = get or tbl

				local var_54_81 = UIInverseScaleVectorToResolution(get)

				if not math.point_is_inside_2d_box(var_54_81, arg_54_6, var_54_8) then
					UIRenderer.draw_rect(arg_54_0, arg_54_6, var_54_8, Colors.get_color_table_with_alpha("magenta", 50))

					if not arg_54_8:get("left_press") then
						print("PRESSED")

						arg_54_5.link_pressed = tbl_3[i10]
					end
				else
					UIRenderer.draw_rect(arg_54_0, arg_54_6, var_54_8, Colors.get_color_table_with_alpha("powder_blue", 50))
				end
			end

			if not tbl_9[i10] then
				for i_4, v_5 in ipairs(tbl_9[i10]) do
					UIRenderer.draw_texture(arg_54_0, v_5.data.texture, arg_54_6 + Vector3(v_5.offset_x, v_5.offset_y, 0), Vector2(v_5.size[1], v_5.size[2]))
				end
			end

			arg_54_6.y = arg_54_6.y - arg_54_4.font_size - spacing
		end
	end
}

local tbl_11 = {}
local tbl_12 = {}
local tbl_13 = {}
local tbl_14 = {}

local function fn_2(arg_55_0, arg_55_1, arg_55_2, arg_55_3)
	-- function 55
	local var_55_0 = arg_55_2

	if not arg_55_1.localize then
		var_55_0 = Managers.localizer:simple_lookup(arg_55_2)
	end

	if not string.find(var_55_0, "%b$;[%a%d_]*:") then
		table.clear(tbl_13)

		return arg_55_3
	end

	local input = Managers.input

	input = not input and Managers.input:is_device_active("gamepad")

	local var_55_2
	local get_input_action, var_55_4

	get_input_action, tbl_13, var_55_4, tbl_14 = Managers.localizer:get_input_action(var_55_0)

	local inv_scale = RESOLUTION_LOOKUP.inv_scale

	if not tbl_13[1] then
		table.clear(tbl_11)
		table.clear(tbl_12)

		for i = 1, #tbl_13 do
			local var_55_6 = tbl_13[i]
			local var_55_7 = tbl_14[i]
			local var_55_8, var_55_9 = UIFontByResolution(arg_55_1)
			local var_55_10 = var_55_8[1]
			local var_55_11 = var_55_9
			local text_size = UIRenderer.text_size(arg_55_0, "½", var_55_10, var_55_11)
			local num = UIRenderer.text_size(arg_55_0, "½ ", var_55_10, var_55_11) - text_size

			if not input then
				local num_2 = var_55_11 * inv_scale
				local num_3 = math.ceil(num_2 / num) + 1

				tbl_11[i] = string.rep(" ", num_3)

				local num_4 = math.ceil(num_2 / text_size) + 1

				tbl_12[i] = string.rep("½", num_4)
			else
				local get_gamepad_input_texture_data, var_55_18, var_55_19, var_55_20 = UISettings.get_gamepad_input_texture_data(Managers.input:get_service(var_55_7), var_55_6, input)

				if not (not var_55_19 and var_55_20 and var_55_19[1] ~= "mouse") then
					local num_5 = var_55_11 * inv_scale
					local num_6 = math.ceil(num_5 / num) + 1

					tbl_11[i] = string.rep(" ", num_6)

					local num_7 = math.ceil(num_5 / text_size) + 1

					tbl_12[i] = string.rep("½", num_7)
				else
					local upper = Utf8.upper
					local var_55_25

					if not var_55_20 then
						var_55_25 = Localize(var_55_19[2])

						if not var_55_25 then
							-- Nothing
						end
					end

					var_55_25 = Keyboard.button_locale_name(var_55_19[2])
					var_55_25 = var_55_25 or Localize(UNASSIGNED_KEY)

					::label_55_0::

					local var_55_26 = upper(var_55_25)
					local num_8 = UIRenderer.text_size(arg_55_0, var_55_26, var_55_10, var_55_11) + var_55_11 * inv_scale
					local ceil = math.ceil(num_8 / num)

					tbl_11[i] = string.rep(" ", ceil)

					local ceil_2 = math.ceil(num_8 / text_size)

					tbl_12[i] = string.rep("½", ceil_2)
				end
			end
		end

		local flag = true
		local num_9 = 1

		for j = 1, #tbl_12 do
			var_55_0 = Managers.localizer:replace_macro_in_string(var_55_0, tbl_12[j], flag, num_9)
		end

		table.reverse(tbl_13)
		table.reverse(tbl_14)
		table.reverse(tbl_12)
		table.reverse(tbl_11)
	else
		var_55_0 = arg_55_3
	end

	return var_55_0
end

local tbl_15 = {
	0,
	255,
	255,
	255
}

local function fn_3(arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4, arg_56_5, arg_56_6)
	-- function 56
	if not tbl_13[1] then
		return arg_56_1
	end

	local flag = true
	local inv_scale = RESOLUTION_LOOKUP.inv_scale

	while not flag do
		local var_56_2 = tbl_13[#tbl_13]
		local var_56_3 = tbl_14[#tbl_14]
		local var_56_4 = tbl_12[#tbl_12]
		local var_56_5 = tbl_11[#tbl_11]

		if not (not var_56_2 and not var_56_3 and not var_56_4 and var_56_5) then
			Crashify.print_exception("Buttons in text", "Text: %q - Input action: %q - input_service: %q - replacement_str: %q - final_replacement_str: %q", tostring(arg_56_1), tostring(var_56_2), tostring(var_56_3), tostring(var_56_4), tostring(var_56_5))
			table.clear(tbl_13)
			table.clear(tbl_14)
			table.clear(tbl_12)
			table.clear(tbl_11)

			return arg_56_1
		end

		local find = string.find(arg_56_1, tbl_12[#tbl_12])

		if not find then
			local var_56_7 = tbl_13[#tbl_13]
			local var_56_8 = tbl_14[#tbl_14]
			local is_device_active = Managers.input:is_device_active("gamepad")
			local get_gamepad_input_texture_data, var_56_11, var_56_12, var_56_13 = UISettings.get_gamepad_input_texture_data(Managers.input:get_service(var_56_8), var_56_7, is_device_active)
			local sub = string.sub(arg_56_1, 1, math.max(find, 2))
			local flag_2 = false

			while not (Utf8.valid(sub) or not (find > 1)) do
				find = find - 1
				sub = string.sub(arg_56_1, 1, math.max(find, 2))
				flag_2 = true
			end

			local text_size = UIRenderer.text_size(arg_56_0, sub, arg_56_2, arg_56_3)

			text_size = not (find > 1) or not text_size or 0

			local flag_3 = false

			if not flag_2 then
				flag_3 = arg_56_5 + Vector3(text_size + arg_56_3 * inv_scale * 0.25, -arg_56_3 * inv_scale * 0.25, 0)
			else
				flag_3 = arg_56_5 + Vector3(text_size - arg_56_3 * inv_scale * 0.25, -arg_56_3 * inv_scale * 0.25, 0)
			end

			if not arg_56_6.skip_button_rendering then
				if not is_device_active then
					if not get_gamepad_input_texture_data then
						tbl_15[1] = arg_56_6.text_color[1]

						draw_texture(arg_56_0, get_gamepad_input_texture_data.texture, flag_3, Vector2(arg_56_3 * inv_scale, arg_56_3 * inv_scale), tbl_15, arg_56_6.masked, arg_56_6.saturated)
					else
						local num = arg_56_5 + Vector3(text_size, 0, 0)

						UIRenderer.draw_text(arg_56_0, "[?]", arg_56_2, arg_56_3, arg_56_4, num, Colors.get_color_table_with_alpha("font_title", 255))
					end
				elseif not (not var_56_12 and var_56_13 and var_56_12[1] ~= "mouse") then
					if not get_gamepad_input_texture_data then
						local num_2 = get_gamepad_input_texture_data.size[2] / get_gamepad_input_texture_data.size[1]

						tbl_15[1] = arg_56_6.text_color[1]

						draw_texture(arg_56_0, get_gamepad_input_texture_data.texture, flag_3, Vector2(arg_56_3 * inv_scale, arg_56_3 * inv_scale * num_2), tbl_15, arg_56_6.masked, arg_56_6.saturated)
					else
						local num_3 = arg_56_5 + Vector3(text_size, 0, 0)

						UIRenderer.draw_text(arg_56_0, "[?]", arg_56_2, arg_56_3, arg_56_4, num_3, Colors.get_color_table_with_alpha("font_title", 255))
					end
				else
					local upper = Utf8.upper
					local var_56_22

					if not var_56_13 then
						var_56_22 = Localize(var_56_12[2])

						if not var_56_22 then
							-- Nothing
						end
					end

					var_56_22 = Keyboard.button_locale_name(var_56_12[2])
					var_56_22 = var_56_22 or Localize(UNASSIGNED_KEY)

					::label_56_0::

					local var_56_23 = upper(var_56_22)
					local text_size_2, var_56_25 = UIRenderer.text_size(arg_56_0, var_56_23, arg_56_2, arg_56_3)
					local var_56_26 = get_gamepad_input_texture_data[1]
					local var_56_27 = get_gamepad_input_texture_data[2]
					local num_4 = var_56_25 / var_56_26.size[2] * 1.5
					local var_56_29

					if not flag_2 then
						var_56_29 = arg_56_5 + Vector3(text_size + var_56_26.size[1] * 0.3 * num_4, -var_56_26.size[2] * 0.23 * num_4, 0)
					else
						var_56_29 = arg_56_5 + Vector3(text_size - var_56_26.size[1] * 0.3 * num_4, -var_56_26.size[2] * 0.23 * num_4, 0)
					end

					draw_texture(arg_56_0, var_56_26.texture, var_56_29, Vector2(var_56_26.size[1] * num_4, var_56_26.size[2] * num_4), {
						arg_56_6.text_color[1],
						255,
						255,
						255
					}, arg_56_6.masked, arg_56_6.saturated)

					var_56_29[1] = var_56_29[1] + var_56_26.size[1] * num_4

					draw_texture(arg_56_0, var_56_27.texture, var_56_29, Vector2(text_size_2, var_56_27.size[2] * num_4), {
						arg_56_6.text_color[1],
						255,
						255,
						255
					}, arg_56_6.masked, arg_56_6.saturated)

					local var_56_30

					if not flag_2 then
						var_56_30 = arg_56_5 + Vector3(text_size + (var_56_26.size[1] * 0.3 * num_4 + var_56_26.size[1] * 0.3 * num_4) * 2, 0, 1)
					else
						var_56_30 = arg_56_5 + Vector3(text_size + var_56_26.size[1] * 0.3 * num_4 + var_56_26.size[1] * 0.3 * num_4, 0, 1)
					end

					UIRenderer.draw_text(arg_56_0, var_56_23, arg_56_2, arg_56_3, arg_56_4, var_56_30, arg_56_6.text_color)

					var_56_29[1] = var_56_29[1] + text_size_2

					draw_texture_uv(arg_56_0, var_56_26.texture, var_56_29, Vector2(var_56_26.size[1] * num_4, var_56_26.size[2] * num_4), {
						{
							1,
							0
						},
						{
							0,
							1
						}
					}, {
						arg_56_6.text_color[1],
						255,
						255,
						255
					}, arg_56_6.masked, arg_56_6.saturated)
				end
			end

			arg_56_1 = string.gsub(arg_56_1, tbl_12[#tbl_12], tbl_11[#tbl_11], 1)
			tbl_13[#tbl_13] = nil
			tbl_14[#tbl_14] = nil
			tbl_12[#tbl_12] = nil
			tbl_11[#tbl_11] = nil
		end

		flag = find == nil or #tbl_12 > 0
	end

	return arg_56_1
end

local function fn_4(arg_57_0, arg_57_1, arg_57_2, arg_57_3, arg_57_4)
	-- function 57
	local color_override = arg_57_4.color_override
	local internal_color_overrides = arg_57_4.internal_color_overrides

	if not internal_color_overrides then
		internal_color_overrides = {}
		arg_57_4.internal_color_overrides = internal_color_overrides
	end

	local var_57_2 = internal_color_overrides[arg_57_0]
	local count = #color_override

	if count > 0 then
		if not var_57_2 then
			var_57_2 = {}
			internal_color_overrides[arg_57_0] = var_57_2
		end

		local max = math.max(count, #var_57_2)

		for i = 1, max do
			local flag = true
			local var_57_6 = color_override[i]

			if not var_57_6 then
				local num = arg_57_0 - 1
				local color = var_57_6.color
				local num_2 = var_57_6.start_index + num
				local num_3 = var_57_6.end_index + num

				if num_2 <= arg_57_2 + arg_57_1 then
					local var_57_11
					local var_57_12

					if not (not (num_2 <= arg_57_2) or num_3 >= arg_57_2 + arg_57_1) then
						var_57_11 = 1
						var_57_12 = arg_57_1
					else
						var_57_11 = math.max(1, num_2 - arg_57_2)

						if num_3 <= arg_57_2 + arg_57_1 then
							var_57_12 = num_3 - arg_57_2
						else
							var_57_12 = arg_57_1
						end
					end

					if not var_57_11 and not var_57_12 then
						if not var_57_2[i] then
							var_57_2[i] = {}
						end

						local var_57_13 = var_57_2[i]

						var_57_13.color = Color(color[1], color[2], color[3], color[4])
						var_57_13.start_index = var_57_11
						var_57_13.end_index = var_57_12
						flag = false
					end
				end
			end

			if not flag then
				var_57_2[i] = nil
			end
		end
	else
		return nil
	end

	if not (not var_57_2 and not (#var_57_2 > 0)) then
		return var_57_2
	end
end

UIPasses.text = {
	init = function (self)
		-- function 58
		assert(self.text_id, "no text id in pass definition. YOU NEEDS IT.")

		local tbl = {
			text_id = self.text_id
		}
		local flag

		flag = not self.retained_mode and true and nil
		tbl.dirty = flag

		return tbl
	end,
	destroy = function (arg_59_0, arg_59_1, arg_59_2)
		-- function 59
		assert(arg_59_2.retained_mode, "why u destroy immediate pass?")

		local retained_ids = arg_59_1.retained_ids

		if not retained_ids then
			for i = 1, #retained_ids do
				UIRenderer.destroy_text(arg_59_0, retained_ids[i])
			end

			arg_59_1.retained_ids = nil
		end
	end,
	draw = function (self, arg_60_1, arg_60_2, arg_60_3, arg_60_4, arg_60_5, arg_60_6, arg_60_7, arg_60_8, arg_60_9)
		-- function 60
		local var_60_0

		if not arg_60_3.retained_mode then
			var_60_0 = not arg_60_1.retained_ids and arg_60_1.retained_ids and true
		end

		local var_60_1

		if var_60_0 == true then
			var_60_1 = {}
		end

		local var_60_2 = arg_60_5[arg_60_1.text_id]

		if type(var_60_2) ~= "string" then
			var_60_2 = string.format("%s", var_60_2)
		end

		if not arg_60_4.localize then
			var_60_2 = Localize(var_60_2)
		end

		if not arg_60_4.upper_case then
			var_60_2 = Utf8.upper(var_60_2)
		end

		local var_60_3 = var_60_2
		local var_60_4 = fn_2(self, arg_60_4, arg_60_5[arg_60_1.text_id], var_60_3)
		local font_size = arg_60_4.font_size

		if not arg_60_4.word_wrap and not arg_60_4.dynamic_font_size_word_wrap then
			local flag = arg_60_4._dynamic_wraped_text ~= var_60_4 or arg_60_4._dynamic_wraped_scale ~= RESOLUTION_LOOKUP.scale
			local var_60_7

			if not flag then
				local scaled_font_size_by_area = UIRenderer.scaled_font_size_by_area
				local var_60_9 = self
				local var_60_10 = var_60_4
				local area_size = arg_60_4.area_size

				area_size = area_size or arg_60_7
				var_60_7 = scaled_font_size_by_area(var_60_9, var_60_10, area_size, arg_60_4)
			else
				var_60_7 = arg_60_4._dynamic_wrap_font_size
			end

			arg_60_4.font_size = var_60_7
			arg_60_4._dynamic_wrap_font_size = var_60_7
			arg_60_4._dynamic_wraped_text = var_60_4
			arg_60_4._dynamic_wraped_scale = RESOLUTION_LOOKUP.scale
		elseif not arg_60_4.dynamic_font_size then
			local scaled_font_size_by_width = UIRenderer.scaled_font_size_by_width
			local var_60_13 = self
			local var_60_14 = var_60_4
			local var_60_15

			if not arg_60_4.area_size then
				var_60_15 = arg_60_4.area_size[1]

				if not var_60_15 then
					-- Nothing
				end
			end

			var_60_15 = arg_60_7[1]

			::label_60_0::

			arg_60_4.font_size = scaled_font_size_by_width(var_60_13, var_60_14, var_60_15 - 1, arg_60_4)
		end

		local var_60_16
		local var_60_17
		local var_60_18

		if not arg_60_4.font_type then
			local var_60_19, var_60_20 = UIFontByResolution(arg_60_4)

			var_60_16, var_60_17, var_60_18 = var_60_19[1], var_60_20, arg_60_4.font_type
		end

		if not arg_60_4.word_wrap then
			local length = Utf8.length(var_60_4)
			local var_60_22, var_60_23, var_60_24 = UIGetFontHeight(self.gui, var_60_18, var_60_17)
			local word_wrap = UIRenderer.word_wrap
			local var_60_26 = self
			local var_60_27 = var_60_4
			local var_60_28 = var_60_16
			local var_60_29 = var_60_17
			local var_60_30

			if not arg_60_4.area_size then
				var_60_30 = arg_60_4.area_size[1]

				if not var_60_30 then
					-- Nothing
				end
			end

			var_60_30 = arg_60_7[1]

			::label_60_1::

			local var_60_31 = word_wrap(var_60_26, var_60_27, var_60_28, var_60_29, var_60_30)
			local text_start_index = arg_60_5.text_start_index

			text_start_index = text_start_index or 1

			local max_texts = arg_60_5.max_texts

			max_texts = max_texts or #var_60_31

			local min = math.min(#var_60_31 - (text_start_index - 1), max_texts)
			local inv_scale = RESOLUTION_LOOKUP.inv_scale
			local num = (var_60_24 - var_60_23) * inv_scale
			local font_height_multiplier = arg_60_4.font_height_multiplier

			font_height_multiplier = font_height_multiplier or 1

			local num_2 = num * font_height_multiplier
			local var_60_39 = Vector3(0, not arg_60_4.grow_downward and num_2 and -num_2, 0)

			if not arg_60_4.dynamic_height then
				arg_60_7[2] = min * num_2
				arg_60_6.y = arg_60_6.y - arg_60_7[2]
			end

			if arg_60_4.vertical_alignment == "top" then
				arg_60_6 = arg_60_6 + Vector3(0, arg_60_7[2] - var_60_24 * inv_scale, 0)
			elseif arg_60_4.vertical_alignment == "center" then
				arg_60_6[2] = arg_60_6[2] + (arg_60_7[2] - num_2 * 0.5) / 2 + math.max(min - 1, 0) * 0.5 * num_2
			else
				arg_60_6 = arg_60_6 + Vector3(0, (min - 1) * num_2 + math.abs(var_60_23) * inv_scale, 0)
			end

			local horizontal_alignment = arg_60_4.horizontal_alignment

			horizontal_alignment = horizontal_alignment or "left"

			local num_3 = 0
			local num_4 = 0

			if horizontal_alignment == "center" then
				num_4 = 0.5
			elseif horizontal_alignment == "right" then
				num_4 = 1
			end

			local num_5 = 0
			local var_60_44 = Vector3(0, 0, 0)

			for i = 1, min do
				var_60_4 = var_60_31[i - 1 + text_start_index]

				local length_2

				if not var_60_4 then
					length_2 = Utf8.length(var_60_4)

					if not length_2 then
						-- Nothing
					end
				end

				length_2 = 0

				::label_60_2::

				local var_60_46

				if horizontal_alignment ~= "left" then
					var_60_46 = UIRenderer.text_size(self, var_60_4, var_60_16, var_60_17, arg_60_7[2])
					var_60_44.x = (arg_60_7[1] - var_60_46) * num_4
				end

				if not arg_60_4.draw_text_rect then
					var_60_46 = var_60_46 or UIRenderer.text_size(self, var_60_4, var_60_16, var_60_17, arg_60_7[2])
					num_5 = not (num_5 < var_60_46) or not var_60_46 or num_5
				end

				local text_color = arg_60_4.text_color

				if not arg_60_4.line_colors and not arg_60_4.line_colors[i] then
					text_color = arg_60_4.line_colors[i]
				end

				if not arg_60_4.inject_alpha then
					var_60_4 = string.format(var_60_4, text_color[1])
				end

				local line_color_override = arg_60_4.line_color_override

				if not arg_60_4.color_override then
					line_color_override = fn_4(i, length_2, num_3, length, arg_60_4)
				end

				var_60_4 = fn_3(self, var_60_4, var_60_16, var_60_17, var_60_18, arg_60_6 + var_60_44, arg_60_4)

				local flag_2

				flag_2 = not var_60_0 and not var_60_1 and true and var_60_0[i]

				local draw_text = UIRenderer.draw_text(self, var_60_4, var_60_16, var_60_17, var_60_18, arg_60_6 + var_60_44, text_color, flag_2, line_color_override)

				if not var_60_1 then
					var_60_1[i] = draw_text
				end

				arg_60_6 = arg_60_6 + var_60_39
				num_3 = num_3 + length_2 + 1
			end

			if not arg_60_4.draw_text_rect then
				local num_6 = 4
				local num_7 = 4
				local num_8 = (arg_60_7[1] - num_5) * num_4
				local num_9 = arg_60_6 - Vector3(num_6 - num_8, num_7 * 2 + var_60_39[2], 1)
				local var_60_55 = Vector2(num_5 + num_6 * 2, min * -var_60_39[2])

				if not arg_60_4.masked then
					draw_texture(self, "rect_masked", num_9, var_60_55, arg_60_4.rect_color, arg_60_4.masked, not arg_60_4 and arg_60_4.saturated)
				else
					UIRenderer.draw_rounded_rect(self, num_9, var_60_55, 5, arg_60_4.rect_color)

					if not arg_60_4.draw_rect_border then
						UIRenderer.draw_rounded_rect(self, num_9 + Vector3(-1, -1, -1), var_60_55 + Vector2(2, 2), 5, arg_60_4.text_color)
					end
				end
			end
		elseif not arg_60_4.horizontal_scroll then
			local text_index = arg_60_5.text_index
			local length_3 = Utf8.length(var_60_4)
			local end_index = arg_60_5.end_index

			end_index = end_index or length_3

			local replacing_character = arg_60_4.replacing_character

			if not replacing_character then
				var_60_4 = string.rep(replacing_character, end_index)
			end

			local var_60_60
			local var_60_61
			local jump_to_end = arg_60_5.jump_to_end

			jump_to_end = jump_to_end or length_3 < arg_60_5.caret_index

			if not jump_to_end then
				end_index = Utf8.length(var_60_4)
				text_index = end_index
				arg_60_5.jump_to_end = nil

				local num_10 = 0
				local flag_3 = true

				while num_10 < arg_60_7[1] do
					text_index = math.max(text_index - 1, 1)
					var_60_60 = UTF8Utils.sub_string(var_60_4, text_index, end_index)
					num_10 = UIRenderer.text_size(self, var_60_60, var_60_16, var_60_17, var_60_18)

					if text_index == 1 then
						flag_3 = false

						break
					end
				end

				if not flag_3 then
					text_index = text_index + 1
					var_60_60 = UTF8Utils.sub_string(var_60_4, text_index, end_index)
				end

				arg_60_5.text_index = text_index
				arg_60_5.end_index = nil
			else
				var_60_60 = UTF8Utils.sub_string(var_60_4, text_index, end_index)
			end

			local caret_index = arg_60_5.caret_index

			if caret_index > end_index + 1 then
				arg_60_5.text_index = arg_60_5.text_index + 1
				arg_60_5.end_index = end_index + 1
			elseif caret_index < text_index then
				arg_60_5.text_index = arg_60_5.text_index - 1
				arg_60_5.end_index = end_index - 1
			end

			local caret_size = arg_60_4.caret_size

			if not caret_size then
				local caret_offset = arg_60_4.caret_offset
				local sub_string = UTF8Utils.sub_string(var_60_60, 1, arg_60_5.caret_index - arg_60_5.text_index)
				local text_size = UIRenderer.text_size(self, sub_string, var_60_16, var_60_17, var_60_18)
				local num_11 = arg_60_6 + Vector3(text_size + caret_offset[1], caret_offset[2], caret_offset[3])
				local flag_4

				flag_4 = not var_60_0 and not var_60_1 and true and var_60_0[1]

				local draw_text_2 = UIRenderer.draw_text(self, sub_string, var_60_16, var_60_17, var_60_18, arg_60_6, arg_60_4.text_color, flag_4, arg_60_4.color_override)

				if not var_60_1 then
					var_60_1[1] = draw_text_2
				end

				if not arg_60_4.masked then
					draw_texture(self, "rect_masked", num_11, caret_size, arg_60_4.caret_color, not arg_60_4 and arg_60_4.masked, not arg_60_4 and arg_60_4.saturated)
				else
					UIRenderer.draw_rect(self, num_11, caret_size, arg_60_4.caret_color)
				end

				local sub = string.sub(var_60_60, #sub_string + 1, #var_60_60 + 1)

				arg_60_6[1] = arg_60_6[1] + text_size

				UIRenderer.draw_text(self, sub, var_60_16, var_60_17, var_60_18, arg_60_6, arg_60_4.text_color, draw_text_2, arg_60_4.color_override)
			else
				local flag_5

				flag_5 = not var_60_0 and not var_60_1 and true and var_60_0[1]

				local draw_text_3 = UIRenderer.draw_text(self, var_60_60, var_60_16, var_60_17, var_60_18, arg_60_6, arg_60_4.text_color, flag_5, arg_60_4.color_override)

				if not var_60_1 then
					var_60_1[1] = draw_text_3
				end
			end
		else
			local var_60_76, var_60_77, var_60_78 = UIGetFontHeight(self.gui, var_60_18, var_60_17)
			local text_size_2, var_60_80, var_60_81 = UIRenderer.text_size(self, var_60_4, var_60_16, var_60_17, var_60_18)
			local num_12 = arg_60_6 + fn(text_size_2, var_60_76, var_60_77, var_60_78, arg_60_7, var_60_81, arg_60_4)
			local var_60_83 = fn_3(self, var_60_4, var_60_16, var_60_17, var_60_18, num_12, arg_60_4)
			local flag_6

			flag_6 = not var_60_0 and not var_60_1 and true and var_60_0[1]

			local draw_text_4 = UIRenderer.draw_text(self, var_60_83, var_60_16, var_60_17, var_60_18, num_12, arg_60_4.text_color, flag_6, arg_60_4.color_override)

			if not var_60_1 then
				var_60_1[1] = draw_text_4
			end
		end

		if not arg_60_3.retained_mode then
			arg_60_1.retained_ids = var_60_1 or arg_60_1.retained_ids
			arg_60_1.dirty = false
		end

		arg_60_4.font_size = font_size
	end,
	get_preferred_size = function (self, arg_61_1, arg_61_2, arg_61_3, arg_61_4, arg_61_5, arg_61_6, arg_61_7, arg_61_8)
		-- function 61
		local var_61_0 = arg_61_5[arg_61_1.text_id]
		local var_61_1, var_61_2 = UIFontByResolution(arg_61_4)
		local font_type = arg_61_4.font_type
		local var_61_4 = var_61_1[1]

		if not arg_61_4.localize then
			var_61_0 = Localize(var_61_0)
		end

		if not arg_61_4.upper_case then
			var_61_0 = Utf8.upper(var_61_0)
		end

		local var_61_5
		local var_61_6

		if not arg_61_4.word_wrap then
			local var_61_7, var_61_8, var_61_9 = UIGetFontHeight(self.gui, font_type, var_61_2)
			local word_wrap = UIRenderer.word_wrap(self, var_61_0, var_61_4, var_61_2, arg_61_4.size[1])
			local num = 1
			local count = #word_wrap
			local min = math.min(#word_wrap - (num - 1), count)
			local inv_scale = RESOLUTION_LOOKUP.inv_scale

			var_61_6 = (var_61_9 + math.abs(var_61_8)) * inv_scale * min
			var_61_5 = arg_61_4.size[1]
		else
			var_61_5, var_61_6 = UIRenderer.text_size(self, var_61_0, var_61_1[1], var_61_2)
		end

		return var_61_5, var_61_6
	end
}

local function fn_5(arg_62_0, arg_62_1, arg_62_2, arg_62_3, arg_62_4, arg_62_5, arg_62_6, arg_62_7)
	-- function 62
	local width = arg_62_1.width
	local texts = arg_62_1.texts
	local num = #texts / 3
	local var_62_3 = arg_62_0

	for i = 1, num do
		local var_62_4 = texts[i * 3 - 2]
		local var_62_5 = texts[i * 3 - 1]
		local num_2 = arg_62_3 + texts[i * 3]:unbox()

		if not var_62_5 then
			var_62_3 = UIRenderer.draw_justified_text(arg_62_2, var_62_4, arg_62_4, arg_62_5, arg_62_6, num_2, arg_62_7, var_62_3, width)
		else
			var_62_3 = UIRenderer.draw_text(arg_62_2, var_62_4, arg_62_4, arg_62_5, arg_62_6, num_2, arg_62_7)
		end
	end

	return var_62_3
end

UIPasses.lorebook_multiple_texts = {
	init = function (self)
		-- function 63
		assert(self.text_id, "no text id in pass definition. YOU NEEDS IT.")

		local tbl = {
			text_id = self.text_id
		}
		local flag

		flag = not self.retained_mode and true and nil
		tbl.dirty = flag

		return tbl
	end,
	destroy = function (arg_64_0, arg_64_1, arg_64_2)
		-- function 64
		assert(arg_64_2.retained_mode, "why u destroy immediate pass?")

		if not arg_64_1.retained_id then
			UIRenderer.destroy_text(arg_64_0, arg_64_1.retained_id)

			arg_64_1.retained_id = nil
		end
	end,
	draw = function (arg_65_0, arg_65_1, arg_65_2, arg_65_3, arg_65_4, arg_65_5, arg_65_6, arg_65_7, arg_65_8, arg_65_9)
		-- function 65
		local var_65_0

		if not arg_65_3.retained_mode then
			var_65_0 = not arg_65_1.retained_id and arg_65_1.retained_id and true
		end

		local var_65_1
		local var_65_2
		local var_65_3

		if not arg_65_4.font_type then
			local var_65_4, var_65_5 = UIFontByResolution(arg_65_4)

			var_65_1, var_65_2, var_65_3 = var_65_4[1], var_65_5, var_65_4[3]
		else
			local font = arg_65_4.font

			var_65_1, var_65_2, var_65_3 = font[1], font[2], font[3]
			var_65_2 = arg_65_4.font_size or var_65_2
		end

		local text_color = arg_65_4.text_color
		local page = arg_65_5.page
		local top = page.top

		arg_65_6.y = arg_65_6.y + arg_65_7[2]

		local var_65_10 = fn_5(var_65_0, top, arg_65_0, arg_65_6, var_65_1, var_65_2, var_65_3, text_color)
		local center = page.center
		local var_65_12 = fn_5(var_65_10, center, arg_65_0, arg_65_6, var_65_1, var_65_2, var_65_3, text_color)
		local bottom = page.bottom
		local var_65_14 = fn_5(var_65_12, bottom, arg_65_0, arg_65_6, var_65_1, var_65_2, var_65_3, text_color)

		if not arg_65_3.retained_mode then
			arg_65_1.retained_id = var_65_14 or arg_65_1.retained_id
			arg_65_1.dirty = false
		end
	end
}
UIPasses.lorebook_paragraph_divider = {
	init = function (self)
		-- function 66
		if not self.retained_mode then
			return {
				dirty = true
			}
		end
	end,
	destroy = function (arg_67_0, arg_67_1, arg_67_2)
		-- function 67
		assert(arg_67_2.retained_mode, "why u destroy immediate pass?")

		if not arg_67_1.retained_id then
			UIRenderer.destroy_bitmap(arg_67_0, arg_67_1.retained_id)

			arg_67_1.retained_id = nil
		end
	end,
	draw = function (arg_68_0, arg_68_1, arg_68_2, arg_68_3, arg_68_4, arg_68_5, arg_68_6, arg_68_7, arg_68_8, arg_68_9)
		-- function 68
		local positions = arg_68_5.positions
		local count = #positions
		local texture_id = arg_68_3.texture_id

		texture_id = texture_id or "texture_id"

		local var_68_3 = arg_68_6[2]

		if not arg_68_3.retained_mode then
			for i = 1, count do
				arg_68_6[2] = var_68_3 + positions[i]

				local var_68_4 = arg_68_5[texture_id][i]
				local retained_mode = arg_68_3.retained_mode

				if not retained_mode then
					if not arg_68_1.retained_id then
						retained_mode = arg_68_1.retained_id

						if not retained_mode then
							-- Nothing
						end
					end

					retained_mode = true
				end

				::label_68_0::

				local var_68_6 = draw_texture(arg_68_0, var_68_4, arg_68_6, arg_68_7, not arg_68_4 and arg_68_4.color, not arg_68_4 and arg_68_4.masked, not arg_68_4 and arg_68_4.saturated, retained_mode)

				arg_68_1.retained_id = not var_68_6 and var_68_6 and arg_68_1.retained_id
				arg_68_1.dirty = false
			end
		else
			for j = 1, count do
				arg_68_6[2] = var_68_3 + positions[j]

				local var_68_7 = arg_68_5[texture_id][j]

				draw_texture(arg_68_0, var_68_7, arg_68_6, arg_68_7, not arg_68_4 and arg_68_4.color, not arg_68_4 and arg_68_4.masked, not arg_68_4 and arg_68_4.saturated)
			end
		end
	end
}
UIPasses.multiple_texts = {
	init = function (self)
		-- function 69
		assert(self.texts_id, "no text id in pass definition. YOU NEEDS IT.")

		return {
			texts_id = self.texts_id
		}
	end,
	draw = function (arg_70_0, arg_70_1, arg_70_2, arg_70_3, arg_70_4, arg_70_5, arg_70_6, arg_70_7, arg_70_8, arg_70_9)
		-- function 70
		local var_70_0, var_70_1 = UIFontByResolution(arg_70_4)
		local var_70_2 = var_70_0[1]
		local var_70_3 = var_70_1
		local var_70_4 = var_70_0[3]
		local texts

		if not arg_70_5[arg_70_1.texts_id] then
			texts = arg_70_5[arg_70_1.texts_id].texts

			if not texts then
				-- Nothing
			end
		end

		texts = arg_70_5.texts

		::label_70_0::

		local axis = arg_70_4.axis

		axis = axis or 2

		local direction = arg_70_4.direction

		direction = direction or 1

		local flag = direction == 2

		for i = 1, #texts do
			local var_70_9 = texts[i]

			if not arg_70_4.localize then
				var_70_9 = Localize(var_70_9)
			end

			local text_size, var_70_11 = UIRenderer.text_size(arg_70_0, var_70_9, var_70_2, var_70_3)
			local var_70_12 = Vector3(0, 0, 0)

			if axis == 2 then
				if arg_70_4.horizontal_alignment == "center" then
					var_70_12[1] = arg_70_7[1] * 0.5 - text_size * 0.5
				elseif arg_70_4.horizontal_alignment == "right" then
					var_70_12[1] = arg_70_7[1] - text_size
				end

				if arg_70_4.vertical_alignment == "center" then
					var_70_12[2] = arg_70_7[2] * 0.5 - var_70_11 * 0.5
				elseif arg_70_4.vertical_alignment == "top" then
					var_70_12[2] = arg_70_7[2] - var_70_11
				end
			else
				if i ~= 1 or not flag then
					arg_70_6[axis] = arg_70_6[axis] - arg_70_7[axis]
				end

				if arg_70_4.horizontal_alignment == "center" then
					var_70_12[1] = arg_70_7[1] * 0.5 - text_size * 0.5
				elseif arg_70_4.horizontal_alignment == "right" then
					var_70_12[1] = arg_70_7[1] - text_size
				end

				if arg_70_4.vertical_alignment == "center" then
					var_70_12[2] = arg_70_7[2] * 0.5 - var_70_11 * 0.5
				elseif arg_70_4.vertical_alignment == "top" then
					var_70_12[2] = arg_70_7[2] - var_70_11
				end
			end

			UIRenderer.draw_text(arg_70_0, var_70_9, var_70_2, var_70_3, var_70_4, arg_70_6 + var_70_12, arg_70_4.text_color)

			if axis == 2 then
				if not flag then
					arg_70_6[2] = arg_70_6[2] + arg_70_7[2] + arg_70_4.spacing
				else
					arg_70_6[2] = arg_70_6[2] - arg_70_7[2] - arg_70_4.spacing
				end
			elseif not flag then
				arg_70_6[1] = arg_70_6[1] - arg_70_7[1] - arg_70_4.spacing
			else
				arg_70_6[1] = arg_70_6[1] + arg_70_7[1] + arg_70_4.spacing
			end
		end
	end
}
UIPasses.viewport = {
	init = function (self, arg_71_1, arg_71_2)
		-- function 71
		local var_71_0 = arg_71_2[self.style_id]
		local world_flags = var_71_0.world_flags

		world_flags = world_flags or {
			Application.DISABLE_SOUND,
			Application.DISABLE_ESRAM
		}

		local shading_environment = var_71_0.shading_environment
		local create_world = Managers.world:create_world(var_71_0.world_name, shading_environment, nil, var_71_0.layer, unpack(world_flags))
		local viewport_type = var_71_0.viewport_type

		viewport_type = viewport_type or "default"

		local create_viewport = ScriptWorld.create_viewport(create_world, var_71_0.viewport_name, viewport_type, var_71_0.layer)
		local level_name = var_71_0.level_name
		local object_sets = var_71_0.object_sets
		local var_71_8

		if not level_name then
			local var_71_9
			local var_71_10
			local var_71_11
			local mood_setting = var_71_0.mood_setting
			local flag = false

			var_71_8 = ScriptWorld.spawn_level(create_world, level_name, object_sets, var_71_9, var_71_10, var_71_11, mood_setting, flag)

			Level.spawn_background(var_71_8)
		end

		local flag_2 = true

		ScriptWorld.deactivate_viewport(create_world, create_viewport)

		local unbox = Vector3Aux.unbox(var_71_0.camera_position)
		local unbox_2 = Vector3Aux.unbox(var_71_0.camera_lookat)
		local normalize = Vector3.normalize(unbox_2 - unbox)
		local camera = ScriptViewport.camera(create_viewport)

		ScriptCamera.set_local_position(camera, unbox)
		ScriptCamera.set_local_rotation(camera, Quaternion.look(normalize))

		local fov = var_71_0.fov

		fov = fov or 65

		Camera.set_vertical_fov(camera, math.pi * fov / 180)

		local var_71_20

		if not var_71_0.enable_sub_gui then
			var_71_20 = UIRenderer.create(create_world, "material", "materials/ui/ui_1080p_hud_atlas_textures", "material", "materials/ui/ui_1080p_hud_single_textures", "material", "materials/ui/ui_1080p_menu_atlas_textures", "material", "materials/ui/ui_1080p_menu_single_textures", "material", "materials/ui/ui_1080p_common", "material", "materials/ui/ui_1080p_versus_available_common", "material", "materials/fonts/gw_fonts")
		end

		return {
			deactivated = flag_2,
			world = create_world,
			world_name = var_71_0.world_name,
			level = var_71_8,
			viewport = create_viewport,
			viewport_name = var_71_0.viewport_name,
			ui_renderer = var_71_20,
			camera = camera
		}
	end,
	destroy = function (arg_72_0, arg_72_1, arg_72_2)
		-- function 72
		if not arg_72_1.ui_renderer then
			UIRenderer.destroy(arg_72_1.ui_renderer, arg_72_1.world)

			arg_72_1.ui_renderer = nil
		end

		ScriptWorld.destroy_viewport(arg_72_1.world, arg_72_1.viewport_name)
		Managers.world:destroy_world(arg_72_1.world)
	end,
	draw = function (arg_73_0, arg_73_1, arg_73_2, arg_73_3, arg_73_4, arg_73_5, arg_73_6, arg_73_7, arg_73_8, arg_73_9)
		-- function 73
		local viewport_size = arg_73_4.viewport_size

		if not viewport_size then
			if arg_73_4.horizontal_alignment == "right" then
				arg_73_6[1] = arg_73_6[1] + arg_73_7[1] - viewport_size[1]
			elseif arg_73_4.horizontal_alignment == "center" then
				arg_73_6[1] = arg_73_6[1] + (arg_73_7[1] - viewport_size[1]) / 2
			end

			if arg_73_4.vertical_alignment == "center" then
				arg_73_6[2] = arg_73_6[2] + (arg_73_7[2] - viewport_size[2]) / 2
			elseif arg_73_4.vertical_alignment == "top" then
				arg_73_6[2] = arg_73_6[2] + arg_73_7[2] - viewport_size[2]
			end

			arg_73_7 = viewport_size
		end

		local var_73_1 = UIScaleVectorToResolution(arg_73_6)
		local var_73_2 = UIScaleVectorToResolution(arg_73_7)
		local res_w = RESOLUTION_LOOKUP.res_w
		local res_h = RESOLUTION_LOOKUP.res_h
		local zero = Vector3.zero()

		zero.x = math.clamp(var_73_2.x / res_w, 0, 1)
		zero.y = math.clamp(var_73_2.y / res_h, 0, 1)

		local zero_2 = Vector3.zero()

		zero_2.x = math.clamp(var_73_1.x / res_w, 0, 1)
		zero_2.y = math.clamp(1 - var_73_1.y / res_h - zero.y, 0, 1)

		local viewport = arg_73_1.viewport
		local world = arg_73_1.world

		if not (res_w < var_73_1.x or not (var_73_1.x < 0)) then
			if not arg_73_1.deactivated then
				ScriptWorld.deactivate_viewport(world, viewport)
			end

			arg_73_1.deactivated = true
		elseif not arg_73_1.deactivated then
			ScriptWorld.activate_viewport(world, viewport)

			arg_73_1.deactivated = false
		end

		local flag = false

		if not Managers.splitscreen then
			flag = Managers.splitscreen:active()
		end

		local flag_2

		flag_2 = not flag and 0.5 and 1

		Viewport.set_rect(viewport, zero_2.x * flag_2, zero_2.y * flag_2, zero.x * flag_2, zero.y * flag_2)

		arg_73_5.viewport_size_x = zero.x
		arg_73_5.viewport_size_y = zero.y
		arg_73_1.viewport_rect_pos_x = zero_2.x
		arg_73_1.viewport_rect_pos_y = zero_2.y
		arg_73_1.viewport_rect_size_x = var_73_2.x
		arg_73_1.viewport_rect_size_y = var_73_2.y
		arg_73_1.size_scale_x = zero.x
		arg_73_1.size_scale_y = zero.y
	end,
	raycast_at_screen_position = function (self, arg_74_1, arg_74_2, arg_74_3, arg_74_4)
		-- function 74
		if self.viewport_rect_pos_x == nil then
			return nil
		end

		local res_w = RESOLUTION_LOOKUP.res_w
		local res_h = RESOLUTION_LOOKUP.res_h
		local zero = Vector3.zero()
		local num = res_w / res_h
		local num_2 = 1.7777777777777777

		if num < num_2 then
			local num_3 = arg_74_1.x / res_w
			local num_4 = res_h / 9 * 16

			zero.x = res_w * 0.5 - num_4 * 0.5 + num_4 * num_3

			local num_5 = arg_74_1.y / res_h
			local num_6 = self.size_scale_x * res_h

			zero.y = res_h * 0.5 - num_6 * 0.5 + num_6 * num_5
		elseif num_2 < num then
			local num_7 = arg_74_1.x / res_w
			local num_8 = self.size_scale_y * res_w

			zero.x = res_w * 0.5 - num_8 * 0.5 + num_8 * num_7
			zero.y = arg_74_1.y
		else
			zero.x = arg_74_1.x
			zero.y = arg_74_1.y
		end

		local screen_to_world = Camera.screen_to_world(self.camera, zero, 0)
		local num_9 = Camera.screen_to_world(self.camera, zero + Vector3(0, 0, 0), 1) - screen_to_world
		local normalize = Vector3.normalize(num_9)
		local get_data = World.get_data(self.world, "physics_world")

		return PhysicsWorld.immediate_raycast(get_data, screen_to_world, normalize, arg_74_3, arg_74_2, "collision_filter", arg_74_4)
	end
}

local script_data = script_data
local ui_debug_hover = script_data.ui_debug_hover

ui_debug_hover = ui_debug_hover or Development.parameter("ui_debug_hover")
script_data.ui_debug_hover = ui_debug_hover

local script_data_2 = script_data
local ui_debug_drag = script_data.ui_debug_drag

ui_debug_drag = ui_debug_drag or Development.parameter("ui_debug_drag")
script_data_2.ui_debug_drag = ui_debug_drag

local tbl_16 = {
	0,
	0,
	0
}
local start_drag_threshold = UISettings.start_drag_threshold

UIPasses.is_dragging_item = false
UIPasses.drag = {
	init = function (arg_75_0, arg_75_1, arg_75_2)
		-- function 75
		return nil
	end,
	draw = function (arg_76_0, arg_76_1, arg_76_2, arg_76_3, arg_76_4, arg_76_5, arg_76_6, arg_76_7, arg_76_8, arg_76_9)
		-- function 76
		if not arg_76_5.ui_top_renderer then
			arg_76_0 = arg_76_5.ui_top_renderer
		end

		if not arg_76_5.on_drag_stopped then
			arg_76_5.on_drag_stopped = nil
			UIPasses.is_dragging_item = false
		end

		if not arg_76_5.on_drag_started then
			arg_76_5.on_drag_started = nil
		end

		if not arg_76_5.drag_disabled then
			return
		end

		if not arg_76_5[arg_76_3.texture_id] then
			return
		end

		local get = arg_76_8:get("cursor")

		get = get or tbl

		local var_76_1 = UIInverseScaleVectorToResolution(get)
		local on_drag_started = arg_76_5.on_drag_started
		local is_dragging = arg_76_5.is_dragging

		if not is_dragging then
			if not arg_76_8:get("left_press") and not math.point_is_inside_2d_box(var_76_1, arg_76_6, arg_76_7) then
				arg_76_5.hover_start_timer = 0
			elseif not arg_76_5.hover_start_timer then
				if not arg_76_8:get("left_hold") then
					arg_76_5.hover_start_timer = arg_76_5.hover_start_timer + arg_76_9
				else
					arg_76_5.hover_start_timer = nil
				end
			end
		end

		local hover_start_timer = arg_76_5.hover_start_timer

		if not (not hover_start_timer and not (hover_start_timer >= start_drag_threshold)) then
			arg_76_5.hover_start_timer = nil
			arg_76_5.on_drag_started = true
			arg_76_5.is_dragging = true
			UIPasses.is_dragging_item = true
		elseif not is_dragging and not arg_76_8:get("left_hold") then
			if not on_drag_started then
				arg_76_5.on_drag_started = nil
			end

			local drag_texture_size = arg_76_5.drag_texture_size

			assert(drag_texture_size, "Missing texture_size")

			tbl_16[1] = var_76_1.x - drag_texture_size[1] * 0.5
			tbl_16[2] = var_76_1.y - drag_texture_size[2] * 0.5
			tbl_16[3] = 999

			draw_texture(arg_76_0, arg_76_5[arg_76_3.texture_id], tbl_16, drag_texture_size, nil, nil, false)
		elseif not is_dragging and not arg_76_8:get("left_release") then
			arg_76_5.is_dragging = nil
			arg_76_5.on_drag_stopped = true
		end

		if not script_data.ui_debug_drag then
			local draw_rect = UIRenderer.draw_rect
			local var_76_7 = arg_76_0
			local num = arg_76_6 + Vector3(0, 0, 1)
			local var_76_9 = arg_76_7
			local tbl_2

			if not arg_76_5.is_dragging then
				tbl_2 = {
					128,
					0,
					100,
					100
				}

				if not tbl_2 then
					-- Nothing
				end
			end

			tbl_2 = {
				0,
				0,
				0,
				255
			}

			::label_76_0::

			draw_rect(var_76_7, num, var_76_9, tbl_2)
		end
	end
}

local tbl_17 = {
	0,
	0,
	0
}

UIPasses.gamepad_cursor = {
	init = function (arg_77_0, arg_77_1, arg_77_2)
		-- function 77
		return nil
	end,
	draw = function (arg_78_0, arg_78_1, arg_78_2, arg_78_3, arg_78_4, arg_78_5, arg_78_6, arg_78_7, arg_78_8, arg_78_9)
		-- function 78
		if not Managers.input:gamepad_cursor_active() then
			return
		end

		if not arg_78_5.ui_top_renderer then
			arg_78_0 = arg_78_5.ui_top_renderer
		end

		local get = arg_78_8:get("cursor")

		get = get or tbl

		local offset = arg_78_4.offset

		offset = offset or {
			0,
			0
		}

		local var_78_2 = tbl_17
		local x = get.x

		x = x or 0
		var_78_2[1] = x + offset[1]

		local var_78_4 = tbl_17
		local y = get.y

		y = y or 0
		var_78_4[2] = y + offset[2]
		tbl_17[3] = 1000

		if not Managers.input:is_device_active("gamepad") then
			draw_texture(arg_78_0, arg_78_5[arg_78_3.texture_id], tbl_17, arg_78_4.size, nil, nil, false)
		end

		if not script_data.ui_debug_hover then
			local var_78_6 = Vector2(GAMEPAD_CURSOR_SIZE * 0.5, GAMEPAD_CURSOR_SIZE * 0.5)
			local num = Vector3(tbl_17[1], tbl_17[2], tbl_17[3]) + var_78_6 * 0.5

			UIRenderer.draw_rect(arg_78_0, {
				num[1],
				num[2],
				num[3]
			}, {
				var_78_6[1],
				var_78_6[2]
			}, {
				128,
				255,
				255,
				255
			})
		end

		if not script_data.ui_debug_drag then
			local draw_rect = UIRenderer.draw_rect
			local var_78_9 = arg_78_0
			local num_2 = arg_78_6 + Vector3(0, 0, 1)
			local var_78_11 = arg_78_7
			local tbl_2

			if not arg_78_5.is_dragging then
				tbl_2 = {
					128,
					0,
					100,
					100
				}

				if not tbl_2 then
					-- Nothing
				end
			end

			tbl_2 = {
				0,
				0,
				0,
				255
			}

			::label_78_0::

			draw_rect(var_78_9, num_2, var_78_11, tbl_2)
		end
	end
}
UIPasses.hover = {
	init = function (arg_79_0)
		-- function 79
		return nil
	end,
	draw = function (self, arg_80_1, arg_80_2, arg_80_3, arg_80_4, arg_80_5, arg_80_6, arg_80_7, arg_80_8, arg_80_9)
		-- function 80
		local is_hover = arg_80_5.is_hover
		local var_80_1
		local get

		if not arg_80_8 and not arg_80_8:has("cursor") then
			get = arg_80_8:get("cursor")

			if not get then
				-- Nothing
			end
		end

		get = tbl

		::label_80_0::

		if arg_80_5.hover_type == "circle" then
			local num = self:get_scaling() * arg_80_7 / 2
			local num_2 = Vector3Aux.flat(ScaleVectorToResolution(arg_80_6)) + num

			var_80_1 = Vector3.distance_squared(Vector3Aux.unbox(get), num_2) <= num.x * num.y or false
		else
			if not arg_80_4 then
				local area_size = arg_80_4.area_size

				if not area_size then
					UIUtils.align_box_inplace(arg_80_4, arg_80_6, arg_80_7, area_size)

					arg_80_7 = area_size
				end
			end

			local is_device_active = Managers.input:is_device_active("gamepad")
			local var_80_7 = get

			if not is_device_active then
				var_80_7 = UIInverseScaleVectorToResolution(get)
			end

			var_80_1 = math.point_is_inside_2d_box(var_80_7, arg_80_6, arg_80_7)

			if not script_data.ui_debug_hover then
				local draw_rect = UIRenderer.draw_rect
				local var_80_9 = self
				local num_3 = arg_80_6 + Vector3(0, 0, 1)
				local var_80_11 = arg_80_7
				local tbl_2

				if not arg_80_5.is_hover then
					tbl_2 = {
						128,
						0,
						255,
						0
					}

					if not tbl_2 then
						-- Nothing
					end
				end

				tbl_2 = {
					128,
					255,
					0,
					0
				}

				::label_80_1::

				draw_rect(var_80_9, num_3, var_80_11, tbl_2)
			end
		end

		if not (not var_80_1 and is_hover) then
			arg_80_5.is_hover = not UIPasses.is_dragging_item
			arg_80_5.internal_is_hover = true
		end

		if not (not is_hover and var_80_1) then
			arg_80_5.is_hover = nil
			arg_80_5.internal_is_hover = nil
		end

		if var_80_1 or not arg_80_5.internal_is_hover then
			arg_80_5.internal_is_hover = nil
		end
	end
}
UIPasses.click = {
	init = function (arg_81_0)
		-- function 81
		return nil
	end,
	draw = function (arg_82_0, arg_82_1, arg_82_2, arg_82_3, arg_82_4, arg_82_5, arg_82_6, arg_82_7, arg_82_8, arg_82_9)
		-- function 82
		if not arg_82_5.is_hover and not arg_82_8:get("left_release") then
			arg_82_5.is_clicked = 0
		else
			local is_clicked = arg_82_5.is_clicked

			is_clicked = is_clicked or 10
			arg_82_5.is_clicked = is_clicked + arg_82_9
		end
	end
}
UIPasses.generic_tooltip = {
	init = function (arg_83_0, arg_83_1, arg_83_2)
		-- function 83
		local tbl = {}

		tbl.passes, tbl.end_pass = {
			{
				data = UITooltipPasses.generic_text.setup_data(),
				draw = UITooltipPasses.generic_text.draw
			}
		}, {
			data = UITooltipPasses.background.setup_data(),
			draw = UITooltipPasses.background.draw
		}
		tbl.size = {
			400,
			0
		}
		tbl.alpha_multiplier = 1

		return tbl
	end,
	draw = function (arg_84_0, arg_84_1, arg_84_2, arg_84_3, arg_84_4, arg_84_5, arg_84_6, arg_84_7, arg_84_8, arg_84_9)
		-- function 84
		local size = arg_84_1.size

		size[2] = 0

		local flag = false
		local res_w = RESOLUTION_LOOKUP.res_w
		local res_h = RESOLUTION_LOOKUP.res_h

		if arg_84_6[2] + arg_84_7[2] * 0.5 > res_h * 0.5 then
			flag = true
			arg_84_6[2] = arg_84_6[2] + arg_84_7[2]
		end

		if arg_84_6[1] + arg_84_7[1] * 0.5 > res_w * 0.5 then
			arg_84_6[1] = arg_84_6[1] - size[1] - 5
		else
			arg_84_6[1] = arg_84_6[1] + arg_84_7[1] + 5
		end

		local var_84_4 = arg_84_6[1]
		local var_84_5 = arg_84_6[2]
		local var_84_6 = arg_84_6[3]
		local ipairs

		if not flag then
			ipairs = ipairs

			if not ipairs then
				-- Nothing
			end
		end

		ipairs = ripairs

		::label_84_0::

		local passes = arg_84_1.passes
		local flag_2 = true

		for iter_84_0, iter_84_1 in ipairs(passes) do
			local data = iter_84_1.data
			local draw = iter_84_1.draw(data, flag_2, flag, arg_84_0, arg_84_1, arg_84_2, arg_84_3, arg_84_4, arg_84_5, arg_84_6, size, arg_84_8, arg_84_9)

			size[2] = size[2] + draw

			if not flag then
				arg_84_6[2] = arg_84_6[2] - draw
			else
				arg_84_6[2] = arg_84_6[2] + draw
			end
		end

		arg_84_6[1] = var_84_4
		arg_84_6[2] = var_84_5
		arg_84_6[3] = var_84_6

		local end_pass = arg_84_1.end_pass

		if not end_pass then
			local data_2 = end_pass.data

			end_pass.draw(data_2, flag_2, flag, arg_84_0, arg_84_1, arg_84_2, arg_84_3, arg_84_4, arg_84_5, arg_84_6, size, arg_84_8, arg_84_9)
		end
	end
}
UIPasses.additional_option_tooltip = {
	init = function (self, arg_85_1, arg_85_2)
		-- function 85
		local tbl = {}
		local content_passes = self.content_passes

		content_passes = content_passes or {
			"additional_option_info"
		}

		local tbl_2 = {}

		for i, v in ipairs(content_passes) do
			tbl_2[#tbl_2 + 1] = {
				data = UITooltipPasses[v].setup_data(),
				draw = UITooltipPasses[v].draw
			}
		end

		tbl.end_pass = {
			data = UITooltipPasses.background.setup_data(),
			draw = UITooltipPasses.background.draw
		}

		local flag = not arg_85_2 and arg_85_2[self.style_id]
		local max_width

		if not flag then
			max_width = flag.max_width

			if not max_width then
				-- Nothing
			end
		end

		max_width = 400

		::label_85_0::

		tbl.passes = tbl_2
		tbl.size = {
			max_width,
			0
		}
		tbl.alpha_multiplier = 1

		return tbl
	end,
	update = function (arg_86_0, arg_86_1, arg_86_2, arg_86_3, arg_86_4, arg_86_5, arg_86_6, arg_86_7, arg_86_8)
		-- function 86
		if not arg_86_8 then
			arg_86_1.alpha_progress = 0
			arg_86_1.alpha_wait_time = UISettings.tooltip_wait_duration
		end
	end,
	draw = function (arg_87_0, arg_87_1, arg_87_2, arg_87_3, arg_87_4, arg_87_5, arg_87_6, arg_87_7, arg_87_8, arg_87_9)
		-- function 87
		local var_87_0 = arg_87_5[arg_87_3.additional_option_id]

		if not var_87_0 then
			return
		end

		if not Managers.input:is_device_active("gamepad") then
			Managers.input:set_showing_tooltip(true)
		end

		local alpha_wait_time = arg_87_1.alpha_wait_time
		local alpha_progress = arg_87_1.alpha_progress

		if not alpha_wait_time then
			local num = alpha_wait_time - arg_87_9

			if num <= 0 then
				arg_87_1.alpha_wait_time = nil
			else
				arg_87_1.alpha_wait_time = num
			end

			arg_87_1.alpha_multiplier = 0
		elseif not alpha_progress then
			local tooltip_fade_in_speed = UISettings.tooltip_fade_in_speed
			local min = math.min(alpha_progress + arg_87_9 * tooltip_fade_in_speed, 1)

			arg_87_1.alpha_multiplier = math.easeOutCubic(min)

			if min == 1 then
				arg_87_1.alpha_progress = nil
			else
				arg_87_1.alpha_progress = min
			end
		end

		local var_87_6 = arg_87_6[1]
		local var_87_7 = arg_87_6[2]
		local var_87_8 = arg_87_6[3]
		local size = arg_87_1.size

		size[2] = 0

		local flag = true

		if arg_87_4.horizontal_alignment == "center" then
			arg_87_6[1] = arg_87_6[1] + arg_87_7[1] / 2 - size[1] / 2
		elseif arg_87_4.horizontal_alignment == "right" then
			arg_87_6[1] = arg_87_6[1] + arg_87_7[1] - size[1]
		else
			arg_87_6[1] = arg_87_6[1] - size[1]
		end

		local num_2 = 0
		local passes = arg_87_1.passes
		local flag_2 = false
		local end_pass = arg_87_1.end_pass

		if not end_pass then
			local data = end_pass.data

			num_2 = num_2 + end_pass.draw(data, flag_2, flag, arg_87_0, arg_87_1, arg_87_2, arg_87_3, arg_87_4, arg_87_5, arg_87_6, size, arg_87_8, arg_87_9)
		end

		local frame_margin = end_pass.data.frame_margin

		frame_margin = frame_margin or 0

		for i, v in ipairs(passes) do
			local data_2 = v.data

			data_2.frame_margin = frame_margin
			num_2 = num_2 + v.draw(data_2, flag_2, flag, arg_87_0, arg_87_1, arg_87_2, arg_87_3, arg_87_4, arg_87_5, arg_87_6, size, arg_87_8, arg_87_9, var_87_0)
		end

		if arg_87_4.vertical_alignment == "top" then
			arg_87_6[2] = arg_87_6[2] + arg_87_7[2] + num_2
		else
			arg_87_6[2] = arg_87_6[2] + num_2
		end

		if not arg_87_4.grow_downwards then
			arg_87_6[2] = arg_87_6[2] - num_2
		end

		local var_87_18 = arg_87_6[1]
		local var_87_19 = arg_87_6[2]
		local var_87_20 = arg_87_6[3]
		local flag_3 = true

		for i_2, v_2 in ipairs(passes) do
			local data_3 = v_2.data

			data_3.frame_margin = frame_margin

			local draw = v_2.draw(data_3, flag_3, flag, arg_87_0, arg_87_1, arg_87_2, arg_87_3, arg_87_4, arg_87_5, arg_87_6, size, arg_87_8, arg_87_9, var_87_0)

			size[2] = size[2] + draw
			arg_87_6[2] = arg_87_6[2] - draw
		end

		arg_87_6[1] = var_87_18
		arg_87_6[2] = var_87_19
		arg_87_6[3] = var_87_20

		if not end_pass then
			local data_4 = end_pass.data

			end_pass.draw(data_4, flag_3, flag, arg_87_0, arg_87_1, arg_87_2, arg_87_3, arg_87_4, arg_87_5, arg_87_6, size, arg_87_8, arg_87_9)
		end

		arg_87_6[1] = var_87_6
		arg_87_6[2] = var_87_7
		arg_87_6[3] = var_87_8
	end
}
UIPasses.level_tooltip = {
	init = function (arg_88_0, arg_88_1, arg_88_2)
		-- function 88
		local tbl = {}

		tbl.passes, tbl.end_pass = {
			{
				data = UITooltipPasses.level_info.setup_data(),
				draw = UITooltipPasses.level_info.draw
			}
		}, {
			data = UITooltipPasses.background.setup_data(),
			draw = UITooltipPasses.background.draw
		}
		tbl.size = {
			300,
			0
		}
		tbl.alpha_multiplier = 1

		return tbl
	end,
	update = function (arg_89_0, arg_89_1, arg_89_2, arg_89_3, arg_89_4, arg_89_5, arg_89_6, arg_89_7, arg_89_8)
		-- function 89
		if not arg_89_8 then
			arg_89_1.alpha_progress = 0
			arg_89_1.alpha_wait_time = UISettings.tooltip_wait_duration
		end
	end,
	draw = function (arg_90_0, arg_90_1, arg_90_2, arg_90_3, arg_90_4, arg_90_5, arg_90_6, arg_90_7, arg_90_8, arg_90_9)
		-- function 90
		local var_90_0 = arg_90_5[arg_90_3.level_id]

		if not var_90_0 then
			return
		end

		local alpha_wait_time = arg_90_1.alpha_wait_time
		local alpha_progress = arg_90_1.alpha_progress

		if not alpha_wait_time then
			local num = alpha_wait_time - arg_90_9

			if num <= 0 then
				arg_90_1.alpha_wait_time = nil
			else
				arg_90_1.alpha_wait_time = num
			end

			arg_90_1.alpha_multiplier = 0
		elseif not alpha_progress then
			local tooltip_fade_in_speed = UISettings.tooltip_fade_in_speed
			local min = math.min(alpha_progress + arg_90_9 * tooltip_fade_in_speed, 1)

			arg_90_1.alpha_multiplier = math.easeOutCubic(min)

			if min == 1 then
				arg_90_1.alpha_progress = nil
			else
				arg_90_1.alpha_progress = min
			end
		end

		local size = arg_90_1.size

		size[2] = 0

		local flag = true

		arg_90_6[1] = arg_90_6[1] + arg_90_7[1] / 2 - size[1] / 2

		local num_2 = 0
		local passes = arg_90_1.passes
		local flag_2 = false
		local end_pass = arg_90_1.end_pass

		if not end_pass then
			local data = end_pass.data

			num_2 = num_2 + end_pass.draw(data, flag_2, flag, arg_90_0, arg_90_1, arg_90_2, arg_90_3, arg_90_4, arg_90_5, arg_90_6, size, arg_90_8, arg_90_9)
		end

		local frame_margin = end_pass.data.frame_margin

		frame_margin = frame_margin or 0

		for i, v in ipairs(passes) do
			local data_2 = v.data

			data_2.frame_margin = frame_margin
			num_2 = num_2 + v.draw(data_2, flag_2, flag, arg_90_0, arg_90_1, arg_90_2, arg_90_3, arg_90_4, arg_90_5, arg_90_6, size, arg_90_8, arg_90_9, var_90_0)
		end

		arg_90_6[2] = arg_90_6[2] + arg_90_7[2] + num_2

		local var_90_15 = arg_90_6[1]
		local var_90_16 = arg_90_6[2]
		local var_90_17 = arg_90_6[3]
		local flag_3 = true

		for i_2, v_2 in ipairs(passes) do
			local data_3 = v_2.data

			data_3.frame_margin = frame_margin

			local draw = v_2.draw(data_3, flag_3, flag, arg_90_0, arg_90_1, arg_90_2, arg_90_3, arg_90_4, arg_90_5, arg_90_6, size, arg_90_8, arg_90_9, var_90_0)

			size[2] = size[2] + draw
			arg_90_6[2] = arg_90_6[2] - draw
		end

		arg_90_6[1] = var_90_15
		arg_90_6[2] = var_90_16
		arg_90_6[3] = var_90_17

		if not end_pass then
			local data_4 = end_pass.data

			end_pass.draw(data_4, flag_3, flag, arg_90_0, arg_90_1, arg_90_2, arg_90_3, arg_90_4, arg_90_5, arg_90_6, size, arg_90_8, arg_90_9)
		end
	end
}
UIPasses.hero_power_tooltip = {
	init = function (arg_91_0, arg_91_1, arg_91_2)
		-- function 91
		local tbl = {}

		tbl.passes, tbl.end_pass = {
			{
				data = UITooltipPasses.hero_power_title.setup_data(),
				draw = UITooltipPasses.hero_power_title.draw
			},
			{
				data = UITooltipPasses.hero_power_gained.setup_data(),
				draw = UITooltipPasses.hero_power_gained.draw
			},
			{
				data = UITooltipPasses.hero_power_perks.setup_data(),
				draw = UITooltipPasses.hero_power_perks.draw
			},
			{
				data = UITooltipPasses.hero_power_description.setup_data(),
				draw = UITooltipPasses.hero_power_description.draw
			}
		}, {
			data = UITooltipPasses.background.setup_data(),
			draw = UITooltipPasses.background.draw
		}
		tbl.size = {
			400,
			0
		}
		tbl.alpha_multiplier = 1
		tbl.player = nil

		return tbl
	end,
	update = function (arg_92_0, arg_92_1, arg_92_2, arg_92_3, arg_92_4, arg_92_5, arg_92_6, arg_92_7, arg_92_8)
		-- function 92
		if not arg_92_8 then
			arg_92_1.player = nil
			arg_92_1.alpha_progress = 0
			arg_92_1.alpha_wait_time = UISettings.tooltip_wait_duration
		end
	end,
	draw = function (arg_93_0, arg_93_1, arg_93_2, arg_93_3, arg_93_4, arg_93_5, arg_93_6, arg_93_7, arg_93_8, arg_93_9)
		-- function 93
		if not arg_93_1.player then
			arg_93_1.player = Managers.player:local_player()
		end

		local alpha_wait_time = arg_93_1.alpha_wait_time
		local alpha_progress = arg_93_1.alpha_progress

		if not alpha_wait_time then
			local num = alpha_wait_time - arg_93_9

			if num <= 0 then
				arg_93_1.alpha_wait_time = nil
			else
				arg_93_1.alpha_wait_time = num
			end

			arg_93_1.alpha_multiplier = 0
		elseif not alpha_progress then
			local tooltip_fade_in_speed = UISettings.tooltip_fade_in_speed
			local min = math.min(alpha_progress + arg_93_9 * tooltip_fade_in_speed, 1)

			arg_93_1.alpha_multiplier = math.easeOutCubic(min)

			if min == 1 then
				arg_93_1.alpha_progress = nil
			else
				arg_93_1.alpha_progress = min
			end
		end

		local size = arg_93_1.size

		size[2] = 0

		local flag = true
		local num_2 = 0
		local passes = arg_93_1.passes
		local flag_2 = false
		local end_pass = arg_93_1.end_pass

		if not end_pass then
			local data = end_pass.data

			num_2 = num_2 + end_pass.draw(data, flag_2, flag, arg_93_0, arg_93_1, arg_93_2, arg_93_3, arg_93_4, arg_93_5, arg_93_6, size, arg_93_8, arg_93_9)
		end

		local frame_margin = end_pass.data.frame_margin

		frame_margin = frame_margin or 0
		arg_93_6[1] = arg_93_6[1] + arg_93_7[1] + frame_margin

		for i, v in ipairs(passes) do
			local data_2 = v.data

			data_2.frame_margin = frame_margin
			num_2 = num_2 + v.draw(data_2, flag_2, flag, arg_93_0, arg_93_1, arg_93_2, arg_93_3, arg_93_4, arg_93_5, arg_93_6, size, arg_93_8, arg_93_9)
		end

		arg_93_6[2] = arg_93_6[2] + num_2

		local var_93_14 = arg_93_6[1]
		local var_93_15 = arg_93_6[2]
		local var_93_16 = arg_93_6[3]
		local flag_3 = true

		for i_2, v_2 in ipairs(passes) do
			local data_3 = v_2.data

			data_3.frame_margin = frame_margin

			local draw = v_2.draw(data_3, flag_3, flag, arg_93_0, arg_93_1, arg_93_2, arg_93_3, arg_93_4, arg_93_5, arg_93_6, size, arg_93_8, arg_93_9)

			size[2] = size[2] + draw
			arg_93_6[2] = arg_93_6[2] - draw
		end

		arg_93_6[1] = var_93_14
		arg_93_6[2] = var_93_15
		arg_93_6[3] = var_93_16

		if not end_pass then
			local data_4 = end_pass.data

			end_pass.draw(data_4, flag_3, flag, arg_93_0, arg_93_1, arg_93_2, arg_93_3, arg_93_4, arg_93_5, arg_93_6, size, arg_93_8, arg_93_9)
		end

		arg_93_6[1] = var_93_14
		arg_93_6[2] = var_93_15
		arg_93_6[3] = var_93_16
	end
}
UIPasses.option_tooltip = {
	init = function (arg_94_0, arg_94_1, arg_94_2)
		-- function 94
		local tbl = {}

		tbl.passes, tbl.end_pass = {
			{
				data = UITooltipPasses.generic_text.setup_data(),
				draw = UITooltipPasses.generic_text.draw
			}
		}, {
			data = UITooltipPasses.background.setup_data(),
			draw = UITooltipPasses.background.draw
		}
		tbl.size = {
			600,
			0
		}
		tbl.alpha_multiplier = 1

		return tbl
	end,
	update = function (arg_95_0, arg_95_1, arg_95_2, arg_95_3, arg_95_4, arg_95_5, arg_95_6, arg_95_7, arg_95_8)
		-- function 95
		if not arg_95_8 then
			arg_95_1.alpha_progress = 0
			arg_95_1.alpha_wait_time = UISettings.tooltip_wait_duration
		end
	end,
	draw = function (arg_96_0, arg_96_1, arg_96_2, arg_96_3, arg_96_4, arg_96_5, arg_96_6, arg_96_7, arg_96_8, arg_96_9)
		-- function 96
		if not Managers.input:is_device_active("gamepad") then
			Managers.input:set_showing_tooltip(true)
		end

		local alpha_wait_time = arg_96_1.alpha_wait_time
		local alpha_progress = arg_96_1.alpha_progress

		if not alpha_wait_time then
			local num = alpha_wait_time - arg_96_9

			if num <= 0 then
				arg_96_1.alpha_wait_time = nil
			else
				arg_96_1.alpha_wait_time = num
			end

			arg_96_1.alpha_multiplier = 0
		elseif not alpha_progress then
			local tooltip_fade_in_speed = UISettings.tooltip_fade_in_speed
			local min = math.min(alpha_progress + arg_96_9 * tooltip_fade_in_speed, 1)

			arg_96_1.alpha_multiplier = math.easeOutCubic(min)

			if min == 1 then
				arg_96_1.alpha_progress = nil
			else
				arg_96_1.alpha_progress = min
			end
		end

		local size = arg_96_1.size

		size[2] = 0

		local flag = true
		local num_2 = 0
		local passes = arg_96_1.passes
		local flag_2 = false
		local end_pass = arg_96_1.end_pass

		if not end_pass then
			local data = end_pass.data

			num_2 = num_2 + end_pass.draw(data, flag_2, flag, arg_96_0, arg_96_1, arg_96_2, arg_96_3, arg_96_4, arg_96_5, arg_96_6, size, arg_96_8, arg_96_9)
		end

		local frame_margin = end_pass.data.frame_margin

		frame_margin = frame_margin or 0

		for i, v in ipairs(passes) do
			local data_2 = v.data

			data_2.frame_margin = frame_margin
			num_2 = num_2 + v.draw(data_2, flag_2, flag, arg_96_0, arg_96_1, arg_96_2, arg_96_3, arg_96_4, arg_96_5, arg_96_6, size, arg_96_8, arg_96_9)
		end

		arg_96_6[2] = arg_96_6[2] + arg_96_7[2] + num_2

		local var_96_14 = arg_96_6[1]
		local var_96_15 = arg_96_6[2]
		local var_96_16 = arg_96_6[3]
		local flag_3 = true

		for i_2, v_2 in ipairs(passes) do
			local data_3 = v_2.data

			data_3.frame_margin = frame_margin

			local draw = v_2.draw(data_3, flag_3, flag, arg_96_0, arg_96_1, arg_96_2, arg_96_3, arg_96_4, arg_96_5, arg_96_6, size, arg_96_8, arg_96_9)

			size[2] = size[2] + draw
			arg_96_6[2] = arg_96_6[2] - draw
		end

		arg_96_6[1] = var_96_14
		arg_96_6[2] = var_96_15
		arg_96_6[3] = var_96_16

		if not end_pass then
			local data_4 = end_pass.data

			end_pass.draw(data_4, flag_3, flag, arg_96_0, arg_96_1, arg_96_2, arg_96_3, arg_96_4, arg_96_5, arg_96_6, size, arg_96_8, arg_96_9)
		end
	end
}
UIPasses.item_tooltip = {
	init = function (self, arg_97_1, arg_97_2)
		-- function 97
		local tbl = {}
		local content_passes = self.content_passes

		content_passes = content_passes or {
			"equipped_item_title",
			"item_titles",
			"skin_applied",
			"deed_mission",
			"deed_difficulty",
			"mutators",
			"deed_rewards",
			"ammunition",
			"fatigue",
			"item_power_level",
			"properties",
			"traits",
			"weapon_skin_title",
			"item_information_text",
			"loot_chest_difficulty",
			"loot_chest_power_range",
			"item_rarity_rate",
			"unwieldable",
			"keywords",
			"special_action_tooltip",
			"other_equipped_careers_tooltip",
			"item_description",
			"light_attack_stats",
			"heavy_attack_stats",
			"detailed_stats_light",
			"detailed_stats_heavy",
			"detailed_stats_push",
			"detailed_stats_ranged_light",
			"detailed_stats_ranged_heavy"
		}

		local tbl_2 = {}
		local pass_styles = arg_97_2.pass_styles

		for i, v in ipairs(content_passes) do
			local flag = not pass_styles and pass_styles[v]

			tbl_2[#tbl_2 + 1] = {
				data = UITooltipPasses[v].setup_data(flag),
				draw = UITooltipPasses[v].draw
			}
		end

		local flag_2 = not pass_styles and pass_styles.item_background

		tbl.end_pass = {
			data = UITooltipPasses.item_background.setup_data(flag_2),
			draw = UITooltipPasses.item_background.draw
		}
		tbl.passes = tbl_2
		tbl.size = {
			400,
			0
		}
		tbl.alpha_multiplier = 1
		tbl.items = {}

		local disable_fade_in = arg_97_1.disable_fade_in
		local tbl_3

		if not disable_fade_in then
			tbl_3 = {
				1,
				1,
				1,
				1
			}

			if not tbl_3 then
				-- Nothing
			end
		end

		tbl_3 = {
			0,
			0,
			0,
			0
		}

		::label_97_0::

		tbl.items_alpha_progress = tbl_3

		local flag_3

		flag_3 = not disable_fade_in and 0 and UISettings.tooltip_wait_duration
		tbl.alpha_wait_times = {
			flag_3,
			flag_3 * 2,
			flag_3 * 2,
			flag_3 * 2
		}
		tbl.tooltip_sizes = {}
		tbl.equipped_items = {}
		tbl.player = nil

		return tbl
	end,
	update = function (arg_98_0, arg_98_1, arg_98_2, arg_98_3, arg_98_4, arg_98_5, arg_98_6, arg_98_7, arg_98_8)
		-- function 98
		if not arg_98_8 then
			arg_98_1.player = nil

			local tooltip_wait_duration = UISettings.tooltip_wait_duration

			arg_98_1.alpha_progress = 0
			arg_98_1.alpha_wait_time = tooltip_wait_duration

			local alpha_wait_times = arg_98_1.alpha_wait_times
			local items_alpha_progress = arg_98_1.items_alpha_progress

			if not alpha_wait_times then
				for i = 1, 4 do
					alpha_wait_times[i] = tooltip_wait_duration * 2
					items_alpha_progress[i] = 0
				end
			end
		end
	end,
	draw = function (arg_99_0, arg_99_1, arg_99_2, arg_99_3, arg_99_4, arg_99_5, arg_99_6, arg_99_7, arg_99_8, arg_99_9)
		-- function 99
		if not arg_99_1.player then
			arg_99_1.player = Managers.player:local_player()
		end

		local var_99_0 = arg_99_5[arg_99_3.item_id]

		if not var_99_0 then
			return
		end

		local items = arg_99_1.items

		table.clear(items)

		items[1] = var_99_0

		local backend_id = var_99_0.backend_id
		local slot_type = var_99_0.data.slot_type
		local flag = not not arg_99_5.no_equipped_item or arg_99_5.equipped_item

		if not flag then
			items[2] = flag

			table.clear(arg_99_1.equipped_items)

			arg_99_1.equipped_items[1] = flag
		end

		if (arg_99_5.no_equipped_item or flag or not slot_type) and not InventorySettings.slot_names_by_type[slot_type] then
			local player = arg_99_1.player

			if not player then
				local equipped_items = arg_99_1.equipped_items

				table.clear(equipped_items)

				local get_interface = Managers.backend:get_interface("items")
				local profile_index = arg_99_5.profile_index

				profile_index = profile_index or player:profile_index()

				local career_index = arg_99_5.career_index

				career_index = career_index or player:career_index()

				local name = SPProfiles[profile_index].careers[career_index].name
				local var_99_11 = get_interface:get_loadout()[name]

				for k, v in pairs(var_99_11) do
					table.insert(equipped_items, get_interface:get_item_from_id(v))
				end

				local get_interface_2 = Managers.backend:get_interface("common")
				local str = "slot_type == " .. slot_type
				local filter_items = get_interface_2:filter_items(equipped_items, str)

				arg_99_1.equipped_items = filter_items

				for i, v_2 in ipairs(filter_items) do
					if v_2.backend_id ~= backend_id then
						items[#items + 1] = v_2
					end
				end
			end
		end

		local scale = RESOLUTION_LOOKUP.scale
		local inv_scale = RESOLUTION_LOOKUP.inv_scale
		local var_99_17
		local size = arg_99_1.size
		local res_w = RESOLUTION_LOOKUP.res_w
		local res_h = RESOLUTION_LOOKUP.res_h
		local var_99_21
		local num

		if not (arg_99_5.force_equipped_item_on_left or arg_99_5.force_equipped_item_on_right or not ((arg_99_6[1] + arg_99_7[1] * 0.5) * scale > res_w * 0.5)) then
			arg_99_6[1] = arg_99_6[1] - size[1] - 5
			num = -1
		else
			arg_99_6[1] = arg_99_6[1] + arg_99_7[1] + 5
			num = 1
		end

		local var_99_23 = arg_99_6[1]
		local var_99_24 = arg_99_6[3]
		local tooltip_sizes = arg_99_1.tooltip_sizes

		for i_2, v_3 in ipairs(items) do
			local end_pass = arg_99_1.end_pass
			local frame_margin = end_pass.data.frame_margin

			frame_margin = frame_margin or 0

			local passes = arg_99_1.passes
			local flag_2 = false
			local flag_3 = true
			local ipairs

			if not flag_3 then
				ipairs = ipairs

				if not ipairs then
					-- Nothing
				end
			end

			ipairs = ripairs

			::label_99_0::

			local num_2 = 0

			if not end_pass then
				local data = end_pass.data

				num_2 = num_2 + end_pass.draw(data, flag_2, flag_3, arg_99_0, arg_99_1, arg_99_2, arg_99_3, arg_99_4, arg_99_5, arg_99_6, size, arg_99_8, arg_99_9, v_3)
			end

			for iter_99_6, iter_99_7 in ipairs(passes) do
				local data_2 = iter_99_7.data

				data_2.frame_margin = frame_margin
				num_2 = num_2 + iter_99_7.draw(data_2, flag_2, flag_3, arg_99_0, arg_99_1, arg_99_2, arg_99_3, arg_99_4, arg_99_5, arg_99_6, size, arg_99_8, arg_99_9, v_3)
			end

			tooltip_sizes[i_2] = num_2
		end

		local num_3 = 40 * scale
		local num_4 = 30 * scale
		local count = #items
		local alpha_wait_times = arg_99_1.alpha_wait_times
		local items_alpha_progress = arg_99_1.items_alpha_progress

		for i_3, v_4 in ipairs(items) do
			size[2] = 0

			local flag_4 = true
			local ipairs_2

			if not flag_4 then
				ipairs_2 = ipairs

				if not ipairs_2 then
					-- Nothing
				end
			end

			ipairs_2 = ripairs

			::label_99_1::

			local passes_2 = arg_99_1.passes
			local var_99_43
			local end_pass_2 = arg_99_1.end_pass
			local frame_margin_2 = end_pass_2.data.frame_margin

			frame_margin_2 = frame_margin_2 or 0

			local var_99_46 = tooltip_sizes[i_3]
			local flag_5 = count == 3
			local flag_6 = i_3 == 1
			local var_99_49 = alpha_wait_times[i_3]

			if not var_99_49 then
				if not (flag_6 or alpha_wait_times[1]) then
					local num_5 = var_99_49 - arg_99_9

					if num_5 <= 0 then
						alpha_wait_times[i_3] = nil
					else
						alpha_wait_times[i_3] = num_5
					end

					arg_99_1.alpha_multiplier = 0
				end
			else
				local var_99_51 = items_alpha_progress[i_3]

				if not var_99_51 then
					local tooltip_fade_in_speed = UISettings.tooltip_fade_in_speed
					local min = math.min(var_99_51 + arg_99_9 * tooltip_fade_in_speed, 1)

					arg_99_1.alpha_multiplier = math.easeOutCubic(min)

					if var_99_51 == 1 then
						items_alpha_progress[i_3] = nil
					else
						items_alpha_progress[i_3] = min
					end
				else
					arg_99_1.alpha_multiplier = 1
				end

				if not flag_6 then
					local flag_7

					flag_7 = not arg_99_5.force_top_alignment and 0 and var_99_46
					arg_99_6[2] = arg_99_6[2] + flag_7 - frame_margin_2 / 2

					local num_6 = arg_99_6[2] * scale + num_3

					if res_h < num_6 then
						arg_99_6[2] = arg_99_6[2] - (num_6 - res_h) * inv_scale
					end

					var_99_17 = arg_99_6[2]
				end

				if not flag_6 then
					if not (not flag_5 and not (res_h > tooltip_sizes[2] + tooltip_sizes[3])) then
						arg_99_6[1] = var_99_23 + size[1] * num

						if var_99_17 - (tooltip_sizes[2] + tooltip_sizes[3] + num_4 * 2) < 0 then
							if i_3 > 2 then
								arg_99_6[1] = arg_99_6[1] + size[1] * num
							end

							arg_99_6[2] = var_99_17
						elseif i_3 == 2 then
							arg_99_6[2] = var_99_17
						else
							arg_99_6[2] = var_99_17 - (tooltip_sizes[2] + num_4 * 2)
						end
					else
						arg_99_6[1] = arg_99_6[1] + size[1] * num

						local num_7 = var_99_17 - var_99_46

						if num_7 < 0 then
							arg_99_6[2] = var_99_17 + math.abs(num_7) + num_4
						else
							arg_99_6[2] = var_99_17
						end
					end
				end

				local var_99_57 = arg_99_6[1]
				local num_8 = arg_99_6[2] + frame_margin_2 / 2 * scale
				local var_99_59 = arg_99_6[3]
				local flag_8 = true

				for iter_99_10, iter_99_11 in ipairs_2(passes_2) do
					local data_3 = iter_99_11.data

					data_3.frame_margin = frame_margin_2
					data_3.equipped_items = arg_99_1.equipped_items

					local draw = iter_99_11.draw(data_3, flag_8, flag_4, arg_99_0, arg_99_1, arg_99_2, arg_99_3, arg_99_4, arg_99_5, arg_99_6, size, arg_99_8, arg_99_9, v_4)

					size[2] = size[2] + draw

					if not flag_4 then
						arg_99_6[2] = arg_99_6[2] - draw
					else
						arg_99_6[2] = arg_99_6[2] + draw
					end
				end

				arg_99_6[1] = var_99_57
				arg_99_6[2] = num_8
				arg_99_6[3] = var_99_59

				if not end_pass_2 then
					local data_4 = end_pass_2.data

					end_pass_2.draw(data_4, flag_8, flag_4, arg_99_0, arg_99_1, arg_99_2, arg_99_3, arg_99_4, arg_99_5, arg_99_6, size, arg_99_8, arg_99_9, v_4)
				end
			end

			arg_99_6[3] = var_99_24
		end
	end
}
UIPasses.talent_tooltip = {
	init = function (arg_100_0, arg_100_1, arg_100_2)
		-- function 100
		local tbl = {}

		tbl.passes, tbl.end_pass = {
			{
				data = UITooltipPasses.talent_text.setup_data(),
				draw = UITooltipPasses.talent_text.draw
			}
		}, {
			data = UITooltipPasses.background.setup_data(),
			draw = UITooltipPasses.background.draw
		}
		tbl.size = {
			400,
			0
		}
		tbl.alpha_multiplier = 1

		return tbl
	end,
	update = function (arg_101_0, arg_101_1, arg_101_2, arg_101_3, arg_101_4, arg_101_5, arg_101_6, arg_101_7, arg_101_8)
		-- function 101
		if not arg_101_8 then
			arg_101_1.alpha_progress = 0
			arg_101_1.alpha_wait_time = UISettings.tooltip_wait_duration
		end
	end,
	draw = function (arg_102_0, arg_102_1, arg_102_2, arg_102_3, arg_102_4, arg_102_5, arg_102_6, arg_102_7, arg_102_8, arg_102_9)
		-- function 102
		local var_102_0 = arg_102_5[arg_102_3.talent_id]

		if not var_102_0 then
			return
		end

		local alpha_wait_time = arg_102_1.alpha_wait_time
		local alpha_progress = arg_102_1.alpha_progress

		if not alpha_wait_time then
			local num = alpha_wait_time - arg_102_9

			if num <= 0 then
				arg_102_1.alpha_wait_time = nil
			else
				arg_102_1.alpha_wait_time = num
			end

			arg_102_1.alpha_multiplier = 0
		elseif not alpha_progress then
			local tooltip_fade_in_speed = UISettings.tooltip_fade_in_speed
			local min = math.min(alpha_progress + arg_102_9 * tooltip_fade_in_speed, 1)

			arg_102_1.alpha_multiplier = math.easeOutCubic(min)

			if min == 1 then
				arg_102_1.alpha_progress = nil
			else
				arg_102_1.alpha_progress = min
			end
		end

		local size = arg_102_1.size

		size[2] = 0

		if not arg_102_4.draw_right then
			arg_102_6[1] = arg_102_6[1] + arg_102_7[1]
		else
			arg_102_6[1] = arg_102_6[1] + 0.5 * (arg_102_7[1] - size[1])
		end

		local passes = arg_102_1.passes
		local end_pass = arg_102_1.end_pass
		local frame_margin

		if not end_pass then
			frame_margin = end_pass.data.frame_margin

			if not frame_margin then
				-- Nothing
			end
		end

		frame_margin = 0

		::label_102_0::

		local flag = arg_102_4.draw_downwards ~= false

		if not flag then
			local num_2 = 0
			local flag_2 = false

			if not end_pass then
				local data = end_pass.data

				num_2 = num_2 + end_pass.draw(data, flag_2, flag, arg_102_0, arg_102_1, arg_102_2, arg_102_3, arg_102_4, arg_102_5, arg_102_6, size, arg_102_8, arg_102_9)
			end

			for i, v in ipairs(passes) do
				local data_2 = v.data

				data_2.frame_margin = frame_margin
				num_2 = num_2 + v.draw(data_2, flag_2, flag, arg_102_0, arg_102_1, arg_102_2, arg_102_3, arg_102_4, arg_102_5, arg_102_6, size, arg_102_8, arg_102_9, var_102_0)
			end

			arg_102_6[2] = arg_102_6[2] + arg_102_7[2] + num_2
		end

		local var_102_15 = arg_102_6[1]
		local var_102_16 = arg_102_6[2]
		local var_102_17 = arg_102_6[3]
		local flag_3 = true

		for i_2, v_2 in ipairs(passes) do
			local data_3 = v_2.data

			data_3.frame_margin = frame_margin

			local draw = v_2.draw(data_3, flag_3, flag, arg_102_0, arg_102_1, arg_102_2, arg_102_3, arg_102_4, arg_102_5, arg_102_6, size, arg_102_8, arg_102_9, var_102_0)

			size[2] = size[2] + draw
			arg_102_6[2] = arg_102_6[2] - draw
		end

		arg_102_6[1] = var_102_15
		arg_102_6[2] = var_102_16
		arg_102_6[3] = var_102_17

		if not end_pass then
			local data_4 = end_pass.data

			end_pass.draw(data_4, flag_3, flag, arg_102_0, arg_102_1, arg_102_2, arg_102_3, arg_102_4, arg_102_5, arg_102_6, size, arg_102_8, arg_102_9)
		end
	end
}

local tbl_18 = {
	0,
	0
}
local tbl_19 = {
	0,
	0
}
local tbl_20 = {
	220,
	3,
	3,
	3
}

UIPasses.tooltip_text = {
	init = function (self)
		-- function 103
		assert(self.text_id, "no text id in pass definition. YOU NEEDS IT.")

		return {
			text_id = self.text_id
		}
	end,
	draw = function (self, arg_104_1, arg_104_2, arg_104_3, arg_104_4, arg_104_5, arg_104_6, arg_104_7, arg_104_8, arg_104_9)
		-- function 104
		arg_104_4.font_size = 18

		local var_104_0
		local var_104_1
		local var_104_2

		if not arg_104_4.font_type then
			local var_104_3, var_104_4 = UIFontByResolution(arg_104_4)

			var_104_0, var_104_1, var_104_2 = var_104_3[1], var_104_4, var_104_3[3]
		else
			local font = arg_104_4.font

			var_104_0, var_104_1, var_104_2 = font[1], font[2], font[3]
			var_104_1 = arg_104_4.font_size or var_104_1
		end

		local var_104_6 = arg_104_5[arg_104_1.text_id]

		if not arg_104_4.localize then
			var_104_6 = Localize(var_104_6)
		end

		local max_width = arg_104_4.max_width

		max_width = max_width or arg_104_7[1]

		local var_104_8, var_104_9, var_104_10 = UIGetFontHeight(self.gui, arg_104_4.font_type, var_104_1)
		local word_wrap = UIRenderer.word_wrap(self, var_104_6, var_104_0, var_104_1, max_width)
		local text_start_index = arg_104_5.text_start_index

		text_start_index = text_start_index or 1

		local max_texts = arg_104_5.max_texts

		max_texts = max_texts or #word_wrap

		local min = math.min(#word_wrap - (text_start_index - 1), max_texts)
		local num = (var_104_10 - var_104_9) * RESOLUTION_LOOKUP.inv_scale
		local var_104_16 = Vector3(0, not arg_104_4.grow_downward and num and -num, 0)
		local fixed_position = arg_104_4.fixed_position

		if not fixed_position and not arg_104_4.use_fixed_position then
			tbl_19[1] = arg_104_6[1] + fixed_position[1]
			tbl_19[2] = arg_104_6[2] + fixed_position[2]
		else
			local get = arg_104_8:get("cursor")

			get = get or tbl
			tbl_19[1] = get[1]
			tbl_19[2] = get[2]
		end

		local cursor_offset = arg_104_4.cursor_offset
		local var_104_20 = tbl_19
		local var_104_21 = tbl_19[1]
		local var_104_22

		if not cursor_offset then
			var_104_22 = cursor_offset[1]

			if not var_104_22 then
				-- Nothing
			end
		end

		var_104_22 = 25

		::label_104_0::

		var_104_20[1] = var_104_21 + var_104_22

		local var_104_23 = tbl_19
		local var_104_24 = tbl_19[2]
		local var_104_25

		if not cursor_offset then
			var_104_25 = cursor_offset[2]

			if not var_104_25 then
				-- Nothing
			end
		end

		var_104_25 = 15

		::label_104_1::

		var_104_23[2] = var_104_24 - var_104_25

		local var_104_26

		if not Managers.input:is_device_active("gamepad") then
			var_104_26 = tbl_19
		elseif not IS_XB1 then
			var_104_26 = tbl_19
			var_104_26[2] = 1080 - var_104_26[2] + 20
		else
			var_104_26 = UIInverseScaleVectorToResolution(tbl_19)
		end

		tbl_18[2] = num * min
		tbl_18[1] = 0

		for i = 1, min do
			local var_104_27 = word_wrap[i - 1 + text_start_index]
			local text_size = UIRenderer.text_size(self, var_104_27, var_104_0, var_104_1, tbl_18[2])

			if text_size > tbl_18[1] then
				tbl_18[1] = text_size
			end
		end

		local cursor_side = arg_104_4.cursor_side
		local draw_downwards = arg_104_4.draw_downwards

		if not (not cursor_side and cursor_side ~= "left") then
			arg_104_6[1] = var_104_26[1] - tbl_18[1]

			if not draw_downwards then
				arg_104_6[2] = var_104_26[2] - num
			else
				arg_104_6[2] = var_104_26[2] + (tbl_18[2] - num)
			end
		else
			arg_104_6[1] = var_104_26[1]
			arg_104_6[2] = var_104_26[2] - num
		end

		arg_104_6[3] = UILayer.tooltip + 1

		for j = 1, min do
			local var_104_31 = word_wrap[j - 1 + text_start_index]
			local last_line_color

			if not (not arg_104_4.last_line_color and j ~= min) then
				last_line_color = arg_104_4.last_line_color

				if not last_line_color then
					-- Nothing
				end
			end

			if not arg_104_4.line_colors then
				last_line_color = arg_104_4.line_colors[j]

				if not last_line_color then
					-- Nothing
				end
			end

			last_line_color = arg_104_4.text_color

			::label_104_2::

			UIRenderer.draw_text(self, var_104_31, var_104_0, var_104_1, var_104_2, arg_104_6 + 0.25 * var_104_16, last_line_color)

			if j < min then
				arg_104_6 = arg_104_6 + var_104_16
			end
		end

		local num_2 = 4
		local num_3 = 8

		arg_104_6[3] = arg_104_6[3] - 1
		arg_104_6[2] = arg_104_6[2] - (num + var_104_9) - num_3
		arg_104_6[1] = arg_104_6[1] - 2 - num_2
		tbl_18[1] = tbl_18[1] + num_2 * 2 * RESOLUTION_LOOKUP.inv_scale
		tbl_18[2] = tbl_18[2] + num_3 * 2 * RESOLUTION_LOOKUP.inv_scale

		UIRenderer.draw_rounded_rect(self, arg_104_6, tbl_18, 5, tbl_20)
	end
}

local tbl_21 = {
	0,
	0
}

UIPasses.rect_text = {
	init = function (self)
		-- function 105
		assert(self.text_id, "no text id in pass definition. YOU NEEDS IT.")

		return {
			text_id = self.text_id
		}
	end,
	draw = function (self, arg_106_1, arg_106_2, arg_106_3, arg_106_4, arg_106_5, arg_106_6, arg_106_7, arg_106_8, arg_106_9)
		-- function 106
		local var_106_0
		local var_106_1
		local var_106_2

		if not arg_106_4.font_type then
			local var_106_3, var_106_4 = UIFontByResolution(arg_106_4)

			var_106_0, var_106_1, var_106_2 = var_106_3[1], var_106_4, var_106_3[3]
		else
			local font = arg_106_4.font

			var_106_0, var_106_1, var_106_2 = font[1], font[2], font[3]
			var_106_1 = arg_106_4.font_size or var_106_1
		end

		local var_106_6 = arg_106_5[arg_106_1.text_id]

		if not arg_106_4.localize then
			var_106_6 = Localize(var_106_6)
		end

		local max_width = arg_106_4.max_width

		max_width = max_width or arg_106_7[1]

		local var_106_8, var_106_9, var_106_10 = UIGetFontHeight(self.gui, arg_106_4.font_type, var_106_1)
		local word_wrap = UIRenderer.word_wrap(self, var_106_6, var_106_0, var_106_1, max_width)
		local text_start_index = arg_106_5.text_start_index

		text_start_index = text_start_index or 1

		local max_texts = arg_106_5.max_texts

		max_texts = max_texts or #word_wrap

		local min = math.min(#word_wrap - (text_start_index - 1), max_texts)
		local num = (var_106_10 + math.abs(var_106_9)) * RESOLUTION_LOOKUP.inv_scale
		local var_106_16 = Vector3(0, not arg_106_4.grow_downward and num and -num, 0)
		local length = Utf8.length(var_106_6)

		tbl_21[2] = num * min
		tbl_21[1] = 0

		if not arg_106_4.static_rect_width then
			tbl_21[1] = arg_106_7[1]
		else
			for i = 1, min do
				local var_106_18 = word_wrap[i - 1 + text_start_index]
				local text_size = UIRenderer.text_size(self, var_106_18, var_106_0, var_106_1, tbl_21[2])

				if text_size > tbl_21[1] then
					tbl_21[1] = text_size
				end
			end
		end

		if arg_106_4.horizontal_alignment == "center" then
			local num_2 = 0

			for j = 1, min do
				local var_106_21 = word_wrap[j - 1 + text_start_index]
				local length_2

				if not var_106_21 then
					length_2 = Utf8.length(var_106_21)

					if not length_2 then
						-- Nothing
					end
				end

				length_2 = 0

				::label_106_0::

				local text_size_2 = UIRenderer.text_size(self, var_106_21, var_106_0, var_106_1, arg_106_7[2])
				local var_106_24 = Vector3(arg_106_7[1] / 2 - text_size_2 / 2, 0, 0)
				local var_106_25

				if not arg_106_4.color_override then
					var_106_25 = fn_4(j, length_2, num_2, length, arg_106_4)
				end

				UIRenderer.draw_text(self, var_106_21, var_106_0, var_106_1, var_106_2, arg_106_6 + var_106_24, arg_106_4.text_color, nil, var_106_25)

				if j < min then
					arg_106_6 = arg_106_6 + var_106_16
				end

				num_2 = num_2 + length_2 + 1
			end
		else
			for k = 1, min do
				local var_106_26 = word_wrap[k - 1 + text_start_index]
				local last_line_color

				if not (not arg_106_4.last_line_color and k ~= min) then
					last_line_color = arg_106_4.last_line_color

					if not last_line_color then
						-- Nothing
					end
				end

				if not arg_106_4.line_colors then
					last_line_color = arg_106_4.line_colors[k]

					if not last_line_color then
						-- Nothing
					end
				end

				last_line_color = arg_106_4.text_color

				::label_106_1::

				UIRenderer.draw_text(self, var_106_26, var_106_0, var_106_1, var_106_2, arg_106_6, last_line_color)

				if k < min then
					arg_106_6 = arg_106_6 + var_106_16
				end
			end
		end

		local num_3 = 4
		local num_4 = 2

		arg_106_6[3] = arg_106_6[3] - 1
		arg_106_6[2] = arg_106_6[2] + var_106_9 * RESOLUTION_LOOKUP.inv_scale
		tbl_21[1] = tbl_21[1] + num_3 * 4
		tbl_21[2] = tbl_21[2] + num_4 * 2

		local var_106_30 = Vector3(0, 0, 0)

		if arg_106_4.horizontal_alignment == "center" then
			var_106_30 = Vector3(arg_106_7[1] * 0.5 - tbl_21[1] * 0.5, 0, 0)
		else
			var_106_30 = Vector3(-num_3 * 2, 0, 0)
		end

		if not arg_106_4.masked then
			draw_texture(self, "rect_masked", arg_106_6 + var_106_30, tbl_21, arg_106_4.rect_color, arg_106_4.masked, not arg_106_4 and arg_106_4.saturated)
		else
			UIRenderer.draw_rounded_rect(self, arg_106_6 + var_106_30, tbl_21, 5, arg_106_4.rect_color)
		end

		if not arg_106_4.border then
			arg_106_6 = Vector3(arg_106_6[1] - arg_106_4.border, arg_106_6[2] - arg_106_4.border, arg_106_6[3] - 1)
			tbl_21[1] = tbl_21[1] + arg_106_4.border * 2
			tbl_21[2] = tbl_21[2] + arg_106_4.border * 2

			if not arg_106_4.masked then
				draw_texture(self, "rect_masked", arg_106_6 + var_106_30, tbl_21, arg_106_4.border_color, arg_106_4.masked, not arg_106_4 and arg_106_4.saturated)
			else
				UIRenderer.draw_rounded_rect(self, arg_106_6 + var_106_30, tbl_21, 5, arg_106_4.border_color)
			end
		end
	end
}

local double_click_threshold = UISettings.double_click_threshold

UIPasses.hotspot = {
	init = function (arg_107_0, arg_107_1)
		-- function 107
		return
	end,
	draw = function (arg_108_0, arg_108_1, arg_108_2, arg_108_3, arg_108_4, arg_108_5, arg_108_6, arg_108_7, arg_108_8, arg_108_9)
		-- function 108
		if not arg_108_4 then
			local area_size = arg_108_4.area_size

			if not area_size then
				if arg_108_4.horizontal_alignment == "right" then
					arg_108_6[1] = arg_108_6[1] + arg_108_7[1] - area_size[1]
				elseif arg_108_4.horizontal_alignment == "center" then
					arg_108_6[1] = arg_108_6[1] + (arg_108_7[1] - area_size[1]) / 2
				end

				if arg_108_4.vertical_alignment == "center" then
					arg_108_6[2] = arg_108_6[2] + (arg_108_7[2] - area_size[2]) / 2
				elseif arg_108_4.vertical_alignment == "top" then
					arg_108_6[2] = arg_108_6[2] + arg_108_7[2] - area_size[2]
				end

				arg_108_7 = area_size
			end
		end

		local input = Managers.input
		local is_device_active = input:is_device_active("gamepad")
		local gamepad_cursor_active = input:gamepad_cursor_active()
		local is_frame_hovering = input:is_frame_hovering()
		local is_hover = arg_108_5.is_hover
		local var_108_6
		local str_2 = "cursor"
		local stack_depth = ShowCursorStack.stack_depth
		local flag = not arg_108_8 and arg_108_8:has(str_2)
		local flag_2 = (not (stack_depth > 0) or not flag) and arg_108_8:get(str_2)

		if not (not flag_2 and Script.type_name(flag_2) == str) then
			flag_2 = tbl
		end

		local var_108_11

		if not (not IS_XB1 and is_device_active) then
			var_108_11 = Vector3(flag_2[1], 1080 - flag_2[2], flag_2[3])
		else
			var_108_11 = UIInverseScaleVectorToResolution(flag_2)
		end

		local hover_type = arg_108_5.hover_type
		local var_108_13 = arg_108_6
		local var_108_14 = arg_108_7

		if not is_device_active then
			if not gamepad_cursor_active then
				var_108_6 = false
			elseif not (not is_frame_hovering and arg_108_5.allow_multi_hover) then
				var_108_6 = false
			else
				local scale = RESOLUTION_LOOKUP.scale

				var_108_11[1] = var_108_11[1] * scale
				var_108_11[2] = var_108_11[2] * scale

				local var_108_16 = Vector2(GAMEPAD_CURSOR_SIZE * 0.5, GAMEPAD_CURSOR_SIZE * 0.5)

				var_108_6 = math.box_overlap_box(var_108_11 - var_108_16 * 0.5, var_108_16, var_108_13, var_108_14)
			end
		elseif hover_type == "circle" then
			local num = var_108_14 / 2
			local num_2 = Vector3.flat(var_108_13) + num

			var_108_6 = Vector3.distance_squared(var_108_11, num_2) <= num.x * num.y or false
		else
			var_108_6 = math.point_is_inside_2d_box(var_108_11, var_108_13, var_108_14)
		end

		arg_108_5.cursor_hover = var_108_6

		if not arg_108_5.disable_button then
			var_108_6 = false
		end

		if not (not is_device_active and not var_108_6 and arg_108_5.allow_multi_hover) then
			input:set_hovering(var_108_6)
		end

		if not script_data.ui_debug_hover then
			if not arg_108_5.is_hover then
				UIRenderer.draw_rect(arg_108_0, Vector3(arg_108_6[1], arg_108_6[2], 999), arg_108_7, {
					128,
					0,
					255,
					0
				})
			else
				UIRenderer.draw_rect(arg_108_0, arg_108_6 + Vector3(0, 0, 1), arg_108_7, {
					60,
					255,
					0,
					0
				})
			end
		end

		arg_108_5.gamepad_active = is_device_active

		if not arg_108_5.on_hover_enter then
			arg_108_5.on_hover_enter = nil
		end

		if not arg_108_5.on_hover_exit then
			arg_108_5.on_hover_exit = nil
		end

		if not (not var_108_6 and is_hover) then
			arg_108_5.on_hover_enter = not UIPasses.is_dragging_item
			arg_108_5.is_hover = not UIPasses.is_dragging_item
			arg_108_5.internal_is_hover = true
		end

		if not (not is_hover and var_108_6) then
			arg_108_5.is_hover = nil
			arg_108_5.on_hover_exit = true
			arg_108_5.internal_is_hover = nil
		end

		if not arg_108_5.on_pressed then
			arg_108_5.on_pressed = nil
		end

		if not var_108_6 and not UIPasses.is_dragging_item then
			var_108_6 = false
		elseif var_108_6 or not arg_108_5.internal_is_hover then
			arg_108_5.internal_is_hover = nil
		end

		local flag_3 = not arg_108_8 and arg_108_8:get("left_press")
		local flag_4 = not arg_108_8 and arg_108_8:get("left_hold")
		local is_clicked = arg_108_5.is_clicked

		is_clicked = not is_clicked and arg_108_5.is_clicked < double_click_threshold

		if not var_108_6 then
			if not arg_108_5.input_pressed then
				arg_108_5.input_pressed = flag_3

				if not arg_108_5.input_pressed then
					arg_108_5.on_pressed = true
				end

				if not flag_4 and not flag_3 then
					arg_108_5.is_held = true
				end
			elseif not is_clicked then
				arg_108_5.input_pressed = false
			end
		elseif not arg_108_5.input_pressed then
			arg_108_5.input_pressed = false
		end

		arg_108_5.on_right_click = false
		arg_108_5.on_double_click = false

		if not flag_4 then
			arg_108_5.is_held = false
		end

		local get = arg_108_8:get("left_release")

		if not arg_108_5.input_pressed then
			if not get then
				arg_108_5.on_release = true
				arg_108_5.on_left_release = true
				arg_108_5.is_clicked = 0
			else
				arg_108_5.on_release = false

				if not flag_3 and is_clicked and not is_device_active then
					arg_108_5.on_double_click = true
					arg_108_5.is_clicked = 0
				elseif not var_108_6 and not flag_4 then
					arg_108_5.is_clicked = 0
				else
					local is_clicked_2 = arg_108_5.is_clicked

					is_clicked_2 = is_clicked_2 or 10
					arg_108_5.is_clicked = is_clicked_2 + arg_108_9
				end
			end
		elseif not get and not var_108_6 then
			arg_108_5.on_left_release = true
		else
			if not var_108_6 and flag_3 and flag_4 or not arg_108_8:get("right_press") then
				arg_108_5.on_right_click = true
			end

			arg_108_5.on_release = false
			arg_108_5.on_left_release = false

			local is_clicked_3 = arg_108_5.is_clicked

			is_clicked_3 = is_clicked_3 or 10
			arg_108_5.is_clicked = is_clicked_3 + arg_108_9
		end
	end
}
UIPasses.controller_hotspot = {
	init = function (arg_109_0)
		-- function 109
		return
	end,
	draw = function (arg_110_0, arg_110_1, arg_110_2, arg_110_3, arg_110_4, arg_110_5, arg_110_6, arg_110_7, arg_110_8, arg_110_9)
		-- function 110
		local is_hover = arg_110_5.is_hover
		local var_110_1
		local get_controller_cursor_position = arg_110_8:get_controller_cursor_position()

		get_controller_cursor_position = get_controller_cursor_position or tbl

		local var_110_3 = arg_110_6
		local var_110_4 = arg_110_7
		local point_is_inside_2d_box = math.point_is_inside_2d_box(get_controller_cursor_position, var_110_3, var_110_4)

		if not script_data.ui_debug_hover then
			local draw_rect = UIRenderer.draw_rect
			local var_110_7 = arg_110_0
			local num = arg_110_6 + Vector3(0, 0, 1)
			local var_110_9 = arg_110_7
			local tbl_2

			if not arg_110_5.is_hover then
				tbl_2 = {
					128,
					0,
					255,
					0
				}

				if not tbl_2 then
					-- Nothing
				end
			end

			tbl_2 = {
				128,
				255,
				0,
				0
			}

			::label_110_0::

			draw_rect(var_110_7, num, var_110_9, tbl_2)
		end

		if not (not point_is_inside_2d_box and is_hover) then
			arg_110_5.is_hover = not UIPasses.is_dragging_item
			arg_110_5.internal_is_hover = true
			point_is_inside_2d_box = not UIPasses.is_dragging_item
		end

		if not (not is_hover and point_is_inside_2d_box) then
			arg_110_5.is_hover = nil
			arg_110_5.internal_is_hover = nil
		end

		if not point_is_inside_2d_box and not UIPasses.is_dragging_item then
			point_is_inside_2d_box = false
		elseif point_is_inside_2d_box or not arg_110_5.internal_is_hover then
			arg_110_5.internal_is_hover = nil
		end

		arg_110_5.on_double_click = false

		if not (point_is_inside_2d_box or arg_110_5.is_clicked ~= 0) then
			if not arg_110_8:get("confirm") then
				arg_110_5.on_release = true
				arg_110_5.is_clicked = 0
			else
				arg_110_5.on_release = false

				local get = arg_110_8:get("confirm_hold")

				if arg_110_5.is_clicked ~= 0 or not get then
					arg_110_5.is_clicked = 0
				elseif not (not arg_110_8:get("confirm_press") and not (arg_110_5.is_clicked < UISettings.double_click_threshold)) then
					arg_110_5.on_double_click = true
					arg_110_5.is_clicked = 0
				else
					local is_clicked = arg_110_5.is_clicked

					is_clicked = is_clicked or 10
					arg_110_5.is_clicked = is_clicked + arg_110_9
				end
			end
		else
			arg_110_5.on_release = false

			local is_clicked_2 = arg_110_5.is_clicked

			is_clicked_2 = is_clicked_2 or 10
			arg_110_5.is_clicked = is_clicked_2 + arg_110_9
		end
	end
}
UIPasses.game_pad_connected = {
	init = function (arg_111_0)
		-- function 111
		return
	end,
	draw = function (arg_112_0, arg_112_1, arg_112_2, arg_112_3, arg_112_4, arg_112_5, arg_112_6, arg_112_7, arg_112_8, arg_112_9)
		-- function 112
		arg_112_5.gamepad_connected = Managers.input:get_device("gamepad").active()
	end
}

local function fn_6(arg_113_0, arg_113_1, arg_113_2, arg_113_3, arg_113_4, arg_113_5, arg_113_6, arg_113_7, arg_113_8, arg_113_9, arg_113_10)
	-- function 113
	if not arg_113_8:get(arg_113_10) then
		arg_113_5.on_release = true
		arg_113_5.is_clicked = 0
	else
		arg_113_5.on_release = false

		local is_clicked = arg_113_5.is_clicked

		is_clicked = is_clicked or 10
		arg_113_5.is_clicked = is_clicked + arg_113_9
	end
end

UIPasses.gamepad_button_click_confirm = {
	init = function (arg_114_0)
		-- function 114
		return
	end,
	draw = function (arg_115_0, arg_115_1, arg_115_2, arg_115_3, arg_115_4, arg_115_5, arg_115_6, arg_115_7, arg_115_8, arg_115_9)
		-- function 115
		fn_6(arg_115_0, arg_115_1, arg_115_2, arg_115_3, arg_115_4, arg_115_5, arg_115_6, arg_115_7, arg_115_8, arg_115_9, "confirm")
	end
}
UIPasses.gamepad_button_click_back = {
	init = function (arg_116_0)
		-- function 116
		return
	end,
	draw = function (arg_117_0, arg_117_1, arg_117_2, arg_117_3, arg_117_4, arg_117_5, arg_117_6, arg_117_7, arg_117_8, arg_117_9)
		-- function 117
		fn_6(arg_117_0, arg_117_1, arg_117_2, arg_117_3, arg_117_4, arg_117_5, arg_117_6, arg_117_7, arg_117_8, arg_117_9, "back")
	end
}
UIPasses.gamepad_button_click_refresh = {
	init = function (arg_118_0)
		-- function 118
		return
	end,
	draw = function (arg_119_0, arg_119_1, arg_119_2, arg_119_3, arg_119_4, arg_119_5, arg_119_6, arg_119_7, arg_119_8, arg_119_9)
		-- function 119
		fn_6(arg_119_0, arg_119_1, arg_119_2, arg_119_3, arg_119_4, arg_119_5, arg_119_6, arg_119_7, arg_119_8, arg_119_9, "refresh")
	end
}
UIPasses.on_click = {
	init = function (arg_120_0)
		-- function 120
		return
	end,
	draw = function (arg_121_0, arg_121_1, arg_121_2, arg_121_3, arg_121_4, arg_121_5, arg_121_6, arg_121_7, arg_121_8, arg_121_9)
		-- function 121
		if not arg_121_5[arg_121_3.click_check_content_id].on_pressed then
			arg_121_3.click_function(arg_121_2, arg_121_4, arg_121_5, arg_121_8)
		end
	end
}
UIPasses.on_left_and_right_click = {
	init = function (arg_122_0)
		-- function 122
		return
	end,
	draw = function (arg_123_0, arg_123_1, arg_123_2, arg_123_3, arg_123_4, arg_123_5, arg_123_6, arg_123_7, arg_123_8, arg_123_9)
		-- function 123
		local var_123_0 = arg_123_5[arg_123_3.click_check_content_id]

		if var_123_0.on_pressed or not var_123_0.on_right_click then
			arg_123_3.click_function(arg_123_2, arg_123_4, arg_123_5, arg_123_8)
		end
	end
}
UIPasses.on_double_click = {
	init = function (arg_124_0)
		-- function 124
		return
	end,
	draw = function (arg_125_0, arg_125_1, arg_125_2, arg_125_3, arg_125_4, arg_125_5, arg_125_6, arg_125_7, arg_125_8, arg_125_9)
		-- function 125
		if not arg_125_5[arg_125_3.click_check_content_id].on_double_click then
			arg_125_3.click_function(arg_125_2, arg_125_4, arg_125_5, arg_125_8)
		end
	end
}
UIPasses.debug_cursor = {
	init = function (arg_126_0)
		-- function 126
		return nil
	end,
	draw = function (arg_127_0, arg_127_1, arg_127_2, arg_127_3, arg_127_4, arg_127_5, arg_127_6, arg_127_7, arg_127_8, arg_127_9)
		-- function 127
		local green

		if not arg_127_5.is_hover then
			green = Colors.green

			if not green then
				-- Nothing
			end
		end

		green = Colors.red

		::label_127_0::

		local is_clicked = arg_127_5.is_clicked

		is_clicked = is_clicked or 10

		if is_clicked < 0.5 then
			green = Colors.blue
		end

		UIRenderer.draw_rect(arg_127_0, arg_127_6, arg_127_7, green)
	end
}
UIPasses.local_offset = {
	init = function (arg_128_0)
		-- function 128
		return nil
	end,
	draw = function (arg_129_0, arg_129_1, arg_129_2, arg_129_3, arg_129_4, arg_129_5, arg_129_6, arg_129_7, arg_129_8, arg_129_9)
		-- function 129
		arg_129_3.offset_function(arg_129_2, arg_129_4, arg_129_5, arg_129_0)
	end
}
UIPasses.scroll = {
	init = function (arg_130_0)
		-- function 130
		return nil
	end,
	draw = function (arg_131_0, arg_131_1, arg_131_2, arg_131_3, arg_131_4, arg_131_5, arg_131_6, arg_131_7, arg_131_8, arg_131_9)
		-- function 131
		local get = arg_131_8:get("cursor")

		get = get or tbl

		local var_131_1

		if not Managers.input:is_device_active("gamepad") then
			var_131_1 = get
		else
			var_131_1 = UIInverseScaleVectorToResolution(get)
		end

		local point_is_inside_2d_box = math.point_is_inside_2d_box(var_131_1, arg_131_6, arg_131_7)

		point_is_inside_2d_box = not point_is_inside_2d_box and not UIPasses.is_dragging_item
		arg_131_5.is_hover = point_is_inside_2d_box

		local get_2 = arg_131_8:get("scroll_axis")

		if not get_2 then
			arg_131_3.scroll_function(arg_131_2, arg_131_4, arg_131_5, arg_131_8, get_2, arg_131_9)
		end
	end
}
UIPasses.held = {
	init = function (arg_132_0)
		-- function 132
		return nil
	end,
	draw = function (arg_133_0, arg_133_1, arg_133_2, arg_133_3, arg_133_4, arg_133_5, arg_133_6, arg_133_7, arg_133_8, arg_133_9)
		-- function 133
		local var_133_0

		if not arg_133_3.content_check_hover then
			var_133_0 = arg_133_5[arg_133_3.content_check_hover]

			if not var_133_0 then
				-- Nothing
			end
		end

		var_133_0 = arg_133_5

		::label_133_0::

		if (var_133_0.is_held or not var_133_0.is_hover) and not arg_133_8:get("left_press") then
			var_133_0.is_held = true
		end

		if not var_133_0.is_held then
			if not arg_133_8:get("left_hold") then
				if not arg_133_3.held_function then
					arg_133_3.held_function(arg_133_2, arg_133_4, arg_133_5, arg_133_8)
				end
			else
				if not arg_133_3.release_function then
					arg_133_3.release_function(arg_133_2, arg_133_4, arg_133_5, arg_133_8)
				end

				var_133_0.is_held = false
			end
		end
	end
}
UIPasses.item_presentation = {
	init = function (self, arg_134_1, arg_134_2)
		-- function 134
		local tbl = {}
		local content_passes = self.content_passes

		content_passes = content_passes or {
			"item_titles",
			"deed_mission",
			"deed_difficulty",
			"mutators",
			"deed_rewards",
			"ammunition",
			"fatigue",
			"item_power_level",
			"properties",
			"traits"
		}

		local tbl_2 = {}
		local pass_styles = arg_134_2.pass_styles

		for i, v in ipairs(content_passes) do
			local flag = not pass_styles and pass_styles[v]

			tbl_2[#tbl_2 + 1] = {
				data = UITooltipPasses[v].setup_data(flag),
				draw = UITooltipPasses[v].draw
			}
		end

		local flag_2 = not pass_styles and pass_styles.item_background

		tbl.end_pass = {
			data = UITooltipPasses.item_background.setup_data(flag_2),
			draw = UITooltipPasses.item_background.draw
		}
		tbl.items = {}
		tbl.passes = tbl_2
		tbl.alpha_multiplier = 1
		tbl.player = nil
		tbl.force_equipped = arg_134_1.force_equipped

		return tbl
	end,
	draw = function (arg_135_0, arg_135_1, arg_135_2, arg_135_3, arg_135_4, arg_135_5, arg_135_6, arg_135_7, arg_135_8, arg_135_9)
		-- function 135
		local var_135_0 = arg_135_5[arg_135_3.item_id]

		if not var_135_0 then
			return
		end

		if not arg_135_1.player then
			arg_135_1.player = Managers.player:local_player()
		end

		arg_135_7[2] = 0
		arg_135_1.start_layer = arg_135_6[3]

		local flag = true
		local passes = arg_135_1.passes
		local flag_2 = false
		local num = 0
		local end_pass = arg_135_1.end_pass
		local draw_end_passes = arg_135_4.draw_end_passes
		local frame_margin = end_pass.data.frame_margin

		frame_margin = frame_margin or 0

		if not arg_135_5.compare_item then
			local items = arg_135_1.items

			table.clear(items)

			items[1] = var_135_0

			local compare_item = arg_135_5.compare_item

			if not compare_item then
				items[2] = compare_item
			end
		end

		if not end_pass and not draw_end_passes then
			local data = end_pass.data

			num = num + end_pass.draw(data, flag_2, flag, arg_135_0, arg_135_1, arg_135_2, arg_135_3, arg_135_4, arg_135_5, arg_135_6, arg_135_7, arg_135_8, arg_135_9, var_135_0)
		end

		for i, v in ipairs(passes) do
			local data_2 = v.data

			data_2.frame_margin = frame_margin
			num = num + v.draw(data_2, flag_2, flag, arg_135_0, arg_135_1, arg_135_2, arg_135_3, arg_135_4, arg_135_5, arg_135_6, arg_135_7, arg_135_8, arg_135_9, var_135_0)
		end

		if arg_135_4.vertical_alignment == "center" then
			arg_135_6[2] = arg_135_6[2] + num / 2 - frame_margin / 2
		end

		local var_135_12 = arg_135_6[1]
		local num_2 = arg_135_6[2] + frame_margin / 2
		local var_135_14 = arg_135_6[3]
		local flag_3 = true

		for i_2, v_2 in ipairs(passes) do
			local data_3 = v_2.data

			data_3.frame_margin = frame_margin

			local draw = v_2.draw(data_3, flag_3, flag, arg_135_0, arg_135_1, arg_135_2, arg_135_3, arg_135_4, arg_135_5, arg_135_6, arg_135_7, arg_135_8, arg_135_9, var_135_0)

			arg_135_7[2] = arg_135_7[2] + draw

			if not flag then
				arg_135_6[2] = arg_135_6[2] - draw
			else
				arg_135_6[2] = arg_135_6[2] + draw
			end
		end

		arg_135_6[1] = var_135_12
		arg_135_6[2] = num_2
		arg_135_6[3] = var_135_14

		if not end_pass and not draw_end_passes then
			local data_4 = end_pass.data

			end_pass.draw(data_4, flag_3, flag, arg_135_0, arg_135_1, arg_135_2, arg_135_3, arg_135_4, arg_135_5, arg_135_6, arg_135_7, arg_135_8, arg_135_9, var_135_0)
		end

		arg_135_4.item_presentation_height = arg_135_7[2]
	end
}
UIPasses.keystrokes = {
	init = function (self)
		-- function 136
		return {
			input_text_id = self.input_text_id,
			keystrokes = {}
		}
	end,
	draw = function (arg_137_0, arg_137_1, arg_137_2, arg_137_3, arg_137_4, arg_137_5, arg_137_6, arg_137_7, arg_137_8, arg_137_9)
		-- function 137
		if not arg_137_5.active then
			local var_137_0 = arg_137_5[arg_137_1.input_text_id]
			local caret_index = arg_137_5.caret_index
			local input_mode = arg_137_5.input_mode
			local max_length = arg_137_5.max_length

			Managers.chat:block_chat_input_for_one_frame()
			table.clear(arg_137_1.keystrokes)

			local keystrokes = Keyboard.keystrokes(arg_137_1.keystrokes)
			local parse_strokes, var_137_6, var_137_7 = KeystrokeHelper.parse_strokes(var_137_0, caret_index, input_mode, keystrokes, max_length)

			arg_137_5[arg_137_1.input_text_id] = parse_strokes
			arg_137_5.caret_index = var_137_6
			arg_137_5.input_mode = var_137_7
		end
	end
}

local function fn_7(self, arg_138_1)
	-- function 138
	local content_check_function = self.definition.content_check_function

	if not (not content_check_function and content_check_function(self.content, self.style, arg_138_1)) then
		self.visible = false
	end

	local content_change_function = self.definition.content_change_function

	if not self.visible and not content_change_function then
		content_change_function(self.content, self.style, arg_138_1)
	end
end

local function fn_8(self)
	-- function 139
	self.visible = self.content.visible ~= false
end

UIPasses.auto_layout = {
	init = function (self, arg_140_1, arg_140_2)
		-- function 140
		local tbl = {}
		local sub_passes = self.sub_passes
		local background_passes = self.background_passes

		if not self.style_id then
			arg_140_2 = arg_140_2[self.style_id]

			fassert(arg_140_2, "could not find style " .. self.style_id .. "in style definitions")
		end

		if not self.content_id then
			arg_140_1 = arg_140_1[self.content_id]

			fassert(arg_140_1, "could not find content " .. self.content_id .. "in content definitions")
		end

		local function fn(self, arg_141_1, arg_141_2)
			-- function 141
			local content_id = self.content_id
			local var_141_1

			if not content_id then
				var_141_1 = arg_141_1[content_id]
				var_141_1.parent = arg_141_1
			else
				var_141_1 = arg_141_1
			end

			local style_id = self.style_id
			local var_141_3

			if not style_id then
				var_141_3 = arg_141_2[style_id]
				var_141_3.parent = arg_141_2
			else
				var_141_3 = arg_141_2
			end

			return var_141_1, var_141_3
		end

		local tbl_2 = {}

		for i, v in ipairs(sub_passes) do
			local pass_type = v.pass_type
			local var_140_6 = UIPasses[pass_type]
			local var_140_7, var_140_8 = fn(v, arg_140_1, arg_140_2)
			local var_140_9

			if not var_140_8.render_random_debug_color then
				var_140_9 = {
					64,
					math.random(0, 255),
					math.random(0, 255),
					math.random(0, 255)
				}
			end

			tbl_2[#tbl_2 + 1] = {
				visible = true,
				definition = v,
				data = var_140_6.init(v, arg_140_1, arg_140_2),
				update = var_140_6.update,
				draw = var_140_6.draw,
				content = var_140_7,
				style = var_140_8,
				get_preferred_size = var_140_6.get_preferred_size,
				debug_color = var_140_9
			}
		end

		local tbl_3 = {}

		if not background_passes then
			for i_2, v_2 in ipairs(background_passes) do
				local pass_type_2 = v_2.pass_type
				local var_140_12 = UIPasses[pass_type_2]
				local var_140_13, var_140_14 = fn(v_2, arg_140_1, arg_140_2)
				local var_140_15

				if not var_140_14.render_random_debug_color then
					var_140_15 = {
						64,
						math.random(0, 255),
						math.random(0, 255),
						math.random(0, 255)
					}
				end

				tbl_3[#tbl_3 + 1] = {
					visible = true,
					definition = v_2,
					data = var_140_12.init(v_2, arg_140_1, arg_140_2),
					update = var_140_12.update,
					draw = var_140_12.draw,
					content = var_140_13,
					style = var_140_14,
					get_preferred_size = var_140_12.get_preferred_size,
					debug_color = var_140_15
				}
			end
		end

		tbl.passes = tbl_2
		tbl.background_passes = tbl_3
		tbl._size_table = {
			0,
			0
		}

		return tbl
	end,
	update = function (arg_142_0, arg_142_1, arg_142_2, arg_142_3, arg_142_4, arg_142_5, arg_142_6, arg_142_7, arg_142_8)
		-- function 142
		local num = 0
		local num_2 = 0
		local num_3 = 0
		local num_4 = 0
		local layout_delta_x

		if not arg_142_4 then
			layout_delta_x = arg_142_4.layout_delta_x

			if not layout_delta_x then
				-- Nothing
			end
		end

		layout_delta_x = 0

		do
			local layout_delta_y
		end

		::label_142_0::

		if not arg_142_4 then
			layout_delta_y = arg_142_4.layout_delta_y

			if not layout_delta_y then
				-- Nothing
			end
		end

		layout_delta_y = 1

		do
			local flag
		end

		::label_142_1::

		flag = not (layout_delta_x < 0) or not 1 or 0

		local flag_2

		flag_2 = not (layout_delta_y < 0) or not 1 or 0

		local num_5 = 0
		local num_6 = 0

		for i, v in ipairs(arg_142_1.passes) do
			fn_8(v, arg_142_5, arg_142_4)
			fn_7(v, i)

			if not v.update then
				v.update(arg_142_0, v.data, arg_142_2, v.definition, v.style, v.content, arg_142_6, arg_142_7, v.visible)
			end

			if not v.visible then
				local var_142_10
				local var_142_11

				if not v.style and not v.style.size then
					var_142_10, var_142_11 = v.style.size[1], v.style.size[2]
				end

				if not v.style then
					if not v.style.dynamic_width then
						fassert(v.get_preferred_size, "pass of type '" .. v.definition.pass_type .. "' does not support dynamic_size")

						var_142_10 = v.get_preferred_size(arg_142_0, v.data, arg_142_2, v.definition, v.style, v.content, arg_142_6, arg_142_7, v.visible)
					elseif not v.style.dynamic_height then
						fassert(v.get_preferred_size, "pass of type '" .. v.definition.pass_type .. "' does not support dynamic_size")

						local var_142_12
						local get_preferred_size

						get_preferred_size, var_142_11 = v.get_preferred_size(arg_142_0, v.data, arg_142_2, v.definition, v.style, v.content, arg_142_6, arg_142_7, v.visible)
					elseif not v.style.dynamic_size then
						fassert(v.get_preferred_size, "pass of type '" .. v.definition.pass_type .. "' does not support dynamic_size")

						var_142_10, var_142_11 = v.get_preferred_size(arg_142_0, v.data, arg_142_2, v.definition, v.style, v.content, arg_142_6, arg_142_7, v.visible)
					end
				end

				var_142_10 = var_142_10 or 0
				var_142_11 = var_142_11 or 0

				local layout_left_padding = v.style.layout_left_padding

				layout_left_padding = layout_left_padding or 0

				local num_7 = var_142_10 + layout_left_padding
				local layout_right_padding = v.style.layout_right_padding

				layout_right_padding = layout_right_padding or 0
				v.wanted_width = num_7 + layout_right_padding

				local layout_top_padding = v.style.layout_top_padding

				layout_top_padding = layout_top_padding or 0

				local num_8 = var_142_11 + layout_top_padding
				local layout_bottom_padding = v.style.layout_bottom_padding

				layout_bottom_padding = layout_bottom_padding or 0
				v.wanted_height = num_8 + layout_bottom_padding
				v.layout_pos_x = num_5 + v.wanted_width * layout_delta_x * flag
				v.layout_pos_y = num_6 + v.wanted_height * layout_delta_y * flag_2
				num = math.min(num, v.layout_pos_x)
				num_2 = math.min(num_2, v.layout_pos_y)
				num_3 = math.max(num_3, v.layout_pos_x + v.wanted_width)
				num_4 = math.max(num_4, v.layout_pos_y + v.wanted_height)

				local style = v.style

				style = not style and v.style.offset

				if not style then
					v.layout_pos_x = v.layout_pos_x + style[1]
					v.layout_pos_y = v.layout_pos_y + style[2]
				end

				num_6 = num_6 + v.wanted_height * layout_delta_y
				num_5 = num_5 + v.wanted_width * layout_delta_x
			end
		end

		arg_142_1.layout_min_x = num
		arg_142_1.layout_min_y = num_2
		arg_142_1.layout_max_x = num_3
		arg_142_1.layout_max_y = num_4

		for i_2, v_2 in ipairs(arg_142_1.background_passes) do
			fn_8(v_2, arg_142_5, arg_142_4)
			fn_7(v_2, i_2)

			if not v_2.update then
				v_2.update(arg_142_0, v_2.data, arg_142_2, v_2.definition, v_2.style, v_2.content, arg_142_6, arg_142_7, v_2.visible)
			end
		end
	end,
	draw = function (arg_143_0, arg_143_1, arg_143_2, arg_143_3, arg_143_4, arg_143_5, arg_143_6, arg_143_7, arg_143_8, arg_143_9)
		-- function 143
		local num = arg_143_1.layout_max_x - arg_143_1.layout_min_x
		local num_2 = arg_143_1.layout_max_y - arg_143_1.layout_min_y
		local var_143_2
		local var_143_3

		if arg_143_4.horizontal_alignment == "center" then
			var_143_2 = arg_143_6[1] + arg_143_7[1] / 2 - num / 2
		elseif arg_143_4.horizontal_alignment == "right" then
			var_143_2 = arg_143_6[1] + arg_143_7[1] - num
		else
			var_143_2 = arg_143_6[1]
		end

		if arg_143_4.vertical_alignment == "center" then
			var_143_3 = arg_143_6[2] + arg_143_7[2] / 2 - num_2 / 2
		elseif arg_143_4.vertical_alignment == "top" then
			var_143_3 = arg_143_6[2] + arg_143_7[2] - num_2
		else
			var_143_3 = arg_143_6[2]
		end

		local screen_padding = arg_143_4.screen_padding

		if not screen_padding then
			local inv_scale = RESOLUTION_LOOKUP.inv_scale
			local num_3 = RESOLUTION_LOOKUP.res_w * inv_scale
			local num_4 = RESOLUTION_LOOKUP.res_h * inv_scale
			local top = screen_padding.top

			if not top then
				local num_5 = num_4 - top - (var_143_3 + num_2)

				if num_5 < 0 then
					var_143_3 = var_143_3 + num_5
				end
			end

			local right = screen_padding.right

			if not right then
				local num_6 = num_3 - right - (var_143_2 + num)

				if num_6 < 0 then
					var_143_2 = var_143_2 + num_6
				end
			end

			local bottom = screen_padding.bottom

			if not bottom then
				local num_7 = var_143_3 - bottom

				if num_7 < 0 then
					var_143_3 = var_143_3 - num_7
				end
			end

			local left = screen_padding.left

			if not left then
				local num_8 = var_143_2 - left

				if num_8 < 0 then
					var_143_2 = var_143_2 - num_8
				end
			end
		end

		arg_143_1._size_table[1] = num
		arg_143_1._size_table[2] = num_2

		local var_143_16 = Vector3(0, 0, 0)
		local layout_delta_x

		if not arg_143_4 then
			layout_delta_x = arg_143_4.layout_delta_x

			if not layout_delta_x then
				-- Nothing
			end
		end

		layout_delta_x = 0

		do
			local layout_delta_y
		end

		::label_143_0::

		if not arg_143_4 then
			layout_delta_y = arg_143_4.layout_delta_y

			if not layout_delta_y then
				-- Nothing
			end
		end

		layout_delta_y = 1

		do
			local flag
		end

		::label_143_1::

		flag = not (layout_delta_x < 0) or not 1 or 0

		local flag_2

		flag_2 = not (layout_delta_y < 0) or not 1 or 0

		local background_passes = arg_143_1.background_passes

		for i = 1, #background_passes do
			local var_143_22 = background_passes[i]

			if not var_143_22.visible then
				local layout_left_padding = var_143_22.style.layout_left_padding

				layout_left_padding = layout_left_padding or 0
				var_143_16.x = var_143_2 - layout_left_padding

				local layout_bottom_padding = var_143_22.style.layout_bottom_padding

				layout_bottom_padding = layout_bottom_padding or 0
				var_143_16.y = var_143_3 - layout_bottom_padding
				var_143_16.z = arg_143_6[3]

				local style = var_143_22.style

				style = not style and var_143_22.style.offset

				if not style then
					var_143_16.x = var_143_16.x + style[1]
					var_143_16.y = var_143_16.y + style[2]
					var_143_16.z = var_143_16.z + style[3]
				end

				local _size_table = arg_143_1._size_table
				local layout_left_padding_2 = var_143_22.style.layout_left_padding

				layout_left_padding_2 = layout_left_padding_2 or 0

				local num_9 = num + layout_left_padding_2
				local layout_right_padding = var_143_22.style.layout_right_padding

				layout_right_padding = layout_right_padding or 0
				_size_table[1] = num_9 + layout_right_padding

				local _size_table_2 = arg_143_1._size_table
				local layout_bottom_padding_2 = var_143_22.style.layout_bottom_padding

				layout_bottom_padding_2 = layout_bottom_padding_2 or 0

				local num_10 = num_2 + layout_bottom_padding_2
				local layout_top_padding = var_143_22.style.layout_top_padding

				layout_top_padding = layout_top_padding or 0
				_size_table_2[2] = num_10 + layout_top_padding

				if not var_143_22.debug_color then
					UIRenderer.draw_rect(arg_143_0, var_143_16, arg_143_1._size_table, var_143_22.debug_color)
				end

				var_143_22.draw(arg_143_0, var_143_22.data, arg_143_2, var_143_22.definition, var_143_22.style, var_143_22.content, var_143_16, arg_143_1._size_table, arg_143_8, arg_143_9)
			end
		end

		local passes = arg_143_1.passes

		for j = 1, #passes do
			local var_143_35 = passes[j]

			if not var_143_35.visible then
				var_143_16[1] = var_143_2 + var_143_35.layout_pos_x - num * layout_delta_x * flag
				var_143_16[2] = var_143_3 + var_143_35.layout_pos_y - num_2 * layout_delta_y * flag_2
				var_143_16[3] = arg_143_6[3]

				local style_2 = arg_143_1.style

				style_2 = not style_2 and arg_143_1.style.offset

				if not style_2 then
					var_143_16[3] = var_143_16[3] + style_2[3]
				end

				local style_3 = var_143_35.style

				style_3 = not style_3 and var_143_35.style.offset

				if not style_3 then
					var_143_16[3] = var_143_16[3] + style_3[3]
				end

				if var_143_35.definition.pass_type == "auto_layout" then
					arg_143_1._size_table[1] = num
					arg_143_1._size_table[2] = num_2
				else
					arg_143_1._size_table[1] = not var_143_35.style.fill_width and num and var_143_35.wanted_width
					arg_143_1._size_table[2] = not var_143_35.style.fill_height and num_2 and var_143_35.wanted_height
				end

				if not var_143_35.debug_color then
					UIRenderer.draw_rect(arg_143_0, var_143_16, arg_143_1._size_table, var_143_35.debug_color)
				end

				var_143_35.draw(arg_143_0, var_143_35.data, arg_143_2, var_143_35.definition, var_143_35.style, var_143_35.content, var_143_16, arg_143_1._size_table, arg_143_8, arg_143_9)
			end
		end
	end,
	get_preferred_size = function (arg_144_0, arg_144_1, arg_144_2, arg_144_3, arg_144_4, arg_144_5, arg_144_6, arg_144_7, arg_144_8)
		-- function 144
		local num = arg_144_1.layout_max_x - arg_144_1.layout_min_x
		local num_2 = arg_144_1.layout_max_y - arg_144_1.layout_min_y

		return num, num_2
	end
}
