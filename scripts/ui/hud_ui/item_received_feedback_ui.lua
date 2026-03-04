-- chunkname: @scripts/ui/hud_ui/item_received_feedback_ui.lua

require("scripts/settings/ui_player_portrait_frame_settings")

local var_0_0 = local_require("scripts/ui/hud_ui/item_received_feedback_ui_definitions")
local var_0_1 = var_0_0.MAX_NUMBER_OF_MESSAGES
local var_0_2 = {
	give_item = {
		text_function = function (arg_1_0, arg_1_1, arg_1_2)
			if arg_1_0 > 1 then
				return string.format(Localize("positive_reinforcement_player_gave_item_player_multiple"), arg_1_1, arg_1_2, arg_1_0)
			else
				return string.format(Localize("positive_reinforcement_player_gave_item_player"), arg_1_1, arg_1_2)
			end
		end,
		sound_function = function ()
			return script_data.reinforcement_ui_local_sound or "hud_achievement_unlock_02" or script_data.enable_reinforcement_ui_remote_sound and "hud_info"
		end,
		icon_function = function (arg_3_0, arg_3_1)
			return arg_3_0, arg_3_1
		end
	}
}
local var_0_3 = {
	fade_to = Colors.get_table("white"),
	default = Colors.get_table("cheeseburger"),
	kill = Colors.get_table("red"),
	personal = Colors.get_table("dodger_blue")
}
local var_0_4 = {
	healthkit_first_aid_kit_01 = "reinforcement_heal",
	grenade_fire_02 = "killfeed_icon_09",
	potion_healing_draught_01 = "killfeed_icon_06",
	grenade_frag_02 = "killfeed_icon_05",
	grenade_fire_01 = "killfeed_icon_09",
	grenade_frag_01 = "killfeed_icon_05",
	grenade_engineer = "killfeed_icon_05",
	potion_cooldown_reduction_01 = "killfeed_icon_13",
	potion_damage_boost_01 = "killfeed_icon_10",
	potion_speed_boost_01 = "killfeed_icon_04"
}

ItemReceivedFeedbackUI = class(ItemReceivedFeedbackUI)

ItemReceivedFeedbackUI.init = function (arg_4_0, arg_4_1, arg_4_2)
	arg_4_0._parent = arg_4_1
	arg_4_0.ui_renderer = arg_4_2.ui_renderer
	arg_4_0.input_manager = arg_4_2.input_manager
	arg_4_0.player_manager = arg_4_2.player_manager
	arg_4_0.peer_id = arg_4_2.peer_id
	arg_4_0.world = arg_4_2.world_manager:world("level_world")
	arg_4_0.render_settings = {
		snap_pixel_positions = true
	}

	arg_4_0:create_ui_elements()

	arg_4_0._received_events = {}
	arg_4_0._hash_order = {}
	arg_4_0._hash_widget_lookup = {}
	arg_4_0._animations = {}

	Managers.state.event:register(arg_4_0, "give_item_feedback", "event_give_item_feedback")
end

ItemReceivedFeedbackUI.destroy = function (arg_5_0)
	GarbageLeakDetector.register_object(arg_5_0, "item_received_feedback_ui")
	Managers.state.event:unregister("give_item_feedback", arg_5_0)
end

ItemReceivedFeedbackUI.create_ui_elements = function (arg_6_0)
	UIRenderer.clear_scenegraph_queue(arg_6_0.ui_renderer)

	arg_6_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	arg_6_0.message_widgets = {}
	arg_6_0._unused_widgets = {}

	local var_6_0 = 0

	for iter_6_0, iter_6_1 in pairs(var_0_0.message_widgets) do
		var_6_0 = var_6_0 + 1
		arg_6_0.message_widgets[var_6_0] = UIWidget.init(iter_6_1)
		arg_6_0._unused_widgets[var_6_0] = UIWidget.init(iter_6_1)
	end
end

