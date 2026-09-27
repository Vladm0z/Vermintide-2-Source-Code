-- chunkname: @scripts/ui/views/gdc_start_ui.lua

local tbl = {
	root = {
		is_root = true,
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.gdc_intro
		}
	},
	gdc_logo = {
		vertical_alignment = "top",
		parent = "root",
		horizontal_alignment = "center",
		position = {
			0,
			-100,
			1
		},
		size = {
			1237,
			538
		}
	},
	input_root = {
		parent = "root",
		position = {
			960,
			320,
			0
		},
		size = {
			1,
			1
		}
	},
	input = {
		vertical_alignment = "bottom",
		parent = "input_root",
		position = {
			0,
			0,
			1
		},
		size = {
			200,
			40
		}
	},
	input_text = {
		vertical_alignment = "center",
		parent = "input",
		size = {
			600,
			62
		},
		position = {
			0,
			0,
			2
		}
	},
	input_prefix_text = {
		vertical_alignment = "center",
		parent = "input_icon",
		horizontal_alignment = "left",
		size = {
			300,
			62
		},
		position = {
			-300,
			0,
			2
		}
	},
	input_icon = {
		vertical_alignment = "center",
		parent = "input",
		horizontal_alignment = "left",
		size = {
			62,
			62
		},
		position = {
			0,
			0,
			1
		}
	}
}
local tbl_2 = {
	input = {
		scenegraph_id = "input",
		element = {
			passes = {
				{
					texture_id = "icon_textures",
					style_id = "icon_styles",
					pass_type = "multi_texture"
				},
				{
					style_id = "button_text",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function (self)
						-- function 1
						return self.text ~= ""
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 2
						return self.text
					end
				},
				{
					style_id = "prefix_text",
					pass_type = "text",
					text_id = "prefix_text",
					content_check_function = function (self)
						-- function 3
						return self.text
					end
				}
			}
		},
		content = {
			text = "input_text",
			prefix_text = "",
			button_text = "",
			icon_textures = {
				"pc_button_icon_left"
			}
		},
		style = {
			prefix_text = {
				scenegraph_id = "input_prefix_text",
				font_size = 36,
				word_wrap = true,
				pixel_perfect = true,
				horizontal_alignment = "right",
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					3,
					1
				}
			},
			text = {
				scenegraph_id = "input_text",
				font_size = 36,
				word_wrap = true,
				pixel_perfect = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					3,
					1
				}
			},
			button_text = {
				font_size = 24,
				scenegraph_id = "input_icon",
				horizontal_alignment = "center",
				pixel_perfect = true,
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					2,
					2
				}
			},
			icon_styles = {
				scenegraph_id = "input_icon",
				texture_sizes = {
					{
						20,
						36
					}
				},
				offset = {
					0,
					0,
					1
				},
				color = {
					255,
					255,
					255,
					255
				}
			}
		}
	},
	logo = {
		scenegraph_id = "gdc_logo",
		element = {
			passes = {
				{
					pass_type = "texture",
					texture_id = "logo"
				}
			}
		},
		content = {
			logo = "vermintide_logo_transparent"
		},
		style = {}
	}
}

GDCStartUI = class(GDCStartUI)

GDCStartUI.init = function (self, arg_4_1)
	-- function 4
	self.ui_renderer = arg_4_1.ui_renderer
	self.ingame_ui = arg_4_1.ingame_ui
	self.camera_manager = arg_4_1.camera_manager
	self.network_event_delegate = arg_4_1.network_event_delegate
	self.player_manager = arg_4_1.player_manager
	self.peer_id = arg_4_1.peer_id
	self.world_manager = arg_4_1.world_manager
	self.input_manager = arg_4_1.input_manager
	self.ui_animations = {}

	self.network_event_delegate:register(self, "rpc_on_skip_gdc_intro")
	rawset(_G, "GDCStartUI_pointer", self)
	self:create_ui_elements()
end

GDCStartUI.create_ui_elements = function (self)
	-- function 5
	self.ui_scenegraph = UISceneGraph.init_scenegraph(tbl)
	self.logo_widget = UIWidget.init(tbl_2.logo)
	self.input_widget = UIWidget.init(tbl_2.input)

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)
	self:set_input_text("waiting_for_other_players")

	local style = self.input_widget.style

	self.ui_animations.button_text_pulse = UIAnimation.init(UIAnimation.pulse_animation, style.button_text.text_color, 1, 100, 255, 2)
	self.ui_animations.button_texture_pulse = UIAnimation.init(UIAnimation.pulse_animation, style.icon_styles.color, 1, 100, 255, 2)
end

GDCStartUI.update = function (self, arg_6_1)
	-- function 6
	local peer_id = self.peer_id
	local player_unit = self.player_manager:player_from_peer_id(peer_id).player_unit

	for k, v in pairs(self.ui_animations) do
		UIAnimation.update(v, arg_6_1)

		if not UIAnimation.completed(v) then
			self.ui_animations[k] = nil
		end
	end

	if not self.intro_complete then
		if not self.draw_intro then
			if not player_unit and not Unit.alive(player_unit) and not ScriptUnit.extension(player_unit, "hud_system").show_gdc_intro then
				self:start_gdc_intro()
			end
		else
			local get_service = self.input_manager:get_service("cutscene")

			self:check_start_input(get_service)
		end
	end

	self:draw(arg_6_1)
end

GDCStartUI.draw = function (self, arg_7_1)
	-- function 7
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("cutscene")

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_7_1)

	if self.intro_complete or not self.draw_intro then
		UIRenderer.draw_widget(ui_renderer, self.input_widget)
		UIRenderer.draw_widget(ui_renderer, self.logo_widget)
	end

	UIRenderer.end_pass(ui_renderer)
