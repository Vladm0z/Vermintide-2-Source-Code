-- chunkname: @scripts/ui/hud_ui/news_feed_ui.lua

require("scripts/settings/news_feed_templates")

local var_0_0 = local_require("scripts/ui/hud_ui/news_feed_ui_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = 0.8
local var_0_3 = 0.6
local var_0_4 = 0.6
local var_0_5 = 1.5
local var_0_6 = 10
local var_0_7 = "exit"
local var_0_8 = "enter"
local var_0_9 = var_0_0.MAX_NUMBER_OF_NEWS
local var_0_10 = var_0_0.WIDGET_SIZE
local var_0_11 = var_0_0.NEWS_SPACING

NewsFeedUI = class(NewsFeedUI)

function NewsFeedUI.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0.ui_renderer = arg_1_2.ui_renderer
	arg_1_0.ingame_ui = arg_1_2.ingame_ui
	arg_1_0.input_manager = arg_1_2.input_manager
	arg_1_0.peer_id = arg_1_2.peer_id
	arg_1_0.player_manager = arg_1_2.player_manager
	arg_1_0.ui_animations = {}
	arg_1_0.is_in_inn = arg_1_2.is_in_inn

	arg_1_0:_create_ui_elements()
end

function NewsFeedUI._create_ui_elements(arg_2_0)
	arg_2_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)

	local var_2_0 = {}
	local var_2_1 = {}

	for iter_2_0, iter_2_1 in ipairs(var_0_0.buff_widget_definitions) do
		var_2_0[iter_2_0] = UIWidget.init(iter_2_1)
		var_2_1[iter_2_0] = var_2_0[iter_2_0]
	end

	arg_2_0._news_widgets = var_2_0
	arg_2_0._unused_news_widgets = var_2_1
	arg_2_0._active_news = {}
	arg_2_0.conditions_params = {
		rarities_to_ignore = table.enum_safe("magic")
	}
	arg_2_0.templates_on_cooldown = {}
	arg_2_0.feed_sync_delay = var_0_5

	UIRenderer.clear_scenegraph_queue(arg_2_0.ui_renderer)
	arg_2_0:set_visible(true)
end

local var_0_12 = {}
local var_0_13 = {}

