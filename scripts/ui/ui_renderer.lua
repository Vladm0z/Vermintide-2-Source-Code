-- chunkname: @scripts/ui/ui_renderer.lua

print("[UIRenderer] Loading")
require("scripts/utils/strict_table")
require("scripts/ui/ui_scenegraph")
require("scripts/ui/ui_resolution")
require("scripts/utils/debug_key_handler")
require("scripts/helpers/ui_atlas_helper")

script_data.ui_debug_scenegraph = script_data.ui_debug_scenegraph or Development.parameter("ui_debug_scenegraph")
script_data.ui_debug_pixeldistance = script_data.ui_debug_pixeldistance or Development.parameter("ui_debug_pixeldistance")
script_data.ui_debug_draw_texture = script_data.ui_debug_draw_texture or Development.parameter("ui_debug_draw_texture")

local var_0_0 = Color
local var_0_1 = Vector2
local var_0_2 = Vector3
local var_0_3 = Gui.bitmap_uv
local var_0_4 = Gui.bitmap
local var_0_5 = Gui.update_bitmap_uv
local var_0_6 = Gui.update_bitmap
local var_0_7 = RESOLUTION_LOOKUP
local var_0_8 = UIAtlasHelper

UIRenderer = {}

local var_0_9 = UIRenderer

SNAP_PIXEL_POSITIONS = true

local var_0_10 = {
	{
		0,
		0
	},
	{
		1,
		1
	}
}

local function var_0_11(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = arg_1_1[2] - arg_1_0[2]
	local var_1_1 = arg_1_1[1] - arg_1_0[1]

	var_0_10[1][2] = arg_1_0[2] + var_1_0 * arg_1_2[1][2]
	var_0_10[2][2] = arg_1_0[2] + var_1_0 * arg_1_2[2][2]
	var_0_10[1][1] = arg_1_0[1] + var_1_1 * arg_1_2[1][1]
	var_0_10[2][1] = arg_1_0[1] + var_1_1 * arg_1_2[2][1]

	return var_0_10
end

local function var_0_12(arg_2_0)
	if var_0_7.scale >= 1 then
		arg_2_0[1] = math.round(arg_2_0[1])
		arg_2_0[2] = math.round(arg_2_0[2])
	end

	return arg_2_0
end

var_0_9.script_draw_bitmap = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7, arg_3_8, arg_3_9, arg_3_10)
	local var_3_0 = arg_3_1 and arg_3_1.snap_pixel_positions

	if var_3_0 == nil then
		var_3_0 = SNAP_PIXEL_POSITIONS
	end

	if var_3_0 then
		arg_3_3 = var_0_12(arg_3_3)
	end

	local var_3_1 = arg_3_1 and arg_3_1.alpha_multiplier or 1
	local var_3_2

	if var_0_8.has_atlas_settings_by_texture_name(arg_3_2) then
		var_3_2 = var_0_8.get_atlas_settings_by_texture_name(arg_3_2)
	end

	if not arg_3_5 then
		arg_3_5 = var_0_0(255 * var_3_1, 255, 255, 255)
	else
		arg_3_5 = var_0_0(arg_3_5[1] * var_3_1, arg_3_5[2], arg_3_5[3], arg_3_5[4])
	end

	if var_3_2 then
		local var_3_3 = var_3_2.uv00
		local var_3_4 = var_3_2.uv11
		local var_3_5 = var_0_1(var_3_3[1], var_3_3[2])
		local var_3_6 = var_0_1(var_3_4[1], var_3_4[2])
		local var_3_7

		if not arg_3_6 then
			if arg_3_7 then
				var_3_7 = var_3_2.saturated_material_name
			elseif arg_3_9 then
				var_3_7 = var_3_2.point_sample_material_name
			elseif arg_3_10 then
				var_3_7 = var_3_2.viewport_mask_material_name
			else
				var_3_7 = var_3_2.material_name
			end
		elseif arg_3_7 then
			var_3_7 = var_3_2.masked_saturated_material_name
		elseif arg_3_9 then
			var_3_7 = var_3_2.masked_point_sample_material_name
		else
			var_3_7 = var_3_2.masked_material_name
		end

		if arg_3_8 then
			var_0_5(arg_3_0, arg_3_8, var_3_7, var_3_5, var_3_6, arg_3_3, arg_3_4, arg_3_5)
		else
			return var_0_3(arg_3_0, var_3_7, var_3_5, var_3_6, arg_3_3, arg_3_4, arg_3_5)
		end
	elseif arg_3_8 then
		var_0_6(arg_3_0, arg_3_8, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	else
		return var_0_4(arg_3_0, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	end
end

var_0_9.script_draw_bitmap_uv = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7, arg_4_8, arg_4_9, arg_4_10, arg_4_11)
	local var_4_0 = arg_4_1 and arg_4_1.snap_pixel_positions

	if var_4_0 == nil then
		var_4_0 = SNAP_PIXEL_POSITIONS
	end

	if var_4_0 then
		arg_4_4 = var_0_12(arg_4_4)
	end

	local var_4_1 = arg_4_1 and arg_4_1.alpha_multiplier or 1

	arg_4_6 = arg_4_6 and var_0_0(arg_4_6[1] * var_4_1, arg_4_6[2], arg_4_6[3], arg_4_6[4])

	local var_4_2

	if var_0_8.has_atlas_settings_by_texture_name(arg_4_2) then
		var_4_2 = var_0_8.get_atlas_settings_by_texture_name(arg_4_2)
	end

	if var_4_2 then
		local var_4_3 = var_0_11(var_4_2.uv00, var_4_2.uv11, arg_4_3)
		local var_4_4 = var_4_3[1]
		local var_4_5 = var_4_3[2]
		local var_4_6 = var_0_1(var_4_4[1], var_4_4[2])
		local var_4_7 = var_0_1(var_4_5[1], var_4_5[2])
		local var_4_8

		if arg_4_7 then
			var_4_8 = var_4_2.masked_material_name
		elseif arg_4_8 then
			var_4_8 = var_4_2.saturated_material_name
		elseif arg_4_11 then
			var_4_8 = var_4_2.viewport_mask_material_name
		else
			var_4_8 = var_4_2.material_name
		end

		if arg_4_9 then
			var_0_5(arg_4_0, arg_4_9, var_4_8, var_4_6, var_4_7, arg_4_4, arg_4_5, arg_4_6)
		else
			return var_0_3(arg_4_0, var_4_8, var_4_6, var_4_7, arg_4_4, arg_4_5, arg_4_6)
		end
	else
		local var_4_9 = arg_4_3[1]
		local var_4_10 = arg_4_3[2]

		if arg_4_9 then
			var_0_5(arg_4_0, arg_4_9, arg_4_2, var_0_1(var_4_9[1], var_4_9[2]), var_0_1(var_4_10[1], var_4_10[2]), arg_4_4, arg_4_5, arg_4_6)
		else
			return var_0_3(arg_4_0, arg_4_2, var_0_1(var_4_9[1], var_4_9[2]), var_0_1(var_4_10[1], var_4_10[2]), arg_4_4, arg_4_5, arg_4_6)
		end
	end
end

local var_0_13 = Gui.update_bitmap_3d_uv
local var_0_14 = Gui.bitmap_3d_uv
local var_0_15 = Gui.update_bitmap_3d
local var_0_16 = Gui.bitmap_3d

var_0_9.script_draw_bitmap_3d = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8, arg_5_9)
	local var_5_0 = arg_5_1 and arg_5_1.alpha_multiplier or 1

	arg_5_6 = arg_5_6 and var_0_0(arg_5_6[1] * var_5_0, arg_5_6[2], arg_5_6[3], arg_5_6[4])

	local var_5_1

	if var_0_8.has_atlas_settings_by_texture_name(arg_5_2) then
		var_5_1 = var_0_8.get_atlas_settings_by_texture_name(arg_5_2)
	end

	if var_5_1 then
		local var_5_2

		if arg_5_8 then
			var_5_2 = var_5_1.masked_material_name
		else
			var_5_2 = var_5_1.material_name
		end

		local var_5_3
		local var_5_4

		if arg_5_7 then
			local var_5_5 = var_0_11(var_5_1.uv00, var_5_1.uv11, arg_5_7)
			local var_5_6 = var_5_5[1]
			local var_5_7 = var_5_5[2]

			var_5_3 = var_0_1(var_5_6[1], var_5_6[2])
			var_5_4 = var_0_1(var_5_7[1], var_5_7[2])
		else
			var_5_3, var_5_4 = var_5_1.uv00, var_5_1.uv11
		end

		if arg_5_9 then
			return var_0_13(arg_5_0, arg_5_9, var_5_2, var_0_1(var_5_3[1], var_5_3[2]), var_0_1(var_5_4[1], var_5_4[2]), arg_5_3, var_0_2.zero(), arg_5_4, arg_5_5, arg_5_6)
		else
			return var_0_14(arg_5_0, var_5_2, var_0_1(var_5_3[1], var_5_3[2]), var_0_1(var_5_4[1], var_5_4[2]), arg_5_3, var_0_2.zero(), arg_5_4, arg_5_5, arg_5_6)
		end
	elseif arg_5_7 then
		local var_5_8 = arg_5_7[1]
		local var_5_9 = arg_5_7[2]
		local var_5_10
		local var_5_11
		local var_5_12 = var_0_1(var_5_8[1], var_5_8[2])
		local var_5_13 = var_0_1(var_5_9[1], var_5_9[2])

		if arg_5_9 then
			return var_0_13(arg_5_0, arg_5_9, arg_5_2, var_0_1(var_5_12[1], var_5_12[2]), var_0_1(var_5_13[1], var_5_13[2]), arg_5_3, var_0_2.zero(), arg_5_4, arg_5_5, arg_5_6)
		else
			return var_0_14(arg_5_0, arg_5_2, var_0_1(var_5_12[1], var_5_12[2]), var_0_1(var_5_13[1], var_5_13[2]), arg_5_3, var_0_2.zero(), arg_5_4, arg_5_5, arg_5_6)
		end
	elseif arg_5_9 then
		return var_0_15(arg_5_0, arg_5_9, arg_5_2, arg_5_3, var_0_2.zero(), arg_5_4, arg_5_5, arg_5_6)
	else
		return var_0_16(arg_5_0, arg_5_2, arg_5_3, var_0_2.zero(), arg_5_4, arg_5_5, arg_5_6)
	end
end

var_0_9._injected_material_sets = {}

local function var_0_17(arg_6_0, ...)
	local var_6_0 = var_0_9._injected_material_sets[arg_6_0]

	if var_6_0 then
		return "material", var_6_0, var_0_17(arg_6_0 + 1, ...)
	end

	return ...
end

var_0_9.create = function (arg_7_0, ...)
	local var_7_0 = World.create_screen_gui(arg_7_0, "immediate", var_0_17(1, ...))
	local var_7_1 = World.create_screen_gui(arg_7_0, var_0_17(1, ...))

	return var_0_9.create_ui_renderer(arg_7_0, var_7_0, var_7_1)
