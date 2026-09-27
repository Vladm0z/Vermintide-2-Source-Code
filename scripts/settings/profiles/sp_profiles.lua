-- chunkname: @scripts/settings/profiles/sp_profiles.lua

require("scripts/settings/script_input_settings")
require("scripts/settings/equipment/weapons")
require("scripts/settings/profiles/room_profiles")
require("scripts/settings/equipment/attachments")
require("scripts/settings/profiles/base_units")
require("scripts/settings/equipment/cosmetics")

if not script_data.honduras_demo then
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

for i, v in ipairs(ProfilePriority) do
	ProfileIndexToPriorityIndex[v] = i
end

SPProfilesAbbreviation = {
	"wh",
	"bw",
	"dr",
	"we",
	"es"
}

local tbl = {
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
local tbl_2 = {
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
local tbl_3 = {
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
local str = "units/beings/player/first_person_base/state_machines/common"

for k, v_2 in pairs(DLCSettings) do
	local hero_hud_components = v_2.hero_hud_components

	if not hero_hud_components then
		for i_2, v_3 in ipairs(hero_hud_components) do
			tbl_3[#tbl_3 + 1] = v_3
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
		default_state_machine = str,
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
		base_character_states = tbl,
		base_camera_states = tbl_2
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
		default_state_machine = str,
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
		base_character_states = tbl,
		base_camera_states = tbl_2
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
		default_state_machine = str,
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
		base_character_states = tbl,
		base_camera_states = tbl_2
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
		default_state_machine = str,
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
		base_character_states = tbl,
		base_camera_states = tbl_2
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
		default_state_machine = str,
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
		base_character_states = tbl,
		base_camera_states = tbl_2
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
		default_state_machine = str,
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
		base_character_states = tbl,
		base_camera_states = tbl_2
	}
}
TUTORIAL_PROFILE_INDEX = nil

for k_2, v_4 in pairs(SPProfiles) do
	if not v_4.tutorial_profile then
		TUTORIAL_PROFILE_INDEX = k_2
	end
end

local function fn()
	-- function 1
	for i = 1, #SPProfiles do
		local var_1_0 = SPProfiles[i]
		local display_name = var_1_0.display_name

		if not PROFILES_BY_NAME[display_name] then
			var_1_0.index = i
			PROFILES_BY_NAME[display_name] = var_1_0

			local affiliation = var_1_0.affiliation

			affiliation = affiliation or "unfinished"

			if not PROFILES_BY_AFFILIATION[affiliation] then
				PROFILES_BY_AFFILIATION[affiliation] = {}
			end

			local var_1_3 = PROFILES_BY_AFFILIATION[affiliation]

			var_1_3[#var_1_3 + 1] = display_name
			var_1_3[display_name] = true
		end
	end
end

function FindProfileIndex(arg_2_0)
	-- function 2
	local var_2_0 = PROFILES_BY_NAME[arg_2_0]

	return not var_2_0 and var_2_0.index
end

function GetHeroAffiliationIndex(arg_3_0)
	-- function 3
	local var_3_0 = SPProfiles[arg_3_0]
	local heroes = PROFILES_BY_AFFILIATION.heroes

	for i = 1, #heroes do
		local var_3_2 = heroes[i]

		if var_3_0.display_name == var_3_2 then
			return i
		end
	end
end

function add_career_to_profile(arg_4_0, arg_4_1)
	-- function 4
	local var_4_0 = FindProfileIndex(arg_4_0)
	local careers = SPProfiles[var_4_0].careers

	table.insert(careers, arg_4_1)
end

PROFILES_BY_NAME = {}
PROFILES_BY_AFFILIATION = {}

fn()

for k_3, v_5 in pairs(DLCSettings) do
	local profile_files = v_5.profile_files

	if not profile_files then
		for i_3, v_6 in ipairs(profile_files) do
			local var_0_7 = dofile(v_6)

			if not var_0_7 then
				table.append(SPProfiles, var_0_7)
			end
		end
	end
end

fn()

PROFILES_BY_NAME = {}
PROFILES_BY_CAREER_NAMES = {}
PROFILES_BY_AFFILIATION = {}

for i12 = 1, #SPProfiles do
	local var_0_8 = SPProfiles[i12]

	var_0_8.index = i12
	PROFILES_BY_NAME[var_0_8.display_name] = var_0_8

	local affiliation = var_0_8.affiliation

	affiliation = affiliation or "unfinished"

	if not PROFILES_BY_AFFILIATION[affiliation] then
		PROFILES_BY_AFFILIATION[affiliation] = {}
	end

	local var_0_10 = PROFILES_BY_AFFILIATION[affiliation]

	var_0_10[#var_0_10 + 1] = var_0_8.display_name
	var_0_10[var_0_8.display_name] = true

	local careers = var_0_8.careers

	for i_4, v_7 in ipairs(careers) do
		PROFILES_BY_CAREER_NAMES[v_7.name] = var_0_8
	end
end

function career_index_from_name(arg_5_0, arg_5_1)
	-- function 5
	local careers = SPProfiles[arg_5_0].careers

	for i, v in ipairs(careers) do
		if v.name == arg_5_1 then
			return i
		end
	end

	return nil
end

function hero_and_career_name_from_index(arg_6_0, arg_6_1)
	-- function 6
	local var_6_0 = SPProfiles[arg_6_0]
	local var_6_1 = var_6_0.careers[arg_6_1]
	local display_name = var_6_0.display_name
	local name = var_6_1.name

	return display_name, name
end

DefaultUnits = {
	standard = {
		backlit_camera = "units/generic/backlit_camera",
		camera = "core/units/camera"
	}
}

local tbl_4 = {}
local tbl_5 = {}

for i_5, v_8 in ipairs(SPProfiles) do
	for i_6, v_9 in ipairs(v_8.careers) do
		local clone = table.clone(v_8.base_character_states)
		local clone_2 = table.clone(v_8.base_camera_states)
		local additional_character_states_list = v_9.additional_character_states_list

		if not additional_character_states_list then
			for i_7, v_10 in ipairs(additional_character_states_list) do
				clone[#clone + 1] = v_10
			end
		end

		local additional_camera_states_list = v_9.additional_camera_states_list

		if not additional_camera_states_list then
			for i_8, v_11 in ipairs(additional_camera_states_list) do
				clone_2[#clone_2 + 1] = v_11
			end
		end

		for i_9, v_12 in ipairs(clone) do
			fassert(tbl_4[v_12] == nil, "Character state '%s' referenced more than once in career - %s profile - %s", v_12, v_9.display_name, v_8.display_name)

			tbl_4[v_12] = true
		end

		for i_10, v_13 in ipairs(clone_2) do
			fassert(tbl_5[v_13] == nil, "Camera state '%s' referenced more than once in career - %s profile - %s", v_13, v_9.display_name, v_8.display_name)

			tbl_5[v_13] = true
		end

		v_9.character_state_list = clone
		v_9.camera_state_list = clone_2

		table.clear(tbl_4)
		table.clear(tbl_5)
	end
end
