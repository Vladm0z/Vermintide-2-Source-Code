-- chunkname: @scripts/ui/ui_renderer.lua

print("[UIRenderer] Loading")
require("scripts/utils/strict_table")
require("scripts/ui/ui_scenegraph")
require("scripts/ui/ui_resolution")
require("scripts/utils/debug_key_handler")
require("scripts/helpers/ui_atlas_helper")

local script_data = script_data
local ui_debug_scenegraph = script_data.ui_debug_scenegraph

ui_debug_scenegraph = ui_debug_scenegraph or Development.parameter("ui_debug_scenegraph")
script_data.ui_debug_scenegraph = ui_debug_scenegraph

local script_data_2 = script_data
local ui_debug_pixeldistance = script_data.ui_debug_pixeldistance

ui_debug_pixeldistance = ui_debug_pixeldistance or Development.parameter("ui_debug_pixeldistance")
script_data_2.ui_debug_pixeldistance = ui_debug_pixeldistance

local script_data_3 = script_data
local ui_debug_draw_texture = script_data.ui_debug_draw_texture

ui_debug_draw_texture = ui_debug_draw_texture or Development.parameter("ui_debug_draw_texture")
script_data_3.ui_debug_draw_texture = ui_debug_draw_texture

local Color = Color
local Vector2 = Vector2
local Vector3 = Vector3
local bitmap_uv = Gui.bitmap_uv
local bitmap = Gui.bitmap
local update_bitmap_uv = Gui.update_bitmap_uv
local update_bitmap = Gui.update_bitmap
local RESOLUTION_LOOKUP = RESOLUTION_LOOKUP
local UIAtlasHelper = UIAtlasHelper

UIRenderer = {}

local UIRenderer = UIRenderer

SNAP_PIXEL_POSITIONS = true

local tbl = {
	{
		0,
		0
	},
	{
		1,
		1
	}
}

local function fn(self, arg_1_1, arg_1_2)
	-- function 1
	local num = arg_1_1[2] - self[2]
	local num_2 = arg_1_1[1] - self[1]

	tbl[1][2] = self[2] + num * arg_1_2[1][2]
	tbl[2][2] = self[2] + num * arg_1_2[2][2]
	tbl[1][1] = self[1] + num_2 * arg_1_2[1][1]
	tbl[2][1] = self[1] + num_2 * arg_1_2[2][1]

	return tbl
end

local function fn_2(self)
	-- function 2
	if RESOLUTION_LOOKUP.scale >= 1 then
		self[1] = math.round(self[1])
		self[2] = math.round(self[2])
	end

	return self
end

UIRenderer.script_draw_bitmap = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7, arg_3_8, arg_3_9, arg_3_10)
	-- function 3
	local flag = not arg_3_1 and arg_3_1.snap_pixel_positions

	if flag == nil then
		flag = SNAP_PIXEL_POSITIONS
	end

	if not flag then
		arg_3_3 = fn_2(arg_3_3)
	end

	local alpha_multiplier

	if not arg_3_1 then
		alpha_multiplier = arg_3_1.alpha_multiplier

		if not alpha_multiplier then
			-- Nothing
		end
	end

	alpha_multiplier = 1

	::label_3_0::

	local var_3_2

	if not UIAtlasHelper.has_atlas_settings_by_texture_name(arg_3_2) then
		var_3_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_3_2)
	end

	if not arg_3_5 then
		arg_3_5 = Color(255 * alpha_multiplier, 255, 255, 255)
	else
		arg_3_5 = Color(arg_3_5[1] * alpha_multiplier, arg_3_5[2], arg_3_5[3], arg_3_5[4])
	end

	if not var_3_2 then
		local uv00 = var_3_2.uv00
		local uv11 = var_3_2.uv11
		local var_3_5 = Vector2(uv00[1], uv00[2])
		local var_3_6 = Vector2(uv11[1], uv11[2])
		local var_3_7

		if not arg_3_6 then
			if not arg_3_7 then
				var_3_7 = var_3_2.saturated_material_name
			elseif not arg_3_9 then
				var_3_7 = var_3_2.point_sample_material_name
			elseif not arg_3_10 then
				var_3_7 = var_3_2.viewport_mask_material_name
			else
				var_3_7 = var_3_2.material_name
			end
		elseif not arg_3_7 then
			var_3_7 = var_3_2.masked_saturated_material_name
		elseif not arg_3_9 then
			var_3_7 = var_3_2.masked_point_sample_material_name
		else
			var_3_7 = var_3_2.masked_material_name
		end

		if not arg_3_8 then
			update_bitmap_uv(arg_3_0, arg_3_8, var_3_7, var_3_5, var_3_6, arg_3_3, arg_3_4, arg_3_5)
		else
			return bitmap_uv(arg_3_0, var_3_7, var_3_5, var_3_6, arg_3_3, arg_3_4, arg_3_5)
		end
	elseif not arg_3_8 then
		update_bitmap(arg_3_0, arg_3_8, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	else
		return bitmap(arg_3_0, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	end
end

UIRenderer.script_draw_bitmap_uv = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7, arg_4_8, arg_4_9, arg_4_10, arg_4_11)
	-- function 4
	local flag = not arg_4_1 and arg_4_1.snap_pixel_positions

	if flag == nil then
		flag = SNAP_PIXEL_POSITIONS
	end

	if not flag then
		arg_4_4 = fn_2(arg_4_4)
	end

	local alpha_multiplier

	if not arg_4_1 then
		alpha_multiplier = arg_4_1.alpha_multiplier

		if not alpha_multiplier then
			-- Nothing
		end
	end

	alpha_multiplier = 1

	::label_4_0::

	arg_4_6 = not arg_4_6 and Color(arg_4_6[1] * alpha_multiplier, arg_4_6[2], arg_4_6[3], arg_4_6[4])

	local var_4_2

	if not UIAtlasHelper.has_atlas_settings_by_texture_name(arg_4_2) then
		var_4_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_4_2)
	end

	if not var_4_2 then
		local var_4_3 = fn(var_4_2.uv00, var_4_2.uv11, arg_4_3)
		local var_4_4 = var_4_3[1]
		local var_4_5 = var_4_3[2]
		local var_4_6 = Vector2(var_4_4[1], var_4_4[2])
		local var_4_7 = Vector2(var_4_5[1], var_4_5[2])
		local var_4_8

		if not arg_4_7 then
			var_4_8 = var_4_2.masked_material_name
		elseif not arg_4_8 then
			var_4_8 = var_4_2.saturated_material_name
		elseif not arg_4_11 then
			var_4_8 = var_4_2.viewport_mask_material_name
		else
			var_4_8 = var_4_2.material_name
		end

		if not arg_4_9 then
			update_bitmap_uv(arg_4_0, arg_4_9, var_4_8, var_4_6, var_4_7, arg_4_4, arg_4_5, arg_4_6)
		else
			return bitmap_uv(arg_4_0, var_4_8, var_4_6, var_4_7, arg_4_4, arg_4_5, arg_4_6)
		end
	else
		local var_4_9 = arg_4_3[1]
		local var_4_10 = arg_4_3[2]

		if not arg_4_9 then
			update_bitmap_uv(arg_4_0, arg_4_9, arg_4_2, Vector2(var_4_9[1], var_4_9[2]), Vector2(var_4_10[1], var_4_10[2]), arg_4_4, arg_4_5, arg_4_6)
		else
			return bitmap_uv(arg_4_0, arg_4_2, Vector2(var_4_9[1], var_4_9[2]), Vector2(var_4_10[1], var_4_10[2]), arg_4_4, arg_4_5, arg_4_6)
		end
	end
end

local update_bitmap_3d_uv = Gui.update_bitmap_3d_uv
local bitmap_3d_uv = Gui.bitmap_3d_uv
local update_bitmap_3d = Gui.update_bitmap_3d
local bitmap_3d = Gui.bitmap_3d

UIRenderer.script_draw_bitmap_3d = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8, arg_5_9)
	-- function 5
	local alpha_multiplier

	if not arg_5_1 then
		alpha_multiplier = arg_5_1.alpha_multiplier

		if not alpha_multiplier then
			-- Nothing
		end
	end

	alpha_multiplier = 1

	::label_5_0::

	arg_5_6 = not arg_5_6 and Color(arg_5_6[1] * alpha_multiplier, arg_5_6[2], arg_5_6[3], arg_5_6[4])

	local var_5_1

	if not UIAtlasHelper.has_atlas_settings_by_texture_name(arg_5_2) then
		var_5_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_5_2)
	end

	if not var_5_1 then
		local var_5_2

		if not arg_5_8 then
			var_5_2 = var_5_1.masked_material_name
		else
			var_5_2 = var_5_1.material_name
		end

		local var_5_3
		local var_5_4

		if not arg_5_7 then
			local var_5_5 = fn(var_5_1.uv00, var_5_1.uv11, arg_5_7)
			local var_5_6 = var_5_5[1]
			local var_5_7 = var_5_5[2]

			var_5_3 = Vector2(var_5_6[1], var_5_6[2])
			var_5_4 = Vector2(var_5_7[1], var_5_7[2])
		else
			var_5_3, var_5_4 = var_5_1.uv00, var_5_1.uv11
		end

		if not arg_5_9 then
			return update_bitmap_3d_uv(arg_5_0, arg_5_9, var_5_2, Vector2(var_5_3[1], var_5_3[2]), Vector2(var_5_4[1], var_5_4[2]), arg_5_3, Vector3.zero(), arg_5_4, arg_5_5, arg_5_6)
		else
			return bitmap_3d_uv(arg_5_0, var_5_2, Vector2(var_5_3[1], var_5_3[2]), Vector2(var_5_4[1], var_5_4[2]), arg_5_3, Vector3.zero(), arg_5_4, arg_5_5, arg_5_6)
		end
	elseif not arg_5_7 then
		local var_5_8 = arg_5_7[1]
		local var_5_9 = arg_5_7[2]
		local var_5_10
		local var_5_11
		local var_5_12 = Vector2(var_5_8[1], var_5_8[2])
		local var_5_13 = Vector2(var_5_9[1], var_5_9[2])

		if not arg_5_9 then
			return update_bitmap_3d_uv(arg_5_0, arg_5_9, arg_5_2, Vector2(var_5_12[1], var_5_12[2]), Vector2(var_5_13[1], var_5_13[2]), arg_5_3, Vector3.zero(), arg_5_4, arg_5_5, arg_5_6)
		else
			return bitmap_3d_uv(arg_5_0, arg_5_2, Vector2(var_5_12[1], var_5_12[2]), Vector2(var_5_13[1], var_5_13[2]), arg_5_3, Vector3.zero(), arg_5_4, arg_5_5, arg_5_6)
		end
	elseif not arg_5_9 then
		return update_bitmap_3d(arg_5_0, arg_5_9, arg_5_2, arg_5_3, Vector3.zero(), arg_5_4, arg_5_5, arg_5_6)
	else
		return bitmap_3d(arg_5_0, arg_5_2, arg_5_3, Vector3.zero(), arg_5_4, arg_5_5, arg_5_6)
	end
