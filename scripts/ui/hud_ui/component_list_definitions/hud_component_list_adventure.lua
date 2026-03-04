-- chunkname: @scripts/ui/hud_ui/component_list_definitions/hud_component_list_adventure.lua

local var_0_0 = {
	{
		use_hud_scale = true,
		class_name = "WorldMarkerUI",
		filename = "scripts/ui/hud_ui/world_marker_ui",
		visibility_groups = {
			"alive",
			"dead",
			"spectator"
		}
	},
	{
		use_hud_scale = true,
		class_name = "LootObjectiveUI",
		filename = "scripts/ui/hud_ui/loot_objective_ui",
		visibility_groups = {
			"dead",
			"alive"
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
		class_name = "CareerAbilityBarUI",
		filename = "scripts/ui/hud_ui/career_ability_bar_ui",
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
			"deus_run_stats",
			"game_mode_disable_hud",
			"entering_mission",
			"hero_selection_popup",
			"mission_vote",
			"game_mode_disable_hud",
			"cutscene",
			"realism",
			"dead",
			"alive",
			"in_menu"
		},
		validation_function = function (arg_1_0, arg_1_1)
			return arg_1_1 or Managers.mechanism:current_mechanism_name() == "deus"
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
		validation_function = function (arg_2_0, arg_2_1)
			return not script_data.disable_news_ticker
		end
	},
	{
		class_name = "MissionVotingUI",
		filename = "scripts/ui/mission_vote_ui/mission_voting_ui",
		visibility_groups = {
			"entering_mission",
			"mission_vote",
			"game_mode_disable_hud",
			"cutscene",
			"realism",
			"dead",
			"alive"
		},
		validation_function = function (arg_3_0, arg_3_1)
			return arg_3_1
		end
	},
	{
		use_hud_scale = true,
		class_name = "LevelCountdownUI",
		filename = "scripts/ui/hud_ui/level_countdown_ui",
		visibility_groups = {
			"entering_mission",
			"mission_vote",
			"dead",
			"alive"
		}
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
		}
	},
	{
		use_hud_scale = true,
		class_name = "BuffPresentationUI",
		filename = "scripts/ui/hud_ui/buff_presentation_ui",
		visibility_groups = {
			"alive"
		}
	},
	{
		use_hud_scale = true,
		class_name = "EquipmentUI",
		filename = "scripts/ui/hud_ui/equipment_ui",
		visibility_groups = {
			"alive"
		}
	},
	{
		use_hud_scale = true,
		class_name = "GamePadEquipmentUI",
		filename = "scripts/ui/hud_ui/gamepad_equipment_ui",
		visibility_groups = {
			"alive"
		}
	},
	{
		use_hud_scale = true,
		class_name = "AbilityUI",
		filename = "scripts/ui/hud_ui/ability_ui",
		visibility_groups = {
			"alive",
			"spectator"
		}
	},
	{
		use_hud_scale = true,
		class_name = "GamePadAbilityUI",
		filename = "scripts/ui/hud_ui/gamepad_ability_ui",
		visibility_groups = {
			"alive"
		}
	},
	{
		use_hud_scale = true,
		class_name = "ContractLogUI",
		filename = "scripts/ui/hud_ui/contract_log_ui",
		visibility_groups = {
			"alive"
		},
		validation_function = function (arg_4_0, arg_4_1)
			return GameSettingsDevelopment.backend_settings.quests_enabled and not arg_4_1
		end
	},
	{
		use_hud_scale = true,
		class_name = "DamageNumbersUI",
		filename = "scripts/ui/hud_ui/damage_numbers_ui",
		visibility_groups = {
			"alive"
		},
		validation_function = function (arg_5_0, arg_5_1)
			local var_5_0 = script_data.debug_show_damage_numbers
			local var_5_1 = script_data.debug_ai_attack_pattern

			return arg_5_1 or var_5_0 or var_5_1
		end
	},
	{
		use_hud_scale = true,
		class_name = "NewsFeedUI",
		filename = "scripts/ui/hud_ui/news_feed_ui",
		visibility_groups = {
			"alive"
		}
	},
	{
		use_hud_scale = true,
		class_name = "TwitchVoteUI",
		filename = "scripts/ui/hud_ui/twitch_vote_ui",
		visibility_groups = {
			"realism",
			"alive",
			"dead"
		},
		validation_function = function (arg_6_0, arg_6_1)
			return true
		end
	},
	{
		use_hud_scale = true,
		class_name = "GameTimerUI",
		filename = "scripts/ui/hud_ui/game_timer_ui",
		visibility_groups = {
			"game_mode_disable_hud",
			"dead",
			"alive",
			"in_endscreen"
		}
	},
	{
		use_hud_scale = true,
		class_name = "DifficultyUnlockUI",
		filename = "scripts/ui/hud_ui/difficulty_unlock_ui",
		visibility_groups = {
			"alive"
		},
		validation_function = function (arg_7_0, arg_7_1)
			return Managers.state.game_mode:game_mode_key() == "survival"
		end
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
		class_name = "TutorialUI",
		filename = "scripts/ui/views/tutorial_ui",
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
		class_name = "MissionObjectiveUI",
		filename = "scripts/ui/views/mission_objective_ui",
		visibility_groups = {
			"game_mode_disable_hud",
			"dead",
			"alive"
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
		class_name = "BadgeUI",
		filename = "scripts/ui/hud_ui/badge_ui",
		visibility_groups = {
			"alive"
		}
	},
	{
		use_hud_scale = true,
		class_name = "FatigueUI",
		filename = "scripts/ui/views/fatigue_ui",
		visibility_groups = {
			"alive"
		}
	},
	{
		use_hud_scale = true,
		class_name = "BonusDiceUI",
		filename = "scripts/ui/views/bonus_dice_ui",
		visibility_groups = {
			"alive"
		}
	},
	{
		class_name = "IngamePlayerListUI",
		filename = GameSettingsDevelopment.use_new_tab_menu and "scripts/ui/views/ingame_player_list_ui_v2" or "scripts/ui/views/ingame_player_list_ui",
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
			"alive"
		}
	},
	{
		use_hud_scale = true,
		class_name = "TutorialInputUI",
		filename = "scripts/ui/views/tutorial_input_ui",
		visibility_groups = {
			"game_mode_disable_hud",
			"alive"
		},
		validation_function = function ()
			local var_8_0 = LevelHelper.current_level_settings()

			return var_8_0.tutorial_level or var_8_0.game_mode == "inn_vs"
		end
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
		validation_function = function (arg_9_0, arg_9_1)
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
		}
	},
	{
		use_hud_scale = true,
		class_name = "GiftPopupUI",
		filename = "scripts/ui/gift_popup/gift_popup_ui",
		visibility_groups = {
			"alive",
			"gift_popup"
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
		validation_function = function (arg_10_0, arg_10_1)
			return Managers.state.game_mode:game_mode_key() ~= "tutorial"
		end
	},
	{
		use_hud_scale = true,
		class_name = "ChallengeTrackerUI",
		filename = "scripts/ui/hud_ui/challenge_tracker_ui",
		visibility_groups = {
			"game_mode_disable_hud",
			"dead",
			"alive"
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
		class_name = "PetUI",
		filename = "scripts/ui/hud_ui/pet_ui",
		visibility_groups = {
			"alive"
		}
	}
}

DLCUtils.append("ingame_hud_components", var_0_0)

local var_0_1 = {
	{
		name = "disable_ingame_ui",
		validation_function = function (arg_11_0)
			return (arg_11_0:parent():disable_ingame_ui())
		end
	},
	{
		name = "entering_mission",
		validation_function = function (arg_12_0)
			local var_12_0 = arg_12_0:component("LevelCountdownUI")

			return var_12_0 and var_12_0:is_enter_game()
		end
	},
	{
		name = "hero_selection_popup",
		validation_function = function (arg_13_0)
			return arg_13_0:parent():get_active_popup("profile_picker")
		end
	},
	{
		name = "mission_vote",
		validation_function = function (arg_14_0)
			local var_14_0 = arg_14_0:component("MissionVotingUI")

			return var_14_0 and var_14_0:is_active()
		end
	},
	{
		name = "in_endscreen",
		validation_function = function (arg_15_0)
			local var_15_0 = arg_15_0:parent()
			local var_15_1 = var_15_0:end_screen_active()

			return var_15_0.end_of_level_ui ~= nil or var_15_1
		end
	},
	{
		name = "in_menu",
		validation_function = function (arg_16_0)
			local var_16_0 = arg_16_0:parent()
			local var_16_1 = var_16_0.menu_active
			local var_16_2 = var_16_0.current_view

			return var_16_1 or var_16_2 ~= nil
		end
	},
	{
		name = "gift_popup",
		validation_function = function (arg_17_0)
			local var_17_0 = arg_17_0:component("GiftPopupUI")

			return var_17_0 and var_17_0:active()
		end
	},
	{
		name = "cutscene",
		validation_function = function (arg_18_0)
			local var_18_0 = Managers.state.entity:system("cutscene_system")

			return var_18_0.active_camera and not var_18_0.ingame_hud_enabled
		end
	},
	{
		name = "tab_menu",
		validation_function = function (arg_19_0)
			local var_19_0 = arg_19_0:component("IngamePlayerListUI")
			local var_19_1 = var_19_0 and var_19_0:is_active()
			local var_19_2 = arg_19_0:component("VersusSlotStatusUI")

			var_19_1 = var_19_2 and var_19_2:is_active() or var_19_1

			return var_19_1
		end
	},
	{
		name = "realism",
		validation_function = function (arg_20_0)
			local var_20_0 = Managers.state.game_mode

			return var_20_0 and var_20_0:has_activated_mutator("realism")
		end
	},
	{
		name = "game_mode_disable_hud",
		validation_function = function (arg_21_0)
			local var_21_0 = Managers.state.game_mode
			local var_21_1 = var_21_0 and var_21_0:game_mode()

			return var_21_1 and var_21_1.game_mode_hud_disabled and var_21_1:game_mode_hud_disabled()
		end
	},
	{
		name = "emote_photomode",
		validation_function = function (arg_22_0)
			local var_22_0 = Managers.state.game_mode
			local var_22_1 = var_22_0 and var_22_0:game_mode()

			return var_22_1 and var_22_1:photomode_enabled()
		end
	},
	{
		name = "dead",
		validation_function = function (arg_23_0)
			return arg_23_0:is_own_player_dead()
		end
	},
	{
		name = "alive",
		validation_function = function (arg_24_0)
			local var_24_0 = Network.peer_id()
			local var_24_1 = Managers.player:player_from_peer_id(var_24_0).player_unit

			if var_24_1 and Unit.alive(var_24_1) then
				return true
			end

			return false
		end
	}
}

for iter_0_0, iter_0_1 in ipairs(var_0_0) do
	local var_0_2 = iter_0_1.filename

	require(var_0_2)
end

return {
	components = var_0_0,
	visibility_groups = var_0_1
}
