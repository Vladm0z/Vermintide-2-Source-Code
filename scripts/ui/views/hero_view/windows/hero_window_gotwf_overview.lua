-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_gotwf_overview.lua

require("scripts/ui/reward_popup/reward_popup_ui")

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_gotwf_overview_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.widgets
local var_0_3 = var_0_0.lock_widgets
local var_0_4 = var_0_0.bottom_widgets
local var_0_5 = var_0_0.background_widgets
local var_0_6 = var_0_0.viewport_widgets
local var_0_7 = var_0_0.create_item_definition_func
local var_0_8 = var_0_0.create_simple_item
local var_0_9 = var_0_0.create_claim_button
local var_0_10 = var_0_0.animation_definitions
local var_0_11 = var_0_0.gotwf_item_size
local var_0_12 = var_0_0.icon_scale
local var_0_13 = var_0_0.generic_input_actions
local var_0_14 = "gui/1080p/single_textures/generic/transparent_placeholder_texture"
local var_0_15 = 7
local var_0_16 = {
	260 * var_0_12,
	220 * var_0_12
}
local var_0_17 = {
	common = "store_thumbnail_bg_common",
	promo = "store_thumbnail_bg_promo",
	plentiful = "store_thumbnail_bg_plentiful",
	rare = "store_thumbnail_bg_rare",
	exotic = "store_thumbnail_bg_exotic",
	magic = "store_thumbnail_bg_magic",
	unique = "store_thumbnail_bg_unique"
}

HeroWindowGotwfOverview = class(HeroWindowGotwfOverview)
HeroWindowGotwfOverview.NAME = "HeroWindowGotwfOverview"

function HeroWindowGotwfOverview.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate HeroWindowGotwfOverview")

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._params = arg_1_1
	arg_1_0._parent = arg_1_1.parent
	arg_1_0._ui_renderer = var_1_0.ui_renderer
	arg_1_0._ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0._wwise_world = arg_1_1.wwise_world
	arg_1_0._render_settings = {
		snap_pixel_positions = false
	}
	arg_1_0._gamepad_was_active = false
	arg_1_0._steps = 0
	arg_1_0._hold_left_timer = 0
	arg_1_0._hold_right_timer = 0
	arg_1_0._ready = false
	arg_1_0._loaded_package_names = {}
	arg_1_0._cloned_materials_by_reference = {}
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}
	arg_1_0._ui_animations_callbacks = {}

	arg_1_0:_reset_current_item()
	arg_1_0:_init_scenegraph()
	arg_1_0:_create_background_ui_elements()
	arg_1_0:_sync_backend_gotwf()

	local var_1_1 = true

	arg_1_0._parent:change_generic_actions(var_0_13.default, var_1_1)
	arg_1_0:_play_sound("Play_amb_gotwf_loop")
end

function HeroWindowGotwfOverview._reset_current_item(arg_2_0)
	arg_2_0._params.selected_item = nil
	arg_2_0._params.selected_item_index = nil
	arg_2_0._params.selected_item_claimed = nil
	arg_2_0._params.selected_item_already_owned = nil
end

function HeroWindowGotwfOverview._sync_backend_gotwf(arg_3_0)
	arg_3_0._synced = false

	Managers.backend:get_interface("peddler"):refresh_login_rewards(callback(arg_3_0, "gotwf_data_cb"))
end

function HeroWindowGotwfOverview.gotwf_data_cb(arg_4_0, arg_4_1)
	arg_4_0._login_rewards = arg_4_1

	if arg_4_1.event_type ~= "calendar" then
		arg_4_0._popup_id = Managers.popup:queue_popup(Localize("event_gotfw_available_soon"), Localize("event_gotfw_name"), "go_back", Localize("menu_ok"))

		return
	end

	arg_4_0._synced = true
end

function HeroWindowGotwfOverview._start_transition_animation(arg_5_0, arg_5_1)
	local var_5_0 = {
		parent = arg_5_0._parent,
		render_settings = arg_5_0._render_settings,
		num_items = arg_5_0._login_rewards.total_rewards
	}
	local var_5_1 = arg_5_0._widgets_by_name
	local var_5_2 = arg_5_0._ui_animator:start_animation(arg_5_1, var_5_1, var_0_1, var_5_0)

	arg_5_0._animations[arg_5_1] = var_5_2
end

function HeroWindowGotwfOverview._start_item_rotation_animation(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = {
		parent = arg_6_0._parent,
		render_settings = arg_6_0._render_settings,
		item_widget = arg_6_1,
		reward_index = arg_6_2
	}
	local var_6_1 = "item_rotation"
	local var_6_2 = arg_6_0._widgets_by_name
	local var_6_3 = arg_6_0._ui_animator:start_animation(var_6_1, var_6_2, var_0_1, var_6_0)

	arg_6_0._animations[var_6_1] = var_6_3

	arg_6_0._parent:block_input()

	arg_6_0._ui_animations_callbacks[var_6_1] = function()
		arg_6_0._parent:unblock_input()
	end
end

function HeroWindowGotwfOverview._init_scenegraph(arg_8_0)
	arg_8_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)
end

