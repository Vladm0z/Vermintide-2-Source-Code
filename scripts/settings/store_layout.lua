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

	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}
	local PLATFORM = PLATFORM

	for i, v in ipairs(StoreDlcSettings) do
		local available_platforms = v.available_platforms

		if not available_platforms and not table.find(available_platforms, PLATFORM) then
			if not v.is_bundle then
				tbl_2[#tbl_2 + 1] = v.dlc_name
				tbl_3[v.dlc_name] = v
			else
				tbl[#tbl + 1] = v.dlc_name
			end
		end
	end

	if not IS_CONSOLE then
		StoreLayoutConfig.pages.bundles = {
			sound_event_enter = "Play_hud_store_category_button",
			layout = "dlc_list",
			display_name = "menu_store_category_title_bundles",
			type = "dlc",
			category_button_texture = "store_category_icon_weapons",
			sort_order = 3,
			content = tbl_2
		}

		for k, v_2 in pairs(tbl_3) do
			StoreLayoutConfig.pages[k] = {
				layout = "item_list",
				type = "bundle_items",
				sort_order = 1,
				dlc_name = v_2.dlc_name,
				bundle_contains = v_2.bundle_contains,
				display_name = v_2.name
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
		content = tbl
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

	for k_2, v_3 in pairs(DLCSettings) do
		local store_layout = v_3.store_layout

		if not store_layout then
			table.append_recursive(StoreLayoutConfig, store_layout)
		end
	end
end

StoreLayoutConfig.make_sort_key = function (self)
	-- function 1
	local get_interface = Managers.backend:get_interface("items")
	local data = self.data
	local key = self.key
	local var_1_3 = key
	local prio = self.prio

	prio = prio or 0

	local num = 0
	local rarity = self.rarity

	rarity = rarity or "plentiful"

	local str = ""
	local flag

	flag = get_interface:has_item(key) or not get_interface:has_weapon_illusion(key) or 2 or 0

	if not data then
		local get_interface_2 = Managers.backend:get_interface("live_events")
		local flag_2 = not get_interface_2 and get_interface_2:get_active_events()

		if not flag_2 then
			local var_1_11

			if not data and not data.events then
				flag_2 = table.mirror_array_inplace(flag_2)

				for i = 1, #data.events do
					local var_1_12 = data.events[i]

					if not table.contains(flag_2, var_1_12) then
						var_1_11 = math.min(var_1_11 or math.huge, flag_2[var_1_12])
					end
				end
			end

			str = (var_1_11 or #flag_2 + 1) .. ".event"
		end

		var_1_3 = data.item_type or self.item_type

		if var_1_3 == "weapon_skin" then
			var_1_3 = data.matching_item_key or "weapon_skin"
		else
			var_1_3 = (var_1_3 ~= "bundle" or not "2.bundle" or var_1_3 ~= "skin") and (not "1.skin" or var_1_3 ~= "hat" or not "0.hat" or key)
		end

		prio = data.prio or prio
		rarity = data.rarity or rarity

		local current_prices = self.current_prices

		if not current_prices then
			num = current_prices.SM or 0
		end

		if flag or not get_interface:has_bundle_contents(data.bundle_contains) then
			flag = 1
		end
	end

	local num_2 = 65536 - prio

	if num_2 <= 0 then
		num_2 = 1
	end

	local format = string.format
	local str_2 = "%01x%s%-16.16s%03x%04x%01x"
	local var_1_17 = flag
	local var_1_18 = str
	local var_1_19 = var_1_3
	local var_1_20 = num_2
	local var_1_21 = num
	local var_1_22 = ORDER_RARITY[rarity]

	var_1_22 = var_1_22 or 0

	return (format(str_2, var_1_17, var_1_18, var_1_19, var_1_20, var_1_21, var_1_22))
end

StoreLayoutConfig.compare_sort_key = function (self, arg_2_1)
	-- function 2
	return self.sort_key < arg_2_1.sort_key
end

StoreLayoutConfig.get_item_filter = function (arg_3_0, arg_3_1)
	-- function 3
	local structure = StoreLayoutConfig.structure
	local pages = StoreLayoutConfig.pages
	local base_filter = StoreLayoutConfig.base_filter
	local flag

	flag = base_filter ~= "" or not 0 or 1

	for i, v in ipairs(arg_3_0) do
		local var_3_4 = pages[v]

		var_3_4 = var_3_4 or arg_3_1(v)

		local item_filter = var_3_4.item_filter

		if not var_3_4.exclusive_filter then
			base_filter = StoreLayoutConfig.base_filter .. " and " .. item_filter
			flag = 1
		elseif not item_filter then
			base_filter = base_filter .. " and " .. item_filter
			flag = flag + 1
		end

		if type(structure) == "table" then
			structure = structure[v]
		end
	end

	if type(structure) == "table" then
		local _get_sub_filter = StoreLayoutConfig._get_sub_filter(structure)

		if not _get_sub_filter then
			base_filter = base_filter .. " and ( " .. _get_sub_filter .. " ) "
		end
	end

	return base_filter
end

StoreLayoutConfig._get_sub_filter = function (arg_4_0)
	-- function 4
	local pages = StoreLayoutConfig.pages
	local var_4_1

	for k, v in pairs(arg_4_0) do
		local var_4_2
		local var_4_3 = pages[k]

		if not var_4_3 then
			var_4_2 = var_4_3.item_filter
		end

		if type(v) == "table" then
			local _get_sub_filter = StoreLayoutConfig._get_sub_filter(v)

			if not _get_sub_filter then
				if not var_4_2 then
					var_4_2 = var_4_2 .. " and ( " .. _get_sub_filter .. " ) "
				else
					var_4_2 = _get_sub_filter
				end
			end
		end

		if not var_4_2 then
			if not var_4_1 then
				var_4_1 = var_4_1 .. " or ( " .. var_4_2 .. " ) "
			else
				var_4_1 = " ( " .. var_4_2 .. " ) "
			end
		end
	end

	return var_4_1
end
