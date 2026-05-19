-- chunkname: @scripts/ui/hud_ui/component_list_definitions/hud_component_list_versus.lua

local function var_0_0()
	local var_1_0 = Managers.party:get_local_player_party()
	local var_1_1 = Managers.state.side.side_by_party[var_1_0]

	return var_1_1 and var_1_1:name() == "dark_pact"
end

local function var_0_1()
	local var_2_0 = Managers.party:get_local_player_party()
	local var_2_1 = Managers.state.side.side_by_party[var_2_0]

	return var_2_1 and var_2_1:name() == "heroes"
end

local function var_0_2()
	local var_3_0 = Managers.party:get_local_player_party()
	local var_3_1 = Managers.state.side.side_by_party[var_3_0]

	if not var_3_1 then
		return false
	end

	local var_3_2 = var_3_1:name()

	return var_3_2 == "dark_pact" or var_3_2 == "spectators"
end

local var_0_3 = {
	{
		class_name = "VersusOnboardingUI",
		filename = "scripts/ui/hud_ui/versus_onboarding_ui",
		visibility_groups = {
			"dead",
			"alive"
		}
	},
	{
		class_name = "GameplayInfoUI",
		filename = "scripts/ui/hud_ui/gameplay_info_ui",
		visibility_groups = {
			"dead",
			"alive"
		},
		validation_function = var_0_0
	},
	{
		class_name = "DarkPactAbilityUI",
		filename = "scripts/ui/hud_ui/dark_pact_ability_ui",
		visibility_groups = {
			"alive",
			"ghost_mode"
		},
		validation_function = var_0_2
	},
	{
		class_name = "DarkPactSelectionUI",
		filename = "scripts/ui/hud_ui/dark_pact_selection_ui",
		visibility_groups = {
			"alive",
			"dead"
		},
		validation_function = var_0_0
	},
	{
		use_hud_scale = true,
		class_name = "TutorialUI",
		filename = "scripts/ui/views/tutorial_ui",
		visibility_groups = {
			"alive"
		}
	},
	{
		class_name = "DarkPactClimbingUI",
		filename = "scripts/ui/hud_ui/dark_pact_climbing_ui",
		visibility_groups = {
			"alive"
		},
		validation_function = var_0_0
	},
	{
		use_hud_scale = true,
		class_name = "WorldMarkerUI",
		filename = "scripts/ui/hud_ui/world_marker_ui",
		visibility_groups = {
			"dead",
			"alive",
			"spectator"
		}
	},
	{
		use_hud_scale = true,
		class_name = "LootObjectiveUI",
		filename = "scripts/ui/hud_ui/loot_objective_ui",
		visibility_groups = {
			"dead",
			"alive",
			"spectator"
		}
	},
	{
		use_hud_scale = true,
		class_name = "WaitForRescueUI",
		filename = "scripts/ui/hud_ui/wait_for_rescue_ui",
		visibility_groups = {
			"dead"
		}
	},
	{
		use_hud_scale = true,
		class_name = "ItemReceivedFeedbackUI",
		filename = "scripts/ui/hud_ui/item_received_feedback_ui",
		visibility_groups = {
			"alive"
		}
	},
	{
		use_hud_scale = true,
		class_name = "OverchargeBarUI",
		filename = "scripts/ui/hud_ui/overcharge_bar_ui",
		visibility_groups = {
			"alive",
			"spectator"
		}
	},
	{
		use_hud_scale = true,
		class_name = "BossHealthUI",
		filename = "scripts/ui/hud_ui/boss_health_ui",
		visibility_groups = {
			"dead",
			"alive",
			"spectator"
		}
	},
	{
		class_name = "RewardsPopupUI",
		filename = "scripts/ui/hud_ui/rewards_popup_ui",
		visibility_groups = {
			"entering_mission",
			"hero_selection_popup",
			"mission_vote",
			"game_mode_disable_hud",
			"cutscene",
			"realism",
			"dead",
			"alive"
		},
		validation_function = function(arg_4_0, arg_4_1)
			return arg_4_1
		end
	},
	{
		class_name = "IngameNewsTickerUI",
		filename = "scripts/ui/hud_ui/ingame_news_ticker_ui",
		visibility_groups = {
			"entering_mission",
			"hero_selection_popup",
			"mission_vote",
			"game_mode_disable_hud",
			"cutscene",
			"realism",
			"dead",
			"alive"
		},
		validation_function = function(arg_5_0, arg_5_1)
			return not script_data.disable_news_ticker
		end
	},
	{
		class_name = "MissionVotingUI",
		filename = "scripts/ui/mission_vote_ui/mission_voting_ui",
		visibility_groups = {
			"entering_mission",
			"mission_vote",
			"in_menu"
		},
		validation_function = function(arg_6_0, arg_6_1)
			return arg_6_1
		end
	},
	{
		use_hud_scale = true,
		class_name = "UnitFramesHandler",
		filename = "scripts/ui/hud_ui/unit_frames_handler",
		visibility_groups = {
			"dead",
			"alive",
			"spectator"
		}
	},
	{
		use_hud_scale = true,
		class_name = "BuffUI",
		filename = "scripts/ui/hud_ui/buff_ui",
		visibility_groups = {
			"alive",
			"spectator"
		},
		validation_function = function()
			return not var_0_0()
		end
	},
	{
		use_hud_scale = true,
		class_name = "BuffPresentationUI",
		filename = "scripts/ui/hud_ui/buff_presentation_ui",
		visibility_groups = {
			"alive"
		},
		validation_function = function()
			return not var_0_0()
		end
	},
	{
		use_hud_scale = true,
		class_name = "EquipmentUI",
		filename = "scripts/ui/hud_ui/equipment_ui",
		visibility_groups = {
			"alive",
			"spectator"
		},
		validation_function = function()
			return not var_0_0()
		end
	},
	{
		use_hud_scale = true,
		class_name = "GamePadEquipmentUI",
		filename = "scripts/ui/hud_ui/gamepad_equipment_ui",
		visibility_groups = {
			"alive"
		},
		validation_function = function()
			return not var_0_0()
		end
	},
	{
		use_hud_scale = true,
		class_name = "AbilityUI",
		filename = "scripts/ui/hud_ui/ability_ui",
		visibility_groups = {
			"alive",
			"spectator"
		},
		validation_function = function()
			return not var_0_0()
		end
	},
	{
		use_hud_scale = true,
		class_name = "GamePadAbilityUI",
		filename = "scripts/ui/hud_ui/gamepad_ability_ui",
		visibility_groups = {
			"alive"
		},
		validation_function = function()
			return not var_0_0()
		end
	},
	{
		class_name = "DamageNumbersUI",
		filename = "scripts/ui/hud_ui/damage_numbers_ui",
		visibility_groups = {
			"alive"
		}
	},
	{
		use_hud_scale = true,
		class_name = "InteractionUI",
		filename = "scripts/ui/views/interaction_ui",
		visibility_groups = {
			"realism",
			"game_mode_disable_hud",
			"alive"
		}
	},
	{
		use_hud_scale = true,
		class_name = "DamageIndicatorGui",
		filename = "scripts/ui/views/damage_indicator_gui",
		visibility_groups = {
			"alive"
		}
	},
	{
		use_hud_scale = true,
		class_name = "AreaIndicatorUI",
		filename = "scripts/ui/views/area_indicator_ui",
		visibility_groups = {
			"game_mode_disable_hud",
			"dead",
			"alive"
		}
	},
	{
		use_hud_scale = true,
		class_name = "VersusMissionObjectiveUI",
		filename = "scripts/ui/views/versus_mission_objective_ui",
		visibility_groups = {
			"dead",
			"alive",
			"spectator"
		}
	},
	{
		use_hud_scale = true,
		class_name = "CrosshairUI",
		filename = "scripts/ui/views/crosshair_ui",
		visibility_groups = {
			"alive"
		}
	},
	{
		use_hud_scale = true,
		class_name = "KillConfirmationUI",
		filename = "scripts/ui/hud_ui/kill_confirmation_ui",
		visibility_groups = {
			"dead",
			"alive"
		}
	},
	{
		use_hud_scale = true,
		class_name = "FatigueUI",
		filename = "scripts/ui/views/fatigue_ui",
		visibility_groups = {
			"alive"
		},
		validation_function = function()
			return not var_0_0()
		end
	},
	{
		use_hud_scale = true,
		class_name = "BonusDiceUI",
		filename = "scripts/ui/views/bonus_dice_ui",
		visibility_groups = {
			"alive"
		},
		validation_function = function()
			return not var_0_0()
		end
	},
	{
		class_name = "VersusTabUI",
		filename = "scripts/ui/hud_ui/versus_tab_ui",
		visibility_groups = {
			"tab_menu",
			"realism",
			"game_mode_disable_hud",
			"dead",
			"alive"
		}
	},
	{
		use_hud_scale = true,
		class_name = "PositiveReinforcementUI",
		filename = "scripts/ui/views/positive_reinforcement_ui",
		visibility_groups = {
			"dead",
			"alive",
			"spectator"
		}
	},
	{
		use_hud_scale = true,
		class_name = "TutorialInputUI",
		filename = "scripts/ui/views/tutorial_input_ui",
		visibility_groups = {
			"game_mode_disable_hud",
			"alive"
		}
	},
	{
		class_name = "CutsceneOverlayUI",
		filename = "scripts/ui/views/cutscene_overlay_ui",
		visibility_groups = {
			"cutscene",
			"alive"
		}
	},
	{
		class_name = "CutsceneUI",
		filename = "scripts/ui/views/cutscene_ui",
		visibility_groups = {
			"entering_mission",
			"mission_vote",
			"hero_selection_popup",
			"in_endscreen",
			"in_menu",
			"tab_menu",
			"game_mode_disable_hud",
			"cutscene",
			"realism",
			"dead",
			"alive"
		}
	},
	{
		use_hud_scale = true,
		class_name = "PlayerInventoryUI",
		filename = "scripts/ui/views/player_inventory_ui",
		visibility_groups = {
			"alive"
		},
		validation_function = function(arg_15_0, arg_15_1)
			return false
		end
	},
	{
		use_hud_scale = true,
		class_name = "SubtitleGui",
		filename = "scripts/ui/views/subtitle_gui",
		visibility_groups = {
			"cutscene",
			"realism",
			"dead",
			"alive"
		},
		validation_function = function(arg_16_0, arg_16_1)
			if arg_16_1 then
				return true
			elseif not (Managers.twitch and (Managers.twitch:is_connected() or Managers.twitch:is_activated())) then
				return true
			end
		end
	},
	{
		use_hud_scale = true,
		class_name = "GiftPopupUI",
		filename = "scripts/ui/gift_popup/gift_popup_ui",
		visibility_groups = {
			"alive"
		}
	},
	{
		use_hud_scale = true,
		class_name = "IngameVotingUI",
		filename = "scripts/ui/views/ingame_voting_ui",
		visibility_groups = {
			"realism",
			"game_mode_disable_hud",
			"dead",
			"alive"
		}
	},
	{
		use_hud_scale = true,
		class_name = "MatchmakingUI",
		filename = "scripts/ui/views/matchmaking_ui",
		visibility_groups = {
			"mission_vote",
			"hero_selection_popup",
			"in_endscreen",
			"in_menu",
			"tab_menu",
			"game_mode_disable_hud",
			"cutscene",
			"realism",
			"dead",
			"alive"
		}
	},
	{
		class_name = "FloatingIconUI",
		filename = "scripts/ui/hud_ui/floating_icon_ui",
		visibility_groups = {
			"alive"
		}
	},
	{
		class_name = "SocialWheelUI",
		filename = "scripts/ui/social_wheel/social_wheel_ui",
		visibility_groups = {
			"alive",
			"realism"
		},
		validation_function = function(arg_17_0, arg_17_1)
			return Managers.state.game_mode:game_mode_key() ~= "tutorial" and not arg_17_1
		end
	},
	{
		class_name = "SpectatorUI",
		filename = "scripts/ui/hud_ui/spectator_ui",
		visibility_groups = {
			"spectator"
		}
	},
	{
		use_hud_scale = true,
		class_name = "EmotePhotomodeUI",
		filename = "scripts/ui/hud_ui/emote_photomode_ui",
		visibility_groups = {
			"dead",
			"alive"
		}
	},
	{
		use_hud_scale = true,
		class_name = "ChallengeTrackerUI",
		filename = "scripts/ui/hud_ui/challenge_tracker_ui",
		visibility_groups = {
			"game_mode_disable_hud",
			"dead",
			"alive"
		},
		validation_function = var_0_1
	},
	{
		use_hud_scale = true,
		class_name = "PetUI",
		filename = "scripts/ui/hud_ui/pet_ui",
		visibility_groups = {
			"alive"
		}
	}
}

