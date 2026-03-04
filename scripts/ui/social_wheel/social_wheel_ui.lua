-- chunkname: @scripts/ui/social_wheel/social_wheel_ui.lua

local var_0_0 = local_require("scripts/ui/social_wheel/social_wheel_ui_settings")
local var_0_1 = BASE_SOCIAL_WHEEL_SETTINGS or table.clone(SocialWheelSettings)
local var_0_2 = "gui/1080p/single_textures/generic/transparent_placeholder_texture"
local var_0_3 = "social_wheel_ui"
local var_0_4 = "SocialWheelUI_"
local var_0_5 = "%s_weapon_pose_anim_%02d"
local var_0_6 = false
local var_0_7 = local_require("scripts/ui/social_wheel/social_wheel_ui_definitions")
local var_0_8 = var_0_7.scenegraph_definition

SocialWheelUI = class(SocialWheelUI)

local var_0_9 = {
	"rpc_social_wheel_event"
}
local var_0_10 = 0.125
local var_0_11 = 0.25
local var_0_12 = 0.01
local var_0_13 = 0.125
local var_0_14 = 5
local var_0_15

if IS_WINDOWS then
	var_0_15 = {
		OPEN = {
			MOVE_Y = 0.3,
			SIZE = 0.3,
			MOVE_X = 0.3,
			ALPHA = 0.45
		},
		CLOSE = {
			MOVE_Y = 0.2,
			SIZE = 0.25,
			MOVE_X = 0.2,
			ALPHA = 0.1
		}
	}
else
	var_0_15 = {
		OPEN = {
			MOVE_Y = 0.3,
			SIZE = 0.3,
			MOVE_X = 0.3,
			ALPHA = 0.45
		},
		CLOSE = {
			MOVE_Y = 0.2,
			SIZE = 0.25,
			MOVE_X = 0.2,
			ALPHA = 0.1
		}
	}
end

local var_0_16 = {
	__index = function (arg_1_0, arg_1_1, arg_1_2)
		return arg_1_0.default
	end
}
local var_0_17 = {
	default = {
		OPEN = "Play_hud_socialwheel_open",
		HOVER = "Play_hud_socialwheel_hover",
		SELECT = "Play_hud_socialwheel_select"
	},
	heroes = {
		OPEN = "Play_hud_socialwheel_open",
		HOVER = "Play_hud_socialwheel_hover",
		SELECT = "Play_hud_socialwheel_select"
	}
}

for iter_0_0, iter_0_1 in pairs(DLCSettings) do
	local var_0_18 = iter_0_1.social_wheel_sfx_events

	if var_0_18 then
		table.merge_recursive(var_0_17, var_0_18)
	end
end

setmetatable(var_0_17, var_0_16)

SocialWheelUI.init = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._parent = arg_2_1
	arg_2_0._ui_top_renderer = arg_2_2.ui_top_renderer
	arg_2_0._render_settings = {
		alpha_multiplier = 0
	}
	arg_2_0._is_visible = true
	arg_2_0._state = "update_closed"
	arg_2_0._states = {
		update_closed = true,
		update_open = true
	}
	arg_2_0._ingame_ui_context = arg_2_2
	arg_2_0._peer_id = arg_2_2.peer_id
	arg_2_0._player = arg_2_2.player
	arg_2_0._wwise_world = arg_2_2.wwise_world

	if IS_CONSOLE then
		arg_2_0._console_extension = arg_2_2.is_in_inn and "_inn" or ""
	else
		arg_2_0._console_extension = ""
	end

	arg_2_0._current_context = nil
	arg_2_0._active_context = nil
	arg_2_0._num_free_events = var_0_14
	arg_2_0._valid_selection = true
	arg_2_0._cloned_materials_by_reference = {}

	local var_2_0 = Managers.state.game_mode:settings().ping_mode

	if var_2_0 then
		arg_2_0._world_markers_enabled = var_2_0.world_markers
	else
		arg_2_0._world_markers_enabled = false
	end

	arg_2_0:_create_ui_elements()
	arg_2_0:_register_rpcs()
end

SocialWheelUI._create_ui_elements = function (arg_3_0)
	arg_3_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_8)
	arg_3_0._animations = {}
	arg_3_0._animation_callbacks = {}
	arg_3_0._selection_widgets = {}
	arg_3_0._social_event_widgets = {}
	arg_3_0._queued_social_wheel_events = {}
	arg_3_0._icon_widgets = {}
	arg_3_0._event_index = 0
	arg_3_0._select_timer = 0
	arg_3_0._selected_widget = nil

	arg_3_0:_create_social_wheel(var_0_1)

	arg_3_0._arrow_widget = UIWidget.init(var_0_7.arrow_widget)
	arg_3_0._bg_widget = UIWidget.init(var_0_7.create_bg_widget())
	arg_3_0._page_input_widget = UIWidget.init(var_0_7.page_input_widget)

	UIRenderer.clear_scenegraph_queue(arg_3_0._ui_top_renderer)
end

SocialWheelUI._create_social_wheel = function (arg_4_0, arg_4_1)
	local var_4_0 = arg_4_1 or SocialWheelSettings

	local function var_4_1()
		return arg_4_0._active_context
	end

	for iter_4_0, iter_4_1 in pairs(var_4_0) do
		local var_4_2 = iter_4_1.has_pages
		local var_4_3 = iter_4_1.validation_function

		if not var_4_3 or var_4_3() then
			if not var_4_2 then
				local var_4_4 = #iter_4_1
				local var_4_5 = Script.new_array(var_4_4)

				arg_4_0._selection_widgets[iter_4_0] = var_4_5

				for iter_4_2 = 1, var_4_4 do
					local var_4_6 = var_0_7.create_social_widget(iter_4_1[iter_4_2], arg_4_0:_widget_angle(iter_4_1.angle, var_4_4, iter_4_2), iter_4_1, var_4_1)

					var_4_5[iter_4_2] = UIWidget.init(var_4_6)
				end
			else
				local var_4_7 = #iter_4_1
				local var_4_8 = Script.new_table(var_4_7, 2)

				var_4_8.num_pages = var_4_7
				var_4_8.current_page = 1
				arg_4_0._selection_widgets[iter_4_0] = var_4_8

				for iter_4_3 = 1, var_4_7 do
					local var_4_9 = iter_4_1[iter_4_3]
					local var_4_10 = #var_4_9
					local var_4_11 = Script.new_array(var_4_10)

					var_4_8[iter_4_3] = var_4_11

					if not var_4_8.emotes_page_index then
						var_4_8.emotes_page_index = var_4_9.emotes and iter_4_3 or nil
					end

					if not var_4_8.weapon_poses_page_index then
						var_4_8.weapon_poses_page_index = var_4_9.weapon_poses and iter_4_3 or nil
					end

					for iter_4_4 = 1, var_4_10 do
						local var_4_12 = var_0_7.create_social_widget(var_4_9[iter_4_4], arg_4_0:_widget_angle(iter_4_1.angle, var_4_10, iter_4_4), iter_4_1, var_4_1, iter_4_3)

						var_4_11[iter_4_4] = UIWidget.init(var_4_12)
					end
				end
			end
		end
	end
end

SocialWheelUI._register_rpcs = function (arg_6_0)
	arg_6_0._ingame_ui_context.network_event_delegate:register(arg_6_0, unpack(var_0_9))
end

SocialWheelUI._unregister_rpcs = function (arg_7_0)
	arg_7_0._ingame_ui_context.network_event_delegate:unregister(arg_7_0)
