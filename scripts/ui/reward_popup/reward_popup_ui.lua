-- chunkname: @scripts/ui/reward_popup/reward_popup_ui.lua

local var_0_0 = local_require("scripts/ui/reward_popup/reward_popup_ui_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.animations
local var_0_3 = var_0_0.item_list_padding

RewardPopupUI = class(RewardPopupUI)

local var_0_4 = 10
local var_0_5 = 2.5
local var_0_6 = "rewards_popups"

local function var_0_7(arg_1_0)
	return arg_1_0:get("toggle_menu", true) or arg_1_0:get("back", true) or arg_1_0:get("skip_pressed", true) or arg_1_0:get("left_press")
end

function RewardPopupUI.init(arg_2_0, arg_2_1)
	arg_2_0._ui_top_renderer = arg_2_1.ui_top_renderer
	arg_2_0._input_manager = arg_2_1.input_manager
	arg_2_0.world = arg_2_1.world or arg_2_1.ui_renderer.world
	arg_2_0._wwise_world = arg_2_1.wwise_world or arg_2_1.world_manager:wwise_world(arg_2_0.world)
	arg_2_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_2_0._skip_blur = false

	arg_2_0:create_ui_elements()
	arg_2_0:_setup_input()
end

function RewardPopupUI.create_ui_elements(arg_3_0)
	arg_3_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)

	local var_3_0 = var_0_0.widget_definitions

	arg_3_0.background_top_widget = UIWidget.init(var_3_0.background_top)
	arg_3_0.background_center_widget = UIWidget.init(var_3_0.background_center)
	arg_3_0.background_bottom_widget = UIWidget.init(var_3_0.background_bottom)
	arg_3_0.background_bottom_glow_widget = UIWidget.init(var_3_0.background_bottom_glow)
	arg_3_0.background_top_glow_widget = UIWidget.init(var_3_0.background_top_glow)
	arg_3_0.screen_background_widget = UIWidget.init(var_3_0.screen_background)
	arg_3_0.deus_background_top_widget = UIWidget.init(var_3_0.deus_background_top)
	arg_3_0.deus_background_bottom_widget = UIWidget.init(var_3_0.deus_background_bottom)
	arg_3_0.deus_background_top_glow_widget = UIWidget.init(var_3_0.deus_background_top_glow)
	arg_3_0.deus_background_bottom_glow_widget = UIWidget.init(var_3_0.deus_background_bottom_glow)
	arg_3_0.claim_button_widget = UIWidget.init(var_3_0.claim_button)
	arg_3_0._ui_animator = UIAnimator:new(arg_3_0._ui_scenegraph, var_0_2)
	arg_3_0._animations = {}
	arg_3_0._is_visible = true
	arg_3_0._speed_up_popup = false
	arg_3_0._done_reset_speed_up_popup = false
end

function RewardPopupUI.set_input_manager(arg_4_0, arg_4_1)
	arg_4_0._input_manager = arg_4_1

	arg_4_0:_setup_input()
end

function RewardPopupUI.destroy(arg_5_0)
	arg_5_0:_release_input()

	arg_5_0._ui_animator = nil

	arg_5_0:set_visible(false)

	if arg_5_0._fullscreen_effect_enabled then
		arg_5_0:set_fullscreen_effect_enable_state(false)
	end
end

function RewardPopupUI.set_visible(arg_6_0, arg_6_1)
	arg_6_0._is_visible = arg_6_1
end