end

UIRenderer._injected_material_sets = {}

local function fn_3(arg_6_0, ...)
	-- function 6
	local var_6_0 = UIRenderer._injected_material_sets[arg_6_0]

	if not var_6_0 then
		return "material", var_6_0, fn_3(arg_6_0 + 1, ...)
	end

	return ...
end

UIRenderer.create = function (arg_7_0, ...)
	-- function 7
	local create_screen_gui = World.create_screen_gui(arg_7_0, "immediate", fn_3(1, ...))
	local create_screen_gui_2 = World.create_screen_gui(arg_7_0, fn_3(1, ...))

	return UIRenderer.create_ui_renderer(arg_7_0, create_screen_gui, create_screen_gui_2)
end

local set = table.set({
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

UIRenderer.create_ui_renderer = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	return table.make_strict({
		gui = arg_8_1,
		gui_retained = arg_8_2,
		scenegraph_queue = {},
		video_players = {},
		world = arg_8_0,
		wwise_world = Managers.world:wwise_world(arg_8_0)
	}, set)
end

UIRenderer.create_video_player = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	if not script_data.disable_video_player then
		return
	end

	local video_players = self.video_players

	assert(not video_players[arg_9_1])

	local flag = arg_9_2 or self.world
	local create_video_player = World.create_video_player(flag, arg_9_3, arg_9_4)

	video_players[arg_9_1] = create_video_player

	if arg_9_4 == false then
		VideoPlayer.set_loop(create_video_player, false)
	end
end

UIRenderer.destroy_video_player = function (self, arg_10_1, arg_10_2)
	-- function 10
	if not script_data.disable_video_player then
		return
	end

	local video_players = self.video_players
	local var_10_1 = video_players[arg_10_1]

	assert(var_10_1)
	World.destroy_video_player(arg_10_2 or self.world, var_10_1)

	video_players[arg_10_1] = nil
end

UIRenderer.destroy = function (self, arg_11_1)
	-- function 11
	local video_players = self.video_players

	for k, v in pairs(video_players) do
		World.destroy_video_player(arg_11_1 or self.world, v)

		video_players[k] = nil
	end

	arg_11_1 = arg_11_1 or self.world

	World.destroy_gui(arg_11_1, self.gui)
	World.destroy_gui(arg_11_1, self.gui_retained)
end

UIRenderer.clear_scenegraph_queue = function (self)
	-- function 12
	self.ui_scenegraph = nil

	table.clear(self.scenegraph_queue)
end

UIRenderer.begin_pass = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
	-- function 13
	if not self.ui_scenegraph then
		local ui_scenegraph = self.ui_scenegraph

		self.scenegraph_queue[#self.scenegraph_queue + 1] = ui_scenegraph
		self.ui_scenegraph = arg_13_1

		assert(arg_13_4, "Must provide parent scenegraph id when building multiple depth passes.")
		UISceneGraph.update_scenegraph(arg_13_1, ui_scenegraph, arg_13_4)
	else
		self.ui_scenegraph = arg_13_1

		UISceneGraph.update_scenegraph(arg_13_1)
	end

	self.ui_scenegraph = arg_13_1
	self.input_service = arg_13_2
	self.dt = arg_13_3
	self.render_settings = arg_13_5
end

UIRenderer.end_pass = function (self)
	-- function 14
	self.render_settings = nil

	local scenegraph_queue = self.scenegraph_queue
	local count = #scenegraph_queue

	if count > 0 then
		self.ui_scenegraph = scenegraph_queue[count]
		scenegraph_queue[count] = nil
	else
		self.ui_scenegraph = nil
	end
end

local tbl_2 = {
	alpha_multiplier = 1
}

UIRenderer.draw_all_widgets = function (self, arg_15_1)
	-- function 15
	local render_settings = self.render_settings

	render_settings = render_settings or tbl_2

	local alpha_multiplier = render_settings.alpha_multiplier

	alpha_multiplier = alpha_multiplier or 1

	local draw_widget = UIRenderer.draw_widget

	for k, v in pairs(arg_15_1) do
		local alpha_multiplier_2 = v.content.alpha_multiplier

		alpha_multiplier_2 = alpha_multiplier_2 or 1
		render_settings.alpha_multiplier = alpha_multiplier_2 * alpha_multiplier

		draw_widget(self, v)
	end

	render_settings.alpha_multiplier = alpha_multiplier
end

local start = Profiler.start
local stop = Profiler.stop

UIRenderer.draw_widget = function (self, arg_16_1)
	-- function 16
	local animations = arg_16_1.animations

	if not next(animations) then
		for k in pairs(animations) do
			UIAnimation.update(k, self.dt)

			if not UIAnimation.completed(k) then
				animations[k] = nil
			end
		end
	end

	local UIPasses = UIPasses
	local get_size_scaled = UISceneGraph.get_size_scaled
	local ui_scenegraph = self.ui_scenegraph
	local input_service = self.input_service
	local dt = self.dt
	local scenegraph_id = arg_16_1.scenegraph_id
	local world_position = ui_scenegraph[scenegraph_id].world_position
	local offset = arg_16_1.offset

	offset = offset or UISceneGraph.ZERO_VECTOR3

	local num = world_position[1] + offset[1]
	local num_2 = world_position[2] + offset[2]
	local num_3 = world_position[3] + offset[3]
	local content = arg_16_1.content
	local style = arg_16_1.style
	local var_16_14 = get_size_scaled(ui_scenegraph, scenegraph_id)
	local flag = true
	local input = Managers.input

	if not input then
		local is_device_active = input:is_device_active("gamepad")

		content.is_gamepad_active = is_device_active

		if not content.disable_with_gamepad then
			flag = not is_device_active
		end
	end

	local element = arg_16_1.element
	local dirty = element.dirty
	local passes = element.passes
	local pass_data = element.pass_data

	for j = 1, #passes do
		local var_16_22 = passes[j]
		local pass_type = var_16_22.pass_type
		local var_16_24 = flag

		if content.visible == false then
			var_16_24 = false
		end

		local var_16_25 = content
		local content_id = var_16_22.content_id

		if not content_id then
			var_16_25 = content[content_id]

			if not var_16_25 then
				var_16_25 = content
			else
				var_16_25.parent = content

				if var_16_25.visible == false then
					var_16_24 = false
				end
			end
		end

		local var_16_27 = style
		local style_id = var_16_22.style_id

		if not style_id then
			var_16_27 = style[style_id]

			if not var_16_27 then
				var_16_27.parent = style
			else
				var_16_27 = style
			end
		end

		if not var_16_24 then
			local content_check_function = var_16_22.content_check_function

			if not content_check_function then
				var_16_24 = not not content_check_function(var_16_25, var_16_27)
			end

			if not var_16_24 then
				local content_change_function = var_16_22.content_change_function

				if not content_change_function then
					content_change_function(var_16_25, var_16_27, animations, dt, self.render_settings)
				end
			end
		end

		local var_16_31 = UIPasses[pass_type]
		local var_16_32 = pass_data[j]

		if not var_16_31.update then
			var_16_31.update(self, var_16_32, ui_scenegraph, var_16_22, var_16_27, var_16_25, input_service, dt, var_16_24)
		end

		if not var_16_22.retained_mode then
			if var_16_24 == not var_16_32.visible then
				var_16_32.visible = var_16_24

				if not var_16_24 then
					var_16_32.dirty = true
				else
					var_16_31.destroy(self, var_16_32, var_16_22)

					goto label_16_0
				end
			end

			if not (dirty or var_16_32.dirty) then
				goto label_16_0
			end
		end

		if not var_16_24 then
			local var_16_33 = var_16_14
			local var_16_34 = num
			local var_16_35 = num_2
			local var_16_36 = num_3
			local scenegraph_id_2 = var_16_27.scenegraph_id

			scenegraph_id_2 = scenegraph_id_2 or var_16_22.scenegraph_id

			if not scenegraph_id_2 then
				var_16_33 = get_size_scaled(ui_scenegraph, scenegraph_id_2)

				local world_position_2 = ui_scenegraph[scenegraph_id_2].world_position

				var_16_34, var_16_35, var_16_36 = world_position_2[1], world_position_2[2], world_position_2[3]
			end

			local size = var_16_27.size

			if not size then
				local var_16_40 = Vector2
				local var_16_41 = size[1]

				var_16_41 = var_16_41 or var_16_33[1]

				local var_16_42 = size[2]

				var_16_42 = var_16_42 or var_16_33[2]
				var_16_33 = var_16_40(var_16_41, var_16_42)
			end

			local offset_2 = var_16_27.offset

			if not offset_2 then
				var_16_34 = var_16_34 + offset_2[1]
				var_16_35 = var_16_35 + offset_2[2]

				local var_16_44 = offset_2[3]

				var_16_44 = var_16_44 or 0
				var_16_36 = var_16_36 + var_16_44
			end

			var_16_31.draw(self, var_16_32, ui_scenegraph, var_16_22, var_16_27, var_16_25, Vector3(var_16_34, var_16_35, var_16_36), var_16_33, input_service, dt)
		end

		::label_16_0::
	end

	element.dirty = nil
end

UIRenderer.set_element_visible = function (arg_17_0, arg_17_1, arg_17_2)
	-- function 17
	local UIPasses = UIPasses
	local pass_data = arg_17_1.pass_data
	local passes = arg_17_1.passes

	for i = 1, #passes do
		local var_17_3 = passes[i]

		if not var_17_3.retained_mode then
			local var_17_4 = pass_data[i]

			if arg_17_2 ~= var_17_4.visible then
				if not arg_17_2 then
					var_17_4.dirty = true
				else
					UIPasses[var_17_3.pass_type].destroy(arg_17_0, var_17_4, var_17_3)
				end

				var_17_4.visible = arg_17_2
			end
		end
	end
end

UIRenderer.draw_rect = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	-- function 18
	local render_settings = self.render_settings
	local flag = not render_settings and render_settings.snap_pixel_positions

	if flag == nil then
		flag = SNAP_PIXEL_POSITIONS
	end

	if not flag then
		arg_18_1 = fn_2(arg_18_1)
	end

	local var_18_2 = UIScaleVectorToResolution(arg_18_1)
	local var_18_3 = UIScaleVectorToResolution(arg_18_2)
	local alpha_multiplier

	if not render_settings then
		alpha_multiplier = render_settings.alpha_multiplier

		if not alpha_multiplier then
			-- Nothing
		end
	end

	alpha_multiplier = 1

	::label_18_0::

	arg_18_3 = Color(arg_18_3[1] * alpha_multiplier, arg_18_3[2], arg_18_3[3], arg_18_3[4])

	if arg_18_4 == true then
		return Gui.rect(self.gui_retained, var_18_2, var_18_3, arg_18_3)
	elseif not arg_18_4 then
		return Gui.update_rect(self.gui_retained, arg_18_4, var_18_2, var_18_3, arg_18_3)
	else
		return Gui.rect(self.gui, var_18_2, var_18_3, arg_18_3)
	end
end

UIRenderer.draw_triangle = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	-- function 19
	local render_settings = self.render_settings
	local alpha_multiplier

	if not render_settings then
		alpha_multiplier = render_settings.alpha_multiplier

		if not alpha_multiplier then
			-- Nothing
		end
	end

	alpha_multiplier = 1

	::label_19_0::

	local var_19_2 = Color(arg_19_3.color[1] * alpha_multiplier, arg_19_3.color[2], arg_19_3.color[3], arg_19_3.color[4])
	local var_19_3 = arg_19_1[3]
	local var_19_4 = Vector3(arg_19_1[1], 0, arg_19_1[2])
	local var_19_5
	local var_19_6
	local var_19_7

	if arg_19_3.triangle_alignment == "top_left" then
		var_19_5 = var_19_4
		var_19_6 = var_19_4 + Vector3(0, 0, arg_19_2[2])
		var_19_7 = var_19_4 + Vector3(arg_19_2[1], 0, arg_19_2[2])
	elseif arg_19_3.triangle_alignment == "top_right" then
		var_19_5 = var_19_4 + Vector3(0, 0, arg_19_2[2])
		var_19_6 = var_19_4 + Vector3(arg_19_2[1], 0, arg_19_2[2])
		var_19_7 = var_19_4 + Vector3(arg_19_2[1], 0, 0)
	elseif arg_19_3.triangle_alignment == "bottom_left" then
		var_19_5 = var_19_4
		var_19_6 = var_19_4 + Vector3(arg_19_2[1], 0, 0)
		var_19_7 = var_19_4 + Vector3(0, 0, arg_19_2[2])
	elseif arg_19_3.triangle_alignment == "up" then
		var_19_5 = var_19_4
		var_19_6 = var_19_4 + Vector3(arg_19_2[1], 0, 0)
		var_19_7 = var_19_4 + Vector3(arg_19_2[1] * 0.5, 0, arg_19_2[2])
	elseif arg_19_3.triangle_alignment == "down" then
		var_19_5 = var_19_4 + Vector3(0, 0, arg_19_2[2])
		var_19_6 = var_19_4 + Vector3(arg_19_2[1] * 0.5, 0, 0)
		var_19_7 = var_19_4 + Vector3(arg_19_2[1], 0, arg_19_2[2])
	elseif arg_19_3.triangle_alignment == "left" then
		var_19_5 = var_19_4 + Vector3(0, 0, arg_19_2[2] * 0.5)
		var_19_6 = var_19_4 + Vector3(arg_19_2[1], 0, 0)
		var_19_7 = var_19_4 + Vector3(0, 0, arg_19_2[2])
	elseif arg_19_3.triangle_alignment == "right" then
		var_19_5 = var_19_4 + Vector3(0, 0, arg_19_2[2])
		var_19_6 = var_19_4 + Vector3(arg_19_2[1], 0, arg_19_2[2] * 0.5)
		var_19_7 = var_19_4 + Vector3(0, 0, 0)
	else
		var_19_5 = var_19_4
		var_19_6 = var_19_4 + Vector3(arg_19_2[1], 0, 0)
		var_19_7 = var_19_4 + Vector3(arg_19_2[1], 0, arg_19_2[2])
	end

	if arg_19_4 == true then
		return Gui.triangle(self.gui_retained, UIScaleVectorToResolutionRealCoordinates(var_19_5), UIScaleVectorToResolutionRealCoordinates(var_19_6), UIScaleVectorToResolutionRealCoordinates(var_19_7), var_19_3, var_19_2)
	elseif not arg_19_4 then
		return Gui.update_triangle(self.gui_retained, arg_19_4, UIScaleVectorToResolutionRealCoordinates(var_19_5), UIScaleVectorToResolutionRealCoordinates(var_19_6), UIScaleVectorToResolutionRealCoordinates(var_19_7), var_19_3, var_19_2)
	else
		return Gui.triangle(self.gui, UIScaleVectorToResolutionRealCoordinates(var_19_5), UIScaleVectorToResolutionRealCoordinates(var_19_6), UIScaleVectorToResolutionRealCoordinates(var_19_7), var_19_3, var_19_2)
	end
end

UIRenderer.draw_rect_rotated = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	-- function 20
	arg_20_1 = UIScaleVectorToResolution(arg_20_1)

	local var_20_0 = UIScaleVectorToResolution(arg_20_4)
	local var_20_1 = Rotation2D(Vector3.zero(), arg_20_3, Vector2(var_20_0[1], var_20_0[2]))
	local translation = Matrix4x4.translation(var_20_1)
	local var_20_3 = UIScaleVectorToResolution(arg_20_2)

	translation.x = translation.x + var_20_3.x
	translation.z = translation.z + var_20_3.y

	Matrix4x4.set_translation(var_20_1, translation)

	local render_settings = self.render_settings
	local alpha_multiplier

	if not render_settings then
		alpha_multiplier = render_settings.alpha_multiplier

		if not alpha_multiplier then
			-- Nothing
		end
	end

	alpha_multiplier = 1

	::label_20_0::

	arg_20_5 = Color(arg_20_5[1] * alpha_multiplier, arg_20_5[2], arg_20_5[3], arg_20_5[4])

	Gui.rect_3d(self.gui, var_20_1, Vector3.zero(), arg_20_2[3], arg_20_1, arg_20_5)
end

local str = "arial"
local str_2 = "materials/fonts/" .. str

local function fn_4(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	-- function 21
	local var_21_0 = tostring(arg_21_1[3])
	local tbl = {
		arg_21_1[1],
		arg_21_1[2],
		990
	}
	local tbl_2 = {
		64,
		255,
		0,
		0
	}
	local tbl_3 = {
		192,
		255,
		0,
		0
	}

	UIRenderer.draw_rect(arg_21_0, tbl, {
		arg_21_2[1],
		1
	}, tbl_3)
	UIRenderer.draw_rect(arg_21_0, tbl, {
		1,
		arg_21_2[2]
	}, tbl_3)
	UIRenderer.draw_rect(arg_21_0, {
		tbl[1] + arg_21_2[1],
		tbl[2] + arg_21_2[2],
		tbl[3]
	}, {
		-arg_21_2[1],
		1
	}, tbl_3)
	UIRenderer.draw_rect(arg_21_0, {
		tbl[1] + arg_21_2[1],
		tbl[2] + arg_21_2[2],
		tbl[3]
	}, {
		1,
		-arg_21_2[2]
	}, tbl_3)

	local inv_scale = RESOLUTION_LOOKUP.inv_scale

	if not math.point_is_inside_2d_box(inv_scale * Mouse.axis(2), arg_21_1, arg_21_2) then
		UIRenderer.draw_rect(arg_21_0, tbl, arg_21_2, tbl_2)

		local format = string.format("%s : %s", var_21_0, arg_21_3)
		local text_size, var_21_7 = UIRenderer.text_size(arg_21_0, format, str_2, 12)

		tbl[2] = tbl[2] - var_21_7

		if tbl[1] + text_size > 1920 then
			tbl[1] = tbl[1] - text_size + arg_21_2[1]
		end

		if tbl[2] < 0 then
			tbl[2] = tbl[2] + arg_21_2[2]
		end

		UIRenderer.draw_rect(arg_21_0, tbl, {
			text_size,
			var_21_7
		}, tbl_3)
		UIRenderer.draw_text(arg_21_0, format, str_2, 12, str, {
			tbl[1],
			tbl[2] + 6,
			tbl[3]
		})
	end
end

local tbl_3 = {
	{
		1,
		0
	},
	{
		0,
		1
	}
}

UIRenderer.draw_texture_flip_horizontal = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6)
	-- function 22
	if not (not script_data.ui_debug_draw_texture and not (Keyboard.button(Keyboard.button_index("v")) > 0)) then
		fn_4(self, arg_22_2, arg_22_3, arg_22_1)
	end

	local var_22_0 = UIScaleVectorToResolution(arg_22_2)

	arg_22_3 = UIScaleVectorToResolution(arg_22_3)

	return UIRenderer.script_draw_bitmap_uv(self.gui, self.render_settings, arg_22_1, tbl_3, var_22_0, arg_22_3, arg_22_4, arg_22_5, arg_22_6)
end

UIRenderer.draw_texture = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6, arg_23_7, arg_23_8, arg_23_9)
	-- function 23
	local gui = self.gui

	if not arg_23_7 then
		gui = self.gui_retained

		if arg_23_7 == true then
			arg_23_7 = nil
		end
	end

	local scale = RESOLUTION_LOOKUP.scale
	local script_draw_bitmap = UIRenderer.script_draw_bitmap
	local var_23_3 = gui
	local render_settings = self.render_settings
	local var_23_5 = arg_23_1
	local var_23_6 = Vector3
	local num = arg_23_2[1] * scale
	local num_2 = arg_23_2[2] * scale
	local var_23_9 = arg_23_2[3]

	var_23_9 = var_23_9 or 0

	local var_23_10 = var_23_6(num, num_2, var_23_9)
	local var_23_11 = Vector3
	local num_3 = arg_23_3[1] * scale
	local num_4 = arg_23_3[2] * scale
	local var_23_14 = arg_23_3[3]

	var_23_14 = var_23_14 or 0

	return script_draw_bitmap(var_23_3, render_settings, var_23_5, var_23_10, var_23_11(num_3, num_4, var_23_14), arg_23_4, arg_23_5, arg_23_6, arg_23_7, arg_23_8, arg_23_9)
end

UIRenderer.draw_texture_uv = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6, arg_24_7, arg_24_8, arg_24_9, arg_24_10)
	-- function 24
	if not (not script_data.ui_debug_draw_texture and not (Keyboard.button(Keyboard.button_index("v")) > 0)) then
		fn_4(self, arg_24_2, arg_24_3, arg_24_1)
	end

	local var_24_0 = UIScaleVectorToResolution(arg_24_2)

	arg_24_3 = UIScaleVectorToResolution(arg_24_3)

	if arg_24_8 == true then
		return UIRenderer.script_draw_bitmap_uv(self.gui_retained, self.render_settings, arg_24_1, arg_24_4, var_24_0, arg_24_3, arg_24_5, arg_24_6, arg_24_7, nil, arg_24_9, arg_24_10)
	elseif not arg_24_8 then
		return UIRenderer.script_draw_bitmap_uv(self.gui_retained, self.render_settings, arg_24_1, arg_24_4, var_24_0, arg_24_3, arg_24_5, arg_24_6, arg_24_7, arg_24_8, arg_24_9, arg_24_10)
	else
		return UIRenderer.script_draw_bitmap_uv(self.gui, self.render_settings, arg_24_1, arg_24_4, var_24_0, arg_24_3, arg_24_5, arg_24_6, arg_24_7, nil, arg_24_9, arg_24_10)
	end
end

UIRenderer.draw_gradient_mask_texture = function (self, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6, arg_25_7)
	-- function 25
	if not (not script_data.ui_debug_draw_texture and not (Keyboard.button(Keyboard.button_index("v")) > 0)) then
		fn_4(self, arg_25_2, arg_25_3, arg_25_1)
	end

	local gui = self.gui
	local gui_retained = self.gui_retained
	local var_25_2 = UIScaleVectorToResolution(arg_25_2)
	local var_25_3 = UIScaleVectorToResolution(arg_25_3)
	local has_atlas_settings_by_texture_name = UIAtlasHelper.has_atlas_settings_by_texture_name(arg_25_1)

	has_atlas_settings_by_texture_name = not has_atlas_settings_by_texture_name and UIAtlasHelper.get_atlas_settings_by_texture_name(arg_25_1)

	local material = Gui.material
	local flag = not arg_25_7 and gui_retained and gui
	local material_name

	if not has_atlas_settings_by_texture_name then
		material_name = has_atlas_settings_by_texture_name.material_name

		if not material_name then
			-- Nothing
		end
	end

	material_name = arg_25_1

	::label_25_0::

	local var_25_8 = material(flag, material_name)

	Material.set_scalar(var_25_8, "gradient_threshold", arg_25_6)

	if arg_25_7 == true then
		return UIRenderer.script_draw_bitmap(self.gui_retained, self.render_settings, arg_25_1, var_25_2, var_25_3, arg_25_4, arg_25_5, nil, nil)
	elseif not arg_25_7 then
		return UIRenderer.script_draw_bitmap(self.gui_retained, self.render_settings, arg_25_1, var_25_2, var_25_3, arg_25_4, arg_25_5, nil, arg_25_7)
	else
		return UIRenderer.script_draw_bitmap(self.gui, self.render_settings, arg_25_1, var_25_2, var_25_3, arg_25_4, arg_25_5, nil)
	end
end

local tbl_4 = {}

UIRenderer.draw_multi_texture = function (self, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6, arg_26_7, arg_26_8, arg_26_9, arg_26_10, arg_26_11, arg_26_12, arg_26_13, arg_26_14, arg_26_15, arg_26_16)
	-- function 26
	local script_draw_bitmap = UIRenderer.script_draw_bitmap
	local draw_tiled_texture = UIRenderer.draw_tiled_texture

	arg_26_7 = arg_26_7 or 1
	arg_26_9 = arg_26_9 or 1

	local var_26_2 = UIScaleVectorToResolution(arg_26_2)
	local var_26_3 = Vector3(arg_26_2[1], arg_26_2[2], arg_26_2[3])
	local var_26_4 = Vector3(arg_26_2[1], arg_26_2[2], arg_26_2[3])

	arg_26_8 = not arg_26_8 and UIScaleVectorToResolution(arg_26_8)

	local gui = self.gui
	local gui_retained = self.gui_retained

	arg_26_6 = arg_26_6 or tbl_4

	local flag = arg_26_9 == 2
	local flag_2 = arg_26_10 or #arg_26_1

	if flag_2 <= 0 then
		return
	end

	local var_26_9

	if arg_26_16 == true then
		var_26_9 = {}
	end

	for i = 1, flag_2 do
		local var_26_10 = arg_26_1[i]

		arg_26_3 = not arg_26_4 and arg_26_4[i] and arg_26_3

		local var_26_11 = arg_26_12
		local var_26_12 = arg_26_15

		if not arg_26_11 then
			var_26_11 = arg_26_11[i] or arg_26_12
		end

		if not arg_26_14 then
			var_26_12 = arg_26_14[i] or arg_26_15
		end

		local var_26_13 = arg_26_6[i]

		if not var_26_13 then
			local var_26_14 = UIScaleVectorToResolution(var_26_13)

			if i ~= 1 or not flag then
				var_26_2[arg_26_7] = var_26_2[arg_26_7] - var_26_14[arg_26_7]
				var_26_4[arg_26_7] = var_26_4[arg_26_7] - var_26_13[arg_26_7]
			end

			local flag_3 = not arg_26_5 and arg_26_5[i]

			if not flag_3 then
				local var_26_16 = UIScaleVectorToResolution(flag_3)

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
				var_26_17 = draw_tiled_texture(self, var_26_10, var_26_3, var_26_13, arg_26_3, var_26_11, arg_26_13, arg_26_16)
			elseif not arg_26_16 then
				var_26_17 = arg_26_16[i]

				draw_tiled_texture(self, var_26_10, var_26_3, var_26_13, arg_26_3, var_26_11, arg_26_13, var_26_17)
			else
				draw_tiled_texture(self, var_26_10, var_26_3, var_26_13, arg_26_3, var_26_11, arg_26_13)
			end

			if not var_26_9 then
				var_26_9[i] = var_26_17
			end

			if not flag then
				var_26_2[arg_26_7] = var_26_2[arg_26_7] - var_26_14[arg_26_7]
				var_26_4[arg_26_7] = var_26_4[arg_26_7] - var_26_13[arg_26_7]
			else
				var_26_2[arg_26_7] = var_26_2[arg_26_7] + var_26_14[arg_26_7]
				var_26_4[arg_26_7] = var_26_4[arg_26_7] + var_26_13[arg_26_7]
			end
		else
			local var_26_18 = UIScaleVectorToResolution(arg_26_3)

			if i ~= 1 or not flag then
				var_26_2[arg_26_7] = var_26_2[arg_26_7] - var_26_18[arg_26_7]
				var_26_4[arg_26_7] = var_26_4[arg_26_7] - arg_26_3[arg_26_7]
			end

			local flag_4 = not arg_26_5 and arg_26_5[i]

			if not flag_4 then
				local var_26_20 = UIScaleVectorToResolution(flag_4)

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
				var_26_21 = script_draw_bitmap(gui_retained, self.render_settings, var_26_10, var_26_3, var_26_18, var_26_11, arg_26_13, var_26_12, nil)
			elseif not arg_26_16 then
				var_26_21 = arg_26_16[i]

				script_draw_bitmap(gui_retained, self.render_settings, var_26_10, var_26_3, var_26_18, var_26_11, arg_26_13, var_26_12, var_26_21)
			else
				script_draw_bitmap(gui, self.render_settings, var_26_10, var_26_3, var_26_18, var_26_11, arg_26_13, var_26_12)
			end

			if not var_26_9 then
				var_26_9[i] = var_26_21
			end

			if not flag then
				var_26_2[arg_26_7] = var_26_2[arg_26_7] - var_26_18[arg_26_7]
				var_26_4[arg_26_7] = var_26_4[arg_26_7] - arg_26_3[arg_26_7]
			else
				var_26_2[arg_26_7] = var_26_2[arg_26_7] + var_26_18[arg_26_7]
				var_26_4[arg_26_7] = var_26_4[arg_26_7] + arg_26_3[arg_26_7]
			end
		end

		if not arg_26_8 then
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

local tbl_5 = {
	{
		0,
		0
	},
	{
		1,
		1
	}
}

UIRenderer.draw_tiled_texture = function (self, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6, arg_27_7, arg_27_8)
	-- function 27
	local scale = RESOLUTION_LOOKUP.scale
	local num = scale * arg_27_2[1]
	local num_2 = scale * arg_27_2[2]
	local var_27_3 = Vector3
	local var_27_4 = num
	local var_27_5 = num_2
	local var_27_6 = arg_27_2[3]

	var_27_6 = var_27_6 or 0
	arg_27_2 = var_27_3(var_27_4, var_27_5, var_27_6)

	local var_27_7 = arg_27_4[1]
	local var_27_8 = arg_27_4[2]
	local num_3 = arg_27_3[1] / var_27_7
	local num_4 = arg_27_3[2] / var_27_8
	local num_5 = scale * var_27_7
	local num_6 = scale * var_27_8

	arg_27_4 = Vector2(num_5, num_6)

	local script_draw_bitmap_uv = UIRenderer.script_draw_bitmap_uv
	local gui = self.gui
	local render_settings = self.render_settings
	local var_27_16 = tbl_5

	var_27_16[2][1] = 1

	while num_3 > 0 do
		if num_3 < 1 then
			var_27_16[2][1] = num_3
			arg_27_4[1] = num_3 * num_5
		end

		local var_27_17 = num_2

		arg_27_2[2] = var_27_17
		var_27_16[2][2] = 1
		arg_27_4[2] = num_6

		local var_27_18 = num_4

		while var_27_18 > 0 do
			if var_27_18 < 1 then
				var_27_16[2][2] = var_27_18
				arg_27_4[2] = var_27_18 * num_6
			end

			script_draw_bitmap_uv(gui, render_settings, arg_27_1, var_27_16, arg_27_2, arg_27_4, arg_27_5, arg_27_6, arg_27_7)

			var_27_17 = var_27_17 + num_6
			arg_27_2[2] = var_27_17
			var_27_18 = var_27_18 - 1
		end

		num = num + num_5
		arg_27_2[1] = num
		num_3 = num_3 - 1
	end
end

UIRenderer.draw_centered_texture_amount = function (self, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6, arg_28_7, arg_28_8, arg_28_9, arg_28_10, arg_28_11)
	-- function 28
	local var_28_0 = UIScaleVectorToResolution(arg_28_2)
	local var_28_1 = UIScaleVectorToResolution(arg_28_3)

	arg_28_4 = UIScaleVectorToResolution(arg_28_4)

	local var_28_2 = Vector2(arg_28_4[1], arg_28_4[2])
	local num = var_28_1[arg_28_6] / (arg_28_5 + 1)
	local flag = type(arg_28_1) == "table"
	local gui = self.gui
	local gui_retained = self.gui_retained
	local var_28_7

	if arg_28_11 == true then
		var_28_7 = {}
	end

	for i = 1, arg_28_5 do
		local var_28_8

		if not arg_28_9 and not arg_28_9[i] then
			var_28_8 = arg_28_9[i]

			if not var_28_8 then
				-- Nothing
			end
		end

		var_28_8 = arg_28_8

		::label_28_0::

		local var_28_9 = Vector3(var_28_0.x, var_28_0.y, var_28_0.z)

		var_28_9[arg_28_6] = var_28_9[arg_28_6] + (num * i - arg_28_4[arg_28_6] * 0.5)

		if arg_28_11 == true then
			local script_draw_bitmap = UIRenderer.script_draw_bitmap
			local var_28_11 = gui_retained
			local render_settings = self.render_settings
			local var_28_13

			if not flag then
				var_28_13 = arg_28_1[i]

				if not var_28_13 then
					-- Nothing
				end
			end

			var_28_13 = arg_28_1

			::label_28_1::

			var_28_7[i] = script_draw_bitmap(var_28_11, render_settings, var_28_13, var_28_9, var_28_2, var_28_8, arg_28_10, nil, nil)
		elseif not arg_28_11 then
			local var_28_14 = arg_28_11[i]
			local script_draw_bitmap_2 = UIRenderer.script_draw_bitmap
			local var_28_16 = gui_retained
			local render_settings_2 = self.render_settings
			local var_28_18

			if not flag then
				var_28_18 = arg_28_1[i]

				if not var_28_18 then
					-- Nothing
				end
			end

			var_28_18 = arg_28_1

			::label_28_2::

			script_draw_bitmap_2(var_28_16, render_settings_2, var_28_18, var_28_9, var_28_2, var_28_8, arg_28_10, nil, var_28_14)
		else
			local script_draw_bitmap_3 = UIRenderer.script_draw_bitmap
			local var_28_20 = gui
			local render_settings_3 = self.render_settings
			local var_28_22

			if not flag then
				var_28_22 = arg_28_1[i]

				if not var_28_22 then
					-- Nothing
				end
			end

			var_28_22 = arg_28_1

			::label_28_3::

			script_draw_bitmap_3(var_28_20, render_settings_3, var_28_22, var_28_9, var_28_2, var_28_8, arg_28_10, nil)
		end
	end

	return var_28_7
end

UIRenderer.draw_texture_rotated = function (self, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6, arg_29_7, arg_29_8, arg_29_9)
	-- function 29
	arg_29_2 = UIScaleVectorToResolution(arg_29_2)

	local var_29_0 = UIScaleVectorToResolution(arg_29_5)
	local var_29_1 = Rotation2D(Vector3.zero(), arg_29_4, Vector2(var_29_0[1], var_29_0[2]))
	local translation = Matrix4x4.translation(var_29_1)
	local var_29_3 = UIScaleVectorToResolution(arg_29_3)

	translation.x = translation.x + var_29_3.x
	translation.z = translation.z + var_29_3.y

	local render_settings = self.render_settings
	local flag = not render_settings and render_settings.snap_pixel_positions

	if flag == nil then
		flag = SNAP_PIXEL_POSITIONS
	end

	if not flag then
		translation = fn_2(translation)
	end

	Matrix4x4.set_translation(var_29_1, translation)

	local gui = self.gui
	local gui_retained = self.gui_retained

	if arg_29_9 == true then
		return UIRenderer.script_draw_bitmap_3d(gui_retained, render_settings, arg_29_1, var_29_1, arg_29_3[3], arg_29_2, arg_29_6, arg_29_7, arg_29_8, nil)
	elseif not arg_29_9 then
		return UIRenderer.script_draw_bitmap_3d(gui_retained, render_settings, arg_29_1, var_29_1, arg_29_3[3], arg_29_2, arg_29_6, arg_29_7, arg_29_8, arg_29_9)
	else
		return UIRenderer.script_draw_bitmap_3d(gui, render_settings, arg_29_1, var_29_1, arg_29_3[3], arg_29_2, arg_29_6, arg_29_7, arg_29_8)
	end
end

local tbl_6 = {}

UIRenderer.draw_text = function (self, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5, arg_30_6, arg_30_7, arg_30_8)
	-- function 30
	local var_30_0 = UIScaleVectorToResolution(arg_30_5)

	if not (not arg_30_8 and #arg_30_8 > 0 or nil) then
		tbl_6[#tbl_6 + 1] = "color_override"
		tbl_6[#tbl_6 + 1] = arg_30_8
	end

	local flag = #tbl_6 > 0
	local var_30_2
	local render_settings = self.render_settings
	local alpha_multiplier

	if not render_settings then
		alpha_multiplier = render_settings.alpha_multiplier

		if not alpha_multiplier then
			-- Nothing
		end
	end

	alpha_multiplier = 1

	::label_30_0::

	arg_30_6 = not arg_30_6 and Color(arg_30_6[1] * alpha_multiplier, arg_30_6[2], arg_30_6[3], arg_30_6[4])

	if not (not render_settings and render_settings.offscreen_target) then
		arg_30_4 = arg_30_4 .. "_offscreen"
	end

	local FormatDirectives = Gui.FormatDirectives
	local var_30_6 = Fonts[arg_30_4]
	local flag_2 = not var_30_6 and var_30_6[4]

	if not flag_2 then
		FormatDirectives = bit.bor(FormatDirectives, flag_2)
	end

	if not flag then
		if arg_30_7 == true then
			var_30_2 = Gui.text(self.gui_retained, arg_30_1, arg_30_2, arg_30_3, arg_30_4, var_30_0, arg_30_6, FormatDirectives, unpack(tbl_6))
		elseif not arg_30_7 then
			Gui.update_text(self.gui_retained, arg_30_7, arg_30_1, arg_30_2, arg_30_3, arg_30_4, var_30_0, arg_30_6, FormatDirectives, unpack(tbl_6))
		else
			Gui.text(self.gui, arg_30_1, arg_30_2, arg_30_3, arg_30_4, var_30_0, arg_30_6, FormatDirectives, unpack(tbl_6))
		end
	elseif arg_30_7 == true then
		var_30_2 = Gui.text(self.gui_retained, arg_30_1, arg_30_2, arg_30_3, arg_30_4, var_30_0, arg_30_6, FormatDirectives)
	elseif not arg_30_7 then
		Gui.update_text(self.gui_retained, arg_30_7, arg_30_1, arg_30_2, arg_30_3, arg_30_4, var_30_0, arg_30_6, FormatDirectives)
	else
		Gui.text(self.gui, arg_30_1, arg_30_2, arg_30_3, arg_30_4, var_30_0, arg_30_6, FormatDirectives)
	end

	if not flag then
		table.clear(tbl_6)
	end

	return var_30_2
end

UIRenderer.draw_justified_text = function (self, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5, arg_31_6, arg_31_7, arg_31_8, ...)
	-- function 31
	local var_31_0 = UIScaleVectorToResolution(arg_31_5)
	local render_settings = self.render_settings
	local alpha_multiplier

	if not render_settings then
		alpha_multiplier = render_settings.alpha_multiplier

		if not alpha_multiplier then
			-- Nothing
		end
	end

	alpha_multiplier = 1

	::label_31_0::

	arg_31_6 = not arg_31_6 and Color(arg_31_6[1] * alpha_multiplier, arg_31_6[2], arg_31_6[3], arg_31_6[4])

	local FormatDirectives = Gui.FormatDirectives
	local var_31_4 = Fonts[arg_31_4]
	local flag = not var_31_4 and var_31_4[4]

	if not flag then
		FormatDirectives = bit.bor(FormatDirectives, flag)
	end

	local num = arg_31_8 * RESOLUTION_LOOKUP.scale

	if arg_31_7 == true then
		return Gui.text(self.gui_retained, arg_31_1, arg_31_2, arg_31_3, arg_31_4, var_31_0, arg_31_6, FormatDirectives, "justify", num, ...)
	elseif not arg_31_7 then
		Gui.update_text(self.gui_retained, arg_31_7, arg_31_1, arg_31_2, arg_31_3, arg_31_4, var_31_0, arg_31_6, FormatDirectives, "justify", num, ...)
	else
		Gui.text(self.gui, arg_31_1, arg_31_2, arg_31_3, arg_31_4, var_31_0, arg_31_6, FormatDirectives, "justify", num, ...)
	end
end

UIRenderer.word_wrap = function (self, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6)
	-- function 32
	local str = " 。，"
	local str_2 = " -+&/*"
	local str_3 = "\n"
	local flag = true
	local scale = RESOLUTION_LOOKUP.scale
	local var_32_5
	local var_32_6
	local FormatDirectives = Gui.FormatDirectives

	if not arg_32_6 then
		local var_32_8 = Fonts[arg_32_6]
		local flag_2 = not var_32_8 and var_32_8[4]

		if not var_32_8[4] then
			FormatDirectives = bit.bor(FormatDirectives, flag_2)
		end
	end

	if not arg_32_5 then
		var_32_5, var_32_6 = Gui.word_wrap(self.gui, arg_32_1, arg_32_2, arg_32_3, arg_32_4 * scale, str, str_2, str_3, flag, arg_32_5, FormatDirectives)
	else
		var_32_5, var_32_6 = Gui.word_wrap(self.gui, arg_32_1, arg_32_2, arg_32_3, arg_32_4 * scale, str, str_2, str_3, flag, FormatDirectives)
	end

	return var_32_5, var_32_6
end

UIRenderer.text_size = function (self, arg_33_1, arg_33_2, arg_33_3, ...)
	-- function 33
	local text_extents, var_33_1 = Gui.text_extents(self.gui, arg_33_1, arg_33_2, arg_33_3, Gui.FormatDirectives, ...)
	local inv_scale = RESOLUTION_LOOKUP.inv_scale
	local num = (var_33_1.x + text_extents.x) * inv_scale
	local num_2 = (var_33_1.y - text_extents.y) * inv_scale

	return num, num_2, text_extents
end

UIRenderer.text_alignment_size = function (self, arg_34_1, arg_34_2, arg_34_3, ...)
	-- function 34
	local text_extents, var_34_1 = Gui.text_extents(self.gui, arg_34_1, arg_34_2, arg_34_3, Gui.FormatDirectives, ...)
	local inv_scale = RESOLUTION_LOOKUP.inv_scale
	local num = (var_34_1.x + 0) * inv_scale
	local num_2 = (var_34_1.y - text_extents.y) * inv_scale

	return num, num_2, text_extents
end

UIRenderer.break_paragraphs = function (arg_35_0, arg_35_1)
	-- function 35
	local num = 1

	for iter_35_0 in string.gmatch(arg_35_0, "[^\n]+") do
		arg_35_1[num] = iter_35_0
		num = num + 1
	end

	return arg_35_1, num
end

UIRenderer.draw_video = function (self, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6)
	-- function 36
	if not script_data.disable_video_player then
		return true
	end

	local gui = self.gui
	local flag = arg_36_6 or self.video_players[arg_36_5]
	local flag_2 = true
	local render_settings = self.render_settings
	local alpha_multiplier

	if not render_settings then
		alpha_multiplier = render_settings.alpha_multiplier

		if not alpha_multiplier then
			-- Nothing
		end
	end

	alpha_multiplier = 1

	::label_36_0::

	arg_36_4 = not arg_36_4 and Color(arg_36_4[1] * alpha_multiplier, arg_36_4[2], arg_36_4[3], arg_36_4[4])

	Gui.video(gui, arg_36_1, flag, UIScaleVectorToResolution(arg_36_2), UIScaleVectorToResolution(arg_36_3, flag_2), arg_36_4)

	return VideoPlayer.current_frame(flag) == VideoPlayer.number_of_frames(flag)
end

UIRenderer.draw_splash_video = function (self, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5, arg_37_6)
	-- function 37
	if not script_data.disable_video_player then
		return true
	end

	local flag = arg_37_6 or self.video_players[arg_37_5]

	if VideoPlayer.current_frame(flag) == VideoPlayer.number_of_frames(flag) then
		return true
	end

	local gui = self.gui
	local resolution, var_37_3 = Gui.resolution()
	local num = resolution / var_37_3
	local num_2 = 1.7777777777777777
	local var_37_6 = var_37_3
	local var_37_7 = resolution

	if math.abs(num - num_2) > 0.005 then
		var_37_7 = resolution
		var_37_6 = var_37_7 / num_2

		if var_37_3 < var_37_6 then
			var_37_7 = var_37_3 * num_2
			var_37_6 = var_37_3
		end
	end

	local render_settings = self.render_settings
	local alpha_multiplier

	if not render_settings then
		alpha_multiplier = render_settings.alpha_multiplier

		if not alpha_multiplier then
			-- Nothing
		end
	end

	alpha_multiplier = 1

	::label_37_0::

	arg_37_4 = not arg_37_4 and Color(arg_37_4[1] * alpha_multiplier, arg_37_4[2], arg_37_4[3], arg_37_4[4])

	Gui.video(gui, arg_37_1, flag, Vector3(resolution * 0.5 - var_37_7 * 0.5, var_37_3 * 0.5 - var_37_6 * 0.5, arg_37_2[3]), Vector2(var_37_7, var_37_6), arg_37_4)
end

local tbl_7 = {}
local num = 32

for i = 1, num do
	local num_2 = i / num * math.pi * 2

	tbl_7[i * 2 - 1] = math.cos(num_2)
	tbl_7[i * 2] = math.sin(num_2)
end

UIRenderer.draw_circle = function (self, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
	-- function 38
	local gui = self.gui
	local triangle = Gui.triangle
	local render_settings = self.render_settings
	local alpha_multiplier

	if not render_settings then
		alpha_multiplier = render_settings.alpha_multiplier

		if not alpha_multiplier then
			-- Nothing
		end
	end

	alpha_multiplier = 1

	::label_38_0::

	arg_38_4 = not arg_38_4 and Color(arg_38_4[1] * alpha_multiplier, arg_38_4[2], arg_38_4[3], arg_38_4[4])

	local num_2 = 999
	local var_38_5 = Vector3(unpack(arg_38_1))

	var_38_5.z = var_38_5.y

	local x = var_38_5.x
	local y = var_38_5.y
	local var_38_8 = Vector3(x + tbl_7[1] * arg_38_2, 0, y + tbl_7[2] * arg_38_2)

	for i = 2, num do
		local var_38_9 = Vector3(x + tbl_7[i * 2 - 1] * arg_38_2, 0, y + tbl_7[i * 2] * arg_38_2)

		triangle(gui, var_38_5, var_38_8, var_38_9, num_2, arg_38_4)

		var_38_8 = var_38_9
	end

	local var_38_10 = Vector3(x + tbl_7[1] * arg_38_2, 0, y + tbl_7[2] * arg_38_2)

	triangle(gui, var_38_5, var_38_8, var_38_10, num_2, arg_38_4)
end

UIRenderer.draw_rounded_rect = function (self, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
	-- function 39
	local scale = RESOLUTION_LOOKUP.scale
	local triangle = Gui.triangle

	arg_39_1 = UIScaleVectorToResolution(arg_39_1)
	arg_39_2 = UIScaleVectorToResolution(arg_39_2)
	arg_39_3 = arg_39_3 * scale

	local num_2 = num / 4
	local var_39_3 = arg_39_1[1]
	local var_39_4 = arg_39_1[2]
	local var_39_5 = arg_39_2[1]
	local var_39_6 = arg_39_2[2]
	local gui = self.gui
	local var_39_8 = arg_39_1[3]
	local var_39_9 = Vector3(arg_39_1[1] + var_39_5 / 2, 0, arg_39_1[2] + var_39_6 / 2)
	local var_39_10 = Vector3(var_39_3 + var_39_5 - arg_39_3 + tbl_7[1] * arg_39_3, 0, var_39_4 + var_39_6 - arg_39_3 + tbl_7[2] * arg_39_3)
	local render_settings = self.render_settings
	local alpha_multiplier

	if not render_settings then
		alpha_multiplier = render_settings.alpha_multiplier

		if not alpha_multiplier then
			-- Nothing
		end
	end

	alpha_multiplier = 1

	::label_39_0::

	arg_39_4 = not arg_39_4 and Color(arg_39_4[1] * alpha_multiplier, arg_39_4[2], arg_39_4[3], arg_39_4[4])

	for i = 2, num_2 do
		local var_39_13 = Vector3(var_39_3 + var_39_5 - arg_39_3 + tbl_7[i * 2 - 1] * arg_39_3, 0, var_39_4 + var_39_6 - arg_39_3 + tbl_7[i * 2] * arg_39_3)

		triangle(gui, var_39_9, var_39_10, var_39_13, var_39_8, arg_39_4)

		var_39_10 = var_39_13
	end

	for j = num_2, num_2 * 2 do
		local var_39_14 = Vector3(var_39_3 + arg_39_3 + tbl_7[j * 2 - 1] * arg_39_3, 0, var_39_4 + var_39_6 - arg_39_3 + tbl_7[j * 2] * arg_39_3)

		triangle(gui, var_39_9, var_39_10, var_39_14, var_39_8, arg_39_4)

		var_39_10 = var_39_14
	end

	for k = num_2 * 2, num_2 * 3 do
		local var_39_15 = Vector3(var_39_3 + arg_39_3 + tbl_7[k * 2 - 1] * arg_39_3, 0, var_39_4 + arg_39_3 + tbl_7[k * 2] * arg_39_3)

		triangle(gui, var_39_9, var_39_10, var_39_15, var_39_8, arg_39_4)

		var_39_10 = var_39_15
	end

	for l = num_2 * 3, num_2 * 4 do
		local var_39_16 = Vector3(var_39_3 + var_39_5 - arg_39_3 + tbl_7[l * 2 - 1] * arg_39_3, 0, var_39_4 + arg_39_3 + tbl_7[l * 2] * arg_39_3)

		triangle(gui, var_39_9, var_39_10, var_39_16, var_39_8, arg_39_4)

		var_39_10 = var_39_16
	end

	local var_39_17 = Vector3(var_39_3 + var_39_5 - arg_39_3 + tbl_7[1] * arg_39_3, 0, var_39_4 + arg_39_3 + tbl_7[2] * arg_39_3)

	triangle(gui, var_39_9, var_39_10, var_39_17, var_39_8, arg_39_4)

	local var_39_18 = var_39_17
	local var_39_19 = Vector3(var_39_3 + var_39_5 - arg_39_3 + tbl_7[1] * arg_39_3, 0, var_39_4 + var_39_6 - arg_39_3 + tbl_7[2] * arg_39_3)

	triangle(gui, var_39_9, var_39_18, var_39_19, var_39_8, arg_39_4)
end

local tbl_8 = {
	0,
	0,
	0
}

UIRenderer.scaled_cursor_position_by_scenegraph = function (self, arg_40_1, arg_40_2, arg_40_3)
	-- function 40
	local get = self:get("cursor")

	get = get or tbl_8

	local var_40_1

	if not arg_40_3 then
		var_40_1 = UIInverseScaleVectorToResolution(get)

		if not var_40_1 then
			-- Nothing
		end
	end

	var_40_1 = get

	::label_40_0::

	local get_world_position = UISceneGraph.get_world_position(arg_40_1, arg_40_2)

	var_40_1.x = var_40_1.x - get_world_position[1]
	var_40_1.y = var_40_1.y - get_world_position[2]

	return var_40_1
end

UIRenderer.crop_text = function (arg_41_0, arg_41_1)
	-- function 41
	if arg_41_1 < Utf8.length(arg_41_0) then
		return UTF8Utils.sub_string(arg_41_0, 1, arg_41_1) .. "..."
	end

	return arg_41_0
end

local str_3 = "..."

UIRenderer.crop_text_width = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	-- function 42
	local var_42_0, var_42_1 = UIFontByResolution(arg_42_3)
	local text_size = UIRenderer.text_size(arg_42_0, arg_42_1, var_42_0[1], var_42_1)
	local text_size_2 = UIRenderer.text_size(arg_42_0, str_3, var_42_0[1], var_42_1)

	if arg_42_2 < text_size then
		repeat
			local num = 1 - (1 - (arg_42_2 - text_size_2) / text_size) * 0.5
			local length = Utf8.length(arg_42_1)
			local floor = math.floor(length * num)

			arg_42_1 = UTF8Utils.sub_string(arg_42_1, 1, floor)

			if floor <= 0 then
				return arg_42_1
			end

			text_size = math.floor(UIRenderer.text_size(arg_42_0, arg_42_1, var_42_0[1], var_42_1))
		until text_size <= arg_42_2

		local length_2 = Utf8.length(arg_42_1)

		arg_42_1 = UTF8Utils.sub_string(arg_42_1, 1, length_2) .. "..."
	end

	return arg_42_1
end

UIRenderer.scaled_font_size_by_area = function (self, arg_43_1, arg_43_2, arg_43_3)
	-- function 43
	local var_43_0 = arg_43_2[1]
	local var_43_1 = arg_43_2[2]
	local font_type = arg_43_3.font_type
	local var_43_3 = Fonts[font_type][1]
	local gui = self.gui

	for i = arg_43_3.font_size, 1, -0.5 do
		local var_43_5, var_43_6, var_43_7 = UIGetFontHeight(gui, font_type, i)
		local word_wrap = Gui.word_wrap(gui, arg_43_1, var_43_3, i, var_43_0, " 。，", "-+&/*", "\n", true, Gui.FormatDirectives)

		if var_43_1 > math.ceil(1.05 * (var_43_7 - var_43_6) * #word_wrap) then
			return i
		end
	end

	return 1
end

UIRenderer.scaled_font_size_by_width = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	-- function 44
	local var_44_0, var_44_1 = UIFontByResolution(arg_44_3)
	local text_size = UIRenderer.text_size(arg_44_0, arg_44_1, var_44_0[1], var_44_1)
	local num = 1
	local font_size = arg_44_3.font_size

	while arg_44_2 < text_size do
		if num >= arg_44_3.font_size then
			break
		end

		arg_44_3.font_size = math.max(arg_44_3.font_size - 1, num)

		local var_44_5, var_44_6 = UIFontByResolution(arg_44_3)

		text_size = math.floor(UIRenderer.text_size(arg_44_0, arg_44_1, var_44_5[1], var_44_6))
	end

	local font_size_2 = arg_44_3.font_size

	arg_44_3.font_size = font_size

	return font_size_2
end

local tbl_9 = {
	{
		0,
		0
	},
	{
		0,
		0
	}
}
local tbl_10 = {
	{
		0,
		0
	},
	{
		0,
		0
	}
}
local tbl_11 = {
	{
		0,
		0
	},
	{
		0,
		0
	}
}

UIRenderer.draw_texture_frame = function (self, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6, arg_45_7, arg_45_8, arg_45_9, arg_45_10, arg_45_11, arg_45_12, arg_45_13)
	-- function 45
	local gui = self.gui
	local gui_retained = self.gui_retained

	arg_45_1 = UIScaleVectorToResolution(arg_45_1)
	arg_45_2 = UIScaleVectorToResolution(arg_45_2)
	arg_45_4 = UIScaleVectorToResolution(arg_45_4)

	local var_45_2 = arg_45_1[3]
	local var_45_3 = UIScaleVectorToResolution(arg_45_5.corner)
	local var_45_4 = var_45_3[1]
	local var_45_5 = var_45_3[2]
	local x = arg_45_1.x
	local y = arg_45_1.y
	local var_45_8 = arg_45_4[1]
	local var_45_9 = arg_45_4[2]
	local x_2 = arg_45_2.x
	local y_2 = arg_45_2.y
	local num = 1
	local var_45_13

	if arg_45_13 == true then
		var_45_13 = {}
	end

	local num_2 = var_45_4 / var_45_8
	local num_3 = var_45_5 / var_45_9

	tbl_9[1][1] = 0
	tbl_9[1][2] = 1 - num_3
	tbl_9[2][1] = num_2
	tbl_9[2][2] = 1

	if arg_45_13 == true then
		var_45_13[#var_45_13 + 1] = UIRenderer.script_draw_bitmap_uv(gui_retained, self.render_settings, arg_45_3, tbl_9, Vector3(x, y, var_45_2), var_45_3, arg_45_6, arg_45_7, arg_45_8, nil)
	elseif not arg_45_13 then
		local var_45_16 = arg_45_13[num]

		UIRenderer.script_draw_bitmap_uv(gui_retained, self.render_settings, arg_45_3, tbl_9, Vector3(x, y, var_45_2), var_45_3, arg_45_6, arg_45_7, arg_45_8, var_45_16)

		num = num + 1
	else
		UIRenderer.script_draw_bitmap_uv(gui, self.render_settings, arg_45_3, tbl_9, Vector3(x, y, var_45_2), var_45_3, arg_45_6, arg_45_7, arg_45_8)
	end

	tbl_9[1][1] = 0
	tbl_9[1][2] = 0
	tbl_9[2][1] = num_2
	tbl_9[2][2] = num_3

	if arg_45_13 == true then
		var_45_13[#var_45_13 + 1] = UIRenderer.script_draw_bitmap_uv(gui_retained, self.render_settings, arg_45_3, tbl_9, Vector3(x, y + y_2 - var_45_5, var_45_2), var_45_3, arg_45_6, arg_45_7, arg_45_8, nil)
	elseif not arg_45_13 then
		local var_45_17 = arg_45_13[num]

		UIRenderer.script_draw_bitmap_uv(gui_retained, self.render_settings, arg_45_3, tbl_9, Vector3(x, y + y_2 - var_45_5, var_45_2), var_45_3, arg_45_6, arg_45_7, arg_45_8, var_45_17)

		num = num + 1
	else
		UIRenderer.script_draw_bitmap_uv(gui, self.render_settings, arg_45_3, tbl_9, Vector3(x, y + y_2 - var_45_5, var_45_2), var_45_3, arg_45_6, arg_45_7, arg_45_8)
	end

	tbl_9[1][1] = 1 - num_2
	tbl_9[1][2] = 0
	tbl_9[2][1] = 1
	tbl_9[2][2] = num_3

	if arg_45_13 == true then
		var_45_13[#var_45_13 + 1] = UIRenderer.script_draw_bitmap_uv(gui_retained, self.render_settings, arg_45_3, tbl_9, Vector3(x + x_2 - var_45_4, y + y_2 - var_45_5, var_45_2), var_45_3, arg_45_6, arg_45_7, arg_45_8, nil)
	elseif not arg_45_13 then
		local var_45_18 = arg_45_13[num]

		UIRenderer.script_draw_bitmap_uv(gui_retained, self.render_settings, arg_45_3, tbl_9, Vector3(x + x_2 - var_45_4, y + y_2 - var_45_5, var_45_2), var_45_3, arg_45_6, arg_45_7, arg_45_8, var_45_18)

		num = num + 1
	else
		UIRenderer.script_draw_bitmap_uv(gui, self.render_settings, arg_45_3, tbl_9, Vector3(x + x_2 - var_45_4, y + y_2 - var_45_5, var_45_2), var_45_3, arg_45_6, arg_45_7, arg_45_8)
	end

	tbl_9[1][1] = 1 - num_2
	tbl_9[1][2] = 1 - num_3
	tbl_9[2][1] = 1
	tbl_9[2][2] = 1

	if arg_45_13 == true then
		var_45_13[#var_45_13 + 1] = UIRenderer.script_draw_bitmap_uv(gui_retained, self.render_settings, arg_45_3, tbl_9, Vector3(x + x_2 - var_45_4, y, var_45_2), var_45_3, arg_45_6, arg_45_7, arg_45_8, nil)
	elseif not arg_45_13 then
		local var_45_19 = arg_45_13[num]

		UIRenderer.script_draw_bitmap_uv(gui_retained, self.render_settings, arg_45_3, tbl_9, Vector3(x + x_2 - var_45_4, y, var_45_2), var_45_3, arg_45_6, arg_45_7, arg_45_8, var_45_19)

		num = num + 1
	else
		UIRenderer.script_draw_bitmap_uv(gui, self.render_settings, arg_45_3, tbl_9, Vector3(x + x_2 - var_45_4, y, var_45_2), var_45_3, arg_45_6, arg_45_7, arg_45_8)
	end

	if not arg_45_12 then
		tbl_9[1][1] = num_2
		tbl_9[1][2] = num_3
		tbl_9[2][1] = 1 - num_2
		tbl_9[2][2] = 1 - num_3

		if arg_45_13 == true then
			var_45_13[#var_45_13 + 1] = UIRenderer.script_draw_bitmap_uv(gui_retained, self.render_settings, arg_45_3, tbl_9, Vector3(x + var_45_4, y + var_45_5, var_45_2), arg_45_2 - var_45_3 * 2, arg_45_6, arg_45_7, arg_45_8, nil)
		elseif not arg_45_13 then
			local var_45_20 = arg_45_13[num]

			UIRenderer.script_draw_bitmap_uv(gui_retained, self.render_settings, arg_45_3, tbl_9, Vector3(x + var_45_4, y + var_45_5, var_45_2), arg_45_2 - var_45_3 * 2, arg_45_6, arg_45_7, arg_45_8, var_45_20)

			num = num + 1
		else
			UIRenderer.script_draw_bitmap_uv(gui, self.render_settings, arg_45_3, tbl_9, Vector3(x + var_45_4, y + var_45_5, var_45_2), arg_45_2 - var_45_3 * 2, arg_45_6, arg_45_7, arg_45_8)
		end
	end

	if not arg_45_9 then
		return
	end

	if not arg_45_10 then
		local var_45_21 = UIScaleVectorToResolution(arg_45_5.vertical)
		local var_45_22 = var_45_21[1]
		local var_45_23 = var_45_21[2]
		local num_4 = arg_45_2[2] - var_45_5 * 2

		var_45_21[2] = num_4

		local var_45_25 = num_4
		local num_5 = y + var_45_5
		local max = math.max(math.ceil(var_45_25 / var_45_23), 1)

		for i = 1, max do
			local clamp = math.clamp(var_45_25 / var_45_23, 0, 1)
			local flag = i % 2 == 0

			tbl_9[1][1] = 0
			tbl_9[2][1] = var_45_22 / var_45_8

			if not flag and not arg_45_11 then
				tbl_9[1][2] = math.lerp(var_45_5 / var_45_9, 1 - var_45_5 / var_45_9, clamp)
				tbl_9[2][2] = var_45_5 / var_45_9
			else
				tbl_9[1][2] = math.lerp(1 - var_45_5 / var_45_9, var_45_5 / var_45_9, clamp)
				tbl_9[2][2] = 1 - var_45_5 / var_45_9
			end

			tbl_10[1][1] = 1 - var_45_22 / var_45_8
			tbl_10[2][1] = 1

			if not flag and not arg_45_11 then
				tbl_10[1][2] = math.lerp(var_45_5 / var_45_9, 1 - var_45_5 / var_45_9, clamp)
				tbl_10[2][2] = var_45_5 / var_45_9
			else
				tbl_10[1][2] = math.lerp(1 - var_45_5 / var_45_9, var_45_5 / var_45_9, clamp)
				tbl_10[2][2] = 1 - var_45_5 / var_45_9
			end

			var_45_21[2] = clamp * var_45_23

			if arg_45_13 == true then
				var_45_13[#var_45_13 + 1] = UIRenderer.script_draw_bitmap_uv(gui_retained, self.render_settings, arg_45_3, tbl_9, Vector3(x, num_5, var_45_2), var_45_21, arg_45_6, arg_45_7, arg_45_8, nil)
			elseif not arg_45_13 then
				local var_45_30 = arg_45_13[num]

				UIRenderer.script_draw_bitmap_uv(gui_retained, self.render_settings, arg_45_3, tbl_9, Vector3(x, num_5, var_45_2), var_45_21, arg_45_6, arg_45_7, arg_45_8, var_45_30)

				num = num + 1
			else
				UIRenderer.script_draw_bitmap_uv(gui, self.render_settings, arg_45_3, tbl_9, Vector3(x, num_5, var_45_2), var_45_21, arg_45_6, arg_45_7, arg_45_8)
			end

			if arg_45_13 == true then
				var_45_13[#var_45_13 + 1] = UIRenderer.script_draw_bitmap_uv(gui_retained, self.render_settings, arg_45_3, tbl_10, Vector3(x + x_2 - var_45_22, num_5, var_45_2), var_45_21, arg_45_6, arg_45_7, arg_45_8, nil)
			elseif not arg_45_13 then
				local var_45_31 = arg_45_13[num]

				UIRenderer.script_draw_bitmap_uv(gui_retained, self.render_settings, arg_45_3, tbl_10, Vector3(x + x_2 - var_45_22, num_5, var_45_2), var_45_21, arg_45_6, arg_45_7, arg_45_8, var_45_31)

				num = num + 1
			else
				UIRenderer.script_draw_bitmap_uv(gui, self.render_settings, arg_45_3, tbl_10, Vector3(x + x_2 - var_45_22, num_5, var_45_2), var_45_21, arg_45_6, arg_45_7, arg_45_8)
			end

			num_5 = num_5 + var_45_23
			var_45_25 = var_45_25 - var_45_23
		end

		local var_45_32 = UIScaleVectorToResolution(arg_45_5.horizontal)
		local var_45_33 = var_45_32[1]
		local var_45_34 = var_45_32[2]
		local num_6 = arg_45_2[1] - var_45_4 * 2

		var_45_32[1] = num_6

		local var_45_36 = num_6
		local num_7 = x + var_45_4
		local max_2 = math.max(math.ceil(var_45_36 / var_45_23), 1)

		for j = 1, max_2 do
			local clamp_2 = math.clamp(var_45_36 / var_45_33, 0, 1)
			local flag_2 = j % 2 == 0

			if not flag_2 and not arg_45_11 then
				tbl_9[1][1] = 1 - var_45_4 / var_45_8
				tbl_9[2][1] = math.lerp(1 - var_45_4 / var_45_8, var_45_4 / var_45_8, clamp_2)
			else
				tbl_9[1][1] = var_45_4 / var_45_8
				tbl_9[2][1] = math.lerp(var_45_4 / var_45_8, 1 - var_45_4 / var_45_8, clamp_2)
			end

			tbl_9[1][2] = 1 - var_45_5 / var_45_9
			tbl_9[2][2] = 1

			if not flag_2 and not arg_45_11 then
				tbl_11[1][1] = 1 - var_45_4 / var_45_8
				tbl_11[2][1] = math.lerp(1 - var_45_4 / var_45_8, var_45_4 / var_45_8, clamp_2)
			else
				tbl_11[1][1] = var_45_4 / var_45_8
				tbl_11[2][1] = math.lerp(var_45_4 / var_45_8, 1 - var_45_4 / var_45_8, clamp_2)
			end

			tbl_11[1][2] = 0
			tbl_11[2][2] = var_45_5 / var_45_9
			var_45_32[1] = clamp_2 * var_45_33

			if arg_45_13 == true then
				var_45_13[#var_45_13 + 1] = UIRenderer.script_draw_bitmap_uv(gui_retained, self.render_settings, arg_45_3, tbl_9, Vector3(num_7, y, var_45_2), var_45_32, arg_45_6, arg_45_7, arg_45_8, nil)
			elseif not arg_45_13 then
				local var_45_41 = arg_45_13[num]

				UIRenderer.script_draw_bitmap_uv(gui_retained, self.render_settings, arg_45_3, tbl_9, Vector3(num_7, y, var_45_2), var_45_32, arg_45_6, arg_45_7, arg_45_8, var_45_41)

				num = num + 1
			else
				UIRenderer.script_draw_bitmap_uv(gui, self.render_settings, arg_45_3, tbl_9, Vector3(num_7, y, var_45_2), var_45_32, arg_45_6, arg_45_7, arg_45_8)
			end

			if arg_45_13 == true then
				var_45_13[#var_45_13 + 1] = UIRenderer.script_draw_bitmap_uv(gui_retained, self.render_settings, arg_45_3, tbl_11, Vector3(num_7, y + y_2 - var_45_34, var_45_2), var_45_32, arg_45_6, arg_45_7, arg_45_8, nil)
			elseif not arg_45_13 then
				local var_45_42 = arg_45_13[num]

				UIRenderer.script_draw_bitmap_uv(gui_retained, self.render_settings, arg_45_3, tbl_11, Vector3(num_7, y + y_2 - var_45_34, var_45_2), var_45_32, arg_45_6, arg_45_7, arg_45_8, var_45_42)

				num = num + 1
			else
				UIRenderer.script_draw_bitmap_uv(gui, self.render_settings, arg_45_3, tbl_11, Vector3(num_7, y + y_2 - var_45_34, var_45_2), var_45_32, arg_45_6, arg_45_7, arg_45_8)
			end

			num_7 = num_7 + var_45_33
			var_45_36 = var_45_36 - var_45_33
		end
	else
		local var_45_43 = UIScaleVectorToResolution(arg_45_5.vertical)
		local var_45_44 = var_45_43[1]
		local var_45_45 = var_45_43[2]

		var_45_43[2] = arg_45_2[2] - var_45_5 * 2
		tbl_9[1][1] = 0
		tbl_9[1][2] = 0.5 - var_45_45 / arg_45_2[2] * 0.5
		tbl_9[2][1] = var_45_44 / var_45_8
		tbl_9[2][2] = 0.5 + var_45_45 / arg_45_2[2] * 0.5
		tbl_10[1][1] = 1 - var_45_44 / var_45_8
		tbl_10[1][2] = 0.5 - var_45_45 / arg_45_2[2] * 0.5
		tbl_10[2][1] = 1
		tbl_10[2][2] = 0.5 + var_45_45 / arg_45_2[2] * 0.5

		local num_8 = y + var_45_5

		if arg_45_13 == true then
			var_45_13[#var_45_13 + 1] = UIRenderer.script_draw_bitmap_uv(gui_retained, self.render_settings, arg_45_3, tbl_9, Vector3(x, num_8, var_45_2), var_45_43, arg_45_6, arg_45_7, arg_45_8, nil)
		elseif not arg_45_13 then
			local var_45_47 = arg_45_13[num]

			UIRenderer.script_draw_bitmap_uv(gui_retained, self.render_settings, arg_45_3, tbl_9, Vector3(x, num_8, var_45_2), var_45_43, arg_45_6, arg_45_7, arg_45_8, var_45_47)

			num = num + 1
		else
			UIRenderer.script_draw_bitmap_uv(gui, self.render_settings, arg_45_3, tbl_9, Vector3(x, num_8, var_45_2), var_45_43, arg_45_6, arg_45_7, arg_45_8)
		end

		if arg_45_13 == true then
			var_45_13[#var_45_13 + 1] = UIRenderer.script_draw_bitmap_uv(gui_retained, self.render_settings, arg_45_3, tbl_10, Vector3(x + x_2 - var_45_44, num_8, var_45_2), var_45_43, arg_45_6, arg_45_7, arg_45_8, nil)
		elseif not arg_45_13 then
			local var_45_48 = arg_45_13[num]

			UIRenderer.script_draw_bitmap_uv(gui_retained, self.render_settings, arg_45_3, tbl_10, Vector3(x + x_2 - var_45_44, num_8, var_45_2), var_45_43, arg_45_6, arg_45_7, arg_45_8, var_45_48)

			num = num + 1
		else
			UIRenderer.script_draw_bitmap_uv(gui, self.render_settings, arg_45_3, tbl_10, Vector3(x + x_2 - var_45_44, num_8, var_45_2), var_45_43, arg_45_6, arg_45_7, arg_45_8)
		end

		local var_45_49 = UIScaleVectorToResolution(arg_45_5.horizontal)
		local var_45_50 = var_45_49[1]
		local var_45_51 = var_45_49[2]

		var_45_49[1] = arg_45_2[1] - var_45_4 * 2
		tbl_11[1][1] = 0.5 - var_45_50 / arg_45_2[1] * 0.5
		tbl_11[1][2] = 0
		tbl_11[2][1] = 0.5 + var_45_50 / arg_45_2[1] * 0.5
		tbl_11[2][2] = var_45_51 / var_45_9
		tbl_9[1][1] = 0.5 - var_45_50 / arg_45_2[1] * 0.5
		tbl_9[1][2] = 1 - var_45_51 / var_45_9
		tbl_9[2][1] = 0.5 + var_45_50 / arg_45_2[1] * 0.5
		tbl_9[2][2] = 1

		local num_9 = x + var_45_4

		if arg_45_13 == true then
			var_45_13[#var_45_13 + 1] = UIRenderer.script_draw_bitmap_uv(gui_retained, self.render_settings, arg_45_3, tbl_9, Vector3(num_9, y, var_45_2), var_45_49, arg_45_6, arg_45_7, arg_45_8, nil)
		elseif not arg_45_13 then
			local var_45_53 = arg_45_13[num]

			UIRenderer.script_draw_bitmap_uv(gui_retained, self.render_settings, arg_45_3, tbl_9, Vector3(num_9, y, var_45_2), var_45_49, arg_45_6, arg_45_7, arg_45_8, var_45_53)

			num = num + 1
		else
			UIRenderer.script_draw_bitmap_uv(gui, self.render_settings, arg_45_3, tbl_9, Vector3(num_9, y, var_45_2), var_45_49, arg_45_6, arg_45_7, arg_45_8)
		end

		if arg_45_13 == true then
			var_45_13[#var_45_13 + 1] = UIRenderer.script_draw_bitmap_uv(gui_retained, self.render_settings, arg_45_3, tbl_11, Vector3(num_9, y + y_2 - var_45_51, var_45_2), var_45_49, arg_45_6, arg_45_7, arg_45_8, nil)
		elseif not arg_45_13 then
			local var_45_54 = arg_45_13[num]

			UIRenderer.script_draw_bitmap_uv(gui_retained, self.render_settings, arg_45_3, tbl_11, Vector3(num_9, y + y_2 - var_45_51, var_45_2), var_45_49, arg_45_6, arg_45_7, arg_45_8, var_45_54)
		else
			UIRenderer.script_draw_bitmap_uv(gui, self.render_settings, arg_45_3, tbl_11, Vector3(num_9, y + y_2 - var_45_51, var_45_2), var_45_49, arg_45_6, arg_45_7, arg_45_8)
		end
	end

	return var_45_13
end

UIRenderer.destroy_bitmap = function (self, arg_46_1)
	-- function 46
	Gui.destroy_bitmap(self.gui_retained, arg_46_1)
end

UIRenderer.destroy_text = function (self, arg_47_1)
	-- function 47
	Gui.destroy_text(self.gui_retained, arg_47_1)
end

require("scripts/ui/ui_passes")
