-- chunkname: @scripts/ui/views/gdc_start_ui.lua

local var_0_0 = {
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
local var_0_1 = {
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
					content_check_function = function(arg_1_0)
						return arg_1_0.text ~= ""
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function(arg_2_0)
						return arg_2_0.text
					end
				},
				{
					style_id = "prefix_text",
					pass_type = "text",
					text_id = "prefix_text",
					content_check_function = function(arg_3_0)
						return arg_3_0.text
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

function GDCStartUI.init(arg_4_0, arg_4_1)
	arg_4_0.ui_renderer = arg_4_1.ui_renderer
	arg_4_0.ingame_ui = arg_4_1.ingame_ui
	arg_4_0.camera_manager = arg_4_1.camera_manager
	arg_4_0.network_event_delegate = arg_4_1.network_event_delegate
	arg_4_0.player_manager = arg_4_1.player_manager
	arg_4_0.peer_id = arg_4_1.peer_id
	arg_4_0.world_manager = arg_4_1.world_manager
	arg_4_0.input_manager = arg_4_1.input_manager
	arg_4_0.ui_animations = {}

	arg_4_0.network_event_delegate:register(arg_4_0, "rpc_on_skip_gdc_intro")
	rawset(_G, "GDCStartUI_pointer", arg_4_0)
	arg_4_0:create_ui_elements()
end

function GDCStartUI.create_ui_elements(arg_5_0)
	arg_5_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0)
	arg_5_0.logo_widget = UIWidget.init(var_0_1.logo)
	arg_5_0.input_widget = UIWidget.init(var_0_1.input)

	UIRenderer.clear_scenegraph_queue(arg_5_0.ui_renderer)
	arg_5_0:set_input_text("waiting_for_other_players")

	local var_5_0 = arg_5_0.input_widget.style

	arg_5_0.ui_animations.button_text_pulse = UIAnimation.init(UIAnimation.pulse_animation, var_5_0.button_text.text_color, 1, 100, 255, 2)
	arg_5_0.ui_animations.button_texture_pulse = UIAnimation.init(UIAnimation.pulse_animation, var_5_0.icon_styles.color, 1, 100, 255, 2)
end

function GDCStartUI.update(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.peer_id
	local var_6_1 = arg_6_0.player_manager:player_from_peer_id(var_6_0).player_unit

	for iter_6_0, iter_6_1 in pairs(arg_6_0.ui_animations) do
		UIAnimation.update(iter_6_1, arg_6_1)

		if UIAnimation.completed(iter_6_1) then
			arg_6_0.ui_animations[iter_6_0] = nil
		end
	end

	if not arg_6_0.intro_complete then
		if not arg_6_0.draw_intro then
			if var_6_1 and Unit.alive(var_6_1) and ScriptUnit.extension(var_6_1, "hud_system").show_gdc_intro then
				arg_6_0:start_gdc_intro()
			end
		else
			local var_6_2 = arg_6_0.input_manager:get_service("cutscene")

			arg_6_0:check_start_input(var_6_2)
		end
	end

	arg_6_0:draw(arg_6_1)
end

function GDCStartUI.draw(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.ui_renderer
	local var_7_1 = arg_7_0.ui_scenegraph
	local var_7_2 = arg_7_0.input_manager:get_service("cutscene")

	UIRenderer.begin_pass(var_7_0, var_7_1, var_7_2, arg_7_1)

	if not arg_7_0.intro_complete and arg_7_0.draw_intro then
		UIRenderer.draw_widget(var_7_0, arg_7_0.input_widget)
		UIRenderer.draw_widget(var_7_0, arg_7_0.logo_widget)
	end

	UIRenderer.end_pass(var_7_0)
end

function GDCStartUI.destroy(arg_8_0)
	arg_8_0.network_event_delegate:unregister(arg_8_0)
	rawset(_G, "GDCStartUI_pointer", nil)
	GarbageLeakDetector.register_object(arg_8_0, "GDCStartUI")
end

function GDCStartUI.start_gdc_intro(arg_9_0)
	arg_9_0.draw_intro = true
end

function GDCStartUI.end_gdc_intro(arg_10_0)
	arg_10_0.draw_intro = nil
	arg_10_0.intro_complete = true
end

function GDCStartUI.rpc_on_skip_gdc_intro(arg_11_0, arg_11_1)
	if Managers.player.is_server then
		Managers.state.network.network_transmit:send_rpc_clients_except("rpc_on_skip_gdc_intro", arg_11_0.peer_id)
	end

	if not arg_11_0.input_pressed then
		arg_11_0.input_pressed = true

		arg_11_0:end_gdc_intro()

		local var_11_0 = "level_world"
		local var_11_1 = arg_11_0.world_manager

		if var_11_1:has_world(var_11_0) then
			local var_11_2 = var_11_1:world(var_11_0)

			LevelHelper:flow_event(var_11_2, "gdc_intro_complete")
		end
	end
end

function GDCStartUI.check_start_input(arg_12_0, arg_12_1)
	if arg_12_0.input_pressed or not arg_12_0.input_widget then
		return
	end

	local var_12_0 = Development.parameter("gdc_ignore_minimum_players")
	local var_12_1 = Development.parameter("gdc_player_count") or 1

	var_12_1 = var_12_0 and 1 or var_12_1

	local var_12_2 = Managers.player:human_players()
	local var_12_3 = 0

	for iter_12_0, iter_12_1 in pairs(var_12_2) do
		local var_12_4 = iter_12_1.player_unit

		if var_12_4 and Unit.alive(var_12_4) then
			var_12_3 = var_12_3 + 1
		end
	end

	if arg_12_1 and (var_12_1 <= var_12_3 and arg_12_1:get("gdc_skip") or arg_12_1:has("gdc_debug_skip") and arg_12_1:get("gdc_debug_skip")) then
		if Managers.player.is_server then
			arg_12_0:rpc_on_skip_gdc_intro()
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_on_skip_gdc_intro")
		end
	end

	if arg_12_0.num_of_human_players ~= var_12_3 then
		local var_12_5 = var_12_3 < var_12_1 and Localize("waiting_for_other_players") .. " - " .. var_12_3 .. "/" .. var_12_1 or nil

		arg_12_0:set_input_text(var_12_5)

		arg_12_0.num_of_human_players = var_12_3
	end
end

function GDCStartUI.set_input_text(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0.ui_renderer
	local var_13_1 = arg_13_0.ui_scenegraph
	local var_13_2 = arg_13_0.input_widget
	local var_13_3 = var_13_2.content
	local var_13_4 = var_13_2.style
	local var_13_5 = ""
	local var_13_6 = ""
	local var_13_7 = ""
	local var_13_8

	if not arg_13_1 then
		local var_13_9 = "jump"
		local var_13_10 = arg_13_0.input_manager
		local var_13_11 = var_13_10:get_service("Player")
		local var_13_12 = var_13_10:is_device_active("gamepad")
		local var_13_13, var_13_14 = UISettings.get_gamepad_input_texture_data(var_13_11, var_13_9, var_13_12)

		assert(var_13_13, "Could not find button texture(s) for action: jump")

		var_13_5 = Localize("to_start_game")
		var_13_6 = Localize("interaction_prefix_press")
	else
		var_13_5 = arg_13_1
		var_13_6 = ""
	end

	local var_13_15 = 0
	local var_13_16 = 0

	if var_13_8 then
		if var_13_8.texture then
			var_13_3.button_text = ""
			var_13_3.icon_textures = {
				var_13_8.texture
			}
			var_13_4.icon_styles.texture_sizes = {
				var_13_8.size
			}
			var_13_15 = var_13_8.size[1]
			var_13_16 = var_13_8.size[2]
		else
			local var_13_17 = {}
			local var_13_18 = {}
			local var_13_19 = var_13_4.button_text
			local var_13_20, var_13_21 = UIFontByResolution(var_13_19)
			local var_13_22, var_13_23, var_13_24 = UIRenderer.text_size(var_13_0, var_13_7, var_13_20[1], var_13_21)

			for iter_13_0 = 1, #var_13_8 do
				var_13_17[iter_13_0] = var_13_8[iter_13_0].texture
				var_13_18[iter_13_0] = var_13_8[iter_13_0].size

				if iter_13_0 == 2 then
					var_13_18[iter_13_0][1] = var_13_22
				end

				var_13_15 = var_13_15 + var_13_18[iter_13_0][1]
				var_13_16 = var_13_16 < var_13_18[iter_13_0][2] and var_13_18[iter_13_0][2] or var_13_16
			end

			var_13_3.icon_textures = var_13_17
			var_13_3.button_text = var_13_7
			var_13_4.icon_styles.texture_sizes = var_13_18
		end

		var_13_1.input_text.local_position[1] = var_13_15
		var_13_1.input_icon.size[1] = var_13_15
		var_13_1.input_icon.size[2] = var_13_16
	else
		var_13_3.icon_textures = {}
		var_13_3.button_text = ""
		var_13_3.prefix_text = ""
		var_13_1.input_text.local_position[1] = 0
	end

	local var_13_25 = var_13_4.text
	local var_13_26, var_13_27 = arg_13_0:get_text_width(var_13_25, var_13_5)
	local var_13_28 = arg_13_0:get_text_width(var_13_4.prefix_text, var_13_6)

	var_13_3.text = var_13_5
	var_13_3.prefix_text = var_13_6
	var_13_1.input_text.position[2] = var_13_27 == var_13_25.font_size and 3 or 0
	var_13_1.input_prefix_text.position[2] = var_13_1.input_text.position[2]
	var_13_1.input.position[1] = -((var_13_26 + var_13_15) * 0.5) + var_13_28
end

function GDCStartUI.get_text_width(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0, var_14_1 = UIFontByResolution(arg_14_1)
	local var_14_2, var_14_3, var_14_4 = UIRenderer.text_size(arg_14_0.ui_renderer, arg_14_2, var_14_0[1], var_14_1)

	return var_14_2, var_14_1
end
