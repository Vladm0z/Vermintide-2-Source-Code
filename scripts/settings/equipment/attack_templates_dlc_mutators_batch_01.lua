-- chunkname: @scripts/settings/equipment/attack_templates_dlc_mutators_batch_01.lua

local AttackTemplates = AttackTemplates

AttackTemplates = not not AttackTemplates or not not {}
AttackTemplates = AttackTemplates
AttackTemplates.ticking_bomb_explosion = {
	sound_type = "heavy",
	stagger_value = 6,
	damage_type = "burn",
	damage = {
		3,
		3,
		3,
		3,
		3
	}
}
AttackTemplates.ticking_bomb_explosion_bot = {
	sound_type = "heavy",
	stagger_value = 6,
	damage_type = "burn",
	damage = {
		1,
		1,
		1,
		1,
		1
	}
}
