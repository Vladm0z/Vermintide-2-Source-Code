-- chunkname: @scripts/entity_system/entity_system.lua

require("scripts/entity_system/systems/extension_system_base")
require("scripts/entity_system/systems/aggro/aggro_system")
require("scripts/entity_system/systems/ai/ai_system")
require("scripts/entity_system/systems/ai/ai_line_of_sight_system")
require("scripts/entity_system/systems/ai/ai_bot_group_system")
require("scripts/entity_system/systems/ai/ai_group_system")
require("scripts/entity_system/systems/ai/ai_inventory_system")
require("scripts/entity_system/systems/ai/ai_inventory_item_system")
require("scripts/entity_system/systems/ai/ai_interest_point_system")
require("scripts/entity_system/systems/ai/ai_navigation_system")
require("scripts/entity_system/systems/ai/ai_slot_system")
require("scripts/entity_system/systems/ai/ai_slot_system_2")
require("scripts/entity_system/systems/ai/nav_graph_system")
require("scripts/entity_system/systems/animation/animation_system")
require("scripts/entity_system/systems/animation/aim_system")
require("scripts/entity_system/systems/animation/animation_movement_system")
require("scripts/entity_system/systems/attachment/attachment_system")
require("scripts/entity_system/systems/cosmetic/cosmetic_system")
require("scripts/entity_system/systems/area_damage/area_damage_system")
require("scripts/entity_system/systems/audio/audio_system")
require("scripts/entity_system/systems/buff/buff_area_system")
require("scripts/entity_system/systems/buff/buff_system")
require("scripts/entity_system/systems/camera/camera_system")
require("scripts/entity_system/systems/world_marker/world_marker_system")
require("scripts/entity_system/systems/cutscene/cutscene_system")
require("scripts/entity_system/systems/darkness/darkness_system")
require("scripts/entity_system/systems/damage/death_system")
require("scripts/entity_system/systems/damage/health_system")
require("scripts/entity_system/systems/damage/health_trigger_system")
require("scripts/entity_system/systems/damage/hit_reaction_system")
require("scripts/entity_system/systems/dialogues/dialogue_system")
require("scripts/entity_system/systems/dialogues/dialogue_context_system")
require("scripts/entity_system/systems/dialogues/surrounding_aware_system")
require("scripts/entity_system/systems/doors/door_system")
require("scripts/entity_system/systems/fade/fade_system")
require("scripts/entity_system/systems/fade/fade_system_dummy")
require("scripts/entity_system/systems/first_person/first_person_system")
require("scripts/entity_system/systems/interaction/interaction_system")
require("scripts/entity_system/systems/interaction/interactable_system")
require("scripts/entity_system/systems/inventory/inventory_system")
require("scripts/entity_system/systems/leaderboard/leaderboard_system")
require("scripts/entity_system/systems/limited_item_track/limited_item_track_system")
require("scripts/entity_system/systems/locomotion/locomotion_system")
require("scripts/entity_system/systems/network/game_object_system")
require("scripts/entity_system/systems/objective_socket/objective_socket_system")
require("scripts/entity_system/systems/outlines/outline_system")
require("scripts/entity_system/systems/mutator_item/mutator_item_system")
require("scripts/entity_system/systems/pickups/pickup_system")
require("scripts/entity_system/systems/progress/progress_system")
require("scripts/entity_system/systems/projectile_impact/projectile_impact_system")
require("scripts/entity_system/systems/projectile_locomotion/projectile_locomotion_system")
require("scripts/entity_system/systems/round_started/round_started_system")
require("scripts/entity_system/systems/sound/sound_effect_system")
require("scripts/entity_system/systems/sound/sound_sector_system")
require("scripts/entity_system/systems/sound_environment/sound_environment_system")
require("scripts/entity_system/systems/sound_environment/sound_environment_system_dummy")
require("scripts/entity_system/systems/spawner/spawner_system")
require("scripts/entity_system/systems/statistics/statistics_system")
require("scripts/entity_system/systems/talents/talent_system")
require("scripts/entity_system/systems/volumes/volume_system")
require("scripts/entity_system/systems/projectile/projectile_system")
require("scripts/entity_system/systems/proximity/proximity_system")
require("scripts/entity_system/systems/projectile/projectile_linker_system")
require("scripts/entity_system/systems/props/end_zone_system")
require("scripts/entity_system/systems/props/props_system")
require("scripts/entity_system/systems/status/status_system")
require("scripts/entity_system/systems/transportation/transportation_system")
require("scripts/entity_system/systems/weapon/weapon_system")
require("scripts/entity_system/systems/weapon/ammo_system")
require("scripts/entity_system/systems/hud/hud_system")
require("scripts/entity_system/systems/tutorial/tutorial_system")
require("scripts/entity_system/systems/play_go_tutorial/play_go_tutorial_system")
require("scripts/entity_system/systems/mission/mission_system")
require("scripts/entity_system/systems/ping/ping_system")
require("scripts/entity_system/systems/payload/payload_system")
require("scripts/entity_system/systems/target_override/target_override_system")
require("scripts/entity_system/systems/position_lookup/position_lookup_system")
require("scripts/entity_system/systems/keep_decoration/keep_decoration_system")
require("scripts/entity_system/systems/whereabouts/whereabouts_system")
require("scripts/entity_system/systems/objective/objective_item_spawner_system")
require("scripts/entity_system/systems/objective/objective_system")
require("scripts/entity_system/systems/weaves/weave_loadout_system")
require("scripts/entity_system/systems/career/career_system")
require("scripts/entity_system/systems/disrupt_ritual/disrupt_ritual_system")
require("scripts/entity_system/systems/puzzle/puzzle_system")
require("scripts/entity_system/systems/unit_flow_override_system/unit_flow_override_system")
DLCUtils.require_list("systems")
require("scripts/unit_extensions/human/ai_player_unit/ai_anim_utils")
require("scripts/unit_extensions/human/ai_player_unit/ai_husk_base_extension")
require("scripts/unit_extensions/human/ai_player_unit/ai_simple_extension")
require("scripts/unit_extensions/human/ai_player_unit/ai_utils")
require("scripts/unit_extensions/generic/end_zone_extension")
require("scripts/unit_extensions/generic/bot_nav_transition_extension")
require("scripts/unit_extensions/generic/generic_aggroable_extension")
require("scripts/unit_extensions/generic/generic_ammo_user_extension")
require("scripts/unit_extensions/generic/generic_character_state_machine_extension")
require("scripts/unit_extensions/generic/generic_camera_state_machine_extension")
require("scripts/unit_extensions/generic/generic_death_extension")
require("scripts/unit_extensions/generic/generic_trail_extension")
require("scripts/unit_extensions/generic/generic_unit_aim_extension")
require("scripts/unit_extensions/generic/generic_hit_reaction_extension")
require("scripts/unit_extensions/generic/ai_line_of_sight_extension")
require("scripts/unit_extensions/generic/ladder_extension")
require("scripts/unit_extensions/generic/player_in_zone_extension")
require("scripts/unit_extensions/default_player_unit/player_eyetracking_extension")
require("scripts/unit_extensions/generic/shadow_flare_extension")
require("scripts/unit_extensions/generic/tentacle_spline_extension")
require("scripts/unit_extensions/generic/tentacle_templates")
require("scripts/unit_extensions/generic/thorn_mutator_extension")
require("scripts/unit_extensions/generic/scale_unit_extension")
require("scripts/unit_extensions/generic/store_display_item_gizmo_extension")
require("scripts/unit_extensions/generic/thrown_unit_husk_extension")
require("scripts/unit_extensions/ai_supplementary/beastmen_standard_extension")
require("scripts/unit_extensions/ai_supplementary/beastmen_standard_templates")
require("scripts/unit_extensions/ai_supplementary/unit_synchronization_extension")
require("scripts/unit_extensions/ai_supplementary/vortex_extension")
require("scripts/unit_extensions/ai_supplementary/vortex_templates")
require("scripts/unit_extensions/ai_supplementary/vortex_husk_extension")
require("scripts/unit_extensions/ai_supplementary/corruptor_beam_extension")
require("scripts/unit_extensions/ai_supplementary/stormfiend_beam_extension")
require("scripts/unit_extensions/weapons/area_damage/liquid/damage_wave_extension")
require("scripts/unit_extensions/weapons/area_damage/liquid/damage_wave_husk_extension")
require("scripts/unit_extensions/weapons/area_damage/liquid/damage_wave_templates")
require("scripts/unit_extensions/weapons/area_damage/liquid/damage_blob_extension")
require("scripts/unit_extensions/weapons/area_damage/liquid/damage_blob_husk_extension")
require("scripts/unit_extensions/weapons/area_damage/liquid/damage_blob_templates")
require("scripts/unit_extensions/default_player_unit/player_unit_attack_intensity_extension")
require("scripts/unit_extensions/default_player_unit/player_input_extension")
require("scripts/unit_extensions/default_player_unit/player_input_tutorial_extension")
require("scripts/unit_extensions/default_player_unit/player_sound_effect_extension")
require("scripts/unit_extensions/default_player_unit/player_whereabouts_extension")
require("scripts/unit_extensions/default_player_unit/lure_whereabouts_extension")
require("scripts/unit_extensions/human/player_bot_unit/player_bot_base")
require("scripts/unit_extensions/human/player_bot_unit/player_bot_input")
require("scripts/unit_extensions/human/player_bot_unit/player_bot_navigation")
require("scripts/unit_extensions/default_player_unit/talents/talent_extension")
require("scripts/unit_extensions/default_player_unit/talents/husk_talent_extension")
require("scripts/unit_extensions/default_player_unit/careers/career_extension")
require("scripts/unit_extensions/weapons/area_damage/area_damage_extension")
require("scripts/unit_extensions/weapons/area_damage/timed_explosion_extension")
require("scripts/unit_extensions/weapons/area_damage/proximity_mine_extension")
require("scripts/unit_extensions/weapons/area_damage/liquid/liquid_area_damage_extension")
require("scripts/unit_extensions/weapons/area_damage/liquid/liquid_area_damage_husk_extension")
require("scripts/unit_extensions/weapons/area_damage/liquid/liquid_area_damage_templates")
require("scripts/unit_extensions/weapons/area_damage/area_damage_templates")
require("scripts/unit_extensions/weapons/ammo/active_reload_ammo_user_extension")
require("scripts/unit_extensions/weapons/spread/weapon_spread_extension")
require("scripts/unit_extensions/default_player_unit/charge/player_husk_overcharge_extension")
require("scripts/unit_extensions/default_player_unit/charge/player_unit_overcharge_extension")
require("scripts/unit_extensions/default_player_unit/player_husk_visual_effects_extension")
require("scripts/unit_extensions/default_player_unit/player_unit_visual_effects_extension")
require("scripts/unit_extensions/default_player_unit/energy/player_unit_energy_extension")
require("scripts/unit_extensions/default_player_unit/energy/player_husk_energy_extension")
require("scripts/unit_extensions/default_player_unit/boons/boon_extension")
require("scripts/unit_extensions/default_player_unit/target_override_extension")
require("scripts/unit_extensions/cutscene_camera/cutscene_camera")
require("scripts/unit_extensions/smart_targeting/player_unit_smart_targeting_extension")
require("scripts/unit_extensions/human/ai_player_unit/ai_shield_user_extension")
require("scripts/unit_extensions/human/ai_player_unit/ai_shield_user_husk_extension")
require("scripts/unit_extensions/human/ai_player_unit/bulwark_shield_extension")
require("scripts/unit_extensions/human/ai_player_unit/bulwark_husk_shield_extension")
require("scripts/unit_extensions/props/quest_challenge_prop_extension")
require("scripts/unit_extensions/props/event_upsell_prop_extension")
require("scripts/unit_extensions/weaves/weave_capture_point_extension")
require("scripts/unit_extensions/weaves/weave_target_extension")
require("scripts/unit_extensions/weaves/weave_limited_item_spawner_extension")
require("scripts/unit_extensions/weaves/weave_doom_wheel_extension")
require("scripts/unit_extensions/weaves/weave_socket_extension")
require("scripts/unit_extensions/weaves/weave_item_extension")
require("scripts/unit_extensions/weaves/weave_interaction_extension")
require("scripts/unit_extensions/weaves/weave_kill_enemies_extension")
require("scripts/unit_extensions/level/event_light_spawner_extension")
require("scripts/unit_extensions/level/disrupt_ritual_extension")
DLCUtils.require_list("entity_extensions")