DLCUtils.append("ingame_hud_components", var_0_3)

local var_0_4 = {
	{
		name = "disable_ingame_ui",
		validation_function = function(arg_18_0)
			return (arg_18_0:parent():disable_ingame_ui())
		end
	},
	{
		name = "entering_mission",
		validation_function = function(arg_19_0)
			local var_19_0 = arg_19_0:component("LevelCountdownUI")

			return var_19_0 and var_19_0:is_enter_game()
		end
	},
	{
		name = "hero_selection_popup",
		validation_function = function(arg_20_0)
			return arg_20_0:parent():get_active_popup("profile_picker")
		end
	},
	{
		name = "mission_vote",
		validation_function = function(arg_21_0)
			local var_21_0 = arg_21_0:component("MissionVotingUI")

			return var_21_0 and var_21_0:is_active()
		end
	},
	{
		name = "in_endscreen",
		validation_function = function(arg_22_0)
			local var_22_0 = arg_22_0:parent()
			local var_22_1 = var_22_0:end_screen_active()

			return var_22_0.end_of_level_ui ~= nil or var_22_1
		end
	},
	{
		name = "in_menu",
		validation_function = function(arg_23_0)
			local var_23_0 = arg_23_0:parent()
			local var_23_1 = var_23_0.menu_active
			local var_23_2 = var_23_0.current_view

			return var_23_1 or var_23_2 ~= nil
		end
	},
	{
		name = "gift_popup",
		validation_function = function(arg_24_0)
			local var_24_0 = arg_24_0:component("GiftPopupUI")

			return var_24_0 and var_24_0:active()
		end
	},
	{
		name = "cutscene",
		validation_function = function(arg_25_0)
			local var_25_0 = Managers.state.entity:system("cutscene_system")

			return var_25_0.active_camera and not var_25_0.ingame_hud_enabled
		end
	},
	{
		name = "tab_menu",
		validation_function = function(arg_26_0)
			local var_26_0 = arg_26_0:component("VersusTabUI")

			return var_26_0 and var_26_0:is_active()
		end
	},
	{
		name = "in_inn",
		validation_function = function(arg_27_0)
			return arg_27_0:is_in_inn()
		end
	},
	{
		name = "realism",
		validation_function = function(arg_28_0)
			local var_28_0 = Managers.state.game_mode

			return var_28_0 and var_28_0:has_activated_mutator("realism")
		end
	},
	{
		name = "game_mode_disable_hud",
		validation_function = function(arg_29_0)
			local var_29_0 = Managers.state.game_mode
			local var_29_1 = var_29_0 and var_29_0:game_mode()

			return var_29_1 and var_29_1.game_mode_hud_disabled and var_29_1:game_mode_hud_disabled()
		end
	},
	{
		name = "spectator",
		validation_function = function(arg_30_0)
			return Managers.player:local_player():get_party().name == "spectators"
		end
	},
	{
		name = "dead",
		validation_function = function(arg_31_0)
			local var_31_0 = Managers.player:local_player()
			local var_31_1 = Managers.state.side:get_side_from_player_unique_id(var_31_0:unique_id())
			local var_31_2 = var_31_1 and var_31_1:name() == "heroes"
			local var_31_3 = true

			if var_31_2 then
				var_31_3 = Managers.state.game_mode:game_mode():player_ready()
			end

			return arg_31_0:is_own_player_dead() and var_31_3
		end
	},
	{
		name = "alive",
		validation_function = function(arg_32_0)
			local var_32_0 = Managers.player:local_player().player_unit
			local var_32_1 = Managers.state.game_mode:game_mode():player_ready()

			return var_32_0 and Unit.alive(var_32_0) and var_32_1
		end
	},
	{
		name = "ghost_mode",
		validation_function = function(arg_33_0)
			local var_33_0 = Managers.player:local_player()
			local var_33_1 = ScriptUnit.has_extension(var_33_0.unit, "ghost_mode_system")

			return var_33_1 and var_33_1:is_in_ghost_mode()
		end
	}
}

for iter_0_0 = 1, #var_0_3 do
	require(var_0_3[iter_0_0].filename)
end

return {
	components = var_0_3,
	visibility_groups = var_0_4
}