end

local var_0_18 = table.set({
	"gui",
	"gui_retained",
	"ui_scenegraph",
	"scenegraph_queue",
	"input_service",
	"dt",
	"video_players",
	"world",
	"wwise_world",
	"render_settings",
	"debug_startpoint"
})

var_0_9.create_ui_renderer = function (arg_8_0, arg_8_1, arg_8_2)
	return table.make_strict({
		gui = arg_8_1,
		gui_retained = arg_8_2,
		scenegraph_queue = {},
		video_players = {},
		world = arg_8_0,
		wwise_world = Managers.world:wwise_world(arg_8_0)
	}, var_0_18)
end

var_0_9.create_video_player = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	if script_data.disable_video_player then
		return
	end

	local var_9_0 = arg_9_0.video_players

	assert(not var_9_0[arg_9_1])

	local var_9_1 = arg_9_2 or arg_9_0.world
	local var_9_2 = World.create_video_player(var_9_1, arg_9_3, arg_9_4)

	var_9_0[arg_9_1] = var_9_2

	if arg_9_4 == false then
		VideoPlayer.set_loop(var_9_2, false)
	end
end

var_0_9.destroy_video_player = function (arg_10_0, arg_10_1, arg_10_2)
	if script_data.disable_video_player then
		return
	end

	local var_10_0 = arg_10_0.video_players
	local var_10_1 = var_10_0[arg_10_1]

	assert(var_10_1)
	World.destroy_video_player(arg_10_2 or arg_10_0.world, var_10_1)

	var_10_0[arg_10_1] = nil
end

