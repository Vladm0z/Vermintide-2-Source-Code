-- chunkname: @scripts/ui/views/deus_menu/deus_shop_view_v2.lua

require("scripts/network/shared_state")

local var_0_0 = local_require("scripts/ui/views/deus_menu/deus_shop_view_definitions_v2")
local interaction_data = var_0_0.interaction_data
local purchase_interaction = var_0_0.purchase_interaction
local allow_boon_removal = var_0_0.allow_boon_removal
local num = 1
local num_2 = 2
local num_3 = 3
local num_4 = 4
local num_5 = 5
local tbl = {
	[num] = {
		unit_package = "units/props/deus_idol/deus_sigmar_01",
		unit_name = "units/props/deus_idol/deus_sigmar_01"
	},
	[num_2] = {
		unit_package = "units/props/deus_idol/deus_myrmidia_01",
		unit_name = "units/props/deus_idol/deus_myrmidia_01"
	},
	[num_3] = {
		unit_package = "units/props/deus_idol/deus_valaya_01",
		unit_name = "units/props/deus_idol/deus_valaya_01"
	},
	[num_4] = {
		unit_package = "units/props/deus_idol/deus_lileath_01",
		unit_name = "units/props/deus_idol/deus_lileath_01"
	},
	[num_5] = {
		unit_package = "units/props/deus_idol/deus_taal_01",
		unit_name = "units/props/deus_idol/deus_taal_01"
	}
}
local tbl_2 = {
	blessing_bought = "hud_morris_map_shrine_buy_blessing",
	power_up_bought = "hud_morris_map_shrine_buy_power_up",
	button_hover = "hud_morris_hover",
	ready_pressed = "hud_morris_close"
}

require("scripts/settings/dlcs/morris/deus_cost_settings")
require("scripts/settings/dlcs/morris/deus_shop_settings")

DeusShopView = class(DeusShopView)

local num_6 = 1
local num_7 = 60
local num_8 = 5
local num_9 = 15
local tbl_3 = {
	FINISHED = 5,
	SELECTING = 3,
	INITIALIZED = 1,
	FINISHING = 4,
	STARTING = 2
}
local tbl_4 = {
	READY_TO_BUY = 1,
	DONE_BUYING = 2
}
local tbl_5 = {
	server = {
		shop_state = {
			default_value = 0,
			type = "number",
			composite_keys = {}
		}
	},
	peer = {
		peer_state = {
			default_value = 0,
			type = "number",
			composite_keys = {}
		}
	}
}

SharedState.validate_spec(tbl_5)

local function fn(arg_1_0)
	-- function 1
	local default = UISettings.inventory_consumable_slot_colors.default
	local var_1_1

	if not arg_1_0 then
		var_1_1 = UISettings.inventory_consumable_slot_colors[arg_1_0]

		if not var_1_1 then
			-- Nothing
		end
	end

	var_1_1 = default

	::label_1_0::

	return var_1_1
end

DeusShopView.init = function (self, arg_2_1)
	-- function 2
	local str = "deus_shop_view"
	local input_manager = arg_2_1.input_manager

	self._input_manager = input_manager
	self._world = arg_2_1.world
	self._network_event_delegate = arg_2_1.network_event_delegate
	self._input_service_name = str
	self._previous_bought_blessings = {}

	input_manager:create_input_service(str, "IngameMenuKeymaps", "IngameMenuFilters")
	input_manager:map_device_to_service(str, "keyboard")
	input_manager:map_device_to_service(str, "mouse")
	input_manager:map_device_to_service(str, "gamepad")

	self.render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = false
	}
	self.ui_renderer = arg_2_1.ui_renderer
	self.ui_top_renderer = arg_2_1.ui_top_renderer
	self._wwise_world = arg_2_1.wwise_world
	self._portrait_mode = false
	self._is_server = arg_2_1.is_server
	self._deus_run_controller = arg_2_1.deus_run_controller

	local get_server_peer_id = self._deus_run_controller:get_server_peer_id()
	local get_own_peer_id = self._deus_run_controller:get_own_peer_id()

	self._shared_state = SharedState:new("deus_shop_" .. self._deus_run_controller:get_run_id(), tbl_5, self._is_server, arg_2_1.network_server, get_server_peer_id, get_own_peer_id)

	self._shared_state:full_sync()

	if not self._is_server then
		self._shared_state:set_server(self._shared_state:get_key("shop_state"), tbl_3.INITIALIZED)

		self._human_player_vo_units = {}
	end

	local event = Managers.state.event

	event:register(self, "ingame_menu_opened", "on_ingame_menu_opened")
	event:register(self, "ingame_menu_closed", "on_ingame_menu_closed")
end

DeusShopView._set_camera_node = function (arg_3_0, arg_3_1)
	-- function 3
	local camera_follow_unit = Managers.player:local_player().camera_follow_unit

	Unit.set_data(camera_follow_unit, "camera", "settings_node", arg_3_1)
end

