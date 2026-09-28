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
		validation_function = function (context, is_in_inn)
			-- function 1
			return not not is_in_inn or Managers.mechanism:current_mechanism_name() == "deus"
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
		validation_function = function (context, is_in_inn)
			-- function 2
			local disable_news_ticker = script_data.disable_news_ticker

			return not disable_news_ticker
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
		validation_function = function (context, is_in_inn)
			-- function 3
			return is_in_inn
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
		validation_function = function (context, is_in_inn)
			-- function 4
			local backend_settings = GameSettingsDevelopment.backend_settings
			local quests_enabled = backend_settings.quests_enabled

			return not not quests_enabled and not not not is_in_inn
		end
	},
	{
		use_hud_scale = true,
		class_name = "DamageNumbersUI",
		filename = "scripts/ui/hud_ui/damage_numbers_ui",
		visibility_groups = {
			"alive"
		},
		validation_function = function (context, is_in_inn)
			-- function 5
			local debug_show_damage_numbers = script_data.debug_show_damage_numbers
			local debug_ai_attack_pattern = script_data.debug_ai_attack_pattern
			local activate = not not is_in_inn or not not debug_show_damage_numbers or not not debug_ai_attack_pattern

			return activate
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
		validation_function = function (context, is_in_inn)
			-- function 6
			local use_twitch_ui = true

			return use_twitch_ui
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
		validation_function = function (context, is_in_inn)
			-- function 7
			local game_mode_key = Managers.state.game_mode:game_mode_key()

			return game_mode_key == "survival"
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

flag = (not GameSettingsDevelopment.use_new_tab_menu or not "scripts/ui/views/ingame_player_list_ui_v2") and not not "scripts/ui/views/ingame_player_list_ui"
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
		local level_settings = LevelHelper.current_level_settings()
		local is_valid = level_settings.tutorial_level

		is_valid = not not is_valid or level_settings.game_mode == "inn_vs"

		return is_valid
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
	validation_function = function (context, is_in_inn)
		-- function 9
		local use_player_inventory = false

		return use_player_inventory
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
	validation_function = function (context, is_in_inn)
		-- function 10
		local game_mode_key = Managers.state.game_mode:game_mode_key()

		return game_mode_key ~= "tutorial"
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

local components = tbl

DLCUtils.append("ingame_hud_components", components)

local visibility_groups = {
	{
		name = "disable_ingame_ui",
		validation_function = function (ingame_hud)
			-- function 11
			local ingame_ui = ingame_hud:parent()
			local disable_ingame_ui = ingame_ui:disable_ingame_ui()

			return disable_ingame_ui
		end
	},
	{
		name = "entering_mission",
		validation_function = function (ingame_hud)
			-- function 12
			local component = ingame_hud:component("LevelCountdownUI")
			local is_enter_game = not not component and not not component:is_enter_game()

			return is_enter_game
		end
	},
	{
		name = "hero_selection_popup",
		validation_function = function (ingame_hud)
			-- function 13
			local ingame_ui = ingame_hud:parent()

			return ingame_ui:get_active_popup("profile_picker")
		end
	},
	{
		name = "mission_vote",
		validation_function = function (ingame_hud)
			-- function 14
			local component = ingame_hud:component("MissionVotingUI")
			local is_active = not not component and not not component:is_active()

			return is_active
		end
	},
	{
		name = "in_endscreen",
		validation_function = function (ingame_hud)
			-- function 15
			local ingame_ui = ingame_hud:parent()
			local end_screen_active = ingame_ui:end_screen_active()
			local in_score_screen = ingame_ui.end_of_level_ui ~= nil

			return not not in_score_screen or not not end_screen_active
		end
	},
	{
		name = "in_menu",
		validation_function = function (ingame_hud)
			-- function 16
			local ingame_ui = ingame_hud:parent()
			local menu_active = ingame_ui.menu_active
			local current_view = ingame_ui.current_view
			local is_menu_active = not not menu_active or current_view ~= nil

			return is_menu_active
		end
	},
	{
		name = "gift_popup",
		validation_function = function (ingame_hud)
			-- function 17
			local component = ingame_hud:component("GiftPopupUI")
			local is_active = not not component and not not component:active()

			return is_active
		end
	},
	{
		name = "cutscene",
		validation_function = function (ingame_hud)
			-- function 18
			local cutscene_system = Managers.state.entity:system("cutscene_system")
			local active_camera = cutscene_system.active_camera

			if active_camera then
				-- Nothing
			end

			active_camera = not cutscene_system.ingame_hud_enabled

			local cutscene_active = active_camera

			::label_18_0::

			return cutscene_active
		end
	},
	{
		name = "tab_menu",
		validation_function = function (ingame_hud)
			-- function 19
			local component = ingame_hud:component("IngamePlayerListUI")
			local is_active = not not component and not not component:is_active()
			local component = ingame_hud:component("VersusSlotStatusUI")

			if component and not component:is_active() then
				-- Nothing
			end

			return is_active
		end
	},
	{
		name = "realism",
		validation_function = function (ingame_hud)
			-- function 20
			local game_mode_manager = Managers.state.game_mode
			local has_realism = not not game_mode_manager and not not game_mode_manager:has_activated_mutator("realism")

			return has_realism
		end
	},
	{
		name = "game_mode_disable_hud",
		validation_function = function (ingame_hud)
			-- function 21
			local game_mode_manager = Managers.state.game_mode
			local game_mode = not not game_mode_manager and not not game_mode_manager:game_mode()

			if game_mode then
				-- Nothing
			end

			::label_21_0::

			local game_mode_hud_disabled = game_mode.game_mode_hud_disabled

			if game_mode_hud_disabled then
				-- Nothing
			end

			game_mode_hud_disabled = game_mode:game_mode_hud_disabled()

			local game_mode_disable_hud = game_mode_hud_disabled

			::label_21_1::

			return game_mode_disable_hud
		end
	},
	{
		name = "emote_photomode",
		validation_function = function (ingame_hud)
			-- function 22
			local game_mode_manager = Managers.state.game_mode
			local game_mode = not not game_mode_manager and not not game_mode_manager:game_mode()
			local photomode_enabled = not not game_mode and not not game_mode:photomode_enabled()

			return photomode_enabled
		end
	},
	{
		name = "dead",
		validation_function = function (ingame_hud)
			-- function 23
			return ingame_hud:is_own_player_dead()
		end
	},
	{
		name = "alive",
		validation_function = function (ingame_hud)
			-- function 24
			local peer_id = Network.peer_id()
			local player_manager = Managers.player
			local my_player = player_manager:player_from_peer_id(peer_id)
			local player_unit = my_player.player_unit

			if player_unit and Unit.alive(player_unit) then
				return true
			end

			return false
		end
	}
}

for _, settings in ipairs(components) do
	local filename = settings.filename

	require(filename)
end

return {
	components = components,
	visibility_groups = visibility_groups
}
