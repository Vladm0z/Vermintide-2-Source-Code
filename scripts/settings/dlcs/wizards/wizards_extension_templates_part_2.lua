-- chunkname: @scripts/settings/dlcs/wizards/wizards_extension_templates_part_2.lua

return {
	ethereal_skull_unit = {
		go_type = "shadow_skull_unit",
		self_owned_extensions = {
			"GenericHitReactionExtension",
			"GenericHealthExtension",
			"GenericDeathExtension",
			"AIProximityExtension",
			"ProjectileLinkerExtension",
			"EnemyOutlineExtension",
			"AIGroupMember",
			"BuffExtension",
			"DialogueActorExtension",
			"AIVolumeExtension",
			"AISimpleExtension",
			"ProjectileEtherealSkullLocomotionExtension",
			"ProjectileLinearSphereSweepImpactUnitExtension",
			"GenericImpactProjectileUnitExtension"
		},
		husk_extensions = {
			"GenericHitReactionExtension",
			"GenericHealthExtension",
			"GenericDeathExtension",
			"AIProximityExtension",
			"ProjectileLinkerExtension",
			"BuffExtension",
			"EnemyOutlineExtension",
			"DialogueActorExtension",
			"AiHuskBaseExtension",
			"ProjectileExtrapolatedHuskLocomotionExtension",
			"GenericImpactProjectileUnitExtension"
		}
	}
}
