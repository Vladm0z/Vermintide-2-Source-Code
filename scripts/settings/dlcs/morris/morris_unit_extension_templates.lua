-- chunkname: @scripts/settings/dlcs/morris/morris_unit_extension_templates.lua

local var_0_0 = _G.GameSettingsDevelopment and GameSettingsDevelopment.use_engine_optimized_ai_locomotion and "AILocomotionExtensionC" or "AILocomotionExtension"

return {
	deus_weapon_chest = {
		go_type = "deus_weapon_chest",
		self_owned_extensions = {
			"GenericUnitInteractableExtension",
			"GenericOutlineExtension",
			"LookatTargetExtension",
			"DeusChestExtension",
			"DeusChestPreloadExtension",
			"PingTargetExtension",
			"GenericUnitAimExtension",
			"ProjectileLinkerExtension"
		},
		husk_extensions = {
			"GenericUnitInteractableExtension",
			"GenericOutlineExtension",
			"LookatTargetExtension",
			"DeusChestExtension",
			"DeusChestPreloadExtension",
			"PingTargetExtension",
			"GenericUnitAimExtension",
			"ProjectileLinkerExtension"
		}
	},
	deus_cursed_chest = {
		go_type = "deus_cursed_chest",
		self_owned_extensions = {
			"GenericUnitInteractableExtension",
			"GenericOutlineExtension",
			"LookatTargetExtension",
			"PickupUnitExtension",
			"PingTargetExtension",
			"DeusCursedChestExtension"
		},
		husk_extensions = {
			"GenericUnitInteractableExtension",
			"GenericOutlineExtension",
			"LookatTargetExtension",
			"PickupUnitExtension",
			"PingTargetExtension",
			"DeusCursedChestExtension"
		}
	},
	buff_objective_unit = {
		go_type = "buff_objective_unit",
		self_owned_extensions = {
			"BuffExtension",
			"UnitSynchronizationExtension"
		},
		husk_extensions = {
			"BuffExtension",
			"UnitSynchronizationExtension"
		}
	},
	ai_unit_greed_pinata = {
		go_type = "ai_unit",
		self_owned_extensions = {
			var_0_0,
			"AINavigationExtension",
			"GenericHitReactionExtension",
			"GenericHealthExtension",
			"GenericDeathExtension",
			"BuffExtension",
			"ProjectileLinkerExtension",
			"PingTargetExtension",
			"EnemyOutlineExtension",
			"AIUnitFadeExtension",
			"AISimpleExtension"
		},
		husk_extensions = {
			"AiHuskLocomotionExtension",
			"GenericHitReactionExtension",
			"GenericHealthExtension",
			"GenericDeathExtension",
			"BuffExtension",
			"ProjectileLinkerExtension",
			"PingTargetExtension",
			"EnemyOutlineExtension",
			"AIUnitFadeExtension",
			"AiHuskBaseExtension"
		}
	},
	deus_relic = {
		go_type = "deus_relic",
		self_owned_extensions = {
			"ProjectilePhysicsUnitLocomotionExtension",
			"PickupUnitExtension",
			"GenericUnitInteractableExtension",
			"ObjectiveLightOutlineExtension",
			"LookatTargetExtension",
			"PickupProjectileVolumeExtension",
			"PingTargetExtension",
			"DeusRelicExtension"
		},
		husk_extensions = {
			"ProjectilePhysicsHuskLocomotionExtension",
			"PickupUnitExtension",
			"GenericUnitInteractableExtension",
			"ObjectiveLightOutlineExtension",
			"LookatTargetExtension",
			"PingTargetExtension"
		}
	},
	egg_of_tzeentch_unit = {
		go_type = "egg_of_tzeentch_unit",
		self_owned_extensions = {
			"BuffExtension",
			"GenericHealthExtension",
			"GenericHitReactionExtension",
			"GenericDeathExtension",
			"ObjectiveLightOutlineExtension",
			"TimedSpawnerExtension",
			"LookatTargetExtension"
		},
		husk_extensions = {
			"BuffExtension",
			"GenericHealthExtension",
			"GenericHitReactionExtension",
			"GenericDeathExtension",
			"ObjectiveLightOutlineExtension",
			"TimedSpawnerExtension",
			"LookatTargetExtension"
		}
	},
	buffed_timed_explosion_unit = {
		go_type = "buffed_timed_explosion_unit",
		self_owned_extensions = {
			"TimedExplosionExtension",
			"BuffExtension"
		},
		husk_extensions = {
			"TimedExplosionExtension",
			"BuffExtension"
		}
	}
}
