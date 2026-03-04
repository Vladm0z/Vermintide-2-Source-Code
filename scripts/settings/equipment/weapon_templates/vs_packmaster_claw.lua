-- chunkname: @scripts/settings/equipment/weapon_templates/vs_packmaster_claw.lua

local var_0_0 = {
	actions = {},
	right_hand_attachment_node_linking = AttachmentNodeLinking.vs_packmaster_claw
}

var_0_0.wield_anim = "idle"
var_0_0.display_unit = "units/weapons/weapon_display/display_2h_weapon"
var_0_0.buff_type = "MELEE_2H"
var_0_0.weapon_type = "POLEARM"
var_0_0.max_fatigue_points = 6
var_0_0.dodge_count = 3
var_0_0.block_angle = 90
var_0_0.outer_block_angle = 360
var_0_0.block_fatigue_point_multiplier = 0.5
var_0_0.outer_block_fatigue_point_multiplier = 2
var_0_0.sound_event_block_within_arc = "weapon_foley_blunt_1h_block_wood"
var_0_0.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 1.2
	},
	change_dodge_speed = {
		external_optional_multiplier = 1.2
	}
}
var_0_0.attack_meta_data = {
	tap_attack = {
		arc = 0
	},
	hold_attack = {
		arc = 0
	}
}
var_0_0.aim_assist_settings = {
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
var_0_0.tooltip_keywords = {
	"weapon_keyword_high_damage",
	"weapon_keyword_armour_piercing",
	"weapon_keyword_shield_breaking"
}
var_0_0.tooltip_compare = {
	light = {
		action_name = "action_one",
		sub_action_name = "light_attack_left"
	},
	heavy = {
		action_name = "action_one",
		sub_action_name = "heavy_attack_left"
	}
}
var_0_0.tooltip_detail = {
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
var_0_0.wwise_dep_right_hand = {
	"wwise/one_handed_axes"
}

local var_0_1 = table.clone(var_0_0)

var_0_1.crosshair_style = "dot"

local var_0_2 = table.clone(var_0_0)

var_0_2.right_hand_attachment_node_linking = AttachmentNodeLinking.vs_poison_wind_globadier_orb
var_0_2.crosshair_style = "dot"

local var_0_3 = table.clone(var_0_0)

var_0_3.right_hand_attachment_node_linking = AttachmentNodeLinking.vs_gutter_runner_claws.right
var_0_3.left_hand_attachment_node_linking = AttachmentNodeLinking.vs_gutter_runner_claws.left
var_0_3.crosshair_style = "dot"

return {
	vs_packmaster_claw = var_0_1,
	vs_poison_wind_globadier_orb = var_0_2,
	vs_gutter_runner_claws = var_0_3
}