local var_0_0 = {
	"TentacleSplineExtension",
	"VortexExtension",
	"VortexHuskExtension",
	"ThrownUnitHuskExtension",
	"BeastmenStandardExtension",
	"UnitSynchronizationExtension",
	"GrudgeMarkSirenChainExtension"
}

EntitySystem = class(EntitySystem)

EntitySystem.init = function (arg_1_0, arg_1_1)
	assert(arg_1_1.entity_manager, "Entity Manager is missing!")
	assert(arg_1_1.world, "World is missing!")
	assert(arg_1_1.unit_spawner, "Unit Spawner is missing!")

	arg_1_0.entity_manager = arg_1_1.entity_manager
	arg_1_0.world = arg_1_1.world
	arg_1_0.unit_spawner = arg_1_1.unit_spawner
	arg_1_0.startup_data = arg_1_1.startup_data
	arg_1_0.is_server = arg_1_1.is_server
	arg_1_0.entity_system_bag = arg_1_1.entity_system_bag
	arg_1_0.network_clock = arg_1_1.network_clock
	arg_1_0.network_transmit = arg_1_1.network_transmit
	arg_1_0.statistics_db = arg_1_1.statistics_db
	arg_1_0.dice_keeper = arg_1_1.dice_keeper
	arg_1_0.system_update_context = {}

	arg_1_0:_init_systems(arg_1_1)
