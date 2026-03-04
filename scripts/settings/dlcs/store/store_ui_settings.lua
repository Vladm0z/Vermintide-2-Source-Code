-- chunkname: @scripts/settings/dlcs/store/store_ui_settings.lua

local var_0_0 = DLCSettings.store

var_0_0.hero_view = {
	store = {
		filename = "scripts/ui/views/hero_view/states/hero_view_state_store"
	}
}
var_0_0.hero_view_settings_by_screen = {
	{
		name = "store",
		hotkey_disabled = false,
		state_name = "HeroViewStateStore",
		draw_background_world = false,
		camera_position = {
			0,
			0,
			0
		},
		camera_rotation = {
			0,
			0,
			0
		}
	}
}
var_0_0.controller_settings = {
	IngameMenuKeymaps = {
		win32 = {
			hotkey_store = {
				"keyboard",
				"p",
				"pressed"
			}
		}
	}
}
var_0_0.hotkey_mapping = {
	hotkey_store = {
		in_transition = "hero_view_force",
		error_message = "matchmaking_ready_interaction_message_store",
		view = "hero_view",
		transition_state = "store",
		in_transition_menu = "hero_view",
		disable_for_mechanism = {
			adventure = {
				matchmaking = false,
				matchmaking_ready = true,
				not_matchmaking = false
			},
			versus = {
				matchmaking = false,
				matchmaking_ready = true,
				not_matchmaking = false
			},
			deus = {
				matchmaking = false,
				matchmaking_ready = true,
				not_matchmaking = false
			}
		}
	}
}
var_0_0.store_state_filenames = {
	"scripts/ui/ui_widgets_store",
	"scripts/settings/store_dlc_settings",
	"scripts/settings/store_bundle_layouts",
	"scripts/settings/store_bundle_featured_settings",
	"scripts/settings/store_layout",
	"scripts/ui/views/store_welcome_popup",
	"scripts/ui/views/store_item_purchase_popup",
	"scripts/ui/views/store_login_rewards_popup",
	"scripts/ui/views/hero_view/states/store_window_layout",
	"scripts/ui/views/hero_view/windows/store/store_window_item_list",
	"scripts/ui/views/hero_view/windows/store/store_window_panel",
	"scripts/ui/views/hero_view/windows/store/store_window_background",
	"scripts/ui/views/hero_view/windows/store/store_window_category_list",
	"scripts/ui/views/hero_view/windows/store/store_window_item_preview",
	"scripts/ui/views/hero_view/windows/store/store_window_path_title",
	"scripts/ui/views/hero_view/windows/store/store_window_featured",
	"scripts/ui/views/hero_view/windows/store/store_window_item_details",
	"scripts/ui/views/hero_view/windows/store/store_window_category_item_list"
}
var_0_0.ui_materials_in_inn = {
	"materials/ui/ui_1080p_store_menu"
}
var_0_0.ui_texture_settings = {
	filenames = {
		"scripts/ui/atlas_settings/gui_store_menu_atlas"
	},
	atlas_settings = {
		store_menu_atlas = {
			offscreen_material_name = "gui_store_menu_atlas_offscreen",
			masked_point_sample_material_name = "gui_store_menu_atlas_point_sample_masked",
			masked_offscreen_material_name = "gui_store_menu_atlas_masked_offscreen",
			point_sample_offscreen_material_name = "gui_store_menu_atlas_point_sample_offscreen",
			saturated_material_name = "gui_store_menu_atlas_saturated",
			masked_material_name = "gui_store_menu_atlas_masked",
			point_sample_material_name = "gui_store_menu_atlas_point_sample",
			masked_saturated_material_name = "gui_store_menu_atlas_masked_saturated",
			saturated_offscreen_material_name = "gui_store_menu_atlas_saturated",
			masked_point_sample_offscreen_material_name = "gui_store_menu_atlas_point_sample_masked_offscreen",
			material_name = "gui_store_menu_atlas"
		}
	},
	single_textures = {
		"dlc_store_banner_bogenhafen",
		"dlc_store_banner_premium",
		"dlc_store_banner_holly",
		"dlc_store_banner_wom"
	}
}
var_0_0.currency_ui_settings = {
	SM = {
		name = "menu_store_panel_currency_tooltip_title",
		icon_small = "store_icon_currency_ingame",
		frame = "button_frame_01_gold",
		icon_big = "store_icon_currency_ingame_big",
		tooltip_input = "menu_store_panel_currency_tooltip_obtain_desc",
		currency_type = "SM",
		tooltip_description = "menu_store_panel_currency_tooltip_desc",
		tooltip_title = "menu_store_panel_currency_tooltip_title",
		background_ui_settings = {
			texture = "menu_frame_bg_07",
			size = {
				512,
				256
			}
		}
	},
	VS = {
		name = "menu_store_versus_panel_currency_tooltip_title",
		icon_small = "store_icon_currency_versus_coin",
		max_amount = 999,
		frame = "button_frame_01_gold",
		icon_big = "store_icon_currency_versus_coin_big",
		tooltip_input = "menu_store_panel_versus_currency_tooltip_obtain_desc",
		currency_type = "VS",
		tooltip_description = "menu_store_panel_versus_currency_tooltip_desc",
		tooltip_title = "menu_store_versus_panel_currency_tooltip_title",
		background_ui_settings = {
			texture = "menu_frame_bg_07",
			size = {
				512,
				256
			}
		}
	}
}
var_0_0.allowed_store_item_types = {
	weapon_pose = true,
	weapon_skin = true,
	hat = true,
	chips = true,
	frame = true,
	skin = true,
	weapon_pose_bundle = true
}
var_0_0.currency_types = {
	[1] = "SM",
	[2] = "VS"
}