function HeroWindowGotwfOverview._create_background_ui_elements(arg_9_0, arg_9_1)
	local var_9_0 = {}
	local var_9_1 = {}

	for iter_9_0, iter_9_1 in pairs(var_0_5) do
		local var_9_2 = UIWidget.init(iter_9_1)

		var_9_1[iter_9_0] = var_9_2
		var_9_0[#var_9_0 + 1] = var_9_2
	end

	arg_9_0._background_widgets = var_9_0
	arg_9_0._widgets_by_name = var_9_1
end

function HeroWindowGotwfOverview._create_ui_elements(arg_10_0, arg_10_1)
	local var_10_0 = {}
	local var_10_1 = {}
	local var_10_2 = {}
	local var_10_3 = {}
	local var_10_4 = {}
	local var_10_5 = {}
	local var_10_6 = {}
	local var_10_7 = {}

	arg_10_0._item_texture_widgets = {}

	for iter_10_0, iter_10_1 in pairs(var_0_2) do
		local var_10_8 = UIWidget.init(iter_10_1)

		var_10_0[#var_10_0 + 1] = var_10_8
		var_10_7[iter_10_0] = var_10_8
	end

	for iter_10_2, iter_10_3 in pairs(var_0_4) do
		local var_10_9 = UIWidget.init(iter_10_3)

		var_10_4[#var_10_4 + 1] = var_10_9
		var_10_7[iter_10_2] = var_10_9
	end

	for iter_10_4, iter_10_5 in pairs(var_0_6) do
		local var_10_10 = UIWidget.init(iter_10_5)

		var_10_5[#var_10_5 + 1] = var_10_10
		var_10_7[iter_10_4] = var_10_10
	end

	for iter_10_6, iter_10_7 in pairs(var_0_3) do
		local var_10_11 = UIWidget.init(iter_10_7)

		var_10_1[#var_10_1 + 1] = var_10_11
		var_10_7[iter_10_6] = var_10_11
	end

	local var_10_12 = arg_10_0._login_rewards.total_rewards

	for iter_10_8 = 1, var_10_12 do
		local var_10_13 = arg_10_0:_create_reward_widget(iter_10_8)
		local var_10_14 = arg_10_0:_create_claim_button_widget(iter_10_8)

		var_10_3[#var_10_3 + 1] = var_10_13
		var_10_6[#var_10_6 + 1] = var_10_14
		var_10_7["claim_button_" .. iter_10_8] = var_10_14
	end

	arg_10_0._widgets = var_10_0
	arg_10_0._lock_widgets = var_10_1
	arg_10_0._bottom_widgets = var_10_4
	arg_10_0._item_widgets = var_10_3
	arg_10_0._widgets_by_name = var_10_7
	arg_10_0._claim_button_widgets = var_10_6
	arg_10_0._viewport_widgets = var_10_5

	arg_10_0:_select_current_reward()
	arg_10_0:_calculate_duration()
	arg_10_0:_update_claim_button_visibility()
	arg_10_0:_reset_current_item()
	arg_10_0:_create_scrollbar()
	arg_10_0:_create_ui_animator()
	arg_10_0:_create_reward_popup()
	UIRenderer.clear_scenegraph_queue(arg_10_0._ui_renderer)
end

function HeroWindowGotwfOverview._create_reward_popup(arg_11_0)
	local var_11_0 = {
		wwise_world = arg_11_0._wwise_world,
		ui_renderer = arg_11_0._ui_renderer,
		ui_top_renderer = arg_11_0._ui_top_renderer,
		input_manager = Managers.input
	}

	arg_11_0._reward_popup = RewardPopupUI:new(var_11_0)
end

function HeroWindowGotwfOverview._create_ui_animator(arg_12_0)
	arg_12_0._ui_animator = UIAnimator:new(arg_12_0._ui_scenegraph, var_0_10)
end

function HeroWindowGotwfOverview._create_scrollbar(arg_13_0)
	local var_13_0 = (#arg_13_0._item_widgets - var_0_15) * var_0_11[1]

	arg_13_0._scrollbar_ui = ScrollbarUI:new(arg_13_0._ui_scenegraph, "gotwf_item_anchor", "scrollbar_area", var_13_0, false, nil, true)
end

function HeroWindowGotwfOverview._select_current_reward(arg_14_0)
	local var_14_0 = #arg_14_0._login_rewards.rewards
	local var_14_1 = arg_14_0._item_widgets[var_14_0].content
	local var_14_2 = var_14_1.reward_order
	local var_14_3 = var_14_2[#var_14_2]

	var_14_1["hotspot_" .. var_14_3].is_selected = true
end

function HeroWindowGotwfOverview._calculate_duration(arg_15_0)
	local var_15_0 = arg_15_0._login_rewards
	local var_15_1 = var_15_0.start_time
	local var_15_2 = var_15_0.total_rewards
	local var_15_3 = var_15_0.start_time + 86400000 * (var_15_2 - 1)
	local var_15_4 = os.date("%x", var_15_1 * 0.001)
	local var_15_5 = os.date("%x", var_15_3 * 0.001)

	arg_15_0._widgets_by_name.gotwf_description.content.text = var_15_4 .. " - " .. var_15_5
end

function HeroWindowGotwfOverview._create_claim_button_widget(arg_16_0, arg_16_1)
	local var_16_0 = #arg_16_0._login_rewards.rewards
	local var_16_1 = var_0_9()
	local var_16_2 = UIWidget.init(var_16_1)

	var_16_2.offset[1] = (arg_16_1 - 1) * var_0_11[1]
	var_16_2.content.reward_offset = arg_16_1 - var_16_0

	return var_16_2
end

function HeroWindowGotwfOverview._create_reward_widget(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0._login_rewards.start_time
	local var_17_1 = arg_17_0._login_rewards.rewards
	local var_17_2 = #var_17_1
	local var_17_3 = arg_17_0._login_rewards.num_allowed_old_segments_to_claim
	local var_17_4 = math.max(var_17_2 - var_17_3, 1)
	local var_17_5 = arg_17_0._login_rewards.claimed_rewards[arg_17_1] > 0
	local var_17_6 = var_17_1[arg_17_1]
	local var_17_7 = os.date("%x", var_17_0 * 0.001 + 86400 * (arg_17_1 - 1))
	local var_17_8 = true
	local var_17_9 = arg_17_1
	local var_17_10 = arg_17_1 == var_17_2
	local var_17_11 = var_17_6 == nil or not var_17_5
	local var_17_12 = arg_17_1 < var_17_4
	local var_17_13 = not var_17_5 and not var_17_12 and arg_17_1 <= var_17_2
	local var_17_14 = var_0_7("gotwf_item_anchor", var_0_16, var_17_8, var_17_9, var_17_10, var_17_7, var_17_5, var_17_11 and not var_17_5, var_17_12, var_17_13, var_17_6)
	local var_17_15 = UIWidget.init(var_17_14)

	if var_17_6 and var_17_5 then
		arg_17_0:_populate_item_widget(var_17_15, arg_17_1, var_17_6)
	end

	return var_17_15
end

function HeroWindowGotwfOverview._update_claim_button_visibility(arg_18_0)
	local var_18_0 = #arg_18_0._login_rewards.rewards
	local var_18_1 = arg_18_0._login_rewards.claimed_rewards
	local var_18_2 = var_18_0 - arg_18_0._login_rewards.num_allowed_old_segments_to_claim

	for iter_18_0 = 1, #arg_18_0._claim_button_widgets do
		local var_18_3 = arg_18_0._claim_button_widgets[iter_18_0]
		local var_18_4 = var_18_0 + var_18_3.content.reward_offset

		if var_18_0 < var_18_4 or var_18_4 < var_18_2 or var_18_1[var_18_4] > 0 then
			var_18_3.content.visible = false
			var_18_3.content.button_hotspot.disable_button = true
		end
	end
end

function HeroWindowGotwfOverview._animate_list_entries(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0._parent
	local var_19_1 = arg_19_0._list_widgets
	local var_19_2 = Managers.input:is_device_active("mouse")
	local var_19_3 = true

	for iter_19_0, iter_19_1 in ipairs(arg_19_0._item_widgets) do
		local var_19_4 = iter_19_0 > arg_19_0._steps and iter_19_0 <= var_0_15 + arg_19_0._steps
		local var_19_5 = iter_19_1.content
		local var_19_6 = iter_19_1.style
		local var_19_7 = var_19_5.num_rewards

		for iter_19_2 = 1, var_19_7 do
			local var_19_8 = var_19_5["button_hotspot_" .. iter_19_2] or var_19_5["hotspot_" .. iter_19_2]

			if var_19_8.on_hover_enter then
				arg_19_0:_play_sound("Play_hud_store_button_hover")

				var_19_8.on_hover_enter = false
			end
		end

		var_19_5.is_gamepad_selected = iter_19_0 == (arg_19_0._current_item_index or 0) and not var_19_2

		arg_19_0:_animate_item_product(iter_19_1, arg_19_1, var_19_4)
	end
end

function HeroWindowGotwfOverview._animate_item_product(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	if arg_20_0._animations.item_rotation then
		return
	end

	local var_20_0 = arg_20_1.content
	local var_20_1 = arg_20_1.style
	local var_20_2 = var_20_0.num_rewards
	local var_20_3 = false

	for iter_20_0 = var_20_2, 1, -1 do
		local var_20_4 = var_20_0.reward_order[iter_20_0]
		local var_20_5 = var_20_0["button_hotspot_" .. var_20_4] or var_20_0["hotspot_" .. var_20_4]
		local var_20_6 = var_20_5.on_hover_enter
		local var_20_7 = var_20_5.is_hover

		if arg_20_3 ~= nil and not arg_20_3 or var_20_3 then
			var_20_7 = false
			var_20_6 = false
		end

		local var_20_8 = var_20_5.is_selected or var_20_0.is_gamepad_selected and iter_20_0 == var_20_2

		if not var_20_5.was_selected and var_20_8 then
			var_20_5.was_selected = true
		end

		var_20_3 = var_20_7 or var_20_3

		local var_20_9 = not var_20_8 and var_20_5.is_clicked and var_20_5.is_clicked == 0
		local var_20_10 = var_20_5.input_progress or 0
		local var_20_11 = var_20_5.hover_progress or 0
		local var_20_12 = var_20_5.pulse_progress or 1
		local var_20_13 = var_20_5.selection_progress or 0
		local var_20_14 = (var_20_7 or var_20_8) and 14 or 3
		local var_20_15 = 3
		local var_20_16 = 20

		if var_20_9 then
			var_20_10 = math.min(var_20_10 + arg_20_2 * var_20_16, 1)
		else
			var_20_10 = math.max(var_20_10 - arg_20_2 * var_20_16, 0)
		end

		local var_20_17 = math.easeOutCubic(var_20_10)
		local var_20_18 = math.easeInCubic(var_20_10)

		if var_20_6 then
			var_20_12 = 0
		end

		local var_20_19 = math.min(var_20_12 + arg_20_2 * var_20_15, 1)
		local var_20_20 = math.easeOutCubic(var_20_19)
		local var_20_21 = math.easeInCubic(var_20_19)

		if var_20_7 then
			var_20_11 = math.min(var_20_11 + arg_20_2 * var_20_14, 1)
		else
			var_20_11 = math.max(var_20_11 - arg_20_2 * var_20_14, 0)
		end

		local var_20_22 = math.easeOutCubic(var_20_11)
		local var_20_23 = math.easeInCubic(var_20_11)

		if var_20_8 then
			var_20_13 = math.min(var_20_13 + arg_20_2 * var_20_14, 1)
		else
			var_20_13 = math.max(var_20_13 - arg_20_2 * var_20_14, 0)
		end

		local var_20_24 = math.easeOutCubic(var_20_13)
		local var_20_25 = math.easeInCubic(var_20_13)
		local var_20_26 = math.max(var_20_11, var_20_13)
		local var_20_27 = math.max(var_20_24, var_20_22)
		local var_20_28 = math.max(var_20_23, var_20_25)
		local var_20_29 = 255 * var_20_26

		var_20_1["hover_frame_" .. var_20_4].color[1] = var_20_29

		local var_20_30 = var_20_1["overlay_" .. var_20_4]

		if var_20_30 then
			local var_20_31 = 80 - 80 * var_20_26

			var_20_30.color[1] = var_20_31
		end

		local var_20_32 = 255 - 255 * var_20_19

		var_20_1["pulse_frame_" .. var_20_4].color[1] = var_20_32
		var_20_5.pulse_progress = var_20_19
		var_20_5.hover_progress = var_20_11
		var_20_5.input_progress = var_20_10
		var_20_5.selection_progress = var_20_13
	end
end

function HeroWindowGotwfOverview._populate_painting_data(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	local var_21_0 = arg_21_3.item_id
	local var_21_1 = Paintings[var_21_0]

	if not var_21_1 or var_21_0 == "hidden" then
		return
	end

	local var_21_2 = arg_21_0._ui_top_renderer.gui
	local var_21_3 = arg_21_1.content
	local var_21_4 = arg_21_1.style
	local var_21_5
	local var_21_6 = "keep_painting_" .. var_21_0
	local var_21_7 = string.find(var_21_0, "_none") ~= nil

	if not var_21_7 then
		var_21_5 = "resource_packages/keep_paintings/" .. var_21_6
	end

	arg_21_0._reference_id = (arg_21_0._reference_id or 0) + 1

	local var_21_8 = var_21_0 .. "_" .. arg_21_0._reference_id .. "_" .. arg_21_4
	local var_21_9 = "keep_painting_" .. var_21_0
	local var_21_10 = "template_store_diffuse_masked"

	arg_21_0:_create_material_instance(var_21_2, var_21_9, var_21_10, var_21_8)

	local function var_21_11()
		local var_22_0 = "units/gameplay/keep_paintings/materials/" .. var_21_6 .. "/" .. var_21_6 .. "_df"

		arg_21_0:_set_material_diffuse(var_21_2, var_21_9, var_22_0)

		local var_22_1 = 150 * var_0_12
		local var_22_2 = 0.125

		if var_21_1.orientation == "horizontal" then
			var_21_3["painting_" .. arg_21_4] = {
				texture_id = var_21_9,
				uvs = {
					{
						0,
						var_22_2
					},
					{
						1,
						1 - var_22_2
					}
				}
			}
			var_21_4["painting_" .. arg_21_4].offset[2] = 20
			var_21_4["painting_" .. arg_21_4].texture_size = {
				var_22_1,
				var_22_1 * (1 - 2 * var_22_2)
			}
			var_21_4["painting_frame_" .. arg_21_4].area_size = {
				var_22_1,
				var_22_1 * (1 - 2 * var_22_2)
			}
			var_21_4["painting_frame_" .. arg_21_4].offset[2] = 20
		else
			var_21_3["painting_" .. arg_21_4] = {
				texture_id = var_21_9,
				uvs = {
					{
						var_22_2,
						0
					},
					{
						1 - var_22_2,
						1
					}
				}
			}
			var_21_4["painting_" .. arg_21_4].offset[2] = 10
			var_21_4["painting_" .. arg_21_4].texture_size = {
				var_22_1 * (1 - 2 * var_22_2),
				var_22_1
			}
			var_21_4["painting_frame_" .. arg_21_4].area_size = {
				var_22_1 * (1 - 2 * var_22_2),
				var_22_1
			}
			var_21_4["painting_frame_" .. arg_21_4].offset[2] = 10
		end

		var_21_3.disable_loading_icon = true
	end

	if var_21_7 then
		var_21_11()
	else
		arg_21_0:_load_texture_package(var_21_5, var_21_8, var_21_11)
	end
end

function HeroWindowGotwfOverview._populate_item_widget(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	local var_23_0 = arg_23_0:_get_reward_item_from_bundle(arg_23_3)

	if var_23_0 then
		if var_23_0.reward_type == "keep_decoration_painting" then
			arg_23_0:_populate_painting_data(arg_23_1, arg_23_2, var_23_0, 1)
		else
			arg_23_0:_populate_item_data(arg_23_1, arg_23_2, var_23_0, 1)
		end
	else
		for iter_23_0 = #arg_23_3, 1, -1 do
			local var_23_1 = arg_23_3[iter_23_0]

			if var_23_1.reward_type == "keep_decoration_painting" then
				arg_23_0:_populate_painting_data(arg_23_1, arg_23_2, var_23_1, iter_23_0)
			else
				arg_23_0:_populate_item_data(arg_23_1, arg_23_2, var_23_1, iter_23_0)
			end
		end
	end
end

function HeroWindowGotwfOverview._populate_item_data(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	local var_24_0 = UISettings.item_rarity_textures
	local var_24_1 = UISettings.item_type_store_icons
	local var_24_2 = arg_24_3.item_id
	local var_24_3 = arg_24_3.reward_type
	local var_24_4

	if var_24_3 == "chips" then
		var_24_4 = Currencies[var_24_2]
	elseif var_24_3 == "currency" then
		var_24_4, var_24_2 = BackendUtils.get_fake_currency_item(arg_24_3.currency_code, arg_24_3.amount)
	else
		var_24_4 = ItemMasterList[var_24_2]
	end

	if not var_24_4 then
		return
	end

	local var_24_5 = var_24_4.rarity or "default"
	local var_24_6 = var_24_4.item_type
	local var_24_7 = arg_24_1.content
	local var_24_8 = arg_24_1.style
	local var_24_9 = var_24_8["icon_" .. arg_24_4].masked

	var_24_7["item_" .. arg_24_4] = var_24_4

	local var_24_10 = var_0_17[var_24_5]

	var_24_7["background_" .. arg_24_4] = var_24_10

	local var_24_11 = var_24_8["overlay_" .. arg_24_4].offset[3]
	local var_24_12 = var_24_8["icon_" .. arg_24_4].offset[3]

	var_24_8["icon_" .. arg_24_4].offset[3] = var_24_11
	var_24_8["overlay_" .. arg_24_4].offset[3] = var_24_12

	local var_24_13 = var_24_1[var_24_6]

	if var_24_5 and var_24_13 then
		var_24_7["type_tag_icon_" .. arg_24_4] = var_24_13 .. "_" .. (var_24_5 == "plentiful" and "common" or var_24_5)
	else
		var_24_7["type_tag_icon_" .. arg_24_4] = var_24_13
	end

	local var_24_14 = arg_24_0._ui_top_renderer.gui

	arg_24_0._reference_id = (arg_24_0._reference_id or 0) + 1

	local var_24_15 = var_24_2 .. "_" .. arg_24_0._reference_id .. "_" .. arg_24_4

	if var_24_6 == "chips" then
		var_24_2 = "shillings_medium"
	elseif var_24_6 == "versus_currency_name" then
		var_24_2 = "versus_currency_small"
	elseif var_24_6 == "loot_chest" then
		var_24_2 = "loot_chest_generic"
	end

	local var_24_16 = var_24_4.store_icon_override_key
	local var_24_17 = "store_item_icon_" .. (var_24_16 or var_24_2)
	local var_24_18 = "resource_packages/store/item_icons/" .. var_24_17

	if var_24_6 == "frame" then
		var_24_7.disable_loading_icon = true

		local var_24_19 = "gotwf_item_anchor"
		local var_24_20 = var_24_4.temporary_template or "default"
		local var_24_21 = 1
		local var_24_22 = 20
		local var_24_23 = {
			10 + (arg_24_2 - 1) * (var_0_16[1] + var_24_22),
			20,
			0
		}
		local var_24_24 = true
		local var_24_25 = true
		local var_24_26 = UIWidgets.create_base_portrait_frame(var_24_19, var_24_20, var_24_21, var_24_23, var_24_24, var_24_25)

		arg_24_0._item_texture_widgets[#arg_24_0._item_texture_widgets + 1] = UIWidget.init(var_24_26)

		local var_24_27 = Gui.material(arg_24_0._ui_top_renderer.gui, "portrait_frame_gotwf_01_child")

		if var_24_27 then
			Material.set_scalar(var_24_27, "masked", 1)
		end
	elseif Application.can_get("package", var_24_18) then
		var_24_7["reference_name_" .. arg_24_4] = var_24_15
		var_24_7["icon_" .. arg_24_4] = nil

		local var_24_28 = var_24_9 and var_24_17 .. "_masked" or var_24_17
		local var_24_29 = var_24_9 and "template_store_diffuse_masked" or "template_store_diffuse"

		arg_24_0:_create_material_instance(var_24_14, var_24_28, var_24_29, var_24_15)

		local function var_24_30()
			local var_25_0 = "gui/1080p/single_textures/store_item_icons/" .. var_24_17 .. "/" .. var_24_17

			arg_24_0:_set_material_diffuse(var_24_14, var_24_28, var_25_0)

			var_24_7["icon_" .. arg_24_4] = var_24_28
		end

		arg_24_0:_load_texture_package(var_24_18, var_24_15, var_24_30)
	else
		Application.warning("Icon package not accessable for product_id: (%s) and texture_name: (%s)", var_24_2, var_24_17)
	end
end

function HeroWindowGotwfOverview._create_material_instance(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	arg_26_0._cloned_materials_by_reference[arg_26_4] = arg_26_2

	return Gui.clone_material_from_template(arg_26_1, arg_26_2, arg_26_3)
end

function HeroWindowGotwfOverview._set_material_diffuse(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	local var_27_0 = Gui.material(arg_27_1, arg_27_2)

	if var_27_0 then
		Material.set_texture(var_27_0, "diffuse_map", arg_27_3)
	end
end

function HeroWindowGotwfOverview._load_texture_package(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	local var_28_0 = true
	local var_28_1 = false

	Managers.package:load(arg_28_1, arg_28_2, arg_28_3, var_28_0, var_28_1)

	arg_28_0._loaded_package_names[arg_28_2] = arg_28_1
end

function HeroWindowGotwfOverview._is_unique_reference_to_material(arg_29_0, arg_29_1)
	local var_29_0 = arg_29_0._cloned_materials_by_reference
	local var_29_1 = var_29_0[arg_29_1]

	fassert(var_29_1, "[HeroWindowGotwfOverview] - Could not find a used material for reference name: (%s)", arg_29_1)

	for iter_29_0, iter_29_1 in pairs(var_29_0) do
		if var_29_1 == iter_29_1 and arg_29_1 ~= iter_29_0 then
			return false
		end
	end

	return true
end

function HeroWindowGotwfOverview._unload_texture_by_reference(arg_30_0, arg_30_1)
	local var_30_0 = arg_30_0._loaded_package_names
	local var_30_1 = arg_30_0._cloned_materials_by_reference
	local var_30_2 = var_30_0[arg_30_1]

	fassert(var_30_2, "[HeroWindowGotwfOverview] - Could not find a package to unload for reference name: (%s)", arg_30_1)
	Managers.package:unload(var_30_2, arg_30_1)

	var_30_0[arg_30_1] = nil

	if arg_30_0:_is_unique_reference_to_material(arg_30_1) then
		local var_30_3 = var_30_1[arg_30_1]
		local var_30_4 = arg_30_0._ui_top_renderer.gui

		arg_30_0:_set_material_diffuse(var_30_4, var_30_3, var_0_14)
	end

	var_30_1[arg_30_1] = nil
end

function HeroWindowGotwfOverview._play_sound(arg_31_0, arg_31_1)
	arg_31_0._parent:play_sound(arg_31_1)
end

function HeroWindowGotwfOverview.on_exit(arg_32_0, arg_32_1)
	print("[HeroViewWindow] Exit Substate HeroWindowGotwfOverview")

	arg_32_0._ui_animator = nil

	local var_32_0 = arg_32_0._loaded_package_names

	for iter_32_0, iter_32_1 in pairs(var_32_0) do
		arg_32_0:_unload_texture_by_reference(iter_32_0)
	end

	if arg_32_0._reward_popup then
		arg_32_0._reward_popup:destroy()

		arg_32_0._reward_popup = nil
	end

	arg_32_0:_play_sound("Stop_amb_gotwf_loop")
end

function HeroWindowGotwfOverview.update(arg_33_0, arg_33_1, arg_33_2)
	if arg_33_0._ready then
		arg_33_0:_handle_reward_popup(arg_33_1, arg_33_2)
		arg_33_0:_update_animations(arg_33_1)
		arg_33_0:_draw(arg_33_1, arg_33_2)
	else
		arg_33_0:_check_ready()
	end

	arg_33_0:_handle_popup()
	arg_33_0:_draw_background(arg_33_1, arg_33_2)
end

function HeroWindowGotwfOverview._handle_reward_popup(arg_34_0, arg_34_1, arg_34_2)
	arg_34_0._reward_popup:update(arg_34_1)
end

function HeroWindowGotwfOverview._check_ready(arg_35_0)
	if arg_35_0._params.loading_package or not arg_35_0._synced then
		return
	end

	arg_35_0._ready = true

	arg_35_0:_create_ui_elements(arg_35_0._params)
	arg_35_0:_start_transition_animation("on_enter")
end

function HeroWindowGotwfOverview._handle_popup(arg_36_0)
	local var_36_0 = arg_36_0._popup_id

	if not var_36_0 then
		return
	end

	if Managers.popup:query_result(var_36_0) then
		arg_36_0._parent:set_layout_by_name("featured")
	end
end

function HeroWindowGotwfOverview._claim_daily_reward(arg_37_0, arg_37_1)
	if arg_37_0._login_rewards.num_allowed_old_segments_to_claim < math.abs(arg_37_1) or arg_37_1 > 0 then
		return
	end

	local var_37_0 = Managers.backend:get_interface("peddler")
	local var_37_1 = #arg_37_0._login_rewards.rewards + (arg_37_1 or 0)

	if arg_37_0._login_rewards.claimed_rewards[var_37_1] > 0 then
		return
	end

	var_37_0:claim_login_rewards(callback(arg_37_0, "_claim_reward_result_cb", var_37_1), arg_37_1)

	arg_37_0._force_index = #arg_37_0._login_rewards.rewards + (arg_37_1 or 0)
	arg_37_0._awaiting_result = true

	arg_37_0._parent:block_input()
	arg_37_0:_play_sound("Play_hud_gotwf_claim")
end

function HeroWindowGotwfOverview._claim_reward_result_cb(arg_38_0, arg_38_1, arg_38_2)
	if not arg_38_0._ui_animator then
		return
	end

	if arg_38_2.event_type ~= "calendar" then
		arg_38_0._awaiting_result = false

		arg_38_0._parent:unblock_input()
		Managers.ui:handle_transition("close_active", {
			fade_out_speed = 1,
			use_fade = true,
			fade_in_speed = 1
		})

		return
	end

	arg_38_0._login_rewards = arg_38_2

	local var_38_0 = arg_38_0._login_rewards.rewards[arg_38_1]

	if (var_38_0 and #var_38_0 or 0) == 0 then
		arg_38_0._awaiting_result = false

		arg_38_0._parent:unblock_input()

		return
	end

	arg_38_0._replacement_presentation_data = arg_38_0:_gather_replacement_presentation_data(arg_38_1)
	arg_38_0._item_widgets[arg_38_1].content.visible = false

	arg_38_0:_update_claim_button_visibility()
	arg_38_0:_reset_current_item()
	arg_38_0:_start_transition_animation("hide_item_list")
	arg_38_0:_start_transition_animation("lock_open")

	arg_38_0._ui_animations_callbacks.lock_open = callback(arg_38_0, "_start_transition_animation", "lock_close")
	arg_38_0._ui_animations_callbacks.lock_close = callback(arg_38_0, "_start_transition_animation", "reveal")

	function arg_38_0._ui_animations_callbacks.reveal()
		arg_38_0:_update_daily_rewards(arg_38_1)
		arg_38_0:_start_transition_animation("show_item_list")
		arg_38_0:_trigger_replacement_rewards()
	end

	Managers.backend:commit()
	arg_38_0:_play_sound("Play_hud_gotwf_animation_start")
end

function HeroWindowGotwfOverview._trigger_replacement_rewards(arg_40_0)
	if not arg_40_0._replacement_presentation_data then
		return
	end

	arg_40_0._reward_popup:display_presentation(arg_40_0._replacement_presentation_data)

	arg_40_0._replacement_presentation_data = nil
end

local var_0_18 = {}

function HeroWindowGotwfOverview._gather_replacement_presentation_data(arg_41_0, arg_41_1)
	if arg_41_0._login_rewards.claimed_rewards[arg_41_1] < 2 then
		return
	end

	table.clear(var_0_18)

	local var_41_0 = arg_41_0._login_rewards.currency_added[1]

	if not var_41_0 then
		return
	end

	local var_41_1, var_41_2, var_41_3 = BackendUtils.get_fake_currency_item(var_41_0.code or "SM", var_41_0.amount)
	local var_41_4 = {
		data = var_41_1
	}
	local var_41_5 = {}
	local var_41_6, var_41_7, var_41_8 = UIUtils.get_ui_information_from_item(var_41_4)

	var_41_5[1] = Localize(var_41_7)
	var_41_5[2] = string.format(Localize(var_41_3), var_41_0.amount)

	local var_41_9 = {}

	var_41_9[#var_41_9 + 1] = {
		widget_type = "description",
		value = var_41_5
	}
	var_41_9[#var_41_9 + 1] = {
		widget_type = "icon",
		value = var_41_4.data.icon
	}
	var_0_18[#var_0_18 + 1] = var_41_9
	var_0_18.bg_alpha = 200
	var_0_18.offset = {
		0,
		190,
		1
	}

	return var_0_18
end

function HeroWindowGotwfOverview._update_daily_rewards(arg_42_0, arg_42_1)
	local var_42_0 = arg_42_0:_create_reward_widget(arg_42_1)

	arg_42_0._item_widgets[arg_42_1] = var_42_0

	arg_42_0:_select_current_reward(arg_42_0._current_item_index)
	arg_42_0:_update_selected_reward(var_42_0)
	arg_42_0:_update_claim_button_visibility()

	arg_42_0._awaiting_result = false

	arg_42_0._parent:unblock_input()
end

function HeroWindowGotwfOverview._update_selected_reward(arg_43_0, arg_43_1)
	local var_43_0 = arg_43_0._login_rewards
	local var_43_1 = var_43_0.rewards
	local var_43_2 = var_43_0.claimed_rewards
	local var_43_3 = arg_43_1.content
	local var_43_4 = var_43_3.reward_order
	local var_43_5 = var_43_4[#var_43_4]

	var_43_3["hotspot_" .. var_43_5].is_selected = true

	local var_43_6 = var_43_1[arg_43_0._current_item_index]
	local var_43_7 = arg_43_0:_get_reward_item_from_bundle(var_43_6) or var_43_6[math.min(var_43_5, #var_43_6)]
	local var_43_8 = var_43_2[arg_43_0._current_item_index]
	local var_43_9 = var_43_8 > 0
	local var_43_10 = var_43_8 > 1

	arg_43_0._params.selected_item = var_43_9 and var_43_7
	arg_43_0._params.selected_item_index = var_43_9 and arg_43_0._current_item_index
	arg_43_0._params.selected_item_claimed = var_43_9
	arg_43_0._params.selected_item_already_owned = var_43_10
	arg_43_0._current_item_index = arg_43_0._current_item_index
end

function HeroWindowGotwfOverview.post_update(arg_44_0, arg_44_1, arg_44_2)
	if arg_44_0._ready then
		arg_44_0:_animate_list_entries(arg_44_1, arg_44_2)
		arg_44_0:_animate_buttons(arg_44_1, arg_44_2)
		arg_44_0:_handle_arrow_visibility(arg_44_1, arg_44_2)
		arg_44_0:_handle_input(arg_44_1, arg_44_2)
		arg_44_0:_handle_input_descriptions(arg_44_1, arg_44_2)
	end
end

function HeroWindowGotwfOverview._animate_buttons(arg_45_0, arg_45_1, arg_45_2)
	local var_45_0 = arg_45_0._claim_button_widgets

	for iter_45_0, iter_45_1 in pairs(var_45_0) do
		arg_45_0:_animate_button(iter_45_1, arg_45_1, arg_45_2)
	end
end

function HeroWindowGotwfOverview._animate_button(arg_46_0, arg_46_1, arg_46_2)
	local var_46_0 = arg_46_1.content
	local var_46_1 = arg_46_1.style
	local var_46_2 = var_46_0.button_hotspot
	local var_46_3 = var_46_2.is_hover
	local var_46_4 = var_46_2.is_selected
	local var_46_5 = var_46_2.is_clicked and var_46_2.is_clicked == 0
	local var_46_6 = var_46_2.input_progress or 0
	local var_46_7 = var_46_2.hover_progress or 0
	local var_46_8 = var_46_2.selection_progress or 0
	local var_46_9 = 8
	local var_46_10 = 20

	if var_46_5 then
		var_46_6 = math.min(var_46_6 + arg_46_2 * var_46_10, 1)
	else
		var_46_6 = math.max(var_46_6 - arg_46_2 * var_46_10, 0)
	end

	if var_46_3 then
		var_46_7 = math.min(var_46_7 + arg_46_2 * var_46_9, 1)
	else
		var_46_7 = math.max(var_46_7 - arg_46_2 * var_46_9, 0)
	end

	if var_46_4 then
		var_46_8 = math.min(var_46_8 + arg_46_2 * var_46_9, 1)
	else
		var_46_8 = math.max(var_46_8 - arg_46_2 * var_46_9, 0)
	end

	local var_46_11 = math.max(var_46_7, var_46_8)

	var_46_1.clicked_rect.color[1] = 100 * var_46_6

	local var_46_12 = 255 * var_46_7

	var_46_1.hover_glow.color[1] = var_46_12

	local var_46_13 = var_46_1.title_text_disabled
	local var_46_14 = var_46_13.default_text_color
	local var_46_15 = var_46_13.text_color

	var_46_15[2] = var_46_14[2] * 0.4
	var_46_15[3] = var_46_14[3] * 0.4
	var_46_15[4] = var_46_14[4] * 0.4
	var_46_2.hover_progress = var_46_7
	var_46_2.input_progress = var_46_6
	var_46_2.selection_progress = var_46_8

	local var_46_16 = var_46_1.title_text
	local var_46_17 = var_46_16.text_color
	local var_46_18 = var_46_16.default_text_color
	local var_46_19 = var_46_16.select_text_color

	Colors.lerp_color_tables(var_46_18, var_46_19, var_46_11, var_46_17)
end

function HeroWindowGotwfOverview._handle_arrow_visibility(arg_47_0, arg_47_1, arg_47_2)
	if arg_47_0._ui_animations.move then
		arg_47_0._scrollbar_ui:force_update_progress()

		return
	end

	local var_47_0 = arg_47_0._widgets_by_name.arrow_left.content
	local var_47_1 = arg_47_0._widgets_by_name.arrow_right.content
	local var_47_2 = arg_47_0._login_rewards.total_rewards

	if var_47_2 <= var_0_15 then
		var_47_0.visible = false
		var_47_0.hotspot = {}
		var_47_1.visible = false
		var_47_1.hotspot = {}
	elseif arg_47_0._steps > 0 then
		var_47_0.visible = true

		if arg_47_0._steps < var_47_2 - var_0_15 then
			var_47_1.visible = true
		else
			var_47_1.visible = false
			var_47_1.hotspot = {}
		end
	elseif arg_47_0._steps == 0 then
		var_47_0.visible = false
		var_47_0.hotspot = {}
		var_47_1.visible = true
	end
end

function HeroWindowGotwfOverview._update_animations(arg_48_0, arg_48_1)
	local var_48_0 = arg_48_0._ui_animations
	local var_48_1 = arg_48_0._animations
	local var_48_2 = arg_48_0._ui_animator

	for iter_48_0, iter_48_1 in pairs(arg_48_0._ui_animations) do
		UIAnimation.update(iter_48_1, arg_48_1)

		if UIAnimation.completed(iter_48_1) then
			arg_48_0._ui_animations[iter_48_0] = nil
		end
	end

	var_48_2:update(arg_48_1)

	for iter_48_2, iter_48_3 in pairs(var_48_1) do
		if var_48_2:is_animation_completed(iter_48_3) then
			var_48_2:stop_animation(iter_48_3)

			var_48_1[iter_48_2] = nil

			local var_48_3 = arg_48_0._ui_animations_callbacks[iter_48_2]

			if var_48_3 then
				var_48_3()
			end
		end
	end

	if arg_48_0._ui_animations.move then
		arg_48_0._scrollbar_ui:force_update_progress()
	else
		local var_48_4 = math.abs(arg_48_0._ui_scenegraph.gotwf_item_anchor.local_position[1])

		arg_48_0._steps = math.ceil(var_48_4 / var_0_11[1])
	end
end

function HeroWindowGotwfOverview._handle_input(arg_49_0, arg_49_1, arg_49_2)
	local var_49_0 = arg_49_0._parent
	local var_49_1 = arg_49_0._widgets_by_name
	local var_49_2 = Managers.input:is_device_active("gamepad")
	local var_49_3 = Managers.input:is_device_active("mouse")
	local var_49_4 = arg_49_0._parent:window_input_service()
	local var_49_5 = arg_49_0._ui_scenegraph.gotwf_item_anchor.local_position
	local var_49_6 = arg_49_0._login_rewards.total_rewards
	local var_49_7 = #arg_49_0._login_rewards.rewards
	local var_49_8 = math.max(var_49_6 - var_0_15, 0)
	local var_49_9 = arg_49_0._current_item_index
	local var_49_10 = arg_49_0._steps
	local var_49_11 = arg_49_0._params
	local var_49_12 = false
	local var_49_13 = arg_49_0._login_rewards.claimed_rewards

	if not arg_49_0._current_item_index then
		arg_49_0._current_item_index = var_49_7
		arg_49_0._steps = math.clamp(arg_49_0._current_item_index + 3 - var_0_15, 0, var_49_8)
		var_49_12 = true
	elseif arg_49_0._force_index then
		arg_49_0._current_item_index = arg_49_0._force_index
		arg_49_0._steps = math.clamp(arg_49_0._current_item_index + 3 - var_0_15, 0, var_49_8)
		var_49_12 = true
		arg_49_0._force_index = nil
	end

	local var_49_14 = var_49_13[arg_49_0._current_item_index]

	if var_49_2 and not arg_49_0._gamepad_was_active then
		arg_49_0._steps = math.clamp(arg_49_0._current_item_index + 3 - var_0_15, 0, var_49_8)
		arg_49_0._current_item_index = arg_49_0._current_item_index or arg_49_0._steps + 1
		var_49_12 = true

		if var_49_2 then
			for iter_49_0 = 1, table.size(arg_49_0._claim_button_widgets) do
				arg_49_0._claim_button_widgets[iter_49_0].content.gamepad_selected = iter_49_0 == arg_49_0._current_item_index
			end

			local var_49_15 = arg_49_0._item_widgets[arg_49_0._current_item_index].content
			local var_49_16 = var_49_15.reward_order
			local var_49_17 = var_49_16[#var_49_16]

			var_49_15["hotspot_" .. var_49_17].is_selected = var_49_14 > 0 and true
		else
			for iter_49_1, iter_49_2 in ipairs(arg_49_0._item_widgets) do
				local var_49_18 = iter_49_2.content
				local var_49_19 = var_49_18.num_rewards

				for iter_49_3 = 1, var_49_19 do
					var_49_18["hotspot_" .. iter_49_3].is_selected = false
				end
			end
		end

		arg_49_0._scrollbar_ui:disable_input(true)
	elseif not var_49_2 and arg_49_0._gamepad_was_active then
		arg_49_0._scrollbar_ui:disable_input(false)
	end

	if not arg_49_0._awaiting_result and not var_49_12 then
		local var_49_20 = 0
		local var_49_21 = 0

		if var_49_4:get("move_left_hold") then
			var_49_20 = arg_49_0._hold_left_timer + arg_49_1
			var_49_21 = 0
		elseif var_49_4:get("move_right_hold") then
			var_49_21 = arg_49_0._hold_right_timer + arg_49_1
			var_49_20 = 0
		else
			var_49_21 = 0
			var_49_20 = 0
		end

		if not var_49_3 then
			if var_49_4:get("move_left") or var_49_20 > 0.5 then
				if var_49_20 > 0.5 then
					var_49_20 = 0.4
				end

				arg_49_0._current_item_index = math.clamp(arg_49_0._current_item_index - 1, 1, var_49_6)
				arg_49_0._steps = math.clamp(arg_49_0._current_item_index + 3 - var_0_15, 0, var_49_8)
			elseif (var_49_4:get("move_right") or var_49_21 > 0.5) and var_49_6 > arg_49_0._current_item_index then
				if var_49_21 > 0.5 then
					var_49_21 = 0.4
				end

				arg_49_0._current_item_index = math.clamp(arg_49_0._current_item_index + 1, 1, var_49_6)
				arg_49_0._steps = math.clamp(arg_49_0._current_item_index + 3 - var_0_15, 0, var_49_8)
			end

			if var_49_4:get("confirm_press") then
				local var_49_22 = arg_49_0._current_item_index - var_49_7

				arg_49_0:_claim_daily_reward(var_49_22)
			elseif var_49_4:get("special_1_press") then
				local var_49_23 = arg_49_0._item_widgets[arg_49_0._current_item_index]
				local var_49_24 = var_49_23.content
				local var_49_25 = var_49_24.num_rewards

				if var_49_25 > 1 then
					var_49_9 = nil

					local var_49_26 = var_49_24.reward_order[1]

					for iter_49_4 = 1, var_49_25 do
						var_49_24["hotspot_" .. iter_49_4].is_selected = false
					end

					arg_49_0:_start_item_rotation_animation(var_49_23, var_49_26)
					arg_49_0:_play_sound("Play_hud_gotwf_click_claimed")
				end
			end
		elseif UIUtils.is_button_pressed(var_49_1.arrow_right, "hotspot") then
			arg_49_0._steps = math.clamp(arg_49_0._steps + 1, 0, var_49_6 - var_0_15)
		elseif UIUtils.is_button_pressed(var_49_1.arrow_left, "hotspot") then
			arg_49_0._steps = math.clamp(arg_49_0._steps - 1, 0, var_49_6 - var_0_15)
		else
			for iter_49_5, iter_49_6 in ipairs(arg_49_0._item_widgets) do
				local var_49_27 = iter_49_6.content
				local var_49_28 = var_49_27.num_rewards

				for iter_49_7 = var_49_28, 1, -1 do
					local var_49_29 = var_49_27.reward_order[iter_49_7]

					if UIUtils.is_button_pressed(iter_49_6, "hotspot_" .. var_49_29) then
						arg_49_0._current_item_index = iter_49_5

						local var_49_30 = iter_49_6.content
						local var_49_31 = var_49_30.reward_order

						if var_49_30.owned then
							local var_49_32 = table.find(var_49_31, var_49_29)

							if var_49_28 > 1 and var_49_32 < var_49_28 then
								arg_49_0:_start_item_rotation_animation(iter_49_6, var_49_29)

								var_49_9 = nil

								local var_49_33 = var_49_30.num_rewards

								for iter_49_8 = 1, var_49_33 do
									var_49_30["hotspot_" .. iter_49_8].is_selected = false
								end
							end
						end

						break
					end
				end
			end

			for iter_49_9, iter_49_10 in pairs(arg_49_0._claim_button_widgets) do
				if UIUtils.is_button_pressed(iter_49_10) then
					local var_49_34 = iter_49_10.content.reward_offset

					arg_49_0:_claim_daily_reward(var_49_34)

					return
				end
			end
		end

		arg_49_0._hold_right_timer = var_49_21
		arg_49_0._hold_left_timer = var_49_20
	end

	if arg_49_0._current_item_index ~= var_49_9 then
		if var_49_9 then
			local var_49_35 = arg_49_0._item_widgets[var_49_9].content
			local var_49_36 = var_49_35.num_rewards

			for iter_49_11 = 1, var_49_36 do
				var_49_35["hotspot_" .. iter_49_11].is_selected = false
			end

			arg_49_0._claim_button_widgets[var_49_9].content.gamepad_selected = false
		end

		local var_49_37 = arg_49_0._login_rewards.claimed_rewards[arg_49_0._current_item_index]
		local var_49_38 = var_49_37 > 0
		local var_49_39 = var_49_37 > 1

		arg_49_0._claim_button_widgets[arg_49_0._current_item_index].content.gamepad_selected = true

		local var_49_40 = arg_49_0._item_widgets[arg_49_0._current_item_index].content
		local var_49_41 = var_49_40.reward_order
		local var_49_42 = var_49_40.num_rewards
		local var_49_43 = math.min(var_49_42, var_49_41[#var_49_41])

		var_49_40["hotspot_" .. var_49_43].is_selected = var_49_38

		if var_49_40.owned then
			arg_49_0:_play_sound("Play_hud_gotwf_click_claimed")
		else
			arg_49_0:_play_sound("Play_hud_gotwf_click_unclaimed")
		end

		local var_49_44 = arg_49_0._login_rewards.rewards[arg_49_0._current_item_index]
		local var_49_45 = arg_49_0:_get_reward_item_from_bundle(var_49_44) or var_49_44 and var_49_44[var_49_43]

		arg_49_0._params.selected_item = var_49_38 and var_49_45
		arg_49_0._params.selected_item_index = var_49_38 and arg_49_0._current_item_index
		arg_49_0._params.selected_item_claimed = var_49_38
		arg_49_0._params.selected_item_already_owned = var_49_39

		if var_49_38 then
			arg_49_0:_start_transition_animation("reveal_instant")
		else
			arg_49_0:_start_transition_animation("hide_instant")
		end
	end

	if var_49_10 ~= arg_49_0._steps or var_49_12 then
		arg_49_0._ui_animations.move = UIAnimation.init(UIAnimation.function_by_time, var_49_5, 1, var_49_5[1], -arg_49_0._steps * var_0_11[1], 0.5, math.easeOutCubic)
	end

	arg_49_0._gamepad_was_active = var_49_2
end

function HeroWindowGotwfOverview._get_reward_item_from_bundle(arg_50_0, arg_50_1)
	if not arg_50_1 then
		return
	end

	local var_50_0 = arg_50_1[1]

	if var_50_0.reward_type == "bundle" then
		local var_50_1 = var_50_0.item_id
		local var_50_2 = ItemMasterList[var_50_1].bundle.BundledItems
		local var_50_3 = Managers.player:local_player()
		local var_50_4 = var_50_3:profile_index()
		local var_50_5 = var_50_3:career_index()
		local var_50_6 = SPProfiles[var_50_4].careers[var_50_5].name
		local var_50_7 = 1

		for iter_50_0 = 1, #var_50_2 do
			local var_50_8 = var_50_2[iter_50_0]
			local var_50_9 = rawget(ItemMasterList, var_50_8) or {}

			if table.contains(var_50_9.can_wield, var_50_6) then
				var_50_7 = iter_50_0

				break
			end
		end

		return {
			reward_type = "bundle_item",
			item_id = var_50_2[var_50_7],
			bundle_item_id = var_50_0.item_id
		}
	end
end

function HeroWindowGotwfOverview._handle_input_descriptions(arg_51_0, arg_51_1, arg_51_2)
	local var_51_0 = true
	local var_51_1 = #arg_51_0._login_rewards.rewards
	local var_51_2 = arg_51_0._current_item_index - var_51_1
	local var_51_3 = arg_51_0._login_rewards.rewards[arg_51_0._current_item_index]
	local var_51_4 = var_51_3 and #var_51_3 or 1
	local var_51_5 = arg_51_0._login_rewards.claimed_rewards[arg_51_0._current_item_index] > 0
	local var_51_6 = arg_51_0._login_rewards.num_allowed_old_segments_to_claim

	if var_51_5 then
		if var_51_4 > 1 then
			arg_51_0._parent:change_generic_actions(var_0_13.multiple_rewards, var_51_0)
		else
			arg_51_0._parent:change_generic_actions(var_0_13.default, var_51_0)
		end
	elseif var_51_2 >= -var_51_6 and var_51_2 <= 0 then
		arg_51_0._parent:change_generic_actions(var_0_13.claim_available, var_51_0)
	else
		arg_51_0._parent:change_generic_actions(var_0_13.default, var_51_0)
	end
end

function HeroWindowGotwfOverview._draw(arg_52_0, arg_52_1, arg_52_2)
	local var_52_0 = arg_52_0._parent
	local var_52_1 = arg_52_0._parent:get_layout_renderer()
	local var_52_2 = arg_52_0._ui_renderer
	local var_52_3 = arg_52_0._ui_top_renderer
	local var_52_4 = arg_52_0._ui_scenegraph
	local var_52_5 = arg_52_0._parent:window_input_service()
	local var_52_6 = arg_52_0._render_settings
	local var_52_7 = #arg_52_0._item_widgets
	local var_52_8 = arg_52_0._login_rewards.claimed_rewards
	local var_52_9 = var_52_6.alpha_multiplier

	UIRenderer.begin_pass(var_52_3, var_52_4, var_52_5, arg_52_1, nil, var_52_6)

	for iter_52_0, iter_52_1 in ipairs(arg_52_0._widgets) do
		var_52_6.snap_pixel_positions = false
		var_52_6.alpha_multiplier = iter_52_1.alpha_multiplier or var_52_9

		UIRenderer.draw_widget(var_52_3, iter_52_1)
	end

	if var_52_8[arg_52_0._current_item_index] > 0 or arg_52_0._awaiting_result then
		for iter_52_2, iter_52_3 in ipairs(arg_52_0._lock_widgets) do
			var_52_6.snap_pixel_positions = false
			var_52_6.alpha_multiplier = iter_52_3.alpha_multiplier or var_52_9

			UIRenderer.draw_widget(var_52_3, iter_52_3)
		end
	end

	for iter_52_4, iter_52_5 in ipairs(arg_52_0._item_texture_widgets) do
		var_52_6.snap_pixel_positions = false
		var_52_6.alpha_multiplier = iter_52_5.alpha_multiplier or var_52_9

		UIRenderer.draw_widget(var_52_3, iter_52_5)
	end

	local var_52_10 = math.abs(arg_52_0._ui_scenegraph.gotwf_item_anchor.local_position[1])
	local var_52_11 = math.ceil(var_52_10 / var_0_11[1])

	for iter_52_6, iter_52_7 in ipairs(arg_52_0._item_widgets) do
		if iter_52_6 > var_52_11 - 1 and iter_52_6 <= var_0_15 + var_52_11 + 1 then
			var_52_6.snap_pixel_positions = false
			var_52_6.alpha_multiplier = iter_52_7.alpha_multiplier or var_52_9

			UIRenderer.draw_widget(var_52_3, iter_52_7)
		end
	end

	local var_52_12 = math.abs(arg_52_0._ui_scenegraph.gotwf_item_anchor.local_position[1])
	local var_52_13 = math.ceil(var_52_12 / var_0_11[1])

	for iter_52_8, iter_52_9 in ipairs(arg_52_0._claim_button_widgets) do
		if iter_52_8 > var_52_13 - 1 and iter_52_8 <= var_0_15 + var_52_13 + 1 then
			var_52_6.snap_pixel_positions = false
			var_52_6.alpha_multiplier = iter_52_9.alpha_multiplier or var_52_9

			UIRenderer.draw_widget(var_52_3, iter_52_9)
		end
	end

	UIRenderer.end_pass(var_52_3)

	local var_52_14 = var_52_6.alpha_multiplier

	UIRenderer.begin_pass(var_52_2, var_52_4, var_52_5, arg_52_1, nil, var_52_6)

	for iter_52_10, iter_52_11 in ipairs(arg_52_0._bottom_widgets) do
		var_52_6.snap_pixel_positions = false
		var_52_6.alpha_multiplier = iter_52_11.alpha_multiplier or var_52_14

		UIRenderer.draw_widget(var_52_2, iter_52_11)
	end

	UIRenderer.end_pass(var_52_2)

	if var_52_1 then
		UIRenderer.begin_pass(var_52_1, var_52_4, var_52_5, arg_52_1, nil, arg_52_0._render_settings)

		for iter_52_12, iter_52_13 in ipairs(arg_52_0._viewport_widgets) do
			UIRenderer.draw_widget(var_52_1, iter_52_13)
		end

		UIRenderer.end_pass(var_52_1)
	end

	var_52_6.alpha_multiplier = var_52_14

	arg_52_0._scrollbar_ui:update(arg_52_1, arg_52_2, var_52_3, var_52_5, var_52_6)
end

function HeroWindowGotwfOverview._draw_background(arg_53_0, arg_53_1, arg_53_2)
	local var_53_0 = arg_53_0._parent
	local var_53_1 = arg_53_0._ui_top_renderer
	local var_53_2 = arg_53_0._ui_scenegraph
	local var_53_3 = arg_53_0._parent:window_input_service()
	local var_53_4 = arg_53_0._render_settings
	local var_53_5 = var_53_4.alpha_multiplier

	var_53_4.alpha_multiplier = 1

	UIRenderer.begin_pass(var_53_1, var_53_2, var_53_3, arg_53_1, nil, var_53_4)

	for iter_53_0, iter_53_1 in ipairs(arg_53_0._background_widgets) do
		var_53_4.alpha_multiplier = 1

		UIRenderer.draw_widget(var_53_1, iter_53_1)
	end

	UIRenderer.end_pass(var_53_1)

	var_53_4.alpha_multiplier = var_53_5
end