var_0_9.destroy = function (arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0.video_players

	for iter_11_0, iter_11_1 in pairs(var_11_0) do
		World.destroy_video_player(arg_11_1 or arg_11_0.world, iter_11_1)

		var_11_0[iter_11_0] = nil
	end

	arg_11_1 = arg_11_1 or arg_11_0.world

	World.destroy_gui(arg_11_1, arg_11_0.gui)
	World.destroy_gui(arg_11_1, arg_11_0.gui_retained)
end

var_0_9.clear_scenegraph_queue = function (arg_12_0)
	arg_12_0.ui_scenegraph = nil

	table.clear(arg_12_0.scenegraph_queue)
end

var_0_9.begin_pass = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
	if arg_13_0.ui_scenegraph then
		local var_13_0 = arg_13_0.ui_scenegraph

		arg_13_0.scenegraph_queue[#arg_13_0.scenegraph_queue + 1] = var_13_0
		arg_13_0.ui_scenegraph = arg_13_1

		assert(arg_13_4, "Must provide parent scenegraph id when building multiple depth passes.")
		UISceneGraph.update_scenegraph(arg_13_1, var_13_0, arg_13_4)
	else
		arg_13_0.ui_scenegraph = arg_13_1

		UISceneGraph.update_scenegraph(arg_13_1)
	end

	arg_13_0.ui_scenegraph = arg_13_1
	arg_13_0.input_service = arg_13_2
	arg_13_0.dt = arg_13_3
	arg_13_0.render_settings = arg_13_5
end

var_0_9.end_pass = function (arg_14_0)
	arg_14_0.render_settings = nil

	local var_14_0 = arg_14_0.scenegraph_queue
	local var_14_1 = #var_14_0

	if var_14_1 > 0 then
		arg_14_0.ui_scenegraph = var_14_0[var_14_1]
		var_14_0[var_14_1] = nil
	else
		arg_14_0.ui_scenegraph = nil
	end
end

local var_0_19 = {
	alpha_multiplier = 1
}

var_0_9.draw_all_widgets = function (arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0.render_settings or var_0_19
	local var_15_1 = var_15_0.alpha_multiplier or 1
	local var_15_2 = var_0_9.draw_widget

	for iter_15_0, iter_15_1 in pairs(arg_15_1) do
		var_15_0.alpha_multiplier = (iter_15_1.content.alpha_multiplier or 1) * var_15_1

		var_15_2(arg_15_0, iter_15_1)
	end

	var_15_0.alpha_multiplier = var_15_1
end

local var_0_20 = Profiler.start
local var_0_21 = Profiler.stop

var_0_9.draw_widget = function (arg_16_0, arg_16_1)
	local var_16_0 = arg_16_1.animations

	if next(var_16_0) then
		for iter_16_0 in pairs(var_16_0) do
			UIAnimation.update(iter_16_0, arg_16_0.dt)

			if UIAnimation.completed(iter_16_0) then
				var_16_0[iter_16_0] = nil
			end
		end
	end

	local var_16_1 = UIPasses
	local var_16_2 = UISceneGraph.get_size_scaled
	local var_16_3 = arg_16_0.ui_scenegraph
	local var_16_4 = arg_16_0.input_service
	local var_16_5 = arg_16_0.dt
	local var_16_6 = arg_16_1.scenegraph_id
	local var_16_7 = var_16_3[var_16_6].world_position
	local var_16_8 = arg_16_1.offset or UISceneGraph.ZERO_VECTOR3
	local var_16_9 = var_16_7[1] + var_16_8[1]
	local var_16_10 = var_16_7[2] + var_16_8[2]
	local var_16_11 = var_16_7[3] + var_16_8[3]
	local var_16_12 = arg_16_1.content
	local var_16_13 = arg_16_1.style
	local var_16_14 = var_16_2(var_16_3, var_16_6)
	local var_16_15 = true
	local var_16_16 = Managers.input

	if var_16_16 then
		local var_16_17 = var_16_16:is_device_active("gamepad")

		var_16_12.is_gamepad_active = var_16_17

		if var_16_12.disable_with_gamepad then
			var_16_15 = not var_16_17
		end
	end

	local var_16_18 = arg_16_1.element
	local var_16_19 = var_16_18.dirty
	local var_16_20 = var_16_18.passes
	local var_16_21 = var_16_18.pass_data

	for iter_16_1 = 1, #var_16_20 do
		local var_16_22 = var_16_20[iter_16_1]
		local var_16_23 = var_16_22.pass_type
		local var_16_24 = var_16_15

		if var_16_12.visible == false then
			var_16_24 = false
		end

		local var_16_25 = var_16_12
		local var_16_26 = var_16_22.content_id

		if var_16_26 then
			var_16_25 = var_16_12[var_16_26]

			if not var_16_25 then
				var_16_25 = var_16_12
			else
				var_16_25.parent = var_16_12

				if var_16_25.visible == false then
					var_16_24 = false
				end
			end
		end

		local var_16_27 = var_16_13
		local var_16_28 = var_16_22.style_id

		if var_16_28 then
			var_16_27 = var_16_13[var_16_28]

			if var_16_27 then
				var_16_27.parent = var_16_13
			else
				var_16_27 = var_16_13
			end
		end

		if var_16_24 then
			local var_16_29 = var_16_22.content_check_function

			if var_16_29 then
				var_16_24 = not not var_16_29(var_16_25, var_16_27)
			end

			if var_16_24 then
				local var_16_30 = var_16_22.content_change_function

				if var_16_30 then
					var_16_30(var_16_25, var_16_27, var_16_0, var_16_5, arg_16_0.render_settings)
				end
			end
		end

		local var_16_31 = var_16_1[var_16_23]
		local var_16_32 = var_16_21[iter_16_1]

		if var_16_31.update then
			var_16_31.update(arg_16_0, var_16_32, var_16_3, var_16_22, var_16_27, var_16_25, var_16_4, var_16_5, var_16_24)
		end

		if var_16_22.retained_mode then
			if var_16_24 == not var_16_32.visible then
				var_16_32.visible = var_16_24

				if var_16_24 then
					var_16_32.dirty = true
				else
					var_16_31.destroy(arg_16_0, var_16_32, var_16_22)

					goto label_16_0
				end
			end

			if not var_16_19 and not var_16_32.dirty then
				goto label_16_0
			end
		end

		if var_16_24 then
			local var_16_33 = var_16_14
			local var_16_34 = var_16_9
			local var_16_35 = var_16_10
			local var_16_36 = var_16_11
			local var_16_37 = var_16_27.scenegraph_id or var_16_22.scenegraph_id

			if var_16_37 then
				var_16_33 = var_16_2(var_16_3, var_16_37)

				local var_16_38 = var_16_3[var_16_37].world_position

				var_16_34, var_16_35, var_16_36 = var_16_38[1], var_16_38[2], var_16_38[3]
			end

			local var_16_39 = var_16_27.size

			if var_16_39 then
				var_16_33 = var_0_1(var_16_39[1] or var_16_33[1], var_16_39[2] or var_16_33[2])
			end

			local var_16_40 = var_16_27.offset

			if var_16_40 then
				var_16_34 = var_16_34 + var_16_40[1]
				var_16_35 = var_16_35 + var_16_40[2]
				var_16_36 = var_16_36 + (var_16_40[3] or 0)
			end

			var_16_31.draw(arg_16_0, var_16_32, var_16_3, var_16_22, var_16_27, var_16_25, var_0_2(var_16_34, var_16_35, var_16_36), var_16_33, var_16_4, var_16_5)
		end

		::label_16_0::
	end

	var_16_18.dirty = nil
end

var_0_9.set_element_visible = function (arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = UIPasses
	local var_17_1 = arg_17_1.pass_data
	local var_17_2 = arg_17_1.passes

	for iter_17_0 = 1, #var_17_2 do
		local var_17_3 = var_17_2[iter_17_0]

		if var_17_3.retained_mode then
			local var_17_4 = var_17_1[iter_17_0]

			if arg_17_2 ~= var_17_4.visible then
				if arg_17_2 then
					var_17_4.dirty = true
				else
					var_17_0[var_17_3.pass_type].destroy(arg_17_0, var_17_4, var_17_3)
				end

				var_17_4.visible = arg_17_2
			end
		end
	end
end

var_0_9.draw_rect = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	local var_18_0 = arg_18_0.render_settings
	local var_18_1 = var_18_0 and var_18_0.snap_pixel_positions

	if var_18_1 == nil then
		var_18_1 = SNAP_PIXEL_POSITIONS
	end

	if var_18_1 then
		arg_18_1 = var_0_12(arg_18_1)
	end

	local var_18_2 = UIScaleVectorToResolution(arg_18_1)
	local var_18_3 = UIScaleVectorToResolution(arg_18_2)
	local var_18_4 = var_18_0 and var_18_0.alpha_multiplier or 1

	arg_18_3 = var_0_0(arg_18_3[1] * var_18_4, arg_18_3[2], arg_18_3[3], arg_18_3[4])

	if arg_18_4 == true then
		return Gui.rect(arg_18_0.gui_retained, var_18_2, var_18_3, arg_18_3)
	elseif arg_18_4 then
		return Gui.update_rect(arg_18_0.gui_retained, arg_18_4, var_18_2, var_18_3, arg_18_3)
	else
		return Gui.rect(arg_18_0.gui, var_18_2, var_18_3, arg_18_3)
	end
end

var_0_9.draw_triangle = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	local var_19_0 = arg_19_0.render_settings
	local var_19_1 = var_19_0 and var_19_0.alpha_multiplier or 1
	local var_19_2 = var_0_0(arg_19_3.color[1] * var_19_1, arg_19_3.color[2], arg_19_3.color[3], arg_19_3.color[4])
	local var_19_3 = arg_19_1[3]
	local var_19_4 = var_0_2(arg_19_1[1], 0, arg_19_1[2])
	local var_19_5
	local var_19_6
	local var_19_7

	if arg_19_3.triangle_alignment == "top_left" then
		var_19_5 = var_19_4
		var_19_6 = var_19_4 + var_0_2(0, 0, arg_19_2[2])
		var_19_7 = var_19_4 + var_0_2(arg_19_2[1], 0, arg_19_2[2])
	elseif arg_19_3.triangle_alignment == "top_right" then
		var_19_5 = var_19_4 + var_0_2(0, 0, arg_19_2[2])
		var_19_6 = var_19_4 + var_0_2(arg_19_2[1], 0, arg_19_2[2])
		var_19_7 = var_19_4 + var_0_2(arg_19_2[1], 0, 0)
	elseif arg_19_3.triangle_alignment == "bottom_left" then
		var_19_5 = var_19_4
		var_19_6 = var_19_4 + var_0_2(arg_19_2[1], 0, 0)
		var_19_7 = var_19_4 + var_0_2(0, 0, arg_19_2[2])
	elseif arg_19_3.triangle_alignment == "up" then
		var_19_5 = var_19_4
		var_19_6 = var_19_4 + var_0_2(arg_19_2[1], 0, 0)
		var_19_7 = var_19_4 + var_0_2(arg_19_2[1] * 0.5, 0, arg_19_2[2])
	elseif arg_19_3.triangle_alignment == "down" then
		var_19_5 = var_19_4 + var_0_2(0, 0, arg_19_2[2])
		var_19_6 = var_19_4 + var_0_2(arg_19_2[1] * 0.5, 0, 0)
		var_19_7 = var_19_4 + var_0_2(arg_19_2[1], 0, arg_19_2[2])
	elseif arg_19_3.triangle_alignment == "left" then
		var_19_5 = var_19_4 + var_0_2(0, 0, arg_19_2[2] * 0.5)
		var_19_6 = var_19_4 + var_0_2(arg_19_2[1], 0, 0)
		var_19_7 = var_19_4 + var_0_2(0, 0, arg_19_2[2])
	elseif arg_19_3.triangle_alignment == "right" then
		var_19_5 = var_19_4 + var_0_2(0, 0, arg_19_2[2])
		var_19_6 = var_19_4 + var_0_2(arg_19_2[1], 0, arg_19_2[2] * 0.5)
		var_19_7 = var_19_4 + var_0_2(0, 0, 0)
	else
		var_19_5 = var_19_4
		var_19_6 = var_19_4 + var_0_2(arg_19_2[1], 0, 0)
		var_19_7 = var_19_4 + var_0_2(arg_19_2[1], 0, arg_19_2[2])
	end

	if arg_19_4 == true then
		return Gui.triangle(arg_19_0.gui_retained, UIScaleVectorToResolutionRealCoordinates(var_19_5), UIScaleVectorToResolutionRealCoordinates(var_19_6), UIScaleVectorToResolutionRealCoordinates(var_19_7), var_19_3, var_19_2)
	elseif arg_19_4 then
		return Gui.update_triangle(arg_19_0.gui_retained, arg_19_4, UIScaleVectorToResolutionRealCoordinates(var_19_5), UIScaleVectorToResolutionRealCoordinates(var_19_6), UIScaleVectorToResolutionRealCoordinates(var_19_7), var_19_3, var_19_2)
	else
		return Gui.triangle(arg_19_0.gui, UIScaleVectorToResolutionRealCoordinates(var_19_5), UIScaleVectorToResolutionRealCoordinates(var_19_6), UIScaleVectorToResolutionRealCoordinates(var_19_7), var_19_3, var_19_2)
	end
end

var_0_9.draw_rect_rotated = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	arg_20_1 = UIScaleVectorToResolution(arg_20_1)

	local var_20_0 = UIScaleVectorToResolution(arg_20_4)
	local var_20_1 = Rotation2D(var_0_2.zero(), arg_20_3, var_0_1(var_20_0[1], var_20_0[2]))
	local var_20_2 = Matrix4x4.translation(var_20_1)
	local var_20_3 = UIScaleVectorToResolution(arg_20_2)

	var_20_2.x = var_20_2.x + var_20_3.x
	var_20_2.z = var_20_2.z + var_20_3.y

	Matrix4x4.set_translation(var_20_1, var_20_2)

	local var_20_4 = arg_20_0.render_settings
	local var_20_5 = var_20_4 and var_20_4.alpha_multiplier or 1

	arg_20_5 = var_0_0(arg_20_5[1] * var_20_5, arg_20_5[2], arg_20_5[3], arg_20_5[4])

	Gui.rect_3d(arg_20_0.gui, var_20_1, var_0_2.zero(), arg_20_2[3], arg_20_1, arg_20_5)
end

local var_0_22 = "arial"
local var_0_23 = "materials/fonts/" .. var_0_22

local function var_0_24(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	local var_21_0 = tostring(arg_21_1[3])
	local var_21_1 = {
		arg_21_1[1],
		arg_21_1[2],
		990
	}
	local var_21_2 = {
		64,
		255,
		0,
		0
	}
	local var_21_3 = {
		192,
		255,
		0,
		0
	}

	var_0_9.draw_rect(arg_21_0, var_21_1, {
		arg_21_2[1],
		1
	}, var_21_3)
	var_0_9.draw_rect(arg_21_0, var_21_1, {
		1,
		arg_21_2[2]
	}, var_21_3)
	var_0_9.draw_rect(arg_21_0, {
		var_21_1[1] + arg_21_2[1],
		var_21_1[2] + arg_21_2[2],
		var_21_1[3]
	}, {
		-arg_21_2[1],
		1
	}, var_21_3)
	var_0_9.draw_rect(arg_21_0, {
		var_21_1[1] + arg_21_2[1],
		var_21_1[2] + arg_21_2[2],
		var_21_1[3]
	}, {
		1,
		-arg_21_2[2]
	}, var_21_3)

	local var_21_4 = var_0_7.inv_scale

	if math.point_is_inside_2d_box(var_21_4 * Mouse.axis(2), arg_21_1, arg_21_2) then
		var_0_9.draw_rect(arg_21_0, var_21_1, arg_21_2, var_21_2)

		local var_21_5 = string.format("%s : %s", var_21_0, arg_21_3)
		local var_21_6, var_21_7 = var_0_9.text_size(arg_21_0, var_21_5, var_0_23, 12)

		var_21_1[2] = var_21_1[2] - var_21_7

		if var_21_1[1] + var_21_6 > 1920 then
			var_21_1[1] = var_21_1[1] - var_21_6 + arg_21_2[1]
		end

		if var_21_1[2] < 0 then
			var_21_1[2] = var_21_1[2] + arg_21_2[2]
		end

		var_0_9.draw_rect(arg_21_0, var_21_1, {
			var_21_6,
			var_21_7
		}, var_21_3)
		var_0_9.draw_text(arg_21_0, var_21_5, var_0_23, 12, var_0_22, {
			var_21_1[1],
			var_21_1[2] + 6,
			var_21_1[3]
		})
	end
end

local var_0_25 = {
	{
		1,
		0
	},
	{
		0,
		1
	}
}

var_0_9.draw_texture_flip_horizontal = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6)
	if script_data.ui_debug_draw_texture and Keyboard.button(Keyboard.button_index("v")) > 0 then
		var_0_24(arg_22_0, arg_22_2, arg_22_3, arg_22_1)
	end

	local var_22_0 = UIScaleVectorToResolution(arg_22_2)

	arg_22_3 = UIScaleVectorToResolution(arg_22_3)

	return var_0_9.script_draw_bitmap_uv(arg_22_0.gui, arg_22_0.render_settings, arg_22_1, var_0_25, var_22_0, arg_22_3, arg_22_4, arg_22_5, arg_22_6)
end

var_0_9.draw_texture = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6, arg_23_7, arg_23_8, arg_23_9)
	local var_23_0 = arg_23_0.gui

	if arg_23_7 then
		var_23_0 = arg_23_0.gui_retained

		if arg_23_7 == true then
			arg_23_7 = nil
		end
	end

	local var_23_1 = var_0_7.scale

	return var_0_9.script_draw_bitmap(var_23_0, arg_23_0.render_settings, arg_23_1, var_0_2(arg_23_2[1] * var_23_1, arg_23_2[2] * var_23_1, arg_23_2[3] or 0), var_0_2(arg_23_3[1] * var_23_1, arg_23_3[2] * var_23_1, arg_23_3[3] or 0), arg_23_4, arg_23_5, arg_23_6, arg_23_7, arg_23_8, arg_23_9)
end

var_0_9.draw_texture_uv = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6, arg_24_7, arg_24_8, arg_24_9, arg_24_10)
	if script_data.ui_debug_draw_texture and Keyboard.button(Keyboard.button_index("v")) > 0 then
		var_0_24(arg_24_0, arg_24_2, arg_24_3, arg_24_1)
	end

	local var_24_0 = UIScaleVectorToResolution(arg_24_2)

	arg_24_3 = UIScaleVectorToResolution(arg_24_3)

	if arg_24_8 == true then
		return var_0_9.script_draw_bitmap_uv(arg_24_0.gui_retained, arg_24_0.render_settings, arg_24_1, arg_24_4, var_24_0, arg_24_3, arg_24_5, arg_24_6, arg_24_7, nil, arg_24_9, arg_24_10)
	elseif arg_24_8 then
		return var_0_9.script_draw_bitmap_uv(arg_24_0.gui_retained, arg_24_0.render_settings, arg_24_1, arg_24_4, var_24_0, arg_24_3, arg_24_5, arg_24_6, arg_24_7, arg_24_8, arg_24_9, arg_24_10)
	else
		return var_0_9.script_draw_bitmap_uv(arg_24_0.gui, arg_24_0.render_settings, arg_24_1, arg_24_4, var_24_0, arg_24_3, arg_24_5, arg_24_6, arg_24_7, nil, arg_24_9, arg_24_10)
	end
end

var_0_9.draw_gradient_mask_texture = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6, arg_25_7)
	if script_data.ui_debug_draw_texture and Keyboard.button(Keyboard.button_index("v")) > 0 then
		var_0_24(arg_25_0, arg_25_2, arg_25_3, arg_25_1)
	end

	local var_25_0 = arg_25_0.gui
	local var_25_1 = arg_25_0.gui_retained
	local var_25_2 = UIScaleVectorToResolution(arg_25_2)
	local var_25_3 = UIScaleVectorToResolution(arg_25_3)
	local var_25_4 = var_0_8.has_atlas_settings_by_texture_name(arg_25_1) and var_0_8.get_atlas_settings_by_texture_name(arg_25_1)
	local var_25_5 = Gui.material(arg_25_7 and var_25_1 or var_25_0, var_25_4 and var_25_4.material_name or arg_25_1)

	Material.set_scalar(var_25_5, "gradient_threshold", arg_25_6)

	if arg_25_7 == true then
		return var_0_9.script_draw_bitmap(arg_25_0.gui_retained, arg_25_0.render_settings, arg_25_1, var_25_2, var_25_3, arg_25_4, arg_25_5, nil, nil)
	elseif arg_25_7 then
		return var_0_9.script_draw_bitmap(arg_25_0.gui_retained, arg_25_0.render_settings, arg_25_1, var_25_2, var_25_3, arg_25_4, arg_25_5, nil, arg_25_7)
	else
		return var_0_9.script_draw_bitmap(arg_25_0.gui, arg_25_0.render_settings, arg_25_1, var_25_2, var_25_3, arg_25_4, arg_25_5, nil)
	end
end

local var_0_26 = {}

var_0_9.draw_multi_texture = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6, arg_26_7, arg_26_8, arg_26_9, arg_26_10, arg_26_11, arg_26_12, arg_26_13, arg_26_14, arg_26_15, arg_26_16)
	local var_26_0 = var_0_9.script_draw_bitmap
	local var_26_1 = var_0_9.draw_tiled_texture

	arg_26_7 = arg_26_7 or 1
	arg_26_9 = arg_26_9 or 1

	local var_26_2 = UIScaleVectorToResolution(arg_26_2)
	local var_26_3 = var_0_2(arg_26_2[1], arg_26_2[2], arg_26_2[3])
	local var_26_4 = var_0_2(arg_26_2[1], arg_26_2[2], arg_26_2[3])

	arg_26_8 = arg_26_8 and UIScaleVectorToResolution(arg_26_8)

	local var_26_5 = arg_26_0.gui
	local var_26_6 = arg_26_0.gui_retained

	arg_26_6 = arg_26_6 or var_0_26

	local var_26_7 = arg_26_9 == 2
	local var_26_8 = arg_26_10 or #arg_26_1

	if var_26_8 <= 0 then
		return
	end

	local var_26_9

	if arg_26_16 == true then
		var_26_9 = {}
	end

	for iter_26_0 = 1, var_26_8 do
		local var_26_10 = arg_26_1[iter_26_0]

		arg_26_3 = arg_26_4 and arg_26_4[iter_26_0] or arg_26_3

		local var_26_11 = arg_26_12
		local var_26_12 = arg_26_15

		if arg_26_11 then
			var_26_11 = arg_26_11[iter_26_0] or arg_26_12
		end

		if arg_26_14 then
			var_26_12 = arg_26_14[iter_26_0] or arg_26_15
		end

		local var_26_13 = arg_26_6[iter_26_0]

		if var_26_13 then
			local var_26_14 = UIScaleVectorToResolution(var_26_13)

			if iter_26_0 == 1 and var_26_7 then
				var_26_2[arg_26_7] = var_26_2[arg_26_7] - var_26_14[arg_26_7]
				var_26_4[arg_26_7] = var_26_4[arg_26_7] - var_26_13[arg_26_7]
			end

			local var_26_15 = arg_26_5 and arg_26_5[iter_26_0]

			if var_26_15 then
				local var_26_16 = UIScaleVectorToResolution(var_26_15)

				var_26_3[1] = var_26_4[1] + var_26_16[1]
				var_26_3[2] = var_26_4[2] + var_26_16[2]
				var_26_3[3] = var_26_4[3] + var_26_16[3]
			else
				var_26_3[1] = var_26_4[1]
				var_26_3[2] = var_26_4[2]
				var_26_3[3] = var_26_4[3]
			end

			local var_26_17

			if arg_26_16 == true then
				var_26_17 = var_26_1(arg_26_0, var_26_10, var_26_3, var_26_13, arg_26_3, var_26_11, arg_26_13, arg_26_16)
			elseif arg_26_16 then
				var_26_17 = arg_26_16[iter_26_0]

				var_26_1(arg_26_0, var_26_10, var_26_3, var_26_13, arg_26_3, var_26_11, arg_26_13, var_26_17)
			else
				var_26_1(arg_26_0, var_26_10, var_26_3, var_26_13, arg_26_3, var_26_11, arg_26_13)
			end

			if var_26_9 then
				var_26_9[iter_26_0] = var_26_17
			end

			if var_26_7 then
				var_26_2[arg_26_7] = var_26_2[arg_26_7] - var_26_14[arg_26_7]
				var_26_4[arg_26_7] = var_26_4[arg_26_7] - var_26_13[arg_26_7]
			else
				var_26_2[arg_26_7] = var_26_2[arg_26_7] + var_26_14[arg_26_7]
				var_26_4[arg_26_7] = var_26_4[arg_26_7] + var_26_13[arg_26_7]
			end
		else
			local var_26_18 = UIScaleVectorToResolution(arg_26_3)

			if iter_26_0 == 1 and var_26_7 then
				var_26_2[arg_26_7] = var_26_2[arg_26_7] - var_26_18[arg_26_7]
				var_26_4[arg_26_7] = var_26_4[arg_26_7] - arg_26_3[arg_26_7]
			end

			local var_26_19 = arg_26_5 and arg_26_5[iter_26_0]

			if var_26_19 then
				local var_26_20 = UIScaleVectorToResolution(var_26_19)

				var_26_3[1] = var_26_2[1] + var_26_20[1]
				var_26_3[2] = var_26_2[2] + var_26_20[2]
				var_26_3[3] = var_26_2[3] + var_26_20[3]
			else
				var_26_3[1] = var_26_2[1]
				var_26_3[2] = var_26_2[2]
				var_26_3[3] = var_26_2[3]
			end

			local var_26_21

			if arg_26_16 == true then
				var_26_21 = var_26_0(var_26_6, arg_26_0.render_settings, var_26_10, var_26_3, var_26_18, var_26_11, arg_26_13, var_26_12, nil)
			elseif arg_26_16 then
				var_26_21 = arg_26_16[iter_26_0]

				var_26_0(var_26_6, arg_26_0.render_settings, var_26_10, var_26_3, var_26_18, var_26_11, arg_26_13, var_26_12, var_26_21)
			else
				var_26_0(var_26_5, arg_26_0.render_settings, var_26_10, var_26_3, var_26_18, var_26_11, arg_26_13, var_26_12)
			end

			if var_26_9 then
				var_26_9[iter_26_0] = var_26_21
			end

			if var_26_7 then
				var_26_2[arg_26_7] = var_26_2[arg_26_7] - var_26_18[arg_26_7]
				var_26_4[arg_26_7] = var_26_4[arg_26_7] - arg_26_3[arg_26_7]
			else
				var_26_2[arg_26_7] = var_26_2[arg_26_7] + var_26_18[arg_26_7]
				var_26_4[arg_26_7] = var_26_4[arg_26_7] + arg_26_3[arg_26_7]
			end
		end

		if arg_26_8 then
			if arg_26_9 == 2 then
				var_26_2[1] = var_26_2[1] - arg_26_8[1]
				var_26_2[2] = var_26_2[2] - arg_26_8[2]
			else
				var_26_2[1] = var_26_2[1] + arg_26_8[1]
				var_26_2[2] = var_26_2[2] + arg_26_8[2]
			end
		end
	end

	return var_26_9