end

EntitySystem._init_systems = function (arg_2_0, arg_2_1)
	local var_2_0 = false
	local var_2_1 = true
	local var_2_2 = true
	local var_2_3 = true

	arg_2_1.entity_system = arg_2_0

	local var_2_4 = Managers.mechanism:current_mechanism_name() == "versus"

	print("entity_system: is_versus", var_2_4)
	arg_2_0:_add_system("ai_bot_group_system", AIBotGroupSystem, arg_2_1)
	arg_2_0:_add_system("target_override_system", TargetOverrideSystem, arg_2_1, {
		"TargetOverrideExtension"
	})
	arg_2_0:_add_system("ai_system", AISystem, arg_2_1)
	arg_2_0:_add_system("ai_line_of_sight_system", AILineOfSightSystem, arg_2_1)
	arg_2_0:_add_system("ai_interest_point_system", AIInterestPointSystem, arg_2_1)
	arg_2_0:_add_system("input_system", ExtensionSystemBase, arg_2_1, {
		"PlayerInputExtension",
		"PlayerInputTutorialExtension",
		"PlayerBotInput"
	}, nil, var_2_1)
	arg_2_0:_add_system("position_lookup_system", PositionLookupSystem, arg_2_1)
	arg_2_0:_add_system("darkness_system", DarknessSystem, arg_2_1, {
		"LightSourceExtension"
	})
	arg_2_0:_add_system("character_state_machine_system", ExtensionSystemBase, arg_2_1, {
		"GenericCharacterStateMachineExtension"
	})
	arg_2_0:_add_system("ladder_system", ExtensionSystemBase, arg_2_1, {
		"LadderExtension"
	})
	arg_2_0:_add_system("inventory_system", InventorySystem, arg_2_1)
	arg_2_0:_add_system("pickup_system", PickupSystem, arg_2_1)
	arg_2_0:_add_system("attachment_system", AttachmentSystem, arg_2_1)
	arg_2_0:_add_system("cosmetic_system", CosmeticSystem, arg_2_1)
	arg_2_0:_add_system("ai_shield_system", ExtensionSystemBase, arg_2_1, {
		"AIShieldUserExtension",
		"AIShieldUserHuskExtension",
		"BulwarkShieldExtension",
		"BulwarkHuskShieldExtension"
	})
	arg_2_0:_add_system("ai_inventory_system", AIInventorySystem, arg_2_1)
	arg_2_0:_add_system("ai_inventory_item_system", AIInventoryItemSystem, arg_2_1)
	arg_2_0:_add_system("objective_socket_system", ObjectiveSocketSystem, arg_2_1)
	arg_2_0:_add_system("objective_item_spawner_system", ObjectiveItemSpawnerSystem, arg_2_1)
	arg_2_0:_add_system("objective_system", ObjectiveSystem, arg_2_1)
	arg_2_0:_add_system("limited_item_track_system", LimitedItemTrackSystem, arg_2_1)
	arg_2_0:_add_system("aggro_system", AggroSystem, arg_2_1)
	arg_2_0:_add_system("ping_system", PingSystem, arg_2_1)
	arg_2_0:_add_system("smart_targeting_system", ExtensionSystemBase, arg_2_1, {
		"PlayerUnitSmartTargetingExtension"
	})
	arg_2_0:_add_system("weapon_system", WeaponSystem, arg_2_1)
	arg_2_0:_add_system("projectile_locomotion_system", ProjectileLocomotionSystem, arg_2_1)
	arg_2_0:_add_system("projectile_impact_system", ProjectileImpactSystem, arg_2_1)
	arg_2_0:_add_system("projectile_linker_system", ProjectileLinkerSystem, arg_2_1)
	arg_2_0:_add_system("projectile_system", ProjectileSystem, arg_2_1)
	arg_2_0:_add_system("mutator_item_system", MutatorItemSystem, arg_2_1)
	arg_2_0:_add_system("weave_loadout_system", WeaveLoadoutSystem, arg_2_1)
	arg_2_0:_add_system("puzzle_system", PuzzleSystem, arg_2_1)

	if var_2_4 then
		arg_2_0:_add_system("ghost_mode_system", GhostModeSystem, arg_2_1)
		arg_2_0:_add_system("versus_horde_ability_system", VersusHordeAbilitySystem, arg_2_1)
	else
		arg_2_0.entity_manager:add_ignore_extensions({
			"PlayerEquipmentWorldMarkerExtension"
		})
	end

	arg_2_0:_add_system("world_marker_system", WorldMarkerSystem, arg_2_1)

	if DEDICATED_SERVER then
		arg_2_0.entity_manager:add_ignore_extensions({
			"UnitFlowOverrideExtension"
		})
	end

	arg_2_0:_add_system("buff_system", BuffSystem, arg_2_1)
	arg_2_0:_add_system("buff_area_system", BuffAreaSystem, arg_2_1)
	arg_2_0:_add_system("talent_system", TalentSystem, arg_2_1)
	arg_2_0:_add_system("ammo_system", AmmoSystem, arg_2_1)
	arg_2_0:_add_system("spread_system", ExtensionSystemBase, arg_2_1, {
		"WeaponSpreadExtension"
	})
	arg_2_0:_add_system("health_system", HealthSystem, arg_2_1)
	arg_2_0:_add_system("status_system", StatusSystem, arg_2_1)
	arg_2_0:_add_system("attack_intensity_system", ExtensionSystemBase, arg_2_1, {
		"PlayerUnitAttackIntensityExtension"
	})
	arg_2_0:_add_system("hit_reaction_system", HitReactionSystem, arg_2_1)
	arg_2_0:_add_system("overcharge_system", ExtensionSystemBase, arg_2_1, {
		"PlayerUnitOverchargeExtension",
		"PlayerHuskOverchargeExtension"
	})
	arg_2_0:_add_system("trail_system", ExtensionSystemBase, arg_2_1, {
		"GenericTrailExtension"
	})
	arg_2_0:_add_system("sound_effect_system", SoundEffectSystem, arg_2_1)
	arg_2_0:_add_system("visual_effects_system", ExtensionSystemBase, arg_2_1, {
		"PlayerUnitVisualEffectsExtension",
		"PlayerHuskVisualEffectsExtension"
	}, nil, nil, nil, var_2_3)
	arg_2_0:_add_system("ai_slot_system", AISlotSystem2, arg_2_1)
	arg_2_0:_add_system("ai_commander_system", AICommanderSystem, arg_2_1)
	arg_2_0:_add_system("area_damage_system", AreaDamageSystem, arg_2_1)
	arg_2_0:_add_system("death_system", DeathSystem, arg_2_1)
	arg_2_0:_add_system("interactor_system", InteractionSystem, arg_2_1)
	arg_2_0:_add_system("interactable_system", InteractableSystem, arg_2_1)
	arg_2_0:_add_system("ai_group_system", AIGroupSystem, arg_2_1)
	arg_2_0:_add_system("ai_navigation_system", AINavigationSystem, arg_2_1, {
		"AINavigationExtension",
		"PlayerBotNavigation"
	}, nil, var_2_0, var_2_2)
	arg_2_0:_add_system("whereabouts_system", WhereaboutsSystem, arg_2_1, {
		"PlayerWhereaboutsExtension",
		"LureWhereaboutsExtension",
		"JumpsWhereaboutsExtension"
	}, nil, var_2_0)
	arg_2_0:_add_system("ai_supplementary_system", ExtensionSystemBase, arg_2_1, var_0_0)
	arg_2_0:_add_system("ai_beam_effect_system", ExtensionSystemBase, arg_2_1, {
		"CorruptorBeamExtension",
		"StormfiendBeamExtension",
		"CurseCorruptorBeamExtension"
	})
	arg_2_0:_add_system("door_system", DoorSystem, arg_2_1)
	arg_2_0:_add_system("payload_system", PayloadSystem, arg_2_1)
	arg_2_0:_add_system("career_system", CareerSystem, arg_2_1)
	arg_2_0:_add_system("event_spawner_system", ExtensionSystemBase, arg_2_1, {
		"EventLightSpawnerExtension"
	})
	arg_2_0:_add_system("disrupt_ritual_system", DisruptRitualSystem, arg_2_1, {
		"DisruptRitualExtension"
	})

	if Managers.state.game_mode:settings().use_keep_decorations then
		arg_2_0:_add_system("keep_decoration_system", KeepDecorationSystem, arg_2_1)
	else
		arg_2_0.entity_manager:add_ignore_extensions({
			"KeepDecorationPaintingExtension"
		})
	end

	arg_2_0:_add_system("aim_system", AimSystem, arg_2_1, {
		"GenericUnitAimExtension"
	})
	arg_2_0:_add_system("animation_movement_system", AnimationMovementSystem, arg_2_1, {
		"GenericUnitAnimationMovementSystem"
	})
	arg_2_0:_add_system("transportation_system", TransportationSystem, arg_2_1, nil, nil, var_2_0, var_2_2)
	arg_2_0:_add_system("locomotion_system", LocomotionSystem, arg_2_1, nil, nil, var_2_0, var_2_2)
	arg_2_0:_add_system("animation_system", AnimationSystem, arg_2_1)

	if IS_WINDOWS then
		arg_2_0:_add_system("eyetracking_system", ExtensionSystemBase, arg_2_1, {
			"PlayerEyeTrackingExtension"
		})
	end

	arg_2_0:_add_system("first_person_system", FirstPersonSystem, arg_2_1)

	if DEDICATED_SERVER then
		arg_2_0:_add_system("fade_system", FadeSystemDummy, arg_2_1)
	else
		arg_2_0:_add_system("fade_system", FadeSystem, arg_2_1)
	end

	arg_2_0:_add_system("camera_state_machine_system", ExtensionSystemBase, arg_2_1, {
		"GenericCameraStateMachineExtension"
	})
	arg_2_0:_add_system("camera_system", CameraSystem, arg_2_1, nil, nil, var_2_0, var_2_2)
	arg_2_0:_add_system("sound_sector_system", SoundSectorSystem, arg_2_1, nil, nil, nil, nil, nil)
	arg_2_0:_add_system("volume_system", VolumeSystem, arg_2_1)
	arg_2_0:_add_system("cutscene_system", CutsceneSystem, arg_2_1)
	arg_2_0:_add_system("outline_system", OutlineSystem, arg_2_1, nil, nil, nil, nil, var_2_3)
	arg_2_0:_add_system("play_go_tutorial_system", PlayGoTutorialSystem, arg_2_1)
	arg_2_0:_add_system("tutorial_system", TutorialSystem, arg_2_1)
	arg_2_0:_add_system("mission_system", MissionSystem, arg_2_1)
	arg_2_0:_add_system("hud_system", HUDSystem, arg_2_1)
	arg_2_0:_add_system("round_started_system", RoundStartedSystem, arg_2_1)
	arg_2_0:_add_system("spawner_system", SpawnerSystem, arg_2_1)
	arg_2_0:_add_system("props_system", PropsSystem, arg_2_1, {
		"BotNavTransitionExtension"
	}, {
		"PerlinLightExtension",
		"QuestChallengePropExtension",
		"EventUpsellPropExtension"
	})
	arg_2_0:_add_system("end_zone_system", EndZoneSystem, arg_2_1)
	arg_2_0:_add_system("progress_system", ProgressSystem, arg_2_1)
	arg_2_0:_add_system("nav_graph_system", NavGraphSystem, arg_2_1)
	arg_2_0:_add_system("audio_system", AudioSystem, arg_2_1)

	if DEDICATED_SERVER then
		arg_2_0:_add_system("sound_environment_system", SoundEnvironmentSystemDummy, arg_2_1)
	else
		arg_2_0:_add_system("sound_environment_system", SoundEnvironmentSystem, arg_2_1)
	end

	arg_2_0:_add_system("game_object_system", GameObjectSystem, arg_2_1)
	arg_2_0:_add_system("statistics_system", StatisticsSystem, arg_2_1)
	arg_2_0:_add_system("dialogue_context_system", DialogueContextSystem, arg_2_1)
	arg_2_0:_add_system("health_trigger_system", HealthTriggerSystem, arg_2_1)
	arg_2_0:_add_system("surrounding_aware_system", SurroundingAwareSystem, arg_2_1)
	arg_2_0:_add_system("dialogue_system", DialogueSystem, arg_2_1, nil, nil, var_2_0, var_2_2)
	arg_2_0:_add_system("proximity_system", ProximitySystem, arg_2_1, nil, nil, var_2_0, var_2_2)
	arg_2_0:_add_system("energy_system", ExtensionSystemBase, arg_2_1, {
		"PlayerUnitEnergyExtension",
		"PlayerHuskEnergyExtension"
	})
	arg_2_0:_add_system("boon_system", ExtensionSystemBase, arg_2_1, {
		"BoonExtension"
	})
	arg_2_0:_add_system("unit_flow_override_system", UnitFlowOverrideSystem, arg_2_1, nil, nil, nil, nil, var_2_3)

	for iter_2_0, iter_2_1 in pairs(DLCSettings) do
		local var_2_5 = iter_2_1.entity_system_params or {}

		for iter_2_2, iter_2_3 in pairs(var_2_5) do
			local var_2_6 = iter_2_3.system_name
			local var_2_7 = rawget(_G, iter_2_3.system_class_name)
			local var_2_8 = iter_2_3.context or arg_2_1
			local var_2_9 = iter_2_3.extension_list

			arg_2_0:_add_system(var_2_6, var_2_7, var_2_8, var_2_9)
		end
	end
