-- chunkname: @scripts/ui/views/crosshair_ui_definitions.lua

local num = 228
local num_2 = 2
local num_3 = 3
local pi = math.pi
local tbl = {
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
			num,
			num
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
			-(4 + num_3),
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
			-(4 + num_3),
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
			4 + num_3,
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
local tbl_2 = {
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
				tbl.crosshair_arrow.size[1] / 2,
				tbl.crosshair_arrow.size[2] / 2
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
				tbl.crosshair_line.size[1] / 2,
				tbl.crosshair_line.size[2] / 2
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
				tbl.crosshair_shotgun.size[1] / 2,
				tbl.crosshair_shotgun.size[2] / 2
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
				angle = 0.5 * pi,
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
				angle = 0.5 * pi,
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
				angle = pi / 6,
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
				angle = 11 * pi / 6,
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
				angle = 7 * pi / 6,
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
				angle = 5 * pi / 6,
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
local tbl_3 = {
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
local tbl_4 = {
	ally_to_self = {
		{
			name = "ally_to_self",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				-- function 1
				return
			end,
			update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				-- function 2
				local style = arg_2_2.style
				local easeOutCubic = math.easeOutCubic(arg_2_3)
				local num = 100 * math.easeOutCubic(arg_2_3)

				for k, v in pairs(style) do
					if not v.angle then
						-- Nothing
					else
						local angle = v.angle
						local num_2 = -num * math.cos(angle)
						local num_3 = num * math.sin(angle)

						v.offset[1] = num_2
						v.offset[2] = num_3
					end
				end

				style.career_portrait.color[1] = 255 * (1 - easeOutCubic)
				style.text.text_color[1] = 255 * (1 - easeOutCubic)
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				-- function 3
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
				-- function 4
				return
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				-- function 5
				local style = arg_5_2.style
				local easeOutCubic = math.easeOutCubic(arg_5_3)
				local num = 10 + 90 * (1 - math.easeOutCubic(arg_5_3))

				for k, v in pairs(style) do
					if not v.angle then
						-- Nothing
					else
						local angle = v.angle
						local num_2 = -num * math.cos(angle)
						local num_3 = num * math.sin(angle)

						v.offset[1] = num_2
						v.offset[2] = num_3
					end
				end

				style.career_portrait.color[1] = 255 * easeOutCubic
				style.text.text_color[1] = 255 * easeOutCubic
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				-- function 6
				return
			end
		}
	}
}

return {
	scenegraph_definition = tbl,
	animations_definitions = tbl_4,
	widget_definitions = tbl_2,
	hit_marker_configurations = tbl_3,
	max_spread_pitch = num,
	max_spread_yaw = num,
	MAX_SIZE = num
}
