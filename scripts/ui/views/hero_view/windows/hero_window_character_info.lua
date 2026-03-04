-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_character_info.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_character_info_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.category_settings
local var_0_3 = var_0_0.scenegraph_definition
local var_0_4 = var_0_0.animation_definitions
local var_0_5 = false
local var_0_6 = 1

HeroWindowCharacterInfo = class(HeroWindowCharacterInfo)
HeroWindowCharacterInfo.NAME = "HeroWindowCharacterInfo"

HeroWindowCharacterInfo.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate HeroWindowCharacterInfo")

	arg_1_0.parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0.ui_renderer = var_1_0.ui_renderer
	arg_1_0.ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.statistics_db = var_1_0.statistics_db
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0.ingame_ui = var_1_0.ingame_ui

	local var_1_1 = Managers.player

	arg_1_0._stats_id = var_1_1:local_player():stats_id()
	arg_1_0.player_manager = var_1_1
	arg_1_0.peer_id = var_1_0.peer_id
	arg_1_0.hero_name = arg_1_1.hero_name
	arg_1_0.career_index = arg_1_1.career_index
	arg_1_0.profile_index = arg_1_1.profile_index
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}

	arg_1_0:create_ui_elements(arg_1_1, arg_1_2)
end

HeroWindowCharacterInfo.create_ui_elements = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_3)

	local var_2_0 = {}
	local var_2_1 = {}

	for iter_2_0, iter_2_1 in pairs(var_0_1) do
		local var_2_2 = UIWidget.init(iter_2_1)

		var_2_0[#var_2_0 + 1] = var_2_2
		var_2_1[iter_2_0] = var_2_2
	end

	arg_2_0._widgets = var_2_0
	arg_2_0._widgets_by_name = var_2_1

	arg_2_0:_create_insignia_widget()
	UIRenderer.clear_scenegraph_queue(arg_2_0.ui_renderer)

	arg_2_0.ui_animator = UIAnimator:new(arg_2_0.ui_scenegraph, var_0_4)

	if arg_2_2 then
		local var_2_3 = arg_2_0.ui_scenegraph.window.local_position

		var_2_3[1] = var_2_3[1] + arg_2_2[1]
		var_2_3[2] = var_2_3[2] + arg_2_2[2]
		var_2_3[3] = var_2_3[3] + arg_2_2[3]
	end
end

HeroWindowCharacterInfo.on_exit = function (arg_3_0, arg_3_1)
	print("[HeroViewWindow] Exit Substate HeroWindowCharacterInfo")

	arg_3_0.ui_animator = nil
end

HeroWindowCharacterInfo.update = function (arg_4_0, arg_4_1, arg_4_2)
	if var_0_5 then
		var_0_5 = false

		arg_4_0:create_ui_elements()
	end

	arg_4_0:_update_loadout_sync()
	arg_4_0:_update_animations(arg_4_1)
	arg_4_0:draw(arg_4_1)
end

HeroWindowCharacterInfo.post_update = function (arg_5_0, arg_5_1, arg_5_2)
	return
end

HeroWindowCharacterInfo._update_animations = function (arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0._ui_animations
	local var_6_1 = arg_6_0._animations
	local var_6_2 = arg_6_0.ui_animator

	for iter_6_0, iter_6_1 in pairs(arg_6_0._ui_animations) do
		UIAnimation.update(iter_6_1, arg_6_1)

		if UIAnimation.completed(iter_6_1) then
			arg_6_0._ui_animations[iter_6_0] = nil
		end
	end

	var_6_2:update(arg_6_1)

	for iter_6_2, iter_6_3 in pairs(var_6_1) do
		if var_6_2:is_animation_completed(iter_6_3) then
			var_6_2:stop_animation(iter_6_3)

			var_6_1[iter_6_2] = nil
		end
	end
end

HeroWindowCharacterInfo.set_focus = function (arg_7_0, arg_7_1)
	arg_7_0._focused = arg_7_1
end

HeroWindowCharacterInfo._update_loadout_sync = function (arg_8_0)
	local var_8_0 = arg_8_0.parent.loadout_sync_id

	if var_8_0 ~= arg_8_0._loadout_sync_id or arg_8_0:_has_hero_level_changed() then
		arg_8_0:_update_experience_presentation()
		arg_8_0:_update_hero_portrait_frame()

		arg_8_0._loadout_sync_id = var_8_0
	end
end

HeroWindowCharacterInfo._has_hero_level_changed = function (arg_9_0)
	local var_9_0 = ExperienceSettings.get_experience(arg_9_0.hero_name)

	if ExperienceSettings.get_level(var_9_0) ~= arg_9_0._hero_level then
		return true
	end
end

HeroWindowCharacterInfo._update_experience_presentation = function (arg_10_0)
	local var_10_0 = arg_10_0._widgets_by_name
	local var_10_1 = ExperienceSettings.get_experience(arg_10_0.hero_name)
	local var_10_2, var_10_3 = ExperienceSettings.get_level(var_10_1)
	local var_10_4 = ExperienceSettings.get_experience_pool(arg_10_0.hero_name)
	local var_10_5, var_10_6 = ExperienceSettings.get_extra_level(var_10_4)
	local var_10_7 = var_0_3.experience_bar.size
	local var_10_8 = arg_10_0.ui_scenegraph.experience_bar.size

	if var_10_3 > 0 then
		var_10_8[1] = math.ceil(var_10_7[1] * var_10_3)
	elseif var_10_6 > 0 then
		var_10_8[1] = math.ceil(var_10_7[1] * var_10_6)
	end

	local var_10_9 = Localize("level") .. " " .. tostring(var_10_2)

	if var_10_5 and var_10_5 > 0 then
		var_10_9 = var_10_9 .. " (+" .. tostring(var_10_5) .. ")"
	end

	var_10_0.level_text.content.text = var_10_9
	arg_10_0._hero_level = var_10_2
end

HeroWindowCharacterInfo._update_hero_portrait_frame = function (arg_11_0)
	local var_11_0 = arg_11_0.career_index
	local var_11_1 = arg_11_0.profile_index
	local var_11_2 = SPProfiles[var_11_1]
	local var_11_3 = var_11_2.careers[var_11_0]
	local var_11_4 = var_11_3.portrait_image
	local var_11_5 = var_11_3.display_name
	local var_11_6 = var_11_2.character_name
	local var_11_7 = arg_11_0._widgets_by_name

	var_11_7.hero_name.content.text = var_11_6
	var_11_7.career_name.content.text = var_11_5

	local var_11_8 = arg_11_0._hero_level and tostring(arg_11_0._hero_level) or "-"
	local var_11_9 = arg_11_0:_get_portrait_frame()

	arg_11_0._portrait_widget = arg_11_0:_create_portrait_frame_widget(var_11_9, var_11_4, var_11_8)
end

HeroWindowCharacterInfo._exit = function (arg_12_0, arg_12_1)
	arg_12_0.exit = true
	arg_12_0.exit_level_id = arg_12_1
end

HeroWindowCharacterInfo.draw = function (arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0.ui_renderer
	local var_13_1 = arg_13_0.ui_top_renderer
	local var_13_2 = arg_13_0.ui_scenegraph
	local var_13_3 = arg_13_0.parent:window_input_service()

	UIRenderer.begin_pass(var_13_1, var_13_2, var_13_3, arg_13_1, nil, arg_13_0.render_settings)

	for iter_13_0, iter_13_1 in ipairs(arg_13_0._widgets) do
		UIRenderer.draw_widget(var_13_1, iter_13_1)
	end

	if arg_13_0._portrait_widget then
		UIRenderer.draw_widget(var_13_1, arg_13_0._portrait_widget)
	end

	if arg_13_0._insignia_widget then
		UIRenderer.draw_widget(var_13_1, arg_13_0._insignia_widget)
	end

	UIRenderer.end_pass(var_13_1)
end

HeroWindowCharacterInfo._play_sound = function (arg_14_0, arg_14_1)
	arg_14_0.parent:play_sound(arg_14_1)
end

HeroWindowCharacterInfo._create_portrait_frame_widget = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = UIWidgets.create_portrait_frame("portrait_root", arg_15_1, arg_15_3, 1, nil, arg_15_2)
	local var_15_1 = UIWidget.init(var_15_0, arg_15_0.ui_top_renderer)

	var_15_1.content.frame_settings_name = arg_15_1

	return var_15_1
end

HeroWindowCharacterInfo._create_insignia_widget = function (arg_16_0)
	local var_16_0 = Managers.player:local_player()
	local var_16_1 = ExperienceSettings.get_versus_player_level(var_16_0)
	local var_16_2 = UIWidgets.create_small_insignia("insignia", var_16_1)

	arg_16_0._insignia_widget = UIWidget.init(var_16_2)
end

HeroWindowCharacterInfo._get_portrait_frame = function (arg_17_0)
	local var_17_0 = arg_17_0.profile_index
	local var_17_1 = arg_17_0.career_index
	local var_17_2 = arg_17_0.hero_name
	local var_17_3 = SPProfiles[var_17_0].careers[var_17_1].name
	local var_17_4 = "default"
	local var_17_5 = BackendUtils.get_loadout_item(var_17_3, "slot_frame")

	var_17_4 = var_17_5 and var_17_5.data.temporary_template or var_17_4

	return var_17_4
end
