-- chunkname: @scripts/ui/hud_ui/component_list_definitions/hud_component_list_adventure.lua

local tbl = {
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
			-- function 1
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
			-- function 2
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
			-- function 3
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
			-- function 4
			return not GameSettingsDevelopment.backend_settings.quests_enabled and not arg_4_1
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
			-- function 5
			local debug_show_damage_numbers = script_data.debug_show_damage_numbers
			local debug_ai_attack_pattern = script_data.debug_ai_attack_pattern

			return arg_5_1 or debug_show_damage_numbers or debug_ai_attack_pattern
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
			-- function 6
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
			-- function 7
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
	}
}
local tbl_2 = {
	class_name = "IngamePlayerListUI"
}
local flag

flag = not GameSettingsDevelopment.use_new_tab_menu and "scripts/ui/views/ingame_player_list_ui_v2" and "scripts/ui/views/ingame_player_list_ui"
tbl_2.filename = flag
tbl_2.visibility_groups = {
	"tab_menu",
	"realism",
	"game_mode_disable_hud",
	"dead",
	"alive"
}
tbl[34] = tbl_2
tbl[35] = {
	use_hud_scale = true,
	class_name = "PositiveReinforcementUI",
	filename = "scripts/ui/views/positive_reinforcement_ui",
	visibility_groups = {
		"dead",
		"alive"
	}
}
tbl[36] = {
	use_hud_scale = true,
	class_name = "TutorialInputUI",
	filename = "scripts/ui/views/tutorial_input_ui",
	visibility_groups = {
		"game_mode_disable_hud",
		"alive"
	},
	validation_function = function ()
		-- function 8
		local current_level_settings = LevelHelper.current_level_settings()
		local tutorial_level = current_level_settings.tutorial_level

		tutorial_level = tutorial_level or current_level_settings.game_mode == "inn_vs"

		return tutorial_level
	end
}
tbl[37] = {
	class_name = "CutsceneOverlayUI",
	filename = "scripts/ui/views/cutscene_overlay_ui",
	visibility_groups = {
		"cutscene",
		"alive"
	}
}
tbl[38] = {
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
}
tbl[39] = {
	use_hud_scale = true,
	class_name = "PlayerInventoryUI",
	filename = "scripts/ui/views/player_inventory_ui",
	visibility_groups = {
		"alive"
	},
	validation_function = function (arg_9_0, arg_9_1)
		-- function 9
		return false
	end
}
tbl[40] = {
	use_hud_scale = true,
	class_name = "SubtitleGui",
	filename = "scripts/ui/views/subtitle_gui",
	visibility_groups = {
		"cutscene",
		"realism",
		"dead",
		"alive"
	}
}
tbl[41] = {
	use_hud_scale = true,
	class_name = "GiftPopupUI",
	filename = "scripts/ui/gift_popup/gift_popup_ui",
	visibility_groups = {
		"alive",
		"gift_popup"
	}
}
tbl[42] = {
	use_hud_scale = true,
	class_name = "IngameVotingUI",
	filename = "scripts/ui/views/ingame_voting_ui",
	visibility_groups = {
		"realism",
		"game_mode_disable_hud",
		"dead",
		"alive"
	}
}
tbl[43] = {
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
}
tbl[44] = {
	class_name = "FloatingIconUI",
	filename = "scripts/ui/hud_ui/floating_icon_ui",
	visibility_groups = {
		"alive"
	}
}
tbl[45] = {
	class_name = "SocialWheelUI",
	filename = "scripts/ui/social_wheel/social_wheel_ui",
	visibility_groups = {
		"alive",
		"realism"
	},
	validation_function = function (arg_10_0, arg_10_1)
		-- function 10
		return Managers.state.game_mode:game_mode_key() ~= "tutorial"
	end
}
tbl[46] = {
	use_hud_scale = true,
	class_name = "ChallengeTrackerUI",
	filename = "scripts/ui/hud_ui/challenge_tracker_ui",
	visibility_groups = {
		"game_mode_disable_hud",
		"dead",
		"alive"
	}
}
tbl[47] = {
	use_hud_scale = true,
	class_name = "EmotePhotomodeUI",
	filename = "scripts/ui/hud_ui/emote_photomode_ui",
	visibility_groups = {
		"dead",
		"alive"
	}
}
tbl[48] = {
	use_hud_scale = true,
	class_name = "PetUI",
	filename = "scripts/ui/hud_ui/pet_ui",
	visibility_groups = {
		"alive"
	}
}