end

local var_0_27 = {
	{
		0,
		0
	},
	{
		1,
		1
	}
}

var_0_9.draw_tiled_texture = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6, arg_27_7, arg_27_8)
	local var_27_0 = var_0_7.scale
	local var_27_1 = var_27_0 * arg_27_2[1]
	local var_27_2 = var_27_0 * arg_27_2[2]

	arg_27_2 = var_0_2(var_27_1, var_27_2, arg_27_2[3] or 0)

	local var_27_3 = arg_27_4[1]
	local var_27_4 = arg_27_4[2]
	local var_27_5 = arg_27_3[1] / var_27_3
	local var_27_6 = arg_27_3[2] / var_27_4
	local var_27_7 = var_27_0 * var_27_3
	local var_27_8 = var_27_0 * var_27_4

	arg_27_4 = var_0_1(var_27_7, var_27_8)

	local var_27_9 = var_0_9.script_draw_bitmap_uv
	local var_27_10 = arg_27_0.gui
	local var_27_11 = arg_27_0.render_settings
	local var_27_12 = var_0_27

	var_27_12[2][1] = 1

	while var_27_5 > 0 do
		if var_27_5 < 1 then
			var_27_12[2][1] = var_27_5
			arg_27_4[1] = var_27_5 * var_27_7
		end

		local var_27_13 = var_27_2

		arg_27_2[2] = var_27_13
		var_27_12[2][2] = 1
		arg_27_4[2] = var_27_8

		local var_27_14 = var_27_6

		while var_27_14 > 0 do
			if var_27_14 < 1 then
				var_27_12[2][2] = var_27_14
				arg_27_4[2] = var_27_14 * var_27_8
			end

			var_27_9(var_27_10, var_27_11, arg_27_1, var_27_12, arg_27_2, arg_27_4, arg_27_5, arg_27_6, arg_27_7)

			var_27_13 = var_27_13 + var_27_8
			arg_27_2[2] = var_27_13
			var_27_14 = var_27_14 - 1
		end

		var_27_1 = var_27_1 + var_27_7
		arg_27_2[1] = var_27_1
		var_27_5 = var_27_5 - 1
	end
end

var_0_9.draw_centered_texture_amount = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6, arg_28_7, arg_28_8, arg_28_9, arg_28_10, arg_28_11)
	local var_28_0 = UIScaleVectorToResolution(arg_28_2)
	local var_28_1 = UIScaleVectorToResolution(arg_28_3)

	arg_28_4 = UIScaleVectorToResolution(arg_28_4)

	local var_28_2 = var_0_1(arg_28_4[1], arg_28_4[2])
	local var_28_3 = var_28_1[arg_28_6] / (arg_28_5 + 1)
	local var_28_4 = type(arg_28_1) == "table"
	local var_28_5 = arg_28_0.gui
	local var_28_6 = arg_28_0.gui_retained
	local var_28_7

	if arg_28_11 == true then
		var_28_7 = {}
	end

	for iter_28_0 = 1, arg_28_5 do
		local var_28_8 = arg_28_9 and arg_28_9[iter_28_0] and arg_28_9[iter_28_0] or arg_28_8
		local var_28_9 = var_0_2(var_28_0.x, var_28_0.y, var_28_0.z)

		var_28_9[arg_28_6] = var_28_9[arg_28_6] + (var_28_3 * iter_28_0 - arg_28_4[arg_28_6] * 0.5)

		if arg_28_11 == true then
			var_28_7[iter_28_0] = var_0_9.script_draw_bitmap(var_28_6, arg_28_0.render_settings, var_28_4 and arg_28_1[iter_28_0] or arg_28_1, var_28_9, var_28_2, var_28_8, arg_28_10, nil, nil)
		elseif arg_28_11 then
			local var_28_10 = arg_28_11[iter_28_0]

			var_0_9.script_draw_bitmap(var_28_6, arg_28_0.render_settings, var_28_4 and arg_28_1[iter_28_0] or arg_28_1, var_28_9, var_28_2, var_28_8, arg_28_10, nil, var_28_10)
		else
			var_0_9.script_draw_bitmap(var_28_5, arg_28_0.render_settings, var_28_4 and arg_28_1[iter_28_0] or arg_28_1, var_28_9, var_28_2, var_28_8, arg_28_10, nil)
		end
	end

	return var_28_7
