-- chunkname: @scripts/ui/views/voice_chat_ui.lua

VoiceChatUI = class(VoiceChatUI)

local flag = true
local num = 4
local num_2 = 16
local tbl = {
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
	tbl.root.scale = "hud_fit"
	tbl.root.is_root = false
end

local tbl_2 = {
	UIWidgets.create_simple_texture("voice_chat_icon_01", "icon_slot_1", false, flag),
	UIWidgets.create_simple_texture("voice_chat_icon_01", "icon_slot_2", false, flag),
	UIWidgets.create_simple_texture("voice_chat_icon_01", "icon_slot_3", false, flag),
	UIWidgets.create_simple_texture("voice_chat_icon_01", "icon_slot_4", false, flag)
}
local tbl_3 = {
	UIWidgets.create_simple_texture("voice_chat_bg_01", "bg_slot_1", false, flag),
	UIWidgets.create_simple_texture("voice_chat_bg_01", "bg_slot_2", false, flag),
	UIWidgets.create_simple_texture("voice_chat_bg_01", "bg_slot_3", false, flag),
	UIWidgets.create_simple_texture("voice_chat_bg_01", "bg_slot_4", false, flag)
}
local tbl_4 = {
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
local tbl_5 = {
	UIWidgets.create_simple_text("player_1", "name_slot_1", nil, nil, tbl_4, nil, flag),
	UIWidgets.create_simple_text("player_2", "name_slot_2", nil, nil, tbl_4, nil, flag),
	UIWidgets.create_simple_text("player_3", "name_slot_3", nil, nil, tbl_4, nil, flag),
	UIWidgets.create_simple_text("player_4", "name_slot_4", nil, nil, tbl_4, nil, flag)
}
local flag_2 = false
local num_3 = 0.3

VoiceChatUI.init = function (self, arg_1_1)
	-- function 1
	self.ui_top_renderer = arg_1_1.ui_top_renderer
	self.player_manager = arg_1_1.player_manager
	self._voip = arg_1_1.voip
	self._cached_names = {}
	self._talking_peers = {}
	self._push_to_talk_end_t = 0
	self._push_to_talk_talking = false
	self._dirty = true

	local user_setting = Application.user_setting("safe_rect")

	user_setting = user_setting or 0
	self._safe_rect = user_setting

	self:create_ui_elements()
end

VoiceChatUI.set_input_manager = function (self, arg_2_1)
	-- function 2
	self.input_manager = arg_2_1
end

VoiceChatUI.create_ui_elements = function (self)
	-- function 3
	UIRenderer.clear_scenegraph_queue(self.ui_top_renderer)

	self.ui_scenegraph = UISceneGraph.init_scenegraph(tbl)
	self.icon_widgets = {}

	for i, v in ipairs(tbl_2) do
		local var_3_0 = UIWidget.init(v)

		var_3_0.content.visible = false
		var_3_0.style.texture_id.color = Colors.get_color_table_with_alpha("white", 150)
		self.icon_widgets[#self.icon_widgets + 1] = var_3_0
	end

	self.bg_widgets = {}

	for i_2, v_2 in ipairs(tbl_3) do
		local var_3_1 = UIWidget.init(v_2)

		var_3_1.content.visible = false
		self.bg_widgets[#self.bg_widgets + 1] = var_3_1
	end

	self.name_widgets = {}

	for i_3, v_3 in ipairs(tbl_5) do
		local var_3_2 = UIWidget.init(v_3)

		var_3_2.content.visible = false
		self.name_widgets[#self.name_widgets + 1] = var_3_2
	end

	flag_2 = false
end

VoiceChatUI.destroy = function (self)
	-- function 4
	if not self.icon_widgets then
		for i, v in ipairs(self.icon_widgets) do
			UIWidget.destroy(self.ui_top_renderer, v)
		end

		self.icon_widget = nil
	end

	if not self.bg_widgets then
		for i_2, v_2 in ipairs(self.bg_widgets) do
			UIWidget.destroy(self.ui_top_renderer, v_2)
		end

		self.bg_widgets = nil
	end

	if not self.name_widgets then
		for i_3, v_3 in ipairs(self.name_widgets) do
			UIWidget.destroy(self.ui_top_renderer, v_3)
		end

		self._name_widgets = nil
	end

	GarbageLeakDetector.register_object(self, "voice_chat_ui")
end

VoiceChatUI._update_timer = function (self)
	-- function 5
	self._timer = Application.time_since_launch()
end

VoiceChatUI._update_safe_rect = function (self)
	-- function 6
	if not IS_PS4 then
		local user_setting = Application.user_setting("safe_rect")

		user_setting = user_setting or 0

		if user_setting ~= self._safe_rect then
			self._safe_rect = user_setting
			self._dirty = true
		end
	end
end

local tbl_6 = {}

VoiceChatUI._update_talking_state = function (self)
	-- function 7
	local members_in_own_room = self._voip:members_in_own_room()

	members_in_own_room = members_in_own_room or tbl_6

	local get_members

	if not members_in_own_room.get_members then
		get_members = members_in_own_room:get_members()

		if not get_members then
			-- Nothing
		end
	end

	get_members = members_in_own_room

	::label_7_0::

	for k, v in pairs(get_members) do
		local is_talking = self._voip:is_talking(v)
		local var_7_3 = self._talking_peers[v]
		local _talking_peers = self._talking_peers
		local num

		if not is_talking then
			num = self._timer + num_3

			if not num then
				-- Nothing
			end
		end

		num = var_7_3

		::label_7_1::

		_talking_peers[v] = num
		self._dirty = not not var_7_3 == not not is_talking or self._dirty
	end

	for k_2, v_2 in pairs(self._talking_peers) do
		if not (v_2 < self._timer or table.find(get_members, k_2)) then
			self._talking_peers[k_2] = nil
			self._dirty = true
		end
	end

	self:_evaluate_push_to_talk()
end

VoiceChatUI._evaluate_push_to_talk = function (self)
	-- function 8
	if not self._voip:push_to_talk_enabled() then
		return
	end

	local peer_id = Network.peer_id()
	local is_push_to_talk_active = self._voip:is_push_to_talk_active()
	local is_talking = self._voip:is_talking(peer_id)
	local _push_to_talk_talking = self._push_to_talk_talking
	local num

	if not is_push_to_talk_active and not is_talking then
		num = self._timer + num_3

		if not num then
			-- Nothing
		end
	end

	num = self._push_to_talk_end_t

	::label_8_0::

	self._push_to_talk_end_t = num
	self._push_to_talk_talking = self._push_to_talk_end_t > self._timer

	local _push_to_talk_talking_2 = self._push_to_talk_talking
	local _talking_peers = self._talking_peers
	local _push_to_talk_end_t

	if not _push_to_talk_talking_2 then
		_push_to_talk_end_t = self._push_to_talk_end_t

		if not _push_to_talk_end_t then
			-- Nothing
		end
	end

	_push_to_talk_end_t = nil

	::label_8_1::

	_talking_peers[peer_id] = _push_to_talk_end_t
	self._dirty = _push_to_talk_talking ~= _push_to_talk_talking_2 or self._dirty
end

VoiceChatUI._update_widgets = function (self)
	-- function 9
	if not self._dirty then
		return
	end

	local peer_id = Network.peer_id()
	local num_3 = 1

	for k, v in pairs(self._talking_peers) do
		local var_9_2 = self.icon_widgets[num_3]
		local content = var_9_2.content
		local element = var_9_2.element

		content.visible = true
		element.dirty = true

		local var_9_5 = self.bg_widgets[num_3]
		local content_2 = var_9_5.content
		local element_2 = var_9_5.element

		content_2.visible = true
		element_2.dirty = true

		local var_9_8

		if not HAS_STEAM then
			var_9_8 = Steam.user_name(k)
		else
			local player_from_peer_id = Managers.player:player_from_peer_id(k, 1)

			var_9_8 = not player_from_peer_id and player_from_peer_id:name()
		end

		if not (not var_9_8 and var_9_8 ~= "") then
			var_9_8 = "Remote #" .. string.sub(k, -3)
		end

		local var_9_10 = self.name_widgets[num_3]
		local crop_text_width

		if Utf8.length(var_9_8) > num_2 then
			crop_text_width = UIRenderer.crop_text_width(self.ui_top_renderer, var_9_8, 250, var_9_10.style.text)

			if not crop_text_width then
				-- Nothing
			end
		end

		crop_text_width = var_9_8

		::label_9_0::

		local content_3 = var_9_10.content
		local element_3 = var_9_10.element

		content_3.text = crop_text_width
		element_3.dirty = true

		if not (not self._voip:push_to_talk_enabled() and k ~= peer_id) then
			content_3.visible = self._push_to_talk_end_t > self._timer
		else
			content_3.visible = true
		end

		num_3 = num_3 + 1
	end

	for k_2 = num_3, num do
		local var_9_14 = self.icon_widgets[k_2]
		local content_4 = var_9_14.content
		local element_4 = var_9_14.element

		content_4.visible = false
		element_4.dirty = true

		local var_9_17 = self.bg_widgets[k_2]
		local content_5 = var_9_17.content
		local element_5 = var_9_17.element

		content_5.visible = false
		element_5.dirty = true

		local var_9_20 = self.name_widgets[k_2]
		local content_6 = var_9_20.content
		local element_6 = var_9_20.element

		content_6.visible = false
		element_6.dirty = true
	end
end

VoiceChatUI.update = function (self, arg_10_1)
	-- function 10
	self:_update_timer()
	self:_update_safe_rect()
	self:_update_talking_state()
	self:_update_widgets()
	self:_draw(arg_10_1)
end

VoiceChatUI._draw = function (self, arg_11_1)
	-- function 11
	if not self._dirty then
		return
	end

	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("Player")

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, get_service, arg_11_1)

	for i = 1, num do
		UIRenderer.draw_widget(ui_top_renderer, self.icon_widgets[i])
		UIRenderer.draw_widget(ui_top_renderer, self.bg_widgets[i])
		UIRenderer.draw_widget(ui_top_renderer, self.name_widgets[i])
	end

	UIRenderer.end_pass(ui_top_renderer)

	self._dirty = not flag
end
