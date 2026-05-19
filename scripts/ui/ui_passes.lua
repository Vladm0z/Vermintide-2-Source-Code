-- chunkname: @scripts/ui/ui_passes.lua

require("scripts/utils/colors")
require("scripts/settings/ui_settings")
require("scripts/settings/inventory_settings")
require("scripts/settings/ui_frame_settings")
require("scripts/utils/utf8_utils")
require("scripts/ui/ui_passes_tooltips")

local var_0_0 = UIRenderer
local var_0_1 = var_0_0.draw_texture
local var_0_2 = var_0_0.draw_texture_uv
local var_0_3 = UIInverseScaleVectorToResolution
local var_0_4 = UIGetFontHeight
local var_0_5 = UIScaleVectorToResolution
local var_0_6 = ScaleVectorToResolution
local var_0_7 = string
local var_0_8 = math

UIPasses = UIPasses or {}
UIPasses.nop = {
	init = NOP,
	draw = NOP,
	update = NOP
}
UIPasses.rect = {
	init = function(arg_1_0)
		if arg_1_0.retained_mode then
			return {
				dirty = true
			}
		end
	end,
	destroy = function(arg_2_0, arg_2_1, arg_2_2)
		assert(arg_2_2.retained_mode, "why u destroy immediate pass?")

		if arg_2_1.retained_id then
			var_0_0.destroy_bitmap(arg_2_0, arg_2_1.retained_id)

			arg_2_1.retained_id = nil
		end
	end,
	draw = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7, arg_3_8, arg_3_9)
		local var_3_0 = Colors.color_definitions.white

		if arg_3_4 then
			local var_3_1 = arg_3_4.texture_size

			if var_3_1 then
				UIUtils.align_box_inplace(arg_3_4, arg_3_6, arg_3_7, var_3_1)

				arg_3_7 = var_3_1
			end

			var_3_0 = arg_3_4.color or var_3_0
		end

		if arg_3_3.retained_mode then
			local var_3_2 = arg_3_3.retained_mode and (arg_3_1.retained_id and arg_3_1.retained_id or true)
			local var_3_3 = var_0_0.draw_rect(arg_3_0, arg_3_6, arg_3_7, var_3_0, var_3_2)

			arg_3_1.retained_id = var_3_3 and var_3_3 or arg_3_1.retained_id
			arg_3_1.dirty = false
		else
			var_0_0.draw_rect(arg_3_0, arg_3_6, arg_3_7, var_3_0)
		end
	end
}
UIPasses.texture = {
	init = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
		if arg_4_0.clone and arg_4_3 then
			local var_4_0 = arg_4_3.gui

			if arg_4_0.retained_mode then
				var_4_0 = arg_4_3.gui_retained
			end

			local var_4_1 = arg_4_1[arg_4_0.texture_id or "texture_id"]
			local var_4_2 = Application.guid()

			Gui.clone_material_from_template(var_4_0, var_4_2, var_4_1)

			arg_4_0.cloned_material = var_4_2
			arg_4_1[arg_4_0.texture_id or "texture_id"] = var_4_2
		end

		if arg_4_0.material_func and arg_4_3 then
			local var_4_3 = arg_4_3.gui

			if arg_4_0.retained_mode then
				var_4_3 = arg_4_3.gui_retained
			end

			local var_4_4 = arg_4_0.context
			local var_4_5 = arg_4_1[arg_4_0.texture_id or "texture_id"]

			arg_4_0.material_func(var_4_3, var_4_5, var_4_4)
		end

		if arg_4_0.retained_mode then
			return {
				dirty = true
			}
		end
	end,
	destroy = function(arg_5_0, arg_5_1, arg_5_2)
		assert(arg_5_2.retained_mode, "Attempted to destroy an immediate mode pass")

		if arg_5_1.retained_id then
			var_0_0.destroy_bitmap(arg_5_0, arg_5_1.retained_id)

			arg_5_1.retained_id = nil
		end
	end,
	draw = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7, arg_6_8, arg_6_9)
		local var_6_0 = arg_6_5[arg_6_3.texture_id or "texture_id"]
		local var_6_1
		local var_6_2
		local var_6_3
		local var_6_4
		local var_6_5

		if arg_6_4 then
			local var_6_6 = arg_6_4.texture_size

			if var_6_6 then
				UIUtils.align_box_inplace(arg_6_4, arg_6_6, arg_6_7, var_6_6)

				arg_6_7 = var_6_6
			end

			var_6_1 = arg_6_4.color
			var_6_2 = arg_6_4.masked
			var_6_3 = arg_6_4.saturated
			var_6_4 = arg_6_4.point_sample
			var_6_5 = arg_6_4.viewport_mask
		end

		if arg_6_3.retained_mode then
			local var_6_7 = arg_6_3.retained_mode and (arg_6_1.retained_id or true)

			arg_6_1.retained_id = var_0_1(arg_6_0, var_6_0, arg_6_6, arg_6_7, var_6_1, var_6_2, var_6_3, var_6_7, var_6_4, var_6_5) or arg_6_1.retained_id
			arg_6_1.dirty = false
		else
			var_0_1(arg_6_0, var_6_0, arg_6_6, arg_6_7, var_6_1, var_6_2, var_6_3, nil, var_6_4, var_6_5)
		end
	end
}
UIPasses.texture_uv = {
	init = function(arg_7_0)
		if arg_7_0.retained_mode then
			return {
				dirty = true
			}
		end

		return arg_7_0.content_id
	end,
	destroy = function(arg_8_0, arg_8_1, arg_8_2)
		assert(arg_8_2.retained_mode, "why u destroy immediate pass?")

		if arg_8_1.retained_id then
			var_0_0.destroy_bitmap(arg_8_0, arg_8_1.retained_id)

			arg_8_1.retained_id = nil
		end
	end,
	draw = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7, arg_9_8, arg_9_9)
		local var_9_0 = arg_9_5.uvs
		local var_9_1 = arg_9_5[arg_9_3.texture_id or "texture_id"]
		local var_9_2
		local var_9_3
		local var_9_4
		local var_9_5
		local var_9_6

		if arg_9_4 then
			local var_9_7 = arg_9_4.texture_size

			if var_9_7 then
				if arg_9_4.horizontal_alignment == "right" then
					arg_9_6[1] = arg_9_6[1] + arg_9_7[1] - var_9_7[1]
				elseif arg_9_4.horizontal_alignment == "center" then
					arg_9_6[1] = arg_9_6[1] + (arg_9_7[1] - var_9_7[1]) / 2
				end

				if arg_9_4.vertical_alignment == "center" then
					arg_9_6[2] = arg_9_6[2] + (arg_9_7[2] - var_9_7[2]) / 2
				elseif arg_9_4.vertical_alignment == "top" then
					arg_9_6[2] = arg_9_6[2] + arg_9_7[2] - var_9_7[2]
				end

				arg_9_7 = var_9_7
			end

			var_9_2 = arg_9_4.color
			var_9_3 = arg_9_4.masked
			var_9_4 = arg_9_4.saturated
			var_9_6 = arg_9_4.point_sample
			var_9_5 = arg_9_4.viewport_mask
		end

		if arg_9_3.retained_mode then
			local var_9_8 = arg_9_3.retained_mode and (arg_9_1.retained_id and arg_9_1.retained_id or true)
			local var_9_9 = var_0_2(arg_9_0, var_9_1, arg_9_6, arg_9_7, var_9_0, var_9_2, var_9_3, var_9_4, var_9_8, var_9_6, var_9_5)

			arg_9_1.retained_id = var_9_9 and var_9_9 or arg_9_1.retained_id
			arg_9_1.dirty = false
		else
			var_0_2(arg_9_0, var_9_1, arg_9_6, arg_9_7, var_9_0, var_9_2, var_9_3, var_9_4, nil, var_9_6, var_9_5)
		end
	end
}

local var_0_9 = {
	0,
	0,
	0
}

UIPasses.texture_uv_dynamic_color_uvs_size_offset = {
	init = function(arg_10_0)
		if arg_10_0.retained_mode then
			return {
				dirty = true
			}
		end

		return nil
	end,
	destroy = function(arg_11_0, arg_11_1, arg_11_2)
		assert(arg_11_2.retained_mode, "why u destroy immediate pass?")

		if arg_11_1.retained_id then
			var_0_0.destroy_bitmap(arg_11_0, arg_11_1.retained_id)

			arg_11_1.retained_id = nil
		end
	end,
	draw = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6, arg_12_7, arg_12_8, arg_12_9)
		arg_12_5 = arg_12_3.content_id and arg_12_5[arg_12_3.content_id] or arg_12_5
		arg_12_4 = arg_12_3.style_id and arg_12_4[arg_12_3.style_id] or arg_12_4

		local var_12_0, var_12_1, var_12_2, var_12_3 = arg_12_3.dynamic_function(arg_12_5, arg_12_4, arg_12_7, arg_12_9, arg_12_0)
		local var_12_4 = arg_12_5.texture_index
		local var_12_5 = var_12_4 and arg_12_5[arg_12_3.texture_id or "texture_id"][var_12_4] or arg_12_5[arg_12_3.texture_id or "texture_id"]

		if var_12_3 then
			arg_12_6 = arg_12_6 + Vector3(var_12_3[1], var_12_3[2], var_12_3[3])
		end

		if arg_12_3.retained_mode then
			local var_12_6 = arg_12_3.retained_mode and (arg_12_1.retained_id and arg_12_1.retained_id or true)
			local var_12_7 = var_0_2(arg_12_0, var_12_5, arg_12_6, var_12_2, var_12_1, var_12_0, arg_12_4 and arg_12_4.masked, arg_12_4 and arg_12_4.saturated, var_12_6)

			arg_12_1.retained_id = var_12_7 and var_12_7 or arg_12_1.retained_id
			arg_12_1.dirty = false
		else
			return var_0_2(arg_12_0, var_12_5, arg_12_6, var_12_2, var_12_1, var_12_0, arg_12_4 and arg_12_4.masked, arg_12_4 and arg_12_4.saturated)
		end

		return var_0_2(arg_12_0, var_12_5, arg_12_6, var_12_2, var_12_1, var_12_0, arg_12_4 and arg_12_4.masked, arg_12_4 and arg_12_4.saturated)
	end
}

local var_0_10 = {
	0,
	0,
	0
}

UIPasses.list_pass = {
	init = function(arg_13_0)
		local var_13_0 = arg_13_0.passes
		local var_13_1 = #var_13_0
		local var_13_2 = {}

		for iter_13_0 = 1, var_13_1 do
			var_13_2[iter_13_0] = UIPasses[var_13_0[iter_13_0].pass_type].init(var_13_0[iter_13_0])
		end

		return {
			num_passes = var_13_1,
			sub_pass_datas = var_13_2
		}
	end,
	draw = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6, arg_14_7, arg_14_8, arg_14_9)
		local var_14_0 = arg_14_1.num_list_elements

		if not var_14_0 then
			var_14_0 = #arg_14_5
			arg_14_1.num_list_elements = var_14_0
		end

		local var_14_1 = arg_14_1.num_passes
		local var_14_2 = arg_14_3.passes
		local var_14_3 = arg_14_1.sub_pass_datas
		local var_14_4 = arg_14_4.list_member_offset
		local var_14_5 = FrameTable.alloc_table()
		local var_14_6 = FrameTable.alloc_table()
		local var_14_7 = arg_14_4.columns
		local var_14_8 = arg_14_4.column_offset

		var_0_10[1] = arg_14_6[1]
		var_0_10[2] = arg_14_6[2]
		var_0_10[3] = arg_14_6[3]

		local var_14_9 = arg_14_4.start_index
		local var_14_10 = arg_14_4.num_draws - 1
		local var_14_11 = var_0_8.min(var_14_9 + var_14_10, var_14_0)

		if arg_14_4.scenegraph_id then
			local var_14_12 = arg_14_2[arg_14_4.scenegraph_id].size
			local var_14_13 = var_14_10 * var_14_4[1] + arg_14_7[1]
			local var_14_14 = var_14_10 * var_14_4[2] + arg_14_7[2]

			if arg_14_4.horizontal_alignment == "center" then
				var_0_10[1] = arg_14_6[1] + var_14_12[1] / 2 - var_14_13 / 2
			elseif arg_14_4.horizontal_alignment == "right" then
				var_0_10[1] = arg_14_6[1] + var_14_12[1] - var_14_13
			end

			if arg_14_4.vertical_alignment == "center" then
				var_0_10[2] = arg_14_6[2] + var_14_12[2] / 2 - var_14_14 / 2
			elseif arg_14_4.vertical_alignment == "top" then
				var_0_10[2] = arg_14_6[2] + var_14_12[2] - var_0_8.abs(var_14_4[2])
			end
		end

		var_14_5[1] = var_0_10[1]
		var_14_5[2] = var_0_10[2]
		var_14_5[3] = var_0_10[3]

		local var_14_15 = 0
		local var_14_16 = 0

		if IS_PS4 then
			var_14_15, var_14_16 = 0, var_0_8.max(var_14_9 - 1, 0)
		end

		local var_14_17

		for iter_14_0 = var_14_9, var_14_11 do
			var_14_15 = var_14_15 + 1

			local var_14_18 = arg_14_5[iter_14_0]

			var_14_18.parent = arg_14_5.parent

			local var_14_19 = arg_14_4.item_styles and arg_14_4.item_styles[iter_14_0] or arg_14_4
			local var_14_20 = var_14_19.list_member_offset
			local var_14_21
			local var_14_22

			if var_14_7 then
				var_14_21 = var_14_15 % var_14_7

				if var_14_21 == 0 then
					var_14_21 = var_14_7 - 1
					var_14_22 = true
				else
					var_14_21 = var_14_21 - 1
					var_14_22 = false
				end
			else
				var_14_22 = true
			end

			if var_14_20 then
				if var_14_21 then
					var_14_5[1] = var_0_10[1] + var_14_8 * var_14_21
					var_14_5[2] = var_0_10[2] + var_14_20[2] * var_14_16
					var_14_5[3] = var_0_10[3] + var_14_20[3]
				else
					var_14_5[1] = var_0_10[1] + var_14_20[1] * var_14_16
					var_14_5[2] = var_0_10[2] + var_14_20[2] * var_14_16
					var_14_5[3] = var_0_10[3] + var_14_20[3]
				end
			elseif var_14_21 then
				var_14_5[1] = var_0_10[1] + var_14_8 * var_14_21
				var_14_5[2] = var_0_10[2] + var_14_4[2] * var_14_16
				var_14_5[3] = var_0_10[3] + var_14_4[3]
			else
				var_14_5[1] = var_0_10[1] + var_14_4[1] * var_14_16
				var_14_5[2] = var_0_10[2] + var_14_4[2] * var_14_16
				var_14_5[3] = var_0_10[3] + var_14_4[3]
			end

			for iter_14_1 = 1, var_14_1 do
				var_14_6[1] = var_14_5[1]
				var_14_6[2] = var_14_5[2]
				var_14_6[3] = var_14_5[3]

				local var_14_23 = var_14_2[iter_14_1]
				local var_14_24 = var_14_23.content_id
				local var_14_25

				if var_14_24 then
					var_14_25 = var_14_18[var_14_24]
					var_14_25.parent = var_14_18
				else
					var_14_25 = var_14_18
				end

				local var_14_26 = var_14_23.style_id
				local var_14_27 = var_14_26 and var_14_19[var_14_26] or var_14_19
				local var_14_28 = var_14_27 and var_14_27.size and Vector2(unpack(var_14_27.size)) or arg_14_7
				local var_14_29 = var_14_27 and var_14_27.offset

				if var_14_29 then
					var_14_6[1] = var_14_6[1] + var_14_29[1]
					var_14_6[2] = var_14_6[2] + var_14_29[2]
					var_14_6[3] = var_14_6[3] + var_14_29[3]
				end

				local var_14_30 = var_14_3[iter_14_1]
				local var_14_31 = var_14_25.visible ~= false
				local var_14_32 = var_14_23.content_check_function

				if var_14_32 and not var_14_32(var_14_25, var_14_27, iter_14_0) then
					var_14_31 = false
				end

				local var_14_33 = var_14_23.content_change_function

				if var_14_31 and var_14_33 then
					var_14_33(var_14_25, var_14_27, iter_14_0)
				end

				if var_14_31 then
					UIPasses[var_14_23.pass_type].draw(arg_14_0, var_14_30, arg_14_2, var_14_23, var_14_27, var_14_25, Vector3(unpack(var_14_6)), var_14_28, arg_14_8, arg_14_9)
				end
			end

			if var_14_22 then
				var_14_16 = var_14_16 + 1
			end
		end
	end
}
UIPasses.gradient_mask_texture = {
	init = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
		if arg_15_0.clone and arg_15_3 then
			local var_15_0 = arg_15_3.gui

			if arg_15_0.retained_mode then
				var_15_0 = arg_15_3.gui_retained
			end

			local var_15_1 = arg_15_1[arg_15_0.texture_id or "texture_id"]
			local var_15_2 = Application.guid()

			Gui.clone_material_from_template(var_15_0, var_15_2, var_15_1)

			arg_15_0.cloned_material = var_15_2
			arg_15_1[arg_15_0.texture_id or "texture_id"] = var_15_2

			if not UIAtlasHelper.has_atlas_settings_by_texture_name(var_15_1) then
				UIAtlasHelper.add_standalone_texture_by_name(var_15_2)
			end
		end

		if arg_15_0.retained_mode then
			return {
				dirty = true
			}
		end
	end,
	destroy = function(arg_16_0, arg_16_1, arg_16_2)
		assert(arg_16_2.retained_mode, "why u destroy immediate pass?")

		if arg_16_1.retained_id then
			var_0_0.destroy_bitmap(arg_16_0, arg_16_1.retained_id)

			arg_16_1.retained_id = nil
		end
	end,
	draw = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, arg_17_9)
		local var_17_0
		local var_17_1 = false
		local var_17_2 = 1

		if arg_17_4 then
			local var_17_3 = arg_17_4.texture_size

			if var_17_3 then
				if arg_17_4.horizontal_alignment == "right" then
					arg_17_6[1] = arg_17_6[1] + arg_17_7[1] - var_17_3[1]
				elseif arg_17_4.horizontal_alignment == "center" then
					arg_17_6[1] = arg_17_6[1] + (arg_17_7[1] - var_17_3[1]) / 2
				end

				if arg_17_4.vertical_alignment == "center" then
					arg_17_6[2] = arg_17_6[2] + (arg_17_7[2] - var_17_3[2]) / 2
				elseif arg_17_4.vertical_alignment == "top" then
					arg_17_6[2] = arg_17_6[2] + arg_17_7[2] - var_17_3[2]
				end

				arg_17_7 = var_17_3
			end

			var_17_0 = arg_17_4.color
			var_17_1 = arg_17_4.masked
			var_17_2 = arg_17_4.gradient_threshold or var_17_2
		end

		local var_17_4 = arg_17_3.texture_id or "texture_id"

		if arg_17_3.retained_mode then
			local var_17_5 = arg_17_3.retained_mode and (arg_17_1.retained_id and arg_17_1.retained_id or true)
			local var_17_6 = var_0_0.draw_gradient_mask_texture(arg_17_0, arg_17_5[var_17_4], arg_17_6, arg_17_7, var_17_0, var_17_1, var_17_2, var_17_5)

			arg_17_1.retained_id = var_17_6 and var_17_6 or arg_17_1.retained_id
			arg_17_1.dirty = false
		else
			var_0_0.draw_gradient_mask_texture(arg_17_0, arg_17_5[var_17_4], arg_17_6, arg_17_7, var_17_0, var_17_1, var_17_2)
		end
	end
}
UIPasses.texture_frame = {
	init = function(arg_18_0, arg_18_1, arg_18_2)
		if arg_18_0.retained_mode then
			return {
				dirty = true
			}
		end

		return nil
	end,
	destroy = function(arg_19_0, arg_19_1, arg_19_2)
		assert(arg_19_2.retained_mode, "why u destroy immediate pass?")

		local var_19_0 = arg_19_1.retained_ids

		if var_19_0 then
			for iter_19_0 = 1, #var_19_0 do
				var_0_0.destroy_bitmap(arg_19_0, var_19_0[iter_19_0])
			end

			arg_19_1.retained_ids = nil
		end
	end,
	draw = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6, arg_20_7, arg_20_8, arg_20_9)
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
		local var_20_11 = arg_20_3.texture_id or "texture_id"

		if arg_20_4 then
			local var_20_12 = arg_20_4.area_size

			if var_20_12 then
				if arg_20_4.horizontal_alignment == "right" then
					arg_20_6[1] = arg_20_6[1] + arg_20_7[1] - var_20_12[1]
				elseif arg_20_4.horizontal_alignment == "center" then
					arg_20_6[1] = arg_20_6[1] + (arg_20_7[1] - var_20_12[1]) / 2
				end

				if arg_20_4.vertical_alignment == "center" then
					arg_20_6[2] = arg_20_6[2] + (arg_20_7[2] - var_20_12[2]) / 2
				elseif arg_20_4.vertical_alignment == "top" then
					arg_20_6[2] = arg_20_6[2] + arg_20_7[2] - var_20_12[2]
				end

				var_20_10 = Vector2(var_20_12[1], var_20_12[2])
			end

			local var_20_13 = arg_20_4.frame_margins

			if var_20_13 then
				var_20_9 = Vector3(arg_20_6[1] + var_20_13[1], arg_20_6[2] + var_20_13[2], arg_20_6[3])

				if var_20_10 then
					var_20_10[1] = var_20_10[1] - var_20_13[1] * 2
					var_20_10[2] = var_20_10[2] - var_20_13[2] * 2
				else
					var_20_10 = Vector2(arg_20_7[1] - var_20_13[1] * 2, arg_20_7[2] - var_20_13[2] * 2)
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

		if arg_20_3.retained_mode then
			local var_20_14 = arg_20_3.retained_mode and (arg_20_1.retained_ids and arg_20_1.retained_ids or true)
			local var_20_15 = var_0_0.draw_texture_frame(arg_20_0, var_20_9, var_20_10, arg_20_5[var_20_11], var_20_0, var_20_1, var_20_2, var_20_3, var_20_4, var_20_5, var_20_7, var_20_8, var_20_6, var_20_14)

			arg_20_1.retained_ids = var_20_15 and var_20_15 or arg_20_1.retained_ids
			arg_20_1.dirty = false
		else
			return var_0_0.draw_texture_frame(arg_20_0, var_20_9, var_20_10, arg_20_5[var_20_11], var_20_0, var_20_1, var_20_2, var_20_3, var_20_4, var_20_5, var_20_7, var_20_8, var_20_6)
		end
	end
}
UIPasses.shader_tiled_texture = {
	init = function(arg_21_0)
		if arg_21_0.retained_mode then
			return {
				dirty = true
			}
		end
	end,
	destroy = function(arg_22_0, arg_22_1, arg_22_2)
		assert(arg_22_2.retained_mode, "why u destroy immediate pass?")

		if arg_22_1.retained_id then
			var_0_0.destroy_bitmap(arg_22_0, arg_22_1.retained_id)

			arg_22_1.retained_id = nil
		end
	end,
	draw = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6, arg_23_7, arg_23_8, arg_23_9)
		local var_23_0
		local var_23_1
		local var_23_2
		local var_23_3 = arg_23_3.texture_id or "texture_id"

		if arg_23_4 then
			local var_23_4 = arg_23_4.texture_size

			if var_23_4 then
				if arg_23_4.horizontal_alignment == "right" then
					arg_23_6[1] = arg_23_6[1] + arg_23_7[1] - var_23_4[1]
				elseif arg_23_4.horizontal_alignment == "center" then
					arg_23_6[1] = arg_23_6[1] + (arg_23_7[1] - var_23_4[1]) / 2
				end

				if arg_23_4.vertical_alignment == "center" then
					arg_23_6[2] = arg_23_6[2] + (arg_23_7[2] - var_23_4[2]) / 2
				elseif arg_23_4.vertical_alignment == "top" then
					arg_23_6[2] = arg_23_6[2] + arg_23_7[2] - var_23_4[2]
				end

				arg_23_7 = var_23_4
			end

			local var_23_5 = arg_23_4.tile_size
			local var_23_6 = Vector2(arg_23_7[1] / var_23_5[1], arg_23_7[2] / var_23_5[2])
			local var_23_7 = arg_23_3.retained_mode and arg_23_0.gui_retained or arg_23_0.gui
			local var_23_8 = Gui.material(var_23_7, arg_23_5[var_23_3])

			Material.set_vector2(var_23_8, "tile_multiplier", var_23_6)

			local var_23_9 = Vector2(0, 0)

			if arg_23_4.tile_offset then
				if arg_23_4.tile_offset[1] then
					var_23_9[1] = arg_23_6[1] / var_23_5[1]
				end

				if arg_23_4.tile_offset[2] then
					var_23_9[2] = arg_23_6[2] / var_23_5[2]
				end
			end

			Material.set_vector2(var_23_8, "tile_offset", var_23_9)

			var_23_0 = arg_23_4.color
			var_23_1 = arg_23_4.masked
			var_23_2 = arg_23_4.saturated
		end

		if arg_23_3.retained_mode then
			local var_23_10 = arg_23_3.retained_mode and (arg_23_1.retained_id and arg_23_1.retained_id or true)
			local var_23_11 = var_0_1(arg_23_0, arg_23_5[var_23_3], arg_23_6, arg_23_7, var_23_0, var_23_1, var_23_2, var_23_10)

			arg_23_1.retained_id = var_23_11 and var_23_11 or arg_23_1.retained_id
			arg_23_1.dirty = false
		else
			var_0_1(arg_23_0, arg_23_5[var_23_3], arg_23_6, arg_23_7, var_23_0, var_23_1, var_23_2)
		end
	end
}
UIPasses.tiled_texture = {
	init = function(arg_24_0)
		return nil
	end,
	draw = function(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6, arg_25_7, arg_25_8, arg_25_9)
		local var_25_0
		local var_25_1
		local var_25_2
		local var_25_3

		if arg_25_4 then
			local var_25_4 = arg_25_4.texture_size

			if var_25_4 then
				if arg_25_4.horizontal_alignment == "right" then
					arg_25_6[1] = arg_25_6[1] + arg_25_7[1] - var_25_4[1]
				elseif arg_25_4.horizontal_alignment == "center" then
					arg_25_6[1] = arg_25_6[1] + (arg_25_7[1] - var_25_4[1]) / 2
				end

				if arg_25_4.vertical_alignment == "center" then
					arg_25_6[2] = arg_25_6[2] + (arg_25_7[2] - var_25_4[2]) / 2
				elseif arg_25_4.vertical_alignment == "top" then
					arg_25_6[2] = arg_25_6[2] + arg_25_7[2] - var_25_4[2]
				end

				arg_25_7 = var_25_4
			end

			var_25_0 = arg_25_4.texture_tiling_size
			var_25_1 = arg_25_4.color
			var_25_2 = arg_25_4.masked
			var_25_3 = arg_25_4.saturated
		end

		assert(var_25_0, "Missing texture_tiling_size")

		local var_25_5 = arg_25_3.texture_id or "texture_id"

		return var_0_0.draw_tiled_texture(arg_25_0, arg_25_5[var_25_5], arg_25_6, arg_25_7, var_25_0, var_25_1, var_25_2, var_25_3)
	end
}
UIPasses.multi_texture = {
	init = function(arg_26_0, arg_26_1, arg_26_2)
		if arg_26_0.retained_mode then
			return {
				dirty = true
			}
		end

		return nil
	end,
	destroy = function(arg_27_0, arg_27_1, arg_27_2)
		assert(arg_27_2.retained_mode, "why u destroy immediate pass?")

		local var_27_0 = arg_27_1.retained_ids

		if var_27_0 then
			for iter_27_0 = 1, #var_27_0 do
				var_0_0.destroy_bitmap(arg_27_0, var_27_0[iter_27_0])
			end

			arg_27_1.retained_ids = nil
		end
	end,
	draw = function(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6, arg_28_7, arg_28_8, arg_28_9)
		local var_28_0 = arg_28_4.texture_size
		local var_28_1 = arg_28_4.texture_sizes
		local var_28_2 = arg_28_4.texture_offsets

		assert(var_28_0 or var_28_1, "Missing texture_sizes")

		if arg_28_3.retained_mode then
			local var_28_3 = arg_28_3.retained_mode and (arg_28_1.retained_ids and arg_28_1.retained_ids or true)
			local var_28_4 = var_0_0.draw_multi_texture(arg_28_0, arg_28_5[arg_28_3.texture_id], arg_28_6, var_28_0, var_28_1, var_28_2, arg_28_4.tile_sizes, arg_28_4.axis, arg_28_4.spacing, arg_28_4.direction, arg_28_4.draw_count, arg_28_4.texture_colors, arg_28_4.color, arg_28_4.masked, arg_28_4 and arg_28_4.texture_saturation, arg_28_4 and arg_28_4.saturated, var_28_3)

			arg_28_1.retained_ids = var_28_4 and var_28_4 or arg_28_1.retained_ids
			arg_28_1.dirty = false
		else
			return var_0_0.draw_multi_texture(arg_28_0, arg_28_5[arg_28_3.texture_id], arg_28_6, var_28_0, var_28_1, var_28_2, arg_28_4.tile_sizes, arg_28_4.axis, arg_28_4.spacing, arg_28_4.direction, arg_28_4.draw_count, arg_28_4.texture_colors, arg_28_4.color, arg_28_4.masked, arg_28_4 and arg_28_4.texture_saturation, arg_28_4 and arg_28_4.saturated)
		end
	end
}
UIPasses.centered_texture_amount = {
	init = function(arg_29_0)
		if arg_29_0.retained_mode then
			return {
				dirty = true
			}
		end

		return nil
	end,
	destroy = function(arg_30_0, arg_30_1, arg_30_2)
		assert(arg_30_2.retained_mode, "why u destroy immediate pass?")

		local var_30_0 = arg_30_1.retained_ids

		if var_30_0 then
			for iter_30_0 = 1, #var_30_0 do
				var_0_0.destroy_bitmap(arg_30_0, var_30_0[iter_30_0])
			end

			arg_30_1.retained_ids = nil
		end
	end,
	draw = function(arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5, arg_31_6, arg_31_7, arg_31_8, arg_31_9)
		local var_31_0 = arg_31_4.texture_size

		assert(var_31_0, "Missing texture_size")

		local var_31_1 = arg_31_4.texture_axis

		assert(var_31_1, "Missing texture_axis")

		local var_31_2 = arg_31_4.texture_amount

		assert(var_31_2, "Missing texture_amount")

		if arg_31_3.retained_mode then
			local var_31_3 = arg_31_3.retained_mode and (arg_31_1.retained_ids and arg_31_1.retained_ids or true)
			local var_31_4 = var_0_0.draw_centered_texture_amount(arg_31_0, arg_31_5[arg_31_3.texture_id], arg_31_6, arg_31_7, var_31_0, var_31_2, var_31_1, arg_31_4 and arg_31_4.spacing, arg_31_4 and arg_31_4.color, arg_31_4 and arg_31_4.texture_colors, arg_31_4 and arg_31_4.masked, var_31_3)

			arg_31_1.retained_ids = var_31_4 and var_31_4 or arg_31_1.retained_ids
			arg_31_1.dirty = false
		else
			return var_0_0.draw_centered_texture_amount(arg_31_0, arg_31_5[arg_31_3.texture_id], arg_31_6, arg_31_7, var_31_0, var_31_2, var_31_1, arg_31_4 and arg_31_4.spacing, arg_31_4 and arg_31_4.color, arg_31_4 and arg_31_4.texture_colors, arg_31_4 and arg_31_4.masked)
		end
	end
}
UIPasses.rotated_texture = {
	init = function(arg_32_0)
		if arg_32_0.retained_mode then
			return {
				dirty = true
			}
		end
	end,
	destroy = function(arg_33_0, arg_33_1, arg_33_2)
		assert(arg_33_2.retained_mode, "why u destroy immediate pass?")

		if arg_33_1.retained_id then
			var_0_0.destroy_bitmap(arg_33_0, arg_33_1.retained_id)

			arg_33_1.retained_id = nil
		end
	end,
	draw = function(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5, arg_34_6, arg_34_7, arg_34_8, arg_34_9)
		local var_34_0 = arg_34_5[arg_34_3.texture_id or "texture_id"]
		local var_34_1
		local var_34_2
		local var_34_3
		local var_34_4
		local var_34_5 = false

		if arg_34_4 then
			local var_34_6 = arg_34_4.texture_size

			if var_34_6 then
				if arg_34_4.horizontal_alignment == "right" then
					arg_34_6[1] = arg_34_6[1] + arg_34_7[1] - var_34_6[1]
				elseif arg_34_4.horizontal_alignment == "center" then
					arg_34_6[1] = arg_34_6[1] + (arg_34_7[1] - var_34_6[1]) / 2
				end

				if arg_34_4.vertical_alignment == "center" then
					arg_34_6[2] = arg_34_6[2] + (arg_34_7[2] - var_34_6[2]) / 2
				elseif arg_34_4.vertical_alignment == "top" then
					arg_34_6[2] = arg_34_6[2] + arg_34_7[2] - var_34_6[2]
				end

				arg_34_7 = var_34_6
			end

			var_34_1 = arg_34_4.angle
			var_34_2 = arg_34_4.pivot
			var_34_3 = arg_34_4.color
			var_34_4 = arg_34_4.uvs
			var_34_5 = arg_34_4.masked
		end

		if arg_34_3.retained_mode then
			local var_34_7 = arg_34_3.retained_mode and (arg_34_1.retained_id and arg_34_1.retained_id or true)
			local var_34_8 = var_0_0.draw_texture_rotated(arg_34_0, var_34_0, arg_34_7, arg_34_6, var_34_1, var_34_2, var_34_3, var_34_4, var_34_5, var_34_7)

			arg_34_1.retained_id = var_34_8 and var_34_8 or arg_34_1.retained_id
			arg_34_1.dirty = false
		else
			var_0_0.draw_texture_rotated(arg_34_0, var_34_0, arg_34_7, arg_34_6, var_34_1, var_34_2, var_34_3, var_34_4, var_34_5)
		end
	end
}
UIPasses.rounded_background = {
	init = function(arg_35_0)
		return nil
	end,
	draw = function(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6, arg_36_7, arg_36_8, arg_36_9)
		local var_36_0
		local var_36_1

		if arg_36_4 then
			local var_36_2 = arg_36_4.rect_size

			if var_36_2 then
				if arg_36_4.horizontal_alignment == "right" then
					arg_36_6[1] = arg_36_6[1] + arg_36_7[1] - var_36_2[1]
				elseif arg_36_4.horizontal_alignment == "center" then
					arg_36_6[1] = arg_36_6[1] + (arg_36_7[1] - var_36_2[1]) / 2
				end

				if arg_36_4.vertical_alignment == "center" then
					arg_36_6[2] = arg_36_6[2] + (arg_36_7[2] - var_36_2[2]) / 2
				elseif arg_36_4.vertical_alignment == "top" then
					arg_36_6[2] = arg_36_6[2] + arg_36_7[2] - var_36_2[2]
				end

				arg_36_7 = var_36_2
			end

			var_36_0 = arg_36_4.corner_radius
			var_36_1 = arg_36_4.color
		end

		return var_0_0.draw_rounded_rect(arg_36_0, arg_36_6, arg_36_7, var_36_0, var_36_1)
	end
}
UIPasses.triangle = {
	init = function(arg_37_0)
		if arg_37_0.retained_mode then
			return {
				dirty = true
			}
		end
	end,
	destroy = function(arg_38_0, arg_38_1, arg_38_2)
		assert(arg_38_2.retained_mode, "why u destroy immediate pass?")

		if arg_38_1.retained_id then
			var_0_0.destroy_bitmap(arg_38_0, arg_38_1.retained_id)

			arg_38_1.retained_id = nil
		end
	end,
	draw = function(arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6, arg_39_7, arg_39_8, arg_39_9)
		if arg_39_4 then
			local var_39_0 = arg_39_4.texture_size

			if var_39_0 then
				if arg_39_4.horizontal_alignment == "right" then
					arg_39_6[1] = arg_39_6[1] + arg_39_7[1] - var_39_0[1]
				elseif arg_39_4.horizontal_alignment == "center" then
					arg_39_6[1] = arg_39_6[1] + (arg_39_7[1] - var_39_0[1]) / 2
				end

				if arg_39_4.vertical_alignment == "center" then
					arg_39_6[2] = arg_39_6[2] + (arg_39_7[2] - var_39_0[2]) / 2
				elseif arg_39_4.vertical_alignment == "top" then
					arg_39_6[2] = arg_39_6[2] + arg_39_7[2] - var_39_0[2]
				end

				arg_39_7 = var_39_0
			end
		end

		if arg_39_3.retained_mode then
			local var_39_1 = arg_39_3.retained_mode and (arg_39_1.retained_id and arg_39_1.retained_id or true)
			local var_39_2 = var_0_0.draw_triangle(arg_39_0, arg_39_6, arg_39_7, arg_39_4, var_39_1)

			arg_39_1.retained_id = var_39_2 and var_39_2 or arg_39_1.retained_id
			arg_39_1.dirty = false
		else
			var_0_0.draw_triangle(arg_39_0, arg_39_6, arg_39_7, arg_39_4)
		end
	end
}