end

var_0_9.draw_texture_rotated = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6, arg_29_7, arg_29_8, arg_29_9)
	arg_29_2 = UIScaleVectorToResolution(arg_29_2)

	local var_29_0 = UIScaleVectorToResolution(arg_29_5)
	local var_29_1 = Rotation2D(var_0_2.zero(), arg_29_4, var_0_1(var_29_0[1], var_29_0[2]))
	local var_29_2 = Matrix4x4.translation(var_29_1)
	local var_29_3 = UIScaleVectorToResolution(arg_29_3)

	var_29_2.x = var_29_2.x + var_29_3.x
	var_29_2.z = var_29_2.z + var_29_3.y

	local var_29_4 = arg_29_0.render_settings
	local var_29_5 = var_29_4 and var_29_4.snap_pixel_positions

	if var_29_5 == nil then
		var_29_5 = SNAP_PIXEL_POSITIONS
	end

	if var_29_5 then
		var_29_2 = var_0_12(var_29_2)
	end

	Matrix4x4.set_translation(var_29_1, var_29_2)

	local var_29_6 = arg_29_0.gui
	local var_29_7 = arg_29_0.gui_retained

	if arg_29_9 == true then
		return var_0_9.script_draw_bitmap_3d(var_29_7, var_29_4, arg_29_1, var_29_1, arg_29_3[3], arg_29_2, arg_29_6, arg_29_7, arg_29_8, nil)
	elseif arg_29_9 then
		return var_0_9.script_draw_bitmap_3d(var_29_7, var_29_4, arg_29_1, var_29_1, arg_29_3[3], arg_29_2, arg_29_6, arg_29_7, arg_29_8, arg_29_9)
	else
		return var_0_9.script_draw_bitmap_3d(var_29_6, var_29_4, arg_29_1, var_29_1, arg_29_3[3], arg_29_2, arg_29_6, arg_29_7, arg_29_8)
	end
end

local var_0_28 = {}

var_0_9.draw_text = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5, arg_30_6, arg_30_7, arg_30_8)
	local var_30_0 = UIScaleVectorToResolution(arg_30_5)

	if arg_30_8 and #arg_30_8 > 0 or nil then
		var_0_28[#var_0_28 + 1] = "color_override"
		var_0_28[#var_0_28 + 1] = arg_30_8
	end

	local var_30_1 = #var_0_28 > 0
	local var_30_2
	local var_30_3 = arg_30_0.render_settings
	local var_30_4 = var_30_3 and var_30_3.alpha_multiplier or 1

	arg_30_6 = arg_30_6 and var_0_0(arg_30_6[1] * var_30_4, arg_30_6[2], arg_30_6[3], arg_30_6[4])

	if var_30_3 and var_30_3.offscreen_target then
		arg_30_4 = arg_30_4 .. "_offscreen"
	end

	local var_30_5 = Gui.FormatDirectives
	local var_30_6 = Fonts[arg_30_4]
	local var_30_7 = var_30_6 and var_30_6[4]

	if var_30_7 then
		var_30_5 = bit.bor(var_30_5, var_30_7)
	end

	if var_30_1 then
		if arg_30_7 == true then
			var_30_2 = Gui.text(arg_30_0.gui_retained, arg_30_1, arg_30_2, arg_30_3, arg_30_4, var_30_0, arg_30_6, var_30_5, unpack(var_0_28))
		elseif arg_30_7 then
			Gui.update_text(arg_30_0.gui_retained, arg_30_7, arg_30_1, arg_30_2, arg_30_3, arg_30_4, var_30_0, arg_30_6, var_30_5, unpack(var_0_28))
		else
			Gui.text(arg_30_0.gui, arg_30_1, arg_30_2, arg_30_3, arg_30_4, var_30_0, arg_30_6, var_30_5, unpack(var_0_28))
		end
	elseif arg_30_7 == true then
		var_30_2 = Gui.text(arg_30_0.gui_retained, arg_30_1, arg_30_2, arg_30_3, arg_30_4, var_30_0, arg_30_6, var_30_5)
	elseif arg_30_7 then
		Gui.update_text(arg_30_0.gui_retained, arg_30_7, arg_30_1, arg_30_2, arg_30_3, arg_30_4, var_30_0, arg_30_6, var_30_5)
	else
		Gui.text(arg_30_0.gui, arg_30_1, arg_30_2, arg_30_3, arg_30_4, var_30_0, arg_30_6, var_30_5)
	end

	if var_30_1 then
		table.clear(var_0_28)
	end

	return var_30_2
end

var_0_9.draw_justified_text = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5, arg_31_6, arg_31_7, arg_31_8, ...)
	local var_31_0 = UIScaleVectorToResolution(arg_31_5)
	local var_31_1 = arg_31_0.render_settings
	local var_31_2 = var_31_1 and var_31_1.alpha_multiplier or 1

	arg_31_6 = arg_31_6 and var_0_0(arg_31_6[1] * var_31_2, arg_31_6[2], arg_31_6[3], arg_31_6[4])

	local var_31_3 = Gui.FormatDirectives
	local var_31_4 = Fonts[arg_31_4]
	local var_31_5 = var_31_4 and var_31_4[4]

	if var_31_5 then
		var_31_3 = bit.bor(var_31_3, var_31_5)
	end

	local var_31_6 = arg_31_8 * var_0_7.scale

	if arg_31_7 == true then
		return Gui.text(arg_31_0.gui_retained, arg_31_1, arg_31_2, arg_31_3, arg_31_4, var_31_0, arg_31_6, var_31_3, "justify", var_31_6, ...)
	elseif arg_31_7 then
		Gui.update_text(arg_31_0.gui_retained, arg_31_7, arg_31_1, arg_31_2, arg_31_3, arg_31_4, var_31_0, arg_31_6, var_31_3, "justify", var_31_6, ...)
	else
		Gui.text(arg_31_0.gui, arg_31_1, arg_31_2, arg_31_3, arg_31_4, var_31_0, arg_31_6, var_31_3, "justify", var_31_6, ...)
	end
end

var_0_9.word_wrap = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6)
	local var_32_0 = " 。，"
	local var_32_1 = " -+&/*"
	local var_32_2 = "\n"
	local var_32_3 = true
	local var_32_4 = var_0_7.scale
	local var_32_5
	local var_32_6
	local var_32_7 = Gui.FormatDirectives

	if arg_32_6 then
		local var_32_8 = Fonts[arg_32_6]
		local var_32_9 = var_32_8 and var_32_8[4]

		if var_32_8[4] then
			var_32_7 = bit.bor(var_32_7, var_32_9)
		end
	end

	if arg_32_5 then
		var_32_5, var_32_6 = Gui.word_wrap(arg_32_0.gui, arg_32_1, arg_32_2, arg_32_3, arg_32_4 * var_32_4, var_32_0, var_32_1, var_32_2, var_32_3, arg_32_5, var_32_7)
	else
		var_32_5, var_32_6 = Gui.word_wrap(arg_32_0.gui, arg_32_1, arg_32_2, arg_32_3, arg_32_4 * var_32_4, var_32_0, var_32_1, var_32_2, var_32_3, var_32_7)
	end

	return var_32_5, var_32_6
end

var_0_9.text_size = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3, ...)
	local var_33_0, var_33_1 = Gui.text_extents(arg_33_0.gui, arg_33_1, arg_33_2, arg_33_3, Gui.FormatDirectives, ...)
	local var_33_2 = var_0_7.inv_scale
	local var_33_3 = (var_33_1.x + var_33_0.x) * var_33_2
	local var_33_4 = (var_33_1.y - var_33_0.y) * var_33_2

	return var_33_3, var_33_4, var_33_0
end

var_0_9.text_alignment_size = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3, ...)
	local var_34_0, var_34_1 = Gui.text_extents(arg_34_0.gui, arg_34_1, arg_34_2, arg_34_3, Gui.FormatDirectives, ...)
	local var_34_2 = var_0_7.inv_scale
	local var_34_3 = (var_34_1.x + 0) * var_34_2
	local var_34_4 = (var_34_1.y - var_34_0.y) * var_34_2

	return var_34_3, var_34_4, var_34_0
end

var_0_9.break_paragraphs = function (arg_35_0, arg_35_1)
	local var_35_0 = 1

	for iter_35_0 in string.gmatch(arg_35_0, "[^\n]+") do
		arg_35_1[var_35_0] = iter_35_0
		var_35_0 = var_35_0 + 1
	end

	return arg_35_1, var_35_0
end

var_0_9.draw_video = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6)
	if script_data.disable_video_player then
		return true
	end

	local var_36_0 = arg_36_0.gui
	local var_36_1 = arg_36_6 or arg_36_0.video_players[arg_36_5]
	local var_36_2 = true
	local var_36_3 = arg_36_0.render_settings
	local var_36_4 = var_36_3 and var_36_3.alpha_multiplier or 1

	arg_36_4 = arg_36_4 and var_0_0(arg_36_4[1] * var_36_4, arg_36_4[2], arg_36_4[3], arg_36_4[4])

	Gui.video(var_36_0, arg_36_1, var_36_1, UIScaleVectorToResolution(arg_36_2), UIScaleVectorToResolution(arg_36_3, var_36_2), arg_36_4)

	return VideoPlayer.current_frame(var_36_1) == VideoPlayer.number_of_frames(var_36_1)
end

var_0_9.draw_splash_video = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5, arg_37_6)
	if script_data.disable_video_player then
		return true
	end

	local var_37_0 = arg_37_6 or arg_37_0.video_players[arg_37_5]

	if VideoPlayer.current_frame(var_37_0) == VideoPlayer.number_of_frames(var_37_0) then
		return true
	end

	local var_37_1 = arg_37_0.gui
	local var_37_2, var_37_3 = Gui.resolution()
	local var_37_4 = var_37_2 / var_37_3
	local var_37_5 = 1.7777777777777777
	local var_37_6 = var_37_3
	local var_37_7 = var_37_2

	if math.abs(var_37_4 - var_37_5) > 0.005 then
		var_37_7 = var_37_2
		var_37_6 = var_37_7 / var_37_5

		if var_37_3 < var_37_6 then
			var_37_7 = var_37_3 * var_37_5
			var_37_6 = var_37_3
		end
	end

	local var_37_8 = arg_37_0.render_settings
	local var_37_9 = var_37_8 and var_37_8.alpha_multiplier or 1

	arg_37_4 = arg_37_4 and var_0_0(arg_37_4[1] * var_37_9, arg_37_4[2], arg_37_4[3], arg_37_4[4])

	Gui.video(var_37_1, arg_37_1, var_37_0, var_0_2(var_37_2 * 0.5 - var_37_7 * 0.5, var_37_3 * 0.5 - var_37_6 * 0.5, arg_37_2[3]), var_0_1(var_37_7, var_37_6), arg_37_4)
