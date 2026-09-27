-- chunkname: @scripts/settings/equipment/attack_templates_dlc_vs.lua

local AttackTemplates = AttackTemplates

AttackTemplates = AttackTemplates or {}
AttackTemplates = AttackTemplates
AttackTemplates.shot_shotgun_vs = {
	stagger_angle = "stab",
	sound_type = "heavy",
	damage_type = "shot_shotgun",
	ranged_stagger = true,
	stagger_value = 2
}
AttackTemplates.rat_ogre_leap_vs = {
	stagger_value = 2
}