ItemReceivedFeedbackUI.remove_event = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._received_events
	local var_7_1 = table.remove(var_7_0, arg_7_1).widget
	local var_7_2 = arg_7_0._unused_widgets

	var_7_2[#var_7_2 + 1] = var_7_1
end

ItemReceivedFeedbackUI.add_event = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, ...)
	if not script_data.disable_reinforcement_ui then
		local var_8_0 = arg_8_0._received_events
		local var_8_1 = arg_8_1 .. arg_8_3
		local var_8_2 = arg_8_0._hash_order
		local var_8_3 = Managers.time:time("game")
		local var_8_4 = UISettings.positive_reinforcement.increment_duration
		local var_8_5 = arg_8_0.message_widgets
		local var_8_6 = arg_8_0._unused_widgets

		if #var_8_6 == 0 then
			arg_8_0:remove_event(#var_8_0)
		end

		local var_8_7 = var_0_2[arg_8_3]
		local var_8_8 = table.remove(var_8_6, 1)
		local var_8_9 = var_8_8.offset
		local var_8_10 = {
			text = "",
			shown_amount = 0,
			amount = 0,
			widget = var_8_8,
			event_type = arg_8_3,
			next_increment = var_8_3 - var_8_4,
			data = {
				...
			}
		}
		local var_8_11 = #var_8_0 + 1

		table.insert(var_8_0, 1, var_8_10)

		local var_8_12 = var_8_8.content
		local var_8_13 = var_8_8.style
		local var_8_14, var_8_15 = var_8_7.icon_function(...)

		arg_8_0:_assign_portrait_texture(var_8_8, "portrait_1", var_8_14)

		var_8_12.icon = var_8_15
		var_8_9[2] = 0
		var_8_9[1] = 0

		local var_8_16 = var_8_12.text_style_ids

		for iter_8_0, iter_8_1 in ipairs(var_8_16) do
			var_8_13[iter_8_1].color[1] = 255
		end

		local var_8_17 = var_8_7.sound_function()

		if var_8_17 then
			local var_8_18 = arg_8_0.world
			local var_8_19 = Managers.world:wwise_world(var_8_18)

			WwiseWorld.trigger_event(var_8_19, var_8_17)
		end
	end
end

local var_0_5 = {
	96,
	112
}

ItemReceivedFeedbackUI._assign_portrait_texture = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	arg_9_1.content[arg_9_2].texture_id = arg_9_3

	local var_9_0 = table.clone(var_0_5)

	if UIAtlasHelper.has_atlas_settings_by_texture_name(arg_9_3) then
		local var_9_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_9_3)

		var_9_0[1] = var_9_1.size[1]
		var_9_0[2] = var_9_1.size[2]
	end

	local var_9_2 = arg_9_1.style[arg_9_2]
	local var_9_3 = var_9_2.portrait_offset
	local var_9_4 = var_9_2.offset

	var_9_4[1] = var_9_3[1] - var_9_0[1] / 2
	var_9_4[2] = var_9_3[2] - var_9_0[2] / 2
	var_9_2.size = var_9_0
end

ItemReceivedFeedbackUI.event_give_item_feedback = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if not arg_10_2 or not arg_10_2:name() then
		local var_10_0
	end

	local var_10_1 = arg_10_2 and arg_10_2.player_unit
	local var_10_2 = Unit.alive(var_10_1) and ScriptUnit.extension(var_10_1, "career_system")
	local var_10_3 = var_10_2 and var_10_2:career_index() or arg_10_2 and arg_10_2:profile_index()
	local var_10_4 = arg_10_2 and arg_10_2:profile_index() or nil
	local var_10_5 = var_10_4 and var_10_3 and arg_10_0:_get_hero_portrait(var_10_4, var_10_3)
	local var_10_6 = ItemMasterList[arg_10_3]
	local var_10_7 = var_10_6 and var_10_6.item_received_icon
	local var_10_8 = var_0_4[arg_10_3] or var_10_7 or "icons_placeholder"

	arg_10_0:add_event(arg_10_1, var_0_3.default, "give_item", var_10_5, var_10_8)
