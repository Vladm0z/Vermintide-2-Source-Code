-- chunkname: @scripts/settings/profiles/sp_profiles.lua

require("scripts/settings/script_input_settings")
require("scripts/settings/equipment/weapons")
require("scripts/settings/profiles/room_profiles")
require("scripts/settings/equipment/attachments")
require("scripts/settings/profiles/base_units")
require("scripts/settings/equipment/cosmetics")

if script_data.honduras_demo then
	ProfilePriority = {
		3,
		5,
		4,
		1,
		2
	}
elseif LAUNCH_MODE == "attract_benchmark" then
	ProfilePriority = {
		3,
		4,
		2,
		1,
		5
	}
else
	ProfilePriority = {
		5,
		3,
		4,
		1,
		2
	}
end

ProfileIndexToPriorityIndex = {}

for iter_0_0, iter_0_1 in ipairs(ProfilePriority) do
	ProfileIndexToPriorityIndex[iter_0_1] = iter_0_0
end

SPProfilesAbbreviation = {
	"wh",
	"bw",
	"dr",
	"we",
	"es"
}

local var_0_0 = {
	"PlayerCharacterStateDead",
	"PlayerCharacterStateInteracting",
	"PlayerCharacterStateInspecting",
	"PlayerCharacterStateEmote",
	"PlayerCharacterStateJumping",
	"PlayerCharacterStateClimbingLadder",
	"PlayerCharacterStateLeavingLadderTop",
	"PlayerCharacterStateEnterLadderTop",
	"PlayerCharacterStateFalling",
	"PlayerCharacterStateKnockedDown",
	"PlayerCharacterStatePouncedDown",
	"PlayerCharacterStateStanding",
	"PlayerCharacterStateWalking",
	"PlayerCharacterStateDodging",
	"PlayerCharacterStateLedgeHanging",
	"PlayerCharacterStateLeaveLedgeHangingPullUp",
	"PlayerCharacterStateLeaveLedgeHangingFalling",
	"PlayerCharacterStateCatapulted",
	"PlayerCharacterStateStunned",
	"PlayerCharacterStateCharged",
	"PlayerCharacterStateUsingTransport",
	"PlayerCharacterStateGrabbedByPackMaster",
	"PlayerCharacterStateGrabbedByTentacle",
	"PlayerCharacterStateWaitingForAssistedRespawn",
	"PlayerCharacterStateOverchargeExploding",
	"PlayerCharacterStateInVortex",
	"PlayerCharacterStateGrabbedByChaosSpawn",
	"PlayerCharacterStateLunging",
	"PlayerCharacterStateLeaping",
	"PlayerCharacterStateOverpowered",
	"PlayerCharacterStateInHangingCage",
	"PlayerCharacterStateGrabbedByCorruptor"
}
local var_0_1 = {
	"CameraStateIdle",
	"CameraStateFollow",
	"CameraStateFollowThirdPerson",
	"CameraStateFollowAttract",
	"CameraStateFollowThirdPersonLedge",
	"CameraStateFollowThirdPersonOverShoulder",
	"CameraStateFollowThirdPersonSmartClimbing",
	"CameraStateFollowThirdPersonTunneling",
	"CameraStateFollowChaosSpawnGrabbed",
	"CameraStateObserver",
	"CameraStateInteraction"
}
local var_0_2 = {
	"LootObjectiveUI",
	"WaitForRescueUI",
	"ItemReceivedFeedbackUI",
	"OverchargeBarUI",
	"BuffUI",
	"BuffPresentationUI",
	"EquipmentUI",
	"GamePadEquipmentUI",
	"AbilityUI",
	"GamePadAbilityUI",
	"InteractionUI",
	"DamageIndicatorGui",
	"CrosshairUI",
	"FatigueUI",
	"BonusDiceUI",
	"PlayerInventoryUI",
	"SocialWheelUI",
	"WeaveProgressUI",
	"WeaveTimerUI",
	"WorldMarkerUI",
	"ChallengeTrackerUI"
}
local var_0_3 = "units/beings/player/first_person_base/state_machines/common"