DLCUtils.append("ingame_hud_components", tbl)

local tbl_3 = {
	{
		name = "disable_ingame_ui",
		validation_function = function (self)
			-- function 11
			return (self:parent():disable_ingame_ui())
		end
	},
	{
		name = "entering_mission",
		validation_function = function (self)
			-- function 12
			local component = self:component("LevelCountdownUI")

			return not component and component:is_enter_game()
		end
	},
	{
		name = "hero_selection_popup",
		validation_function = function (self)
			-- function 13
			return self:parent():get_active_popup("profile_picker")
		end
	},
	{
		name = "mission_vote",
		validation_function = function (self)
			-- function 14
			local component = self:component("MissionVotingUI")

			return not component and component:is_active()
		end
	},
	{
		name = "in_endscreen",
		validation_function = function (self)
			-- function 15
			local parent = self:parent()
			local end_screen_active = parent:end_screen_active()

			return parent.end_of_level_ui ~= nil or end_screen_active
		end
	},
	{
		name = "in_menu",
		validation_function = function (self)
			-- function 16
			local parent = self:parent()
			local menu_active = parent.menu_active
			local current_view = parent.current_view

			return menu_active or current_view ~= nil
		end
	},
	{
		name = "gift_popup",
		validation_function = function (self)
			-- function 17
			local component = self:component("GiftPopupUI")

			return not component and component:active()
		end
	},
	{
		name = "cutscene",
		validation_function = function (arg_18_0)
			-- function 18
			local system = Managers.state.entity:system("cutscene_system")
			local active_camera = system.active_camera

			active_camera = not active_camera and not system.ingame_hud_enabled

			return active_camera
		end
	},
	{
		name = "tab_menu",
		validation_function = function (self)
			-- function 19
			local component = self:component("IngamePlayerListUI")
			local flag = not component and component:is_active()
			local component_2 = self:component("VersusSlotStatusUI")

			flag = not component_2 and component_2:is_active() and flag

			return flag
		end
	},
	{
		name = "realism",
		validation_function = function (arg_20_0)
			-- function 20
			local game_mode = Managers.state.game_mode

			return not game_mode and game_mode:has_activated_mutator("realism")
		end
	},
	{
		name = "game_mode_disable_hud",
		validation_function = function (arg_21_0)
			-- function 21
			local game_mode = Managers.state.game_mode
			local flag = not game_mode and game_mode:game_mode()

			if not flag then
				-- Nothing
			end

			::label_21_0::

			local game_mode_hud_disabled = flag.game_mode_hud_disabled

			game_mode_hud_disabled = not game_mode_hud_disabled and flag:game_mode_hud_disabled()

			::label_21_1::

			return game_mode_hud_disabled
		end
	},
	{
		name = "emote_photomode",
		validation_function = function (arg_22_0)
			-- function 22
			local game_mode = Managers.state.game_mode
			local flag = not game_mode and game_mode:game_mode()

			return not flag and flag:photomode_enabled()
		end
	},
	{
		name = "dead",
		validation_function = function (self)
			-- function 23
			return self:is_own_player_dead()
		end
	},
	{
		name = "alive",
		validation_function = function (arg_24_0)
			-- function 24
			local peer_id = Network.peer_id()
			local player_unit = Managers.player:player_from_peer_id(peer_id).player_unit

			if not player_unit and not Unit.alive(player_unit) then
				return true
			end

			return false
		end
	}
}

for i, v in ipairs(tbl) do
	local filename = v.filename

	require(filename)
end

return {
	components = tbl,
	visibility_groups = tbl_3
}