end

GDCStartUI.destroy = function (self)
	-- function 8
	self.network_event_delegate:unregister(self)
	rawset(_G, "GDCStartUI_pointer", nil)
	GarbageLeakDetector.register_object(self, "GDCStartUI")
end

GDCStartUI.start_gdc_intro = function (self)
	-- function 9
	self.draw_intro = true
end

GDCStartUI.end_gdc_intro = function (self)
	-- function 10
	self.draw_intro = nil
	self.intro_complete = true
end

GDCStartUI.rpc_on_skip_gdc_intro = function (self, arg_11_1)
	-- function 11
	if not Managers.player.is_server then
		Managers.state.network.network_transmit:send_rpc_clients_except("rpc_on_skip_gdc_intro", self.peer_id)
	end

	if not self.input_pressed then
		self.input_pressed = true

		self:end_gdc_intro()

		local str = "level_world"
		local world_manager = self.world_manager

		if not world_manager:has_world(str) then
			local world = world_manager:world(str)

			LevelHelper:flow_event(world, "gdc_intro_complete")
		end
	end
end

GDCStartUI.check_start_input = function (self, arg_12_1)
	-- function 12
	if not (self.input_pressed or self.input_widget) then
		return
	end

	local parameter = Development.parameter("gdc_ignore_minimum_players")
	local parameter_2 = Development.parameter("gdc_player_count")

	parameter_2 = parameter_2 or 1
	parameter_2 = not parameter and 1 and parameter_2

	local human_players = Managers.player:human_players()
	local num = 0

	for k, v in pairs(human_players) do
		local player_unit = v.player_unit

		if not player_unit and not Unit.alive(player_unit) then
			num = num + 1
		end
	end

	if not arg_12_1 and not (parameter_2 <= num) and not arg_12_1:get("gdc_skip") and not arg_12_1:has("gdc_debug_skip") and not arg_12_1:get("gdc_debug_skip") then
		if not Managers.player.is_server then
			self:rpc_on_skip_gdc_intro()
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_on_skip_gdc_intro")
		end
	end

	if self.num_of_human_players ~= num then
		local str

		if num < parameter_2 then
			str = Localize("waiting_for_other_players") .. " - " .. num .. "/" .. parameter_2

			if not str then
				-- Nothing
			end
		end

		str = nil

		::label_12_0::

		self:set_input_text(str)

		self.num_of_human_players = num
	end
end

GDCStartUI.set_input_text = function (self, arg_13_1)
	-- function 13
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local input_widget = self.input_widget
	local content = input_widget.content
	local style = input_widget.style
	local str = ""
	local str_2 = ""
	local str_3 = ""
	local var_13_8

	if not arg_13_1 then
		local str_4 = "jump"
		local input_manager = self.input_manager
		local get_service = input_manager:get_service("Player")
		local is_device_active = input_manager:is_device_active("gamepad")
		local get_gamepad_input_texture_data, var_13_14 = UISettings.get_gamepad_input_texture_data(get_service, str_4, is_device_active)

		assert(get_gamepad_input_texture_data, "Could not find button texture(s) for action: jump")

		str = Localize("to_start_game")
		str_2 = Localize("interaction_prefix_press")
	else
		str = arg_13_1
		str_2 = ""
	end

	local num = 0
	local num_2 = 0

	if not var_13_8 then
		if not var_13_8.texture then
			content.button_text = ""
			content.icon_textures = {
				var_13_8.texture
			}
			style.icon_styles.texture_sizes = {
				var_13_8.size
			}
			num = var_13_8.size[1]
			num_2 = var_13_8.size[2]
		else
			local tbl = {}
			local tbl_2 = {}
			local button_text = style.button_text
			local var_13_20, var_13_21 = UIFontByResolution(button_text)
			local text_size, var_13_23, var_13_24 = UIRenderer.text_size(ui_renderer, str_3, var_13_20[1], var_13_21)

			for i = 1, #var_13_8 do
				tbl[i] = var_13_8[i].texture
				tbl_2[i] = var_13_8[i].size

				if i == 2 then
					tbl_2[i][1] = text_size
				end

				num = num + tbl_2[i][1]
				num_2 = not (num_2 < tbl_2[i][2]) or not tbl_2[i][2] or num_2
			end

			content.icon_textures = tbl
			content.button_text = str_3
			style.icon_styles.texture_sizes = tbl_2
		end

		ui_scenegraph.input_text.local_position[1] = num
		ui_scenegraph.input_icon.size[1] = num
		ui_scenegraph.input_icon.size[2] = num_2
	else
		content.icon_textures = {}
		content.button_text = ""
		content.prefix_text = ""
		ui_scenegraph.input_text.local_position[1] = 0
	end

	local text = style.text
	local get_text_width, var_13_27 = self:get_text_width(text, str)
	local get_text_width_2 = self:get_text_width(style.prefix_text, str_2)

	content.text = str
	content.prefix_text = str_2

	local position = ui_scenegraph.input_text.position
	local flag

	flag = var_13_27 ~= text.font_size or not 3 or 0
	position[2] = flag
	ui_scenegraph.input_prefix_text.position[2] = ui_scenegraph.input_text.position[2]
	ui_scenegraph.input.position[1] = -((get_text_width + num) * 0.5) + get_text_width_2
end

GDCStartUI.get_text_width = function (self, arg_14_1, arg_14_2)
	-- function 14
	local var_14_0, var_14_1 = UIFontByResolution(arg_14_1)
	local text_size, var_14_3, var_14_4 = UIRenderer.text_size(self.ui_renderer, arg_14_2, var_14_0[1], var_14_1)

	return text_size, var_14_1
end