function NewsFeedUI._sync_news(arg_3_0, arg_3_1, arg_3_2)
	if not arg_3_0.is_in_inn then
		return
	end

	local var_3_0 = arg_3_0.feed_sync_delay

	if var_3_0 then
		local var_3_1 = math.max(0, var_3_0 - arg_3_1)

		if var_3_1 == 0 then
			arg_3_0.feed_sync_delay = nil
		else
			arg_3_0.feed_sync_delay = var_3_1
		end

		return
	end

	local var_3_2 = arg_3_0.templates_on_cooldown

	for iter_3_0, iter_3_1 in pairs(var_3_2) do
		if iter_3_1 > 0 then
			iter_3_1 = math.max(0, iter_3_1 - arg_3_1)

			if iter_3_1 == 0 then
				var_3_2[iter_3_0] = nil
			else
				var_3_2[iter_3_0] = iter_3_1
			end
		end
	end

	local var_3_3 = Managers.player:local_player(1)
	local var_3_4 = var_3_3.player_unit
	local var_3_5 = arg_3_0.conditions_params

	if var_3_4 then
		local var_3_6 = var_3_3:profile_display_name()
		local var_3_7 = var_3_3:career_name()

		if var_3_5.hero_name ~= var_3_6 or var_3_5.career_name ~= var_3_7 then
			while #arg_3_0._active_news > 0 do
				arg_3_0:_remove_entry(1)
			end
		end

		var_3_5.hero_name = var_3_6
		var_3_5.career_name = var_3_7
	else
		return
	end

	local var_3_8 = arg_3_0._active_news
	local var_3_9 = Managers.player:local_player(1).player_unit
	local var_3_10 = NewsFeedTemplates

	if var_3_9 then
		table.clear(var_0_13)

		for iter_3_2 = 1, #var_3_8 do
			var_3_8[iter_3_2].verified = false
		end

		local var_3_11 = false

		for iter_3_3, iter_3_4 in ipairs(var_3_10) do
			local var_3_12 = iter_3_4.name
			local var_3_13 = iter_3_4.condition_func

			if not var_3_2[var_3_12] and (var_3_13(var_3_5) or script_data.show_all_news_feed_items) then
				local var_3_14 = false

				for iter_3_5 = 1, #var_3_8 do
					local var_3_15 = var_3_8[iter_3_5]

					if var_3_15.name == var_3_12 then
						var_3_15.verified = true
						var_3_14 = true

						break
					end
				end

				if not var_3_14 and not var_3_11 then
					var_0_13[#var_0_13 + 1] = var_3_12
					var_3_11 = true
				end
			end
		end

		table.clear(var_0_12)

		for iter_3_6, iter_3_7 in ripairs(var_3_8) do
			if not iter_3_7.verified then
				var_0_12[#var_0_12 + 1] = iter_3_6
			end
		end

		for iter_3_8 = 1, #var_0_12 do
			local var_3_16 = var_0_12[iter_3_8]

			arg_3_0:_mark_entry_for_removal(var_3_16)
		end

		local var_3_17 = false

		for iter_3_9, iter_3_10 in ipairs(var_3_10) do
			for iter_3_11, iter_3_12 in ipairs(var_0_13) do
				if iter_3_12 == iter_3_10.name and arg_3_0:_add_entry(iter_3_10) then
					var_3_17 = true
				end
			end
		end

		if var_3_17 then
			arg_3_0:_update_alignment_duration()

			arg_3_0.feed_sync_delay = var_0_5
		else
			arg_3_0.feed_sync_delay = var_0_6
		end
	end
end

function NewsFeedUI._add_entry(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_1.name
	local var_4_1 = arg_4_1.hidden
	local var_4_2 = arg_4_1.duration
	local var_4_3 = arg_4_1.cooldown
	local var_4_4 = arg_4_1.infinite
	local var_4_5 = arg_4_1.title
	local var_4_6 = arg_4_1.description
	local var_4_7 = arg_4_1.icon
	local var_4_8 = arg_4_1.icon_offset
	local var_4_9 = arg_4_1.icon_size
	local var_4_10 = arg_4_0._unused_news_widgets

	if #arg_4_0._active_news >= var_0_9 then
		return false
	end

	local var_4_11 = {
		state = "enter",
		name = var_4_0,
		duration = var_4_2,
		cooldown = var_4_3,
		infinite = var_4_4,
		anim_duration = var_0_3,
		removed_func = arg_4_1.removed_func
	}
	local var_4_12 = arg_4_0._active_news

	var_4_12[#var_4_12 + 1] = var_4_11

	local var_4_13 = #arg_4_0._active_news

	if not var_4_1 then
		local var_4_14 = table.remove(var_4_10, 1)
		local var_4_15 = var_4_14.content
		local var_4_16 = var_4_14.style

		var_4_11.widget = var_4_14
		var_4_15.title_text = Localize(var_4_5)
		var_4_15.text = Localize(var_4_6)
		var_4_15.is_infinite = var_4_4
		var_4_15.icon = var_4_7
		var_4_16.icon.texture_size = var_4_9
		var_4_16.icon.offset = var_4_8

		local var_4_17 = var_0_10[2] + var_0_11
		local var_4_18 = var_4_14.offset

		if var_4_13 > 1 then
			var_4_18[2] = var_4_12[var_4_13 - 1].widget.offset[2] - var_4_17
		else
			var_4_18[2] = 0
		end
	end

	if arg_4_1.added_func then
		arg_4_1.added_func()
	end

	return true
end

function NewsFeedUI._update_alignment_duration(arg_5_0)
	arg_5_0._alignment_duration = var_0_2

	for iter_5_0, iter_5_1 in ipairs(arg_5_0._active_news) do
		local var_5_0 = iter_5_1.widget

		if var_5_0 then
			iter_5_1.current_position = var_5_0.offset[2]
		end
	end
end

function NewsFeedUI._update_entries_expire_time(arg_6_0, arg_6_1, arg_6_2)
	for iter_6_0, iter_6_1 in ipairs(arg_6_0._active_news) do
		local var_6_0 = iter_6_1.duration

		if var_6_0 then
			local var_6_1 = math.max(0, var_6_0 - arg_6_1)

			if var_6_1 == 0 then
				iter_6_1.duration = nil

				arg_6_0:_mark_entry_for_removal(iter_6_0)
			else
				iter_6_1.duration = var_6_1
			end
		end
	end
end

function NewsFeedUI._mark_entry_for_removal(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._active_news[arg_7_1]

	if var_7_0.state ~= var_0_7 then
		var_7_0.state = var_0_7
		var_7_0.anim_duration = var_0_4
	end
end

function NewsFeedUI._remove_entry(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._active_news
	local var_8_1 = table.remove(var_8_0, arg_8_1)
	local var_8_2 = var_8_1.widget

	if var_8_2 then
		local var_8_3 = arg_8_0._unused_news_widgets

		table.insert(var_8_3, #var_8_3 + 1, var_8_2)
	end

	arg_8_0:_update_alignment_duration()

	local var_8_4 = var_8_1.name
	local var_8_5 = var_8_1.cooldown

	arg_8_0.templates_on_cooldown[var_8_4] = var_8_5

	local var_8_6 = var_8_1.removed_func

	if var_8_6 then
		var_8_6()
	end
end

function NewsFeedUI._update_alignment(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0._alignment_duration

	if not var_9_0 then
		return
	end

	local var_9_1 = math.max(var_9_0 - arg_9_1, 0)
	local var_9_2 = var_9_1 / var_0_2
	local var_9_3 = math.easeCubic(var_9_2)

	if var_9_2 == 1 then
		arg_9_0._alignment_duration = nil
	else
		arg_9_0._alignment_duration = var_9_1
	end

	local var_9_4 = var_0_10[2] + var_0_11
	local var_9_5 = 0

	for iter_9_0, iter_9_1 in ipairs(arg_9_0._active_news) do
		local var_9_6 = iter_9_1.widget

		if var_9_6 then
			local var_9_7 = var_9_6.offset
			local var_9_8 = iter_9_1.current_position

			var_9_7[2] = var_9_8 - (var_9_8 - var_9_5) * (1 - var_9_3)
			var_9_5 = var_9_5 - var_9_4
		end
	end
end

function NewsFeedUI._update_state_animations(arg_10_0, arg_10_1)
	local var_10_0 = var_0_10[2] + var_0_11
	local var_10_1 = 0
	local var_10_2 = arg_10_0._active_news

	for iter_10_0, iter_10_1 in ipairs(var_10_2) do
		local var_10_3 = false
		local var_10_4 = iter_10_1.state
		local var_10_5 = iter_10_1.anim_duration

		if var_10_5 then
			local var_10_6 = math.max(var_10_5 - arg_10_1, 0)
			local var_10_7 = 0

			if var_10_4 == var_0_8 then
				var_10_7 = 1 - var_10_6 / var_0_3

				if var_10_7 == 1 then
					iter_10_1.anim_duration = nil
				else
					iter_10_1.anim_duration = var_10_6
				end
			elseif var_10_4 == var_0_7 then
				var_10_7 = var_10_6 / var_0_3

				if var_10_7 == 0 then
					iter_10_1.anim_duration = nil
					var_10_3 = true
				else
					iter_10_1.anim_duration = var_10_6
				end
			end

			if not var_10_3 then
				local var_10_8 = iter_10_1.widget

				if var_10_8 then
					arg_10_0:_animate_widget(var_10_8, var_10_4, var_10_7)
				end
			else
				iter_10_1.delete = var_10_3
			end
		end
	end

	for iter_10_2, iter_10_3 in ripairs(var_10_2) do
		if iter_10_3.delete then
			arg_10_0:_remove_entry(iter_10_2)
		end
	end
end

function NewsFeedUI._animate_widget(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = arg_11_1.offset
	local var_11_1 = arg_11_1.style
	local var_11_2 = 0

	if arg_11_2 == var_0_8 then
		var_11_2 = math.easeCubic(math.min(arg_11_3 * 2, 1))
	else
		var_11_2 = math.easeCubic(arg_11_3)
	end

	var_11_0[1] = 100 - var_11_2 * 100

	local var_11_3 = var_11_2 * 255

	var_11_1.text.text_color[1] = var_11_3
	var_11_1.text_shadow.text_color[1] = var_11_3
	var_11_1.title_text.text_color[1] = var_11_3
	var_11_1.title_text_shadow.text_color[1] = var_11_3
	var_11_1.background.color[1] = var_11_3
	var_11_1.icon.color[1] = var_11_3

	local var_11_4 = var_11_1.effect
	local var_11_5 = var_11_4.color

	if arg_11_2 == var_0_8 then
		var_11_5[1] = math.ease_pulse(arg_11_3) * 255
		var_11_4.offset[1] = 120 - var_11_0[1]

		local var_11_6 = 75
		local var_11_7 = math.easeCubic(arg_11_3)

		var_11_4.angle = math.degrees_to_radians(var_11_6 * var_11_7)
	elseif var_11_3 < var_11_5[1] then
		var_11_5[1] = var_11_3
	end
end

function NewsFeedUI.set_position(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0.ui_scenegraph.pivot.local_position

	var_12_0[1] = arg_12_1
	var_12_0[2] = arg_12_2
end

function NewsFeedUI.destroy(arg_13_0)
	arg_13_0:set_visible(false)
end

function NewsFeedUI.set_visible(arg_14_0, arg_14_1)
	arg_14_0._is_visible = arg_14_1

	local var_14_0 = arg_14_0.ui_renderer
end

function NewsFeedUI.update(arg_15_0, arg_15_1, arg_15_2)
	if not arg_15_0._is_visible then
		return
	end

	arg_15_0:_sync_news(arg_15_1, arg_15_2)
	arg_15_0:_update_state_animations(arg_15_1)
	arg_15_0:_update_alignment(arg_15_1)
	arg_15_0:_handle_resolution_modified()
	arg_15_0:_update_entries_expire_time(arg_15_1, arg_15_2)
	arg_15_0:draw(arg_15_1)
end

function NewsFeedUI._handle_resolution_modified(arg_16_0)
	if RESOLUTION_LOOKUP.modified then
		arg_16_0:_on_resolution_modified()
	end
end

function NewsFeedUI._on_resolution_modified(arg_17_0)
	return
end

function NewsFeedUI.draw(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0.ui_renderer
	local var_18_1 = arg_18_0.ui_scenegraph
	local var_18_2 = arg_18_0.input_manager:get_service("ingame_menu")

	UIRenderer.begin_pass(var_18_0, var_18_1, var_18_2, arg_18_1)

	local var_18_3 = arg_18_0._active_news

	for iter_18_0 = 1, #var_18_3 do
		local var_18_4 = var_18_3[iter_18_0].widget

		if var_18_4 then
			UIRenderer.draw_widget(var_18_0, var_18_4)
		end
	end

	UIRenderer.end_pass(var_18_0)
end