end

EntitySystem.register_system = function (arg_3_0, arg_3_1, arg_3_2, ...)
	return
end

EntitySystem._add_system = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7, arg_4_8)
	if DEDICATED_SERVER and arg_4_8 then
		local var_4_0 = arg_4_2.system_extensions or {}

		if arg_4_4 then
			table.append(var_4_0, arg_4_4)
		end

		arg_4_0.entity_manager:add_ignore_extensions(var_4_0)
	else
		local var_4_1 = {}

		if arg_4_4 ~= nil then
			table.append(var_4_1, arg_4_4)
		end

		if not DEDICATED_SERVER and arg_4_5 ~= nil then
			table.append(var_4_1, arg_4_5)
		end

		local var_4_2 = arg_4_2:new(arg_4_3, arg_4_1, var_4_1)
		local var_4_3 = not arg_4_6
		local var_4_4 = not arg_4_7

		arg_4_0.entity_system_bag:add_system(var_4_2, var_4_3, var_4_4)

		if DEDICATED_SERVER and arg_4_5 ~= nil then
			arg_4_0.entity_manager:add_ignore_extensions(arg_4_5)
		end
	end
end

EntitySystem.pre_update = function (arg_5_0, arg_5_1)
	arg_5_0:system_update("pre_update", arg_5_1)
