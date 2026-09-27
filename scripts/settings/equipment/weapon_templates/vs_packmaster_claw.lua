-- chunkname: @scripts/settings/equipment/weapon_templates/vs_packmaster_claw.lua

local tbl = {
	actions = {},
	right_hand_attachment_node_linking = AttachmentNodeLinking.vs_packmaster_claw
}

tbl.wield_anim = "idle"
tbl.display_unit = "units/weapons/weapon_display/display_2h_weapon"
tbl.buff_type = "MELEE_2H"
tbl.weapon_type = "POLEARM"
tbl.max_fatigue_points = 6
tbl.dodge_count = 3
tbl.block_angle = 90
tbl.outer_block_angle = 360
tbl.block_fatigue_point_multiplier = 0.5
tbl.outer_block_fatigue_point_multiplier = 2
tbl.sound_event_block_within_arc = "weapon_foley_blunt_1h_block_wood"
tbl.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 1.2
	},
	change_dodge_speed = {
		external_optional_multiplier = 1.2
	}
}
tbl.attack_meta_data = {
	tap_attack = {
		arc = 0
	},
	hold_attack = {
		arc = 0
	}
}
tbl.aim_assist_settings = {
	max_range = 5,
	no_aim_input_multiplier = 0,
	vertical_only = true,
	base_multiplier = 0,
	effective_max_range = 4,
	breed_scalars = {
		skaven_storm_vermin = 1,
		skaven_clan_rat = 0.5,
		skaven_slave = 0.5
	}
}
tbl.tooltip_keywords = {
	"weapon_keyword_high_damage",
	"weapon_keyword_armour_piercing",
	"weapon_keyword_shield_breaking"
}
tbl.tooltip_compare = {
	light = {
		action_name = "action_one",
		sub_action_name = "light_attack_left"
	},
	heavy = {
		action_name = "action_one",
		sub_action_name = "heavy_attack_left"
	}
}
tbl.tooltip_detail = {
	light = {
		action_name = "action_one",
		sub_action_name = "default"
	},
	heavy = {
		action_name = "action_one",
		sub_action_name = "default"
	},
	push = {
		action_name = "action_one",
		sub_action_name = "push"
	}
}
tbl.wwise_dep_right_hand = {
	"wwise/one_handed_axes"
}

local clone = table.clone(tbl)

clone.crosshair_style = "dot"

local clone_2 = table.clone(tbl)

clone_2.right_hand_attachment_node_linking = AttachmentNodeLinking.vs_poison_wind_globadier_orb
clone_2.crosshair_style = "dot"

local clone_3 = table.clone(tbl)

clone_3.right_hand_attachment_node_linking = AttachmentNodeLinking.vs_gutter_runner_claws.right
clone_3.left_hand_attachment_node_linking = AttachmentNodeLinking.vs_gutter_runner_claws.left
clone_3.crosshair_style = "dot"

return {
	vs_packmaster_claw = clone,
	vs_poison_wind_globadier_orb = clone_2,
	vs_gutter_runner_claws = clone_3
}