end

SocialWheelUI.destroy = function (arg_8_0)
	arg_8_0:_unregister_rpcs()

	local var_8_0 = ScriptUnit.has_extension(arg_8_0._player.player_unit, "interactor_system")

	if var_8_0 then
		var_8_0:enable_interactions(true)
	end

	if arg_8_0._loaded_weapon_pose_packages then
		for iter_8_0, iter_8_1 in pairs(arg_8_0._loaded_weapon_pose_packages) do
			arg_8_0:_reset_materials_for_item_type(iter_8_1.item_type, iter_8_0)
			Managers.package:unload(iter_8_1.package_name, var_0_3)
		end

		table.clear(arg_8_0._loaded_weapon_pose_packages)
	end

	arg_8_0:_set_player_input_scale(1, nil)
end

SocialWheelUI._widget_angle = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = math.pi
	local var_9_1 = arg_9_1 / arg_9_2

	return -(var_9_0 * 0.5 + var_9_0 - arg_9_1 * 0.5 + var_9_1 * 0.5) - (arg_9_3 - 1) * var_9_1
end

SocialWheelUI._select_widget = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = math.pi
	local var_10_1 = arg_10_1 / arg_10_2
	local var_10_2 = var_10_0 * 0.5 + var_10_0 - arg_10_1 * 0.5
	local var_10_3 = (-arg_10_3 - var_10_2) % (2 * var_10_0)
	local var_10_4 = math.floor(var_10_3 / var_10_1) + 1

	if var_10_4 > 0 and var_10_4 <= arg_10_2 then
		return var_10_4
	end
end

local var_0_19 = {
	0,
	0,
	0
}

SocialWheelUI._add_social_wheel_event = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	local var_11_0 = SocialWheelSettingsLookup[arg_11_2]
	local var_11_1, var_11_2 = var_11_0.event_text, var_11_0.event_text_func
	local var_11_3

	if var_11_2 then
		var_11_1, var_11_3 = var_11_2(arg_11_3, var_11_0)
	end

	if var_11_1 then
		if IS_WINDOWS then
			if arg_11_0._num_free_events >= 1 then
				local var_11_4 = true
				local var_11_5 = true

				Managers.chat:send_chat_message(1, arg_11_1:local_player_id(), var_11_1, var_11_4, var_11_3, var_11_5)
			else
				local var_11_6 = Localize("social_wheel_too_many_messages_warning")

				Managers.chat:add_local_system_message(1, var_11_6, true)
			end
		else
			local var_11_7 = arg_11_1.peer_id == Network.peer_id()
			local var_11_8 = arg_11_1.player_unit

			if Unit.alive(var_11_8) then
				local var_11_9 = ScriptUnit.extension(var_11_8, "career_system"):career_name()
				local var_11_10 = CareerSettings[var_11_9]
				local var_11_11 = UIWidget.init(var_0_7.create_social_text_event(var_11_0, var_11_10.portrait_image, var_11_1, var_11_7))
				local var_11_12

				if not var_11_7 then
					local var_11_13 = Managers.world:world("level_world")
					local var_11_14 = ScriptWorld.viewport(var_11_13, "player_1")
					local var_11_15 = ScriptViewport.camera(var_11_14)
					local var_11_16 = UIWidget.init(var_0_7.create_social_icon(var_11_0, arg_11_1.peer_id, var_11_15, var_11_13, Managers.time:time("game") + 5, 1))

					arg_11_0._icon_widgets[arg_11_1.peer_id] = var_11_16
				end
			end
		end

		if arg_11_4 then
			arg_11_0:_play_sound("Play_hud_socialwheel_notification")
		end
	end
end