local var_0_11 = "Vector3"

UIPasses.scrollbar_hotspot = {
	init = function(arg_40_0)
		return {
			content_id = arg_40_0.content_id,
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
				var_0_8.huge,
				var_0_8.huge
			}
		}
	end,
	draw = function(arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4, arg_41_5, arg_41_6, arg_41_7, arg_41_8, arg_41_9)
		local var_41_0
		local var_41_1 = "cursor"
		local var_41_2 = ShowCursorStack.stack_depth
		local var_41_3 = arg_41_8 and arg_41_8:has(var_41_1)
		local var_41_4 = var_41_2 > 0 and var_41_3 and arg_41_8:get(var_41_1)

		if not var_41_4 or Script.type_name(var_41_4) ~= var_0_11 then
			var_41_4 = var_0_9
		end

		local var_41_5 = Managers.input:is_device_active("gamepad")
		local var_41_6

		if var_41_5 then
			var_41_6 = var_41_4
		else
			var_41_6 = var_0_3(var_41_4)
		end

		local var_41_7 = arg_41_1.hotspot_position

		var_41_7[1] = arg_41_6[1]
		var_41_7[2] = arg_41_6[2]
		var_41_7[3] = arg_41_6[3]

		local var_41_8 = arg_41_1.hotspot_size

		var_41_8[1] = arg_41_7[1]
		var_41_8[2] = arg_41_7[2]

		if arg_41_4.hotspot_width_modifier then
			local var_41_9 = var_41_8[1] * arg_41_4.hotspot_width_modifier

			var_41_8[1] = var_41_9
			var_41_7[1] = var_41_7[1] - var_41_9 / 2 + arg_41_7[1] / 2
		end

		local var_41_10 = var_0_8.point_is_inside_2d_box(var_41_6, var_41_7, var_41_8)

		arg_41_5.is_hover = var_41_10

		local var_41_11 = arg_41_5.percentage
		local var_41_12 = arg_41_1.scrollbar_size

		var_41_12[1] = var_41_8[1]

		local var_41_13 = var_0_8.max(arg_41_4.min_scrollbar_height, var_41_8[2] * var_41_11)

		var_41_12[2] = var_41_13

		local var_41_14 = arg_41_5.scroll_value
		local var_41_15 = var_41_8[2] - var_41_13
		local var_41_16 = var_41_15 * var_41_14
		local var_41_17 = arg_41_1.scrollbar_position

		var_41_17[1] = var_41_7[1]
		var_41_17[2] = var_41_7[2] + var_41_16
		var_41_17[3] = var_41_7[3] + 1

		local var_41_18 = var_0_8.point_is_inside_2d_box(var_41_6, var_41_17, var_41_12)

		arg_41_5.is_hover_scrollbar = var_41_18

		local var_41_19 = arg_41_8 and arg_41_8:get("left_hold")

		if var_41_18 then
			if var_41_19 then
				arg_41_5.holding = true

				if arg_41_1.start_move_pos[2] == var_0_8.huge then
					arg_41_1.start_move_pos[2] = var_41_4[2]
					arg_41_5.og_scroll_value = arg_41_5.scroll_value
				end
			end
		elseif var_41_10 and var_41_19 then
			arg_41_5.holding = true
		end

		local var_41_20

		if arg_41_5.holding then
			if not var_41_19 then
				arg_41_5.holding = false
				arg_41_1.start_move_pos[2] = var_0_8.huge
			elseif arg_41_1.start_move_pos[2] < var_0_8.huge then
				local var_41_21 = arg_41_1.start_move_pos[2]
				local var_41_22 = (var_41_4[2] - var_41_21) / var_41_15
				local var_41_23 = arg_41_5.og_scroll_value

				var_41_20 = var_0_8.clamp(var_41_23 + var_41_22, 0, 1)
			else
				local var_41_24 = var_41_4[2] - var_41_7[2]

				var_41_20 = var_0_8.clamp(var_41_24 / var_41_15, 0, 1)
			end
		end

		local var_41_25 = false
		local var_41_26 = arg_41_1.scroll_area_position
		local var_41_27 = arg_41_4.scroll_area_size

		if not var_41_20 and var_41_27 then
			local var_41_28 = arg_41_4.scroll_area_offset

			var_41_26[1] = var_41_7[1] + var_41_28[1]
			var_41_26[2] = var_41_7[2] + var_41_28[2]
			var_41_26[3] = var_41_7[3] + var_41_28[3]
			var_41_25 = var_0_8.point_is_inside_2d_box(var_41_6, var_41_26, var_41_27)

			if var_41_25 then
				local var_41_29 = arg_41_8:get("scroll_axis")[2]
				local var_41_30 = arg_41_5.scroll_amount * var_41_29

				var_41_20 = var_0_8.clamp(arg_41_5.scroll_value + var_41_30, 0, 1)
			end
		end

		if var_41_20 then
			arg_41_5.scroll_value = var_41_20
		end

		if script_data.ui_debug_hover then
			if var_41_10 then
				var_0_0.draw_rect(arg_41_0, Vector3(var_41_7[1], var_41_7[2], 999), var_41_8, {
					128,
					0,
					255,
					0
				})
			else
				var_0_0.draw_rect(arg_41_0, Vector3(var_41_7[1], var_41_7[2], var_41_7[3] + 1), var_41_8, {
					60,
					255,
					0,
					0
				})
			end

			if var_41_18 then
				var_0_0.draw_rect(arg_41_0, Vector3(var_41_17[1], var_41_17[2], 999), var_41_12, {
					128,
					0,
					255,
					0
				})
			else
				var_0_0.draw_rect(arg_41_0, Vector3(var_41_17[1], var_41_17[2], var_41_17[3] + 1), var_41_12, {
					60,
					255,
					0,
					0
				})
			end

			if var_41_25 then
				var_0_0.draw_rect(arg_41_0, Vector3(var_41_26[1], var_41_26[2], 999), var_41_27, {
					128,
					0,
					255,
					0
				})
			else
				var_0_0.draw_rect(arg_41_0, Vector3(var_41_26[1], var_41_26[2], var_41_26[3] + 1), var_41_27, {
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
	init = function(arg_42_0)
		return {
			content_id = arg_42_0.content_id,
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
	draw = function(arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5, arg_43_6, arg_43_7, arg_43_8, arg_43_9)
		var_0_0.draw_rect(arg_43_0, arg_43_6, arg_43_7, arg_43_4.background_color)

		local var_43_0 = arg_43_5.percentage
		local var_43_1 = arg_43_1.scrollbar_size

		var_43_1[1] = arg_43_7[1]

		local var_43_2 = var_0_8.max(arg_43_4.min_scrollbar_height, arg_43_7[2] * var_43_0)

		var_43_1[2] = var_43_2

		local var_43_3 = arg_43_5.scroll_value
		local var_43_4 = (arg_43_7[2] - var_43_2) * var_43_3
		local var_43_5 = arg_43_1.scrollbar_position

		var_43_5[1] = arg_43_6[1]
		var_43_5[2] = arg_43_6[2] + var_43_4
		var_43_5[3] = arg_43_6[3] + 1

		var_0_0.draw_rect(arg_43_0, var_43_5, var_43_1, arg_43_4.scrollbar_color)
	end
}
UIPasses.rect_rotated = {
	init = function(arg_44_0)
		return nil
	end,
	draw = function(arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6, arg_45_7, arg_45_8, arg_45_9)
		local var_45_0 = 0
		local var_45_1
		local var_45_2

		if arg_45_4 then
			local var_45_3 = arg_45_4.texture_size

			if var_45_3 then
				if arg_45_4.horizontal_alignment == "right" then
					arg_45_6[1] = arg_45_6[1] + arg_45_7[1] - var_45_3[1]
				elseif arg_45_4.horizontal_alignment == "center" then
					arg_45_6[1] = arg_45_6[1] + (arg_45_7[1] - var_45_3[1]) / 2
				end

				if arg_45_4.vertical_alignment == "center" then
					arg_45_6[2] = arg_45_6[2] + (arg_45_7[2] - var_45_3[2]) / 2
				elseif arg_45_4.vertical_alignment == "top" then
					arg_45_6[2] = arg_45_6[2] + arg_45_7[2] - var_45_3[2]
				end

				arg_45_7 = var_45_3
			end

			var_45_0 = arg_45_4.angle
			var_45_1 = arg_45_4.pivot
			var_45_2 = arg_45_4.color
		end

		return var_0_0.draw_rect_rotated(arg_45_0, arg_45_7, arg_45_6, var_45_0, var_45_1, var_45_2)
	end
}
UIPasses.video = {
	init = function(arg_46_0)
		return nil
	end,
	draw = function(arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4, arg_47_5, arg_47_6, arg_47_7, arg_47_8, arg_47_9)
		arg_47_5.video_completed = var_0_0.draw_video(arg_47_0, arg_47_5.material_name, arg_47_6, arg_47_7, arg_47_4.color, arg_47_5.video_player_reference, arg_47_5.video_player)
	end
}
UIPasses.splash_video = {
	init = function(arg_48_0)
		return nil
	end,
	draw = function(arg_49_0, arg_49_1, arg_49_2, arg_49_3, arg_49_4, arg_49_5, arg_49_6, arg_49_7, arg_49_8, arg_49_9)
		arg_49_5.video_completed = var_0_0.draw_splash_video(arg_49_0, arg_49_5.material_name, arg_49_6, arg_49_7, arg_49_4.color, arg_49_5.video_player_reference, arg_49_5.video_player)
	end
}
UIPasses.border = {
	init = function(arg_50_0)
		return nil
	end,
	draw = function(arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4, arg_51_5, arg_51_6, arg_51_7, arg_51_8, arg_51_9)
		local var_51_0 = arg_51_6
		local var_51_1 = arg_51_4.thickness or 1

		var_0_0.draw_rect(arg_51_0, var_51_0, Vector3(var_51_1, arg_51_7.y, 0), arg_51_4.color)
		var_0_0.draw_rect(arg_51_0, var_51_0, Vector3(arg_51_7.x, var_51_1, 0), arg_51_4.color)
		var_0_0.draw_rect(arg_51_0, var_51_0 + Vector3(arg_51_7.x - var_51_1, 0, 0), Vector3(var_51_1, arg_51_7.y, 0), arg_51_4.color)
		var_0_0.draw_rect(arg_51_0, var_51_0 + Vector3(0, arg_51_7.y - var_51_1, 0), Vector3(arg_51_7.x, var_51_1, 0), arg_51_4.color)
	end
}

local function var_0_12(arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4, arg_52_5, arg_52_6)
	local var_52_0 = Vector3(0, 0, 0)

	if arg_52_6.horizontal_alignment == "right" then
		var_52_0 = Vector3(arg_52_4[1] - arg_52_0, 0, 0)
	elseif arg_52_6.horizontal_alignment == "center" then
		local var_52_1 = (arg_52_4[1] - arg_52_0) / 2

		var_52_0 = Vector3(var_52_1 - arg_52_5.x, 0, 0)
	end

	local var_52_2 = RESOLUTION_LOOKUP.inv_scale

	if arg_52_6.vertical_alignment == "center" then
		local var_52_3 = (arg_52_4[2] - arg_52_1 * var_52_2 * 0.5) / 2

		var_52_0 = var_52_0 + Vector3(0, var_52_3, 0)
	elseif arg_52_6.vertical_alignment == "top" then
		local var_52_4 = arg_52_4[2] - arg_52_3 * var_52_2

		var_52_0 = var_52_0 + Vector3(0, var_52_4, 0)
	else
		var_52_0.y = var_52_0.y + var_0_8.abs(arg_52_2) * var_52_2
	end

	return var_52_0
end

local var_0_13 = {}
local var_0_14 = {}
local var_0_15 = {}
local var_0_16 = {}
local var_0_17 = {}
local var_0_18 = {}
local var_0_19 = {}
local var_0_20 = {}
local var_0_21 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890"
local var_0_22 = "{#color(%d,%d,%d)}"

UIPasses.text_area_chat = {
	init = function(arg_53_0)
		assert(arg_53_0.text_id)

		return {
			irc_channel_colors = table.clone(IRC_CHANNEL_COLORS),
			text_id = arg_53_0.text_id
		}
	end,
	draw = function(arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5, arg_54_6, arg_54_7, arg_54_8, arg_54_9)
		if #arg_54_5.message_tables == 0 then
			return
		end

		table.clear_array(var_0_14, #var_0_14)
		table.clear(var_0_15)
		table.clear(var_0_16)
		table.clear(var_0_17)
		table.clear(var_0_18)
		table.clear(var_0_13)
		table.clear(var_0_19)
		table.clear(var_0_20)

		local var_54_0, var_54_1 = Gui.resolution()
		local var_54_2 = var_54_0 .. ":" .. var_54_1 .. "-" .. arg_54_4.font_size
		local var_54_3
		local var_54_4
		local var_54_5

		if arg_54_4.font_type then
			local var_54_6, var_54_7 = UIFontByResolution(arg_54_4)

			var_54_3, var_54_4, var_54_5 = var_54_6[1], var_54_7, arg_54_4.font_type
		end

		local var_54_8 = Vector3(arg_54_7.x, var_54_4, arg_54_7.z)
		local var_54_9 = arg_54_4.offset

		if var_54_9 then
			arg_54_6 = arg_54_6 + Vector3(var_54_9[1], var_54_9[2], var_54_9[3] or 0)
		end

		local var_54_10 = arg_54_4.text_color[1]
		local var_54_11 = arg_54_1.irc_channel_colors

		for iter_54_0, iter_54_1 in pairs(var_54_11) do
			iter_54_1[1] = var_54_10
		end

		local var_54_12 = RESOLUTION_LOOKUP.inv_scale
		local var_54_13, var_54_14 = UIFontByResolution(arg_54_4, var_54_12)
		local var_54_15 = unpack(var_54_13)
		local var_54_16, var_54_17, var_54_18 = var_0_0.text_size(arg_54_0, var_0_21, var_54_15, arg_54_4.font_size)
		local var_54_19 = arg_54_4.text_color
		local var_54_20 = arg_54_4.default_color
		local var_54_21 = arg_54_4.name_color
		local var_54_22 = arg_54_4.name_color_dev
		local var_54_23 = arg_54_4.name_color_system
		local var_54_24 = 0

		for iter_54_2 = 1, #arg_54_5.message_tables do
			local var_54_25 = arg_54_5.message_tables[iter_54_2]
			local var_54_26 = var_54_25.is_dev
			local var_54_27 = var_54_25.is_bot
			local var_54_28 = var_54_25.is_system
			local var_54_29 = var_54_25.is_enemy
			local var_54_30 = var_54_25.trimmed_sender or var_54_25.sender
			local var_54_31 = var_54_25.message
			local var_54_32 = var_54_25.type
			local var_54_33 = var_54_25.link
			local var_54_34 = var_54_25.emojis
			local var_54_35 = var_54_25.formatted
			local var_54_36 = var_54_25.channel_string or ""

			if var_54_35 ~= var_54_2 then
				local var_54_37

				if var_54_36 ~= "" then
					local var_54_38 = var_54_29 and {
						255,
						237,
						48,
						48
					} or {
						255,
						53,
						161,
						212
					}

					var_54_36 = var_0_7.format(var_0_22, var_54_38[2], var_54_38[3], var_54_38[4]) .. var_54_36
				end

				if var_54_20 and type(var_54_20) == "table" then
					var_54_20 = var_0_7.format(var_0_22, var_54_20[2], var_54_20[3], var_54_20[4])
				else
					var_54_20 = var_54_20 or var_0_7.format(var_0_22, var_54_19[2], var_54_19[3], var_54_19[4])
				end

				if var_54_28 then
					if var_54_23 and type(var_54_23) == "table" then
						var_54_23 = var_0_7.format(var_0_22, var_54_23[2], var_54_23[3], var_54_23[4])
					end

					var_54_37 = var_54_23 .. var_54_30 .. var_54_20 .. var_54_31
				elseif var_54_26 then
					if var_54_22 and type(var_54_22) == "table" then
						var_54_22 = var_0_7.format(var_0_22, var_54_22[2], var_54_22[3], var_54_22[4])
					end

					var_54_37 = var_54_36 .. var_54_22 .. var_54_30 .. var_54_20 .. var_54_31
				else
					if var_54_21 and type(var_54_21) == "table" then
						var_54_21 = var_0_7.format(var_0_22, var_54_21[2], var_54_21[3], var_54_21[4])
					end

					local var_54_39 = var_54_36 ~= "" and "" or var_54_21

					var_54_37 = var_54_36 .. var_54_39 .. var_54_30 .. var_54_20 .. var_54_31
				end

				local var_54_40 = "${e};"
				local var_54_41 = var_54_37

				if var_54_34 then
					for iter_54_3, iter_54_4 in ipairs(var_54_34) do
						var_54_41 = var_0_7.gsub(var_54_41, iter_54_4.keys, var_54_40)
					end
				end

				local var_54_42 = var_0_0.word_wrap(arg_54_0, var_54_41, var_54_3, var_54_4, arg_54_7[1], nil, var_54_5)
				local var_54_43
				local var_54_44 = table.clone(var_54_42)

				if var_54_34 then
					local var_54_45
					local var_54_46

					var_54_43 = {}

					for iter_54_5, iter_54_6 in ipairs(var_54_34) do
						for iter_54_7, iter_54_8 in ipairs(var_54_44) do
							local var_54_47 = var_0_7.find(iter_54_8, var_54_40)

							if var_54_47 then
								local var_54_48 = var_0_7.sub(iter_54_8, 0, var_0_8.max(var_54_47 - 1, 0))

								if not Utf8.valid(var_54_48) then
									print(var_0_7.format("%q is not a valid utf-8 string", var_54_48))

									break
								end

								local var_54_49 = "      "
								local var_54_50 = var_0_7.gsub(var_54_48, "{#.-}", "")
								local var_54_51 = UIUtils.get_text_width(arg_54_0, arg_54_4, var_54_50)

								var_54_43[iter_54_7] = var_54_43[iter_54_7] or {}
								var_54_43[iter_54_7][#var_54_43[iter_54_7] + 1] = {
									data = iter_54_6,
									offset_x = var_54_51,
									offset_y = -arg_54_4.emoji_size[2] * 0.3,
									size = arg_54_4.emoji_size
								}
								var_54_45 = var_0_7.gsub(iter_54_8, var_54_40, var_54_49, 1)
								var_54_46 = iter_54_7

								break
							end
						end

						if var_54_45 then
							var_54_44[var_54_46] = var_54_45
						end
					end
				end

				var_54_25.formatted_emojis = var_54_43
				var_54_25.formatted_message_array = var_54_44
				var_54_25.formatted = var_54_2
			end

			local var_54_52 = var_54_25.formatted_message_array
			local var_54_53 = var_54_25.formatted_emojis
			local var_54_54 = #var_54_52

			var_54_24 = var_54_24 + var_54_54

			local var_54_55 = #var_0_14 + 1

			for iter_54_9 = 1, var_54_54 do
				var_0_14[var_54_55] = var_54_52[iter_54_9]

				if var_54_28 then
					var_0_18[var_54_55] = var_54_52[iter_54_9]
				end

				if iter_54_9 == 1 then
					if var_54_26 then
						var_0_17[#var_0_14] = var_54_30
					elseif var_54_27 then
						var_0_15[var_54_55] = var_54_30
						var_0_16[var_54_55] = Colors.get_color_table_with_alpha("dark_gray", var_54_10)
					else
						var_0_15[var_54_55] = var_54_30
						var_0_16[var_54_55] = var_54_11[var_54_32] or Colors.get_color_table_with_alpha("gray", var_54_10)
					end

					local var_54_56, var_54_57, var_54_58 = var_0_0.text_size(arg_54_0, var_54_36, var_54_3, var_54_4)

					var_0_20[var_54_55] = var_54_56
				end

				if var_54_33 then
					var_0_13[var_54_55] = var_54_33
				end

				if var_54_53 and var_54_53[iter_54_9] then
					local var_54_59 = var_54_53[iter_54_9]

					var_0_19[var_54_55] = var_54_59
				end

				var_54_55 = var_54_55 + 1
			end
		end

		local var_54_60 = arg_54_4.spacing or 0
		local var_54_61 = var_0_8.floor(arg_54_7[2] / (arg_54_4.font_size + var_54_60))
		local var_54_62 = var_54_61 * arg_54_4.font_size
		local var_54_63 = 12

		if var_54_62 > arg_54_7[2] + var_54_63 then
			var_54_61 = var_54_61 - 1
		end

		local var_54_64 = var_0_8.min(var_54_61, var_54_24)
		local var_54_65 = arg_54_4.vertical_alignment

		if var_54_65 == "top" then
			arg_54_6 = arg_54_6 + Vector3(0, arg_54_7[2], 0)
		elseif var_54_65 == "bottom" then
			local var_54_66 = (arg_54_4.font_size + var_54_60) * (var_54_64 - 1)

			arg_54_6 = arg_54_6 + Vector3(0, var_54_66 - var_54_18[2], 0)
		end

		local var_54_67 = var_54_64 / var_54_24
		local var_54_68 = arg_54_5.text_start_offset
		local var_54_69 = (1 - var_54_67) * var_54_24
		local var_54_70 = var_0_8.modf((1 + var_54_69) * var_54_68)
		local var_54_71 = var_0_8.min(var_54_24, var_54_70 + var_54_64)

		for iter_54_10 = var_0_8.max(1, var_54_71 - var_54_64 + 1), var_54_71 do
			local var_54_72 = var_0_14[iter_54_10]

			var_0_0.draw_text(arg_54_0, var_54_72, var_54_3, var_54_4, var_54_5, arg_54_6, var_54_19)

			if var_0_13[iter_54_10] then
				local var_54_73 = arg_54_8:get("cursor") or var_0_9
				local var_54_74 = var_0_3(var_54_73)

				if var_0_8.point_is_inside_2d_box(var_54_74, arg_54_6, var_54_8) then
					var_0_0.draw_rect(arg_54_0, arg_54_6, var_54_8, Colors.get_color_table_with_alpha("magenta", 50))

					if arg_54_8:get("left_press") then
						print("PRESSED")

						arg_54_5.link_pressed = var_0_13[iter_54_10]
					end
				else
					var_0_0.draw_rect(arg_54_0, arg_54_6, var_54_8, Colors.get_color_table_with_alpha("powder_blue", 50))
				end
			end

			if var_0_19[iter_54_10] then
				for iter_54_11, iter_54_12 in ipairs(var_0_19[iter_54_10]) do
					var_0_0.draw_texture(arg_54_0, iter_54_12.data.texture, arg_54_6 + Vector3(iter_54_12.offset_x, iter_54_12.offset_y, 0), Vector2(iter_54_12.size[1], iter_54_12.size[2]))
				end
			end

			arg_54_6.y = arg_54_6.y - arg_54_4.font_size - var_54_60
		end
	end
}

local var_0_23 = {}
local var_0_24 = {}
local var_0_25 = {}
local var_0_26 = {}

local function var_0_27(arg_55_0, arg_55_1, arg_55_2, arg_55_3)
	local var_55_0 = arg_55_2

	if arg_55_1.localize then
		var_55_0 = Managers.localizer:simple_lookup(arg_55_2)
	end

	if not var_0_7.find(var_55_0, "%b$;[%a%d_]*:") then
		table.clear(var_0_25)

		return arg_55_3
	end

	local var_55_1 = Managers.input and Managers.input:is_device_active("gamepad")
	local var_55_2
	local var_55_3, var_55_4

	var_55_3, var_0_25, var_55_4, var_0_26 = Managers.localizer:get_input_action(var_55_0)

	local var_55_5 = RESOLUTION_LOOKUP.inv_scale

	if var_0_25[1] then
		table.clear(var_0_23)
		table.clear(var_0_24)

		for iter_55_0 = 1, #var_0_25 do
			local var_55_6 = var_0_25[iter_55_0]
			local var_55_7 = var_0_26[iter_55_0]
			local var_55_8, var_55_9 = UIFontByResolution(arg_55_1)
			local var_55_10 = var_55_8[1]
			local var_55_11 = var_55_9
			local var_55_12 = var_0_0.text_size(arg_55_0, "½", var_55_10, var_55_11)
			local var_55_13 = var_0_0.text_size(arg_55_0, "½ ", var_55_10, var_55_11) - var_55_12

			if var_55_1 then
				local var_55_14 = var_55_11 * var_55_5
				local var_55_15 = var_0_8.ceil(var_55_14 / var_55_13) + 1

				var_0_23[iter_55_0] = var_0_7.rep(" ", var_55_15)

				local var_55_16 = var_0_8.ceil(var_55_14 / var_55_12) + 1

				var_0_24[iter_55_0] = var_0_7.rep("½", var_55_16)
			else
				local var_55_17, var_55_18, var_55_19, var_55_20 = UISettings.get_gamepad_input_texture_data(Managers.input:get_service(var_55_7), var_55_6, var_55_1)

				if not var_55_19 or not var_55_20 and var_55_19[1] == "mouse" then
					local var_55_21 = var_55_11 * var_55_5
					local var_55_22 = var_0_8.ceil(var_55_21 / var_55_13) + 1

					var_0_23[iter_55_0] = var_0_7.rep(" ", var_55_22)

					local var_55_23 = var_0_8.ceil(var_55_21 / var_55_12) + 1

					var_0_24[iter_55_0] = var_0_7.rep("½", var_55_23)
				else
					local var_55_24 = Utf8.upper(var_55_20 and Localize(var_55_19[2]) or Keyboard.button_name(var_55_19[2]) or Localize(UNASSIGNED_KEY))
					local var_55_25 = var_0_0.text_size(arg_55_0, var_55_24, var_55_10, var_55_11) + var_55_11 * var_55_5
					local var_55_26 = var_0_8.ceil(var_55_25 / var_55_13)

					var_0_23[iter_55_0] = var_0_7.rep(" ", var_55_26)

					local var_55_27 = var_0_8.ceil(var_55_25 / var_55_12)

					var_0_24[iter_55_0] = var_0_7.rep("½", var_55_27)
				end
			end
		end

		local var_55_28 = true
		local var_55_29 = 1

		for iter_55_1 = 1, #var_0_24 do
			var_55_0 = Managers.localizer:replace_macro_in_string(var_55_0, var_0_24[iter_55_1], var_55_28, var_55_29)
		end

		table.reverse(var_0_25)
		table.reverse(var_0_26)
		table.reverse(var_0_24)
		table.reverse(var_0_23)
	else
		var_55_0 = arg_55_3
	end

	return var_55_0
end

local var_0_28 = {
	0,
	255,
	255,
	255
}

local function var_0_29(arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4, arg_56_5, arg_56_6)
	if not var_0_25[1] then
		return arg_56_1
	end

	local var_56_0 = true
	local var_56_1 = RESOLUTION_LOOKUP.inv_scale

	while var_56_0 do
		local var_56_2 = var_0_25[#var_0_25]
		local var_56_3 = var_0_26[#var_0_26]
		local var_56_4 = var_0_24[#var_0_24]
		local var_56_5 = var_0_23[#var_0_23]

		if not var_56_2 or not var_56_3 or not var_56_4 or not var_56_5 then
			Crashify.print_exception("Buttons in text", "Text: %q - Input action: %q - input_service: %q - replacement_str: %q - final_replacement_str: %q", tostring(arg_56_1), tostring(var_56_2), tostring(var_56_3), tostring(var_56_4), tostring(var_56_5))
			table.clear(var_0_25)
			table.clear(var_0_26)
			table.clear(var_0_24)
			table.clear(var_0_23)

			return arg_56_1
		end

		local var_56_6 = var_0_7.find(arg_56_1, var_0_24[#var_0_24])

		if var_56_6 then
			local var_56_7 = var_0_25[#var_0_25]
			local var_56_8 = var_0_26[#var_0_26]
			local var_56_9 = Managers.input:is_device_active("gamepad")
			local var_56_10, var_56_11, var_56_12, var_56_13 = UISettings.get_gamepad_input_texture_data(Managers.input:get_service(var_56_8), var_56_7, var_56_9)
			local var_56_14 = var_0_7.sub(arg_56_1, 1, var_0_8.max(var_56_6, 2))
			local var_56_15 = false

			while not Utf8.valid(var_56_14) and var_56_6 > 1 do
				var_56_6 = var_56_6 - 1
				var_56_14 = var_0_7.sub(arg_56_1, 1, var_0_8.max(var_56_6, 2))
				var_56_15 = true
			end

			local var_56_16 = var_0_0.text_size(arg_56_0, var_56_14, arg_56_2, arg_56_3)

			var_56_16 = var_56_6 > 1 and var_56_16 or 0

			local var_56_17 = false

			if var_56_15 then
				var_56_17 = arg_56_5 + Vector3(var_56_16 + arg_56_3 * var_56_1 * 0.25, -arg_56_3 * var_56_1 * 0.25, 0)
			else
				var_56_17 = arg_56_5 + Vector3(var_56_16 - arg_56_3 * var_56_1 * 0.25, -arg_56_3 * var_56_1 * 0.25, 0)
			end

			if not arg_56_6.skip_button_rendering then
				if var_56_9 then
					if var_56_10 then
						var_0_28[1] = arg_56_6.text_color[1]

						var_0_1(arg_56_0, var_56_10.texture, var_56_17, Vector2(arg_56_3 * var_56_1, arg_56_3 * var_56_1), var_0_28, arg_56_6.masked, arg_56_6.saturated)
					else
						local var_56_18 = arg_56_5 + Vector3(var_56_16, 0, 0)

						var_0_0.draw_text(arg_56_0, "[?]", arg_56_2, arg_56_3, arg_56_4, var_56_18, Colors.get_color_table_with_alpha("font_title", 255))
					end
				elseif not var_56_12 or not var_56_13 and var_56_12[1] == "mouse" then
					if var_56_10 then
						local var_56_19 = var_56_10.size[2] / var_56_10.size[1]

						var_0_28[1] = arg_56_6.text_color[1]

						var_0_1(arg_56_0, var_56_10.texture, var_56_17, Vector2(arg_56_3 * var_56_1, arg_56_3 * var_56_1 * var_56_19), var_0_28, arg_56_6.masked, arg_56_6.saturated)
					else
						local var_56_20 = arg_56_5 + Vector3(var_56_16, 0, 0)

						var_0_0.draw_text(arg_56_0, "[?]", arg_56_2, arg_56_3, arg_56_4, var_56_20, Colors.get_color_table_with_alpha("font_title", 255))
					end
				else
					local var_56_21 = Utf8.upper(var_56_13 and Localize(var_56_12[2]) or Keyboard.button_name(var_56_12[2]) or Localize(UNASSIGNED_KEY))
					local var_56_22, var_56_23 = var_0_0.text_size(arg_56_0, var_56_21, arg_56_2, arg_56_3)
					local var_56_24 = var_56_10[1]
					local var_56_25 = var_56_10[2]
					local var_56_26 = var_56_23 / var_56_24.size[2] * 1.5
					local var_56_27

					if var_56_15 then
						var_56_27 = arg_56_5 + Vector3(var_56_16 + var_56_24.size[1] * 0.3 * var_56_26, -var_56_24.size[2] * 0.23 * var_56_26, 0)
					else
						var_56_27 = arg_56_5 + Vector3(var_56_16 - var_56_24.size[1] * 0.3 * var_56_26, -var_56_24.size[2] * 0.23 * var_56_26, 0)
					end

					var_0_1(arg_56_0, var_56_24.texture, var_56_27, Vector2(var_56_24.size[1] * var_56_26, var_56_24.size[2] * var_56_26), {
						arg_56_6.text_color[1],
						255,
						255,
						255
					}, arg_56_6.masked, arg_56_6.saturated)

					var_56_27[1] = var_56_27[1] + var_56_24.size[1] * var_56_26

					var_0_1(arg_56_0, var_56_25.texture, var_56_27, Vector2(var_56_22, var_56_25.size[2] * var_56_26), {
						arg_56_6.text_color[1],
						255,
						255,
						255
					}, arg_56_6.masked, arg_56_6.saturated)

					local var_56_28

					if var_56_15 then
						var_56_28 = arg_56_5 + Vector3(var_56_16 + (var_56_24.size[1] * 0.3 * var_56_26 + var_56_24.size[1] * 0.3 * var_56_26) * 2, 0, 1)
					else
						var_56_28 = arg_56_5 + Vector3(var_56_16 + var_56_24.size[1] * 0.3 * var_56_26 + var_56_24.size[1] * 0.3 * var_56_26, 0, 1)
					end

					var_0_0.draw_text(arg_56_0, var_56_21, arg_56_2, arg_56_3, arg_56_4, var_56_28, arg_56_6.text_color)

					var_56_27[1] = var_56_27[1] + var_56_22

					var_0_2(arg_56_0, var_56_24.texture, var_56_27, Vector2(var_56_24.size[1] * var_56_26, var_56_24.size[2] * var_56_26), {
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

			arg_56_1 = var_0_7.gsub(arg_56_1, var_0_24[#var_0_24], var_0_23[#var_0_23], 1)
			var_0_25[#var_0_25] = nil
			var_0_26[#var_0_26] = nil
			var_0_24[#var_0_24] = nil
			var_0_23[#var_0_23] = nil
		end

		var_56_0 = var_56_6 ~= nil and #var_0_24 > 0
	end

	return arg_56_1
end

local function var_0_30(arg_57_0, arg_57_1, arg_57_2, arg_57_3, arg_57_4)
	local var_57_0 = arg_57_4.color_override
	local var_57_1 = arg_57_4.internal_color_overrides

	if not var_57_1 then
		var_57_1 = {}
		arg_57_4.internal_color_overrides = var_57_1
	end

	local var_57_2 = var_57_1[arg_57_0]
	local var_57_3 = #var_57_0

	if var_57_3 > 0 then
		if not var_57_2 then
			var_57_2 = {}
			var_57_1[arg_57_0] = var_57_2
		end

		local var_57_4 = var_0_8.max(var_57_3, #var_57_2)

		for iter_57_0 = 1, var_57_4 do
			local var_57_5 = true
			local var_57_6 = var_57_0[iter_57_0]

			if var_57_6 then
				local var_57_7 = arg_57_0 - 1
				local var_57_8 = var_57_6.color
				local var_57_9 = var_57_6.start_index + var_57_7
				local var_57_10 = var_57_6.end_index + var_57_7

				if var_57_9 <= arg_57_2 + arg_57_1 then
					local var_57_11
					local var_57_12

					if var_57_9 <= arg_57_2 and var_57_10 >= arg_57_2 + arg_57_1 then
						var_57_11 = 1
						var_57_12 = arg_57_1
					else
						var_57_11 = var_0_8.max(1, var_57_9 - arg_57_2)

						if var_57_10 <= arg_57_2 + arg_57_1 then
							var_57_12 = var_57_10 - arg_57_2
						else
							var_57_12 = arg_57_1
						end
					end

					if var_57_11 and var_57_12 then
						if not var_57_2[iter_57_0] then
							var_57_2[iter_57_0] = {}
						end

						local var_57_13 = var_57_2[iter_57_0]

						var_57_13.color = Color(var_57_8[1], var_57_8[2], var_57_8[3], var_57_8[4])
						var_57_13.start_index = var_57_11
						var_57_13.end_index = var_57_12
						var_57_5 = false
					end
				end
			end

			if var_57_5 then
				var_57_2[iter_57_0] = nil
			end
		end
	else
		return nil
	end

	if var_57_2 and #var_57_2 > 0 then
		return var_57_2
	end
end

UIPasses.text = {
	init = function(arg_58_0)
		assert(arg_58_0.text_id, "no text id in pass definition. YOU NEEDS IT.")

		return {
			text_id = arg_58_0.text_id,
			dirty = arg_58_0.retained_mode and true or nil
		}
	end,
	destroy = function(arg_59_0, arg_59_1, arg_59_2)
		assert(arg_59_2.retained_mode, "why u destroy immediate pass?")

		local var_59_0 = arg_59_1.retained_ids

		if var_59_0 then
			for iter_59_0 = 1, #var_59_0 do
				var_0_0.destroy_text(arg_59_0, var_59_0[iter_59_0])
			end

			arg_59_1.retained_ids = nil
		end
	end,
	draw = function(arg_60_0, arg_60_1, arg_60_2, arg_60_3, arg_60_4, arg_60_5, arg_60_6, arg_60_7, arg_60_8, arg_60_9)
		local var_60_0

		if arg_60_3.retained_mode then
			var_60_0 = arg_60_1.retained_ids and arg_60_1.retained_ids or true
		end

		local var_60_1

		if var_60_0 == true then
			var_60_1 = {}
		end

		local var_60_2 = arg_60_5[arg_60_1.text_id]

		if type(var_60_2) ~= "string" then
			var_60_2 = var_0_7.format("%s", var_60_2)
		end

		if arg_60_4.localize then
			var_60_2 = Localize(var_60_2)
		end

		if arg_60_4.upper_case then
			var_60_2 = Utf8.upper(var_60_2)
		end

		local var_60_3 = var_60_2
		local var_60_4 = var_0_27(arg_60_0, arg_60_4, arg_60_5[arg_60_1.text_id], var_60_3)
		local var_60_5 = arg_60_4.font_size

		if arg_60_4.word_wrap and arg_60_4.dynamic_font_size_word_wrap then
			local var_60_6 = arg_60_4._dynamic_wraped_text ~= var_60_4 or arg_60_4._dynamic_wraped_scale ~= RESOLUTION_LOOKUP.scale
			local var_60_7

			if var_60_6 then
				var_60_7 = var_0_0.scaled_font_size_by_area(arg_60_0, var_60_4, arg_60_4.area_size or arg_60_7, arg_60_4)
			else
				var_60_7 = arg_60_4._dynamic_wrap_font_size
			end

			arg_60_4.font_size = var_60_7
			arg_60_4._dynamic_wrap_font_size = var_60_7
			arg_60_4._dynamic_wraped_text = var_60_4
			arg_60_4._dynamic_wraped_scale = RESOLUTION_LOOKUP.scale
		elseif arg_60_4.dynamic_font_size then
			arg_60_4.font_size = var_0_0.scaled_font_size_by_width(arg_60_0, var_60_4, (arg_60_4.area_size and arg_60_4.area_size[1] or arg_60_7[1]) - 1, arg_60_4)
		end

		local var_60_8
		local var_60_9
		local var_60_10

		if arg_60_4.font_type then
			local var_60_11, var_60_12 = UIFontByResolution(arg_60_4)

			var_60_8, var_60_9, var_60_10 = var_60_11[1], var_60_12, arg_60_4.font_type
		end

		if arg_60_4.word_wrap then
			local var_60_13 = UTF8Utils.string_length(var_60_4)
			local var_60_14, var_60_15, var_60_16 = var_0_4(arg_60_0.gui, var_60_10, var_60_9)
			local var_60_17 = var_0_0.word_wrap(arg_60_0, var_60_4, var_60_8, var_60_9, arg_60_4.area_size and arg_60_4.area_size[1] or arg_60_7[1])
			local var_60_18 = arg_60_5.text_start_index or 1
			local var_60_19 = arg_60_5.max_texts or #var_60_17
			local var_60_20 = var_0_8.min(#var_60_17 - (var_60_18 - 1), var_60_19)
			local var_60_21 = RESOLUTION_LOOKUP.inv_scale
			local var_60_22 = (var_60_16 - var_60_15) * var_60_21 * (arg_60_4.font_height_multiplier or 1)
			local var_60_23 = Vector3(0, arg_60_4.grow_downward and var_60_22 or -var_60_22, 0)

			if arg_60_4.dynamic_height then
				arg_60_7[2] = var_60_20 * var_60_22
				arg_60_6.y = arg_60_6.y - arg_60_7[2]
			end

			if arg_60_4.vertical_alignment == "top" then
				arg_60_6 = arg_60_6 + Vector3(0, arg_60_7[2] - var_60_16 * var_60_21, 0)
			elseif arg_60_4.vertical_alignment == "center" then
				arg_60_6[2] = arg_60_6[2] + (arg_60_7[2] - var_60_22 * 0.5) / 2 + var_0_8.max(var_60_20 - 1, 0) * 0.5 * var_60_22
			else
				arg_60_6 = arg_60_6 + Vector3(0, (var_60_20 - 1) * var_60_22 + var_0_8.abs(var_60_15) * var_60_21, 0)
			end

			local var_60_24 = arg_60_4.horizontal_alignment or "left"
			local var_60_25 = 0
			local var_60_26 = 0

			if var_60_24 == "center" then
				var_60_26 = 0.5
			elseif var_60_24 == "right" then
				var_60_26 = 1
			end

			local var_60_27 = 0
			local var_60_28 = Vector3(0, 0, 0)

			for iter_60_0 = 1, var_60_20 do
				var_60_4 = var_60_17[iter_60_0 - 1 + var_60_18]

				local var_60_29 = var_60_4 and UTF8Utils.string_length(var_60_4) or 0
				local var_60_30

				if var_60_24 ~= "left" then
					var_60_30 = var_0_0.text_size(arg_60_0, var_60_4, var_60_8, var_60_9, arg_60_7[2])
					var_60_28.x = (arg_60_7[1] - var_60_30) * var_60_26
				end

				if arg_60_4.draw_text_rect then
					var_60_30 = var_60_30 or var_0_0.text_size(arg_60_0, var_60_4, var_60_8, var_60_9, arg_60_7[2])
					var_60_27 = var_60_27 < var_60_30 and var_60_30 or var_60_27
				end

				local var_60_31 = arg_60_4.text_color

				if arg_60_4.line_colors and arg_60_4.line_colors[iter_60_0] then
					var_60_31 = arg_60_4.line_colors[iter_60_0]
				end

				if arg_60_4.inject_alpha then
					var_60_4 = var_0_7.format(var_60_4, var_60_31[1])
				end

				local var_60_32 = arg_60_4.line_color_override

				if arg_60_4.color_override then
					var_60_32 = var_0_30(iter_60_0, var_60_29, var_60_25, var_60_13, arg_60_4)
				end

				var_60_4 = var_0_29(arg_60_0, var_60_4, var_60_8, var_60_9, var_60_10, arg_60_6 + var_60_28, arg_60_4)

				local var_60_33 = var_60_0 and (var_60_1 and true or var_60_0[iter_60_0])
				local var_60_34 = var_0_0.draw_text(arg_60_0, var_60_4, var_60_8, var_60_9, var_60_10, arg_60_6 + var_60_28, var_60_31, var_60_33, var_60_32)

				if var_60_1 then
					var_60_1[iter_60_0] = var_60_34
				end

				arg_60_6 = arg_60_6 + var_60_23
				var_60_25 = var_60_25 + var_60_29 + 1
			end

			if arg_60_4.draw_text_rect then
				local var_60_35 = 4
				local var_60_36 = 4
				local var_60_37 = (arg_60_7[1] - var_60_27) * var_60_26
				local var_60_38 = arg_60_6 - Vector3(var_60_35 - var_60_37, var_60_36 * 2 + var_60_23[2], 1)
				local var_60_39 = Vector2(var_60_27 + var_60_35 * 2, var_60_20 * -var_60_23[2])

				if arg_60_4.masked then
					var_0_1(arg_60_0, "rect_masked", var_60_38, var_60_39, arg_60_4.rect_color, arg_60_4.masked, arg_60_4 and arg_60_4.saturated)
				else
					var_0_0.draw_rounded_rect(arg_60_0, var_60_38, var_60_39, 5, arg_60_4.rect_color)

					if arg_60_4.draw_rect_border then
						var_0_0.draw_rounded_rect(arg_60_0, var_60_38 + Vector3(-1, -1, -1), var_60_39 + Vector2(2, 2), 5, arg_60_4.text_color)
					end
				end
			end
		elseif arg_60_4.horizontal_scroll then
			local var_60_40 = arg_60_5.text_index
			local var_60_41 = UTF8Utils.string_length(var_60_4)
			local var_60_42 = arg_60_5.end_index or var_60_41
			local var_60_43 = arg_60_4.replacing_character

			if var_60_43 then
				var_60_4 = var_0_7.rep(var_60_43, var_60_42)
			end

			local var_60_44
			local var_60_45

			if arg_60_5.jump_to_end or var_60_41 < arg_60_5.caret_index then
				var_60_42 = UTF8Utils.string_length(var_60_4)
				var_60_40 = var_60_42
				arg_60_5.jump_to_end = nil

				local var_60_46 = 0
				local var_60_47 = true

				while var_60_46 < arg_60_7[1] do
					var_60_40 = var_0_8.max(var_60_40 - 1, 1)
					var_60_44 = UTF8Utils.sub_string(var_60_4, var_60_40, var_60_42)
					var_60_46 = var_0_0.text_size(arg_60_0, var_60_44, var_60_8, var_60_9, var_60_10)

					if var_60_40 == 1 then
						var_60_47 = false

						break
					end
				end

				if var_60_47 then
					var_60_40 = var_60_40 + 1
					var_60_44 = UTF8Utils.sub_string(var_60_4, var_60_40, var_60_42)
				end

				arg_60_5.text_index = var_60_40
				arg_60_5.end_index = nil
			else
				var_60_44 = UTF8Utils.sub_string(var_60_4, var_60_40, var_60_42)
			end

			local var_60_48 = arg_60_5.caret_index

			if var_60_48 > var_60_42 + 1 then
				arg_60_5.text_index = arg_60_5.text_index + 1
				arg_60_5.end_index = var_60_42 + 1
			elseif var_60_48 < var_60_40 then
				arg_60_5.text_index = arg_60_5.text_index - 1
				arg_60_5.end_index = var_60_42 - 1
			end

			local var_60_49 = arg_60_4.caret_size

			if var_60_49 then
				local var_60_50 = arg_60_4.caret_offset
				local var_60_51 = UTF8Utils.sub_string(var_60_44, 1, arg_60_5.caret_index - arg_60_5.text_index)
				local var_60_52 = var_0_0.text_size(arg_60_0, var_60_51, var_60_8, var_60_9, var_60_10)
				local var_60_53 = arg_60_6 + Vector3(var_60_52 + var_60_50[1], var_60_50[2], var_60_50[3])
				local var_60_54 = var_60_0 and (var_60_1 and true or var_60_0[1])
				local var_60_55 = var_0_0.draw_text(arg_60_0, var_60_51, var_60_8, var_60_9, var_60_10, arg_60_6, arg_60_4.text_color, var_60_54, arg_60_4.color_override)

				if var_60_1 then
					var_60_1[1] = var_60_55
				end

				if arg_60_4.masked then
					var_0_1(arg_60_0, "rect_masked", var_60_53, var_60_49, arg_60_4.caret_color, arg_60_4 and arg_60_4.masked, arg_60_4 and arg_60_4.saturated)
				else
					var_0_0.draw_rect(arg_60_0, var_60_53, var_60_49, arg_60_4.caret_color)
				end

				local var_60_56 = var_0_7.sub(var_60_44, #var_60_51 + 1, #var_60_44 + 1)

				arg_60_6[1] = arg_60_6[1] + var_60_52

				var_0_0.draw_text(arg_60_0, var_60_56, var_60_8, var_60_9, var_60_10, arg_60_6, arg_60_4.text_color, var_60_55, arg_60_4.color_override)
			else
				local var_60_57 = var_60_0 and (var_60_1 and true or var_60_0[1])
				local var_60_58 = var_0_0.draw_text(arg_60_0, var_60_44, var_60_8, var_60_9, var_60_10, arg_60_6, arg_60_4.text_color, var_60_57, arg_60_4.color_override)

				if var_60_1 then
					var_60_1[1] = var_60_58
				end
			end
		else
			local var_60_59, var_60_60, var_60_61 = var_0_4(arg_60_0.gui, var_60_10, var_60_9)
			local var_60_62, var_60_63, var_60_64 = var_0_0.text_size(arg_60_0, var_60_4, var_60_8, var_60_9, var_60_10)
			local var_60_65 = arg_60_6 + var_0_12(var_60_62, var_60_59, var_60_60, var_60_61, arg_60_7, var_60_64, arg_60_4)
			local var_60_66 = var_0_29(arg_60_0, var_60_4, var_60_8, var_60_9, var_60_10, var_60_65, arg_60_4)
			local var_60_67 = var_60_0 and (var_60_1 and true or var_60_0[1])
			local var_60_68 = var_0_0.draw_text(arg_60_0, var_60_66, var_60_8, var_60_9, var_60_10, var_60_65, arg_60_4.text_color, var_60_67, arg_60_4.color_override)

			if var_60_1 then
				var_60_1[1] = var_60_68
			end
		end

		if arg_60_3.retained_mode then
			arg_60_1.retained_ids = var_60_1 or arg_60_1.retained_ids
			arg_60_1.dirty = false
		end

		arg_60_4.font_size = var_60_5
	end,
	get_preferred_size = function(arg_61_0, arg_61_1, arg_61_2, arg_61_3, arg_61_4, arg_61_5, arg_61_6, arg_61_7, arg_61_8)
		local var_61_0 = arg_61_5[arg_61_1.text_id]
		local var_61_1, var_61_2 = UIFontByResolution(arg_61_4)
		local var_61_3 = arg_61_4.font_type
		local var_61_4 = var_61_1[1]

		if arg_61_4.localize then
			var_61_0 = Localize(var_61_0)
		end

		if arg_61_4.upper_case then
			var_61_0 = Utf8.upper(var_61_0)
		end

		local var_61_5
		local var_61_6

		if arg_61_4.word_wrap then
			local var_61_7, var_61_8, var_61_9 = var_0_4(arg_61_0.gui, var_61_3, var_61_2)
			local var_61_10 = var_0_0.word_wrap(arg_61_0, var_61_0, var_61_4, var_61_2, arg_61_4.size[1])
			local var_61_11 = 1
			local var_61_12 = #var_61_10
			local var_61_13 = var_0_8.min(#var_61_10 - (var_61_11 - 1), var_61_12)
			local var_61_14 = RESOLUTION_LOOKUP.inv_scale

			var_61_6 = (var_61_9 + var_0_8.abs(var_61_8)) * var_61_14 * var_61_13
			var_61_5 = arg_61_4.size[1]
		else
			var_61_5, var_61_6 = var_0_0.text_size(arg_61_0, var_61_0, var_61_1[1], var_61_2)
		end

		return var_61_5, var_61_6
	end
}

local function var_0_31(arg_62_0, arg_62_1, arg_62_2, arg_62_3, arg_62_4, arg_62_5, arg_62_6, arg_62_7)
	local var_62_0 = arg_62_1.width
	local var_62_1 = arg_62_1.texts
	local var_62_2 = #var_62_1 / 3
	local var_62_3 = arg_62_0

	for iter_62_0 = 1, var_62_2 do
		local var_62_4 = var_62_1[iter_62_0 * 3 - 2]
		local var_62_5 = var_62_1[iter_62_0 * 3 - 1]
		local var_62_6 = arg_62_3 + var_62_1[iter_62_0 * 3]:unbox()

		if var_62_5 then
			var_62_3 = var_0_0.draw_justified_text(arg_62_2, var_62_4, arg_62_4, arg_62_5, arg_62_6, var_62_6, arg_62_7, var_62_3, var_62_0)
		else
			var_62_3 = var_0_0.draw_text(arg_62_2, var_62_4, arg_62_4, arg_62_5, arg_62_6, var_62_6, arg_62_7)
		end
	end

	return var_62_3
end

UIPasses.lorebook_multiple_texts = {
	init = function(arg_63_0)
		assert(arg_63_0.text_id, "no text id in pass definition. YOU NEEDS IT.")

		return {
			text_id = arg_63_0.text_id,
			dirty = arg_63_0.retained_mode and true or nil
		}
	end,
	destroy = function(arg_64_0, arg_64_1, arg_64_2)
		assert(arg_64_2.retained_mode, "why u destroy immediate pass?")

		if arg_64_1.retained_id then
			var_0_0.destroy_text(arg_64_0, arg_64_1.retained_id)

			arg_64_1.retained_id = nil
		end
	end,
	draw = function(arg_65_0, arg_65_1, arg_65_2, arg_65_3, arg_65_4, arg_65_5, arg_65_6, arg_65_7, arg_65_8, arg_65_9)
		local var_65_0

		if arg_65_3.retained_mode then
			var_65_0 = arg_65_1.retained_id and arg_65_1.retained_id or true
		end

		local var_65_1
		local var_65_2
		local var_65_3

		if arg_65_4.font_type then
			local var_65_4, var_65_5 = UIFontByResolution(arg_65_4)

			var_65_1, var_65_2, var_65_3 = var_65_4[1], var_65_5, var_65_4[3]
		else
			local var_65_6 = arg_65_4.font

			var_65_1, var_65_2, var_65_3 = var_65_6[1], var_65_6[2], var_65_6[3]
			var_65_2 = arg_65_4.font_size or var_65_2
		end

		local var_65_7 = arg_65_4.text_color
		local var_65_8 = arg_65_5.page
		local var_65_9 = var_65_8.top

		arg_65_6.y = arg_65_6.y + arg_65_7[2]

		local var_65_10 = var_0_31(var_65_0, var_65_9, arg_65_0, arg_65_6, var_65_1, var_65_2, var_65_3, var_65_7)
		local var_65_11 = var_65_8.center
		local var_65_12 = var_0_31(var_65_10, var_65_11, arg_65_0, arg_65_6, var_65_1, var_65_2, var_65_3, var_65_7)
		local var_65_13 = var_65_8.bottom
		local var_65_14 = var_0_31(var_65_12, var_65_13, arg_65_0, arg_65_6, var_65_1, var_65_2, var_65_3, var_65_7)

		if arg_65_3.retained_mode then
			arg_65_1.retained_id = var_65_14 or arg_65_1.retained_id
			arg_65_1.dirty = false
		end
	end
}
UIPasses.lorebook_paragraph_divider = {
	init = function(arg_66_0)
		if arg_66_0.retained_mode then
			return {
				dirty = true
			}
		end
	end,
	destroy = function(arg_67_0, arg_67_1, arg_67_2)
		assert(arg_67_2.retained_mode, "why u destroy immediate pass?")

		if arg_67_1.retained_id then
			var_0_0.destroy_bitmap(arg_67_0, arg_67_1.retained_id)

			arg_67_1.retained_id = nil
		end
	end,
	draw = function(arg_68_0, arg_68_1, arg_68_2, arg_68_3, arg_68_4, arg_68_5, arg_68_6, arg_68_7, arg_68_8, arg_68_9)
		local var_68_0 = arg_68_5.positions
		local var_68_1 = #var_68_0
		local var_68_2 = arg_68_3.texture_id or "texture_id"
		local var_68_3 = arg_68_6[2]

		if arg_68_3.retained_mode then
			for iter_68_0 = 1, var_68_1 do
				arg_68_6[2] = var_68_3 + var_68_0[iter_68_0]

				local var_68_4 = arg_68_5[var_68_2][iter_68_0]
				local var_68_5 = arg_68_3.retained_mode and (arg_68_1.retained_id and arg_68_1.retained_id or true)
				local var_68_6 = var_0_1(arg_68_0, var_68_4, arg_68_6, arg_68_7, arg_68_4 and arg_68_4.color, arg_68_4 and arg_68_4.masked, arg_68_4 and arg_68_4.saturated, var_68_5)

				arg_68_1.retained_id = var_68_6 and var_68_6 or arg_68_1.retained_id
				arg_68_1.dirty = false
			end
		else
			for iter_68_1 = 1, var_68_1 do
				arg_68_6[2] = var_68_3 + var_68_0[iter_68_1]

				local var_68_7 = arg_68_5[var_68_2][iter_68_1]

				var_0_1(arg_68_0, var_68_7, arg_68_6, arg_68_7, arg_68_4 and arg_68_4.color, arg_68_4 and arg_68_4.masked, arg_68_4 and arg_68_4.saturated)
			end
		end
	end
}
UIPasses.multiple_texts = {
	init = function(arg_69_0)
		assert(arg_69_0.texts_id, "no text id in pass definition. YOU NEEDS IT.")

		return {
			texts_id = arg_69_0.texts_id
		}
	end,
	draw = function(arg_70_0, arg_70_1, arg_70_2, arg_70_3, arg_70_4, arg_70_5, arg_70_6, arg_70_7, arg_70_8, arg_70_9)
		local var_70_0, var_70_1 = UIFontByResolution(arg_70_4)
		local var_70_2 = var_70_0[1]
		local var_70_3 = var_70_1
		local var_70_4 = var_70_0[3]
		local var_70_5 = arg_70_5[arg_70_1.texts_id] and arg_70_5[arg_70_1.texts_id].texts or arg_70_5.texts
		local var_70_6 = arg_70_4.axis or 2
		local var_70_7 = (arg_70_4.direction or 1) == 2

		for iter_70_0 = 1, #var_70_5 do
			local var_70_8 = var_70_5[iter_70_0]

			if arg_70_4.localize then
				var_70_8 = Localize(var_70_8)
			end

			local var_70_9, var_70_10 = var_0_0.text_size(arg_70_0, var_70_8, var_70_2, var_70_3)
			local var_70_11 = Vector3(0, 0, 0)

			if var_70_6 == 2 then
				if arg_70_4.horizontal_alignment == "center" then
					var_70_11[1] = arg_70_7[1] * 0.5 - var_70_9 * 0.5
				elseif arg_70_4.horizontal_alignment == "right" then
					var_70_11[1] = arg_70_7[1] - var_70_9
				end

				if arg_70_4.vertical_alignment == "center" then
					var_70_11[2] = arg_70_7[2] * 0.5 - var_70_10 * 0.5
				elseif arg_70_4.vertical_alignment == "top" then
					var_70_11[2] = arg_70_7[2] - var_70_10
				end
			else
				if iter_70_0 == 1 and var_70_7 then
					arg_70_6[var_70_6] = arg_70_6[var_70_6] - arg_70_7[var_70_6]
				end

				if arg_70_4.horizontal_alignment == "center" then
					var_70_11[1] = arg_70_7[1] * 0.5 - var_70_9 * 0.5
				elseif arg_70_4.horizontal_alignment == "right" then
					var_70_11[1] = arg_70_7[1] - var_70_9
				end

				if arg_70_4.vertical_alignment == "center" then
					var_70_11[2] = arg_70_7[2] * 0.5 - var_70_10 * 0.5
				elseif arg_70_4.vertical_alignment == "top" then
					var_70_11[2] = arg_70_7[2] - var_70_10
				end
			end

			var_0_0.draw_text(arg_70_0, var_70_8, var_70_2, var_70_3, var_70_4, arg_70_6 + var_70_11, arg_70_4.text_color)

			if var_70_6 == 2 then
				if var_70_7 then
					arg_70_6[2] = arg_70_6[2] + arg_70_7[2] + arg_70_4.spacing
				else
					arg_70_6[2] = arg_70_6[2] - arg_70_7[2] - arg_70_4.spacing
				end
			elseif var_70_7 then
				arg_70_6[1] = arg_70_6[1] - arg_70_7[1] - arg_70_4.spacing
			else
				arg_70_6[1] = arg_70_6[1] + arg_70_7[1] + arg_70_4.spacing
			end
		end
	end
}
UIPasses.viewport = {
	init = function(arg_71_0, arg_71_1, arg_71_2)
		local var_71_0 = arg_71_2[arg_71_0.style_id]
		local var_71_1 = var_71_0.world_flags or {
			Application.DISABLE_SOUND,
			Application.DISABLE_ESRAM
		}
		local var_71_2 = var_71_0.shading_environment
		local var_71_3 = Managers.world:create_world(var_71_0.world_name, var_71_2, nil, var_71_0.layer, unpack(var_71_1))
		local var_71_4 = var_71_0.viewport_type or "default"
		local var_71_5 = ScriptWorld.create_viewport(var_71_3, var_71_0.viewport_name, var_71_4, var_71_0.layer)
		local var_71_6 = var_71_0.level_name
		local var_71_7 = var_71_0.object_sets
		local var_71_8

		if var_71_6 then
			local var_71_9
			local var_71_10
			local var_71_11
			local var_71_12 = var_71_0.mood_setting
			local var_71_13 = false

			var_71_8 = ScriptWorld.spawn_level(var_71_3, var_71_6, var_71_7, var_71_9, var_71_10, var_71_11, var_71_12, var_71_13)

			Level.spawn_background(var_71_8)
		end

		local var_71_14 = true

		ScriptWorld.deactivate_viewport(var_71_3, var_71_5)

		local var_71_15 = Vector3Aux.unbox(var_71_0.camera_position)
		local var_71_16 = Vector3Aux.unbox(var_71_0.camera_lookat)
		local var_71_17 = Vector3.normalize(var_71_16 - var_71_15)
		local var_71_18 = ScriptViewport.camera(var_71_5)

		ScriptCamera.set_local_position(var_71_18, var_71_15)
		ScriptCamera.set_local_rotation(var_71_18, Quaternion.look(var_71_17))

		local var_71_19 = var_71_0.fov or 65

		Camera.set_vertical_fov(var_71_18, var_0_8.pi * var_71_19 / 180)

		local var_71_20

		if var_71_0.enable_sub_gui then
			var_71_20 = var_0_0.create(var_71_3, "material", "materials/ui/ui_1080p_hud_atlas_textures", "material", "materials/ui/ui_1080p_hud_single_textures", "material", "materials/ui/ui_1080p_menu_atlas_textures", "material", "materials/ui/ui_1080p_menu_single_textures", "material", "materials/ui/ui_1080p_common", "material", "materials/ui/ui_1080p_versus_available_common", "material", "materials/fonts/gw_fonts")
		end

		return {
			deactivated = var_71_14,
			world = var_71_3,
			world_name = var_71_0.world_name,
			level = var_71_8,
			viewport = var_71_5,
			viewport_name = var_71_0.viewport_name,
			ui_renderer = var_71_20,
			camera = var_71_18
		}
	end,
	destroy = function(arg_72_0, arg_72_1, arg_72_2)
		if arg_72_1.ui_renderer then
			var_0_0.destroy(arg_72_1.ui_renderer, arg_72_1.world)

			arg_72_1.ui_renderer = nil
		end

		ScriptWorld.destroy_viewport(arg_72_1.world, arg_72_1.viewport_name)
		Managers.world:destroy_world(arg_72_1.world)
	end,
	draw = function(arg_73_0, arg_73_1, arg_73_2, arg_73_3, arg_73_4, arg_73_5, arg_73_6, arg_73_7, arg_73_8, arg_73_9)
		local var_73_0 = arg_73_4.viewport_size

		if var_73_0 then
			if arg_73_4.horizontal_alignment == "right" then
				arg_73_6[1] = arg_73_6[1] + arg_73_7[1] - var_73_0[1]
			elseif arg_73_4.horizontal_alignment == "center" then
				arg_73_6[1] = arg_73_6[1] + (arg_73_7[1] - var_73_0[1]) / 2
			end

			if arg_73_4.vertical_alignment == "center" then
				arg_73_6[2] = arg_73_6[2] + (arg_73_7[2] - var_73_0[2]) / 2
			elseif arg_73_4.vertical_alignment == "top" then
				arg_73_6[2] = arg_73_6[2] + arg_73_7[2] - var_73_0[2]
			end

			arg_73_7 = var_73_0
		end

		local var_73_1 = var_0_5(arg_73_6)
		local var_73_2 = var_0_5(arg_73_7)
		local var_73_3 = RESOLUTION_LOOKUP.res_w
		local var_73_4 = RESOLUTION_LOOKUP.res_h
		local var_73_5 = Vector3.zero()

		var_73_5.x = var_0_8.clamp(var_73_2.x / var_73_3, 0, 1)
		var_73_5.y = var_0_8.clamp(var_73_2.y / var_73_4, 0, 1)

		local var_73_6 = Vector3.zero()

		var_73_6.x = var_0_8.clamp(var_73_1.x / var_73_3, 0, 1)
		var_73_6.y = var_0_8.clamp(1 - var_73_1.y / var_73_4 - var_73_5.y, 0, 1)

		local var_73_7 = arg_73_1.viewport
		local var_73_8 = arg_73_1.world

		if var_73_3 < var_73_1.x or var_73_1.x < 0 then
			if not arg_73_1.deactivated then
				ScriptWorld.deactivate_viewport(var_73_8, var_73_7)
			end

			arg_73_1.deactivated = true
		elseif arg_73_1.deactivated then
			ScriptWorld.activate_viewport(var_73_8, var_73_7)

			arg_73_1.deactivated = false
		end

		local var_73_9 = false

		if Managers.splitscreen then
			var_73_9 = Managers.splitscreen:active()
		end

		local var_73_10 = var_73_9 and 0.5 or 1

		Viewport.set_rect(var_73_7, var_73_6.x * var_73_10, var_73_6.y * var_73_10, var_73_5.x * var_73_10, var_73_5.y * var_73_10)

		arg_73_5.viewport_size_x = var_73_5.x
		arg_73_5.viewport_size_y = var_73_5.y
		arg_73_1.viewport_rect_pos_x = var_73_6.x
		arg_73_1.viewport_rect_pos_y = var_73_6.y
		arg_73_1.viewport_rect_size_x = var_73_2.x
		arg_73_1.viewport_rect_size_y = var_73_2.y
		arg_73_1.size_scale_x = var_73_5.x
		arg_73_1.size_scale_y = var_73_5.y
	end,
	raycast_at_screen_position = function(arg_74_0, arg_74_1, arg_74_2, arg_74_3, arg_74_4)
		if arg_74_0.viewport_rect_pos_x == nil then
			return nil
		end

		local var_74_0 = RESOLUTION_LOOKUP.res_w
		local var_74_1 = RESOLUTION_LOOKUP.res_h
		local var_74_2 = Vector3.zero()
		local var_74_3 = var_74_0 / var_74_1
		local var_74_4 = 1.7777777777777777

		if var_74_3 < var_74_4 then
			local var_74_5 = arg_74_1.x / var_74_0
			local var_74_6 = var_74_1 / 9 * 16

			var_74_2.x = var_74_0 * 0.5 - var_74_6 * 0.5 + var_74_6 * var_74_5

			local var_74_7 = arg_74_1.y / var_74_1
			local var_74_8 = arg_74_0.size_scale_x * var_74_1

			var_74_2.y = var_74_1 * 0.5 - var_74_8 * 0.5 + var_74_8 * var_74_7
		elseif var_74_4 < var_74_3 then
			local var_74_9 = arg_74_1.x / var_74_0
			local var_74_10 = arg_74_0.size_scale_y * var_74_0

			var_74_2.x = var_74_0 * 0.5 - var_74_10 * 0.5 + var_74_10 * var_74_9
			var_74_2.y = arg_74_1.y
		else
			var_74_2.x = arg_74_1.x
			var_74_2.y = arg_74_1.y
		end

		local var_74_11 = Camera.screen_to_world(arg_74_0.camera, var_74_2, 0)
		local var_74_12 = Camera.screen_to_world(arg_74_0.camera, var_74_2 + Vector3(0, 0, 0), 1) - var_74_11
		local var_74_13 = Vector3.normalize(var_74_12)
		local var_74_14 = World.get_data(arg_74_0.world, "physics_world")

		return PhysicsWorld.immediate_raycast(var_74_14, var_74_11, var_74_13, arg_74_3, arg_74_2, "collision_filter", arg_74_4)
	end
}
script_data.ui_debug_hover = script_data.ui_debug_hover or Development.parameter("ui_debug_hover")
script_data.ui_debug_drag = script_data.ui_debug_drag or Development.parameter("ui_debug_drag")

local var_0_32 = {
	0,
	0,
	0
}
local var_0_33 = UISettings.start_drag_threshold

UIPasses.is_dragging_item = false
UIPasses.drag = {
	init = function(arg_75_0, arg_75_1, arg_75_2)
		return nil
	end,
	draw = function(arg_76_0, arg_76_1, arg_76_2, arg_76_3, arg_76_4, arg_76_5, arg_76_6, arg_76_7, arg_76_8, arg_76_9)
		if arg_76_5.ui_top_renderer then
			arg_76_0 = arg_76_5.ui_top_renderer
		end

		if arg_76_5.on_drag_stopped then
			arg_76_5.on_drag_stopped = nil
			UIPasses.is_dragging_item = false
		end

		if arg_76_5.on_drag_started then
			arg_76_5.on_drag_started = nil
		end

		if arg_76_5.drag_disabled then
			return
		end

		if not arg_76_5[arg_76_3.texture_id] then
			return
		end

		local var_76_0 = arg_76_8:get("cursor") or var_0_9
		local var_76_1 = var_0_3(var_76_0)
		local var_76_2 = arg_76_5.on_drag_started
		local var_76_3 = arg_76_5.is_dragging

		if not var_76_3 then
			if arg_76_8:get("left_press") and var_0_8.point_is_inside_2d_box(var_76_1, arg_76_6, arg_76_7) then
				arg_76_5.hover_start_timer = 0
			elseif arg_76_5.hover_start_timer then
				if arg_76_8:get("left_hold") then
					arg_76_5.hover_start_timer = arg_76_5.hover_start_timer + arg_76_9
				else
					arg_76_5.hover_start_timer = nil
				end
			end
		end

		local var_76_4 = arg_76_5.hover_start_timer

		if var_76_4 and var_76_4 >= var_0_33 then
			arg_76_5.hover_start_timer = nil
			arg_76_5.on_drag_started = true
			arg_76_5.is_dragging = true
			UIPasses.is_dragging_item = true
		elseif var_76_3 and arg_76_8:get("left_hold") then
			if var_76_2 then
				arg_76_5.on_drag_started = nil
			end

			local var_76_5 = arg_76_5.drag_texture_size

			assert(var_76_5, "Missing texture_size")

			var_0_32[1] = var_76_1.x - var_76_5[1] * 0.5
			var_0_32[2] = var_76_1.y - var_76_5[2] * 0.5
			var_0_32[3] = 999

			var_0_1(arg_76_0, arg_76_5[arg_76_3.texture_id], var_0_32, var_76_5, nil, nil, false)
		elseif var_76_3 and arg_76_8:get("left_release") then
			arg_76_5.is_dragging = nil
			arg_76_5.on_drag_stopped = true
		end

		if script_data.ui_debug_drag then
			var_0_0.draw_rect(arg_76_0, arg_76_6 + Vector3(0, 0, 1), arg_76_7, arg_76_5.is_dragging and {
				128,
				0,
				100,
				100
			} or {
				0,
				0,
				0,
				255
			})
		end
	end
}

local var_0_34 = {
	0,
	0,
	0
}

UIPasses.gamepad_cursor = {
	init = function(arg_77_0, arg_77_1, arg_77_2)
		return nil
	end,
	draw = function(arg_78_0, arg_78_1, arg_78_2, arg_78_3, arg_78_4, arg_78_5, arg_78_6, arg_78_7, arg_78_8, arg_78_9)
		if not Managers.input:gamepad_cursor_active() then
			return
		end

		if arg_78_5.ui_top_renderer then
			arg_78_0 = arg_78_5.ui_top_renderer
		end

		local var_78_0 = arg_78_8:get("cursor") or var_0_9
		local var_78_1 = arg_78_4.offset or {
			0,
			0
		}

		var_0_34[1] = (var_78_0.x or 0) + var_78_1[1]
		var_0_34[2] = (var_78_0.y or 0) + var_78_1[2]
		var_0_34[3] = 1000

		if Managers.input:is_device_active("gamepad") then
			var_0_1(arg_78_0, arg_78_5[arg_78_3.texture_id], var_0_34, arg_78_4.size, nil, nil, false)
		end

		if script_data.ui_debug_hover then
			local var_78_2 = Vector2(GAMEPAD_CURSOR_SIZE * 0.5, GAMEPAD_CURSOR_SIZE * 0.5)
			local var_78_3 = Vector3(var_0_34[1], var_0_34[2], var_0_34[3]) + var_78_2 * 0.5

			var_0_0.draw_rect(arg_78_0, {
				var_78_3[1],
				var_78_3[2],
				var_78_3[3]
			}, {
				var_78_2[1],
				var_78_2[2]
			}, {
				128,
				255,
				255,
				255
			})
		end

		if script_data.ui_debug_drag then
			var_0_0.draw_rect(arg_78_0, arg_78_6 + Vector3(0, 0, 1), arg_78_7, arg_78_5.is_dragging and {
				128,
				0,
				100,
				100
			} or {
				0,
				0,
				0,
				255
			})
		end
	end
}
UIPasses.hover = {
	init = function(arg_79_0)
		return nil
	end,
	draw = function(arg_80_0, arg_80_1, arg_80_2, arg_80_3, arg_80_4, arg_80_5, arg_80_6, arg_80_7, arg_80_8, arg_80_9)
		local var_80_0 = arg_80_5.is_hover
		local var_80_1
		local var_80_2 = arg_80_8 and arg_80_8:has("cursor") and arg_80_8:get("cursor") or var_0_9

		if arg_80_5.hover_type == "circle" then
			local var_80_3 = arg_80_0:get_scaling() * arg_80_7 / 2
			local var_80_4 = Vector3Aux.flat(var_0_6(arg_80_6)) + var_80_3

			var_80_1 = Vector3.distance_squared(Vector3Aux.unbox(var_80_2), var_80_4) <= var_80_3.x * var_80_3.y or false
		else
			if arg_80_4 then
				local var_80_5 = arg_80_4.area_size

				if var_80_5 then
					UIUtils.align_box_inplace(arg_80_4, arg_80_6, arg_80_7, var_80_5)

					arg_80_7 = var_80_5
				end
			end

			local var_80_6 = Managers.input:is_device_active("gamepad")
			local var_80_7 = var_80_2

			if not var_80_6 then
				var_80_7 = var_0_3(var_80_2)
			end

			var_80_1 = var_0_8.point_is_inside_2d_box(var_80_7, arg_80_6, arg_80_7)

			if script_data.ui_debug_hover then
				var_0_0.draw_rect(arg_80_0, arg_80_6 + Vector3(0, 0, 1), arg_80_7, arg_80_5.is_hover and {
					128,
					0,
					255,
					0
				} or {
					128,
					255,
					0,
					0
				})
			end
		end

		if var_80_1 and not var_80_0 then
			arg_80_5.is_hover = not UIPasses.is_dragging_item
			arg_80_5.internal_is_hover = true
		end

		if var_80_0 and not var_80_1 then
			arg_80_5.is_hover = nil
			arg_80_5.internal_is_hover = nil
		end

		if not var_80_1 and arg_80_5.internal_is_hover then
			arg_80_5.internal_is_hover = nil
		end
	end
}
UIPasses.click = {
	init = function(arg_81_0)
		return nil
	end,
	draw = function(arg_82_0, arg_82_1, arg_82_2, arg_82_3, arg_82_4, arg_82_5, arg_82_6, arg_82_7, arg_82_8, arg_82_9)
		if arg_82_5.is_hover and arg_82_8:get("left_release") then
			arg_82_5.is_clicked = 0
		else
			arg_82_5.is_clicked = (arg_82_5.is_clicked or 10) + arg_82_9
		end
	end
}
UIPasses.generic_tooltip = {
	init = function(arg_83_0, arg_83_1, arg_83_2)
		local var_83_0 = {}

		var_83_0.passes, var_83_0.end_pass = {
			{
				data = UITooltipPasses.generic_text.setup_data(),
				draw = UITooltipPasses.generic_text.draw
			}
		}, {
			data = UITooltipPasses.background.setup_data(),
			draw = UITooltipPasses.background.draw
		}
		var_83_0.size = {
			400,
			0
		}
		var_83_0.alpha_multiplier = 1

		return var_83_0
	end,
	draw = function(arg_84_0, arg_84_1, arg_84_2, arg_84_3, arg_84_4, arg_84_5, arg_84_6, arg_84_7, arg_84_8, arg_84_9)
		local var_84_0 = arg_84_1.size

		var_84_0[2] = 0

		local var_84_1 = false
		local var_84_2 = RESOLUTION_LOOKUP.res_w
		local var_84_3 = RESOLUTION_LOOKUP.res_h

		if arg_84_6[2] + arg_84_7[2] * 0.5 > var_84_3 * 0.5 then
			var_84_1 = true
			arg_84_6[2] = arg_84_6[2] + arg_84_7[2]
		end

		if arg_84_6[1] + arg_84_7[1] * 0.5 > var_84_2 * 0.5 then
			arg_84_6[1] = arg_84_6[1] - var_84_0[1] - 5
		else
			arg_84_6[1] = arg_84_6[1] + arg_84_7[1] + 5
		end

		local var_84_4 = arg_84_6[1]
		local var_84_5 = arg_84_6[2]
		local var_84_6 = arg_84_6[3]
		local var_84_7 = var_84_1 and ipairs or ripairs
		local var_84_8 = arg_84_1.passes
		local var_84_9 = true

		for iter_84_0, iter_84_1 in var_84_7(var_84_8) do
			local var_84_10 = iter_84_1.data
			local var_84_11 = iter_84_1.draw(var_84_10, var_84_9, var_84_1, arg_84_0, arg_84_1, arg_84_2, arg_84_3, arg_84_4, arg_84_5, arg_84_6, var_84_0, arg_84_8, arg_84_9)

			var_84_0[2] = var_84_0[2] + var_84_11

			if var_84_1 then
				arg_84_6[2] = arg_84_6[2] - var_84_11
			else
				arg_84_6[2] = arg_84_6[2] + var_84_11
			end
		end

		arg_84_6[1] = var_84_4
		arg_84_6[2] = var_84_5
		arg_84_6[3] = var_84_6

		local var_84_12 = arg_84_1.end_pass

		if var_84_12 then
			local var_84_13 = var_84_12.data

			var_84_12.draw(var_84_13, var_84_9, var_84_1, arg_84_0, arg_84_1, arg_84_2, arg_84_3, arg_84_4, arg_84_5, arg_84_6, var_84_0, arg_84_8, arg_84_9)
		end
	end
}
UIPasses.additional_option_tooltip = {
	init = function(arg_85_0, arg_85_1, arg_85_2)
		local var_85_0 = {}
		local var_85_1 = arg_85_0.content_passes or {
			"additional_option_info"
		}
		local var_85_2 = {}

		for iter_85_0, iter_85_1 in ipairs(var_85_1) do
			var_85_2[#var_85_2 + 1] = {
				data = UITooltipPasses[iter_85_1].setup_data(),
				draw = UITooltipPasses[iter_85_1].draw
			}
		end

		var_85_0.end_pass = {
			data = UITooltipPasses.background.setup_data(),
			draw = UITooltipPasses.background.draw
		}

		local var_85_3 = arg_85_2 and arg_85_2[arg_85_0.style_id]
		local var_85_4 = var_85_3 and var_85_3.max_width or 400

		var_85_0.passes = var_85_2
		var_85_0.size = {
			var_85_4,
			0
		}
		var_85_0.alpha_multiplier = 1

		return var_85_0
	end,
	update = function(arg_86_0, arg_86_1, arg_86_2, arg_86_3, arg_86_4, arg_86_5, arg_86_6, arg_86_7, arg_86_8)
		if not arg_86_8 then
			arg_86_1.alpha_progress = 0
			arg_86_1.alpha_wait_time = UISettings.tooltip_wait_duration
		end
	end,
	draw = function(arg_87_0, arg_87_1, arg_87_2, arg_87_3, arg_87_4, arg_87_5, arg_87_6, arg_87_7, arg_87_8, arg_87_9)
		local var_87_0 = arg_87_5[arg_87_3.additional_option_id]

		if not var_87_0 then
			return
		end

		if Managers.input:is_device_active("gamepad") then
			Managers.input:set_showing_tooltip(true)
		end

		local var_87_1 = arg_87_1.alpha_wait_time
		local var_87_2 = arg_87_1.alpha_progress

		if var_87_1 then
			local var_87_3 = var_87_1 - arg_87_9

			if var_87_3 <= 0 then
				arg_87_1.alpha_wait_time = nil
			else
				arg_87_1.alpha_wait_time = var_87_3
			end

			arg_87_1.alpha_multiplier = 0
		elseif var_87_2 then
			local var_87_4 = UISettings.tooltip_fade_in_speed
			local var_87_5 = var_0_8.min(var_87_2 + arg_87_9 * var_87_4, 1)

			arg_87_1.alpha_multiplier = var_0_8.easeOutCubic(var_87_5)

			if var_87_5 == 1 then
				arg_87_1.alpha_progress = nil
			else
				arg_87_1.alpha_progress = var_87_5
			end
		end

		local var_87_6 = arg_87_6[1]
		local var_87_7 = arg_87_6[2]
		local var_87_8 = arg_87_6[3]
		local var_87_9 = arg_87_1.size

		var_87_9[2] = 0

		local var_87_10 = true

		if arg_87_4.horizontal_alignment == "center" then
			arg_87_6[1] = arg_87_6[1] + arg_87_7[1] / 2 - var_87_9[1] / 2
		elseif arg_87_4.horizontal_alignment == "right" then
			arg_87_6[1] = arg_87_6[1] + arg_87_7[1] - var_87_9[1]
		else
			arg_87_6[1] = arg_87_6[1] - var_87_9[1]
		end

		local var_87_11 = 0
		local var_87_12 = arg_87_1.passes
		local var_87_13 = false
		local var_87_14 = arg_87_1.end_pass

		if var_87_14 then
			local var_87_15 = var_87_14.data

			var_87_11 = var_87_11 + var_87_14.draw(var_87_15, var_87_13, var_87_10, arg_87_0, arg_87_1, arg_87_2, arg_87_3, arg_87_4, arg_87_5, arg_87_6, var_87_9, arg_87_8, arg_87_9)
		end

		local var_87_16 = var_87_14.data.frame_margin or 0

		for iter_87_0, iter_87_1 in ipairs(var_87_12) do
			local var_87_17 = iter_87_1.data

			var_87_17.frame_margin = var_87_16
			var_87_11 = var_87_11 + iter_87_1.draw(var_87_17, var_87_13, var_87_10, arg_87_0, arg_87_1, arg_87_2, arg_87_3, arg_87_4, arg_87_5, arg_87_6, var_87_9, arg_87_8, arg_87_9, var_87_0)
		end

		if arg_87_4.vertical_alignment == "top" then
			arg_87_6[2] = arg_87_6[2] + arg_87_7[2] + var_87_11
		else
			arg_87_6[2] = arg_87_6[2] + var_87_11
		end

		if arg_87_4.grow_downwards then
			arg_87_6[2] = arg_87_6[2] - var_87_11
		end

		local var_87_18 = arg_87_6[1]
		local var_87_19 = arg_87_6[2]
		local var_87_20 = arg_87_6[3]
		local var_87_21 = true

		for iter_87_2, iter_87_3 in ipairs(var_87_12) do
			local var_87_22 = iter_87_3.data

			var_87_22.frame_margin = var_87_16

			local var_87_23 = iter_87_3.draw(var_87_22, var_87_21, var_87_10, arg_87_0, arg_87_1, arg_87_2, arg_87_3, arg_87_4, arg_87_5, arg_87_6, var_87_9, arg_87_8, arg_87_9, var_87_0)

			var_87_9[2] = var_87_9[2] + var_87_23
			arg_87_6[2] = arg_87_6[2] - var_87_23
		end

		arg_87_6[1] = var_87_18
		arg_87_6[2] = var_87_19
		arg_87_6[3] = var_87_20

		if var_87_14 then
			local var_87_24 = var_87_14.data

			var_87_14.draw(var_87_24, var_87_21, var_87_10, arg_87_0, arg_87_1, arg_87_2, arg_87_3, arg_87_4, arg_87_5, arg_87_6, var_87_9, arg_87_8, arg_87_9)
		end

		arg_87_6[1] = var_87_6
		arg_87_6[2] = var_87_7
		arg_87_6[3] = var_87_8
	end
}
UIPasses.level_tooltip = {
	init = function(arg_88_0, arg_88_1, arg_88_2)
		local var_88_0 = {}

		var_88_0.passes, var_88_0.end_pass = {
			{
				data = UITooltipPasses.level_info.setup_data(),
				draw = UITooltipPasses.level_info.draw
			}
		}, {
			data = UITooltipPasses.background.setup_data(),
			draw = UITooltipPasses.background.draw
		}
		var_88_0.size = {
			300,
			0
		}
		var_88_0.alpha_multiplier = 1

		return var_88_0
	end,
	update = function(arg_89_0, arg_89_1, arg_89_2, arg_89_3, arg_89_4, arg_89_5, arg_89_6, arg_89_7, arg_89_8)
		if not arg_89_8 then
			arg_89_1.alpha_progress = 0
			arg_89_1.alpha_wait_time = UISettings.tooltip_wait_duration
		end
	end,
	draw = function(arg_90_0, arg_90_1, arg_90_2, arg_90_3, arg_90_4, arg_90_5, arg_90_6, arg_90_7, arg_90_8, arg_90_9)
		local var_90_0 = arg_90_5[arg_90_3.level_id]

		if not var_90_0 then
			return
		end

		local var_90_1 = arg_90_1.alpha_wait_time
		local var_90_2 = arg_90_1.alpha_progress

		if var_90_1 then
			local var_90_3 = var_90_1 - arg_90_9

			if var_90_3 <= 0 then
				arg_90_1.alpha_wait_time = nil
			else
				arg_90_1.alpha_wait_time = var_90_3
			end

			arg_90_1.alpha_multiplier = 0
		elseif var_90_2 then
			local var_90_4 = UISettings.tooltip_fade_in_speed
			local var_90_5 = var_0_8.min(var_90_2 + arg_90_9 * var_90_4, 1)

			arg_90_1.alpha_multiplier = var_0_8.easeOutCubic(var_90_5)

			if var_90_5 == 1 then
				arg_90_1.alpha_progress = nil
			else
				arg_90_1.alpha_progress = var_90_5
			end
		end

		local var_90_6 = arg_90_1.size

		var_90_6[2] = 0

		local var_90_7 = true

		arg_90_6[1] = arg_90_6[1] + arg_90_7[1] / 2 - var_90_6[1] / 2

		local var_90_8 = 0
		local var_90_9 = arg_90_1.passes
		local var_90_10 = false
		local var_90_11 = arg_90_1.end_pass

		if var_90_11 then
			local var_90_12 = var_90_11.data

			var_90_8 = var_90_8 + var_90_11.draw(var_90_12, var_90_10, var_90_7, arg_90_0, arg_90_1, arg_90_2, arg_90_3, arg_90_4, arg_90_5, arg_90_6, var_90_6, arg_90_8, arg_90_9)
		end

		local var_90_13 = var_90_11.data.frame_margin or 0

		for iter_90_0, iter_90_1 in ipairs(var_90_9) do
			local var_90_14 = iter_90_1.data

			var_90_14.frame_margin = var_90_13
			var_90_8 = var_90_8 + iter_90_1.draw(var_90_14, var_90_10, var_90_7, arg_90_0, arg_90_1, arg_90_2, arg_90_3, arg_90_4, arg_90_5, arg_90_6, var_90_6, arg_90_8, arg_90_9, var_90_0)
		end

		arg_90_6[2] = arg_90_6[2] + arg_90_7[2] + var_90_8

		local var_90_15 = arg_90_6[1]
		local var_90_16 = arg_90_6[2]
		local var_90_17 = arg_90_6[3]
		local var_90_18 = true

		for iter_90_2, iter_90_3 in ipairs(var_90_9) do
			local var_90_19 = iter_90_3.data

			var_90_19.frame_margin = var_90_13

			local var_90_20 = iter_90_3.draw(var_90_19, var_90_18, var_90_7, arg_90_0, arg_90_1, arg_90_2, arg_90_3, arg_90_4, arg_90_5, arg_90_6, var_90_6, arg_90_8, arg_90_9, var_90_0)

			var_90_6[2] = var_90_6[2] + var_90_20
			arg_90_6[2] = arg_90_6[2] - var_90_20
		end

		arg_90_6[1] = var_90_15
		arg_90_6[2] = var_90_16
		arg_90_6[3] = var_90_17

		if var_90_11 then
			local var_90_21 = var_90_11.data

			var_90_11.draw(var_90_21, var_90_18, var_90_7, arg_90_0, arg_90_1, arg_90_2, arg_90_3, arg_90_4, arg_90_5, arg_90_6, var_90_6, arg_90_8, arg_90_9)
		end
	end
}
UIPasses.hero_power_tooltip = {
	init = function(arg_91_0, arg_91_1, arg_91_2)
		local var_91_0 = {}

		var_91_0.passes, var_91_0.end_pass = {
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
		var_91_0.size = {
			400,
			0
		}
		var_91_0.alpha_multiplier = 1
		var_91_0.player = nil

		return var_91_0
	end,
	update = function(arg_92_0, arg_92_1, arg_92_2, arg_92_3, arg_92_4, arg_92_5, arg_92_6, arg_92_7, arg_92_8)
		if not arg_92_8 then
			arg_92_1.player = nil
			arg_92_1.alpha_progress = 0
			arg_92_1.alpha_wait_time = UISettings.tooltip_wait_duration
		end
	end,
	draw = function(arg_93_0, arg_93_1, arg_93_2, arg_93_3, arg_93_4, arg_93_5, arg_93_6, arg_93_7, arg_93_8, arg_93_9)
		if not arg_93_1.player then
			arg_93_1.player = Managers.player:local_player()
		end

		local var_93_0 = arg_93_1.alpha_wait_time
		local var_93_1 = arg_93_1.alpha_progress

		if var_93_0 then
			local var_93_2 = var_93_0 - arg_93_9

			if var_93_2 <= 0 then
				arg_93_1.alpha_wait_time = nil
			else
				arg_93_1.alpha_wait_time = var_93_2
			end

			arg_93_1.alpha_multiplier = 0
		elseif var_93_1 then
			local var_93_3 = UISettings.tooltip_fade_in_speed
			local var_93_4 = var_0_8.min(var_93_1 + arg_93_9 * var_93_3, 1)

			arg_93_1.alpha_multiplier = var_0_8.easeOutCubic(var_93_4)

			if var_93_4 == 1 then
				arg_93_1.alpha_progress = nil
			else
				arg_93_1.alpha_progress = var_93_4
			end
		end

		local var_93_5 = arg_93_1.size

		var_93_5[2] = 0

		local var_93_6 = true
		local var_93_7 = 0
		local var_93_8 = arg_93_1.passes
		local var_93_9 = false
		local var_93_10 = arg_93_1.end_pass

		if var_93_10 then
			local var_93_11 = var_93_10.data

			var_93_7 = var_93_7 + var_93_10.draw(var_93_11, var_93_9, var_93_6, arg_93_0, arg_93_1, arg_93_2, arg_93_3, arg_93_4, arg_93_5, arg_93_6, var_93_5, arg_93_8, arg_93_9)
		end

		local var_93_12 = var_93_10.data.frame_margin or 0

		arg_93_6[1] = arg_93_6[1] + arg_93_7[1] + var_93_12

		for iter_93_0, iter_93_1 in ipairs(var_93_8) do
			local var_93_13 = iter_93_1.data

			var_93_13.frame_margin = var_93_12
			var_93_7 = var_93_7 + iter_93_1.draw(var_93_13, var_93_9, var_93_6, arg_93_0, arg_93_1, arg_93_2, arg_93_3, arg_93_4, arg_93_5, arg_93_6, var_93_5, arg_93_8, arg_93_9)
		end

		arg_93_6[2] = arg_93_6[2] + var_93_7

		local var_93_14 = arg_93_6[1]
		local var_93_15 = arg_93_6[2]
		local var_93_16 = arg_93_6[3]
		local var_93_17 = true

		for iter_93_2, iter_93_3 in ipairs(var_93_8) do
			local var_93_18 = iter_93_3.data

			var_93_18.frame_margin = var_93_12

			local var_93_19 = iter_93_3.draw(var_93_18, var_93_17, var_93_6, arg_93_0, arg_93_1, arg_93_2, arg_93_3, arg_93_4, arg_93_5, arg_93_6, var_93_5, arg_93_8, arg_93_9)

			var_93_5[2] = var_93_5[2] + var_93_19
			arg_93_6[2] = arg_93_6[2] - var_93_19
		end

		arg_93_6[1] = var_93_14
		arg_93_6[2] = var_93_15
		arg_93_6[3] = var_93_16

		if var_93_10 then
			local var_93_20 = var_93_10.data

			var_93_10.draw(var_93_20, var_93_17, var_93_6, arg_93_0, arg_93_1, arg_93_2, arg_93_3, arg_93_4, arg_93_5, arg_93_6, var_93_5, arg_93_8, arg_93_9)
		end

		arg_93_6[1] = var_93_14
		arg_93_6[2] = var_93_15
		arg_93_6[3] = var_93_16
	end
}
UIPasses.option_tooltip = {
	init = function(arg_94_0, arg_94_1, arg_94_2)
		local var_94_0 = {}

		var_94_0.passes, var_94_0.end_pass = {
			{
				data = UITooltipPasses.generic_text.setup_data(),
				draw = UITooltipPasses.generic_text.draw
			}
		}, {
			data = UITooltipPasses.background.setup_data(),
			draw = UITooltipPasses.background.draw
		}
		var_94_0.size = {
			600,
			0
		}
		var_94_0.alpha_multiplier = 1

		return var_94_0
	end,
	update = function(arg_95_0, arg_95_1, arg_95_2, arg_95_3, arg_95_4, arg_95_5, arg_95_6, arg_95_7, arg_95_8)
		if not arg_95_8 then
			arg_95_1.alpha_progress = 0
			arg_95_1.alpha_wait_time = UISettings.tooltip_wait_duration
		end
	end,
	draw = function(arg_96_0, arg_96_1, arg_96_2, arg_96_3, arg_96_4, arg_96_5, arg_96_6, arg_96_7, arg_96_8, arg_96_9)
		if Managers.input:is_device_active("gamepad") then
			Managers.input:set_showing_tooltip(true)
		end

		local var_96_0 = arg_96_1.alpha_wait_time
		local var_96_1 = arg_96_1.alpha_progress

		if var_96_0 then
			local var_96_2 = var_96_0 - arg_96_9

			if var_96_2 <= 0 then
				arg_96_1.alpha_wait_time = nil
			else
				arg_96_1.alpha_wait_time = var_96_2
			end

			arg_96_1.alpha_multiplier = 0
		elseif var_96_1 then
			local var_96_3 = UISettings.tooltip_fade_in_speed
			local var_96_4 = var_0_8.min(var_96_1 + arg_96_9 * var_96_3, 1)

			arg_96_1.alpha_multiplier = var_0_8.easeOutCubic(var_96_4)

			if var_96_4 == 1 then
				arg_96_1.alpha_progress = nil
			else
				arg_96_1.alpha_progress = var_96_4
			end
		end

		local var_96_5 = arg_96_1.size

		var_96_5[2] = 0

		local var_96_6 = true
		local var_96_7 = 0
		local var_96_8 = arg_96_1.passes
		local var_96_9 = false
		local var_96_10 = arg_96_1.end_pass

		if var_96_10 then
			local var_96_11 = var_96_10.data

			var_96_7 = var_96_7 + var_96_10.draw(var_96_11, var_96_9, var_96_6, arg_96_0, arg_96_1, arg_96_2, arg_96_3, arg_96_4, arg_96_5, arg_96_6, var_96_5, arg_96_8, arg_96_9)
		end

		local var_96_12 = var_96_10.data.frame_margin or 0

		for iter_96_0, iter_96_1 in ipairs(var_96_8) do
			local var_96_13 = iter_96_1.data

			var_96_13.frame_margin = var_96_12
			var_96_7 = var_96_7 + iter_96_1.draw(var_96_13, var_96_9, var_96_6, arg_96_0, arg_96_1, arg_96_2, arg_96_3, arg_96_4, arg_96_5, arg_96_6, var_96_5, arg_96_8, arg_96_9)
		end

		arg_96_6[2] = arg_96_6[2] + arg_96_7[2] + var_96_7

		local var_96_14 = arg_96_6[1]
		local var_96_15 = arg_96_6[2]
		local var_96_16 = arg_96_6[3]
		local var_96_17 = true

		for iter_96_2, iter_96_3 in ipairs(var_96_8) do
			local var_96_18 = iter_96_3.data

			var_96_18.frame_margin = var_96_12

			local var_96_19 = iter_96_3.draw(var_96_18, var_96_17, var_96_6, arg_96_0, arg_96_1, arg_96_2, arg_96_3, arg_96_4, arg_96_5, arg_96_6, var_96_5, arg_96_8, arg_96_9)

			var_96_5[2] = var_96_5[2] + var_96_19
			arg_96_6[2] = arg_96_6[2] - var_96_19
		end

		arg_96_6[1] = var_96_14
		arg_96_6[2] = var_96_15
		arg_96_6[3] = var_96_16

		if var_96_10 then
			local var_96_20 = var_96_10.data

			var_96_10.draw(var_96_20, var_96_17, var_96_6, arg_96_0, arg_96_1, arg_96_2, arg_96_3, arg_96_4, arg_96_5, arg_96_6, var_96_5, arg_96_8, arg_96_9)
		end
	end
}
UIPasses.item_tooltip = {
	init = function(arg_97_0, arg_97_1, arg_97_2)
		local var_97_0 = {}
		local var_97_1 = arg_97_0.content_passes or {
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
		local var_97_2 = {}
		local var_97_3 = arg_97_2.pass_styles

		for iter_97_0, iter_97_1 in ipairs(var_97_1) do
			local var_97_4 = var_97_3 and var_97_3[iter_97_1]

			var_97_2[#var_97_2 + 1] = {
				data = UITooltipPasses[iter_97_1].setup_data(var_97_4),
				draw = UITooltipPasses[iter_97_1].draw
			}
		end

		local var_97_5 = var_97_3 and var_97_3.item_background

		var_97_0.end_pass = {
			data = UITooltipPasses.item_background.setup_data(var_97_5),
			draw = UITooltipPasses.item_background.draw
		}
		var_97_0.passes = var_97_2
		var_97_0.size = {
			400,
			0
		}
		var_97_0.alpha_multiplier = 1
		var_97_0.items = {}

		local var_97_6 = arg_97_1.disable_fade_in

		var_97_0.items_alpha_progress = var_97_6 and {
			1,
			1,
			1,
			1
		} or {
			0,
			0,
			0,
			0
		}

		local var_97_7 = var_97_6 and 0 or UISettings.tooltip_wait_duration

		var_97_0.alpha_wait_times = {
			var_97_7,
			var_97_7 * 2,
			var_97_7 * 2,
			var_97_7 * 2
		}
		var_97_0.tooltip_sizes = {}
		var_97_0.equipped_items = {}
		var_97_0.player = nil

		return var_97_0
	end,
	update = function(arg_98_0, arg_98_1, arg_98_2, arg_98_3, arg_98_4, arg_98_5, arg_98_6, arg_98_7, arg_98_8)
		if not arg_98_8 then
			arg_98_1.player = nil

			local var_98_0 = UISettings.tooltip_wait_duration

			arg_98_1.alpha_progress = 0
			arg_98_1.alpha_wait_time = var_98_0

			local var_98_1 = arg_98_1.alpha_wait_times
			local var_98_2 = arg_98_1.items_alpha_progress

			if var_98_1 then
				for iter_98_0 = 1, 4 do
					var_98_1[iter_98_0] = var_98_0 * 2
					var_98_2[iter_98_0] = 0
				end
			end
		end
	end,
	draw = function(arg_99_0, arg_99_1, arg_99_2, arg_99_3, arg_99_4, arg_99_5, arg_99_6, arg_99_7, arg_99_8, arg_99_9)
		if not arg_99_1.player then
			arg_99_1.player = Managers.player:local_player()
		end

		local var_99_0 = arg_99_5[arg_99_3.item_id]

		if not var_99_0 then
			return
		end

		local var_99_1 = arg_99_1.items

		table.clear(var_99_1)

		var_99_1[1] = var_99_0

		local var_99_2 = var_99_0.backend_id
		local var_99_3 = var_99_0.data.slot_type
		local var_99_4 = not arg_99_5.no_equipped_item and arg_99_5.equipped_item

		if var_99_4 then
			var_99_1[2] = var_99_4

			table.clear(arg_99_1.equipped_items)

			arg_99_1.equipped_items[1] = var_99_4
		end

		if not arg_99_5.no_equipped_item and not var_99_4 and var_99_3 and InventorySettings.slot_names_by_type[var_99_3] then
			local var_99_5 = arg_99_1.player

			if var_99_5 then
				local var_99_6 = arg_99_1.equipped_items

				table.clear(var_99_6)

				local var_99_7 = Managers.backend:get_interface("items")
				local var_99_8 = arg_99_5.profile_index or var_99_5:profile_index()
				local var_99_9 = arg_99_5.career_index or var_99_5:career_index()
				local var_99_10 = SPProfiles[var_99_8].careers[var_99_9].name
				local var_99_11 = var_99_7:get_loadout()[var_99_10]

				for iter_99_0, iter_99_1 in pairs(var_99_11) do
					table.insert(var_99_6, var_99_7:get_item_from_id(iter_99_1))
				end

				local var_99_12 = Managers.backend:get_interface("common")
				local var_99_13 = "slot_type == " .. var_99_3
				local var_99_14 = var_99_12:filter_items(var_99_6, var_99_13)

				arg_99_1.equipped_items = var_99_14

				for iter_99_2, iter_99_3 in ipairs(var_99_14) do
					if iter_99_3.backend_id ~= var_99_2 then
						var_99_1[#var_99_1 + 1] = iter_99_3
					end
				end
			end
		end

		local var_99_15 = RESOLUTION_LOOKUP.scale
		local var_99_16 = RESOLUTION_LOOKUP.inv_scale
		local var_99_17
		local var_99_18 = arg_99_1.size
		local var_99_19 = RESOLUTION_LOOKUP.res_w
		local var_99_20 = RESOLUTION_LOOKUP.res_h
		local var_99_21
		local var_99_22

		if arg_99_5.force_equipped_item_on_left or not arg_99_5.force_equipped_item_on_right and (arg_99_6[1] + arg_99_7[1] * 0.5) * var_99_15 > var_99_19 * 0.5 then
			arg_99_6[1] = arg_99_6[1] - var_99_18[1] - 5
			var_99_22 = -1
		else
			arg_99_6[1] = arg_99_6[1] + arg_99_7[1] + 5
			var_99_22 = 1
		end

		local var_99_23 = arg_99_6[1]
		local var_99_24 = arg_99_6[3]
		local var_99_25 = arg_99_1.tooltip_sizes

		for iter_99_4, iter_99_5 in ipairs(var_99_1) do
			local var_99_26 = arg_99_1.end_pass
			local var_99_27 = var_99_26.data.frame_margin or 0
			local var_99_28 = arg_99_1.passes
			local var_99_29 = false
			local var_99_30 = true
			local var_99_31 = var_99_30 and ipairs or ripairs
			local var_99_32 = 0

			if var_99_26 then
				local var_99_33 = var_99_26.data

				var_99_32 = var_99_32 + var_99_26.draw(var_99_33, var_99_29, var_99_30, arg_99_0, arg_99_1, arg_99_2, arg_99_3, arg_99_4, arg_99_5, arg_99_6, var_99_18, arg_99_8, arg_99_9, iter_99_5)
			end

			for iter_99_6, iter_99_7 in var_99_31(var_99_28) do
				local var_99_34 = iter_99_7.data

				var_99_34.frame_margin = var_99_27
				var_99_32 = var_99_32 + iter_99_7.draw(var_99_34, var_99_29, var_99_30, arg_99_0, arg_99_1, arg_99_2, arg_99_3, arg_99_4, arg_99_5, arg_99_6, var_99_18, arg_99_8, arg_99_9, iter_99_5)
			end

			var_99_25[iter_99_4] = var_99_32
		end

		local var_99_35 = 40 * var_99_15
		local var_99_36 = 30 * var_99_15
		local var_99_37 = #var_99_1
		local var_99_38 = arg_99_1.alpha_wait_times
		local var_99_39 = arg_99_1.items_alpha_progress

		for iter_99_8, iter_99_9 in ipairs(var_99_1) do
			var_99_18[2] = 0

			local var_99_40 = true
			local var_99_41 = var_99_40 and ipairs or ripairs
			local var_99_42 = arg_99_1.passes
			local var_99_43
			local var_99_44 = arg_99_1.end_pass
			local var_99_45 = var_99_44.data.frame_margin or 0
			local var_99_46 = var_99_25[iter_99_8]
			local var_99_47 = var_99_37 == 3
			local var_99_48 = iter_99_8 == 1
			local var_99_49 = var_99_38[iter_99_8]

			if var_99_49 then
				if var_99_48 or not var_99_38[1] then
					local var_99_50 = var_99_49 - arg_99_9

					if var_99_50 <= 0 then
						var_99_38[iter_99_8] = nil
					else
						var_99_38[iter_99_8] = var_99_50
					end

					arg_99_1.alpha_multiplier = 0
				end
			else
				local var_99_51 = var_99_39[iter_99_8]

				if var_99_51 then
					local var_99_52 = UISettings.tooltip_fade_in_speed
					local var_99_53 = var_0_8.min(var_99_51 + arg_99_9 * var_99_52, 1)

					arg_99_1.alpha_multiplier = var_0_8.easeOutCubic(var_99_53)

					if var_99_51 == 1 then
						var_99_39[iter_99_8] = nil
					else
						var_99_39[iter_99_8] = var_99_53
					end
				else
					arg_99_1.alpha_multiplier = 1
				end

				if var_99_48 then
					local var_99_54 = arg_99_5.force_top_alignment and 0 or var_99_46

					arg_99_6[2] = arg_99_6[2] + var_99_54 - var_99_45 / 2

					local var_99_55 = arg_99_6[2] * var_99_15 + var_99_35

					if var_99_20 < var_99_55 then
						arg_99_6[2] = arg_99_6[2] - (var_99_55 - var_99_20) * var_99_16
					end

					var_99_17 = arg_99_6[2]
				end

				if not var_99_48 then
					if var_99_47 and var_99_20 > var_99_25[2] + var_99_25[3] then
						arg_99_6[1] = var_99_23 + var_99_18[1] * var_99_22

						if var_99_17 - (var_99_25[2] + var_99_25[3] + var_99_36 * 2) < 0 then
							if iter_99_8 > 2 then
								arg_99_6[1] = arg_99_6[1] + var_99_18[1] * var_99_22
							end

							arg_99_6[2] = var_99_17
						elseif iter_99_8 == 2 then
							arg_99_6[2] = var_99_17
						else
							arg_99_6[2] = var_99_17 - (var_99_25[2] + var_99_36 * 2)
						end
					else
						arg_99_6[1] = arg_99_6[1] + var_99_18[1] * var_99_22

						local var_99_56 = var_99_17 - var_99_46

						if var_99_56 < 0 then
							arg_99_6[2] = var_99_17 + var_0_8.abs(var_99_56) + var_99_36
						else
							arg_99_6[2] = var_99_17
						end
					end
				end

				local var_99_57 = arg_99_6[1]
				local var_99_58 = arg_99_6[2] + var_99_45 / 2 * var_99_15
				local var_99_59 = arg_99_6[3]
				local var_99_60 = true

				for iter_99_10, iter_99_11 in var_99_41(var_99_42) do
					local var_99_61 = iter_99_11.data

					var_99_61.frame_margin = var_99_45
					var_99_61.equipped_items = arg_99_1.equipped_items

					local var_99_62 = iter_99_11.draw(var_99_61, var_99_60, var_99_40, arg_99_0, arg_99_1, arg_99_2, arg_99_3, arg_99_4, arg_99_5, arg_99_6, var_99_18, arg_99_8, arg_99_9, iter_99_9)

					var_99_18[2] = var_99_18[2] + var_99_62

					if var_99_40 then
						arg_99_6[2] = arg_99_6[2] - var_99_62
					else
						arg_99_6[2] = arg_99_6[2] + var_99_62
					end
				end

				arg_99_6[1] = var_99_57
				arg_99_6[2] = var_99_58
				arg_99_6[3] = var_99_59

				if var_99_44 then
					local var_99_63 = var_99_44.data

					var_99_44.draw(var_99_63, var_99_60, var_99_40, arg_99_0, arg_99_1, arg_99_2, arg_99_3, arg_99_4, arg_99_5, arg_99_6, var_99_18, arg_99_8, arg_99_9, iter_99_9)
				end
			end

			arg_99_6[3] = var_99_24
		end
	end
}
UIPasses.talent_tooltip = {
	init = function(arg_100_0, arg_100_1, arg_100_2)
		local var_100_0 = {}

		var_100_0.passes, var_100_0.end_pass = {
			{
				data = UITooltipPasses.talent_text.setup_data(),
				draw = UITooltipPasses.talent_text.draw
			}
		}, {
			data = UITooltipPasses.background.setup_data(),
			draw = UITooltipPasses.background.draw
		}
		var_100_0.size = {
			400,
			0
		}
		var_100_0.alpha_multiplier = 1

		return var_100_0
	end,
	update = function(arg_101_0, arg_101_1, arg_101_2, arg_101_3, arg_101_4, arg_101_5, arg_101_6, arg_101_7, arg_101_8)
		if not arg_101_8 then
			arg_101_1.alpha_progress = 0
			arg_101_1.alpha_wait_time = UISettings.tooltip_wait_duration
		end
	end,
	draw = function(arg_102_0, arg_102_1, arg_102_2, arg_102_3, arg_102_4, arg_102_5, arg_102_6, arg_102_7, arg_102_8, arg_102_9)
		local var_102_0 = arg_102_5[arg_102_3.talent_id]

		if not var_102_0 then
			return
		end

		local var_102_1 = arg_102_1.alpha_wait_time
		local var_102_2 = arg_102_1.alpha_progress

		if var_102_1 then
			local var_102_3 = var_102_1 - arg_102_9

			if var_102_3 <= 0 then
				arg_102_1.alpha_wait_time = nil
			else
				arg_102_1.alpha_wait_time = var_102_3
			end

			arg_102_1.alpha_multiplier = 0
		elseif var_102_2 then
			local var_102_4 = UISettings.tooltip_fade_in_speed
			local var_102_5 = var_0_8.min(var_102_2 + arg_102_9 * var_102_4, 1)

			arg_102_1.alpha_multiplier = var_0_8.easeOutCubic(var_102_5)

			if var_102_5 == 1 then
				arg_102_1.alpha_progress = nil
			else
				arg_102_1.alpha_progress = var_102_5
			end
		end

		local var_102_6 = arg_102_1.size

		var_102_6[2] = 0

		if arg_102_4.draw_right then
			arg_102_6[1] = arg_102_6[1] + arg_102_7[1]
		else
			arg_102_6[1] = arg_102_6[1] + 0.5 * (arg_102_7[1] - var_102_6[1])
		end

		local var_102_7 = arg_102_1.passes
		local var_102_8 = arg_102_1.end_pass
		local var_102_9 = var_102_8 and var_102_8.data.frame_margin or 0
		local var_102_10 = arg_102_4.draw_downwards ~= false

		if var_102_10 then
			local var_102_11 = 0
			local var_102_12 = false

			if var_102_8 then
				local var_102_13 = var_102_8.data

				var_102_11 = var_102_11 + var_102_8.draw(var_102_13, var_102_12, var_102_10, arg_102_0, arg_102_1, arg_102_2, arg_102_3, arg_102_4, arg_102_5, arg_102_6, var_102_6, arg_102_8, arg_102_9)
			end

			for iter_102_0, iter_102_1 in ipairs(var_102_7) do
				local var_102_14 = iter_102_1.data

				var_102_14.frame_margin = var_102_9
				var_102_11 = var_102_11 + iter_102_1.draw(var_102_14, var_102_12, var_102_10, arg_102_0, arg_102_1, arg_102_2, arg_102_3, arg_102_4, arg_102_5, arg_102_6, var_102_6, arg_102_8, arg_102_9, var_102_0)
			end

			arg_102_6[2] = arg_102_6[2] + arg_102_7[2] + var_102_11
		end

		local var_102_15 = arg_102_6[1]
		local var_102_16 = arg_102_6[2]
		local var_102_17 = arg_102_6[3]
		local var_102_18 = true

		for iter_102_2, iter_102_3 in ipairs(var_102_7) do
			local var_102_19 = iter_102_3.data

			var_102_19.frame_margin = var_102_9

			local var_102_20 = iter_102_3.draw(var_102_19, var_102_18, var_102_10, arg_102_0, arg_102_1, arg_102_2, arg_102_3, arg_102_4, arg_102_5, arg_102_6, var_102_6, arg_102_8, arg_102_9, var_102_0)

			var_102_6[2] = var_102_6[2] + var_102_20
			arg_102_6[2] = arg_102_6[2] - var_102_20
		end

		arg_102_6[1] = var_102_15
		arg_102_6[2] = var_102_16
		arg_102_6[3] = var_102_17

		if var_102_8 then
			local var_102_21 = var_102_8.data

			var_102_8.draw(var_102_21, var_102_18, var_102_10, arg_102_0, arg_102_1, arg_102_2, arg_102_3, arg_102_4, arg_102_5, arg_102_6, var_102_6, arg_102_8, arg_102_9)
		end
	end
}

local var_0_35 = {
	0,
	0
}
local var_0_36 = {
	0,
	0
}
local var_0_37 = {
	220,
	3,
	3,
	3
}

UIPasses.tooltip_text = {
	init = function(arg_103_0)
		assert(arg_103_0.text_id, "no text id in pass definition. YOU NEEDS IT.")

		return {
			text_id = arg_103_0.text_id
		}
	end,
	draw = function(arg_104_0, arg_104_1, arg_104_2, arg_104_3, arg_104_4, arg_104_5, arg_104_6, arg_104_7, arg_104_8, arg_104_9)
		arg_104_4.font_size = 18

		local var_104_0
		local var_104_1
		local var_104_2

		if arg_104_4.font_type then
			local var_104_3, var_104_4 = UIFontByResolution(arg_104_4)

			var_104_0, var_104_1, var_104_2 = var_104_3[1], var_104_4, var_104_3[3]
		else
			local var_104_5 = arg_104_4.font

			var_104_0, var_104_1, var_104_2 = var_104_5[1], var_104_5[2], var_104_5[3]
			var_104_1 = arg_104_4.font_size or var_104_1
		end

		local var_104_6 = arg_104_5[arg_104_1.text_id]

		if arg_104_4.localize then
			var_104_6 = Localize(var_104_6)
		end

		local var_104_7 = arg_104_4.max_width or arg_104_7[1]
		local var_104_8, var_104_9, var_104_10 = var_0_4(arg_104_0.gui, arg_104_4.font_type, var_104_1)
		local var_104_11 = var_0_0.word_wrap(arg_104_0, var_104_6, var_104_0, var_104_1, var_104_7)
		local var_104_12 = arg_104_5.text_start_index or 1
		local var_104_13 = arg_104_5.max_texts or #var_104_11
		local var_104_14 = var_0_8.min(#var_104_11 - (var_104_12 - 1), var_104_13)
		local var_104_15 = (var_104_10 - var_104_9) * RESOLUTION_LOOKUP.inv_scale
		local var_104_16 = Vector3(0, arg_104_4.grow_downward and var_104_15 or -var_104_15, 0)
		local var_104_17 = arg_104_4.fixed_position

		if var_104_17 and arg_104_4.use_fixed_position then
			var_0_36[1] = arg_104_6[1] + var_104_17[1]
			var_0_36[2] = arg_104_6[2] + var_104_17[2]
		else
			local var_104_18 = arg_104_8:get("cursor") or var_0_9

			var_0_36[1] = var_104_18[1]
			var_0_36[2] = var_104_18[2]
		end

		local var_104_19 = arg_104_4.cursor_offset

		var_0_36[1] = var_0_36[1] + (var_104_19 and var_104_19[1] or 25)
		var_0_36[2] = var_0_36[2] - (var_104_19 and var_104_19[2] or 15)

		local var_104_20

		if Managers.input:is_device_active("gamepad") then
			var_104_20 = var_0_36
		elseif IS_XB1 then
			var_104_20 = var_0_36
			var_104_20[2] = 1080 - var_104_20[2] + 20
		else
			var_104_20 = var_0_3(var_0_36)
		end

		var_0_35[2] = var_104_15 * var_104_14
		var_0_35[1] = 0

		for iter_104_0 = 1, var_104_14 do
			local var_104_21 = var_104_11[iter_104_0 - 1 + var_104_12]
			local var_104_22 = var_0_0.text_size(arg_104_0, var_104_21, var_104_0, var_104_1, var_0_35[2])

			if var_104_22 > var_0_35[1] then
				var_0_35[1] = var_104_22
			end
		end

		local var_104_23 = arg_104_4.cursor_side
		local var_104_24 = arg_104_4.draw_downwards

		if var_104_23 and var_104_23 == "left" then
			arg_104_6[1] = var_104_20[1] - var_0_35[1]

			if var_104_24 then
				arg_104_6[2] = var_104_20[2] - var_104_15
			else
				arg_104_6[2] = var_104_20[2] + (var_0_35[2] - var_104_15)
			end
		else
			arg_104_6[1] = var_104_20[1]
			arg_104_6[2] = var_104_20[2] - var_104_15
		end

		arg_104_6[3] = UILayer.tooltip + 1

		for iter_104_1 = 1, var_104_14 do
			local var_104_25 = var_104_11[iter_104_1 - 1 + var_104_12]
			local var_104_26 = arg_104_4.last_line_color and iter_104_1 == var_104_14 and arg_104_4.last_line_color or arg_104_4.line_colors and arg_104_4.line_colors[iter_104_1] or arg_104_4.text_color

			var_0_0.draw_text(arg_104_0, var_104_25, var_104_0, var_104_1, var_104_2, arg_104_6 + 0.25 * var_104_16, var_104_26)

			if iter_104_1 < var_104_14 then
				arg_104_6 = arg_104_6 + var_104_16
			end
		end

		local var_104_27 = 4
		local var_104_28 = 8

		arg_104_6[3] = arg_104_6[3] - 1
		arg_104_6[2] = arg_104_6[2] - (var_104_15 + var_104_9) - var_104_28
		arg_104_6[1] = arg_104_6[1] - 2 - var_104_27
		var_0_35[1] = var_0_35[1] + var_104_27 * 2 * RESOLUTION_LOOKUP.inv_scale
		var_0_35[2] = var_0_35[2] + var_104_28 * 2 * RESOLUTION_LOOKUP.inv_scale

		var_0_0.draw_rounded_rect(arg_104_0, arg_104_6, var_0_35, 5, var_0_37)
	end
}

local var_0_38 = {
	0,
	0
}

UIPasses.rect_text = {
	init = function(arg_105_0)
		assert(arg_105_0.text_id, "no text id in pass definition. YOU NEEDS IT.")

		return {
			text_id = arg_105_0.text_id
		}
	end,
	draw = function(arg_106_0, arg_106_1, arg_106_2, arg_106_3, arg_106_4, arg_106_5, arg_106_6, arg_106_7, arg_106_8, arg_106_9)
		local var_106_0
		local var_106_1
		local var_106_2

		if arg_106_4.font_type then
			local var_106_3, var_106_4 = UIFontByResolution(arg_106_4)

			var_106_0, var_106_1, var_106_2 = var_106_3[1], var_106_4, var_106_3[3]
		else
			local var_106_5 = arg_106_4.font

			var_106_0, var_106_1, var_106_2 = var_106_5[1], var_106_5[2], var_106_5[3]
			var_106_1 = arg_106_4.font_size or var_106_1
		end

		local var_106_6 = arg_106_5[arg_106_1.text_id]

		if arg_106_4.localize then
			var_106_6 = Localize(var_106_6)
		end

		local var_106_7 = arg_106_4.max_width or arg_106_7[1]
		local var_106_8, var_106_9, var_106_10 = var_0_4(arg_106_0.gui, arg_106_4.font_type, var_106_1)
		local var_106_11 = var_0_0.word_wrap(arg_106_0, var_106_6, var_106_0, var_106_1, var_106_7)
		local var_106_12 = arg_106_5.text_start_index or 1
		local var_106_13 = arg_106_5.max_texts or #var_106_11
		local var_106_14 = var_0_8.min(#var_106_11 - (var_106_12 - 1), var_106_13)
		local var_106_15 = (var_106_10 + var_0_8.abs(var_106_9)) * RESOLUTION_LOOKUP.inv_scale
		local var_106_16 = Vector3(0, arg_106_4.grow_downward and var_106_15 or -var_106_15, 0)
		local var_106_17 = UTF8Utils.string_length(var_106_6)

		var_0_38[2] = var_106_15 * var_106_14
		var_0_38[1] = 0

		if arg_106_4.static_rect_width then
			var_0_38[1] = arg_106_7[1]
		else
			for iter_106_0 = 1, var_106_14 do
				local var_106_18 = var_106_11[iter_106_0 - 1 + var_106_12]
				local var_106_19 = var_0_0.text_size(arg_106_0, var_106_18, var_106_0, var_106_1, var_0_38[2])

				if var_106_19 > var_0_38[1] then
					var_0_38[1] = var_106_19
				end
			end
		end

		if arg_106_4.horizontal_alignment == "center" then
			local var_106_20 = 0

			for iter_106_1 = 1, var_106_14 do
				local var_106_21 = var_106_11[iter_106_1 - 1 + var_106_12]
				local var_106_22 = var_106_21 and UTF8Utils.string_length(var_106_21) or 0
				local var_106_23 = var_0_0.text_size(arg_106_0, var_106_21, var_106_0, var_106_1, arg_106_7[2])
				local var_106_24 = Vector3(arg_106_7[1] / 2 - var_106_23 / 2, 0, 0)
				local var_106_25

				if arg_106_4.color_override then
					var_106_25 = var_0_30(iter_106_1, var_106_22, var_106_20, var_106_17, arg_106_4)
				end

				var_0_0.draw_text(arg_106_0, var_106_21, var_106_0, var_106_1, var_106_2, arg_106_6 + var_106_24, arg_106_4.text_color, nil, var_106_25)

				if iter_106_1 < var_106_14 then
					arg_106_6 = arg_106_6 + var_106_16
				end

				var_106_20 = var_106_20 + var_106_22 + 1
			end
		else
			for iter_106_2 = 1, var_106_14 do
				local var_106_26 = var_106_11[iter_106_2 - 1 + var_106_12]
				local var_106_27 = arg_106_4.last_line_color and iter_106_2 == var_106_14 and arg_106_4.last_line_color or arg_106_4.line_colors and arg_106_4.line_colors[iter_106_2] or arg_106_4.text_color

				var_0_0.draw_text(arg_106_0, var_106_26, var_106_0, var_106_1, var_106_2, arg_106_6, var_106_27)

				if iter_106_2 < var_106_14 then
					arg_106_6 = arg_106_6 + var_106_16
				end
			end
		end

		local var_106_28 = 4
		local var_106_29 = 2

		arg_106_6[3] = arg_106_6[3] - 1
		arg_106_6[2] = arg_106_6[2] + var_106_9 * RESOLUTION_LOOKUP.inv_scale
		var_0_38[1] = var_0_38[1] + var_106_28 * 4
		var_0_38[2] = var_0_38[2] + var_106_29 * 2

		local var_106_30 = Vector3(0, 0, 0)

		if arg_106_4.horizontal_alignment == "center" then
			var_106_30 = Vector3(arg_106_7[1] * 0.5 - var_0_38[1] * 0.5, 0, 0)
		else
			var_106_30 = Vector3(-var_106_28 * 2, 0, 0)
		end

		if arg_106_4.masked then
			var_0_1(arg_106_0, "rect_masked", arg_106_6 + var_106_30, var_0_38, arg_106_4.rect_color, arg_106_4.masked, arg_106_4 and arg_106_4.saturated)
		else
			var_0_0.draw_rounded_rect(arg_106_0, arg_106_6 + var_106_30, var_0_38, 5, arg_106_4.rect_color)
		end

		if arg_106_4.border then
			arg_106_6 = Vector3(arg_106_6[1] - arg_106_4.border, arg_106_6[2] - arg_106_4.border, arg_106_6[3] - 1)
			var_0_38[1] = var_0_38[1] + arg_106_4.border * 2
			var_0_38[2] = var_0_38[2] + arg_106_4.border * 2

			if arg_106_4.masked then
				var_0_1(arg_106_0, "rect_masked", arg_106_6 + var_106_30, var_0_38, arg_106_4.border_color, arg_106_4.masked, arg_106_4 and arg_106_4.saturated)
			else
				var_0_0.draw_rounded_rect(arg_106_0, arg_106_6 + var_106_30, var_0_38, 5, arg_106_4.border_color)
			end
		end
	end
}

local var_0_39 = UISettings.double_click_threshold

UIPasses.hotspot = {
	init = function(arg_107_0, arg_107_1)
		return
	end,
	draw = function(arg_108_0, arg_108_1, arg_108_2, arg_108_3, arg_108_4, arg_108_5, arg_108_6, arg_108_7, arg_108_8, arg_108_9)
		if arg_108_4 then
			local var_108_0 = arg_108_4.area_size

			if var_108_0 then
				if arg_108_4.horizontal_alignment == "right" then
					arg_108_6[1] = arg_108_6[1] + arg_108_7[1] - var_108_0[1]
				elseif arg_108_4.horizontal_alignment == "center" then
					arg_108_6[1] = arg_108_6[1] + (arg_108_7[1] - var_108_0[1]) / 2
				end

				if arg_108_4.vertical_alignment == "center" then
					arg_108_6[2] = arg_108_6[2] + (arg_108_7[2] - var_108_0[2]) / 2
				elseif arg_108_4.vertical_alignment == "top" then
					arg_108_6[2] = arg_108_6[2] + arg_108_7[2] - var_108_0[2]
				end

				arg_108_7 = var_108_0
			end
		end

		local var_108_1 = Managers.input
		local var_108_2 = var_108_1:is_device_active("gamepad")
		local var_108_3 = var_108_1:gamepad_cursor_active()
		local var_108_4 = var_108_1:is_frame_hovering()
		local var_108_5 = arg_108_5.is_hover
		local var_108_6
		local var_108_7 = "cursor"
		local var_108_8 = ShowCursorStack.stack_depth
		local var_108_9 = arg_108_8 and arg_108_8:has(var_108_7)
		local var_108_10 = var_108_8 > 0 and var_108_9 and arg_108_8:get(var_108_7)

		if not var_108_10 or Script.type_name(var_108_10) ~= var_0_11 then
			var_108_10 = var_0_9
		end

		local var_108_11

		if IS_XB1 and not var_108_2 then
			var_108_11 = Vector3(var_108_10[1], 1080 - var_108_10[2], var_108_10[3])
		else
			var_108_11 = var_0_3(var_108_10)
		end

		local var_108_12 = arg_108_5.hover_type
		local var_108_13 = arg_108_6
		local var_108_14 = arg_108_7

		if var_108_2 then
			if not var_108_3 then
				var_108_6 = false
			elseif var_108_4 and not arg_108_5.allow_multi_hover then
				var_108_6 = false
			else
				local var_108_15 = RESOLUTION_LOOKUP.scale

				var_108_11[1] = var_108_11[1] * var_108_15
				var_108_11[2] = var_108_11[2] * var_108_15

				local var_108_16 = Vector2(GAMEPAD_CURSOR_SIZE * 0.5, GAMEPAD_CURSOR_SIZE * 0.5)

				var_108_6 = var_0_8.box_overlap_box(var_108_11 - var_108_16 * 0.5, var_108_16, var_108_13, var_108_14)
			end
		elseif var_108_12 == "circle" then
			local var_108_17 = var_108_14 / 2
			local var_108_18 = Vector3.flat(var_108_13) + var_108_17

			var_108_6 = Vector3.distance_squared(var_108_11, var_108_18) <= var_108_17.x * var_108_17.y or false
		else
			var_108_6 = var_0_8.point_is_inside_2d_box(var_108_11, var_108_13, var_108_14)
		end

		arg_108_5.cursor_hover = var_108_6

		if arg_108_5.disable_button then
			var_108_6 = false
		end

		if var_108_2 and var_108_6 and not arg_108_5.allow_multi_hover then
			var_108_1:set_hovering(var_108_6)
		end

		if script_data.ui_debug_hover then
			if arg_108_5.is_hover then
				var_0_0.draw_rect(arg_108_0, Vector3(arg_108_6[1], arg_108_6[2], 999), arg_108_7, {
					128,
					0,
					255,
					0
				})
			else
				var_0_0.draw_rect(arg_108_0, arg_108_6 + Vector3(0, 0, 1), arg_108_7, {
					60,
					255,
					0,
					0
				})
			end
		end

		arg_108_5.gamepad_active = var_108_2

		if arg_108_5.on_hover_enter then
			arg_108_5.on_hover_enter = nil
		end

		if arg_108_5.on_hover_exit then
			arg_108_5.on_hover_exit = nil
		end

		if var_108_6 and not var_108_5 then
			arg_108_5.on_hover_enter = not UIPasses.is_dragging_item
			arg_108_5.is_hover = not UIPasses.is_dragging_item
			arg_108_5.internal_is_hover = true
		end

		if var_108_5 and not var_108_6 then
			arg_108_5.is_hover = nil
			arg_108_5.on_hover_exit = true
			arg_108_5.internal_is_hover = nil
		end

		if arg_108_5.on_pressed then
			arg_108_5.on_pressed = nil
		end

		if var_108_6 and UIPasses.is_dragging_item then
			var_108_6 = false
		elseif not var_108_6 and arg_108_5.internal_is_hover then
			arg_108_5.internal_is_hover = nil
		end

		local var_108_19 = arg_108_8 and arg_108_8:get("left_press")
		local var_108_20 = arg_108_8 and arg_108_8:get("left_hold")
		local var_108_21 = arg_108_5.is_clicked and arg_108_5.is_clicked < var_0_39

		if var_108_6 then
			if not arg_108_5.input_pressed then
				arg_108_5.input_pressed = var_108_19

				if arg_108_5.input_pressed then
					arg_108_5.on_pressed = true
				end

				if var_108_20 and var_108_19 then
					arg_108_5.is_held = true
				end
			elseif not var_108_21 then
				arg_108_5.input_pressed = false
			end
		elseif arg_108_5.input_pressed then
			arg_108_5.input_pressed = false
		end

		arg_108_5.on_right_click = false
		arg_108_5.on_double_click = false

		if not var_108_20 then
			arg_108_5.is_held = false
		end

		local var_108_22 = arg_108_8:get("left_release")

		if arg_108_5.input_pressed then
			if var_108_22 then
				arg_108_5.on_release = true
				arg_108_5.on_left_release = true
				arg_108_5.is_clicked = 0
			else
				arg_108_5.on_release = false

				if var_108_19 and (var_108_21 or var_108_2) then
					arg_108_5.on_double_click = true
					arg_108_5.is_clicked = 0
				elseif var_108_6 and var_108_20 then
					arg_108_5.is_clicked = 0
				else
					arg_108_5.is_clicked = (arg_108_5.is_clicked or 10) + arg_108_9
				end
			end
		elseif var_108_22 and var_108_6 then
			arg_108_5.on_left_release = true
		else
			if var_108_6 and not var_108_19 and not var_108_20 and arg_108_8:get("right_press") then
				arg_108_5.on_right_click = true
			end

			arg_108_5.on_release = false
			arg_108_5.on_left_release = false
			arg_108_5.is_clicked = (arg_108_5.is_clicked or 10) + arg_108_9
		end
	end
}
UIPasses.controller_hotspot = {
	init = function(arg_109_0)
		return
	end,
	draw = function(arg_110_0, arg_110_1, arg_110_2, arg_110_3, arg_110_4, arg_110_5, arg_110_6, arg_110_7, arg_110_8, arg_110_9)
		local var_110_0 = arg_110_5.is_hover
		local var_110_1
		local var_110_2 = arg_110_8:get_controller_cursor_position() or var_0_9
		local var_110_3 = arg_110_6
		local var_110_4 = arg_110_7
		local var_110_5 = var_0_8.point_is_inside_2d_box(var_110_2, var_110_3, var_110_4)

		if script_data.ui_debug_hover then
			var_0_0.draw_rect(arg_110_0, arg_110_6 + Vector3(0, 0, 1), arg_110_7, arg_110_5.is_hover and {
				128,
				0,
				255,
				0
			} or {
				128,
				255,
				0,
				0
			})
		end

		if var_110_5 and not var_110_0 then
			arg_110_5.is_hover = not UIPasses.is_dragging_item
			arg_110_5.internal_is_hover = true
			var_110_5 = not UIPasses.is_dragging_item
		end

		if var_110_0 and not var_110_5 then
			arg_110_5.is_hover = nil
			arg_110_5.internal_is_hover = nil
		end

		if var_110_5 and UIPasses.is_dragging_item then
			var_110_5 = false
		elseif not var_110_5 and arg_110_5.internal_is_hover then
			arg_110_5.internal_is_hover = nil
		end

		arg_110_5.on_double_click = false

		if var_110_5 or arg_110_5.is_clicked == 0 then
			if arg_110_8:get("confirm") then
				arg_110_5.on_release = true
				arg_110_5.is_clicked = 0
			else
				arg_110_5.on_release = false

				local var_110_6 = arg_110_8:get("confirm_hold")

				if arg_110_5.is_clicked == 0 and var_110_6 then
					arg_110_5.is_clicked = 0
				elseif arg_110_8:get("confirm_press") and arg_110_5.is_clicked < UISettings.double_click_threshold then
					arg_110_5.on_double_click = true
					arg_110_5.is_clicked = 0
				else
					arg_110_5.is_clicked = (arg_110_5.is_clicked or 10) + arg_110_9
				end
			end
		else
			arg_110_5.on_release = false
			arg_110_5.is_clicked = (arg_110_5.is_clicked or 10) + arg_110_9
		end
	end
}
UIPasses.game_pad_connected = {
	init = function(arg_111_0)
		return
	end,
	draw = function(arg_112_0, arg_112_1, arg_112_2, arg_112_3, arg_112_4, arg_112_5, arg_112_6, arg_112_7, arg_112_8, arg_112_9)
		arg_112_5.gamepad_connected = Managers.input:get_device("gamepad").active()
	end
}

local function var_0_40(arg_113_0, arg_113_1, arg_113_2, arg_113_3, arg_113_4, arg_113_5, arg_113_6, arg_113_7, arg_113_8, arg_113_9, arg_113_10)
	if arg_113_8:get(arg_113_10) then
		arg_113_5.on_release = true
		arg_113_5.is_clicked = 0
	else
		arg_113_5.on_release = false
		arg_113_5.is_clicked = (arg_113_5.is_clicked or 10) + arg_113_9
	end
end

UIPasses.gamepad_button_click_confirm = {
	init = function(arg_114_0)
		return
	end,
	draw = function(arg_115_0, arg_115_1, arg_115_2, arg_115_3, arg_115_4, arg_115_5, arg_115_6, arg_115_7, arg_115_8, arg_115_9)
		var_0_40(arg_115_0, arg_115_1, arg_115_2, arg_115_3, arg_115_4, arg_115_5, arg_115_6, arg_115_7, arg_115_8, arg_115_9, "confirm")
	end
}
UIPasses.gamepad_button_click_back = {
	init = function(arg_116_0)
		return
	end,
	draw = function(arg_117_0, arg_117_1, arg_117_2, arg_117_3, arg_117_4, arg_117_5, arg_117_6, arg_117_7, arg_117_8, arg_117_9)
		var_0_40(arg_117_0, arg_117_1, arg_117_2, arg_117_3, arg_117_4, arg_117_5, arg_117_6, arg_117_7, arg_117_8, arg_117_9, "back")
	end
}
UIPasses.gamepad_button_click_refresh = {
	init = function(arg_118_0)
		return
	end,
	draw = function(arg_119_0, arg_119_1, arg_119_2, arg_119_3, arg_119_4, arg_119_5, arg_119_6, arg_119_7, arg_119_8, arg_119_9)
		var_0_40(arg_119_0, arg_119_1, arg_119_2, arg_119_3, arg_119_4, arg_119_5, arg_119_6, arg_119_7, arg_119_8, arg_119_9, "refresh")
	end
}
UIPasses.on_click = {
	init = function(arg_120_0)
		return
	end,
	draw = function(arg_121_0, arg_121_1, arg_121_2, arg_121_3, arg_121_4, arg_121_5, arg_121_6, arg_121_7, arg_121_8, arg_121_9)
		if arg_121_5[arg_121_3.click_check_content_id].on_pressed then
			arg_121_3.click_function(arg_121_2, arg_121_4, arg_121_5, arg_121_8)
		end
	end
}
UIPasses.on_left_and_right_click = {
	init = function(arg_122_0)
		return
	end,
	draw = function(arg_123_0, arg_123_1, arg_123_2, arg_123_3, arg_123_4, arg_123_5, arg_123_6, arg_123_7, arg_123_8, arg_123_9)
		local var_123_0 = arg_123_5[arg_123_3.click_check_content_id]

		if var_123_0.on_pressed or var_123_0.on_right_click then
			arg_123_3.click_function(arg_123_2, arg_123_4, arg_123_5, arg_123_8)
		end
	end
}
UIPasses.on_double_click = {
	init = function(arg_124_0)
		return
	end,
	draw = function(arg_125_0, arg_125_1, arg_125_2, arg_125_3, arg_125_4, arg_125_5, arg_125_6, arg_125_7, arg_125_8, arg_125_9)
		if arg_125_5[arg_125_3.click_check_content_id].on_double_click then
			arg_125_3.click_function(arg_125_2, arg_125_4, arg_125_5, arg_125_8)
		end
	end
}
UIPasses.debug_cursor = {
	init = function(arg_126_0)
		return nil
	end,
	draw = function(arg_127_0, arg_127_1, arg_127_2, arg_127_3, arg_127_4, arg_127_5, arg_127_6, arg_127_7, arg_127_8, arg_127_9)
		local var_127_0 = arg_127_5.is_hover and Colors.green or Colors.red

		if (arg_127_5.is_clicked or 10) < 0.5 then
			var_127_0 = Colors.blue
		end

		var_0_0.draw_rect(arg_127_0, arg_127_6, arg_127_7, var_127_0)
	end
}
UIPasses.local_offset = {
	init = function(arg_128_0)
		return nil
	end,
	draw = function(arg_129_0, arg_129_1, arg_129_2, arg_129_3, arg_129_4, arg_129_5, arg_129_6, arg_129_7, arg_129_8, arg_129_9)
		arg_129_3.offset_function(arg_129_2, arg_129_4, arg_129_5, arg_129_0)
	end
}
UIPasses.scroll = {
	init = function(arg_130_0)
		return nil
	end,
	draw = function(arg_131_0, arg_131_1, arg_131_2, arg_131_3, arg_131_4, arg_131_5, arg_131_6, arg_131_7, arg_131_8, arg_131_9)
		local var_131_0 = arg_131_8:get("cursor") or var_0_9
		local var_131_1

		if Managers.input:is_device_active("gamepad") then
			var_131_1 = var_131_0
		else
			var_131_1 = var_0_3(var_131_0)
		end

		arg_131_5.is_hover = var_0_8.point_is_inside_2d_box(var_131_1, arg_131_6, arg_131_7) and not UIPasses.is_dragging_item

		local var_131_2 = arg_131_8:get("scroll_axis")

		if var_131_2 then
			arg_131_3.scroll_function(arg_131_2, arg_131_4, arg_131_5, arg_131_8, var_131_2, arg_131_9)
		end
	end
}
UIPasses.held = {
	init = function(arg_132_0)
		return nil
	end,
	draw = function(arg_133_0, arg_133_1, arg_133_2, arg_133_3, arg_133_4, arg_133_5, arg_133_6, arg_133_7, arg_133_8, arg_133_9)
		local var_133_0 = arg_133_3.content_check_hover and arg_133_5[arg_133_3.content_check_hover] or arg_133_5

		if not var_133_0.is_held and var_133_0.is_hover and arg_133_8:get("left_press") then
			var_133_0.is_held = true
		end

		if var_133_0.is_held then
			if arg_133_8:get("left_hold") then
				if arg_133_3.held_function then
					arg_133_3.held_function(arg_133_2, arg_133_4, arg_133_5, arg_133_8)
				end
			else
				if arg_133_3.release_function then
					arg_133_3.release_function(arg_133_2, arg_133_4, arg_133_5, arg_133_8)
				end

				var_133_0.is_held = false
			end
		end
	end
}
UIPasses.item_presentation = {
	init = function(arg_134_0, arg_134_1, arg_134_2)
		local var_134_0 = {}
		local var_134_1 = arg_134_0.content_passes or {
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
		local var_134_2 = {}
		local var_134_3 = arg_134_2.pass_styles

		for iter_134_0, iter_134_1 in ipairs(var_134_1) do
			local var_134_4 = var_134_3 and var_134_3[iter_134_1]

			var_134_2[#var_134_2 + 1] = {
				data = UITooltipPasses[iter_134_1].setup_data(var_134_4),
				draw = UITooltipPasses[iter_134_1].draw
			}
		end

		local var_134_5 = var_134_3 and var_134_3.item_background

		var_134_0.end_pass = {
			data = UITooltipPasses.item_background.setup_data(var_134_5),
			draw = UITooltipPasses.item_background.draw
		}
		var_134_0.items = {}
		var_134_0.passes = var_134_2
		var_134_0.alpha_multiplier = 1
		var_134_0.player = nil
		var_134_0.force_equipped = arg_134_1.force_equipped

		return var_134_0
	end,
	draw = function(arg_135_0, arg_135_1, arg_135_2, arg_135_3, arg_135_4, arg_135_5, arg_135_6, arg_135_7, arg_135_8, arg_135_9)
		local var_135_0 = arg_135_5[arg_135_3.item_id]

		if not var_135_0 then
			return
		end

		if not arg_135_1.player then
			arg_135_1.player = Managers.player:local_player()
		end

		arg_135_7[2] = 0
		arg_135_1.start_layer = arg_135_6[3]

		local var_135_1 = true
		local var_135_2 = arg_135_1.passes
		local var_135_3 = false
		local var_135_4 = 0
		local var_135_5 = arg_135_1.end_pass
		local var_135_6 = arg_135_4.draw_end_passes
		local var_135_7 = var_135_5.data.frame_margin or 0

		if arg_135_5.compare_item then
			local var_135_8 = arg_135_1.items

			table.clear(var_135_8)

			var_135_8[1] = var_135_0

			local var_135_9 = arg_135_5.compare_item

			if var_135_9 then
				var_135_8[2] = var_135_9
			end
		end

		if var_135_5 and var_135_6 then
			local var_135_10 = var_135_5.data

			var_135_4 = var_135_4 + var_135_5.draw(var_135_10, var_135_3, var_135_1, arg_135_0, arg_135_1, arg_135_2, arg_135_3, arg_135_4, arg_135_5, arg_135_6, arg_135_7, arg_135_8, arg_135_9, var_135_0)
		end

		for iter_135_0, iter_135_1 in ipairs(var_135_2) do
			local var_135_11 = iter_135_1.data

			var_135_11.frame_margin = var_135_7
			var_135_4 = var_135_4 + iter_135_1.draw(var_135_11, var_135_3, var_135_1, arg_135_0, arg_135_1, arg_135_2, arg_135_3, arg_135_4, arg_135_5, arg_135_6, arg_135_7, arg_135_8, arg_135_9, var_135_0)
		end

		if arg_135_4.vertical_alignment == "center" then
			arg_135_6[2] = arg_135_6[2] + var_135_4 / 2 - var_135_7 / 2
		end

		local var_135_12 = arg_135_6[1]
		local var_135_13 = arg_135_6[2] + var_135_7 / 2
		local var_135_14 = arg_135_6[3]
		local var_135_15 = true

		for iter_135_2, iter_135_3 in ipairs(var_135_2) do
			local var_135_16 = iter_135_3.data

			var_135_16.frame_margin = var_135_7

			local var_135_17 = iter_135_3.draw(var_135_16, var_135_15, var_135_1, arg_135_0, arg_135_1, arg_135_2, arg_135_3, arg_135_4, arg_135_5, arg_135_6, arg_135_7, arg_135_8, arg_135_9, var_135_0)

			arg_135_7[2] = arg_135_7[2] + var_135_17

			if var_135_1 then
				arg_135_6[2] = arg_135_6[2] - var_135_17
			else
				arg_135_6[2] = arg_135_6[2] + var_135_17
			end
		end

		arg_135_6[1] = var_135_12
		arg_135_6[2] = var_135_13
		arg_135_6[3] = var_135_14

		if var_135_5 and var_135_6 then
			local var_135_18 = var_135_5.data

			var_135_5.draw(var_135_18, var_135_15, var_135_1, arg_135_0, arg_135_1, arg_135_2, arg_135_3, arg_135_4, arg_135_5, arg_135_6, arg_135_7, arg_135_8, arg_135_9, var_135_0)
		end

		arg_135_4.item_presentation_height = arg_135_7[2]
	end
}
UIPasses.keystrokes = {
	init = function(arg_136_0)
		return {
			input_text_id = arg_136_0.input_text_id,
			keystrokes = {}
		}
	end,
	draw = function(arg_137_0, arg_137_1, arg_137_2, arg_137_3, arg_137_4, arg_137_5, arg_137_6, arg_137_7, arg_137_8, arg_137_9)
		if arg_137_5.active then
			local var_137_0 = arg_137_5[arg_137_1.input_text_id]
			local var_137_1 = arg_137_5.caret_index
			local var_137_2 = arg_137_5.input_mode
			local var_137_3 = arg_137_5.max_length

			Managers.chat:block_chat_input_for_one_frame()
			table.clear(arg_137_1.keystrokes)

			local var_137_4 = Keyboard.keystrokes(arg_137_1.keystrokes)
			local var_137_5, var_137_6, var_137_7 = KeystrokeHelper.parse_strokes(var_137_0, var_137_1, var_137_2, var_137_4, var_137_3)

			arg_137_5[arg_137_1.input_text_id] = var_137_5
			arg_137_5.caret_index = var_137_6
			arg_137_5.input_mode = var_137_7
		end
	end
}

local function var_0_41(arg_138_0, arg_138_1)
	local var_138_0 = arg_138_0.definition.content_check_function

	if var_138_0 and not var_138_0(arg_138_0.content, arg_138_0.style, arg_138_1) then
		arg_138_0.visible = false
	end

	local var_138_1 = arg_138_0.definition.content_change_function

	if arg_138_0.visible and var_138_1 then
		var_138_1(arg_138_0.content, arg_138_0.style, arg_138_1)
	end
end

local function var_0_42(arg_139_0)
	arg_139_0.visible = arg_139_0.content.visible ~= false
end

UIPasses.auto_layout = {
	init = function(arg_140_0, arg_140_1, arg_140_2)
		local var_140_0 = {}
		local var_140_1 = arg_140_0.sub_passes
		local var_140_2 = arg_140_0.background_passes

		if arg_140_0.style_id then
			arg_140_2 = arg_140_2[arg_140_0.style_id]

			fassert(arg_140_2, "could not find style " .. arg_140_0.style_id .. "in style definitions")
		end

		if arg_140_0.content_id then
			arg_140_1 = arg_140_1[arg_140_0.content_id]

			fassert(arg_140_1, "could not find content " .. arg_140_0.content_id .. "in content definitions")
		end

		local function var_140_3(arg_141_0, arg_141_1, arg_141_2)
			local var_141_0 = arg_141_0.content_id
			local var_141_1

			if var_141_0 then
				var_141_1 = arg_141_1[var_141_0]
				var_141_1.parent = arg_141_1
			else
				var_141_1 = arg_141_1
			end

			local var_141_2 = arg_141_0.style_id
			local var_141_3

			if var_141_2 then
				var_141_3 = arg_141_2[var_141_2]
				var_141_3.parent = arg_141_2
			else
				var_141_3 = arg_141_2
			end

			return var_141_1, var_141_3
		end

		local var_140_4 = {}

		for iter_140_0, iter_140_1 in ipairs(var_140_1) do
			local var_140_5 = iter_140_1.pass_type
			local var_140_6 = UIPasses[var_140_5]
			local var_140_7, var_140_8 = var_140_3(iter_140_1, arg_140_1, arg_140_2)
			local var_140_9

			if var_140_8.render_random_debug_color then
				var_140_9 = {
					64,
					var_0_8.random(0, 255),
					var_0_8.random(0, 255),
					var_0_8.random(0, 255)
				}
			end

			var_140_4[#var_140_4 + 1] = {
				visible = true,
				definition = iter_140_1,
				data = var_140_6.init(iter_140_1, arg_140_1, arg_140_2),
				update = var_140_6.update,
				draw = var_140_6.draw,
				content = var_140_7,
				style = var_140_8,
				get_preferred_size = var_140_6.get_preferred_size,
				debug_color = var_140_9
			}
		end

		local var_140_10 = {}

		if var_140_2 then
			for iter_140_2, iter_140_3 in ipairs(var_140_2) do
				local var_140_11 = iter_140_3.pass_type
				local var_140_12 = UIPasses[var_140_11]
				local var_140_13, var_140_14 = var_140_3(iter_140_3, arg_140_1, arg_140_2)
				local var_140_15

				if var_140_14.render_random_debug_color then
					var_140_15 = {
						64,
						var_0_8.random(0, 255),
						var_0_8.random(0, 255),
						var_0_8.random(0, 255)
					}
				end

				var_140_10[#var_140_10 + 1] = {
					visible = true,
					definition = iter_140_3,
					data = var_140_12.init(iter_140_3, arg_140_1, arg_140_2),
					update = var_140_12.update,
					draw = var_140_12.draw,
					content = var_140_13,
					style = var_140_14,
					get_preferred_size = var_140_12.get_preferred_size,
					debug_color = var_140_15
				}
			end
		end

		var_140_0.passes = var_140_4
		var_140_0.background_passes = var_140_10
		var_140_0._size_table = {
			0,
			0
		}

		return var_140_0
	end,
	update = function(arg_142_0, arg_142_1, arg_142_2, arg_142_3, arg_142_4, arg_142_5, arg_142_6, arg_142_7, arg_142_8)
		local var_142_0 = 0
		local var_142_1 = 0
		local var_142_2 = 0
		local var_142_3 = 0
		local var_142_4 = arg_142_4 and arg_142_4.layout_delta_x or 0
		local var_142_5 = arg_142_4 and arg_142_4.layout_delta_y or 1
		local var_142_6 = var_142_4 < 0 and 1 or 0
		local var_142_7 = var_142_5 < 0 and 1 or 0
		local var_142_8 = 0
		local var_142_9 = 0

		for iter_142_0, iter_142_1 in ipairs(arg_142_1.passes) do
			var_0_42(iter_142_1, arg_142_5, arg_142_4)
			var_0_41(iter_142_1, iter_142_0)

			if iter_142_1.update then
				iter_142_1.update(arg_142_0, iter_142_1.data, arg_142_2, iter_142_1.definition, iter_142_1.style, iter_142_1.content, arg_142_6, arg_142_7, iter_142_1.visible)
			end

			if iter_142_1.visible then
				local var_142_10
				local var_142_11

				if iter_142_1.style and iter_142_1.style.size then
					var_142_10, var_142_11 = iter_142_1.style.size[1], iter_142_1.style.size[2]
				end

				if iter_142_1.style then
					if iter_142_1.style.dynamic_width then
						fassert(iter_142_1.get_preferred_size, "pass of type '" .. iter_142_1.definition.pass_type .. "' does not support dynamic_size")

						var_142_10 = iter_142_1.get_preferred_size(arg_142_0, iter_142_1.data, arg_142_2, iter_142_1.definition, iter_142_1.style, iter_142_1.content, arg_142_6, arg_142_7, iter_142_1.visible)
					elseif iter_142_1.style.dynamic_height then
						fassert(iter_142_1.get_preferred_size, "pass of type '" .. iter_142_1.definition.pass_type .. "' does not support dynamic_size")

						local var_142_12
						local var_142_13

						var_142_13, var_142_11 = iter_142_1.get_preferred_size(arg_142_0, iter_142_1.data, arg_142_2, iter_142_1.definition, iter_142_1.style, iter_142_1.content, arg_142_6, arg_142_7, iter_142_1.visible)
					elseif iter_142_1.style.dynamic_size then
						fassert(iter_142_1.get_preferred_size, "pass of type '" .. iter_142_1.definition.pass_type .. "' does not support dynamic_size")

						var_142_10, var_142_11 = iter_142_1.get_preferred_size(arg_142_0, iter_142_1.data, arg_142_2, iter_142_1.definition, iter_142_1.style, iter_142_1.content, arg_142_6, arg_142_7, iter_142_1.visible)
					end
				end

				var_142_10 = var_142_10 or 0
				var_142_11 = var_142_11 or 0
				iter_142_1.wanted_width = var_142_10 + (iter_142_1.style.layout_left_padding or 0) + (iter_142_1.style.layout_right_padding or 0)
				iter_142_1.wanted_height = var_142_11 + (iter_142_1.style.layout_top_padding or 0) + (iter_142_1.style.layout_bottom_padding or 0)
				iter_142_1.layout_pos_x = var_142_8 + iter_142_1.wanted_width * var_142_4 * var_142_6
				iter_142_1.layout_pos_y = var_142_9 + iter_142_1.wanted_height * var_142_5 * var_142_7
				var_142_0 = var_0_8.min(var_142_0, iter_142_1.layout_pos_x)
				var_142_1 = var_0_8.min(var_142_1, iter_142_1.layout_pos_y)
				var_142_2 = var_0_8.max(var_142_2, iter_142_1.layout_pos_x + iter_142_1.wanted_width)
				var_142_3 = var_0_8.max(var_142_3, iter_142_1.layout_pos_y + iter_142_1.wanted_height)

				local var_142_14 = iter_142_1.style and iter_142_1.style.offset

				if var_142_14 then
					iter_142_1.layout_pos_x = iter_142_1.layout_pos_x + var_142_14[1]
					iter_142_1.layout_pos_y = iter_142_1.layout_pos_y + var_142_14[2]
				end

				var_142_9 = var_142_9 + iter_142_1.wanted_height * var_142_5
				var_142_8 = var_142_8 + iter_142_1.wanted_width * var_142_4
			end
		end

		arg_142_1.layout_min_x = var_142_0
		arg_142_1.layout_min_y = var_142_1
		arg_142_1.layout_max_x = var_142_2
		arg_142_1.layout_max_y = var_142_3

		for iter_142_2, iter_142_3 in ipairs(arg_142_1.background_passes) do
			var_0_42(iter_142_3, arg_142_5, arg_142_4)
			var_0_41(iter_142_3, iter_142_2)

			if iter_142_3.update then
				iter_142_3.update(arg_142_0, iter_142_3.data, arg_142_2, iter_142_3.definition, iter_142_3.style, iter_142_3.content, arg_142_6, arg_142_7, iter_142_3.visible)
			end
		end
	end,
	draw = function(arg_143_0, arg_143_1, arg_143_2, arg_143_3, arg_143_4, arg_143_5, arg_143_6, arg_143_7, arg_143_8, arg_143_9)
		local var_143_0 = arg_143_1.layout_max_x - arg_143_1.layout_min_x
		local var_143_1 = arg_143_1.layout_max_y - arg_143_1.layout_min_y
		local var_143_2
		local var_143_3

		if arg_143_4.horizontal_alignment == "center" then
			var_143_2 = arg_143_6[1] + arg_143_7[1] / 2 - var_143_0 / 2
		elseif arg_143_4.horizontal_alignment == "right" then
			var_143_2 = arg_143_6[1] + arg_143_7[1] - var_143_0
		else
			var_143_2 = arg_143_6[1]
		end

		if arg_143_4.vertical_alignment == "center" then
			var_143_3 = arg_143_6[2] + arg_143_7[2] / 2 - var_143_1 / 2
		elseif arg_143_4.vertical_alignment == "top" then
			var_143_3 = arg_143_6[2] + arg_143_7[2] - var_143_1
		else
			var_143_3 = arg_143_6[2]
		end

		local var_143_4 = arg_143_4.screen_padding

		if var_143_4 then
			local var_143_5 = RESOLUTION_LOOKUP.inv_scale
			local var_143_6 = RESOLUTION_LOOKUP.res_w * var_143_5
			local var_143_7 = RESOLUTION_LOOKUP.res_h * var_143_5
			local var_143_8 = var_143_4.top

			if var_143_8 then
				local var_143_9 = var_143_7 - var_143_8 - (var_143_3 + var_143_1)

				if var_143_9 < 0 then
					var_143_3 = var_143_3 + var_143_9
				end
			end

			local var_143_10 = var_143_4.right

			if var_143_10 then
				local var_143_11 = var_143_6 - var_143_10 - (var_143_2 + var_143_0)

				if var_143_11 < 0 then
					var_143_2 = var_143_2 + var_143_11
				end
			end

			local var_143_12 = var_143_4.bottom

			if var_143_12 then
				local var_143_13 = var_143_3 - var_143_12

				if var_143_13 < 0 then
					var_143_3 = var_143_3 - var_143_13
				end
			end

			local var_143_14 = var_143_4.left

			if var_143_14 then
				local var_143_15 = var_143_2 - var_143_14

				if var_143_15 < 0 then
					var_143_2 = var_143_2 - var_143_15
				end
			end
		end

		arg_143_1._size_table[1] = var_143_0
		arg_143_1._size_table[2] = var_143_1

		local var_143_16 = Vector3(0, 0, 0)
		local var_143_17 = arg_143_4 and arg_143_4.layout_delta_x or 0
		local var_143_18 = arg_143_4 and arg_143_4.layout_delta_y or 1
		local var_143_19 = var_143_17 < 0 and 1 or 0
		local var_143_20 = var_143_18 < 0 and 1 or 0
		local var_143_21 = arg_143_1.background_passes

		for iter_143_0 = 1, #var_143_21 do
			local var_143_22 = var_143_21[iter_143_0]

			if var_143_22.visible then
				var_143_16.x = var_143_2 - (var_143_22.style.layout_left_padding or 0)
				var_143_16.y = var_143_3 - (var_143_22.style.layout_bottom_padding or 0)
				var_143_16.z = arg_143_6[3]

				local var_143_23 = var_143_22.style and var_143_22.style.offset

				if var_143_23 then
					var_143_16.x = var_143_16.x + var_143_23[1]
					var_143_16.y = var_143_16.y + var_143_23[2]
					var_143_16.z = var_143_16.z + var_143_23[3]
				end

				arg_143_1._size_table[1] = var_143_0 + (var_143_22.style.layout_left_padding or 0) + (var_143_22.style.layout_right_padding or 0)
				arg_143_1._size_table[2] = var_143_1 + (var_143_22.style.layout_bottom_padding or 0) + (var_143_22.style.layout_top_padding or 0)

				if var_143_22.debug_color then
					var_0_0.draw_rect(arg_143_0, var_143_16, arg_143_1._size_table, var_143_22.debug_color)
				end

				var_143_22.draw(arg_143_0, var_143_22.data, arg_143_2, var_143_22.definition, var_143_22.style, var_143_22.content, var_143_16, arg_143_1._size_table, arg_143_8, arg_143_9)
			end
		end

		local var_143_24 = arg_143_1.passes

		for iter_143_1 = 1, #var_143_24 do
			local var_143_25 = var_143_24[iter_143_1]

			if var_143_25.visible then
				var_143_16[1] = var_143_2 + var_143_25.layout_pos_x - var_143_0 * var_143_17 * var_143_19
				var_143_16[2] = var_143_3 + var_143_25.layout_pos_y - var_143_1 * var_143_18 * var_143_20
				var_143_16[3] = arg_143_6[3]

				local var_143_26 = arg_143_1.style and arg_143_1.style.offset

				if var_143_26 then
					var_143_16[3] = var_143_16[3] + var_143_26[3]
				end

				local var_143_27 = var_143_25.style and var_143_25.style.offset

				if var_143_27 then
					var_143_16[3] = var_143_16[3] + var_143_27[3]
				end

				if var_143_25.definition.pass_type == "auto_layout" then
					arg_143_1._size_table[1] = var_143_0
					arg_143_1._size_table[2] = var_143_1
				else
					arg_143_1._size_table[1] = var_143_25.style.fill_width and var_143_0 or var_143_25.wanted_width
					arg_143_1._size_table[2] = var_143_25.style.fill_height and var_143_1 or var_143_25.wanted_height
				end

				if var_143_25.debug_color then
					var_0_0.draw_rect(arg_143_0, var_143_16, arg_143_1._size_table, var_143_25.debug_color)
				end

				var_143_25.draw(arg_143_0, var_143_25.data, arg_143_2, var_143_25.definition, var_143_25.style, var_143_25.content, var_143_16, arg_143_1._size_table, arg_143_8, arg_143_9)
			end
		end
	end,
	get_preferred_size = function(arg_144_0, arg_144_1, arg_144_2, arg_144_3, arg_144_4, arg_144_5, arg_144_6, arg_144_7, arg_144_8)
		local var_144_0 = arg_144_1.layout_max_x - arg_144_1.layout_min_x
		local var_144_1 = arg_144_1.layout_max_y - arg_144_1.layout_min_y

		return var_144_0, var_144_1
	end
}
