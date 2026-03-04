-- chunkname: @scripts/ui/views/voice_chat_ui.lua

VoiceChatUI = class(VoiceChatUI)

local var_0_0 = true
local var_0_1 = 4
local var_0_2 = 16
local var_0_3 = {
	root = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.chat
		}
	},
	icon_slot_1 = {
		vertical_alignment = "top",
		parent = "root",
		horizontal_alignment = "left",
		size = {
			24,
			25
		},
		position = {
			140,
			-54,
			1
		}
	},
	icon_slot_2 = {
		vertical_alignment = "bottom",
		parent = "icon_slot_1",
		horizontal_alignment = "center",
		size = {
			24,
			25
		},
		position = {
			0,
			-30,
			0
		}
	},
	icon_slot_3 = {
		vertical_alignment = "bottom",
		parent = "icon_slot_2",
		horizontal_alignment = "center",
		size = {
			24,
			25
		},
		position = {
			0,
			-30,
			0
		}
	},
	icon_slot_4 = {
		vertical_alignment = "bottom",
		parent = "icon_slot_3",
		horizontal_alignment = "center",
		size = {
			24,
			25
		},
		position = {
			0,
			-30,
			0
		}
	},
	name_slot_1 = {
		vertical_alignment = "center",
		parent = "icon_slot_1",
		horizontal_alignment = "left",
		size = {
			400,
			24
		},
		position = {
			25,
			0,
			0
		}
	},
	name_slot_2 = {
		vertical_alignment = "center",
		parent = "icon_slot_2",
		horizontal_alignment = "left",
		size = {
			400,
			24
		},
		position = {
			25,
			0,
			0
		}
	},
	name_slot_3 = {
		vertical_alignment = "center",
		parent = "icon_slot_3",
		horizontal_alignment = "left",
		size = {
			400,
			24
		},
		position = {
			25,
			0,
			0
		}
	},
	name_slot_4 = {
		vertical_alignment = "center",
		parent = "icon_slot_4",
		horizontal_alignment = "left",
		size = {
			400,
			24
		},
		position = {
			25,
			0,
			0
		}
	},
	bg_slot_1 = {
		vertical_alignment = "center",
		parent = "icon_slot_1",
		horizontal_alignment = "left",
		size = {
			250,
			25
		},
		position = {
			-5,
			0,
			-1
		}
	},
	bg_slot_2 = {
		vertical_alignment = "center",
		parent = "icon_slot_2",
		horizontal_alignment = "left",
		size = {
			250,
			25
		},
		position = {
			-5,
			0,
			-1
		}
	},
	bg_slot_3 = {
		vertical_alignment = "center",
		parent = "icon_slot_3",
		horizontal_alignment = "left",
		size = {
			250,
			25
		},
		position = {
			-5,
			0,
			-1
		}
	},
	bg_slot_4 = {
		vertical_alignment = "center",
		parent = "icon_slot_4",
		horizontal_alignment = "left",
		size = {
			250,
			25
		},
		position = {
			-5,
			0,
			-1
		}
	}
}

if not IS_WINDOWS then
	var_0_3.root.scale = "hud_fit"
	var_0_3.root.is_root = false
end

local var_0_4 = {
	UIWidgets.create_simple_texture("voice_chat_icon_01", "icon_slot_1", false, var_0_0),
	UIWidgets.create_simple_texture("voice_chat_icon_01", "icon_slot_2", false, var_0_0),
	UIWidgets.create_simple_texture("voice_chat_icon_01", "icon_slot_3", false, var_0_0),
	UIWidgets.create_simple_texture("voice_chat_icon_01", "icon_slot_4", false, var_0_0)
}
local var_0_5 = {
	UIWidgets.create_simple_texture("voice_chat_bg_01", "bg_slot_1", false, var_0_0),
	UIWidgets.create_simple_texture("voice_chat_bg_01", "bg_slot_2", false, var_0_0),
	UIWidgets.create_simple_texture("voice_chat_bg_01", "bg_slot_3", false, var_0_0),
	UIWidgets.create_simple_texture("voice_chat_bg_01", "bg_slot_4", false, var_0_0)
}
local var_0_6 = {
	vertical_alignment = "center",
	font_size = 18,
	localize = false,
	horizontal_alignment = "left",
	word_wrap = false,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("white", 150),
	offset = {
		0,
		0,
		2
	}
}
local var_0_7 = {
	UIWidgets.create_simple_text("player_1", "name_slot_1", nil, nil, var_0_6, nil, var_0_0),
	UIWidgets.create_simple_text("player_2", "name_slot_2", nil, nil, var_0_6, nil, var_0_0),
	UIWidgets.create_simple_text("player_3", "name_slot_3", nil, nil, var_0_6, nil, var_0_0),
	UIWidgets.create_simple_text("player_4", "name_slot_4", nil, nil, var_0_6, nil, var_0_0)
}
local var_0_8 = false
local var_0_9 = 0.3