for iter_0_2, iter_0_3 in pairs(DLCSettings) do
	local var_0_4 = iter_0_3.hero_hud_components

	if var_0_4 then
		for iter_0_4, iter_0_5 in ipairs(var_0_4) do
			var_0_2[#var_0_2 + 1] = iter_0_5
		end
	end
end

SPProfiles = {
	{
		career_voice_parameter = "victor_career_voice_effect",
		display_name = "witch_hunter",
		hero_selection_image = "hero_icon_wh",
		ingame_short_display_name = "witch_hunter_short",
		character_name = "inventory_name_witch_hunter",
		character_vo = "witch_hunter",
		unit_name = "witch_hunter",
		supports_motion_sickness_modes = true,
		default_wielded_slot = "slot_melee",
		role = "hero",
		ingame_display_name = "inventory_name_witch_hunter",
		affiliation = "heroes",
		ui_portrait = "unit_frame_portrait_victor_captain",
		career_voice_parameter_values = {
			0,
			100,
			50
		},
		room_profile = RoomProfiles.witch_hunter,
		base_units = BaseUnits.witch_hunter,
		default_state_machine = var_0_3,
		first_person_attachment = FirstPersonAttachments.witch_hunter,
		first_person_heights = {
			charged = 1,
			crouch = 1,
			stand = 1.7,
			knocked_down = 1,
			grabbed_by_tentacle = 1.9
		},
		careers = {
			CareerSettings.wh_captain,
			CareerSettings.wh_bountyhunter,
			CareerSettings.wh_zealot
		},
		base_character_states = var_0_0,
		base_camera_states = var_0_1
	},
	{
		career_voice_parameter = "sienna_career_voice_effect",
		display_name = "bright_wizard",
		hero_selection_image = "hero_icon_bw",
		ingame_short_display_name = "bright_wizard_short",
		character_name = "inventory_name_bright_wizard",
		character_vo = "bright_wizard",
		unit_name = "bright_wizard",
		supports_motion_sickness_modes = true,
		default_wielded_slot = "slot_melee",
		role = "hero",
		ingame_display_name = "inventory_name_bright_wizard",
		affiliation = "heroes",
		ui_portrait = "unit_frame_portrait_sienna_scholar",
		career_voice_parameter_values = {
			0,
			100,
			50
		},
		room_profile = RoomProfiles.bright_wizard,
		base_units = BaseUnits.bright_wizard,
		default_state_machine = var_0_3,
		first_person_attachment = FirstPersonAttachments.bright_wizard,
		first_person_heights = {
			charged = 0.9,
			crouch = 1,
			stand = 1.55,
			knocked_down = 0.95,
			grabbed_by_tentacle = 1.7
		},
		careers = {
			CareerSettings.bw_adept,
			CareerSettings.bw_scholar,
			CareerSettings.bw_unchained
		},
		base_character_states = var_0_0,
		base_camera_states = var_0_1
	},
	{
		career_voice_parameter = "dwarf_career_voice_effect",
		display_name = "dwarf_ranger",
		hero_selection_image = "hero_icon_dr",
		ingame_short_display_name = "dwarf_ranger_short",
		character_name = "inventory_name_dwarf_ranger",
		character_vo = "dwarf_ranger",
		unit_name = "dwarf_ranger",
		supports_motion_sickness_modes = true,
		default_wielded_slot = "slot_melee",
		role = "hero",
		ingame_display_name = "inventory_name_dwarf_ranger",
		affiliation = "heroes",
		ui_portrait = "unit_frame_portrait_bardin_ranger",
		career_voice_parameter_values = {
			0,
			100,
			50
		},
		room_profile = RoomProfiles.dwarf_ranger,
		base_units = BaseUnits.dwarf_ranger,
		default_state_machine = var_0_3,
		first_person_attachment = FirstPersonAttachments.dwarf_ranger,
		first_person_heights = {
			charged = 0.75,
			crouch = 1,
			stand = 1.3,
			knocked_down = 0.7,
			grabbed_by_tentacle = 1.7
		},
		careers = {
			CareerSettings.dr_ranger,
			CareerSettings.dr_ironbreaker,
			CareerSettings.dr_slayer
		},
		base_character_states = var_0_0,
		base_camera_states = var_0_1
	},
	{
		career_voice_parameter = "kerillian_career_voice_effect",
		display_name = "wood_elf",
		hero_selection_image = "hero_icon_ww",
		ingame_short_display_name = "wood_elf_short",
		character_name = "inventory_name_wood_elf",
		character_vo = "wood_elf",
		unit_name = "way_watcher",
		supports_motion_sickness_modes = true,
		default_wielded_slot = "slot_melee",
		role = "hero",
		ingame_display_name = "inventory_name_wood_elf",
		affiliation = "heroes",
		ui_portrait = "unit_frame_portrait_kerillian_waywatcher",
		career_voice_parameter_values = {
			0,
			100,
			50
		},
		room_profile = RoomProfiles.wood_elf,
		base_units = BaseUnits.wood_elf,
		default_state_machine = var_0_3,
		first_person_attachment = FirstPersonAttachments.wood_elf,
		first_person_heights = {
			charged = 0.85,
			crouch = 1,
			stand = 1.5,
			knocked_down = 1,
			grabbed_by_tentacle = 1.7
		},
		careers = {
			CareerSettings.we_waywatcher,
			CareerSettings.we_maidenguard,
			CareerSettings.we_shade
		},
		base_character_states = var_0_0,
		base_camera_states = var_0_1
	},
	{
		career_voice_parameter = "markus_career_voice_effect",
		display_name = "empire_soldier",
		hero_selection_image = "hero_icon_es",
		ingame_short_display_name = "empire_soldier_short",
		character_name = "inventory_name_empire_soldier",
		character_vo = "empire_soldier",
		unit_name = "empire_soldier",
		supports_motion_sickness_modes = true,
		default_wielded_slot = "slot_melee",
		role = "hero",
		ingame_display_name = "inventory_name_empire_soldier",
		affiliation = "heroes",
		ui_portrait = "unit_frame_portrait_kruber_huntsman",
		career_voice_parameter_values = {
			0,
			100,
			50
		},
		room_profile = RoomProfiles.empire_soldier,
		base_units = BaseUnits.empire_soldier,
		default_state_machine = var_0_3,
		first_person_attachment = FirstPersonAttachments.empire_soldier,
		first_person_heights = {
			charged = 1,
			crouch = 1,
			stand = 1.65,
			knocked_down = 1,
			grabbed_by_tentacle = 1.9
		},
		careers = {
			CareerSettings.es_mercenary,
			CareerSettings.es_huntsman,
			CareerSettings.es_knight
		},
		base_character_states = var_0_0,
		base_camera_states = var_0_1
	},
	{
		career_voice_parameter = "markus_career_voice_effect",
		display_name = "empire_soldier_tutorial",
		hero_selection_image = "hero_icon_es",
		ingame_short_display_name = "empire_soldier_short",
		character_name = "inventory_name_empire_soldier",
		character_vo = "empire_soldier",
		unit_name = "empire_soldier",
		unit_template_name = "player_unit_3rd_tutorial",
		tutorial_profile = true,
		supports_motion_sickness_modes = true,
		default_wielded_slot = "slot_melee",
		role = "hero",
		ingame_display_name = "inventory_name_empire_soldier",
		affiliation = "tutorial",
		ui_portrait = "unit_frame_portrait_kruber_knight",
		career_voice_parameter_values = {
			0,
			100,
			50
		},
		room_profile = RoomProfiles.empire_soldier,
		base_units = BaseUnits.empire_soldier,
		default_state_machine = var_0_3,
		first_person_attachment = FirstPersonAttachments.empire_soldier,
		first_person_heights = {
			grabbed_by_tentacle = 1.9,
			knocked_down = 1,
			crouch = 1,
			stand = 1.65
		},
		careers = {
			CareerSettings.empire_soldier_tutorial,
			CareerSettings.empire_soldier_tutorial,
			CareerSettings.empire_soldier_tutorial
		},
		base_character_states = var_0_0,
		base_camera_states = var_0_1
	}
}
TUTORIAL_PROFILE_INDEX = nil

for iter_0_6, iter_0_7 in pairs(SPProfiles) do
	if iter_0_7.tutorial_profile then
		TUTORIAL_PROFILE_INDEX = iter_0_6
	end
end

local function var_0_5()
	for iter_1_0 = 1, #SPProfiles do
		local var_1_0 = SPProfiles[iter_1_0]
		local var_1_1 = var_1_0.display_name

		if not PROFILES_BY_NAME[var_1_1] then
			var_1_0.index = iter_1_0
			PROFILES_BY_NAME[var_1_1] = var_1_0

			local var_1_2 = var_1_0.affiliation or "unfinished"

			if not PROFILES_BY_AFFILIATION[var_1_2] then
				PROFILES_BY_AFFILIATION[var_1_2] = {}
			end

			local var_1_3 = PROFILES_BY_AFFILIATION[var_1_2]

			var_1_3[#var_1_3 + 1] = var_1_1
			var_1_3[var_1_1] = true
		end
	end
end

function FindProfileIndex(arg_2_0)
	local var_2_0 = PROFILES_BY_NAME[arg_2_0]

	return var_2_0 and var_2_0.index
end

function GetHeroAffiliationIndex(arg_3_0)
	local var_3_0 = SPProfiles[arg_3_0]
	local var_3_1 = PROFILES_BY_AFFILIATION.heroes

	for iter_3_0 = 1, #var_3_1 do
		local var_3_2 = var_3_1[iter_3_0]

		if var_3_0.display_name == var_3_2 then
			return iter_3_0
		end
	end
end

function add_career_to_profile(arg_4_0, arg_4_1)
	local var_4_0 = FindProfileIndex(arg_4_0)
	local var_4_1 = SPProfiles[var_4_0].careers

	table.insert(var_4_1, arg_4_1)
end

PROFILES_BY_NAME = {}
PROFILES_BY_AFFILIATION = {}

var_0_5()

for iter_0_8, iter_0_9 in pairs(DLCSettings) do
	local var_0_6 = iter_0_9.profile_files

	if var_0_6 then
		for iter_0_10, iter_0_11 in ipairs(var_0_6) do
			local var_0_7 = dofile(iter_0_11)

			if var_0_7 then
				table.append(SPProfiles, var_0_7)
			end
		end
	end
end

var_0_5()

PROFILES_BY_NAME = {}
PROFILES_BY_CAREER_NAMES = {}
PROFILES_BY_AFFILIATION = {}

for iter_0_12 = 1, #SPProfiles do
	local var_0_8 = SPProfiles[iter_0_12]

	var_0_8.index = iter_0_12
	PROFILES_BY_NAME[var_0_8.display_name] = var_0_8

	local var_0_9 = var_0_8.affiliation or "unfinished"

	if not PROFILES_BY_AFFILIATION[var_0_9] then
		PROFILES_BY_AFFILIATION[var_0_9] = {}
	end

	local var_0_10 = PROFILES_BY_AFFILIATION[var_0_9]

	var_0_10[#var_0_10 + 1] = var_0_8.display_name
	var_0_10[var_0_8.display_name] = true

	local var_0_11 = var_0_8.careers

	for iter_0_13, iter_0_14 in ipairs(var_0_11) do
		PROFILES_BY_CAREER_NAMES[iter_0_14.name] = var_0_8
	end
end

function career_index_from_name(arg_5_0, arg_5_1)
	local var_5_0 = SPProfiles[arg_5_0].careers

	for iter_5_0, iter_5_1 in ipairs(var_5_0) do
		if iter_5_1.name == arg_5_1 then
			return iter_5_0
		end
	end

	return nil
end

function hero_and_career_name_from_index(arg_6_0, arg_6_1)
	local var_6_0 = SPProfiles[arg_6_0]
	local var_6_1 = var_6_0.careers[arg_6_1]
	local var_6_2 = var_6_0.display_name
	local var_6_3 = var_6_1.name

	return var_6_2, var_6_3
end

DefaultUnits = {
	standard = {
		backlit_camera = "units/generic/backlit_camera",
		camera = "core/units/camera"
	}
}

local var_0_12 = {}
local var_0_13 = {}

for iter_0_15, iter_0_16 in ipairs(SPProfiles) do
	for iter_0_17, iter_0_18 in ipairs(iter_0_16.careers) do
		local var_0_14 = table.clone(iter_0_16.base_character_states)
		local var_0_15 = table.clone(iter_0_16.base_camera_states)
		local var_0_16 = iter_0_18.additional_character_states_list

		if var_0_16 then
			for iter_0_19, iter_0_20 in ipairs(var_0_16) do
				var_0_14[#var_0_14 + 1] = iter_0_20
			end
		end

		local var_0_17 = iter_0_18.additional_camera_states_list

		if var_0_17 then
			for iter_0_21, iter_0_22 in ipairs(var_0_17) do
				var_0_15[#var_0_15 + 1] = iter_0_22
			end
		end

		for iter_0_23, iter_0_24 in ipairs(var_0_14) do
			fassert(var_0_12[iter_0_24] == nil, "Character state '%s' referenced more than once in career - %s profile - %s", iter_0_24, iter_0_18.display_name, iter_0_16.display_name)

			var_0_12[iter_0_24] = true
		end

		for iter_0_25, iter_0_26 in ipairs(var_0_15) do
			fassert(var_0_13[iter_0_26] == nil, "Camera state '%s' referenced more than once in career - %s profile - %s", iter_0_26, iter_0_18.display_name, iter_0_16.display_name)

			var_0_13[iter_0_26] = true
		end

		iter_0_18.character_state_list = var_0_14
		iter_0_18.camera_state_list = var_0_15

		table.clear(var_0_12)
		table.clear(var_0_13)
	end
end