end

EntitySystem.update = function (arg_6_0, arg_6_1)
	arg_6_0:system_update("update", arg_6_1)
end

EntitySystem.unsafe_entity_update = function (arg_7_0, arg_7_1)
	arg_7_0:system_update("unsafe_entity_update", arg_7_1)
end

EntitySystem.post_update = function (arg_8_0, arg_8_1)
	arg_8_0:system_update("post_update", arg_8_1)
end

EntitySystem.physics_async_update = function (arg_9_0)
	arg_9_0:system_update("physics_async_update", arg_9_0.system_update_context.dt)
end

EntitySystem.system_update = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0.system_update_context

	var_10_0.world = arg_10_0.world
	var_10_0.dt = arg_10_2
	var_10_0.entity_manager = arg_10_0.entity_manager
	var_10_0.t = Managers.time:time("game")
	var_10_0.network_transmit = arg_10_0.network_transmit
	var_10_0.statistics_db = arg_10_0.statistics_db
	var_10_0.dice_keeper = arg_10_0.dice_keeper

	if World.get_data(var_10_0.world, "paused") then
		return
	end

	arg_10_0.entity_system_bag:update(var_10_0, arg_10_1)
end

EntitySystem.commit_and_remove_pending_units = function (arg_11_0)
	local var_11_0 = arg_11_0.unit_spawner

	var_11_0.locked = false

	var_11_0:commit_and_remove_pending_units()

	var_11_0.locked = true
end

EntitySystem.hot_join_sync = function (arg_12_0, arg_12_1)
	arg_12_0.entity_system_bag:hot_join_sync(arg_12_1)
end

EntitySystem.destroy = function (arg_13_0)
	local var_13_0 = World.units(arg_13_0.world)

	arg_13_0.entity_manager:unregister_units(var_13_0, #var_13_0)
	GarbageLeakDetector.register_object(arg_13_0.system_update_context, "EntitySystemUpdateContext")

	arg_13_0.system_update_context = nil

	GarbageLeakDetector.register_object(arg_13_0, "EntitySystem")
end