DeusShopView.start = function (self, arg_4_1)
	-- function 4
	fassert(arg_4_1, "DeusShopView needs params to be set in order to function properly, see GameModeMapDeus")

	self._finished = false
	self._finish_cb = arg_4_1.finish_cb

	self:_set_camera_node("map_deus")
	self:_acquire_input()

	self._render_top_widgets = true
	self._selecting_countdown = nil
	self._final_countdown = num_8

	self._shared_state:set_own(self._shared_state:get_key("peer_state"), tbl_4.READY_TO_BUY)

	if not self._is_server then
		self._shared_state:set_server(self._shared_state:get_key("shop_state"), tbl_3.STARTING)

		local get_peers = self._deus_run_controller:get_peers()

		for k, v in pairs(get_peers) do
			local get_player_profile = self._deus_run_controller:get_player_profile(v, num_6)

			if not get_player_profile then
				local character_vo = SPProfiles[get_player_profile].character_vo

				if not character_vo then
					self._human_player_vo_units[v] = Managers.state.unit_spawner:spawn_network_unit("units/hub_elements/empty", "dialogue_node", {
						dialogue_system = {
							faction = "player",
							dialogue_profile = character_vo
						}
					})
				end
			end
		end
	end

	self._shop_type = self._deus_run_controller:get_current_node().level
	self._shop_config = DeusShopSettings.shop_types[self._shop_type]
	self._available_blessings = self._shop_config.blessings
	self._available_power_ups = self._deus_run_controller:generate_random_power_ups(self._shop_config.power_up_count, DeusPowerUpAvailabilityTypes.shrine)

	local get_own_peer_id = self._deus_run_controller:get_own_peer_id()
	local get_player_profile_2, var_4_5 = self._deus_run_controller:get_player_profile(get_own_peer_id, num_6)
	local var_4_6 = tbl[get_player_profile_2]

	self:_create_ui_elements(self._shop_config, self._available_power_ups, self._available_blessings, var_4_6)

	local find_dialogue_unit = LevelHelper:find_dialogue_unit(self._world, "ferry_lady_01")
	local extension_input = ScriptUnit.extension_input(find_dialogue_unit, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_dialogue_event("deus_shrine_tutorial", alloc_table)

	self._telemetry_data = {
		store_type = self._shop_type,
		purchased_blessings = {},
		purchased_boons = {},
		currency_when_entered = self._deus_run_controller:get_player_soft_currency(get_own_peer_id),
		run_id = self._deus_run_controller:get_run_id()
	}
end

DeusShopView.register_rpcs = function (self, arg_5_1, arg_5_2)
	-- function 5
	self._shared_state:register_rpcs(arg_5_1)
end

DeusShopView.unregister_rpcs = function (self)
	-- function 6
	self._shared_state:unregister_rpcs()
end

DeusShopView._create_ui_elements = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	self.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	self._ui_animator = UIAnimator:new(self.ui_scenegraph, var_0_0.animations_definitions)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(var_0_0.widgets) do
		if not v then
			local var_7_2 = UIWidget.init(v)

			tbl[#tbl + 1] = var_7_2
			tbl_2[k] = var_7_2
		end
	end

	tbl_2.bottom_text.content.text = Localize("deus_shrine_continue_info")
	tbl_2.ready_button.content.title_text = Localize("deus_ready_button")

	local tbl_3 = {}

	for k_2, v_2 in pairs(var_0_0.top_widgets) do
		if not v_2 then
			local var_7_4 = UIWidget.init(v_2)

			tbl_3[#tbl_3 + 1] = var_7_4
			tbl_2[k_2] = var_7_4
		end
	end

	local tbl_4 = {}

	for k_3, v_3 in pairs(var_0_0.player_widgets) do
		if not v_3 then
			local var_7_6 = UIWidget.init(v_3)

			tbl_4[#tbl_4 + 1] = var_7_6
			tbl[#tbl + 1] = var_7_6
			tbl_2[k_3] = var_7_6
		end
	end

	local get_own_peer_id = self._deus_run_controller:get_own_peer_id()
	local get_player_profile, var_7_9 = self._deus_run_controller:get_player_profile(get_own_peer_id, num_6)
	local tbl_5 = {
		power_ups = {},
		blessings = {}
	}
	local DeusPowerUpTemplates = DeusPowerUpTemplates
	local tbl_6 = {}
	local count = #arg_7_2

	for i6 = 1, count do
		local var_7_14 = arg_7_2[i6]
		local rectangular_icon = DeusPowerUpTemplates[var_7_14.name].rectangular_icon
		local size = var_0_0.scenegraph_definition.power_up_root.size
		local create_power_up_shop_item = var_0_0.create_power_up_shop_item("power_up_root", size, false, rectangular_icon)
		local var_7_18 = UIWidget.init(create_power_up_shop_item)
		local num = i6 - 1
		local num_2 = count - 1
		local rad = math.rad(num / num_2 * 180)
		local num_3 = 60
		local num_4 = 0
		local num_5 = ((size[2] + num_4) * count + size[2]) / 2

		var_7_18.offset = {
			num_3 * math.sin(rad),
			num_5 - (num_4 + size[2]) * i6,
			0
		}

		local flag = not (i6 <= arg_7_1.max_discounts) and arg_7_1.power_up_discount
		local var_7_26
		local num_7 = 0

		self:_init_power_up_widget(var_7_18, var_7_14, flag, num_7, var_7_26, get_player_profile, var_7_9)

		tbl[#tbl + 1] = var_7_18
		tbl_6[#tbl_6 + 1] = var_7_18
		tbl_2["power_up_item_" .. i6] = var_7_18
		tbl_5.power_ups[#tbl_5.power_ups + 1] = {
			widget = var_7_18,
			power_up = var_7_14,
			discount = flag
		}
	end

	local tbl_7 = {}
	local count_2 = #arg_7_3

	for i7 = 1, count_2 do
		local size_2 = var_0_0.scenegraph_definition.blessing_root.size
		local create_blessing_shop_item = var_0_0.create_blessing_shop_item("blessing_root", size_2, false)
		local var_7_32 = UIWidget.init(create_blessing_shop_item)
		local num_8 = 15
		local num_9 = ((size_2[2] + num_8) * count_2 + size_2[2]) / 2

		var_7_32.offset = {
			0,
			num_9 - (num_8 + size_2[2]) * i7,
			0
		}

		local var_7_35 = arg_7_3[i7]
		local offset = var_7_32.offset
		local tbl_8 = {
			541,
			75,
			10
		}
		local tbl_9 = {
			offset[1] + tbl_8[1],
			offset[2] + tbl_8[2],
			offset[3] + tbl_8[3]
		}
		local create_blessing_portraits_frame = var_0_0.create_blessing_portraits_frame("blessing_root", "default", "-", false, tbl_9)
		local var_7_40 = UIWidget.init(create_blessing_portraits_frame)

		var_7_32.content.frame_index = i7
		tbl_7[#tbl_7 + 1] = var_7_40
		tbl_2[var_7_35 .. "_portrait_frame_" .. i7] = var_7_40

		self:_init_blessing_widget(var_7_32, var_7_35)

		tbl[#tbl + 1] = var_7_32
		tbl_6[#tbl_6 + 1] = var_7_32
		tbl_2["blessing_item_" .. i7] = var_7_32
		tbl_5.blessings[#tbl_5.blessings + 1] = {
			widget = var_7_32,
			blessing_name = var_7_35
		}
	end

	local get_peers = self._deus_run_controller:get_peers()
	local tbl_10 = {}

	for i8 = 1, 4 do
		local str = "player_portrait_frame_" .. i8
		local var_7_44
		local var_7_45

		if not get_peers[i8] then
			local get_player_profile_2, var_7_47 = self._deus_run_controller:get_player_profile(get_peers[i8], num_6)
			local get_player_level = self._deus_run_controller:get_player_level(get_peers[i8], get_player_profile_2)

			get_player_level = get_player_level or "n/a"

			local get_player_frame = self._deus_run_controller:get_player_frame(get_peers[i8], get_player_profile_2, var_7_47)

			var_7_44 = UIWidgets.deus_create_player_portraits_frame("player_portrait_" .. i8, get_player_frame, get_player_level, false)
		else
			var_7_44 = UIWidgets.deus_create_player_portraits_frame("player_portrait_" .. i8, "default", " ", false)
		end

		local var_7_50 = UIWidget.init(var_7_44)

		tbl_10[#tbl_10 + 1] = var_7_50
		tbl_2[str] = var_7_50
	end

	self._blessing_frame_widgets = tbl_7
	self._portrait_frame_widgets = tbl_10
	self._shop_items = tbl_5
	self._shop_item_widgets = tbl_6
	self._widgets = tbl
	self._top_widgets = tbl_3
	self._widgets_by_name = tbl_2

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	if not arg_7_4 then
		local _create_background_unit_definition = self:_create_background_unit_definition()

		self._background_unit_widget = UIWidget.init(_create_background_unit_definition)

		local unit_name = arg_7_4.unit_name
		local unit_package = arg_7_4.unit_package

		self._unit_previewer = self:_create_unit_previewer(self._background_unit_widget, unit_name, unit_package)

		self._unit_previewer:set_zoom_fraction_unclamped(-0.2)
	end

	local _purchased_boons = self._purchased_boons

	_purchased_boons = _purchased_boons or {}
	self._purchased_boons = _purchased_boons
	self._total_num_power_ups = nil

	self:_update_power_ups()
end

DeusShopView.update = function (self, arg_8_1, arg_8_2)
	-- function 8
	local get_server = self._shared_state:get_server(self._shared_state:get_key("shop_state"))

	self:_update_countdowns(get_server, arg_8_1, arg_8_2)

	if not self._is_server then
		local _check_transition = self:_check_transition(get_server)

		if _check_transition ~= get_server then
			self._shared_state:set_server(self._shared_state:get_key("shop_state"), _check_transition)

			get_server = _check_transition
		end
	end

	if get_server == tbl_3.STARTING then
		self:_update_during_starting(arg_8_1, arg_8_2)
	elseif get_server == tbl_3.SELECTING then
		self:_update_during_selecting(arg_8_1, arg_8_2)
	elseif get_server == tbl_3.FINISHING then
		self:_update_during_finishing(arg_8_1, arg_8_2)
	elseif not (get_server ~= tbl_3.FINISHED or self._finished) then
		self:_finish()

		self._finished = true
	end

	local _unit_previewer = self._unit_previewer

	if not _unit_previewer then
		_unit_previewer:update(arg_8_1, arg_8_2, false)
	end

	self:_handle_mode_input(arg_8_1, arg_8_2)
	self:_update_player_data()
	self:_update_hold_text()
	self:_update_input_helper_text(arg_8_1, arg_8_2)
	self:_update_background_animations(arg_8_1)
	self:_update_animations(arg_8_1)
	self:_update_power_ups()
	self:_draw(arg_8_1, arg_8_2)
end

DeusShopView._handle_mode_input = function (self, arg_9_1, arg_9_2)
	-- function 9
	if not self:input_service():get("cycle_next_raw") then
		if not self._ui_animator:is_animation_completed(self._anim_id) then
			self._ui_animator:stop_animation(self._anim_id)
		end

		local _ui_animator = self._ui_animator
		local var_9_1 = _ui_animator
		local start_animation = _ui_animator.start_animation
		local flag

		flag = not self._portrait_mode and "switch_to_boons" and "switch_to_portraits"
		self._anim_id = start_animation(var_9_1, flag, self._widgets_by_name, var_0_0.scenegraph_definition)
		self._portrait_mode = not self._portrait_mode
	end
end

DeusShopView._update_power_ups = function (self)
	-- function 10
	local _deus_run_controller = self._deus_run_controller
	local get_own_peer_id = _deus_run_controller:get_own_peer_id()
	local get_player_power_ups = _deus_run_controller:get_player_power_ups(get_own_peer_id, num_6)
	local get_party_power_ups = _deus_run_controller:get_party_power_ups()
	local get_player_profile, var_10_5 = _deus_run_controller:get_player_profile(get_own_peer_id, num_6)
	local num = #get_player_power_ups + #get_party_power_ups

	if num ~= self._total_num_power_ups then
		local tbl = {}

		if num > 0 then
			local var_10_8 = Managers.mechanism:game_mechanism():get_deus_run_controller():get_own_initial_talents()[SPProfiles[get_player_profile].careers[var_10_5].name]
			local tbl_2 = {}

			for i = 1, #var_10_8 do
				local var_10_10 = var_10_8[i]

				if var_10_10 ~= 0 then
					local get_talent_power_up_from_tier_and_column, var_10_12 = DeusPowerUpUtils.get_talent_power_up_from_tier_and_column(i, var_10_10)

					tbl_2[get_talent_power_up_from_tier_and_column.name] = true
				end
			end

			local RaritySettings = RaritySettings

			table.sort(get_player_power_ups, function (self, arg_11_1)
				-- function 11
				local order = RaritySettings[self.rarity].order
				local order_2 = RaritySettings[arg_11_1.rarity].order

				if order == order_2 then
					return self.name < arg_11_1.name
				else
					return order_2 < order
				end
			end)

			local DeusPowerUpTemplates = DeusPowerUpTemplates
			local num_2 = #get_player_power_ups + #get_party_power_ups
			local num_3 = Managers.time:time("main") * 2

			for j = 1, num_2 do
				local var_10_17
				local flag = false

				if j <= #get_player_power_ups then
					var_10_17 = get_player_power_ups[j]
				else
					var_10_17 = get_party_power_ups[j - #get_player_power_ups]
					flag = true
				end

				local var_10_19 = DeusPowerUps[var_10_17.rarity][var_10_17.name]
				local get_power_up_name_text, var_10_21 = DeusPowerUpUtils.get_power_up_name_text(var_10_19.name, var_10_19.talent_index, var_10_19.talent_tier, get_player_profile, var_10_5)
				local get_power_up_icon = DeusPowerUpUtils.get_power_up_icon(var_10_19, get_player_profile, var_10_5)
				local get_table = Colors.get_table(var_10_19.rarity)
				local rectangular_icon = DeusPowerUpTemplates[var_10_19.name].rectangular_icon
				local rectangular_power_up_widget_data

				if not rectangular_icon then
					rectangular_power_up_widget_data = var_0_0.rectangular_power_up_widget_data

					if not rectangular_power_up_widget_data then
						-- Nothing
					end
				end

				rectangular_power_up_widget_data = var_0_0.round_power_up_widget_data

				::label_10_0::

				local flag_2 = true
				local flag_3 = true
				local tbl_3 = {
					color = {
						255,
						138,
						172,
						235
					},
					offset = var_0_0.rectangular_power_up_widget_data.icon_offset,
					texture_size = var_0_0.rectangular_power_up_widget_data.icon_size
				}
				local str = "own_power_up_anchor"
				local create_icon_info_box = UIWidgets.create_icon_info_box(str, get_power_up_icon, rectangular_power_up_widget_data.icon_size, rectangular_power_up_widget_data.icon_offset, rectangular_power_up_widget_data.background_icon, rectangular_power_up_widget_data.background_icon_size, rectangular_power_up_widget_data.background_icon_offset, var_10_21, get_power_up_name_text, get_table, rectangular_power_up_widget_data.width, rectangular_icon, flag_2, flag_3, tbl_3)
				local var_10_31 = UIWidget.init(create_icon_info_box)

				var_10_31.content.power_up_name = var_10_19.name
				var_10_31.content.power_up_rarity = var_10_19.rarity

				local content = var_10_31.content

				if not flag then
					-- Nothing
				end

				::label_10_1::

				local var_10_33 = tbl_2[var_10_19.name]

				var_10_33 = var_10_33 or self._purchased_boons[var_10_19.name]

				::label_10_2::

				content.locked = var_10_33

				local content_2 = var_10_31.content
				local flag_4

				flag_4 = not flag and "party_locked" and not tbl_2[var_10_19.name] or "talent_locked" and not self._purchased_boons[var_10_19.name] and "deus_shrine_unlocked" and "search_filter_locked"
				content_2.locked_text_id = flag_4

				local num_4 = (j - 1) % 2

				var_10_31.offset[1] = num_4 * (var_0_0.power_up_widget_size[1] + var_0_0.power_up_widget_spacing[1])
				var_10_31.offset[2] = -math.floor((j - 1) / 2) * (var_0_0.power_up_widget_size[2] + var_0_0.power_up_widget_spacing[2])
				tbl[#tbl + 1] = var_10_31
				self._widgets_by_name[str] = var_10_31
			end
		end

		self._total_num_power_ups = num
		self._power_up_widgets = tbl
		self._power_ups = get_player_power_ups
		self._party_power_ups = get_party_power_ups

		local num_5 = math.ceil(self._total_num_power_ups / 2) * (var_0_0.power_up_widget_size[2] + var_0_0.power_up_widget_spacing[2]) - self.ui_scenegraph.own_power_up_window.size[2]

		if num_5 > 0 then
			local ui_scenegraph = self.ui_scenegraph
			local str_2 = "own_power_up_anchor"
			local str_3 = "own_power_up_window"
			local var_10_41 = num_5
			local flag_5 = false
			local var_10_43
			local var_10_44
			local flag_6 = true

			self._scrollbar_ui = ScrollbarUI:new(ui_scenegraph, str_2, str_3, var_10_41, flag_5, var_10_43, var_10_44, flag_6)
		else
			self._scrollbar_ui = nil
		end
	end
end

DeusShopView.post_update = function (self, arg_12_1, arg_12_2)
	-- function 12
	if not self._unit_previewer then
		self._unit_previewer:post_update(arg_12_1, arg_12_2)
	end
end

DeusShopView._update_animations = function (self, arg_13_1)
	-- function 13
	self._ui_animator:update(arg_13_1)
end

DeusShopView.destroy_idol = function (self)
	-- function 14
	if not self._background_unit_widget then
		self._unit_previewer:destroy()

		self._unit_previewer = nil

		UIWidget.destroy(self.ui_renderer, self._background_unit_widget)

		self._background_unit_widget = nil
	end
end

DeusShopView.destroy = function (self)
	-- function 15
	self:destroy_idol()

	local get_server = self._shared_state:get_server(self._shared_state:get_key("shop_state"))

	if not (get_server == tbl_3.FINISHED or get_server == tbl_3.INITIALIZED) then
		self:_release_input()
	end

	self._shared_state:destroy()

	self._shared_state = nil

	local event = Managers.state.event

	event:unregister("ingame_menu_opened", self)
	event:unregister("ingame_menu_closed", self)
end

DeusShopView.input_service = function (self)
	-- function 16
	return self._input_manager:get_service(self._input_service_name)
end

DeusShopView._finish = function (self, arg_17_1)
	-- function 17
	local _finish_cb = self._finish_cb

	if not _finish_cb then
		self._finish_cb = nil

		_finish_cb(arg_17_1)
	end

	self:_release_input()
	self:_set_camera_node("first_person_node")
	Managers.telemetry_events:store_node_traversed(self._telemetry_data)
end

DeusShopView._init_power_up_widget = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7)
	-- function 18
	local var_18_0 = DeusPowerUps[arg_18_2.rarity][arg_18_2.name]
	local rarity = var_18_0.rarity
	local content = arg_18_1.content

	content.title_text = DeusPowerUpUtils.get_power_up_name_text(var_18_0.name, var_18_0.talent_index, var_18_0.talent_tier, arg_18_6, arg_18_7)
	content.rarity_text = Localize(RaritySettings[rarity].display_name)
	content.sub_text = DeusPowerUpUtils.get_power_up_description(var_18_0, arg_18_6, arg_18_7)
	content.max_value_text = nil
	content.current_value_text = nil
	content.has_discount = arg_18_3
	content.icon = DeusPowerUpUtils.get_power_up_icon(var_18_0, arg_18_6, arg_18_7)

	local var_18_3 = DeusCostSettings.shop.power_ups[rarity]

	var_18_3 = var_18_3 or 9001

	if not arg_18_3 then
		var_18_3 = var_18_3 - var_18_3 * arg_18_3
	end

	content.price_text = tostring(var_18_3)

	local style = arg_18_1.style
	local get_table = Colors.get_table(rarity)

	style.rarity_text.text_color = get_table

	if not arg_18_3 then
		style.price_text.text_color = var_0_0.discount_text_color
	end

	if not (not arg_18_5 and arg_18_4) then
		local var_18_6 = var_0_0.single_price_offset[2]

		style.price_icon.offset[2] = style.price_icon.offset[2] + var_18_6
		style.price_text.offset[2] = style.price_text.offset[2] + var_18_6
		style.price_text_shadow.offset[2] = style.price_text_shadow.offset[2] + var_18_6
		style.price_text_disabled.offset[2] = style.price_text_disabled.offset[2] + var_18_6
	end

	local var_18_7 = DeusPowerUpSetLookup[arg_18_2.rarity]

	var_18_7 = not var_18_7 and DeusPowerUpSetLookup[arg_18_2.rarity][arg_18_2.name]

	local flag = false

	if not var_18_7 then
		local var_18_9 = var_18_7[1]
		local num = 0
		local pieces = var_18_9.pieces

		for i, v in ipairs(pieces) do
			local name = v.name
			local rarity_2 = v.rarity
			local get_own_peer_id = self._deus_run_controller:get_own_peer_id()

			if not self._deus_run_controller:has_power_up_by_name(get_own_peer_id, name, rarity_2) then
				num = num + 1
			end
		end

		flag = true

		local num_required_pieces = var_18_9.num_required_pieces

		num_required_pieces = num_required_pieces or #pieces
		arg_18_1.content.set_progression = Localize("set_bonus_boons") .. " " .. string.format(Localize("set_counter_boons"), num, num_required_pieces)

		if #pieces == num then
			arg_18_1.style.set_progression.text_color = arg_18_1.style.set_progression.progression_colors.complete
		end
	end

	arg_18_1.content.is_part_of_set = flag
end

DeusShopView._init_blessing_widget = function (arg_19_0, arg_19_1, arg_19_2)
	-- function 19
	local content = arg_19_1.content
	local var_19_1 = DeusBlessingSettings[arg_19_2]

	content.title_text = Localize(var_19_1.display_name)
	content.sub_text = Localize(var_19_1.description)
	content.icon = var_19_1.shop_icon

	local var_19_2 = DeusCostSettings.shop.blessings[arg_19_2]

	var_19_2 = var_19_2 or 9001
	content.price_text = var_19_2
end

DeusShopView._update_countdowns = function (self, arg_20_1, arg_20_2, arg_20_3)
	-- function 20
	if arg_20_1 == tbl_3.FINISHING then
		local max

		if not self._final_countdown then
			max = math.max(0, self._final_countdown - arg_20_2)

			if not max then
				-- Nothing
			end
		end

		max = nil

		::label_20_0::

		self._final_countdown = max
	end
end

DeusShopView._check_transition = function (self, arg_21_1)
	-- function 21
	if arg_21_1 == tbl_3.STARTING then
		if not self:_are_all_peers_ready() then
			return tbl_3.SELECTING
		end
	elseif arg_21_1 == tbl_3.SELECTING then
		if self._selecting_countdown == 0 or not self:_are_all_peers_done() then
			self._selecting_countdown = 0

			return tbl_3.FINISHING
		end
	elseif not (arg_21_1 ~= tbl_3.FINISHING or self._final_countdown ~= 0) then
		return tbl_3.FINISHED
	end

	return arg_21_1
end

DeusShopView._update_during_starting = function (self, arg_22_1, arg_22_2)
	-- function 22
	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.bottom_text.content.text = Localize("deus_shrine_waiting_info")
	_widgets_by_name.ready_button.content.button_hotspot.disable_button = true

	self:_update_shop_widgets()
end

DeusShopView._update_during_selecting = function (self, arg_23_1, arg_23_2)
	-- function 23
	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.bottom_text.content.text = Localize("deus_shrine_continue_info")

	local get_key = self._shared_state:get_key("peer_state")
	local flag = self._shared_state:get_own(get_key) == tbl_4.DONE_BUYING

	_widgets_by_name.ready_button.content.button_hotspot.disable_button = flag

	if not self._selecting_countdown then
		local num = self._selecting_countdown - arg_23_1
		local max = math.max(num, 0)

		_widgets_by_name.timer_text.content.text = math.floor(max)

		self:_update_vote_hurry_up(max)

		self._selecting_countdown = max
	elseif not self:_did_someone_vote() then
		self._selecting_countdown = num_7
	end

	self:_update_shop_widgets()
	self:_handle_input(arg_23_1, arg_23_2)
end

DeusShopView._update_vote_hurry_up = function (self, arg_24_1)
	-- function 24
	if not ((self._hurry_up_vo_played or not self._deus_run_controller:is_server()) and not (arg_24_1 < num_9)) then
		self._hurry_up_vo_played = true

		local get_key = self._shared_state:get_key("peer_state")
		local select_array = table.select_array(self._deus_run_controller:get_peers(), function (arg_25_0, arg_25_1)
			-- function 25
			if not (not self._human_player_vo_units[arg_25_1] and self._shared_state:get_peer(arg_25_1, get_key) ~= tbl_4.DONE_BUYING) then
				return arg_25_1
			end
		end)

		table.shuffle(select_array)

		if not select_array[1] then
			local var_24_2 = self._human_player_vo_units[select_array[1]]

			ScriptUnit.extension_input(var_24_2, "dialogue_system"):trigger_networked_dialogue_event("deus_shrine_hurry")
		end
	end
end

DeusShopView._update_during_finishing = function (self, arg_26_1, arg_26_2)
	-- function 26
	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.bottom_text.content.text = Localize("deus_shrine_continue_in")
	_widgets_by_name.ready_button.content.button_hotspot.disable_button = true
	_widgets_by_name.timer_text.content.text = nil

	self:_update_shop_widgets()
	self:_handle_input(arg_26_1, arg_26_2)
end

DeusShopView._update_shop_widgets = function (self)
	-- function 27
	local get_own_peer_id = self._deus_run_controller:get_own_peer_id()
	local get_player_soft_currency = self._deus_run_controller:get_player_soft_currency(get_own_peer_id)

	self._widgets_by_name.coins_text.content.text = string.format("%d", get_player_soft_currency)

	local _shop_items = self._shop_items

	for i, v in ipairs(_shop_items.power_ups) do
		local widget = v.widget
		local power_up = v.power_up
		local discount = v.discount
		local _get_power_up_costs = self:_get_power_up_costs(power_up.rarity, discount)
		local reached_max_power_ups = self._deus_run_controller:reached_max_power_ups(get_own_peer_id, power_up.name)
		local has_power_up = self._deus_run_controller:has_power_up(get_own_peer_id, power_up.client_id)
		local content = widget.content

		if reached_max_power_ups or not has_power_up then
			content.is_bought = true
			content.button_hotspot.disable_button = true
		elseif get_player_soft_currency < _get_power_up_costs then
			content.button_hotspot.disable_button = true
		else
			content.is_bought = false
			content.button_hotspot.disable_button = false
		end
	end

	local get_blessings_with_buyer = self._deus_run_controller:get_blessings_with_buyer()
	local blessings = DeusCostSettings.shop.blessings

	for i_2, v_2 in ipairs(_shop_items.blessings) do
		local widget_2 = v_2.widget
		local blessing_name = v_2.blessing_name
		local var_27_14 = blessings[blessing_name]

		var_27_14 = var_27_14 or 9001

		local content_2 = widget_2.content
		local var_27_16 = get_blessings_with_buyer[blessing_name]

		if not var_27_16 then
			if not content_2.is_bought then
				self:_blessing_bought_vo(var_27_16)
			end

			content_2.is_bought = true
			content_2.button_hotspot.disable_button = true

			local get_player_profile, var_27_18 = self._deus_run_controller:get_player_profile(var_27_16, num_6)

			if get_player_profile ~= 0 then
				local var_27_19 = SPProfiles[get_player_profile].careers[var_27_18]
				local get_player_name = self._deus_run_controller:get_player_name(var_27_16)
				local get_player_level = self._deus_run_controller:get_player_level(var_27_16, get_player_profile)
				local get_player_frame = self._deus_run_controller:get_player_frame(var_27_16, get_player_profile, var_27_18)
				local offset = widget_2.offset
				local tbl = {
					541,
					75,
					10
				}
				local tbl_3 = {
					offset[1] + tbl[1],
					offset[2] + tbl[2],
					offset[3] + tbl[3]
				}
				local var_27_26 = self._blessing_frame_widgets[content_2.frame_index]

				if not (var_27_26.content.frame_settings_name ~= get_player_frame or var_27_26.content.level == get_player_level) then
					self:_update_blessing_portrait_frame(get_player_frame, tostring(get_player_level), blessing_name, content_2.frame_index, tbl_3, content_2.is_bought)
				end

				content_2.player_name_text = get_player_name
				content_2.character_portrait = var_27_19.portrait_image
				content_2.level = tostring(get_player_level)
			end

			if not (self._previous_bought_blessings[blessing_name] or var_27_16 == get_own_peer_id) then
				self:_play_sound(tbl_2.blessing_bought)
			end
		elseif get_player_soft_currency < var_27_14 then
			content_2.button_hotspot.disable_button = true
		else
			content_2.button_hotspot.disable_button = false
			content_2.is_bought = false
		end

		self._previous_bought_blessings[blessing_name] = content_2.is_bought
	end
end

DeusShopView._acquire_input = function (self, arg_28_1)
	-- function 28
	self:_release_input(true)

	local _input_manager = self._input_manager
	local _input_service_name = self._input_service_name

	_input_manager:capture_input({
		"keyboard",
		"gamepad",
		"mouse"
	}, 1, _input_service_name, "DeusShopView")

	if not arg_28_1 then
		ShowCursorStack.show("DeusShopView")
		_input_manager:enable_gamepad_cursor()
	end

	self._acquiring_input = true
end

DeusShopView._blessing_bought_vo = function (self, arg_29_1)
	-- function 29
	if not self._deus_run_controller:is_server() then
		local var_29_0 = self._human_player_vo_units[arg_29_1]

		if not var_29_0 then
			ScriptUnit.extension_input(var_29_0, "dialogue_system"):trigger_networked_dialogue_event("deus_purchasing_blessing")
		end
	end
end

DeusShopView._release_input = function (self, arg_30_1)
	-- function 30
	local _input_manager = self._input_manager

	_input_manager:release_input({
		"keyboard",
		"gamepad",
		"mouse"
	}, 1, self._input_service_name, "DeusShopView")

	if arg_30_1 or not self._acquiring_input then
		ShowCursorStack.hide("DeusShopView")
		_input_manager:disable_gamepad_cursor()
	end

	self._acquiring_input = false
end

DeusShopView._update_button_hover_sound = function (self, arg_31_1)
	-- function 31
	if not UIUtils.is_button_hover_enter(arg_31_1) then
		self:_play_sound(tbl_2.button_hover)
	end
end

DeusShopView._on_blessing_bought = function (self, arg_32_1)
	-- function 32
	self._deus_run_controller:shop_buy_blessing(arg_32_1)

	local var_32_0 = DeusCostSettings.shop.blessings[arg_32_1]

	table.insert(self._telemetry_data.purchased_blessings, {
		name = arg_32_1,
		cost = var_32_0
	})
end

DeusShopView._on_power_up_bought = function (self, arg_33_1, arg_33_2)
	-- function 33
	self._deus_run_controller:shop_buy_power_up(arg_33_1, arg_33_2)

	local _get_power_up_costs = self:_get_power_up_costs(arg_33_1.rarity, arg_33_2)

	table.insert(self._telemetry_data.purchased_boons, {
		name = arg_33_1.name,
		cost = _get_power_up_costs
	})

	self._purchased_boons[arg_33_1.name] = true
end

DeusShopView._handle_input = function (self, arg_34_1, arg_34_2)
	-- function 34
	local _shop_items = self._shop_items

	for i, v in ipairs(_shop_items.power_ups) do
		local widget = v.widget
		local flag = false

		if not (not UIUtils.is_button_held(widget) and widget.content.is_bought) then
			if not interaction_data.interaction_started then
				purchase_interaction.start(interaction_data, arg_34_2)

				self._purchasing_power_up_name = v.power_up.name
			end

			interaction_data.interaction_ongoing = true

			local num = 255 * interaction_data.progress

			widget.style.loading_frame.color[1] = num
			flag = purchase_interaction.update(interaction_data, arg_34_2)
		elseif not (not self._purchasing_power_up_name and v.power_up.name ~= self._purchasing_power_up_name) then
			interaction_data.interaction_ongoing = false
			widget.style.loading_frame.color[1] = 0
			self._purchasing_power_up_name = nil

			purchase_interaction.abort(interaction_data)
		end

		if not flag then
			local power_up = v.power_up
			local discount = v.discount

			self:_on_power_up_bought(power_up, discount or 0)
			self:_play_sound(tbl_2.power_up_bought)
			purchase_interaction.successful(interaction_data)

			self._purchasing_power_up_name = nil
		end

		self:_update_button_hover_sound(widget)
	end

	for i_2, v_2 in ipairs(_shop_items.blessings) do
		local widget_2 = v_2.widget
		local flag_2 = false

		if not (not UIUtils.is_button_held(widget_2) and widget_2.content.is_bought) then
			if not interaction_data.interaction_started then
				purchase_interaction.start(interaction_data, arg_34_2)

				self._purchasing_blessing_name = v_2.blessing_name
			end

			interaction_data.interaction_ongoing = true

			local num_2 = 255 * interaction_data.progress

			widget_2.style.loading_frame.color[1] = num_2
			flag_2 = purchase_interaction.update(interaction_data, arg_34_2)
		elseif not (not self._purchasing_blessing_name and v_2.blessing_name ~= self._purchasing_blessing_name) then
			interaction_data.interaction_ongoing = false
			widget_2.style.loading_frame.color[1] = 0
			self._purchasing_blessing_name = nil

			purchase_interaction.abort(interaction_data)
		end

		if not flag_2 then
			self:_on_blessing_bought(v_2.blessing_name)
			self:_play_sound(tbl_2.blessing_bought)
			purchase_interaction.successful(interaction_data)

			self._purchasing_blessing_name = nil
		end

		self:_update_button_hover_sound(widget_2)
	end

	local _widgets_by_name = self._widgets_by_name

	self:_update_button_hover_sound(_widgets_by_name.ready_button)

	if not UIUtils.is_button_pressed(_widgets_by_name.ready_button) then
		local get_key = self._shared_state:get_key("peer_state")

		self._shared_state:set_own(get_key, tbl_4.DONE_BUYING)
		self:_play_sound(tbl_2.ready_pressed)
	end

	self:_handle_owned_power_up_input(arg_34_1, arg_34_2)
end

DeusShopView._handle_owned_power_up_input = function (self, arg_35_1, arg_35_2)
	-- function 35
	local ui_scenegraph = self.ui_scenegraph
	local input_service = self:input_service()
	local _power_up_widgets = self._power_up_widgets
	local power_up_description = self._widgets_by_name.power_up_description
	local var_35_4
	local var_35_5

	if not (self._portrait_mode or allow_boon_removal) then
		power_up_description.content.visible = false
		self._current_power_up_name = nil

		return
	end

	local content = power_up_description.content
	local style = power_up_description.style
	local flag = false

	for i = 1, #_power_up_widgets do
		local var_35_9 = self._power_up_widgets[i]

		if not UIUtils.is_button_hover(var_35_9) then
			local scenegraph_id = var_35_9.scenegraph_id
			local get_world_position = UISceneGraph.get_world_position(ui_scenegraph, scenegraph_id)
			local offset = var_35_9.offset

			ui_scenegraph.power_up_description_root.local_position[1] = get_world_position[1] + offset[1]
			ui_scenegraph.power_up_description_root.local_position[2] = get_world_position[2] + offset[2]
			var_35_4 = var_35_9.content.power_up_name
			var_35_5 = var_35_9.content.power_up_rarity

			local locked = var_35_9.content.locked
			local locked_text_id = var_35_9.content.locked_text_id

			content.visible = true
			content.locked = locked
			content.locked_text_id = locked_text_id or content.locked_text_id
			flag = true

			if not locked then
				content.end_time = nil
				content.progress = nil
				content.input_made = false
				style.remove_frame.color[1] = 0

				break
			end

			if input_service:get("mouse_middle_press") or not input_service:get("special_1_press") then
				content.input_made = true
				style.remove_frame.color[1] = 0

				self:_play_sound("Play_gui_boon_removal_start")

				break
			end

			if not content.input_made and input_service:get("mouse_middle_held") and not input_service:get("special_1_hold") then
				local end_time = content.end_time

				end_time = end_time or arg_35_2 + content.remove_interaction_duration

				local num = (end_time - arg_35_2) / content.remove_interaction_duration

				style.remove_frame.color[1] = 255 * (1 - num)

				if not (num <= 0) then
					content.end_time = nil
					content.progress = nil
					content.input_made = false

					local get_deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()
					local local_player_id = Managers.player:local_player():local_player_id()

					self._force_update_power_ups = get_deus_run_controller:remove_power_ups(var_35_4, local_player_id)

					self:_play_sound("Play_gui_boon_removal_end")

					break
				end

				content.end_time = end_time
				content.progress = num

				break
			end

			if not content.input_made then
				self:_play_sound("Stop_gui_boon_removal_start")
			end

			content.end_time = nil
			content.progress = nil
			content.input_made = false
			style.remove_frame.color[1] = 0

			break
		end
	end

	if not flag then
		content.end_time = nil
		content.progress = nil
		content.input_made = false
		style.remove_frame.color[1] = 0
	end

	if var_35_4 ~= self._current_power_up_name then
		self:_populate_power_up(var_35_4, var_35_5, power_up_description)
	end

	self._current_power_up_name = var_35_4
end

DeusShopView._populate_power_up = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3)
	-- function 36
	if not arg_36_1 then
		arg_36_3.content.visible = false

		return
	end

	local var_36_0 = DeusPowerUps[arg_36_2][arg_36_1]
	local content = arg_36_3.content
	local local_player = Managers.player:local_player()
	local profile_index = local_player:profile_index()
	local career_index = local_player:career_index()
	local rarity = var_36_0.rarity

	content.title_text = DeusPowerUpUtils.get_power_up_name_text(var_36_0.name, var_36_0.talent_index, var_36_0.talent_tier, profile_index, career_index)
	content.rarity_text = Localize(RaritySettings[rarity].display_name)
	content.description_text = DeusPowerUpUtils.get_power_up_description(var_36_0, profile_index, career_index)
	content.icon = DeusPowerUpUtils.get_power_up_icon(var_36_0, profile_index, career_index)
	content.extend_left = false
	content.is_rectangular_icon = DeusPowerUpTemplates[var_36_0.name].rectangular_icon

	local style = arg_36_3.style
	local get_table = Colors.get_table(rarity)

	style.rarity_text.text_color = get_table
	arg_36_3.content.visible = true

	local var_36_8 = DeusPowerUpSetLookup[rarity]

	var_36_8 = not var_36_8 and DeusPowerUpSetLookup[rarity][var_36_0.name]

	local flag = false

	if not var_36_8 then
		local var_36_10 = var_36_8[1]
		local num = 0
		local pieces = var_36_10.pieces
		local get_deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()

		for i, v in ipairs(pieces) do
			local name = v.name
			local rarity_2 = v.rarity
			local get_own_peer_id = get_deus_run_controller:get_own_peer_id()

			if not get_deus_run_controller:has_power_up_by_name(get_own_peer_id, name, rarity_2) then
				num = num + 1
			end
		end

		flag = true

		local num_required_pieces = var_36_10.num_required_pieces

		num_required_pieces = num_required_pieces or #pieces
		content.set_progression = Localize("set_bonus_boons") .. " " .. string.format(Localize("set_counter_boons"), num, num_required_pieces)

		if #pieces == num then
			style.set_progression.text_color = style.set_progression.progression_colors.complete
		end
	end

	content.is_part_of_set = flag
end

DeusShopView._get_power_up_costs = function (arg_37_0, arg_37_1, arg_37_2)
	-- function 37
	local var_37_0 = DeusCostSettings.shop.power_ups[arg_37_1]

	var_37_0 = var_37_0 or 9001

	if not arg_37_2 then
		var_37_0 = var_37_0 - math.round(var_37_0 * arg_37_2)
	end

	return var_37_0
end

DeusShopView._play_sound = function (self, arg_38_1)
	-- function 38
	WwiseWorld.trigger_event(self._wwise_world, arg_38_1)
end

DeusShopView._update_player_data = function (self)
	-- function 39
	local tbl = {
		{}
	}
	local peer_id = Network.peer_id()
	local get_peers = self._deus_run_controller:get_peers()

	for i = 1, #get_peers do
		local var_39_3 = get_peers[i]
		local var_39_4

		if var_39_3 == peer_id then
			var_39_4 = tbl[1]
		else
			var_39_4 = {}
			tbl[#tbl + 1] = var_39_4
		end

		local get_player_profile, var_39_6 = self._deus_run_controller:get_player_profile(var_39_3, num_6)

		if not (get_player_profile == 0 or var_39_6 == 0) then
			var_39_4.profile_index = get_player_profile
			var_39_4.career_index = var_39_6
			var_39_4.level = self._deus_run_controller:get_player_level(var_39_3, var_39_4.profile_index)
			var_39_4.frame = self._deus_run_controller:get_player_frame(var_39_3, var_39_4.profile_index, var_39_4.career_index)
			var_39_4.name = self._deus_run_controller:get_player_name(var_39_3)

			local get_player_health_percentage = self._deus_run_controller:get_player_health_percentage(var_39_3, num_6)

			get_player_health_percentage = get_player_health_percentage or 1
			var_39_4.health_percentage = get_player_health_percentage
			var_39_4.healthkit_consumable = self._deus_run_controller:get_player_consumable_healthkit_slot(var_39_3, num_6)
			var_39_4.potion_consumable = self._deus_run_controller:get_player_consumable_potion_slot(var_39_3, num_6)
			var_39_4.grenade_consumable = self._deus_run_controller:get_player_consumable_grenade_slot(var_39_3, num_6)
			var_39_4.ammo_percentage = self._deus_run_controller:get_player_ranged_ammo(var_39_3, num_6)

			local get_player_soft_currency = self._deus_run_controller:get_player_soft_currency(var_39_3)

			get_player_soft_currency = get_player_soft_currency or 0
			var_39_4.soft_currency = get_player_soft_currency
			var_39_4.peer_state = self._shared_state:get_peer(var_39_3, self._shared_state:get_key("peer_state"))
		else
			var_39_4.profile_index = 0
			var_39_4.career_index = 0
			var_39_4.level = 1
			var_39_4.frame = "default"
			var_39_4.health_percentage = 1
			var_39_4.soft_currency = 0
		end
	end

	self:_update_player_portraits(tbl)
end

DeusShopView._update_portrait_frame = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
	-- function 40
	local deus_create_player_portraits_frame = UIWidgets.deus_create_player_portraits_frame("player_portrait_" .. arg_40_3, arg_40_1, arg_40_2, false)
	local var_40_1 = UIWidget.init(deus_create_player_portraits_frame)

	arg_40_0._portrait_frame_widgets[arg_40_3] = var_40_1
	arg_40_0._widgets_by_name["player_portrait_frame_" .. arg_40_3] = var_40_1
end

DeusShopView._update_blessing_portrait_frame = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4, arg_41_5, arg_41_6)
	-- function 41
	local create_blessing_portraits_frame = var_0_0.create_blessing_portraits_frame("blessing_root", arg_41_1, arg_41_2, false, arg_41_5)
	local var_41_1 = UIWidget.init(create_blessing_portraits_frame)

	var_41_1.content.is_bought = arg_41_6
	arg_41_0._blessing_frame_widgets[arg_41_4] = var_41_1
	arg_41_0._widgets_by_name[arg_41_3 .. "_portrait_frame_" .. arg_41_4] = var_41_1
end

DeusShopView._update_player_portraits = function (self, arg_42_1)
	-- function 42
	local _widgets_by_name = self._widgets_by_name
	local ready_button_tokens = _widgets_by_name.ready_button_tokens

	for i = 1, 4 do
		local var_42_2 = arg_42_1[i]
		local var_42_3 = _widgets_by_name["player_portrait_" .. i]
		local var_42_4 = _widgets_by_name["player_texts_" .. i]
		local var_42_5 = _widgets_by_name["player_portrait_frame_" .. i]
		local flag = not not var_42_2

		var_42_3.content.visible = flag
		var_42_4.content.visible = flag
		var_42_5.content.visible = flag

		local str = "token_icon_" .. i

		ready_button_tokens.content[str] = nil

		if not flag then
			local frame = var_42_2.frame

			frame = frame or "default"

			local level = var_42_2.level

			level = level or "-"

			if not (var_42_5.content.frame_settings_name ~= frame or var_42_5.content.level == level) then
				self:_update_portrait_frame(frame, level, i)

				var_42_5.content.level = level
			end

			local content = var_42_4.content
			local crop_text = UIRenderer.crop_text
			local name = var_42_2.name

			name = name or ""
			content.name_text = crop_text(name, 17)

			local content_2 = var_42_4.content
			local format = string.format
			local str_2 = "%d"
			local soft_currency = var_42_2.soft_currency

			soft_currency = soft_currency or 0
			content_2.coins_text = format(str_2, soft_currency)
			var_42_4.style.name_text.size[1] = 100
			var_42_4.style.name_text_shadow.size[1] = 100
			var_42_3.style.token_icon.saturated = var_42_2.peer_state == tbl_4.DONE_BUYING

			if not (not var_42_2.profile_index and var_42_2.profile_index == 0) then
				local var_42_17 = SPProfiles[var_42_2.profile_index]
				local var_42_18 = var_42_17.careers[var_42_2.career_index]

				var_42_3.content.character_portrait = var_42_18.portrait_image

				local hero_selection_image = var_42_17.hero_selection_image

				var_42_3.content.token_icon = var_42_17.hero_selection_image

				if var_42_2.peer_state == tbl_4.DONE_BUYING then
					ready_button_tokens.content[str] = hero_selection_image
				end
			else
				var_42_3.content.character_portrait = "unit_frame_portrait_default"
				var_42_3.content.token_icon = nil
			end

			local hp_bar = var_42_3.content.hp_bar
			local health_percentage = var_42_2.health_percentage

			health_percentage = health_percentage or 0
			hp_bar.bar_value = health_percentage

			local content_3 = var_42_3.content
			local ammo_percentage = var_42_2.ammo_percentage

			ammo_percentage = ammo_percentage or 0
			content_3.ammo_percentage = ammo_percentage

			local healthkit_consumable = var_42_2.healthkit_consumable

			var_42_3.content.healthkit_slot = not healthkit_consumable and ItemMasterList[healthkit_consumable].hud_icon
			var_42_3.style.healthkit_slot_bg.color = fn(healthkit_consumable)

			local potion_consumable = var_42_2.potion_consumable

			var_42_3.content.potion_slot = not potion_consumable and ItemMasterList[potion_consumable].hud_icon
			var_42_3.style.potion_slot_bg.color = fn(potion_consumable)

			local grenade_consumable = var_42_2.grenade_consumable

			var_42_3.content.grenade_slot = not grenade_consumable and ItemMasterList[grenade_consumable].hud_icon
			var_42_3.style.grenade_slot_bg.color = fn(grenade_consumable)
		end
	end
end

DeusShopView._are_all_peers_ready = function (self)
	-- function 43
	local get_own_peer_id = self._deus_run_controller:get_own_peer_id()

	for i, v in ipairs(self._deus_run_controller:get_peers()) do
		if get_own_peer_id ~= v then
			local get_key = self._shared_state:get_key("peer_state")

			if self._shared_state:get_peer(v, get_key) == tbl_4.READY_TO_BUY ~= true then
				return false
			end
		end
	end

	return true
end

DeusShopView._are_all_peers_done = function (self)
	-- function 44
	for i, v in ipairs(self._deus_run_controller:get_peers()) do
		local get_key = self._shared_state:get_key("peer_state")

		if self._shared_state:get_peer(v, get_key) == tbl_4.DONE_BUYING ~= true then
			return false
		end
	end

	return true
end

DeusShopView._did_someone_vote = function (self)
	-- function 45
	for i, v in ipairs(self._deus_run_controller:get_peers()) do
		local get_key = self._shared_state:get_key("peer_state")

		if self._shared_state:get_peer(v, get_key) == tbl_4.DONE_BUYING == true then
			return true
		end
	end

	return false
end

DeusShopView._animate_shop_item_widget = function (self, arg_46_1, arg_46_2)
	-- function 46
	local content = arg_46_2.content
	local style = arg_46_2.style
	local hotspot = content.hotspot

	hotspot = hotspot or content.button_hotspot

	local is_hover = hotspot.is_hover
	local is_bought = content.is_bought
	local is_held = hotspot.is_held
	local has_buying_animation_played = content.has_buying_animation_played
	local is_selected = hotspot.is_selected
	local hover_progress = hotspot.hover_progress

	hover_progress = hover_progress or 0

	local hover_progress_2 = hotspot.hover_progress

	hover_progress_2 = hover_progress_2 or 0

	local highlight_progress = hotspot.highlight_progress

	highlight_progress = highlight_progress or 0

	local selection_progress = hotspot.selection_progress

	selection_progress = selection_progress or 0

	local num = 15

	if not is_bought then
		is_hover = false
	end

	if not (not is_hover and is_held) then
		hover_progress = math.min(hover_progress + arg_46_1 * num, 1)
		hover_progress_2 = math.max(hover_progress - arg_46_1 * num, 1)
	elseif not is_hover and not is_held then
		hover_progress = math.max(hover_progress - arg_46_1 * num, 0)
		hover_progress_2 = math.max(hover_progress - arg_46_1 * num, 1)
	else
		hover_progress = math.max(hover_progress - arg_46_1 * num, 0)
		hover_progress_2 = math.max(hover_progress - arg_46_1 * num, 0)
	end

	style.icon_hover_frame.color[1] = 255 * hover_progress
	style.hover.color[1] = 255 * hover_progress_2

	if not is_bought then
		highlight_progress = math.min(highlight_progress + arg_46_1 * num, 1)
	else
		highlight_progress = math.max(highlight_progress - arg_46_1 * num, 0)
	end

	if not is_selected then
		selection_progress = math.min(selection_progress + arg_46_1 * num, 1)
	else
		selection_progress = math.max(selection_progress - arg_46_1 * num, 0)
	end

	if not (not is_bought and has_buying_animation_played) then
		self._ui_animator:start_animation("flash_icon", arg_46_2, var_0_0.scenegraph_definition)
	end

	if not (not is_bought and has_buying_animation_played) then
		self._ui_animator:start_animation("flash_icon", arg_46_2, var_0_0.scenegraph_definition)
	end

	if not (not is_bought and has_buying_animation_played) then
		self._ui_animator:start_animation("flash_icon", arg_46_2, var_0_0.scenegraph_definition)
	end

	if not content.bought_glow_style_ids then
		for i, v in ipairs(content.bought_glow_style_ids) do
			style[v].color[1] = 255 * highlight_progress
		end
	end

	local value_progress = hotspot.value_progress

	value_progress = value_progress or 0

	local max = math.max(value_progress - arg_46_1 * num, 0)

	if not style.icon_equipped_frame then
		style.icon_equipped_frame.color[1] = 255 * max
	end

	hotspot.value_progress = max
	hotspot.hover_progress = hover_progress
	hotspot.highlight_progress = highlight_progress
	hotspot.selection_progress = selection_progress
end

DeusShopView._draw = function (self, arg_47_1, arg_47_2)
	-- function 47
	for i, v in ipairs(self._shop_item_widgets) do
		self:_animate_shop_item_widget(arg_47_1, v)
	end

	local _widgets_by_name = self._widgets_by_name

	UIWidgetUtils.animate_default_button(_widgets_by_name.ready_button, arg_47_1)

	local ui_scenegraph = self.ui_scenegraph
	local get_service = self._input_manager:get_service(self._input_service_name)
	local render_settings = self.render_settings

	if not self._render_top_widgets then
		local ui_top_renderer = self.ui_top_renderer
		local _top_widgets = self._top_widgets

		UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, get_service, arg_47_1, nil, render_settings)

		for k = 1, #_top_widgets do
			UIRenderer.draw_widget(ui_top_renderer, _top_widgets[k])
		end

		UIRenderer.end_pass(ui_top_renderer)
	end

	local ui_renderer = self.ui_renderer

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_47_1, nil, render_settings)

	if not self._background_unit_widget then
		UIRenderer.draw_widget(ui_renderer, self._background_unit_widget)
	end

	local snap_pixel_positions = render_settings.snap_pixel_positions
	local _widgets = self._widgets

	for l = 1, #_widgets do
		local var_47_9 = _widgets[l]

		if var_47_9.snap_pixel_positions ~= nil then
			render_settings.snap_pixel_positions = var_47_9.snap_pixel_positions
		end

		UIRenderer.draw_widget(ui_renderer, var_47_9)

		render_settings.snap_pixel_positions = snap_pixel_positions
	end

	local _portrait_frame_widgets = self._portrait_frame_widgets

	UIRenderer.draw_all_widgets(ui_renderer, _portrait_frame_widgets)

	local _blessing_frame_widgets = self._blessing_frame_widgets

	UIRenderer.draw_all_widgets(ui_renderer, _blessing_frame_widgets)
	self:_draw_boons(arg_47_1, arg_47_2)
	UIRenderer.end_pass(ui_renderer)

	if not (not self._scrollbar_ui and self._portrait_mode) then
		self._scrollbar_ui:update(arg_47_1, arg_47_2, ui_renderer, get_service, render_settings)
	end
end

DeusShopView._draw_boons = function (self, arg_48_1, arg_48_2)
	-- function 48
	local ui_scenegraph = self.ui_scenegraph
	local ui_renderer = self.ui_renderer
	local str = "own_power_up_anchor"
	local str_2 = "own_power_up_window"
	local get_world_position = UISceneGraph.get_world_position(ui_scenegraph, str)
	local get_world_position_2 = UISceneGraph.get_world_position(ui_scenegraph, str_2)
	local var_48_6 = ui_scenegraph[str_2].size[2]
	local _power_up_widgets = self._power_up_widgets

	for i = 1, #_power_up_widgets do
		local var_48_8 = _power_up_widgets[i]
		local offset = var_48_8.offset
		local num = get_world_position[2] + offset[2]
		local var_48_11 = var_0_0.power_up_widget_size[2]

		if num - var_48_11 > get_world_position_2[2] + var_48_6 then
			-- Nothing
		elseif num + var_48_11 < get_world_position_2[2] then
			break
		else
			UIRenderer.draw_widget(ui_renderer, var_48_8)
		end
	end
end

DeusShopView._create_unit_previewer = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3)
	-- function 49
	local var_49_0 = arg_49_1.element.pass_data[1]
	local viewport = var_49_0.viewport
	local world = var_49_0.world

	World.set_data(world, "avoid_blend", true)

	local tbl = {
		0.15,
		2.5,
		-0.5
	}
	local var_49_4 = UIUnitPreviewer:new(arg_49_2, arg_49_3, tbl, world, viewport)

	var_49_4:activate_auto_spin()

	return var_49_4
end

DeusShopView._create_background_unit_definition = function (arg_50_0)
	-- function 50
	local str = "environment/ui_weave_forge_preview"

	return {
		scenegraph_id = "background_unit",
		element = UIElements.Viewport,
		style = {
			viewport = {
				layer = 840,
				world_name = "item_preview",
				viewport_type = "default_forward",
				viewport_name = "item_preview_viewport",
				enable_sub_gui = false,
				fov = 20,
				shading_environment = str,
				camera_position = {
					0,
					0,
					0
				},
				camera_lookat = {
					0,
					0,
					0
				}
			}
		},
		content = {
			button_hotspot = {
				allow_multi_hover = true
			}
		}
	}
end

DeusShopView._update_hold_text = function (self)
	-- function 51
	local text = self._widgets_by_name.hold_to_buy_text.style.text
	local num = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5

	text.text_color[1] = 100 + 155 * num
end

DeusShopView._update_input_helper_text = function (self)
	-- function 52
	local num = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5
	local _widgets_by_name = self._widgets_by_name
	local portrait_input_helper_text = _widgets_by_name.portrait_input_helper_text
	local text = portrait_input_helper_text.style.text
	local boon_input_helper_text = _widgets_by_name.boon_input_helper_text
	local text_2 = boon_input_helper_text.style.text

	text.text_color[1] = 100 + 155 * num
	text_2.text_color[1] = 100 + 155 * num
	portrait_input_helper_text.content.visible = not self._portrait_mode
	boon_input_helper_text.content.visible = self._portrait_mode
end

DeusShopView._update_background_animations = function (self, arg_53_1)
	-- function 53
	local _widgets_by_name = self._widgets_by_name

	for i = 1, 3 do
		local var_53_1 = _widgets_by_name["background_wheel_0" .. i]
		local angle = var_53_1.style.texture_id.angle
		local num = 0
		local var_53_4
		local flag

		flag = (i ~= 1 or not 0.2 or i ~= 2) and (not -0.1 or 0.05)

		local num_2 = angle + arg_53_1 * flag

		var_53_1.style.texture_id.angle = num_2
	end
end

DeusShopView.on_ingame_menu_opened = function (self)
	-- function 54
	self._render_top_widgets = false

	Managers.input:disable_gamepad_cursor()
end

DeusShopView.on_ingame_menu_closed = function (self)
	-- function 55
	self._render_top_widgets = true

	Managers.input:enable_gamepad_cursor()
end
