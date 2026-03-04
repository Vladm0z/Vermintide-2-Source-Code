-- chunkname: @scripts/ui/views/crosshair_ui_definitions.lua

local var_0_0 = 228
local var_0_1 = 2
local var_0_2 = 3
local var_0_3 = math.pi
local var_0_4 = {
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.crosshair
		},
		size = {
			1920,
			1080
		}
	},
	pivot = {
		parent = "screen",
		position = {
			0,
			0,
			1
		},
		size = {
			0,
			0
		}
	},
	crosshair_root = {
		vertical_alignment = "center",
		parent = "pivot",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			var_0_0,
			var_0_0
		}
	},
	crosshair_dot = {
		vertical_alignment = "center",
		parent = "crosshair_root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			4,
			4
		}
	},
	crosshair_line = {
		vertical_alignment = "center",
		parent = "crosshair_root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			10,
			4
		}
	},
	crosshair_arrow = {
		vertical_alignment = "center",
		parent = "crosshair_root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			12,
			11
		}
	},
	crosshair_shotgun = {
		vertical_alignment = "center",
		parent = "crosshair_root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			8,
			25
		}
	},
	crosshair_projectile = {
		vertical_alignment = "center",
		parent = "crosshair_root",
		horizontal_alignment = "center",
		position = {
			0,
			-24,
			3
		},
		size = {
			14,
			28
		}
	},
	critical_hit_indication = {
		vertical_alignment = "center",
		parent = "crosshair_root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			75,
			75
		}
	},
	crosshair_circle = {
		vertical_alignment = "center",
		parent = "crosshair_root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			126,
			126
		}
	},
	crosshair_hit = {
		vertical_alignment = "center",
		parent = "crosshair_root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			10,
			4
		}
	},
	crosshair_hit_2 = {
		vertical_alignment = "center",
		parent = "crosshair_root",
		horizontal_alignment = "center",
		position = {
			-(4 + var_0_2),
			0,
			1
		},
		size = {
			8,
			8
		}
	},
	crosshair_hit_3 = {
		vertical_alignment = "center",
		parent = "crosshair_root",
		horizontal_alignment = "center",
		position = {
			0,
			-(4 + var_0_2),
			1
		},
		size = {
			8,
			8
		}
	},
	crosshair_hit_4 = {
		vertical_alignment = "center",
		parent = "crosshair_root",
		horizontal_alignment = "center",
		position = {
			0,
			4 + var_0_2,
			1
		},
		size = {
			8,
			8
		}
	},
	crosshair_hit_armored = {
		vertical_alignment = "center",
		parent = "crosshair_root",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			-30,
			1
		}
	},
	kill_confirm = {
		vertical_alignment = "center",
		parent = "crosshair_root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			75,
			75
		}
	}
}
local var_0_5 = {
	crosshair_dot = {
		scenegraph_id = "crosshair_dot",
		element = UIElements.SimpleTexture,
		content = {
			texture_id = "crosshair_01_center"
		},
		style = {
			offset = {
				0,
				0,
				0
			}
		},
		offset = {
			0,
			0,
			0
		}
	},
	crosshair_projectile = {
		scenegraph_id = "crosshair_projectile",
		element = UIElements.SimpleTexture,
		content = {
			texture_id = "crosshair_05"
		},
		style = {
			offset = {
				0,
				0,
				0
			}
		},
		offset = {
			0,
			0,
			0
		}
	},
	crosshair_arrow = {
		scenegraph_id = "crosshair_arrow",
		element = UIElements.SimpleRotatedTexture,
		content = {
			texture_id = "crosshair_06"
		},
		style = {
			angle = 0,
			pivot = {
				var_0_4.crosshair_arrow.size[1] / 2,
				var_0_4.crosshair_arrow.size[2] / 2
			},
			offset = {
				0,
				0,
				0
			}
		},
		offset = {
			0,
			0,
			0
		}
	},
	crosshair_line = {
		scenegraph_id = "crosshair_line",
		element = UIElements.SimpleRotatedTexture,
		content = {
			texture_id = "crosshair_01_horizontal"
		},
		style = {
			angle = 0,
			pivot = {
				var_0_4.crosshair_line.size[1] / 2,
				var_0_4.crosshair_line.size[2] / 2
			},
			offset = {
				0,
				0,
				0
			}
		},
		offset = {
			0,
			0,
			0
		}
	},
	crosshair_shotgun = {
		scenegraph_id = "crosshair_shotgun",
		element = UIElements.SimpleRotatedTexture,
		content = {
			texture_id = "crosshair_04"
		},
		style = {
			angle = 0,
			pivot = {
				var_0_4.crosshair_shotgun.size[1] / 2,
				var_0_4.crosshair_shotgun.size[2] / 2
			},
			offset = {
				0,
				0,
				0
			}
		},
		offset = {
			0,
			0,
			0
		}
	},
	critical_hit_indication = {
		scenegraph_id = "critical_hit_indication",
		element = UIElements.SimpleTexture,
		content = {
			texture_id = "crosshair_03"
		},
		style = {
			offset = {
				0,
				0,
				0
			}
		},
		offset = {
			0,
			0,
			0
		}
	},
	crosshair_hit_1 = {
		scenegraph_id = "crosshair_hit",
		element = UIElements.RotatedTexture,
		content = {
			texture_id = "crosshair_01_horizontal"
		},
		style = {
			rotating_texture = {
				angle = 0,
				pivot = {
					5,
					2
				},
				offset = {
					6,
					0,
					0
				},
				color = {
					0,
					255,
					255,
					255
				},
				size = {
					10,
					4
				}
			}
		},
		offset = {
			0,
			0,
			0
		}
	},
	crosshair_hit_2 = {
		scenegraph_id = "crosshair_hit",
		element = UIElements.RotatedTexture,
		content = {
			texture_id = "crosshair_01_horizontal"
		},
		style = {
			rotating_texture = {
				angle = 0,
				pivot = {
					5,
					2
				},
				offset = {
					-6,
					0,
					0
				},
				color = {
					0,
					255,
					255,
					255
				},
				size = {
					10,
					4
				}
			}
		},
		offset = {
			0,
			0,
			0
		}
	},
	crosshair_hit_3 = {
		scenegraph_id = "crosshair_hit",
		element = UIElements.RotatedTexture,
		content = {
			texture_id = "crosshair_01_horizontal"
		},
		style = {
			rotating_texture = {
				angle = 0.5 * var_0_3,
				pivot = {
					5,
					2
				},
				offset = {
					0,
					-6,
					0
				},
				color = {
					0,
					255,
					255,
					255
				},
				size = {
					10,
					4
				}
			}
		},
		offset = {
			0,
			0,
			0
		}
	},
	crosshair_hit_4 = {
		scenegraph_id = "crosshair_hit",
		element = UIElements.RotatedTexture,
		content = {
			texture_id = "crosshair_01_horizontal"
		},
		style = {
			rotating_texture = {
				angle = 0.5 * var_0_3,
				pivot = {
					5,
					2
				},
				offset = {
					0,
					6,
					0
				},
				color = {
					0,
					255,
					255,
					255
				},
				size = {
					10,
					4
				}
			}
		},
		offset = {
			0,
			0,
			0
		}
	},
	crosshair_hit_armored_no_damage = {
		scenegraph_id = "crosshair_hit_armored",
		element = {
			passes = {
				{
					pass_type = "texture",
					texture_id = "texture_id"
				}
			}
		},
		content = {
			texture_id = "enemy_defense_indication_icon"
		},
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = {
				0,
				255,
				255,
				255
			},
			texture_size = {
				55,
				50
			}
		},
		offset = {
			0,
			0,
			0
		}
	},
	crosshair_hit_armored_damage = {
		scenegraph_id = "crosshair_hit_armored",
		element = {
			passes = {
				{
					pass_type = "texture",
					texture_id = "texture_id"
				}
			}
		},
		content = {
			texture_id = "enemy_defense_indication_icon_partial"
		},
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = {
				0,
				255,
				255,
				255
			},
			texture_size = {
				42,
				46
			}
		},
		offset = {
			0,
			0,
			0
		}
	},
	crosshair_hit_armored_break = {
		scenegraph_id = "crosshair_hit_armored",
		element = {
			passes = {
				{
					pass_type = "texture",
					texture_id = "texture_id"
				}
			}
		},
		content = {
			texture_id = "enemy_defense_indication_icon_broken"
		},
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = {
				0,
				255,
				255,
				255
			},
			texture_size = {
				75,
				52
			}
		},
		offset = {
			0,
			0,
			0
		}
	},
	crosshair_hit_armored_open = {
		scenegraph_id = "crosshair_hit_armored",
		element = {
			passes = {
				{
					pass_type = "texture",
					texture_id = "texture_id"
				}
			}
		},
		content = {
			texture_id = "enemy_defense_indication_icon_open"
		},
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = {
				0,
				255,
				255,
				255
			},
			texture_size = {
				42,
				46
			}
		},
		offset = {
			0,
			0,
			0
		}
	},
	crosshair_circle = {
		scenegraph_id = "crosshair_circle",
		element = UIElements.SimpleTexture,
		content = {
			texture_id = "crosshair_02"
		},
		style = {
			offset = {
				0,
				0,
				0
			}
		},
		offset = {
			0,
			0,
			0
		}
	},
	crosshair_wh_priest = {
		scenegraph_id = "crosshair_dot",
		element = {
			passes = {
				{
					pass_type = "rotated_texture",
					style_id = "crosshair_component_1",
					texture_id = "crosshair_component"
				},
				{
					pass_type = "rotated_texture",
					style_id = "crosshair_component_2",
					texture_id = "crosshair_component"
				},
				{
					pass_type = "rotated_texture",
					style_id = "crosshair_component_3",
					texture_id = "crosshair_component"
				},
				{
					pass_type = "rotated_texture",
					style_id = "crosshair_component_4",
					texture_id = "crosshair_component"
				},
				{
					pass_type = "texture",
					style_id = "career_portrait",
					texture_id = "career_portrait"
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_id"
				}
			}
		},
		content = {
			career_portrait = "small_unit_frame_portrait_default",
			text_id = "-",
			crosshair_component = "crosshair_01_horizontal",
			state = "wh_priest_self"
		},
		style = {
			crosshair_component_1 = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				angle = var_0_3 / 6,
				pivot = {
					5,
					2
				},
				offset = {
					-87,
					50,
					0
				},
				color = {
					255,
					255,
					255,
					255
				},
				size = {
					10,
					4
				}
			},
			crosshair_component_2 = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				angle = 11 * var_0_3 / 6,
				pivot = {
					5,
					2
				},
				offset = {
					-87,
					-50,
					0
				},
				color = {
					255,
					255,
					255,
					255
				},
				size = {
					10,
					4
				}
			},
			crosshair_component_3 = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				angle = 7 * var_0_3 / 6,
				pivot = {
					5,
					2
				},
				offset = {
					87,
					-50,
					0
				},
				color = {
					255,
					255,
					255,
					255
				},
				size = {
					10,
					4
				}
			},
			crosshair_component_4 = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				angle = 5 * var_0_3 / 6,
				pivot = {
					5,
					2
				},
				offset = {
					87,
					50,
					0
				},
				color = {
					255,
					255,
					255,
					255
				},
				size = {
					10,
					4
				}
			},
			career_portrait = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					42,
					54
				},
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					70,
					0,
					0
				}
			},
			text = {
				word_wrap = false,
				font_size = 22,
				use_shadow = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 0),
				size = {
					50,
					50
				},
				offset = {
					90,
					-40,
					3
				}
			}
		},
		offset = {
			0,
			0,
			0
		}
	},
	kill_confirm = {
		scenegraph_id = "kill_confirm",
		element = UIElements.SimpleTexture,
		content = {
			texture_id = "crosshair_02"
		},
		style = {
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				0
			}
		}
	}
}
local var_0_6 = {
	normal = {
		color = Colors.color_definitions.hit_marker_normal,
		size = {
			8,
			8
		}
	},
	critical = {
		color = Colors.color_definitions.hit_marker_critical,
		size = {
			12,
			12
		}
	},
	armored = {
		color = Colors.color_definitions.hit_marker_armored,
		size = {
			8,
			8
		}
	},
	friendly = {
		color = Colors.color_definitions.hit_marker_friendly,
		size = {
			8,
			8
		}
	}
}
local var_0_7 = {
	ally_to_self = {
		{
			name = "ally_to_self",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				return
			end,
			update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				local var_2_0 = arg_2_2.style
				local var_2_1 = math.easeOutCubic(arg_2_3)
				local var_2_2 = 100 * math.easeOutCubic(arg_2_3)

				for iter_2_0, iter_2_1 in pairs(var_2_0) do
					if not iter_2_1.angle then
						-- Nothing
					else
						local var_2_3 = iter_2_1.angle
						local var_2_4 = -var_2_2 * math.cos(var_2_3)
						local var_2_5 = var_2_2 * math.sin(var_2_3)

						iter_2_1.offset[1] = var_2_4
						iter_2_1.offset[2] = var_2_5
					end
				end

				var_2_0.career_portrait.color[1] = 255 * (1 - var_2_1)
				var_2_0.text.text_color[1] = 255 * (1 - var_2_1)
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				return
			end
		}
	},
	self_to_ally = {
		{
			name = "self_to_ally",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				return
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				local var_5_0 = arg_5_2.style
				local var_5_1 = math.easeOutCubic(arg_5_3)
				local var_5_2 = 10 + 90 * (1 - math.easeOutCubic(arg_5_3))

				for iter_5_0, iter_5_1 in pairs(var_5_0) do
					if not iter_5_1.angle then
						-- Nothing
					else
						local var_5_3 = iter_5_1.angle
						local var_5_4 = -var_5_2 * math.cos(var_5_3)
						local var_5_5 = var_5_2 * math.sin(var_5_3)

						iter_5_1.offset[1] = var_5_4
						iter_5_1.offset[2] = var_5_5
					end
				end

				var_5_0.career_portrait.color[1] = 255 * var_5_1
				var_5_0.text.text_color[1] = 255 * var_5_1
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end
		}
	}
}

return {
	scenegraph_definition = var_0_4,
	animations_definitions = var_0_7,
	widget_definitions = var_0_5,
	hit_marker_configurations = var_0_6,
	max_spread_pitch = var_0_0,
	max_spread_yaw = var_0_0,
	MAX_SIZE = var_0_0
}