end

local var_0_29 = {}
local var_0_30 = 32

for iter_0_0 = 1, var_0_30 do
	local var_0_31 = iter_0_0 / var_0_30 * math.pi * 2

	var_0_29[iter_0_0 * 2 - 1] = math.cos(var_0_31)
	var_0_29[iter_0_0 * 2] = math.sin(var_0_31)
end

var_0_9.draw_circle = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
	local var_38_0 = arg_38_0.gui
	local var_38_1 = Gui.triangle
	local var_38_2 = arg_38_0.render_settings
	local var_38_3 = var_38_2 and var_38_2.alpha_multiplier or 1

	arg_38_4 = arg_38_4 and var_0_0(arg_38_4[1] * var_38_3, arg_38_4[2], arg_38_4[3], arg_38_4[4])

	local var_38_4 = 999
	local var_38_5 = var_0_2(unpack(arg_38_1))

	var_38_5.z = var_38_5.y

	local var_38_6 = var_38_5.x
	local var_38_7 = var_38_5.y
	local var_38_8 = var_0_2(var_38_6 + var_0_29[1] * arg_38_2, 0, var_38_7 + var_0_29[2] * arg_38_2)

	for iter_38_0 = 2, var_0_30 do
		local var_38_9 = var_0_2(var_38_6 + var_0_29[iter_38_0 * 2 - 1] * arg_38_2, 0, var_38_7 + var_0_29[iter_38_0 * 2] * arg_38_2)

		var_38_1(var_38_0, var_38_5, var_38_8, var_38_9, var_38_4, arg_38_4)

		var_38_8 = var_38_9
	end

	local var_38_10 = var_0_2(var_38_6 + var_0_29[1] * arg_38_2, 0, var_38_7 + var_0_29[2] * arg_38_2)

	var_38_1(var_38_0, var_38_5, var_38_8, var_38_10, var_38_4, arg_38_4)
end

var_0_9.draw_rounded_rect = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
	local var_39_0 = var_0_7.scale
	local var_39_1 = Gui.triangle

	arg_39_1 = UIScaleVectorToResolution(arg_39_1)
	arg_39_2 = UIScaleVectorToResolution(arg_39_2)
	arg_39_3 = arg_39_3 * var_39_0

	local var_39_2 = var_0_30 / 4
	local var_39_3 = arg_39_1[1]
	local var_39_4 = arg_39_1[2]
	local var_39_5 = arg_39_2[1]
	local var_39_6 = arg_39_2[2]
	local var_39_7 = arg_39_0.gui
	local var_39_8 = arg_39_1[3]
	local var_39_9 = var_0_2(arg_39_1[1] + var_39_5 / 2, 0, arg_39_1[2] + var_39_6 / 2)
	local var_39_10 = var_0_2(var_39_3 + var_39_5 - arg_39_3 + var_0_29[1] * arg_39_3, 0, var_39_4 + var_39_6 - arg_39_3 + var_0_29[2] * arg_39_3)
	local var_39_11 = arg_39_0.render_settings
	local var_39_12 = var_39_11 and var_39_11.alpha_multiplier or 1

	arg_39_4 = arg_39_4 and var_0_0(arg_39_4[1] * var_39_12, arg_39_4[2], arg_39_4[3], arg_39_4[4])

	for iter_39_0 = 2, var_39_2 do
		local var_39_13 = var_0_2(var_39_3 + var_39_5 - arg_39_3 + var_0_29[iter_39_0 * 2 - 1] * arg_39_3, 0, var_39_4 + var_39_6 - arg_39_3 + var_0_29[iter_39_0 * 2] * arg_39_3)

		var_39_1(var_39_7, var_39_9, var_39_10, var_39_13, var_39_8, arg_39_4)

		var_39_10 = var_39_13
	end

	for iter_39_1 = var_39_2, var_39_2 * 2 do
		local var_39_14 = var_0_2(var_39_3 + arg_39_3 + var_0_29[iter_39_1 * 2 - 1] * arg_39_3, 0, var_39_4 + var_39_6 - arg_39_3 + var_0_29[iter_39_1 * 2] * arg_39_3)

		var_39_1(var_39_7, var_39_9, var_39_10, var_39_14, var_39_8, arg_39_4)

		var_39_10 = var_39_14
	end

	for iter_39_2 = var_39_2 * 2, var_39_2 * 3 do
		local var_39_15 = var_0_2(var_39_3 + arg_39_3 + var_0_29[iter_39_2 * 2 - 1] * arg_39_3, 0, var_39_4 + arg_39_3 + var_0_29[iter_39_2 * 2] * arg_39_3)

		var_39_1(var_39_7, var_39_9, var_39_10, var_39_15, var_39_8, arg_39_4)

		var_39_10 = var_39_15
	end

	for iter_39_3 = var_39_2 * 3, var_39_2 * 4 do
		local var_39_16 = var_0_2(var_39_3 + var_39_5 - arg_39_3 + var_0_29[iter_39_3 * 2 - 1] * arg_39_3, 0, var_39_4 + arg_39_3 + var_0_29[iter_39_3 * 2] * arg_39_3)

		var_39_1(var_39_7, var_39_9, var_39_10, var_39_16, var_39_8, arg_39_4)

		var_39_10 = var_39_16
	end

	local var_39_17 = var_0_2(var_39_3 + var_39_5 - arg_39_3 + var_0_29[1] * arg_39_3, 0, var_39_4 + arg_39_3 + var_0_29[2] * arg_39_3)

	var_39_1(var_39_7, var_39_9, var_39_10, var_39_17, var_39_8, arg_39_4)

	local var_39_18 = var_39_17
	local var_39_19 = var_0_2(var_39_3 + var_39_5 - arg_39_3 + var_0_29[1] * arg_39_3, 0, var_39_4 + var_39_6 - arg_39_3 + var_0_29[2] * arg_39_3)

	var_39_1(var_39_7, var_39_9, var_39_18, var_39_19, var_39_8, arg_39_4)
end

local var_0_32 = {
	0,
	0,
	0
}

var_0_9.scaled_cursor_position_by_scenegraph = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
	local var_40_0 = arg_40_0:get("cursor") or var_0_32
	local var_40_1 = not arg_40_3 and UIInverseScaleVectorToResolution(var_40_0) or var_40_0
	local var_40_2 = UISceneGraph.get_world_position(arg_40_1, arg_40_2)

	var_40_1.x = var_40_1.x - var_40_2[1]
	var_40_1.y = var_40_1.y - var_40_2[2]

	return var_40_1
end

var_0_9.crop_text = function (arg_41_0, arg_41_1)
	if arg_41_1 < UTF8Utils.string_length(arg_41_0) then
		return UTF8Utils.sub_string(arg_41_0, 1, arg_41_1) .. "..."
	end

	return arg_41_0
end

local var_0_33 = "..."

var_0_9.crop_text_width = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	local var_42_0, var_42_1 = UIFontByResolution(arg_42_3)
	local var_42_2 = var_0_9.text_size(arg_42_0, arg_42_1, var_42_0[1], var_42_1)
	local var_42_3 = var_0_9.text_size(arg_42_0, var_0_33, var_42_0[1], var_42_1)

	if arg_42_2 < var_42_2 then
		repeat
			local var_42_4 = 1 - (1 - (arg_42_2 - var_42_3) / var_42_2) * 0.5
			local var_42_5 = UTF8Utils.string_length(arg_42_1)
			local var_42_6 = math.floor(var_42_5 * var_42_4)

			arg_42_1 = UTF8Utils.sub_string(arg_42_1, 1, var_42_6)

			if var_42_6 <= 0 then
				return arg_42_1
			end

			var_42_2 = math.floor(var_0_9.text_size(arg_42_0, arg_42_1, var_42_0[1], var_42_1))
		until var_42_2 <= arg_42_2

		local var_42_7 = UTF8Utils.string_length(arg_42_1)

		arg_42_1 = UTF8Utils.sub_string(arg_42_1, 1, var_42_7) .. "..."
	end

	return arg_42_1
end