function RewardPopupUI.update(arg_7_0, arg_7_1, arg_7_2)
	if arg_7_0.input_acquired and arg_7_0:is_presentation_complete() then
		arg_7_0:_release_input()
	end

	if not arg_7_0._is_visible or not arg_7_0._draw_widgets then
		return
	end

	if not arg_7_0._speed_up_popup and not arg_7_0._handling_claim_button then
		local var_7_0 = arg_7_0._input_manager:get_service(var_0_6)

		if var_0_7(var_7_0) then
			arg_7_0._speed_up_popup = true
		end
	else
		local var_7_1 = arg_7_0._animation_presentation_data

		if var_7_1 then
			if var_7_1.end_animation_key then
				arg_7_1 = arg_7_1 * var_0_5
			else
				arg_7_1 = arg_7_1 * var_0_4
			end
		end
	end

	arg_7_0:_update_presentation_animation(arg_7_1)
	arg_7_0:_update_animations(arg_7_1)

	local var_7_2 = arg_7_0._animation_params

	if var_7_2 then
		local var_7_3 = var_7_2.blur_progress or 1

		arg_7_0:set_fullscreen_effect_enable_state(true, var_7_3)
	end

	arg_7_0:draw(arg_7_1)
end

function RewardPopupUI._update_animations(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._animations
	local var_8_1 = arg_8_0._ui_animator

	var_8_1:update(arg_8_1)

	local var_8_2 = false

	for iter_8_0, iter_8_1 in pairs(var_8_0) do
		if var_8_1:is_animation_completed(iter_8_1) then
			var_8_1:stop_animation(iter_8_1)

			var_8_0[iter_8_0] = nil
		end

		var_8_2 = true
	end

	return var_8_2
end

function RewardPopupUI.draw(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0._ui_top_renderer
	local var_9_1 = arg_9_0._ui_scenegraph
	local var_9_2 = arg_9_0._input_manager:get_service(var_0_6)
	local var_9_3 = arg_9_0._render_settings

	UIRenderer.begin_pass(var_9_0, var_9_1, var_9_2, arg_9_1, nil, var_9_3)
	UIRenderer.draw_widget(var_9_0, arg_9_0.background_top_widget)
	UIRenderer.draw_widget(var_9_0, arg_9_0.background_center_widget)
	UIRenderer.draw_widget(var_9_0, arg_9_0.background_bottom_widget)
	UIRenderer.draw_widget(var_9_0, arg_9_0.background_bottom_glow_widget)
	UIRenderer.draw_widget(var_9_0, arg_9_0.background_top_glow_widget)
	UIRenderer.draw_widget(var_9_0, arg_9_0.screen_background_widget)
	UIRenderer.draw_widget(var_9_0, arg_9_0.deus_background_top_widget)
	UIRenderer.draw_widget(var_9_0, arg_9_0.deus_background_bottom_widget)
	UIRenderer.draw_widget(var_9_0, arg_9_0.deus_background_bottom_glow_widget)
	UIRenderer.draw_widget(var_9_0, arg_9_0.deus_background_top_glow_widget)

	local var_9_4 = arg_9_0._animation_presentation_data

	if var_9_4 and not var_9_4.complete then
		local var_9_5 = var_9_4.entries[var_9_4.entry_play_index]

		if var_9_5 then
			local var_9_6 = var_9_5.widgets_data

			for iter_9_0, iter_9_1 in ipairs(var_9_6) do
				var_9_3.alpha_multiplier = iter_9_1.alpha_multiplier

				local var_9_7 = iter_9_1.widget

				UIRenderer.draw_widget(var_9_0, var_9_7)

				var_9_3.alpha_multiplier = nil
			end
		end

		if IS_WINDOWS and var_9_4.claim_button then
			local var_9_8 = arg_9_0.claim_button_widget

			UIWidgetUtils.animate_default_button(var_9_8, arg_9_1)

			var_9_3.alpha_multiplier = var_9_8.content.alpha_multiplier

			UIRenderer.draw_widget(var_9_0, var_9_8)
		end
	end

	UIRenderer.end_pass(var_9_0)

	if arg_9_0._handling_claim_button and arg_9_0._menu_input_description and arg_9_0._input_manager:is_device_active("gamepad") then
		arg_9_0._menu_input_description:set_input_description(nil)
		arg_9_0._menu_input_description:draw(var_9_0, arg_9_1)
	end
end

function RewardPopupUI.display_presentation(arg_10_0, arg_10_1, arg_10_2)
	arg_10_0._draw_widgets = true
	arg_10_0._ui_animator = UIAnimator:new(arg_10_0._ui_scenegraph, var_0_2)
	arg_10_0._animations = {}
	arg_10_0._animation_presentation_data = arg_10_0:_setup_presentation(arg_10_1)

	arg_10_0:set_visible(true)

	arg_10_0._presentation_complete = false
	arg_10_0._speed_up_popup = false
	arg_10_0._done_reset_speed_up_popup = false
	arg_10_0._reward_complete_cb = arg_10_2

	if not arg_10_1.keep_input then
		arg_10_0:_acquire_input()
	end
end

function RewardPopupUI.is_presentation_active(arg_11_0)
	return arg_11_0._animation_presentation_data ~= nil
end

function RewardPopupUI.is_presentation_complete(arg_12_0)
	return arg_12_0._presentation_complete
end

function RewardPopupUI.on_presentation_complete(arg_13_0)
	arg_13_0._presentation_complete = true
	arg_13_0._draw_widgets = false

	arg_13_0:set_visible(false)
	arg_13_0:set_fullscreen_effect_enable_state(false)

	arg_13_0._animation_presentation_data = nil

	if arg_13_0._reward_complete_cb then
		arg_13_0._reward_complete_cb()

		arg_13_0._reward_complete_cb = nil
	end
end

function RewardPopupUI.start_presentation_animation(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = {
		wwise_world = arg_14_0._wwise_world
	}

	arg_14_2 = arg_14_2 or {
		background_top = arg_14_0.background_top_widget,
		background_center = arg_14_0.background_center_widget,
		background_bottom = arg_14_0.background_bottom_widget,
		background_bottom_glow = arg_14_0.background_bottom_glow_widget,
		background_top_glow = arg_14_0.background_top_glow_widget,
		claim_button = arg_14_0.claim_button_widget,
		deus_background_top = arg_14_0.deus_background_top_widget,
		deus_background_bottom = arg_14_0.deus_background_bottom_widget,
		deus_background_bottom_glow = arg_14_0.deus_background_bottom_glow_widget,
		deus_background_top_glow = arg_14_0.deus_background_top_glow_widget
	}

	local var_14_1 = arg_14_0._ui_animator:start_animation(arg_14_1, arg_14_2, var_0_1, var_14_0)
	local var_14_2 = arg_14_1 .. var_14_1

	arg_14_0._animations[var_14_2] = var_14_1
	arg_14_0._animation_params = var_14_0

	return var_14_2
end

local function var_0_8(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_0.offset

	var_15_0[1] = arg_15_1
	var_15_0[2] = arg_15_2
end

function RewardPopupUI._hacky_get_tooltip_size(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0._ui_top_renderer
	local var_16_1 = arg_16_0._render_settings
	local var_16_2 = var_16_1.alpha_multiplier

	var_16_1.alpha_multiplier = 0

	UIRenderer.begin_pass(var_16_0, arg_16_0._ui_scenegraph, FAKE_INPUT_SERVICE, 0, nil, var_16_1)
	UIRenderer.draw_widget(var_16_0, arg_16_1)
	UIRenderer.end_pass(var_16_0)

	var_16_1.alpha_multiplier = var_16_2

	return arg_16_1.style.item.item_presentation_height
end

function RewardPopupUI._setup_entry_widget(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = var_0_0.widget_definitions
	local var_17_1 = arg_17_1.value
	local var_17_2 = arg_17_1.widget_type and var_17_0[arg_17_1.widget_type] and arg_17_1.widget_type or "item"
	local var_17_3 = arg_17_1.ignore_height
	local var_17_4 = UIWidget.init(var_17_0[var_17_2])
	local var_17_5 = var_17_4.scenegraph_id
	local var_17_6 = var_0_1[var_17_5].size
	local var_17_7 = arg_17_0._ui_scenegraph[var_17_5].size
	local var_17_8 = 0

	if var_17_2 == "title" or var_17_2 == "level" then
		var_17_4.content.text = var_17_1

		local var_17_9 = var_17_4.style.text

		var_17_7[2] = UIUtils.get_text_height(arg_17_0._ui_top_renderer, var_17_6, var_17_9, var_17_1)
		var_17_8 = var_17_7[2]
	elseif var_17_2 == "description" then
		var_17_4.content.title_text = var_17_1[1]
		var_17_4.content.text = var_17_1[2]

		local var_17_10 = var_17_4.style.text
		local var_17_11 = var_17_4.style.title_text
		local var_17_12 = arg_17_0._ui_top_renderer

		var_17_7[2] = UIUtils.get_text_height(var_17_12, var_17_6, var_17_10, var_17_1[1]) + UIUtils.get_text_height(var_17_12, var_17_6, var_17_11, var_17_1[2])
		var_17_8 = var_17_7[2]
	elseif var_17_2 == "texture" or var_17_2 == "icon" then
		var_17_4.content.texture_id = var_17_1

		local var_17_13 = var_17_4.style.texture_id
		local var_17_14 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_17_1).size
		local var_17_15 = var_17_13.texture_size

		var_17_15[1] = var_17_14[1]
		var_17_15[2] = var_17_14[2]
		var_17_13.offset[3] = arg_17_2

		if var_17_4.style.frame then
			var_17_4.style.frame.offset[3] = arg_17_2 + 1
		end

		var_17_8 = var_17_15[2] / 2
	elseif var_17_2 == "weapon_skin" or var_17_2 == "skin" or var_17_2 == "keep_decoration_painting" then
		local var_17_16 = var_17_1.data
		local var_17_17 = var_17_1.rarity or var_17_16.rarity

		var_17_4.content.texture_id = var_17_1.icon or var_17_16.inventory_icon
		var_17_4.content.rarity_texture = UISettings.item_rarity_textures[var_17_17]
		var_17_8 = 0
	elseif var_17_2 == "career" then
		local var_17_18 = CareerSettings[var_17_1]
		local var_17_19 = "small_" .. var_17_18.portrait_image

		var_17_4.content.texture_id = var_17_19
	elseif var_17_2 == "item" or var_17_2 == "frame" then
		local var_17_20 = var_17_1.backend_id
		local var_17_21 = Managers.backend:get_interface("items"):get_item_from_id(var_17_20)
		local var_17_22 = var_17_21.rarity or var_17_21.data and var_17_21.data.rarity or "plentiful"
		local var_17_23 = UIUtils.get_ui_information_from_item(var_17_21)

		var_17_4.content.texture_id = var_17_23
		var_17_4.content.rarity_texture = UISettings.item_rarity_textures[var_17_22]
		var_17_8 = 0
	elseif var_17_2 == "item_list" then
		local var_17_24 = var_17_4.content
		local var_17_25 = var_17_4.style
		local var_17_26 = #var_17_1
		local var_17_27 = var_0_0.item_list_max_columns
		local var_17_28 = math.ceil(var_17_26 / var_17_27) - 1

		var_17_24.cursor_x = 1
		var_17_24.cursor_y = 1
		var_17_24.rows = var_17_28 + 1
		var_17_24.cols = math.min(var_17_27, var_17_26)
		var_17_24.item_count = var_17_26

		for iter_17_0 = 1, var_17_26 do
			local var_17_29 = "rarity" .. iter_17_0
			local var_17_30 = "icon" .. iter_17_0
			local var_17_31 = "frame" .. iter_17_0
			local var_17_32 = "illusion" .. iter_17_0
			local var_17_33 = "tooltip" .. iter_17_0
			local var_17_34 = "item" .. iter_17_0
			local var_17_35 = 80 + var_0_3
			local var_17_36 = var_17_35 * ((iter_17_0 - 1) % var_17_27)
			local var_17_37 = var_17_35 * (var_17_28 - math.floor((iter_17_0 - 1) / var_17_27))

			if iter_17_0 > var_17_28 * var_17_27 then
				var_17_36 = var_17_36 + var_17_35 * 0.5 * (-var_17_26 % var_17_27)
			end

			var_0_8(var_17_25[var_17_29], var_17_36, var_17_37)
			var_0_8(var_17_25[var_17_30], var_17_36, var_17_37)
			var_0_8(var_17_25[var_17_31], var_17_36, var_17_37)
			var_0_8(var_17_25[var_17_32], var_17_36, var_17_37)
			var_0_8(var_17_25[var_17_33], var_17_36, var_17_37)

			if iter_17_0 == 1 then
				var_0_8(var_17_25.cursor, var_17_36, var_17_37)
			end

			local var_17_38 = var_17_1[iter_17_0]
			local var_17_39 = var_17_38.data
			local var_17_40 = var_17_38.rarity or var_17_39 and var_17_39.rarity or "plentiful"

			var_17_24[var_17_30] = UIUtils.get_ui_information_from_item(var_17_38) or "icons_placeholder"
			var_17_24[var_17_29] = UISettings.item_rarity_textures[var_17_40] or "icons_placeholder"
			var_17_24[var_17_34] = var_17_38
			var_17_24[var_17_32] = var_17_39 and var_17_39.item_type == "weapon_skin"
		end

		for iter_17_1 = var_17_26 + 1, var_0_0.item_list_max_rows * var_17_27 do
			var_17_24["item_" .. iter_17_1] = nil
		end

		var_17_8 = 210 + (80 + var_0_3) * var_17_28
	elseif var_17_2 == "deus_item" then
		local var_17_41 = var_17_1.backend_id
		local var_17_42 = Managers.backend:get_interface("items"):get_item_from_id(var_17_41)
		local var_17_43 = var_17_42.rarity or var_17_42.data and var_17_42.data.rarity or "plentiful"
		local var_17_44, var_17_45, var_17_46 = UIUtils.get_ui_information_from_item(var_17_42)

		var_17_4.content.texture_id = var_17_44
		var_17_4.content.rarity_texture = UISettings.item_rarity_textures[var_17_43]
		var_17_8 = 0
	elseif var_17_2 == "deus_icon" then
		local var_17_47 = Managers.player:local_player()
		local var_17_48 = var_17_47:profile_index()
		local var_17_49 = var_17_47:career_index()

		var_17_4.content.icon = DeusPowerUpUtils.get_power_up_icon(var_17_1, var_17_48, var_17_49)
		var_17_8 = 0
	elseif var_17_2 == "deus_item_tooltip" or var_17_2 == "item_tooltip" then
		local var_17_50 = var_17_1.backend_id
		local var_17_51 = Managers.backend:get_interface("items"):get_item_from_id(var_17_50)

		var_17_4.content.item = var_17_51
		var_17_4.style.item.draw_end_passes = true
		var_17_8 = arg_17_0:_hacky_get_tooltip_size(var_17_4) - 20
	elseif var_17_2 == "deus_power_up" then
		local var_17_52 = DeusPowerUps[var_17_1.rarity][var_17_1.name]
		local var_17_53 = Managers.player:local_player()
		local var_17_54 = var_17_53:profile_index()
		local var_17_55 = var_17_53:career_index()
		local var_17_56 = var_17_52.rarity
		local var_17_57 = RaritySettings[var_17_56]
		local var_17_58 = var_17_4.content

		var_17_58.title_text = DeusPowerUpUtils.get_power_up_name_text(var_17_52.name, var_17_52.talent_index, var_17_52.talent_tier, var_17_54, var_17_55)
		var_17_58.rarity_text = Localize(var_17_57.display_name)
		var_17_4.style.icon_frame.color = var_17_57.frame_color
		var_17_4.style.icon_glow.color = var_17_57.color
		var_17_58.description_text = DeusPowerUpUtils.get_power_up_description(var_17_52, var_17_54, var_17_55)
		var_17_58.icon = DeusPowerUpUtils.get_power_up_icon(var_17_52, var_17_54, var_17_55)

		local var_17_59 = var_17_4.style
		local var_17_60 = Colors.get_table(var_17_56)

		var_17_59.rarity_text.text_color = var_17_60

		local var_17_61 = DeusPowerUpSetLookup[var_17_52.rarity] and DeusPowerUpSetLookup[var_17_52.rarity][var_17_52.name]
		local var_17_62 = false

		if var_17_61 then
			local var_17_63 = var_17_61[1]
			local var_17_64 = 0
			local var_17_65 = var_17_63.pieces
			local var_17_66 = Managers.mechanism:game_mechanism():get_deus_run_controller()

			for iter_17_2, iter_17_3 in ipairs(var_17_65) do
				local var_17_67 = iter_17_3.name
				local var_17_68 = iter_17_3.rarity
				local var_17_69 = var_17_66:get_own_peer_id()

				if var_17_66:has_power_up_by_name(var_17_69, var_17_67, var_17_68) then
					var_17_64 = var_17_64 + 1
				end
			end

			var_17_62 = true

			local var_17_70 = var_17_63.num_required_pieces or #var_17_65

			var_17_4.content.set_progression = Localize("set_bonus_boons") .. " " .. string.format(Localize("set_counter_boons"), var_17_64, var_17_70)

			if #var_17_65 == var_17_64 then
				var_17_59.set_progression.text_color = var_17_59.set_progression.progression_colors.complete
			end
		end

		var_17_4.content.is_part_of_set = var_17_62
		var_17_8 = 160
	elseif var_17_2 == "loot_chest" then
		local var_17_71 = ItemMasterList[var_17_1].inventory_icon

		var_17_4.content.texture_id = var_17_71
		var_17_8 = 0
	end

	return var_17_4, var_17_3 and 0 or var_17_8
end

function RewardPopupUI._setup_presentation(arg_18_0, arg_18_1)
	local var_18_0 = #arg_18_1
	local var_18_1 = {}
	local var_18_2 = {
		end_animation = "close",
		start_animation = "open",
		started = false,
		animations_played = 0,
		entry_play_index = 1,
		amount = var_18_0,
		entries = var_18_1
	}
	local var_18_3 = arg_18_1.animation_data or {}

	for iter_18_0, iter_18_1 in pairs(var_18_3) do
		var_18_2[iter_18_0] = iter_18_1
	end

	local var_18_4 = var_18_3.animation_wait_time or var_18_2.claim_button and 0 or 2
	local var_18_5 = 20
	local var_18_6 = 80

	arg_18_0._skip_blur = arg_18_1.skip_blur
	arg_18_0._bg_alpha = arg_18_1.bg_alpha or 100

	for iter_18_2 = 1, #arg_18_1 do
		local var_18_7 = arg_18_1[iter_18_2]
		local var_18_8 = {}
		local var_18_9 = {
			enter_animation = "entry_enter",
			exit_animation = "entry_exit",
			index = iter_18_2,
			widgets_data = var_18_8,
			animation_wait_time = var_18_4
		}
		local var_18_10 = 0

		for iter_18_3 = 1, #var_18_7 do
			local var_18_11 = var_18_7[iter_18_3]
			local var_18_12, var_18_13 = arg_18_0:_setup_entry_widget(var_18_11, iter_18_3)

			var_18_8[iter_18_3] = {
				alpha_multiplier = 0,
				widget = var_18_12,
				height = var_18_13,
				value = var_18_11.value,
				widget_type = var_18_11.widget_type
			}

			if var_18_10 < var_18_13 then
				var_18_10 = var_18_13
			end
		end

		var_18_9.highest_height = var_18_10
		var_18_1[iter_18_2] = var_18_9

		if var_18_6 < var_18_10 then
			var_18_6 = var_18_10
		end
	end

	var_0_1.background_center.size[2] = var_18_6 + var_18_5
	arg_18_0._ui_scenegraph.background.local_position = arg_18_1.offset or {
		0,
		0,
		1
	}

	return var_18_2
end

function RewardPopupUI._align_entry_widgets(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0._ui_scenegraph
	local var_19_1 = arg_19_1.widgets_data

	for iter_19_0 = 1, #var_19_1 do
		var_19_0[var_19_1[iter_19_0].widget.scenegraph_id].local_position[2] = 0
	end
end

function RewardPopupUI._play_animation(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	local var_20_0 = arg_20_2 .. "_key"
	local var_20_1 = arg_20_1[var_20_0]

	if not var_20_1 then
		arg_20_1[var_20_0] = arg_20_0:start_presentation_animation(arg_20_1[arg_20_2], arg_20_3)

		return true
	elseif arg_20_0._animations[var_20_1] then
		return true
	end
end

function RewardPopupUI._update_presentation_animation(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0._animation_presentation_data

	if not var_21_0 or var_21_0.complete then
		return
	end

	if arg_21_0:_play_animation(var_21_0, "start_animation") then
		return
	end

	local var_21_1 = var_21_0.entry_play_index
	local var_21_2 = var_21_0.entries
	local var_21_3 = var_21_2[var_21_1]

	if not var_21_3.aligned then
		arg_21_0:_align_entry_widgets(var_21_3)

		var_21_3.aligned = true
	end

	if arg_21_0:_play_animation(var_21_3, "enter_animation", var_21_3.widgets_data) then
		return
	end

	if var_21_0.claim_button then
		arg_21_0._handling_claim_button = true

		if not var_21_3.claimed then
			return arg_21_0:_handle_input(var_21_3)
		end

		arg_21_0._handling_claim_button = false
	end

	if not arg_21_0._done_reset_speed_up_popup then
		arg_21_0._done_reset_speed_up_popup = true
		arg_21_0._speed_up_popup = false
	end

	local var_21_4 = var_21_3.animation_wait_time

	if var_21_4 then
		local var_21_5 = var_21_4 - arg_21_1

		if var_21_5 > 0 then
			var_21_3.animation_wait_time = var_21_5
		else
			var_21_3.animation_wait_time = nil
		end

		return
	end

	if arg_21_0:_play_animation(var_21_3, "exit_animation", var_21_3.widgets_data) then
		return
	elseif var_21_1 < #var_21_2 then
		var_21_0.entry_play_index = var_21_1 + 1

		return
	end

	if arg_21_0:_play_animation(var_21_0, "end_animation") then
		return
	end

	var_21_0.complete = true

	arg_21_0:on_presentation_complete()
end

function RewardPopupUI._handle_input(arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0:input_service()

	arg_22_1.claimed = arg_22_1.claimed or var_22_0:get("skip_pressed", true) or var_22_0:get("confirm_press", true) or UIUtils.is_button_pressed(arg_22_0.claim_button_widget)

	local var_22_1 = table.find_by_key(arg_22_1.widgets_data, "widget_type", "item_list")

	if not var_22_1 then
		return
	end

	local var_22_2 = arg_22_1.widgets_data[var_22_1].widget
	local var_22_3 = var_22_2.content
	local var_22_4 = false
	local var_22_5 = var_22_3.cursor_x
	local var_22_6 = var_22_3.cursor_y
	local var_22_7 = var_0_0.item_list_max_columns
	local var_22_8 = var_22_3.rows
	local var_22_9 = var_22_3.item_count % var_22_7

	if var_22_9 == 0 then
		var_22_9 = var_22_7
	end

	if var_22_6 < var_22_8 and var_22_0:get("move_down") then
		var_22_6 = var_22_6 + 1
		var_22_4 = true

		if var_22_6 == var_22_8 then
			var_22_5 = math.clamp(var_22_5 - math.floor(0.5 * (var_22_7 - var_22_9)), 1, var_22_9)
		end
	elseif var_22_6 > 1 and var_22_0:get("move_up") then
		if var_22_6 == var_22_8 then
			var_22_5 = var_22_5 + math.floor(0.5 * (var_22_7 - var_22_9))
		end

		var_22_6 = var_22_6 - 1
		var_22_4 = true
	end

	if var_22_5 > 1 and var_22_0:get("move_left") then
		var_22_5 = var_22_5 - 1
		var_22_4 = true
	elseif var_22_5 < (var_22_6 == var_22_8 and var_22_9 or var_22_7) and var_22_0:get("move_right") then
		var_22_5 = var_22_5 + 1
		var_22_4 = true
	end

	if var_22_4 then
		var_22_3.cursor_x = var_22_5
		var_22_3.cursor_y = var_22_6

		local var_22_10 = 1 + (var_22_5 - 1) + (var_22_6 - 1) * var_22_7

		var_22_3.selected_i = var_22_10

		local var_22_11 = var_22_2.style["icon" .. var_22_10].offset

		var_0_8(var_22_2.style.cursor, var_22_11[1], var_22_11[2])
	elseif var_22_0:get("right_stick_press") then
		if var_22_3.selected_i then
			var_22_3.selected_i = nil
		else
			var_22_3.selected_i = 1 + (var_22_5 - 1) + (var_22_6 - 1) * var_22_7
		end
	end

	return true
end

function RewardPopupUI.set_fullscreen_effect_enable_state(arg_23_0, arg_23_1, arg_23_2)
	if arg_23_0._skip_blur then
		return
	end

	local var_23_0 = arg_23_0.world
	local var_23_1 = World.get_data(var_23_0, "shading_environment")

	arg_23_2 = arg_23_2 or arg_23_1 and 1 or 0

	if var_23_1 then
		ShadingEnvironment.set_scalar(var_23_1, "fullscreen_blur_enabled", arg_23_1 and 1 or 0)
		ShadingEnvironment.set_scalar(var_23_1, "fullscreen_blur_amount", arg_23_1 and arg_23_2 * 0.75 or 0)
		ShadingEnvironment.apply(var_23_1)

		arg_23_0.screen_background_widget.style.rect.color[1] = arg_23_0._bg_alpha * arg_23_2
	end

	arg_23_0._fullscreen_effect_enabled = arg_23_1
end

function RewardPopupUI._setup_input(arg_24_0)
	local var_24_0 = arg_24_0._input_manager

	if var_24_0 and not arg_24_0._input_set_up then
		var_24_0:create_input_service(var_0_6, "IngameMenuKeymaps", "IngameMenuFilters")
		var_24_0:map_device_to_service(var_0_6, "keyboard")
		var_24_0:map_device_to_service(var_0_6, "mouse")
		var_24_0:map_device_to_service(var_0_6, "gamepad")

		arg_24_0._input_set_up = true
	end
end

function RewardPopupUI._acquire_input(arg_25_0)
	if not arg_25_0.input_acquired then
		local var_25_0 = arg_25_0._input_manager

		if var_25_0 and arg_25_0._input_set_up then
			var_25_0:capture_input(ALL_INPUT_METHODS, 1, var_0_6, "RewardPopupUI")

			if arg_25_0._animation_presentation_data.claim_button then
				ShowCursorStack.show("RewardPopupUI")

				arg_25_0._cursor_shown = true

				local var_25_1 = var_25_0:get_service(var_0_6)

				arg_25_0._menu_input_description = MenuInputDescriptionUI:new(nil, arg_25_0._ui_top_renderer, var_25_1, 5, 900, var_0_0.generic_input_actions.default)

				arg_25_0._menu_input_description:set_input_description(nil)
			end
		end

		arg_25_0.input_acquired = true
	end
end

function RewardPopupUI._release_input(arg_26_0)
	if arg_26_0.input_acquired then
		local var_26_0 = arg_26_0._input_manager

		if var_26_0 and arg_26_0._input_set_up then
			var_26_0:release_input(ALL_INPUT_METHODS, 1, var_0_6, "RewardPopupUI")

			arg_26_0._menu_input_description = nil
		end

		arg_26_0.input_acquired = false
	end

	if arg_26_0._cursor_shown then
		ShowCursorStack.hide("RewardPopupUI")

		arg_26_0._cursor_shown = false
	end
end

function RewardPopupUI.input_service(arg_27_0)
	if arg_27_0._input_set_up and arg_27_0.input_acquired then
		return arg_27_0._input_manager:get_service(var_0_6)
	else
		return FAKE_INPUT_SERVICE
	end
end
