-- chunkname: @scripts/settings/store_layout.lua

require("scripts/settings/store_dlc_settings")

if not StoreLayoutConfig then
	StoreLayoutConfig = {
		base_filter = "( not is_event_item or is_active_event_item )",
		menu_options = {
			"featured",
			"cosmetics",
			"bundles",
			"dlc",
			"versus"
		},
		pages = {},
		structure = {},
		global_shader_flag_overrides = {
			NECROMANCER_CAREER_REMAP = false
		}
	}
	StoreLayoutConfig.structure = {
		bundles = 1,
		dlc = 1,
		featured = 1,
		cosmetics = {
			frames = "item_details",
			bardin = {
				ranger = {
					weapon_skins = "item_details",
					hats = "item_details",
					skins = "item_details"
				},
				ironbreaker = {
					weapon_skins = "item_details",
					hats = "item_details",
					skins = "item_details"
				},
				slayer = {
					weapon_skins = "item_details",
					hats = "item_details",
					skins = "item_details"
				},
				engineer = {
					weapon_skins = "item_details",
					hats = "item_details",
					skins = "item_details"
				}
			},
			kruber = {
				mercenary = {
					weapon_skins = "item_details",
					hats = "item_details",
					skins = "item_details"
				},
				huntsman = {
					weapon_skins = "item_details",
					hats = "item_details",
					skins = "item_details"
				},
				knight = {
					weapon_skins = "item_details",
					hats = "item_details",
					skins = "item_details"
				},
				questingknight = {
					weapon_skins = "item_details",
					hats = "item_details",
					skins = "item_details"
				}
			},
			kerillian = {
				waywatcher = {
					weapon_skins = "item_details",
					hats = "item_details",
					skins = "item_details"
				},
				maidenguard = {
					weapon_skins = "item_details",
					hats = "item_details",
					skins = "item_details"
				},
				shade = {
					weapon_skins = "item_details",
					hats = "item_details",
					skins = "item_details"
				}
			},
			victor = {
				captain = {
					weapon_skins = "item_details",
					hats = "item_details",
					skins = "item_details"
				},
				bountyhunter = {
					weapon_skins = "item_details",
					hats = "item_details",
					skins = "item_details"
				},
				zealot = {
					weapon_skins = "item_details",
					hats = "item_details",
					skins = "item_details"
				},
				priest = {
					weapon_skins = "item_details",
					hats = "item_details",
					skins = "item_details"
				}
			},
			sienna = {
				scholar = {
					weapon_skins = "item_details",
					hats = "item_details",
					skins = "item_details"
				},
				adept = {
					weapon_skins = "item_details",
					hats = "item_details",
					skins = "item_details"
				},
				unchained = {
					weapon_skins = "item_details",
					hats = "item_details",
					skins = "item_details"
				}
			},
			event = {
				weapon_skins = "item_details",
				hats = "item_details",
				skins = "item_details",
				frames = "item_details"
			}
		},
		versus = {
			frames = "item_details",
			pactsworn = "item_details",
			weapon_skins_versus = {
				sienna_versus = "item_list",
				bardin_versus = "item_list",
				kruber_versus = "item_list",
				victor_versus = "item_list",
				kerillian_versus = "item_list"
			},
			poses = {
				kruber_poses = "pose_items",
				sienna_poses = "pose_items",
				kerillian_poses = "pose_items",
				bardin_poses = "pose_items",
				victor_poses = "pose_items"
			}
		}
	}
	StoreLayoutConfig.pages.featured = {
		sound_event_enter = "Play_hud_store_category_front",
		layout = "featured",
		display_name = "menu_store_panel_title_featured",
		rotation_timer = false,
		slideshow = {},
		grid = {}
	}
	StoreLayoutConfig.pages.cosmetics = {
		sound_event_enter = "Play_hud_store_category_cosmetics",
		layout = "category",
		item_filter = "item_type ~= bundle and default_selection",
		display_name = "menu_store_panel_title_cosmetics",
		global_shader_flag_overrides = {
			NECROMANCER_CAREER_REMAP = false
		}
	}
	StoreLayoutConfig.pages.discount_tab = {
		sound_event_enter = "Play_hud_store_category_cosmetics",
		layout = "item_list",
		item_filter = "discounted_items",
		type = "item",
		display_name = "menu_store_panel_title_discounts"
	}

	local var_0_0 = {}
	local var_0_1 = {}
	local var_0_2 = {}
	local var_0_3 = PLATFORM

	for iter_0_0, iter_0_1 in ipairs(StoreDlcSettings) do
		local var_0_4 = iter_0_1.available_platforms

		if not var_0_4 or table.find(var_0_4, var_0_3) then
			if iter_0_1.is_bundle then
				var_0_1[#var_0_1 + 1] = iter_0_1.dlc_name
				var_0_2[iter_0_1.dlc_name] = iter_0_1
			else
				var_0_0[#var_0_0 + 1] = iter_0_1.dlc_name
			end
		end
	end

	if IS_CONSOLE then
		StoreLayoutConfig.pages.bundles = {
			sound_event_enter = "Play_hud_store_category_button",
			layout = "dlc_list",
			display_name = "menu_store_category_title_bundles",
			type = "dlc",
			category_button_texture = "store_category_icon_weapons",
			sort_order = 3,
			content = var_0_1
		}

		for iter_0_2, iter_0_3 in pairs(var_0_2) do
			StoreLayoutConfig.pages[iter_0_2] = {
				layout = "item_list",
				type = "bundle_items",
				sort_order = 1,
				dlc_name = iter_0_3.dlc_name,
				bundle_contains = iter_0_3.bundle_contains,
				display_name = iter_0_3.name
			}
		end
	else
		StoreLayoutConfig.pages.bundles = {
			sound_event_enter = "Play_hud_store_category_button",
			layout = "bundle_list",
			display_name = "menu_store_category_title_bundles",
			type = "item",
			item_filter = "item_type == bundle",
			sort_order = 3,
			category_button_texture = "store_category_icon_weapons"
		}
	end

	StoreLayoutConfig.pages.dlc = {
		sound_event_enter = "Play_hud_store_category_dlc",
		layout = "dlc_list",
		display_name = "menu_store_panel_title_dlcs",
		type = "dlc",
		content = var_0_0
	}

	if not IS_CONSOLE then
		StoreLayoutConfig.pages.versus = {
			sound_event_enter = "Play_hud_store_category_cosmetics",
			layout = "category",
			item_filter = "selection == versus and item_type ~= weapon_pose_bundle",
			display_name = "menu_store_panel_title_versus",
			global_shader_flag_overrides = {
				NECROMANCER_CAREER_REMAP = false
			}
		}
	end

	StoreLayoutConfig.pages.item_details = {
		layout = "item_detailed",
		display_name = "item_details",
		type = "item"
	}
	StoreLayoutConfig.pages.all_items = {
		layout = "item_list",
		display_name = "menu_store_category_title_all",
		type = "item"
	}
	StoreLayoutConfig.pages.hats = {
		sound_event_enter = "Play_hud_store_category_button",
		layout = "item_list",
		display_name = "menu_store_category_title_character_hats",
		type = "item",
		item_filter = "item_type == hat",
		sort_order = 1,
		category_button_texture = "store_category_icon_hats"
	}
	StoreLayoutConfig.pages.skins = {
		sound_event_enter = "Play_hud_store_category_button",
		layout = "item_list",
		display_name = "menu_store_category_title_character_skins",
		type = "item",
		item_filter = "item_type == skin and not is_pactsworn_item",
		sort_order = 2,
		category_button_texture = "store_category_icon_skins"
	}
	StoreLayoutConfig.pages.weapon_skins = {
		sound_event_enter = "Play_hud_store_category_button",
		layout = "item_list",
		display_name = "menu_store_category_title_weapon_illusions",
		type = "item",
		item_filter = "item_type == weapon_skin",
		sort_order = 3,
		category_button_texture = "store_category_icon_weapons"
	}
	StoreLayoutConfig.pages.frames = {
		sound_event_enter = "Play_hud_store_category_button",
		layout = "item_list",
		display_name = "frame",
		type = "item",
		item_filter = "item_type == frame",
		sort_order = 99,
		category_button_texture = "store_category_icon_portrait_frames"
	}

	if not IS_CONSOLE then
		StoreLayoutConfig.pages.pose_items = {
			sound_event_enter = "Play_hud_store_category_button",
			layout = "category",
			display_name = "weapon_pose",
			type = "collection_item",
			item_filter = "item_type == weapon_pose_bundle and selection == versus",
			sort_order = 6,
			category_button_texture = "store_category_icon_poses",
			exclusive_filter = true
		}
		StoreLayoutConfig.pages.weapon_skins_versus = {
			sound_event_enter = "Play_hud_store_category_button",
			layout = "category",
			display_name = "menu_store_category_title_weapon_illusions",
			type = "item",
			item_filter = "item_type == weapon_skin and selection == versus",
			sort_order = 3,
			category_button_texture = "store_category_icon_weapons"
		}
		StoreLayoutConfig.pages.poses = {
			sound_event_enter = "Play_hud_store_category_button",
			layout = "category",
			display_name = "weapon_pose",
			item_filter = "item_type == weapon_pose_bundle and selection == versus",
			category_button_texture = "store_category_icon_poses",
			exclusive_filter = true,
			global_shader_flag_overrides = {
				NECROMANCER_CAREER_REMAP = false
			}
		}
		StoreLayoutConfig.pages.kerillian_poses = {
			sound_event_enter = "Play_hud_store_kerillian",
			layout = "category",
			item_filter = "item_type == weapon_pose_bundle and selection == versus and can_wield_wood_elf",
			type = "collection_item",
			display_name = "inventory_name_wood_elf",
			sort_order = 3,
			category_button_texture = "store_category_icon_kerillian_waystalker"
		}
		StoreLayoutConfig.pages.kruber_poses = {
			sound_event_enter = "Play_hud_store_kruber",
			layout = "category",
			item_filter = "item_type == weapon_pose_bundle and selection == versus and can_wield_empire_soldier",
			type = "collection_item",
			display_name = "inventory_name_empire_soldier",
			sort_order = 1,
			category_button_texture = "store_category_icon_kruber_mercenary"
		}
		StoreLayoutConfig.pages.bardin_poses = {
			sound_event_enter = "Play_hud_store_bardin",
			layout = "category",
			item_filter = "item_type == weapon_pose_bundle and selection == versus and can_wield_dwarf_ranger",
			type = "collection_item",
			display_name = "inventory_name_dwarf_ranger",
			sort_order = 2,
			category_button_texture = "store_category_icon_bardin_ranger"
		}
		StoreLayoutConfig.pages.victor_poses = {
			sound_event_enter = "Play_hud_store_saltzpyre",
			layout = "category",
			item_filter = "item_type == weapon_pose_bundle and selection == versus and can_wield_witch_hunter",
			type = "collection_item",
			display_name = "inventory_name_witch_hunter",
			sort_order = 4,
			category_button_texture = "store_category_icon_victor_captain"
		}
		StoreLayoutConfig.pages.sienna_poses = {
			sound_event_enter = "Play_hud_store_sienna",
			layout = "category",
			item_filter = "item_type == weapon_pose_bundle and selection == versus and can_wield_bright_wizard",
			type = "collection_item",
			display_name = "inventory_name_bright_wizard",
			sort_order = 5,
			category_button_texture = "store_category_icon_sienna_scholar"
		}
		StoreLayoutConfig.pages.kerillian_versus = {
			sound_event_enter = "Play_hud_store_kerillian",
			layout = "item_list",
			item_filter = "item_type == weapon_skin and selection == versus and can_wield_wood_elf",
			type = "item",
			display_name = "inventory_name_wood_elf",
			sort_order = 3,
			category_button_texture = "store_category_icon_kerillian_waystalker"
		}
		StoreLayoutConfig.pages.kruber_versus = {
			sound_event_enter = "Play_hud_store_kruber",
			layout = "item_list",
			item_filter = "item_type == weapon_skin and selection == versus and can_wield_empire_soldier",
			type = "item",
			display_name = "inventory_name_empire_soldier",
			sort_order = 1,
			category_button_texture = "store_category_icon_kruber_mercenary"
		}
		StoreLayoutConfig.pages.bardin_versus = {
			sound_event_enter = "Play_hud_store_bardin",
			layout = "item_list",
			item_filter = "item_type == weapon_skin and selection == versus and can_wield_dwarf_ranger",
			type = "item",
			display_name = "inventory_name_dwarf_ranger",
			sort_order = 2,
			category_button_texture = "store_category_icon_bardin_ranger"
		}
		StoreLayoutConfig.pages.victor_versus = {
			sound_event_enter = "Play_hud_store_saltzpyre",
			layout = "item_list",
			item_filter = "item_type == weapon_skin and selection == versus and can_wield_witch_hunter",
			type = "item",
			display_name = "inventory_name_witch_hunter",
			sort_order = 4,
			category_button_texture = "store_category_icon_victor_captain"
		}
		StoreLayoutConfig.pages.sienna_versus = {
			sound_event_enter = "Play_hud_store_sienna",
			layout = "item_list",
			item_filter = "item_type == weapon_skin and selection == versus and can_wield_bright_wizard",
			type = "item",
			display_name = "inventory_name_bright_wizard",
			sort_order = 5,
			category_button_texture = "store_category_icon_sienna_scholar"
		}
		StoreLayoutConfig.pages.pactsworn = {
			sound_event_enter = "Play_hud_store_category_button",
			layout = "item_list",
			display_name = "dark_pact_skin",
			type = "item",
			item_filter = "is_pactsworn_item",
			sort_order = 5,
			category_button_texture = "store_category_icon_pactsworn"
		}
	end

	StoreLayoutConfig.pages.event = {
		sound_event_enter = "Play_hud_store_category_button",
		layout = "item_list",
		display_name = "achv_menu_event_category_title",
		type = "item",
		item_filter = "is_active_event_item",
		sort_order = 100,
		category_button_texture = "store_category_icon_event",
		exclusive_filter = true
	}
	StoreLayoutConfig.pages.bardin = {
		sound_event_enter = "Play_hud_store_bardin",
		layout = "category",
		display_name = "inventory_name_dwarf_ranger",
		item_filter = "can_wield_dwarf_ranger and item_type ~= frame",
		sort_order = 2,
		category_button_texture = "store_category_icon_bardin_ranger"
	}
	StoreLayoutConfig.pages.ironbreaker = {
		sound_event_enter = "Play_hud_store_category_button",
		layout = "category",
		display_name = "dr_ironbreaker",
		item_filter = "can_wield_dr_ironbreaker",
		sort_order = 2,
		category_button_texture = "store_category_icon_bardin_ironbreaker"
	}
	StoreLayoutConfig.pages.slayer = {
		sound_event_enter = "Play_hud_store_category_button",
		layout = "category",
		display_name = "dr_slayer",
		item_filter = "can_wield_dr_slayer",
		sort_order = 3,
		category_button_texture = "store_category_icon_bardin_slayer"
	}
	StoreLayoutConfig.pages.ranger = {
		sound_event_enter = "Play_hud_store_category_button",
		layout = "category",
		display_name = "dr_ranger",
		item_filter = "can_wield_dr_ranger",
		sort_order = 1,
		category_button_texture = "store_category_icon_bardin_ranger"
	}
	StoreLayoutConfig.pages.engineer = {
		sound_event_enter = "Play_hud_store_category_button",
		layout = "category",
		display_name = "dr_engineer",
		item_filter = "can_wield_dr_engineer",
		sort_order = 4,
		category_button_texture = "store_category_icon_bardin_engineer"
	}
	StoreLayoutConfig.pages.kruber = {
		sound_event_enter = "Play_hud_store_kruber",
		layout = "category",
		display_name = "inventory_name_empire_soldier",
		item_filter = "can_wield_empire_soldier and item_type ~= frame",
		sort_order = 1,
		category_button_texture = "store_category_icon_kruber_mercenary"
	}
	StoreLayoutConfig.pages.huntsman = {
		sound_event_enter = "Play_hud_store_category_button",
		layout = "category",
		display_name = "es_huntsman",
		item_filter = "can_wield_es_huntsman",
		sort_order = 2,
		category_button_texture = "store_category_icon_kruber_huntsman"
	}
	StoreLayoutConfig.pages.knight = {
		sound_event_enter = "Play_hud_store_category_button",
		layout = "category",
		display_name = "es_knight",
		item_filter = "can_wield_es_knight",
		sort_order = 3,
		category_button_texture = "store_category_icon_kruber_knight"
	}
	StoreLayoutConfig.pages.mercenary = {
		sound_event_enter = "Play_hud_store_category_button",
		layout = "category",
		display_name = "es_mercenary",
		item_filter = "can_wield_es_mercenary",
		sort_order = 1,
		category_button_texture = "store_category_icon_kruber_mercenary"
	}
	StoreLayoutConfig.pages.questingknight = {
		sound_event_enter = "Play_hud_store_category_button",
		layout = "category",
		display_name = "es_questingknight",
		item_filter = "can_wield_es_questingknight",
		sort_order = 4,
		category_button_texture = "store_category_icon_kruber_questingknight"
	}
	StoreLayoutConfig.pages.kerillian = {
		sound_event_enter = "Play_hud_store_kerillian",
		layout = "category",
		display_name = "inventory_name_wood_elf",
		item_filter = "can_wield_wood_elf and item_type ~= frame",
		sort_order = 3,
		category_button_texture = "store_category_icon_kerillian_waystalker"
	}
	StoreLayoutConfig.pages.waywatcher = {
		sound_event_enter = "Play_hud_store_category_button",
		layout = "category",
		display_name = "we_waywatcher",
		item_filter = "can_wield_we_waywatcher",
		sort_order = 1,
		category_button_texture = "store_category_icon_kerillian_waystalker"
	}
	StoreLayoutConfig.pages.maidenguard = {
		sound_event_enter = "Play_hud_store_category_button",
		layout = "category",
		display_name = "we_maidenguard",
		item_filter = "can_wield_we_maidenguard",
		sort_order = 2,
		category_button_texture = "store_category_icon_kerillian_handmaiden"
	}
	StoreLayoutConfig.pages.shade = {
		sound_event_enter = "Play_hud_store_category_button",
		layout = "category",
		display_name = "we_shade",
		item_filter = "can_wield_we_shade",
		sort_order = 3,
		category_button_texture = "store_category_icon_kerillian_shade"
	}
	StoreLayoutConfig.pages.thornsister = {
		sound_event_enter = "Play_hud_store_category_button",
		layout = "category",
		display_name = "we_thornsister",
		item_filter = "can_wield_we_thornsister",
		sort_order = 4,
		category_button_texture = "store_category_icon_kerillian_thornsister"
	}
	StoreLayoutConfig.pages.victor = {
		sound_event_enter = "Play_hud_store_saltzpyre",
		layout = "category",
		display_name = "inventory_name_witch_hunter",
		item_filter = "can_wield_witch_hunter and item_type ~= frame",
		sort_order = 4,
		category_button_texture = "store_category_icon_victor_captain"
	}
	StoreLayoutConfig.pages.captain = {
		sound_event_enter = "Play_hud_store_category_button",
		layout = "category",
		display_name = "wh_captain",
		item_filter = "can_wield_wh_captain",
		sort_order = 1,
		category_button_texture = "store_category_icon_victor_captain"
	}
	StoreLayoutConfig.pages.bountyhunter = {
		sound_event_enter = "Play_hud_store_category_button",
		layout = "category",
		display_name = "wh_bountyhunter",
		item_filter = "can_wield_wh_bountyhunter",
		sort_order = 2,
		category_button_texture = "store_category_icon_victor_bountyhunter"
	}
	StoreLayoutConfig.pages.zealot = {
		sound_event_enter = "Play_hud_store_category_button",
		layout = "category",
		display_name = "wh_zealot",
		item_filter = "can_wield_wh_zealot",
		sort_order = 3,
		category_button_texture = "store_category_icon_victor_zealot"
	}
	StoreLayoutConfig.pages.priest = {
		sound_event_enter = "Play_hud_store_category_button",
		layout = "category",
		display_name = "wh_priest",
		item_filter = "can_wield_wh_priest",
		sort_order = 4,
		category_button_texture = "store_category_icon_priest"
	}
	StoreLayoutConfig.pages.sienna = {
		sound_event_enter = "Play_hud_store_sienna",
		layout = "category",
		display_name = "inventory_name_bright_wizard",
		item_filter = "can_wield_bright_wizard and item_type ~= frame",
		sort_order = 5,
		category_button_texture = "store_category_icon_sienna_scholar"
	}
	StoreLayoutConfig.pages.scholar = {
		sound_event_enter = "Play_hud_store_category_button",
		layout = "category",
		display_name = "bw_scholar",
		item_filter = "can_wield_bw_scholar",
		sort_order = 2,
		category_button_texture = "store_category_icon_sienna_scholar"
	}
	StoreLayoutConfig.pages.adept = {
		sound_event_enter = "Play_hud_store_category_button",
		layout = "category",
		display_name = "bw_adept",
		item_filter = "can_wield_bw_adept",
		sort_order = 1,
		category_button_texture = "store_category_icon_sienna_adept"
	}
	StoreLayoutConfig.pages.unchained = {
		sound_event_enter = "Play_hud_store_category_button",
		layout = "category",
		display_name = "bw_unchained",
		item_filter = "can_wield_bw_unchained",
		sort_order = 3,
		category_button_texture = "store_category_icon_sienna_unchained"
	}
	StoreLayoutConfig.pages.discounts = {
		sound_event_enter = "Play_hud_store_kruber",
		layout = "category",
		display_name = "inventory_discounts",
		item_filter = "discounted_items",
		sort_order = 6,
		category_button_texture = "store_category_icon_kruber_mercenary"
	}

	for iter_0_4, iter_0_5 in pairs(DLCSettings) do
		local var_0_5 = iter_0_5.store_layout

		if var_0_5 then
			table.append_recursive(StoreLayoutConfig, var_0_5)
		end
	end
end

StoreLayoutConfig.make_sort_key = function (arg_1_0)
	local var_1_0 = Managers.backend:get_interface("items")
	local var_1_1 = arg_1_0.data
	local var_1_2 = arg_1_0.key
	local var_1_3 = var_1_2
	local var_1_4 = arg_1_0.prio or 0
	local var_1_5 = 0
	local var_1_6 = arg_1_0.rarity or "plentiful"
	local var_1_7 = ""
	local var_1_8 = (var_1_0:has_item(var_1_2) or var_1_0:has_weapon_illusion(var_1_2)) and 2 or 0

	if var_1_1 then
		local var_1_9 = Managers.backend:get_interface("live_events")
		local var_1_10 = var_1_9 and var_1_9:get_active_events()

		if var_1_10 then
			local var_1_11

			if var_1_1 and var_1_1.events then
				var_1_10 = table.mirror_array_inplace(var_1_10)

				for iter_1_0 = 1, #var_1_1.events do
					local var_1_12 = var_1_1.events[iter_1_0]

					if table.contains(var_1_10, var_1_12) then
						var_1_11 = math.min(var_1_11 or math.huge, var_1_10[var_1_12])
					end
				end
			end

			var_1_7 = (var_1_11 or #var_1_10 + 1) .. ".event"
		end

		var_1_3 = var_1_1.item_type or arg_1_0.item_type

		if var_1_3 == "weapon_skin" then
			var_1_3 = var_1_1.matching_item_key or "weapon_skin"
		else
			var_1_3 = var_1_3 == "bundle" and "2.bundle" or var_1_3 == "skin" and "1.skin" or var_1_3 == "hat" and "0.hat" or var_1_2
		end

		var_1_4 = var_1_1.prio or var_1_4
		var_1_6 = var_1_1.rarity or var_1_6

		local var_1_13 = arg_1_0.current_prices

		if var_1_13 then
			var_1_5 = var_1_13.SM or 0
		end

		if not var_1_8 and var_1_0:has_bundle_contents(var_1_1.bundle_contains) then
			var_1_8 = 1
		end
	end

	local var_1_14 = 65536 - var_1_4

	if var_1_14 <= 0 then
		var_1_14 = 1
	end

	return (string.format("%01x%s%-16.16s%03x%04x%01x", var_1_8, var_1_7, var_1_3, var_1_14, var_1_5, ORDER_RARITY[var_1_6] or 0))
end

StoreLayoutConfig.compare_sort_key = function (arg_2_0, arg_2_1)
	return arg_2_0.sort_key < arg_2_1.sort_key
end

StoreLayoutConfig.get_item_filter = function (arg_3_0, arg_3_1)
	local var_3_0 = StoreLayoutConfig.structure
	local var_3_1 = StoreLayoutConfig.pages
	local var_3_2 = StoreLayoutConfig.base_filter
	local var_3_3 = var_3_2 == "" and 0 or 1

	for iter_3_0, iter_3_1 in ipairs(arg_3_0) do
		local var_3_4 = var_3_1[iter_3_1] or arg_3_1(iter_3_1)
		local var_3_5 = var_3_4.item_filter

		if var_3_4.exclusive_filter then
			var_3_2 = StoreLayoutConfig.base_filter .. " and " .. var_3_5
			var_3_3 = 1
		elseif var_3_5 then
			var_3_2 = var_3_2 .. " and " .. var_3_5
			var_3_3 = var_3_3 + 1
		end

		if type(var_3_0) == "table" then
			var_3_0 = var_3_0[iter_3_1]
		end
	end

	if type(var_3_0) == "table" then
		local var_3_6 = StoreLayoutConfig._get_sub_filter(var_3_0)

		if var_3_6 then
			var_3_2 = var_3_2 .. " and ( " .. var_3_6 .. " ) "
		end
	end

	return var_3_2
end

StoreLayoutConfig._get_sub_filter = function (arg_4_0)
	local var_4_0 = StoreLayoutConfig.pages
	local var_4_1

	for iter_4_0, iter_4_1 in pairs(arg_4_0) do
		local var_4_2
		local var_4_3 = var_4_0[iter_4_0]

		if var_4_3 then
			var_4_2 = var_4_3.item_filter
		end

		if type(iter_4_1) == "table" then
			local var_4_4 = StoreLayoutConfig._get_sub_filter(iter_4_1)

			if var_4_4 then
				if var_4_2 then
					var_4_2 = var_4_2 .. " and ( " .. var_4_4 .. " ) "
				else
					var_4_2 = var_4_4
				end
			end
		end

		if var_4_2 then
			if var_4_1 then
				var_4_1 = var_4_1 .. " or ( " .. var_4_2 .. " ) "
			else
				var_4_1 = " ( " .. var_4_2 .. " ) "
			end
		end
	end

	return var_4_1
end
