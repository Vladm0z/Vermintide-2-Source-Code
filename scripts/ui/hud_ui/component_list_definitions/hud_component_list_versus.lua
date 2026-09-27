-- chunkname: @scripts/ui/hud_ui/component_list_definitions/hud_component_list_versus.lua

local function fn()
	-- function 1
	local get_local_player_party = Managers.party:get_local_player_party()
	local var_1_1 = Managers.state.side.side_by_party[get_local_player_party]

	return not var_1_1 and var_1_1:name() == "dark_pact"
end

local function fn_2()
	-- function 2
	local get_local_player_party = Managers.party:get_local_player_party()
	local var_2_1 = Managers.state.side.side_by_party[get_local_player_party]

	return not var_2_1 and var_2_1:name() == "heroes"
end

local function fn_3()
	-- function 3
	local get_local_player_party = Managers.party:get_local_player_party()
	local var_3_1 = Managers.state.side.side_by_party[get_local_player_party]

	if not var_3_1 then
		return false
	end

	local name = var_3_1:name()

	return name == "dark_pact" or name == "spectators"
end

local tbl = {
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
		validation_function = fn
	},
	{
		class_name = "DarkPactAbilityUI",
		filename = "scripts/ui/hud_ui/dark_pact_ability_ui",
		visibility_groups = {
			"alive",
			"ghost_mode"
		},
		validation_function = fn_3
	},
	{
		class_name = "DarkPactSelectionUI",
		filename = "scripts/ui/hud_ui/dark_pact_selection_ui",
		visibility_groups = {
			"alive",
			"dead"
		},
		validation_function = fn
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
		validation_function = fn
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
		validation_function = function (arg_4_0, arg_4_1)
			-- function 4
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
		validation_function = function (arg_5_0, arg_5_1)
			-- function 5
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
		validation_function = function (arg_6_0, arg_6_1)
			-- function 6
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
		validation_function = function ()
			-- function 7
			return not fn()
		end
	},
	{
		use_hud_scale = true,
		class_name = "BuffPresentationUI",
		filename = "scripts/ui/hud_ui/buff_presentation_ui",
		visibility_groups = {
			"alive"
		},
		validation_function = function ()
			-- function 8
			return not fn()
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
		validation_function = function ()
			-- function 9
			return not fn()
		end
	},
	{
		use_hud_scale = true,
		class_name = "GamePadEquipmentUI",
		filename = "scripts/ui/hud_ui/gamepad_equipment_ui",
		visibility_groups = {
			"alive"
		},
		validation_function = function ()
			-- function 10
			return not fn()
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
		validation_function = function ()
			-- function 11
			return not fn()
		end
	},
	{
		use_hud_scale = true,
		class_name = "GamePadAbilityUI",
		filename = "scripts/ui/hud_ui/gamepad_ability_ui",
		visibility_groups = {
			"alive"
		},
		validation_function = function ()
			-- function 12
			return not fn()
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
		validation_function = function ()
			-- function 13
			return not fn()
		end
	},
	{
		use_hud_scale = true,
		class_name = "BonusDiceUI",
		filename = "scripts/ui/views/bonus_dice_ui",
		visibility_groups = {
			"alive"
		},
		validation_function = function ()
			-- function 14
			return not fn()
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
		validation_function = function (arg_15_0, arg_15_1)
			-- function 15
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
		validation_function = function (arg_16_0, arg_16_1)
			-- function 16
			if not arg_16_1 then
				return true
			else
				local twitch = Managers.twitch

				if not twitch then
					twitch = Managers.twitch:is_connected()
					twitch = twitch or Managers.twitch:is_activated()
				end

				if not twitch then
					return true
				end
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
		validation_function = function (arg_17_0, arg_17_1)
			-- function 17
			return Managers.state.game_mode:game_mode_key() == "tutorial" or not arg_17_1
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
		validation_function = fn_2
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

DLCUtils.append("ingame_hud_components", tbl)

local tbl_2 = {
	{
		name = "disable_ingame_ui",
		validation_function = function (self)
			-- function 18
			return (self:parent():disable_ingame_ui())
		end
	},
	{
		name = "entering_mission",
		validation_function = function (self)
			-- function 19
			local component = self:component("LevelCountdownUI")

			return not component and component:is_enter_game()
		end
	},
	{
		name = "hero_selection_popup",
		validation_function = function (self)
			-- function 20
			return self:parent():get_active_popup("profile_picker")
		end
	},
	{
		name = "mission_vote",
		validation_function = function (self)
			-- function 21
			local component = self:component("MissionVotingUI")

			return not component and component:is_active()
		end
	},
	{
		name = "in_endscreen",
		validation_function = function (self)
			-- function 22
			local parent = self:parent()
			local end_screen_active = parent:end_screen_active()

			return parent.end_of_level_ui ~= nil or end_screen_active
		end
	},
	{
		name = "in_menu",
		validation_function = function (self)
			-- function 23
			local parent = self:parent()
			local menu_active = parent.menu_active
			local current_view = parent.current_view

			return menu_active or current_view ~= nil
		end
	},
	{
		name = "gift_popup",
		validation_function = function (self)
			-- function 24
			local component = self:component("GiftPopupUI")

			return not component and component:active()
		end
	},
	{
		name = "cutscene",
		validation_function = function (arg_25_0)
			-- function 25
			local system = Managers.state.entity:system("cutscene_system")
			local active_camera = system.active_camera

			active_camera = not active_camera and not system.ingame_hud_enabled

			return active_camera
		end
	},
	{
		name = "tab_menu",
		validation_function = function (self)
			-- function 26
			local component = self:component("VersusTabUI")

			return not component and component:is_active()
		end
	},
	{
		name = "in_inn",
		validation_function = function (self)
			-- function 27
			return self:is_in_inn()
		end
	},
	{
		name = "realism",
		validation_function = function (arg_28_0)
			-- function 28
			local game_mode = Managers.state.game_mode

			return not game_mode and game_mode:has_activated_mutator("realism")
		end
	},
	{
		name = "game_mode_disable_hud",
		validation_function = function (arg_29_0)
			-- function 29
			local game_mode = Managers.state.game_mode
			local flag = not game_mode and game_mode:game_mode()

			if not flag then
				-- Nothing
			end

			::label_29_0::

			local game_mode_hud_disabled = flag.game_mode_hud_disabled

			game_mode_hud_disabled = not game_mode_hud_disabled and flag:game_mode_hud_disabled()

			::label_29_1::

			return game_mode_hud_disabled
		end
	},
	{
		name = "spectator",
		validation_function = function (arg_30_0)
			-- function 30
			return Managers.player:local_player():get_party().name == "spectators"
		end
	},
	{
		name = "dead",
		validation_function = function (self)
			-- function 31
			local local_player = Managers.player:local_player()
			local get_side_from_player_unique_id = Managers.state.side:get_side_from_player_unique_id(local_player:unique_id())
			local flag = not get_side_from_player_unique_id and get_side_from_player_unique_id:name() == "heroes"
			local flag_2 = true

			if not flag then
				flag_2 = Managers.state.game_mode:game_mode():player_ready()
			end

			local is_own_player_dead = self:is_own_player_dead()

			is_own_player_dead = not is_own_player_dead and flag_2

			return is_own_player_dead
		end
	},
	{
		name = "alive",
		validation_function = function (arg_32_0)
			-- function 32
			local player_unit = Managers.player:local_player().player_unit
			local player_ready = Managers.state.game_mode:game_mode():player_ready()

			if not player_unit then
				-- Nothing
			end

			::label_32_0::

			local alive = Unit.alive(player_unit)

			alive = not alive and player_ready

			::label_32_1::

			return alive
		end
	},
	{
		name = "ghost_mode",
		validation_function = function (arg_33_0)
			-- function 33
			local local_player = Managers.player:local_player()
			local has_extension = ScriptUnit.has_extension(local_player.unit, "ghost_mode_system")

			return not has_extension and has_extension:is_in_ghost_mode()
		end
	}
}

for i = 1, #tbl do
	require(tbl[i].filename)
end

return {
	components = tbl,
	visibility_groups = tbl_2
}
