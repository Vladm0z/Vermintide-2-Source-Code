-- chunkname: @scripts/ui/dlc_morris/views/start_game_view/windows/definitions/start_game_window_deus_additional_settings_definitions.lua

local var_0_0 = UISettings.game_start_windows.size
local var_0_1 = {
	var_0_0[1] - 20,
	30
}
local var_0_2 = {
	on_enter = {
		{
			name = "fade_in",
			duration = 0.2,
			init = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				arg_1_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				local var_2_0 = math.easeOutCubic(arg_2_3)

				arg_2_4.render_settings.alpha_multiplier = var_2_0
			end,
			on_complete = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			duration = 0.3,
			init = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				arg_4_3.render_settings.alpha_multiplier = 1
			end,
			update = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				local var_5_0 = math.easeOutCubic(arg_5_3)

				arg_5_4.render_settings.alpha_multiplier = 1 - var_5_0
			end,
			on_complete = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end
		}
	}
}
local var_0_3 = {
	root = {
		is_root = true,
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.default
		}
	},
	root_fit = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.default
		}
	},
	menu_root = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			0
		}
	},
	window = {
		vertical_alignment = "bottom",
		parent = "menu_root",
		horizontal_alignment = "right",
		size = var_0_0,
		position = {
			-100,
			-400,
			1
		}
	},
	additional_option = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_1[1],
			260
		},
		position = {
			0,
			0,
			0
		}
	},
	title_text = {
		vertical_alignment = "top",
		parent = "additional_option",
		horizontal_alignment = "left",
		size = {
			var_0_1[1],
			50
		},
		position = {
			0,
			0,
			1
		}
	},
	title_divider = {
		vertical_alignment = "bottom",
		parent = "title_text",
		horizontal_alignment = "left",
		size = {
			var_0_1[1],
			5
		},
		position = {
			10,
			2,
			0
		}
	},
	game_options_right_chain = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			16,
			var_0_0[2]
		},
		position = {
			195,
			0,
			1
		}
	},
	game_options_left_chain = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			16,
			var_0_0[2]
		},
		position = {
			-195,
			0,
			1
		}
	},
	private_button = {
		vertical_alignment = "top",
		parent = "additional_option",
		horizontal_alignment = "center",
		size = {
			var_0_1[1] - 20,
			var_0_1[2]
		},
		position = {
			0,
			-(var_0_1[2] + 5) * 3 - 25,
			10
		}
	},
	private_button_frame = {
		vertical_alignment = "bottom",
		parent = "private_button",
		horizontal_alignment = "center",
		size = {
			var_0_1[1] - 20,
			var_0_1[2] + 5
		},
		position = {
			0,
			0,
			10
		}
	},
	host_button = {
		vertical_alignment = "top",
		parent = "private_button",
		horizontal_alignment = "center",
		size = {
			var_0_1[1] - 20,
			var_0_1[2]
		},
		position = {
			0,
			var_0_1[2] + 5,
			10
		}
	},
	host_button_frame = {
		vertical_alignment = "bottom",
		parent = "host_button",
		horizontal_alignment = "center",
		size = {
			var_0_1[1] - 20,
			var_0_1[2] + 5
		},
		position = {
			0,
			0,
			10
		}
	},
	strict_matchmaking_button = {
		vertical_alignment = "top",
		parent = "host_button",
		horizontal_alignment = "center",
		size = {
			var_0_1[1] - 20,
			var_0_1[2]
		},
		position = {
			0,
			var_0_1[2] + 5,
			10
		}
	},
	strict_matchmaking_button_frame = {
		vertical_alignment = "bottom",
		parent = "strict_matchmaking_button",
		horizontal_alignment = "center",
		size = {
			var_0_1[1] - 20,
			var_0_1[2] + 5
		},
		position = {
			0,
			0,
			10
		}
	},
	option_tooltip = {
		vertical_alignment = "bottom",
		parent = "additional_option",
		horizontal_alignment = "center",
		size = {
			var_0_1[1] - 40,
			122
		},
		position = {
			0,
			0,
			0
		}
	},
	option_tooltip_divider = {
		vertical_alignment = "top",
		parent = "option_tooltip",
		horizontal_alignment = "left",
		size = {
			var_0_1[1],
			5
		},
		position = {
			-10,
			-24,
			1
		}
	}
}

function create_option_tooltip(arg_7_0, arg_7_1)
	local var_7_0 = "text"
	local var_7_1 = "text_shadow"
	local var_7_2 = {}

	var_7_2[#var_7_2 + 1] = {
		pass_type = "text",
		text_id = var_7_0,
		style_id = var_7_0,
		content_check_function = function(arg_8_0)
			return arg_8_0[var_7_0]
		end
	}
	var_7_2[#var_7_2 + 1] = {
		pass_type = "text",
		text_id = var_7_0,
		style_id = var_7_1,
		content_check_function = function(arg_9_0)
			return arg_9_0[var_7_0]
		end
	}

	local var_7_3 = {
		[var_7_0] = nil
	}
	local var_7_4 = {
		0,
		-35,
		1
	}
	local var_7_5 = {
		[var_7_0] = {
			vertical_alignment = "top",
			font_size = 22,
			horizontal_alignment = "left",
			word_wrap = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = var_7_4
		}
	}
	local var_7_6 = table.clone(var_7_5[var_7_0])

	var_7_6.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_7_6.offset = {
		var_7_4[1] + 2,
		var_7_4[2] - 2,
		var_7_4[3] - 1
	}
	var_7_5[var_7_1] = var_7_6

	return {
		element = {
			passes = var_7_2
		},
		content = var_7_3,
		style = var_7_5,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_7_0
	}
end

local var_0_4 = {
	font_size = 32,
	upper_case = true,
	localize = false,
	word_wrap = true,
	horizontal_alignment = "left",
	use_shadow = true,
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	default_text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		10,
		0,
		0
	}
}
local var_0_5 = {
	background = UIWidgets.create_deus_panel_with_outer_frame("additional_option", var_0_3.additional_option.size),
	title_text = UIWidgets.create_simple_text(Localize("start_game_window_other_options_title"), "title_text", 32, nil, var_0_4),
	title_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "title_divider"),
	option_tooltip = create_option_tooltip("option_tooltip", var_0_3.option_tooltip.size),
	option_tooltip_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "option_tooltip_divider"),
	private_button = UIWidgets.create_default_checkbox_button_console("private_button", var_0_3.private_button.size, Localize("start_game_window_other_options_private"), 24, {
		title = Localize("start_game_window_other_options_private"),
		description = Localize("start_game_window_other_options_private_description")
	}, "menu_frame_03_morris"),
	host_button = UIWidgets.create_default_checkbox_button_console("host_button", var_0_3.host_button.size, Localize("start_game_window_other_options_always_host"), 24, {
		title = Localize("start_game_window_other_options_always_host"),
		description = Localize("start_game_window_other_options_always_host_description")
	}, "menu_frame_03_morris"),
	strict_matchmaking_button = UIWidgets.create_default_checkbox_button_console("strict_matchmaking_button", var_0_3.strict_matchmaking_button.size, Localize("start_game_window_other_options_strict_matchmaking"), 24, {
		title = Localize("start_game_window_other_options_strict_matchmaking"),
		description = Localize("start_game_window_other_options_strict_matchmaking_description")
	}, "menu_frame_03_morris")
}
local var_0_6 = {
	"strict_matchmaking_button",
	"host_button",
	"private_button"
}

return {
	widgets = var_0_5,
	scenegraph_definition = var_0_3,
	animation_definitions = var_0_2,
	gamepad_widget_navigation = var_0_6
}