var_0_9.scaled_font_size_by_area = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	local var_43_0 = arg_43_2[1]
	local var_43_1 = arg_43_2[2]
	local var_43_2 = arg_43_3.font_type
	local var_43_3 = Fonts[var_43_2][1]
	local var_43_4 = arg_43_0.gui

	for iter_43_0 = arg_43_3.font_size, 1, -0.5 do
		local var_43_5, var_43_6, var_43_7 = UIGetFontHeight(var_43_4, var_43_2, iter_43_0)
		local var_43_8 = Gui.word_wrap(var_43_4, arg_43_1, var_43_3, iter_43_0, var_43_0, " 。，", "-+&/*", "\n", true, Gui.FormatDirectives)

		if var_43_1 > math.ceil(1.05 * (var_43_7 - var_43_6) * #var_43_8) then
			return iter_43_0
		end
	end

	return 1
end

var_0_9.scaled_font_size_by_width = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	local var_44_0, var_44_1 = UIFontByResolution(arg_44_3)
	local var_44_2 = var_0_9.text_size(arg_44_0, arg_44_1, var_44_0[1], var_44_1)
	local var_44_3 = 1
	local var_44_4 = arg_44_3.font_size

	while arg_44_2 < var_44_2 do
		if var_44_3 >= arg_44_3.font_size then
			break
		end

		arg_44_3.font_size = math.max(arg_44_3.font_size - 1, var_44_3)

		local var_44_5, var_44_6 = UIFontByResolution(arg_44_3)

		var_44_2 = math.floor(var_0_9.text_size(arg_44_0, arg_44_1, var_44_5[1], var_44_6))
	end

	local var_44_7 = arg_44_3.font_size

	arg_44_3.font_size = var_44_4

	return var_44_7
end

local var_0_34 = {
	{
		0,
		0
	},
	{
		0,
		0
	}
}
local var_0_35 = {
	{
		0,
		0
	},
	{
		0,
		0
	}
}
local var_0_36 = {
	{
		0,
		0
	},
	{
		0,
		0
	}
}

var_0_9.draw_texture_frame = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6, arg_45_7, arg_45_8, arg_45_9, arg_45_10, arg_45_11, arg_45_12, arg_45_13)
	local var_45_0 = arg_45_0.gui
	local var_45_1 = arg_45_0.gui_retained

	arg_45_1 = UIScaleVectorToResolution(arg_45_1)
	arg_45_2 = UIScaleVectorToResolution(arg_45_2)
	arg_45_4 = UIScaleVectorToResolution(arg_45_4)

	local var_45_2 = arg_45_1[3]
	local var_45_3 = UIScaleVectorToResolution(arg_45_5.corner)
	local var_45_4 = var_45_3[1]
	local var_45_5 = var_45_3[2]
	local var_45_6 = arg_45_1.x
	local var_45_7 = arg_45_1.y
	local var_45_8 = arg_45_4[1]
	local var_45_9 = arg_45_4[2]
	local var_45_10 = arg_45_2.x
	local var_45_11 = arg_45_2.y
	local var_45_12 = 1
	local var_45_13

	if arg_45_13 == true then
		var_45_13 = {}
	end

	local var_45_14 = var_45_4 / var_45_8
	local var_45_15 = var_45_5 / var_45_9

	var_0_34[1][1] = 0
	var_0_34[1][2] = 1 - var_45_15
	var_0_34[2][1] = var_45_14
	var_0_34[2][2] = 1

	if arg_45_13 == true then
		var_45_13[#var_45_13 + 1] = var_0_9.script_draw_bitmap_uv(var_45_1, arg_45_0.render_settings, arg_45_3, var_0_34, var_0_2(var_45_6, var_45_7, var_45_2), var_45_3, arg_45_6, arg_45_7, arg_45_8, nil)
	elseif arg_45_13 then
		local var_45_16 = arg_45_13[var_45_12]

		var_0_9.script_draw_bitmap_uv(var_45_1, arg_45_0.render_settings, arg_45_3, var_0_34, var_0_2(var_45_6, var_45_7, var_45_2), var_45_3, arg_45_6, arg_45_7, arg_45_8, var_45_16)

		var_45_12 = var_45_12 + 1
	else
		var_0_9.script_draw_bitmap_uv(var_45_0, arg_45_0.render_settings, arg_45_3, var_0_34, var_0_2(var_45_6, var_45_7, var_45_2), var_45_3, arg_45_6, arg_45_7, arg_45_8)
	end

	var_0_34[1][1] = 0
	var_0_34[1][2] = 0
	var_0_34[2][1] = var_45_14
	var_0_34[2][2] = var_45_15

	if arg_45_13 == true then
		var_45_13[#var_45_13 + 1] = var_0_9.script_draw_bitmap_uv(var_45_1, arg_45_0.render_settings, arg_45_3, var_0_34, var_0_2(var_45_6, var_45_7 + var_45_11 - var_45_5, var_45_2), var_45_3, arg_45_6, arg_45_7, arg_45_8, nil)
	elseif arg_45_13 then
		local var_45_17 = arg_45_13[var_45_12]

		var_0_9.script_draw_bitmap_uv(var_45_1, arg_45_0.render_settings, arg_45_3, var_0_34, var_0_2(var_45_6, var_45_7 + var_45_11 - var_45_5, var_45_2), var_45_3, arg_45_6, arg_45_7, arg_45_8, var_45_17)

		var_45_12 = var_45_12 + 1
	else
		var_0_9.script_draw_bitmap_uv(var_45_0, arg_45_0.render_settings, arg_45_3, var_0_34, var_0_2(var_45_6, var_45_7 + var_45_11 - var_45_5, var_45_2), var_45_3, arg_45_6, arg_45_7, arg_45_8)
	end

	var_0_34[1][1] = 1 - var_45_14
	var_0_34[1][2] = 0
	var_0_34[2][1] = 1
	var_0_34[2][2] = var_45_15

	if arg_45_13 == true then
		var_45_13[#var_45_13 + 1] = var_0_9.script_draw_bitmap_uv(var_45_1, arg_45_0.render_settings, arg_45_3, var_0_34, var_0_2(var_45_6 + var_45_10 - var_45_4, var_45_7 + var_45_11 - var_45_5, var_45_2), var_45_3, arg_45_6, arg_45_7, arg_45_8, nil)
	elseif arg_45_13 then
		local var_45_18 = arg_45_13[var_45_12]

		var_0_9.script_draw_bitmap_uv(var_45_1, arg_45_0.render_settings, arg_45_3, var_0_34, var_0_2(var_45_6 + var_45_10 - var_45_4, var_45_7 + var_45_11 - var_45_5, var_45_2), var_45_3, arg_45_6, arg_45_7, arg_45_8, var_45_18)

		var_45_12 = var_45_12 + 1
	else
		var_0_9.script_draw_bitmap_uv(var_45_0, arg_45_0.render_settings, arg_45_3, var_0_34, var_0_2(var_45_6 + var_45_10 - var_45_4, var_45_7 + var_45_11 - var_45_5, var_45_2), var_45_3, arg_45_6, arg_45_7, arg_45_8)
	end

	var_0_34[1][1] = 1 - var_45_14
	var_0_34[1][2] = 1 - var_45_15
	var_0_34[2][1] = 1
	var_0_34[2][2] = 1

	if arg_45_13 == true then
		var_45_13[#var_45_13 + 1] = var_0_9.script_draw_bitmap_uv(var_45_1, arg_45_0.render_settings, arg_45_3, var_0_34, var_0_2(var_45_6 + var_45_10 - var_45_4, var_45_7, var_45_2), var_45_3, arg_45_6, arg_45_7, arg_45_8, nil)
	elseif arg_45_13 then
		local var_45_19 = arg_45_13[var_45_12]

		var_0_9.script_draw_bitmap_uv(var_45_1, arg_45_0.render_settings, arg_45_3, var_0_34, var_0_2(var_45_6 + var_45_10 - var_45_4, var_45_7, var_45_2), var_45_3, arg_45_6, arg_45_7, arg_45_8, var_45_19)

		var_45_12 = var_45_12 + 1
	else
		var_0_9.script_draw_bitmap_uv(var_45_0, arg_45_0.render_settings, arg_45_3, var_0_34, var_0_2(var_45_6 + var_45_10 - var_45_4, var_45_7, var_45_2), var_45_3, arg_45_6, arg_45_7, arg_45_8)
	end

	if not arg_45_12 then
		var_0_34[1][1] = var_45_14
		var_0_34[1][2] = var_45_15
		var_0_34[2][1] = 1 - var_45_14
		var_0_34[2][2] = 1 - var_45_15

		if arg_45_13 == true then
			var_45_13[#var_45_13 + 1] = var_0_9.script_draw_bitmap_uv(var_45_1, arg_45_0.render_settings, arg_45_3, var_0_34, var_0_2(var_45_6 + var_45_4, var_45_7 + var_45_5, var_45_2), arg_45_2 - var_45_3 * 2, arg_45_6, arg_45_7, arg_45_8, nil)
		elseif arg_45_13 then
			local var_45_20 = arg_45_13[var_45_12]

			var_0_9.script_draw_bitmap_uv(var_45_1, arg_45_0.render_settings, arg_45_3, var_0_34, var_0_2(var_45_6 + var_45_4, var_45_7 + var_45_5, var_45_2), arg_45_2 - var_45_3 * 2, arg_45_6, arg_45_7, arg_45_8, var_45_20)

			var_45_12 = var_45_12 + 1
		else
			var_0_9.script_draw_bitmap_uv(var_45_0, arg_45_0.render_settings, arg_45_3, var_0_34, var_0_2(var_45_6 + var_45_4, var_45_7 + var_45_5, var_45_2), arg_45_2 - var_45_3 * 2, arg_45_6, arg_45_7, arg_45_8)
		end
	end

	if arg_45_9 then
		return
	end

	if arg_45_10 then
		local var_45_21 = UIScaleVectorToResolution(arg_45_5.vertical)
		local var_45_22 = var_45_21[1]
		local var_45_23 = var_45_21[2]
		local var_45_24 = arg_45_2[2] - var_45_5 * 2

		var_45_21[2] = var_45_24

		local var_45_25 = var_45_24
		local var_45_26 = var_45_7 + var_45_5
		local var_45_27 = math.max(math.ceil(var_45_25 / var_45_23), 1)

		for iter_45_0 = 1, var_45_27 do
			local var_45_28 = math.clamp(var_45_25 / var_45_23, 0, 1)
			local var_45_29 = iter_45_0 % 2 == 0

			var_0_34[1][1] = 0
			var_0_34[2][1] = var_45_22 / var_45_8

			if var_45_29 and arg_45_11 then
				var_0_34[1][2] = math.lerp(var_45_5 / var_45_9, 1 - var_45_5 / var_45_9, var_45_28)
				var_0_34[2][2] = var_45_5 / var_45_9
			else
				var_0_34[1][2] = math.lerp(1 - var_45_5 / var_45_9, var_45_5 / var_45_9, var_45_28)
				var_0_34[2][2] = 1 - var_45_5 / var_45_9
			end

			var_0_35[1][1] = 1 - var_45_22 / var_45_8
			var_0_35[2][1] = 1

			if var_45_29 and arg_45_11 then
				var_0_35[1][2] = math.lerp(var_45_5 / var_45_9, 1 - var_45_5 / var_45_9, var_45_28)
				var_0_35[2][2] = var_45_5 / var_45_9
			else
				var_0_35[1][2] = math.lerp(1 - var_45_5 / var_45_9, var_45_5 / var_45_9, var_45_28)
				var_0_35[2][2] = 1 - var_45_5 / var_45_9
			end

			var_45_21[2] = var_45_28 * var_45_23

			if arg_45_13 == true then
				var_45_13[#var_45_13 + 1] = var_0_9.script_draw_bitmap_uv(var_45_1, arg_45_0.render_settings, arg_45_3, var_0_34, var_0_2(var_45_6, var_45_26, var_45_2), var_45_21, arg_45_6, arg_45_7, arg_45_8, nil)
			elseif arg_45_13 then
				local var_45_30 = arg_45_13[var_45_12]

				var_0_9.script_draw_bitmap_uv(var_45_1, arg_45_0.render_settings, arg_45_3, var_0_34, var_0_2(var_45_6, var_45_26, var_45_2), var_45_21, arg_45_6, arg_45_7, arg_45_8, var_45_30)

				var_45_12 = var_45_12 + 1
			else
				var_0_9.script_draw_bitmap_uv(var_45_0, arg_45_0.render_settings, arg_45_3, var_0_34, var_0_2(var_45_6, var_45_26, var_45_2), var_45_21, arg_45_6, arg_45_7, arg_45_8)
			end

			if arg_45_13 == true then
				var_45_13[#var_45_13 + 1] = var_0_9.script_draw_bitmap_uv(var_45_1, arg_45_0.render_settings, arg_45_3, var_0_35, var_0_2(var_45_6 + var_45_10 - var_45_22, var_45_26, var_45_2), var_45_21, arg_45_6, arg_45_7, arg_45_8, nil)
			elseif arg_45_13 then
				local var_45_31 = arg_45_13[var_45_12]

				var_0_9.script_draw_bitmap_uv(var_45_1, arg_45_0.render_settings, arg_45_3, var_0_35, var_0_2(var_45_6 + var_45_10 - var_45_22, var_45_26, var_45_2), var_45_21, arg_45_6, arg_45_7, arg_45_8, var_45_31)

				var_45_12 = var_45_12 + 1
			else
				var_0_9.script_draw_bitmap_uv(var_45_0, arg_45_0.render_settings, arg_45_3, var_0_35, var_0_2(var_45_6 + var_45_10 - var_45_22, var_45_26, var_45_2), var_45_21, arg_45_6, arg_45_7, arg_45_8)
			end

			var_45_26 = var_45_26 + var_45_23
			var_45_25 = var_45_25 - var_45_23
		end

		local var_45_32 = UIScaleVectorToResolution(arg_45_5.horizontal)
		local var_45_33 = var_45_32[1]
		local var_45_34 = var_45_32[2]
		local var_45_35 = arg_45_2[1] - var_45_4 * 2

		var_45_32[1] = var_45_35

		local var_45_36 = var_45_35
		local var_45_37 = var_45_6 + var_45_4
		local var_45_38 = math.max(math.ceil(var_45_36 / var_45_23), 1)

		for iter_45_1 = 1, var_45_38 do
			local var_45_39 = math.clamp(var_45_36 / var_45_33, 0, 1)
			local var_45_40 = iter_45_1 % 2 == 0

			if var_45_40 and arg_45_11 then
				var_0_34[1][1] = 1 - var_45_4 / var_45_8
				var_0_34[2][1] = math.lerp(1 - var_45_4 / var_45_8, var_45_4 / var_45_8, var_45_39)
			else
				var_0_34[1][1] = var_45_4 / var_45_8
				var_0_34[2][1] = math.lerp(var_45_4 / var_45_8, 1 - var_45_4 / var_45_8, var_45_39)
			end

			var_0_34[1][2] = 1 - var_45_5 / var_45_9
			var_0_34[2][2] = 1

			if var_45_40 and arg_45_11 then
				var_0_36[1][1] = 1 - var_45_4 / var_45_8
				var_0_36[2][1] = math.lerp(1 - var_45_4 / var_45_8, var_45_4 / var_45_8, var_45_39)
			else
				var_0_36[1][1] = var_45_4 / var_45_8
				var_0_36[2][1] = math.lerp(var_45_4 / var_45_8, 1 - var_45_4 / var_45_8, var_45_39)
			end

			var_0_36[1][2] = 0
			var_0_36[2][2] = var_45_5 / var_45_9
			var_45_32[1] = var_45_39 * var_45_33

			if arg_45_13 == true then
				var_45_13[#var_45_13 + 1] = var_0_9.script_draw_bitmap_uv(var_45_1, arg_45_0.render_settings, arg_45_3, var_0_34, var_0_2(var_45_37, var_45_7, var_45_2), var_45_32, arg_45_6, arg_45_7, arg_45_8, nil)
			elseif arg_45_13 then
				local var_45_41 = arg_45_13[var_45_12]

				var_0_9.script_draw_bitmap_uv(var_45_1, arg_45_0.render_settings, arg_45_3, var_0_34, var_0_2(var_45_37, var_45_7, var_45_2), var_45_32, arg_45_6, arg_45_7, arg_45_8, var_45_41)

				var_45_12 = var_45_12 + 1
			else
				var_0_9.script_draw_bitmap_uv(var_45_0, arg_45_0.render_settings, arg_45_3, var_0_34, var_0_2(var_45_37, var_45_7, var_45_2), var_45_32, arg_45_6, arg_45_7, arg_45_8)
			end

			if arg_45_13 == true then
				var_45_13[#var_45_13 + 1] = var_0_9.script_draw_bitmap_uv(var_45_1, arg_45_0.render_settings, arg_45_3, var_0_36, var_0_2(var_45_37, var_45_7 + var_45_11 - var_45_34, var_45_2), var_45_32, arg_45_6, arg_45_7, arg_45_8, nil)
			elseif arg_45_13 then
				local var_45_42 = arg_45_13[var_45_12]

				var_0_9.script_draw_bitmap_uv(var_45_1, arg_45_0.render_settings, arg_45_3, var_0_36, var_0_2(var_45_37, var_45_7 + var_45_11 - var_45_34, var_45_2), var_45_32, arg_45_6, arg_45_7, arg_45_8, var_45_42)

				var_45_12 = var_45_12 + 1
			else
				var_0_9.script_draw_bitmap_uv(var_45_0, arg_45_0.render_settings, arg_45_3, var_0_36, var_0_2(var_45_37, var_45_7 + var_45_11 - var_45_34, var_45_2), var_45_32, arg_45_6, arg_45_7, arg_45_8)
			end

			var_45_37 = var_45_37 + var_45_33
			var_45_36 = var_45_36 - var_45_33
		end
	else
		local var_45_43 = UIScaleVectorToResolution(arg_45_5.vertical)
		local var_45_44 = var_45_43[1]
		local var_45_45 = var_45_43[2]

		var_45_43[2] = arg_45_2[2] - var_45_5 * 2
		var_0_34[1][1] = 0
		var_0_34[1][2] = 0.5 - var_45_45 / arg_45_2[2] * 0.5
		var_0_34[2][1] = var_45_44 / var_45_8
		var_0_34[2][2] = 0.5 + var_45_45 / arg_45_2[2] * 0.5
		var_0_35[1][1] = 1 - var_45_44 / var_45_8
		var_0_35[1][2] = 0.5 - var_45_45 / arg_45_2[2] * 0.5
		var_0_35[2][1] = 1
		var_0_35[2][2] = 0.5 + var_45_45 / arg_45_2[2] * 0.5

		local var_45_46 = var_45_7 + var_45_5

		if arg_45_13 == true then
			var_45_13[#var_45_13 + 1] = var_0_9.script_draw_bitmap_uv(var_45_1, arg_45_0.render_settings, arg_45_3, var_0_34, var_0_2(var_45_6, var_45_46, var_45_2), var_45_43, arg_45_6, arg_45_7, arg_45_8, nil)
		elseif arg_45_13 then
			local var_45_47 = arg_45_13[var_45_12]

			var_0_9.script_draw_bitmap_uv(var_45_1, arg_45_0.render_settings, arg_45_3, var_0_34, var_0_2(var_45_6, var_45_46, var_45_2), var_45_43, arg_45_6, arg_45_7, arg_45_8, var_45_47)

			var_45_12 = var_45_12 + 1
		else
			var_0_9.script_draw_bitmap_uv(var_45_0, arg_45_0.render_settings, arg_45_3, var_0_34, var_0_2(var_45_6, var_45_46, var_45_2), var_45_43, arg_45_6, arg_45_7, arg_45_8)
		end

		if arg_45_13 == true then
			var_45_13[#var_45_13 + 1] = var_0_9.script_draw_bitmap_uv(var_45_1, arg_45_0.render_settings, arg_45_3, var_0_35, var_0_2(var_45_6 + var_45_10 - var_45_44, var_45_46, var_45_2), var_45_43, arg_45_6, arg_45_7, arg_45_8, nil)
		elseif arg_45_13 then
			local var_45_48 = arg_45_13[var_45_12]

			var_0_9.script_draw_bitmap_uv(var_45_1, arg_45_0.render_settings, arg_45_3, var_0_35, var_0_2(var_45_6 + var_45_10 - var_45_44, var_45_46, var_45_2), var_45_43, arg_45_6, arg_45_7, arg_45_8, var_45_48)

			var_45_12 = var_45_12 + 1
		else
			var_0_9.script_draw_bitmap_uv(var_45_0, arg_45_0.render_settings, arg_45_3, var_0_35, var_0_2(var_45_6 + var_45_10 - var_45_44, var_45_46, var_45_2), var_45_43, arg_45_6, arg_45_7, arg_45_8)
		end

		local var_45_49 = UIScaleVectorToResolution(arg_45_5.horizontal)
		local var_45_50 = var_45_49[1]
		local var_45_51 = var_45_49[2]

		var_45_49[1] = arg_45_2[1] - var_45_4 * 2
		var_0_36[1][1] = 0.5 - var_45_50 / arg_45_2[1] * 0.5
		var_0_36[1][2] = 0
		var_0_36[2][1] = 0.5 + var_45_50 / arg_45_2[1] * 0.5
		var_0_36[2][2] = var_45_51 / var_45_9
		var_0_34[1][1] = 0.5 - var_45_50 / arg_45_2[1] * 0.5
		var_0_34[1][2] = 1 - var_45_51 / var_45_9
		var_0_34[2][1] = 0.5 + var_45_50 / arg_45_2[1] * 0.5
		var_0_34[2][2] = 1

		local var_45_52 = var_45_6 + var_45_4

		if arg_45_13 == true then
			var_45_13[#var_45_13 + 1] = var_0_9.script_draw_bitmap_uv(var_45_1, arg_45_0.render_settings, arg_45_3, var_0_34, var_0_2(var_45_52, var_45_7, var_45_2), var_45_49, arg_45_6, arg_45_7, arg_45_8, nil)
		elseif arg_45_13 then
			local var_45_53 = arg_45_13[var_45_12]

			var_0_9.script_draw_bitmap_uv(var_45_1, arg_45_0.render_settings, arg_45_3, var_0_34, var_0_2(var_45_52, var_45_7, var_45_2), var_45_49, arg_45_6, arg_45_7, arg_45_8, var_45_53)

			var_45_12 = var_45_12 + 1
		else
			var_0_9.script_draw_bitmap_uv(var_45_0, arg_45_0.render_settings, arg_45_3, var_0_34, var_0_2(var_45_52, var_45_7, var_45_2), var_45_49, arg_45_6, arg_45_7, arg_45_8)
		end

		if arg_45_13 == true then
			var_45_13[#var_45_13 + 1] = var_0_9.script_draw_bitmap_uv(var_45_1, arg_45_0.render_settings, arg_45_3, var_0_36, var_0_2(var_45_52, var_45_7 + var_45_11 - var_45_51, var_45_2), var_45_49, arg_45_6, arg_45_7, arg_45_8, nil)
		elseif arg_45_13 then
			local var_45_54 = arg_45_13[var_45_12]

			var_0_9.script_draw_bitmap_uv(var_45_1, arg_45_0.render_settings, arg_45_3, var_0_36, var_0_2(var_45_52, var_45_7 + var_45_11 - var_45_51, var_45_2), var_45_49, arg_45_6, arg_45_7, arg_45_8, var_45_54)
		else
			var_0_9.script_draw_bitmap_uv(var_45_0, arg_45_0.render_settings, arg_45_3, var_0_36, var_0_2(var_45_52, var_45_7 + var_45_11 - var_45_51, var_45_2), var_45_49, arg_45_6, arg_45_7, arg_45_8)
		end
	end

	return var_45_13
end

var_0_9.destroy_bitmap = function (arg_46_0, arg_46_1)
	Gui.destroy_bitmap(arg_46_0.gui_retained, arg_46_1)
end

var_0_9.destroy_text = function (arg_47_0, arg_47_1)
	Gui.destroy_text(arg_47_0.gui_retained, arg_47_1)
end

require("scripts/ui/ui_passes")