SocialWheelUI._add_social_wheel_event_animation = function (arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_1.content.is_local_player

	arg_12_0._social_event_widgets[#arg_12_0._social_event_widgets + 1] = arg_12_1
	arg_12_0._event_index = arg_12_0._event_index + 1

	local var_12_1 = arg_12_0._event_index

	arg_12_0._animations["social_event_" .. var_12_1] = UIAnimation.init(UIAnimation.function_by_time, arg_12_1.offset, 1, 500, -60, 0.25, math.easeOutCubic)
	arg_12_0._animation_callbacks["social_event_" .. var_12_1] = function ()
		local var_13_0 = var_12_0 and Colors.get_color_table_with_alpha("medium_purple", 255) or Colors.get_color_table_with_alpha("light_sky_blue", 255)

		arg_12_0._animations["social_event_color_" .. var_12_1] = UIAnimation.init(UIAnimation.linear_scale_color, arg_12_1.style.text.text_color, 255, 255, 255, var_13_0[2], var_13_0[3], var_13_0[4], 2)
		arg_12_0._animations["timer_" .. var_12_1] = UIAnimation.init(UIAnimation.function_by_time, var_0_19, 1, 0, 0, 5, math.easeInCubic)
		arg_12_0._animation_callbacks["timer_" .. var_12_1] = function ()
			arg_12_0._animations["social_event_alpha_" .. var_12_1] = UIAnimation.init(UIAnimation.function_by_time, arg_12_1.style.text.text_color, 1, 255, 0, 1, math.easeInCubic)
			arg_12_0._animations["social_event_texture_alpha_" .. var_12_1] = UIAnimation.init(UIAnimation.function_by_time, arg_12_1.style.texture.color, 1, 255, 0, 1, math.easeInCubic)
			arg_12_0._animation_callbacks["social_event_alpha_" .. var_12_1] = function ()
				arg_12_0._animations["spacing_" .. var_12_1] = UIAnimation.init(UIAnimation.function_by_time, arg_12_1.content, "spacing", arg_12_1.content.spacing, 0, 0.5, math.easeOutCubic)
				arg_12_0._animation_callbacks["spacing_" .. var_12_1] = function ()
					table.remove(arg_12_0._social_event_widgets, 1)

					if #arg_12_0._social_event_widgets < 6 then
						local var_16_0 = arg_12_0._queued_social_wheel_events[1]

						if var_16_0 then
							table.remove(arg_12_0._queued_social_wheel_events, 1)
							arg_12_0:_add_social_wheel_event_animation(var_16_0)
						end
					end
				end
			end
		end
	end
end

SocialWheelUI.rpc_social_wheel_event = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	if IS_XB1 and Managers.chat:ignoring_peer_id(arg_17_2) then
		return
	end

	local var_17_0 = Managers.player:player_from_peer_id(arg_17_2)

	if var_17_0 then
		local var_17_1 = Managers.state.unit_storage:unit(arg_17_4)

		if not var_17_1 or Unit.alive(var_17_1) then
			local var_17_2 = rawget(NetworkLookup.social_wheel_events, arg_17_3)

			if var_17_2 then
				arg_17_0:_add_social_wheel_event(var_17_0, var_17_2, var_17_1, true)
			end
		end
	end
end

SocialWheelUI.post_update = function (arg_18_0, arg_18_1)
	arg_18_0:_post_update_remove_icon(arg_18_1)
	arg_18_0:_post_update_render(arg_18_1)
end

local var_0_20 = {}

SocialWheelUI._post_update_remove_icon = function (arg_19_0, arg_19_1)
	table.clear(var_0_20)

	local var_19_0 = Managers.time:time("game")

	for iter_19_0, iter_19_1 in pairs(arg_19_0._icon_widgets) do
		if var_19_0 > iter_19_1.content.end_time then
			var_0_20[#var_0_20 + 1] = iter_19_0
		end
	end

	for iter_19_2, iter_19_3 in ipairs(var_0_20) do
		arg_19_0._icon_widgets[iter_19_3] = nil
	end
end

local var_0_21 = {}

SocialWheelUI._post_update_render = function (arg_20_0, arg_20_1)
	if not arg_20_0._is_visible then
		return
	end

	local var_20_0 = arg_20_0._ui_top_renderer
	local var_20_1 = arg_20_0._ui_scenegraph
	local var_20_2 = Managers.input:get_service("ingame_menu")

	UIRenderer.begin_pass(var_20_0, var_20_1, var_20_2, arg_20_1, nil, var_0_21)

	for iter_20_0, iter_20_1 in pairs(arg_20_0._icon_widgets) do
		UIRenderer.draw_widget(var_20_0, iter_20_1)
	end

	UIRenderer.end_pass(var_20_0)
end

SocialWheelUI.update = function (arg_21_0, arg_21_1, arg_21_2)
	arg_21_0:_update_animations(arg_21_1, arg_21_2)
	arg_21_0:_update_input(arg_21_1, arg_21_2)
	arg_21_0:_draw(arg_21_1, arg_21_2)
end

SocialWheelUI._update_animations = function (arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0._animations
	local var_22_1 = arg_22_0._animation_callbacks

	for iter_22_0, iter_22_1 in pairs(var_22_0) do
		UIAnimation.update(iter_22_1, arg_22_1)

		if UIAnimation.completed(iter_22_1) then
			var_22_0[iter_22_0] = nil

			if var_22_1[iter_22_0] then
				var_22_1[iter_22_0]()

				var_22_1[iter_22_0] = nil
			end
		end
	end
end

SocialWheelUI._update_input = function (arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = Managers.input:get_service("Player")

	arg_23_0[arg_23_0._state](arg_23_0, arg_23_1, arg_23_2, var_23_0)

	arg_23_0.previous_ping_held = var_23_0:get("ping_hold")
	arg_23_0.previous_social_wheel_only_held = var_23_0:get("social_wheel_only_hold")
	arg_23_0.previous_weapon_poses_only_held = var_23_0:get("weapon_poses_only_hold")
	arg_23_0.previous_photomode_only_held = var_23_0:get("photomode_only_hold")
end

SocialWheelUI._draw = function (arg_24_0, arg_24_1, arg_24_2)
	if not arg_24_0._is_visible then
		return
	end

	local var_24_0 = arg_24_0._ui_top_renderer
	local var_24_1 = arg_24_0._ui_scenegraph
	local var_24_2 = Managers.input:get_service("ingame_menu")
	local var_24_3 = arg_24_0._current_selection_widgets
	local var_24_4 = arg_24_0._render_settings

	if var_24_3 and var_24_4.alpha_multiplier > 0 then
		UIRenderer.begin_pass(var_24_0, var_24_1, var_24_2, arg_24_1, nil, var_24_4)

		local var_24_5 = #var_24_3

		for iter_24_0 = 1, var_24_5 do
			local var_24_6 = var_24_3[iter_24_0]

			UIRenderer.draw_widget(var_24_0, var_24_6)
		end

		UIRenderer.draw_widget(var_24_0, arg_24_0._arrow_widget)

		if arg_24_0._current_selection_widget_settings.has_pages then
			UIRenderer.draw_widget(var_24_0, arg_24_0._page_input_widget)
		end

		if not arg_24_0._current_selection_widget_settings.individual_bg then
			UIRenderer.draw_widget(var_24_0, arg_24_0._bg_widget)
		end

		UIRenderer.end_pass(var_24_0)
	end

	UIRenderer.begin_pass(var_24_0, var_24_1, var_24_2, arg_24_1)

	if arg_24_0._selected_widget then
		UIRenderer.draw_widget(var_24_0, arg_24_0._selected_widget)
	end

	local var_24_7 = 0
	local var_24_8 = arg_24_0._social_event_widgets
	local var_24_9 = #var_24_8

	for iter_24_1 = 1, var_24_9 do
		local var_24_10 = var_24_8[iter_24_1]

		var_24_10.offset[2] = var_24_7

		UIRenderer.draw_widget(var_24_0, var_24_10)

		var_24_7 = var_24_7 - var_24_10.content.spacing
	end

	UIRenderer.end_pass(var_24_0)
end

SocialWheelUI.set_visible = function (arg_25_0, arg_25_1)
	arg_25_0._is_visible = arg_25_1
end

SocialWheelUI._set_player_input_scale = function (arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = arg_26_0._player.player_unit

	if Unit.alive(var_26_0) then
		local var_26_1 = ScriptUnit.extension(var_26_0, "input_system")

		var_26_1:set_input_key_scale("look", arg_26_1, arg_26_2)
		var_26_1:set_input_key_scale("look_controller", arg_26_1, arg_26_2)
		var_26_1:set_input_key_scale("look_controller_zoom", arg_26_1, arg_26_2)
		var_26_1:set_input_key_scale("look_controller_3p", arg_26_1, arg_26_2)
		var_26_1:set_input_key_scale("look_controller_ranged", arg_26_1, arg_26_2)
		var_26_1:set_input_key_scale("look_controller_melee", arg_26_1, arg_26_2)
	end

	local var_26_2 = Managers.input:get_service("Player")

	if var_26_2 then
		local var_26_3 = arg_26_1 == 0

		var_26_2:set_input_blocked("look_controller_3p", var_26_3, nil, "SocialWheelUI")
		var_26_2:set_input_blocked("look", var_26_3, nil, "SocialWheelUI")
	end
end

SocialWheelUI._ping_unit_attempt = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	local var_27_0 = arg_27_0._player.player_unit

	if Unit.alive(var_27_0) and Unit.alive(arg_27_1) then
		local var_27_1 = Managers.time:time("game")

		return ScriptUnit.extension(var_27_0, "ping_system"):ping_attempt(var_27_0, arg_27_1, var_27_1, arg_27_2, arg_27_3)
	end
end

SocialWheelUI._ping_world_position_attempt = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	local var_28_0 = arg_28_0._player.player_unit

	if Unit.alive(var_28_0) then
		local var_28_1 = Managers.time:time("game")

		return ScriptUnit.extension(var_28_0, "ping_system"):ping_world_position_attempt(var_28_0, arg_28_1:unbox(), var_28_1, arg_28_2, arg_28_3)
	end
end

SocialWheelUI._social_message_attempt = function (arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = arg_29_0._player.player_unit

	if Unit.alive(var_29_0) then
		local var_29_1 = Managers.time:time("game")

		return ScriptUnit.extension(var_29_0, "ping_system"):social_message_attempt(var_29_0, arg_29_1, arg_29_2)
	end
end

SocialWheelUI._local_ping_attempt = function (arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = arg_30_0._player
	local var_30_1 = var_30_0.player_unit

	if Unit.alive(var_30_1) then
		Managers.state.entity:system("ping_system"):handle_local_ping(PingTypes.LOCAL_ONLY, arg_30_1, var_30_0, var_30_1, arg_30_2, nil)
	end
end

SocialWheelUI._play_sound = function (arg_31_0, arg_31_1)
	if not arg_31_1 then
		return
	end

	WwiseWorld.trigger_event(arg_31_0._wwise_world, arg_31_1)
end

SocialWheelUI._change_state = function (arg_32_0, arg_32_1)
	fassert(arg_32_0._states[arg_32_1], "[SocialWheelUI:_change_state] There is no state called %s", tostring(arg_32_1))

	arg_32_0._state = arg_32_1
end

SocialWheelUI.update_closed = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3)
	local var_33_0 = arg_33_0._player.player_unit

	if Unit.alive(var_33_0) then
		local var_33_1 = ScriptUnit.extension(var_33_0, "ping_system"):social_wheel_context()

		arg_33_0:_set_current_context(var_33_1)

		local var_33_2 = Managers.time:time("game")

		if var_33_1 and var_33_2 > var_33_1.min_t then
			if arg_33_0:_open_menu(arg_33_1, arg_33_2, arg_33_3) then
				arg_33_0:_set_pulsing(var_33_1, true)
			else
				arg_33_0:_set_current_context(nil)
			end
		elseif var_33_1 then
			arg_33_0:_update_pointer(arg_33_3, false, arg_33_2)
		else
			local var_33_3 = Vector3(RESOLUTION_LOOKUP.res_w / 2, RESOLUTION_LOOKUP.res_h / 2, 0)

			arg_33_0._arrow_widget.content.pointing_point:store(var_33_3)
		end
	end
end

SocialWheelUI._set_pulsing = function (arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = arg_34_1.unit

	if Unit.alive(var_34_0) then
		if arg_34_2 then
			Managers.state.entity:system("outline_system"):set_pulsing(var_34_0, true, "pulse")

			arg_34_1.id = true
		elseif not arg_34_2 and arg_34_1.id then
			Managers.state.entity:system("outline_system"):set_pulsing(var_34_0, false)

			arg_34_1.id = nil
		end
	end
end

SocialWheelUI._set_current_context = function (arg_35_0, arg_35_1)
	local var_35_0 = arg_35_0._current_context

	if arg_35_1 ~= var_35_0 then
		if var_35_0 then
			arg_35_0:_set_pulsing(var_35_0, false)
		end

		if arg_35_1 and arg_35_0._state == "open" then
			arg_35_0:_set_pulsing(arg_35_1, true)
		end

		arg_35_0._current_context = arg_35_1
	end
end

SocialWheelUI._open_menu = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
	arg_36_0._block_next_input = false

	local var_36_0 = true
	local var_36_1 = arg_36_0._current_context
	local var_36_2 = var_36_1.unit or var_36_1.ping_context_unit

	if not Unit.alive(var_36_2) then
		var_36_2 = nil
	end

	local var_36_3 = Managers.state.side.side_by_unit[arg_36_0._player.player_unit]:name()
	local var_36_4 = Managers.state.game_mode:setting("social_wheel_by_side")
	local var_36_5

	if var_36_4 then
		var_36_5 = var_36_4[var_36_3] or "general"
	else
		var_36_5 = "general"
	end

	if IS_WINDOWS then
		local var_36_6 = Managers.input:is_device_active("gamepad")
		local var_36_7 = Application.user_setting("social_wheel_gamepad_layout")
		local var_36_8 = Managers.state.game_mode:setting("should_use_gamepad_social_wheel")

		if var_36_7 == "auto" and var_36_6 or var_36_7 == "always" or var_36_8 then
			var_36_5 = var_36_5 .. "_gamepad"
		end
	else
		var_36_5 = var_36_5 .. arg_36_0._console_extension
	end

	arg_36_0:_inject_weapon_poses()

	for iter_36_0 = 1, #SocialWheelPriority do
		local var_36_9 = SocialWheelPriority[iter_36_0]
		local var_36_10 = var_36_9[1]

		if var_36_9[2](var_36_1, arg_36_0._player, var_36_2) then
			var_36_5 = var_36_10

			break
		end
	end

	arg_36_0._current_selection_widgets = arg_36_0._selection_widgets[var_36_5]

	local var_36_11 = arg_36_0._selection_widgets[var_36_5]
	local var_36_12 = var_36_11.current_page

	arg_36_0._page_input_widget.content.visible = true

	if var_36_12 then
		if arg_36_4 then
			var_36_12 = var_36_12 % var_36_11.num_pages + 1

			if var_36_1.show_emotes and var_36_12 ~= var_36_11.emotes_page_index then
				var_36_12 = var_36_11.emotes_page_index
			elseif var_36_1.show_poses and var_36_12 ~= var_36_11.weapon_poses_page_index then
				var_36_12 = var_36_11.weapon_poses_page_index or 1
			end
		else
			var_36_12 = 1

			if var_36_1.show_emotes then
				var_36_12 = var_36_11.emotes_page_index or 1
			elseif var_36_1.show_poses then
				var_36_12 = var_36_11.weapon_poses_page_index or 1
			end
		end

		var_36_11.current_page = var_36_12
		arg_36_0._current_selection_widgets = var_36_11[var_36_12]
	else
		arg_36_0._current_selection_widgets = var_36_11
	end

	if not arg_36_0._current_selection_widgets then
		var_36_0 = false

		return var_36_0
	end

	arg_36_0._active_context = var_36_1

	local var_36_13 = arg_36_0._active_context

	if var_36_11.num_pages and var_36_13.show_emotes or var_36_13.show_poses then
		arg_36_0._page_input_widget.content.visible = false
		arg_36_0._block_next_input = true
	end

	arg_36_0._current_selection_category = var_36_5

	local var_36_14 = SocialWheelSettings[var_36_5]

	fassert(var_36_14, "No settings for category %q.", var_36_5)

	arg_36_0._current_selection_widget_settings = var_36_14

	local var_36_15 = var_0_15.OPEN
	local var_36_16 = arg_36_0._animations

	var_36_16.update_alpha = UIAnimation.init(UIAnimation.function_by_time, arg_36_0._render_settings, "alpha_multiplier", 0, 1, var_36_15.ALPHA, math.easeOutCubic)

	local var_36_17 = arg_36_0._current_selection_widgets
	local var_36_18 = #var_36_17

	for iter_36_1 = 1, var_36_18 do
		local var_36_19 = var_36_17[iter_36_1]
		local var_36_20 = var_36_19.content
		local var_36_21 = var_36_20.final_offset
		local var_36_22 = var_36_20.dir:unbox()
		local var_36_23 = var_36_19.offset

		var_36_16["animation_x_" .. iter_36_1] = UIAnimation.init(UIAnimation.function_by_time, var_36_23, 1, var_36_22[1] * var_36_21[1] * 0.5, var_36_22[1] * var_36_21[1], var_36_15.MOVE_X, math.ease_out_elastic)
		var_36_16["animation_y_" .. iter_36_1] = UIAnimation.init(UIAnimation.function_by_time, var_36_23, 2, var_36_22[2] * var_36_21[2] * 0.5, var_36_22[2] * var_36_21[2], var_36_15.MOVE_Y, math.ease_out_elastic)
		var_36_16["animation_divider_size_" .. iter_36_1] = UIAnimation.init(UIAnimation.function_by_time, var_36_20, "size_multiplier", var_36_20.final_size_multiplier * 0.5, var_36_20.final_size_multiplier, var_36_15.SIZE, math.ease_out_elastic)
	end

	local var_36_24 = arg_36_0._bg_widget.content

	var_36_16.animation_bg_size = UIAnimation.init(UIAnimation.function_by_time, var_36_24, "size_multiplier", var_36_24.final_size_multiplier * 0.5, var_36_24.final_size_multiplier, var_36_15.SIZE, math.ease_out_elastic)

	local var_36_25 = (not IS_WINDOWS or Managers.input:is_device_active("gamepad")) and var_0_11 or var_0_10

	arg_36_0._valid_selection = true
	arg_36_0._selected_widget = nil
	arg_36_0._open_start_t = arg_36_2

	arg_36_0:_set_player_input_scale(0, var_36_25)
	arg_36_0:_change_state("update_open")
	ScriptUnit.extension(arg_36_0._player.player_unit, "interactor_system"):enable_interactions(false)

	if arg_36_0._world_markers_enabled then
		local function var_36_26(arg_37_0, arg_37_1)
			if arg_36_0._world_marker_preview_id then
				Managers.state.event:trigger("remove_world_marker", arg_36_0._world_marker_preview_id)
			end

			arg_36_0._world_marker_preview_id = arg_37_0
			arg_37_1.style.text.localize = false
		end

		local var_36_27 = var_36_13.position and var_36_13.position:unbox()

		if var_36_27 and not arg_36_0._world_marker_preview_id then
			Managers.state.event:trigger("add_world_marker_position", "ping", var_36_27, var_36_26)
		end
	end

	if var_36_3 then
		local var_36_28 = var_0_17[var_36_3].OPEN

		arg_36_0:_play_sound(var_36_28)
	end

	return var_36_0
end

SocialWheelUI._inject_weapon_poses = function (arg_38_0)
	local var_38_0 = Managers.player:local_player()
	local var_38_1 = var_38_0.player_unit

	if not ALIVE[var_38_1] then
		arg_38_0:_reset_social_wheel()

		return
	end

	local var_38_2 = ScriptUnit.has_extension(var_38_1, "inventory_system"):get_wielded_slot_name()

	if var_38_2 ~= "slot_melee" and var_38_2 ~= "slot_ranged" then
		arg_38_0:_reset_social_wheel()

		return
	end

	local var_38_3 = var_38_0:career_name()
	local var_38_4 = BackendUtils.get_loadout_item(var_38_3, var_38_2)
	local var_38_5 = var_38_4.data
	local var_38_6 = string.gsub(var_38_5.key, "^vs_", "")

	if var_38_4.rarity == "magic" then
		var_38_6 = string.gsub(var_38_5.key, "_magic_0%d$", "")
	end

	if arg_38_0._wielded_item_type == var_38_6 and not arg_38_0:_is_dirty(var_38_6) then
		return
	end

	arg_38_0._wielded_item_type = var_38_6
	arg_38_0._loaded_weapon_pose_packages = arg_38_0._loaded_weapon_pose_packages or {}

	local var_38_7 = arg_38_0._loaded_weapon_pose_packages[var_38_2]

	if var_38_7 and var_38_7.item_type ~= var_38_6 and var_38_2 == var_38_7.slot_type then
		arg_38_0:_reset_materials_for_item_type(var_38_7.item_type, var_38_2)
		Managers.package:unload(var_38_7.package_name, var_0_3)

		arg_38_0._loaded_weapon_pose_packages[var_38_2] = nil
	end

	local var_38_8 = arg_38_0._loaded_weapon_pose_packages[var_38_2]

	if not var_38_8 then
		local var_38_9 = "resource_packages/pose_packages/" .. var_38_6

		if Application.can_get("package", var_38_9) then
			if not Managers.package:has_loaded(var_38_9, var_0_3) then
				Managers.package:load(var_38_9, var_0_3, callback(arg_38_0, "_weapon_pose_package_loaded_cb", var_38_6, var_38_2), true, true)
			end

			arg_38_0._loaded_weapon_pose_packages[var_38_2] = {
				package_name = var_38_9,
				item_type = var_38_6,
				slot_type = var_38_2
			}
		else
			Application.warning(string.format("[SocialWheelUI:_inject_weapon_poses] Pose package %q is missing for %q", var_38_6, var_38_9))
		end
	end

	arg_38_0:_create_weapon_pose_wheel(var_38_6, var_38_2, var_38_8)
end

SocialWheelUI._is_dirty = function (arg_39_0, arg_39_1)
	local var_39_0 = arg_39_0:_gather_weapon_poses_by_parent_item(arg_39_1) ~= nil
	local var_39_1 = Managers.state.side.side_by_unit[arg_39_0._player.player_unit]:name()
	local var_39_2 = Managers.state.game_mode:setting("social_wheel_by_side")
	local var_39_3 = "general"

	if var_39_2 then
		var_39_3 = var_39_2[var_39_1]
	end

	local var_39_4 = var_39_3 .. arg_39_0._console_extension
	local var_39_5 = arg_39_0._selection_widgets[var_39_4]
	local var_39_6 = arg_39_0._selection_widgets[var_39_4 .. "_gamepad"]

	if var_39_5 then
		return var_39_5.weapon_poses_page_index ~= nil ~= var_39_0
	end

	if var_39_6 then
		return var_39_6.weapon_poses_page_index ~= nil ~= var_39_0
	end
end

SocialWheelUI._reset_social_wheel = function (arg_40_0)
	local var_40_0 = Managers.state.side.side_by_unit[arg_40_0._player.player_unit]:name()
	local var_40_1 = Managers.state.game_mode:setting("social_wheel_by_side")
	local var_40_2 = "general"

	if var_40_1 then
		var_40_2 = var_40_1[var_40_0]
	end

	local var_40_3 = var_40_2 .. arg_40_0._console_extension
	local var_40_4 = SocialWheelSettings[var_40_3]
	local var_40_5 = SocialWheelSettings[var_40_3 .. "_gamepad"]

	if var_40_4 then
		local var_40_6 = table.find_func_array(var_40_4, function (arg_41_0)
			return arg_41_0.weapon_poses
		end)

		if var_40_6 then
			table.remove(var_40_4, var_40_6)
		end
	end

	if var_40_5 then
		local var_40_7 = table.find_func_array(var_40_5, function (arg_42_0)
			return arg_42_0.weapon_poses
		end)

		if var_40_7 then
			table.remove(var_40_5, var_40_7)
		end
	end

	arg_40_0:_create_social_wheel()
end

SocialWheelUI._create_weapon_pose_wheel = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	arg_43_0:_reset_social_wheel()

	local var_43_0 = arg_43_0:_gather_weapon_poses_by_parent_item(arg_43_1)

	if not var_43_0 then
		return
	end

	local var_43_1 = var_0_0.functions
	local var_43_2 = {
		weapon_poses = true
	}
	local var_43_3 = var_0_6 and "template_diffuse_masked" or "template_diffuse"

	for iter_43_0 = 1, #var_43_0 do
		local var_43_4 = var_43_0[iter_43_0].data
		local var_43_5 = var_43_4.pose_index
		local var_43_6 = var_43_4.parent
		local var_43_7 = string.format(var_0_5, arg_43_2, var_43_4.pose_index)
		local var_43_8 = var_0_4 .. var_43_7

		arg_43_0:_create_material_instance(var_43_8, var_43_3, var_43_7)

		if arg_43_3 then
			local var_43_9 = string.format("gui/1080p/single_textures/icons_poses_social_wheel/" .. arg_43_1 .. "_%02d", var_43_5)

			arg_43_0:_set_material_diffuse_by_texture_path(var_43_8, var_43_9)
		end

		local var_43_10 = string.format(var_0_5 .. "_glow", arg_43_2, var_43_4.pose_index)
		local var_43_11 = var_0_4 .. var_43_10

		arg_43_0:_create_material_instance(var_43_11, var_43_3, var_43_10)

		if arg_43_3 then
			local var_43_12 = string.format("gui/1080p/single_textures/icons_poses_social_wheel/" .. arg_43_1 .. "_%02d_glow", var_43_5)

			arg_43_0:_set_material_diffuse_by_texture_path(var_43_11, var_43_12)
		end

		local var_43_13 = string.format("social_wheel_weapon_pose_general_pose_%02d", var_43_4.pose_index)
		local var_43_14 = {
			localize = false,
			disable_input_text = true,
			name = var_43_13,
			text = string.format(Localize(var_43_6 .. "_emote_wheel"), var_43_4.pose_index),
			event_text = string.format(Localize(var_43_6 .. "_emote_wheel"), var_43_4.pose_index),
			execute_func = var_43_1.play_emote,
			data = {
				anim_event = var_43_4.data.anim_event,
				pose_index = var_43_4.pose_index,
				hide_weapons = var_43_4.data.hide_weapons
			},
			icon = var_43_8,
			icon_glow = var_43_11,
			ping_type = PingTypes.LOCAL_ONLY
		}

		var_43_2[#var_43_2 + 1] = var_43_14
		SocialWheelSettingsLookup[var_43_13] = var_43_14
	end

	local var_43_15 = Managers.state.side.side_by_unit[arg_43_0._player.player_unit]:name()
	local var_43_16 = Managers.state.game_mode:setting("social_wheel_by_side")
	local var_43_17 = "general"

	if var_43_16 then
		var_43_17 = var_43_16[var_43_15]
	end

	local var_43_18 = var_43_17 .. arg_43_0._console_extension
	local var_43_19 = SocialWheelSettings[var_43_18]
	local var_43_20 = SocialWheelSettings[var_43_18 .. "_gamepad"]

	if var_43_19 then
		table.insert(var_43_19, var_43_2)
	end

	if var_43_20 then
		table.insert(var_43_20, var_43_2)
	end

	arg_43_0:_create_social_wheel()
end

SocialWheelUI._create_material_instance = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	local var_44_0 = arg_44_0._cloned_materials_by_reference or {}

	if not var_44_0[arg_44_3] then
		var_44_0[arg_44_3] = arg_44_1

		Gui.clone_material_from_template(arg_44_0._ui_top_renderer.gui, arg_44_1, arg_44_2)

		arg_44_0._cloned_materials_by_reference = var_44_0
	end
end

SocialWheelUI._gather_weapon_poses_by_parent_item = function (arg_45_0, arg_45_1)
	local var_45_0 = {}
	local var_45_1 = Managers.backend:get_interface("items")
	local var_45_2 = var_45_1:get_unlocked_weapon_poses()[arg_45_1]

	if not var_45_2 then
		return
	end

	for iter_45_0, iter_45_1 in pairs(var_45_2) do
		local var_45_3 = var_45_1:get_item_from_id(iter_45_1)

		var_45_0[#var_45_0 + 1] = var_45_3
	end

	local function var_45_4(arg_46_0, arg_46_1)
		return arg_46_0.data.pose_index < arg_46_1.data.pose_index
	end

	table.sort(var_45_0, var_45_4)

	return var_45_0
end

SocialWheelUI._reset_materials_for_item_type = function (arg_47_0, arg_47_1, arg_47_2)
	local var_47_0 = arg_47_0:_gather_weapon_poses_by_parent_item(arg_47_1)

	if not var_47_0 then
		return
	end

	for iter_47_0 = 1, #var_47_0 do
		local var_47_1 = var_47_0[iter_47_0].data
		local var_47_2 = string.format(var_0_5, arg_47_2, var_47_1.pose_index)

		arg_47_0:_reset_cloned_material(var_47_2)

		local var_47_3 = string.format(var_0_5 .. "_glow", arg_47_2, var_47_1.pose_index)

		arg_47_0:_reset_cloned_material(var_47_3)
	end
end

SocialWheelUI._weapon_pose_package_loaded_cb = function (arg_48_0, arg_48_1, arg_48_2)
	local var_48_0 = arg_48_0:_gather_weapon_poses_by_parent_item(arg_48_1)

	if not var_48_0 then
		return
	end

	for iter_48_0 = 1, #var_48_0 do
		local var_48_1 = var_48_0[iter_48_0].data
		local var_48_2 = string.format(var_0_5, arg_48_2, var_48_1.pose_index)
		local var_48_3 = var_0_4 .. var_48_2
		local var_48_4 = var_48_1.pose_index
		local var_48_5 = string.format("gui/1080p/single_textures/icons_poses_social_wheel/" .. arg_48_1 .. "_%02d", var_48_4)

		arg_48_0:_set_material_diffuse_by_texture_path(var_48_3, var_48_5)

		local var_48_6 = string.format(var_0_5 .. "_glow", arg_48_2, var_48_1.pose_index)
		local var_48_7 = var_0_4 .. var_48_6
		local var_48_8 = string.format("gui/1080p/single_textures/icons_poses_social_wheel/" .. arg_48_1 .. "_%02d_glow", var_48_4)

		arg_48_0:_set_material_diffuse_by_texture_path(var_48_7, var_48_8)
	end
end

SocialWheelUI._set_material_diffuse_by_texture_path = function (arg_49_0, arg_49_1, arg_49_2)
	local var_49_0 = Gui.material(arg_49_0._ui_top_renderer.gui, arg_49_1)

	if var_49_0 then
		Material.set_texture(var_49_0, "diffuse_map", arg_49_2)
	else
		Application.error(string.format("[SocialWheelUI:_set_material_diffuse_by_texture_path9 Missing material name: %q", arg_49_1))
	end
end

SocialWheelUI._reset_cloned_material = function (arg_50_0, arg_50_1)
	local var_50_0 = arg_50_0._cloned_materials_by_reference[arg_50_1]

	if var_50_0 then
		arg_50_0:_set_material_diffuse_by_texture_path(var_50_0, var_0_2)
	else
		Application.error(string.format("[SocialWheelUI:_reset_cloned_material] Found no material to reset for reference name: %q", arg_50_1))
	end
end

SocialWheelUI.update_open = function (arg_51_0, arg_51_1, arg_51_2, arg_51_3)
	local var_51_0 = arg_51_3:get("ping_hold")
	local var_51_1 = arg_51_3:get("ping_release") or arg_51_0.previous_ping_held and not var_51_0
	local var_51_2 = arg_51_3:get("social_wheel_only_hold")
	local var_51_3 = arg_51_3:get("social_wheel_only_release") or arg_51_0.previous_social_wheel_only_held and not var_51_2
	local var_51_4 = arg_51_3:get("photomode_only_hold")
	local var_51_5 = arg_51_3:get("photomode_only_release") or arg_51_0.previous_photomode_only_held and not var_51_4

	if var_51_4 and arg_51_0._current_selection_widget_settings.has_pages and arg_51_3:get("social_wheel_page") and not arg_51_0._block_next_input then
		arg_51_0:_close_menu(arg_51_1, arg_51_2, arg_51_3, true)
		arg_51_0:_open_menu(arg_51_1, arg_51_2, arg_51_3, true)

		return
	end

	local var_51_6 = arg_51_3:get("weapon_poses_only_hold")
	local var_51_7 = arg_51_3:get("weapon_poses_only_release") or arg_51_0.previous_weapon_poses_only_held and not var_51_6

	if var_51_6 and arg_51_0._current_selection_widget_settings.has_pages and arg_51_3:get("social_wheel_page") and not arg_51_0._block_next_input then
		arg_51_0:_close_menu(arg_51_1, arg_51_2, arg_51_3, true)
		arg_51_0:_open_menu(arg_51_1, arg_51_2, arg_51_3, true)

		return
	end

	if arg_51_0._current_selection_widget_settings.has_pages and arg_51_3:get("social_wheel_page") and not arg_51_0._block_next_input then
		arg_51_0:_close_menu(arg_51_1, arg_51_2, arg_51_3, true)
		arg_51_0:_open_menu(arg_51_1, arg_51_2, arg_51_3, true)

		return
	end

	if var_51_1 or var_51_3 or var_51_5 or var_51_7 then
		arg_51_0:_close_menu(arg_51_1, arg_51_2, arg_51_3)

		return
	end

	arg_51_0:_update_pointer(arg_51_3, true, arg_51_2)
end

SocialWheelUI._update_pointer = function (arg_52_0, arg_52_1, arg_52_2, arg_52_3)
	local var_52_0 = arg_52_0._arrow_widget
	local var_52_1 = var_52_0.content
	local var_52_2 = var_52_0.style
	local var_52_3 = var_52_2.arrow
	local var_52_4 = var_52_2.cursor
	local var_52_5 = arg_52_0._current_selection_widget_settings
	local var_52_6 = 0
	local var_52_7 = false

	if Managers.input:is_device_active("gamepad") then
		local var_52_8 = arg_52_1:get("look_raw_controller")

		if Vector3.length_squared(var_52_8) < 0.5 then
			var_52_3.angle = 0
			var_52_3.offset = {
				0,
				0,
				0
			}
			var_52_1.visible = false

			if arg_52_3 < arg_52_0._select_timer then
				arg_52_2 = false
			end
		else
			local var_52_9 = Vector3.normalize(var_52_8)

			var_52_6 = math.atan2(var_52_9[2], var_52_9[1])
			var_52_3.angle = math.pi - var_52_6
			var_52_3.offset = {
				90 * var_52_9[1],
				90 * var_52_9[2],
				0
			}
			var_52_1.visible = arg_52_2
			var_52_7 = arg_52_2
			arg_52_0._select_timer = arg_52_3 + 0.4
		end
	else
		local var_52_10 = arg_52_1:get("look_raw")
		local var_52_11 = Vector3(RESOLUTION_LOOKUP.res_w / 2, RESOLUTION_LOOKUP.res_h / 2, 0)
		local var_52_12 = var_52_1.pointing_point:unbox() + Vector3(var_52_10.x, -var_52_10.y, 0) - var_52_11
		local var_52_13 = Vector3.length(var_52_12)
		local var_52_14 = math.min(var_52_13, 200)
		local var_52_15 = Vector3.normalize(var_52_12)
		local var_52_16 = var_52_11 + var_52_15 * var_52_14
		local var_52_17 = arg_52_2 and var_52_5.size[1] / var_52_5.size[2] or 1

		if var_52_14 < 100 then
			var_52_6 = math.atan2(var_52_15[2] * var_52_17, var_52_15[1])
			var_52_3.angle = math.pi - var_52_6
			var_52_3.offset = {
				0,
				0,
				0
			}
			var_52_3.color[1] = 0
			var_52_4.color[1] = 255
			var_52_4.offset = {
				var_52_12.x,
				var_52_12.y
			}
			var_52_1.visible = arg_52_2

			var_52_1.pointing_point:store(var_52_16)
		else
			var_52_6 = math.atan2(var_52_15[2] * var_52_17, var_52_15[1])
			var_52_3.angle = math.pi - var_52_6
			var_52_3.offset = {
				100 * var_52_15[1],
				100 * var_52_15[2],
				0
			}
			var_52_3.color[1] = 255
			var_52_4.color[1] = 0
			var_52_1.visible = arg_52_2

			var_52_1.pointing_point:store(var_52_16)

			var_52_7 = arg_52_2
		end
	end

	if arg_52_2 then
		arg_52_0:_update_selection(var_52_7, var_52_5.angle, var_52_6)
	end
end

SocialWheelUI._update_selection = function (arg_53_0, arg_53_1, arg_53_2, arg_53_3)
	local var_53_0 = arg_53_0._current_selection_widgets

	local function var_53_1()
		var_53_0[arg_53_0._current_index].content.selected = false
		arg_53_0._current_index = nil
		arg_53_0._valid_selection = true
		arg_53_0._bg_widget.content.text_id = Localize("tutorial_no_text")
	end

	if not arg_53_1 then
		if arg_53_0._current_index then
			var_53_1()
		end

		return
	end

	local var_53_2 = arg_53_0:_select_widget(arg_53_2, #var_53_0, arg_53_3)

	if not var_53_2 and arg_53_0._current_index then
		var_53_1()

		return
	end

	local var_53_3 = arg_53_0._current_index

	if var_53_3 and not var_53_0[var_53_3].content.is_valid then
		var_53_1()

		return
	end

	if var_53_2 == var_53_3 then
		return
	end

	if var_53_3 then
		var_53_0[var_53_3].content.selected = false
		arg_53_0._current_index = nil
	end

	local var_53_4 = var_53_0[var_53_2]

	if var_53_4.content.is_valid then
		var_53_4.content.selected = true
		arg_53_0._current_index = var_53_2
		arg_53_0._valid_selection = true

		if not IS_WINDOWS then
			local var_53_5 = arg_53_0._active_context.unit

			if not var_53_5 or Unit.alive(var_53_5) then
				local var_53_6 = var_53_4.content.settings.name
				local var_53_7 = SocialWheelSettingsLookup[var_53_6]
				local var_53_8 = var_53_7.event_text_func

				if not var_53_7.disable_input_text then
					local var_53_9 = var_53_8 and var_53_8(var_53_5, var_53_7, true) or var_53_7.event_text or Localize(var_53_7.text)

					arg_53_0._bg_widget.content.text_id = var_53_9
				end
			end
		end

		local var_53_10 = Managers.state.side.side_by_unit[arg_53_0._player.player_unit]:name()

		if var_53_10 then
			local var_53_11 = var_0_17[var_53_10].HOVER

			arg_53_0:_play_sound(var_53_11)
		end
	else
		arg_53_0._valid_selection = false
	end
end

SocialWheelUI._close_menu = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4)
	local var_55_0 = var_0_15.CLOSE
	local var_55_1 = arg_55_0._animations

	arg_55_0._animations.update_alpha = UIAnimation.init(UIAnimation.function_by_time, arg_55_0._render_settings, "alpha_multiplier", arg_55_0._render_settings.alpha_multiplier, 0, var_55_0.ALPHA, math.easeOutCubic)

	local var_55_2 = arg_55_0._bg_widget.content

	var_55_2.text_id = Localize("tutorial_no_text")
	var_55_1.animation_bg_size = UIAnimation.init(UIAnimation.function_by_time, var_55_2, "size_multiplier", var_55_2.size_multiplier, 0, var_55_0.SIZE, math.easeOutCubic)

	local var_55_3 = arg_55_0._active_context
	local var_55_4 = var_55_3.unit or var_55_3.ping_context_unit
	local var_55_5 = arg_55_0._current_selection_widgets
	local var_55_6 = #var_55_5

	for iter_55_0 = 1, var_55_6 do
		local var_55_7 = var_55_5[iter_55_0]
		local var_55_8 = var_55_7.content
		local var_55_9 = var_55_7.offset

		var_55_1["animation_x_" .. iter_55_0] = UIAnimation.init(UIAnimation.function_by_time, var_55_9, 1, var_55_9[1], 0, var_55_0.MOVE_X, math.easeOutCubic)
		var_55_1["animation_y_" .. iter_55_0] = UIAnimation.init(UIAnimation.function_by_time, var_55_9, 2, var_55_9[2], 0, var_55_0.MOVE_Y, math.easeOutCubic)
		var_55_1["animation_divider_size_" .. iter_55_0] = UIAnimation.init(UIAnimation.function_by_time, var_55_8, "size_multiplier", var_55_8.size_multiplier, 0, var_55_0.SIZE, math.easeOutCubic)

		if iter_55_0 == arg_55_0._current_index then
			local var_55_10 = var_55_8.settings

			var_55_8.selected = false

			local function var_55_11()
				return var_55_3
			end

			local var_55_12 = var_55_7.content.category_settings
			local var_55_13 = arg_55_0._current_selection_category
			local var_55_14 = arg_55_0._selection_widgets[var_55_13].current_page
			local var_55_15 = UIWidget.init(var_0_7.create_social_widget(var_55_10, arg_55_0:_widget_angle(var_55_12.angle, var_55_6, iter_55_0), var_55_12, var_55_11, var_55_14))

			arg_55_0._selected_widget = var_55_15

			local var_55_16 = var_55_15.content

			var_55_16.selected = true
			var_55_16.activated = true

			local var_55_17 = var_55_15.style
			local var_55_18 = var_55_17.icon.color
			local var_55_19 = var_55_17.icon_shadow.color
			local var_55_20 = var_55_17.icon_bg.color
			local var_55_21 = var_55_17.icon.texture_size
			local var_55_22 = var_55_17.icon_shadow.texture_size
			local var_55_23 = var_55_17.icon.base_texture_size
			local var_55_24 = var_55_17.icon_shadow.base_texture_size
			local var_55_25 = var_55_17.text.selected_color
			local var_55_26 = var_55_17.text_shadow.selected_color

			var_55_1["icon_color_a_" .. iter_55_0] = UIAnimation.init(UIAnimation.pulse_animation3, var_55_18, 1, var_55_18[1], var_55_18[1] * 0.5, 10, 0.5)
			var_55_1["icon_size_x_" .. iter_55_0] = UIAnimation.init(UIAnimation.pulse_animation3, var_55_21, 1, var_55_23[1], var_55_23[1] * 0.75, 10, 0.5)
			var_55_1["icon_size_y_" .. iter_55_0] = UIAnimation.init(UIAnimation.pulse_animation3, var_55_21, 2, var_55_23[2], var_55_23[2] * 0.75, 10, 0.5)
			var_55_1["icon_shadow_color_a_" .. iter_55_0] = UIAnimation.init(UIAnimation.pulse_animation3, var_55_19, 1, var_55_19[1], var_55_19[1] * 0.5, 10, 0.5)
			var_55_1["icon_shadow_size_x_" .. iter_55_0] = UIAnimation.init(UIAnimation.pulse_animation3, var_55_22, 1, var_55_24[1], var_55_24[1] * 0.75, 10, 0.5)
			var_55_1["icon_shadow_size_y_" .. iter_55_0] = UIAnimation.init(UIAnimation.pulse_animation3, var_55_22, 2, var_55_24[2], var_55_24[2] * 0.75, 10, 0.5)
			arg_55_0._animation_callbacks["icon_color_a_" .. iter_55_0] = function ()
				var_55_1["fade_text_color_a_" .. iter_55_0] = UIAnimation.init(UIAnimation.function_by_time, var_55_25, 1, var_55_25[1], 0, 0.25, math.easeOutCubic)
				var_55_1["fade_text_shadow_color_a_" .. iter_55_0] = UIAnimation.init(UIAnimation.function_by_time, var_55_26, 1, var_55_26[1], 0, 0.25, math.easeOutCubic)
				var_55_1["fade_icon_color_a_" .. iter_55_0] = UIAnimation.init(UIAnimation.function_by_time, var_55_18, 1, var_55_18[1], 0, 0.25, math.easeOutCubic)
				var_55_1["fade_icon_shadow_color_a_" .. iter_55_0] = UIAnimation.init(UIAnimation.function_by_time, var_55_19, 1, var_55_19[1], 0, 0.25, math.easeOutCubic)
				var_55_1["fade_icon_bg_color_a_" .. iter_55_0] = UIAnimation.init(UIAnimation.function_by_time, var_55_20, 1, var_55_20[1], 0, 0.25, math.easeOutCubic)
				arg_55_0._animation_callbacks["fade_icon_color_a_" .. iter_55_0] = function ()
					arg_55_0._selected_widget = nil
					var_55_16.activated = false
				end
			end
		end
	end

	if arg_55_4 then
		arg_55_0._open_start_t = nil
		arg_55_0._current_index = nil

		return
	end

	if IS_CONSOLE then
		arg_55_0._console_extension = arg_55_0._ingame_ui_context.is_in_inn and "_inn" or ""
	else
		arg_55_0._console_extension = ""
	end

	local var_55_27 = (not IS_WINDOWS or Managers.input:is_device_active("gamepad")) and var_0_13 or var_0_12
	local var_55_28

	if arg_55_0._world_marker_preview_id then
		Managers.state.event:trigger("remove_world_marker", arg_55_0._world_marker_preview_id)

		arg_55_0._world_marker_preview_id = nil
	end

	if arg_55_0._valid_selection then
		if arg_55_0._current_index == nil then
			local var_55_29 = arg_55_2 - arg_55_0._open_start_t
			local var_55_30, var_55_31 = table.max(var_0_15.OPEN)

			if var_55_29 < var_55_31 then
				var_55_28 = arg_55_0:_ping_unit_attempt(var_55_4, PingTypes.CONTEXT)
			end
		else
			local var_55_32 = arg_55_0._current_selection_widgets[arg_55_0._current_index].content.settings
			local var_55_33 = var_55_32.ping_type or PingTypes.CHAT_ONLY
			local var_55_34 = rawget(NetworkLookup.social_wheel_events, var_55_32.name)

			if var_55_34 then
				if var_55_4 and (arg_55_0._world_markers_enabled or var_55_33 == PingTypes.PLAYER_PICK_UP) then
					var_55_28 = arg_55_0:_ping_unit_attempt(var_55_4, var_55_33, var_55_34)
				elseif var_55_33 == PingTypes.LOCAL_ONLY then
					var_55_28 = arg_55_0:_local_ping_attempt(var_55_34, var_55_4)
				elseif var_55_3.position and arg_55_0._world_markers_enabled then
					var_55_28 = arg_55_0:_ping_world_position_attempt(var_55_3.position, var_55_33, var_55_34)
				else
					var_55_28 = arg_55_0:_social_message_attempt(var_55_34, var_55_4)
				end
			end
		end
	end

	local var_55_35 = Managers.state.side.side_by_unit[arg_55_0._player.player_unit]:name()

	if var_55_35 then
		if var_55_28 then
			local var_55_36 = var_0_17[var_55_35].SELECT

			arg_55_0:_play_sound(var_55_36)
		else
			local var_55_37 = var_0_17[var_55_35].CLOSE

			arg_55_0:_play_sound(var_55_37)
		end
	end

	arg_55_0._active_context = nil

	arg_55_0:_set_current_context(nil)

	arg_55_0._open_start_t = nil
	arg_55_0._current_index = nil

	arg_55_0:_set_player_input_scale(1, var_55_27)
	arg_55_0:_change_state("update_closed")
	ScriptUnit.extension(arg_55_0._player.player_unit, "interactor_system"):enable_interactions(true)
end

SocialWheelUI.is_active = function (arg_59_0)
	return arg_59_0._active_context ~= nil
end