VoiceChatUI.init = function (arg_1_0, arg_1_1)
	arg_1_0.ui_top_renderer = arg_1_1.ui_top_renderer
	arg_1_0.player_manager = arg_1_1.player_manager
	arg_1_0._voip = arg_1_1.voip
	arg_1_0._cached_names = {}
	arg_1_0._talking_peers = {}
	arg_1_0._push_to_talk_end_t = 0
	arg_1_0._push_to_talk_talking = false
	arg_1_0._dirty = true
	arg_1_0._safe_rect = Application.user_setting("safe_rect") or 0

	arg_1_0:create_ui_elements()
end

VoiceChatUI.set_input_manager = function (arg_2_0, arg_2_1)
	arg_2_0.input_manager = arg_2_1
end

VoiceChatUI.create_ui_elements = function (arg_3_0)
	UIRenderer.clear_scenegraph_queue(arg_3_0.ui_top_renderer)

	arg_3_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_3)
	arg_3_0.icon_widgets = {}

	for iter_3_0, iter_3_1 in ipairs(var_0_4) do
		local var_3_0 = UIWidget.init(iter_3_1)

		var_3_0.content.visible = false
		var_3_0.style.texture_id.color = Colors.get_color_table_with_alpha("white", 150)
		arg_3_0.icon_widgets[#arg_3_0.icon_widgets + 1] = var_3_0
	end

	arg_3_0.bg_widgets = {}

	for iter_3_2, iter_3_3 in ipairs(var_0_5) do
		local var_3_1 = UIWidget.init(iter_3_3)

		var_3_1.content.visible = false
		arg_3_0.bg_widgets[#arg_3_0.bg_widgets + 1] = var_3_1
	end

	arg_3_0.name_widgets = {}

	for iter_3_4, iter_3_5 in ipairs(var_0_7) do
		local var_3_2 = UIWidget.init(iter_3_5)

		var_3_2.content.visible = false
		arg_3_0.name_widgets[#arg_3_0.name_widgets + 1] = var_3_2
	end

	var_0_8 = false
end

VoiceChatUI.destroy = function (arg_4_0)
	if arg_4_0.icon_widgets then
		for iter_4_0, iter_4_1 in ipairs(arg_4_0.icon_widgets) do
			UIWidget.destroy(arg_4_0.ui_top_renderer, iter_4_1)
		end

		arg_4_0.icon_widget = nil
	end

	if arg_4_0.bg_widgets then
		for iter_4_2, iter_4_3 in ipairs(arg_4_0.bg_widgets) do
			UIWidget.destroy(arg_4_0.ui_top_renderer, iter_4_3)
		end

		arg_4_0.bg_widgets = nil
	end

	if arg_4_0.name_widgets then
		for iter_4_4, iter_4_5 in ipairs(arg_4_0.name_widgets) do
			UIWidget.destroy(arg_4_0.ui_top_renderer, iter_4_5)
		end

		arg_4_0._name_widgets = nil
	end

	GarbageLeakDetector.register_object(arg_4_0, "voice_chat_ui")
end

VoiceChatUI._update_timer = function (arg_5_0)
	arg_5_0._timer = Application.time_since_launch()
end

VoiceChatUI._update_safe_rect = function (arg_6_0)
	if IS_PS4 then
		local var_6_0 = Application.user_setting("safe_rect") or 0

		if var_6_0 ~= arg_6_0._safe_rect then
			arg_6_0._safe_rect = var_6_0
			arg_6_0._dirty = true
		end
	end
end

local var_0_10 = {}

VoiceChatUI._update_talking_state = function (arg_7_0)
	local var_7_0 = arg_7_0._voip:members_in_own_room() or var_0_10
	local var_7_1 = var_7_0.get_members and var_7_0:get_members() or var_7_0

	for iter_7_0, iter_7_1 in pairs(var_7_1) do
		local var_7_2 = arg_7_0._voip:is_talking(iter_7_1)
		local var_7_3 = arg_7_0._talking_peers[iter_7_1]

		arg_7_0._talking_peers[iter_7_1] = var_7_2 and arg_7_0._timer + var_0_9 or var_7_3
		arg_7_0._dirty = not not var_7_3 == not not var_7_2 or arg_7_0._dirty
	end

	for iter_7_2, iter_7_3 in pairs(arg_7_0._talking_peers) do
		if iter_7_3 < arg_7_0._timer or not table.find(var_7_1, iter_7_2) then
			arg_7_0._talking_peers[iter_7_2] = nil
			arg_7_0._dirty = true
		end
	end

	arg_7_0:_evaluate_push_to_talk()
end

VoiceChatUI._evaluate_push_to_talk = function (arg_8_0)
	if not arg_8_0._voip:push_to_talk_enabled() then
		return
	end

	local var_8_0 = Network.peer_id()
	local var_8_1 = arg_8_0._voip:is_push_to_talk_active()
	local var_8_2 = arg_8_0._voip:is_talking(var_8_0)
	local var_8_3 = arg_8_0._push_to_talk_talking

	arg_8_0._push_to_talk_end_t = var_8_1 and var_8_2 and arg_8_0._timer + var_0_9 or arg_8_0._push_to_talk_end_t
	arg_8_0._push_to_talk_talking = arg_8_0._push_to_talk_end_t > arg_8_0._timer

	local var_8_4 = arg_8_0._push_to_talk_talking

	arg_8_0._talking_peers[var_8_0] = var_8_4 and arg_8_0._push_to_talk_end_t or nil
	arg_8_0._dirty = var_8_3 ~= var_8_4 or arg_8_0._dirty
end

VoiceChatUI._update_widgets = function (arg_9_0)
	if not arg_9_0._dirty then
		return
	end

	local var_9_0 = Network.peer_id()
	local var_9_1 = 1

	for iter_9_0, iter_9_1 in pairs(arg_9_0._talking_peers) do
		local var_9_2 = arg_9_0.icon_widgets[var_9_1]
		local var_9_3 = var_9_2.content
		local var_9_4 = var_9_2.element

		var_9_3.visible = true
		var_9_4.dirty = true

		local var_9_5 = arg_9_0.bg_widgets[var_9_1]
		local var_9_6 = var_9_5.content
		local var_9_7 = var_9_5.element

		var_9_6.visible = true
		var_9_7.dirty = true

		local var_9_8

		if HAS_STEAM then
			var_9_8 = Steam.user_name(iter_9_0)
		else
			local var_9_9 = Managers.player:player_from_peer_id(iter_9_0, 1)

			var_9_8 = var_9_9 and var_9_9:name()
		end

		if not var_9_8 or var_9_8 == "" then
			var_9_8 = "Remote #" .. string.sub(iter_9_0, -3)
		end

		local var_9_10 = arg_9_0.name_widgets[var_9_1]
		local var_9_11 = UTF8Utils.string_length(var_9_8) > var_0_2 and UIRenderer.crop_text_width(arg_9_0.ui_top_renderer, var_9_8, 250, var_9_10.style.text) or var_9_8
		local var_9_12 = var_9_10.content
		local var_9_13 = var_9_10.element

		var_9_12.text = var_9_11
		var_9_13.dirty = true

		if arg_9_0._voip:push_to_talk_enabled() and iter_9_0 == var_9_0 then
			var_9_12.visible = arg_9_0._push_to_talk_end_t > arg_9_0._timer
		else
			var_9_12.visible = true
		end

		var_9_1 = var_9_1 + 1
	end

	for iter_9_2 = var_9_1, var_0_1 do
		local var_9_14 = arg_9_0.icon_widgets[iter_9_2]
		local var_9_15 = var_9_14.content
		local var_9_16 = var_9_14.element

		var_9_15.visible = false
		var_9_16.dirty = true

		local var_9_17 = arg_9_0.bg_widgets[iter_9_2]
		local var_9_18 = var_9_17.content
		local var_9_19 = var_9_17.element

		var_9_18.visible = false
		var_9_19.dirty = true

		local var_9_20 = arg_9_0.name_widgets[iter_9_2]
		local var_9_21 = var_9_20.content
		local var_9_22 = var_9_20.element

		var_9_21.visible = false
		var_9_22.dirty = true
	end
end

VoiceChatUI.update = function (arg_10_0, arg_10_1)
	arg_10_0:_update_timer()
	arg_10_0:_update_safe_rect()
	arg_10_0:_update_talking_state()
	arg_10_0:_update_widgets()
	arg_10_0:_draw(arg_10_1)
end

VoiceChatUI._draw = function (arg_11_0, arg_11_1)
	if not arg_11_0._dirty then
		return
	end

	local var_11_0 = arg_11_0.ui_top_renderer
	local var_11_1 = arg_11_0.ui_scenegraph
	local var_11_2 = arg_11_0.input_manager:get_service("Player")

	UIRenderer.begin_pass(var_11_0, var_11_1, var_11_2, arg_11_1)

	for iter_11_0 = 1, var_0_1 do
		UIRenderer.draw_widget(var_11_0, arg_11_0.icon_widgets[iter_11_0])
		UIRenderer.draw_widget(var_11_0, arg_11_0.bg_widgets[iter_11_0])
		UIRenderer.draw_widget(var_11_0, arg_11_0.name_widgets[iter_11_0])
	end

	UIRenderer.end_pass(var_11_0)

	arg_11_0._dirty = not var_0_0
end