end

ItemReceivedFeedbackUI._get_hero_portrait = function (arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = RESOLUTION_LOOKUP.scale
	local var_11_1 = SPProfiles[arg_11_1]
	local var_11_2 = var_11_1.careers[arg_11_2]
	local var_11_3 = var_11_1.display_name
	local var_11_4 = var_11_2.portrait_image

	return "small_" .. var_11_4
end

local var_0_6 = {
	root_scenegraph_id = "message_animated",
	label = "Item received",
	registry_key = "item_received",
	drag_scenegraph_id = "message_animated_dragger"
}

ItemReceivedFeedbackUI.update = function (arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0.ui_renderer
	local var_12_1 = arg_12_0.ui_scenegraph
	local var_12_2 = arg_12_0.input_manager:get_service("Player")
	local var_12_3 = arg_12_0.render_settings

	if HudCustomizer.run(var_12_0, var_12_1, var_0_6) then
		UISceneGraph.update_scenegraph(var_12_1)
	end

	for iter_12_0, iter_12_1 in pairs(arg_12_0._animations) do
		if arg_12_0._animations[iter_12_0] then
			if not UIAnimation.completed(iter_12_1) then
				UIAnimation.update(iter_12_1, arg_12_1)
			else
				arg_12_0._animations[iter_12_0] = nil
			end
		end
	end

	UIRenderer.begin_pass(var_12_0, var_12_1, var_12_2, arg_12_1, nil, var_12_3)

	local var_12_4 = arg_12_0._received_events
	local var_12_5 = 2
	local var_12_6 = 2.5

	for iter_12_2, iter_12_3 in ipairs(var_12_4) do
		local var_12_7 = var_12_3.snap_pixel_positions
		local var_12_8 = iter_12_3.widget
		local var_12_9 = var_12_8.content
		local var_12_10 = var_12_8.style
		local var_12_11 = var_12_8.offset
		local var_12_12 = iter_12_3.event_type
		local var_12_13 = var_0_2[var_12_12]
		local var_12_14 = false

		if not iter_12_3.remove_time then
			iter_12_3.remove_time = arg_12_2 + var_12_6
		elseif arg_12_2 > iter_12_3.remove_time then
			arg_12_0:remove_event(iter_12_2)

			var_12_14 = true
		end

		if not var_12_14 then
			local var_12_15 = 70
			local var_12_16 = (iter_12_2 - 1) * var_12_15
			local var_12_17 = math.abs(math.abs(var_12_11[2]) - math.abs(var_12_16))
			local var_12_18 = iter_12_3.remove_time - arg_12_2
			local var_12_19 = 0.3
			local var_12_20 = 0

			if var_12_19 < var_12_18 then
				var_12_20 = math.clamp((var_12_6 - var_12_18) / var_12_19, 0, 1)
			else
				var_12_20 = math.clamp(var_12_18 / var_12_19, 0, 1)
			end

			local var_12_21 = math.max(var_12_18 - (var_12_6 - var_12_5), 0)
			local var_12_22 = 1 - math.clamp(var_12_21 / var_12_5, 0, 1)

			var_12_11[1] = 50 * math.easeOutCubic(var_12_22)
			var_12_10.arrow.offset[1] = 35 * math.easeOutCubic(var_12_22)
			var_12_10.icon.offset[1] = 80 * math.easeOutCubic(var_12_22)

			local var_12_23 = 255 * math.easeOutCubic(var_12_20)
			local var_12_24 = var_12_9.text_style_ids

			for iter_12_4, iter_12_5 in ipairs(var_12_24) do
				var_12_10[iter_12_5].color[1] = var_12_23
			end

			var_12_3.snap_pixel_positions = var_12_21 == 0

			UIRenderer.draw_widget(var_12_0, var_12_8)
		end

		var_12_3.snap_pixel_positions = var_12_7
	end

	UIRenderer.end_pass(var_12_0)
end
