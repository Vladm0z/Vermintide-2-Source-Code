-- chunkname: @scripts/ui/hint_ui/hint_templates.lua

local var_0_0 = dofile("scripts/settings/objective_templates_vs")

HintTemplates = HintTemplates or {}
HintTemplates.first_time_pactsworn = {
	data = {
		side = "dark_pact",
		title_text = "vs_hint_ghost_mode_title",
		game_mode_key = "versus",
		icon = "objective_ghost_mode",
		body_text = "vs_hint_ghost_mode_body",
		mechanism_name = "versus",
		foot_text = "vs_hint_ghost_mode_foot",
		duration = 20,
		class_name = "HintUIVersusHowToPlay",
		definitions = local_require("scripts/ui/hint_ui/hint_ui_versus_how_to_play_definitions"),
		input_data = {
			input_action = "ghost_mode_exit",
			input_service_name = "Player"
		}
	},
	condition_function = function (arg_1_0, arg_1_1, arg_1_2)
		local var_1_0 = Managers.mechanism:current_mechanism_name()
		local var_1_1 = Managers.state.game_mode:game_mode_key()

		if var_1_0 == arg_1_0.mechanism_name and var_1_1 == arg_1_0.game_mode_key then
			local var_1_2 = Managers.player and Managers.player:local_player()

			if var_1_2 then
				local var_1_3 = var_1_2:get_party()
				local var_1_4 = var_1_3 and Managers.state.side.side_by_party[var_1_3]

				if var_1_4 then
					local var_1_5 = var_1_4:name()
					local var_1_6 = var_1_2.player_unit
					local var_1_7 = ScriptUnit.has_extension(var_1_6, "ghost_mode_system")
					local var_1_8 = var_1_7 and var_1_7:is_in_ghost_mode()

					if var_1_5 and var_1_5 == arg_1_0.side and var_1_8 then
						return true
					end
				end
			end
		end

		return false
	end
}
HintTemplates.horde_ability = {
	data = {
		side = "dark_pact",
		title_text = "vs_hint_horde_ability_title",
		game_mode_key = "versus",
		icon = "objective_horde",
		body_text = "vs_hint_horde_ability_body",
		mechanism_name = "versus",
		foot_text = "vs_hint_horde_ability_foot",
		duration = 20,
		class_name = "HintUIVersusHowToPlay",
		definitions = local_require("scripts/ui/hint_ui/hint_ui_versus_how_to_play_definitions"),
		input_data = {
			input_action = "versus_horde_ability",
			input_service_name = "Player"
		}
	},
	condition_function = function (arg_2_0, arg_2_1, arg_2_2)
		local var_2_0 = Managers.mechanism:current_mechanism_name()
		local var_2_1 = Managers.state.game_mode:game_mode_key()

		if var_2_0 == arg_2_0.mechanism_name and var_2_1 == arg_2_0.game_mode_key then
			local var_2_2 = Managers.player and Managers.player:local_player()

			if var_2_2 then
				local var_2_3 = var_2_2:get_party()
				local var_2_4 = var_2_3 and Managers.state.side.side_by_party[var_2_3]

				if var_2_4 and var_2_4:name() == arg_2_0.side then
					local var_2_5 = var_2_2.player_unit

					if ALIVE[var_2_5] then
						local var_2_6 = ScriptUnit.has_extension(var_2_5, "versus_horde_ability_system")

						if var_2_6 then
							local var_2_7 = var_2_6:get_ability_charge(arg_2_2)
							local var_2_8 = var_2_6:cooldown()

							if var_2_7 and var_2_8 <= var_2_7 then
								return true
							end
						end
					end
				end
			end
		end

		return false
	end
}
HintTemplates.scoring_points = {
	data = {
		side = "heroes",
		title_text = "vs_hint_scoring_title",
		game_mode_key = "versus",
		icon = "objective_points",
		body_text = "vs_hint_scoring_body",
		mechanism_name = "versus",
		foot_text = "vs_hint_scoring_foot",
		duration = 20,
		class_name = "HintUIVersusHowToPlay",
		definitions = local_require("scripts/ui/hint_ui/hint_ui_versus_how_to_play_definitions")
	},
	condition_function = function (arg_3_0, arg_3_1, arg_3_2)
		local var_3_0 = Managers.mechanism:current_mechanism_name()
		local var_3_1 = Managers.state.game_mode:game_mode_key()

		if var_3_0 == arg_3_0.mechanism_name and var_3_1 == arg_3_0.game_mode_key then
			local var_3_2 = Managers.player and Managers.player:local_player()

			if var_3_2 then
				local var_3_3 = var_3_2:get_party()
				local var_3_4 = var_3_3 and Managers.state.side.side_by_party[var_3_3]

				if var_3_4 and var_3_4:name() == arg_3_0.side then
					local var_3_5 = var_3_2.player_unit

					if ALIVE[var_3_5] then
						return true
					end
				end
			end
		end

		return false
	end
}
HintTemplates.block_parry = {
	data = {
		mechanism = "versus",
		title_text = "vs_hint_block_parry_title",
		side = "dark_pact",
		icon = "objective_block",
		body_text = "vs_hint_block_parry_body",
		foot_text = "vs_hint_block_parry_foot",
		duration = 15,
		class_name = "HintUIVersusHowToPlay",
		definitions = local_require("scripts/ui/hint_ui/hint_ui_versus_how_to_play_definitions"),
		input_data = {
			input_action = "action_two",
			input_service_name = "Player"
		}
	}
}
HintTemplates.dodge = {
	data = {
		mechanism = "versus",
		title_text = "vs_hint_dodge_title",
		side = "dark_pact",
		icon = "objective_dodge",
		body_text = "vs_hint_dodge_body",
		foot_text = "vs_hint_dodge_foot",
		duration = 15,
		class_name = "HintUIVersusHowToPlay",
		definitions = local_require("scripts/ui/hint_ui/hint_ui_versus_how_to_play_definitions"),
		input_data = {
			input_action = "dodge_hold",
			input_service_name = "Player"
		}
	}
}
HintTemplates.early_win = {
	data = {
		mechanism = "versus",
		title_text = "vs_hint_early_win_title",
		side = "dark_pact",
		icon = "objective_win",
		body_text = "vs_hint_early_win_body",
		foot_text = "vs_hint_early_win_foot",
		duration = 15,
		class_name = "HintUIVersusHowToPlay",
		definitions = local_require("scripts/ui/hint_ui/hint_ui_versus_how_to_play_definitions"),
		input_data = {
			input_action = "    ",
			input_service_name = "Player"
		}
	}
}
HintTemplates.healing = {
	data = {
		side = "heroes",
		title_text = "vs_hint_healing_title",
		game_mode_key = "versus",
		icon = "objective_heal",
		body_text = "vs_hint_healing_body",
		mechanism_name = "versus",
		foot_text = "vs_hint_healing_foot",
		duration = 15,
		class_name = "HintUIVersusHowToPlay",
		definitions = local_require("scripts/ui/hint_ui/hint_ui_versus_how_to_play_definitions"),
		input_data = {
			input_action = "wield_3",
			input_service_name = "Player"
		}
	},
	condition_function = function (arg_4_0, arg_4_1, arg_4_2)
		local var_4_0 = Managers.mechanism:current_mechanism_name()
		local var_4_1 = Managers.state.game_mode:game_mode_key()

		if var_4_0 == arg_4_0.mechanism_name and var_4_1 == arg_4_0.game_mode_key then
			local var_4_2 = Managers.player and Managers.player:local_player()

			if var_4_2 then
				local var_4_3 = var_4_2:get_party()
				local var_4_4 = var_4_3 and Managers.state.side.side_by_party[var_4_3]

				if var_4_4 and var_4_4:name() == arg_4_0.side then
					local var_4_5 = var_4_2.player_unit

					if ALIVE[var_4_5] then
						local var_4_6 = ScriptUnit.extension(var_4_5, "status_system")
						local var_4_7 = ScriptUnit.extension(var_4_5, "health_system")
						local var_4_8 = ScriptUnit.extension(var_4_5, "inventory_system"):get_slot_data("slot_healthkit")

						if (var_4_6 and var_4_6:is_dead() and 0 or var_4_7:current_health_percent()) <= 0.2 and var_4_8 then
							return true
						end
					end
				end
			end
		end

		return false
	end
}
HintTemplates.bombs = {
	data = {
		side = "heroes",
		title_text = "vs_hint_bombs_title",
		game_mode_key = "versus",
		icon = "objective_bomb",
		body_text = "vs_hint_bombs_body",
		mechanism_name = "versus",
		foot_text = "vs_hint_bombs_foot",
		duration = 15,
		class_name = "HintUIVersusHowToPlay",
		definitions = local_require("scripts/ui/hint_ui/hint_ui_versus_how_to_play_definitions"),
		input_data = {
			input_action = "wield_5",
			input_service_name = "Player"
		}
	},
	condition_function = function (arg_5_0, arg_5_1, arg_5_2)
		local var_5_0 = Managers.mechanism:current_mechanism_name()
		local var_5_1 = Managers.state.game_mode:game_mode_key()

		if var_5_0 == arg_5_0.mechanism_name and var_5_1 == arg_5_0.game_mode_key then
			local var_5_2 = Managers.player and Managers.player:local_player()

			if var_5_2 then
				local var_5_3 = var_5_2:get_party()
				local var_5_4 = var_5_3 and Managers.state.side.side_by_party[var_5_3]

				if var_5_4 and var_5_4:name() == arg_5_0.side then
					local var_5_5 = var_5_2.player_unit

					if ALIVE[var_5_5] and ScriptUnit.extension(var_5_5, "inventory_system"):get_slot_data("slot_grenade") then
						return true
					end
				end
			end
		end

		return false
	end
}
HintTemplates.wounds = {
	data = {
		side = "heroes",
		title_text = "vs_hint_wounds_title",
		game_mode_key = "versus",
		icon = "objective_wound",
		body_text = "vs_hint_wounds_body",
		mechanism_name = "versus",
		foot_text = "vs_hint_wounds_foot",
		duration = 15,
		class_name = "HintUIVersusHowToPlay",
		definitions = local_require("scripts/ui/hint_ui/hint_ui_versus_how_to_play_definitions"),
		input_data = {
			input_action = "versus_horde_ability",
			input_service_name = "Player"
		}
	},
	condition_function = function (arg_6_0, arg_6_1, arg_6_2)
		local var_6_0 = Managers.mechanism:current_mechanism_name()
		local var_6_1 = Managers.state.game_mode:game_mode_key()

		if var_6_0 == arg_6_0.mechanism_name and var_6_1 == arg_6_0.game_mode_key then
			local var_6_2 = Managers.player and Managers.player:local_player()

			if var_6_2 then
				local var_6_3 = var_6_2:get_party()
				local var_6_4 = var_6_3 and Managers.state.side.side_by_party[var_6_3]

				if var_6_4 and var_6_4:name() == arg_6_0.side then
					local var_6_5 = var_6_2.player_unit

					if ALIVE[var_6_5] and ScriptUnit.extension(var_6_5, "status_system"):wounded_and_on_last_wound() then
						return true
					end
				end
			end
		end

		return false
	end
}
HintTemplates.loadouts_01 = {
	data = {
		mechanism = "versus",
		title_text = "vs_hint_loadouts_title",
		side = "dark_pact",
		icon = "objective_loadout",
		body_text = "vs_hint_loadouts_body",
		foot_text = "vs_hint_loadouts_foot",
		duration = 15,
		class_name = "HintUIVersusHowToPlay",
		definitions = local_require("scripts/ui/hint_ui/hint_ui_versus_how_to_play_definitions"),
		input_data = {
			input_action = "versus_horde_ability",
			input_service_name = "Player"
		}
	}
}
HintTemplates.all_chat = {
	data = {
		title_text = "vs_hint_chat_title",
		game_mode_key = "versus",
		icon = "objective_chat",
		body_text = "vs_hint_chat_body",
		mechanism_name = "versus",
		foot_text = "vs_hint_chat_foot",
		duration = 15,
		class_name = "HintUIVersusHowToPlay",
		definitions = local_require("scripts/ui/hint_ui/hint_ui_versus_how_to_play_definitions"),
		input_data = {
			input_action = "activate_chat_input",
			input_service_name = "chat_input"
		}
	},
	condition_function = function (arg_7_0, arg_7_1, arg_7_2)
		if Managers.input:is_device_active("gamepad") then
			return false
		end

		local var_7_0 = Managers.mechanism:current_mechanism_name()
		local var_7_1 = Managers.state.game_mode:game_mode_key()

		if var_7_0 == arg_7_0.mechanism_name and var_7_1 == arg_7_0.game_mode_key and Managers.chat:chat_is_focused() and Managers.chat:current_view_and_color() == "All" then
			return true
		end

		return false
	end
}
HintTemplates.capture_objective = {
	data = {
		side = "heroes",
		title_text = "vs_hint_capture_objective_title",
		game_mode_key = "versus",
		icon = "objective_capture_point",
		body_text = "vs_hint_capture_objective_body",
		mechanism_name = "versus",
		foot_text = "vs_hint_capture_objective_foot",
		duration = 15,
		class_name = "HintUIVersusHowToPlay",
		definitions = local_require("scripts/ui/hint_ui/hint_ui_versus_how_to_play_definitions")
	},
	condition_function = function (arg_8_0, arg_8_1, arg_8_2)
		local var_8_0 = Managers.mechanism:current_mechanism_name()
		local var_8_1 = Managers.state.game_mode:game_mode_key()

		if var_8_0 == arg_8_0.mechanism_name and var_8_1 == arg_8_0.game_mode_key then
			local var_8_2 = Managers.player and Managers.player:local_player()

			if var_8_2 then
				local var_8_3 = var_8_2:get_party()
				local var_8_4 = var_8_3 and Managers.state.side.side_by_party[var_8_3]

				if var_8_4 and var_8_4:name() == arg_8_0.side then
					local var_8_5 = Managers.state.entity:system("objective_system")

					if var_8_5 and var_8_5:is_active() and var_8_5:current_objective_type() == "objective_capture_point" then
						return true
					end
				end
			end
		end

		return false
	end
}
HintTemplates.payload_objective = {
	data = {
		side = "heroes",
		title_text = "vs_hint_payload_objective_title",
		game_mode_key = "versus",
		icon = "objective_payload",
		body_text = "vs_hint_payload_objective_body",
		mechanism_name = "versus",
		foot_text = "vs_hint_payload_objective_foot",
		duration = 15,
		class_name = "HintUIVersusHowToPlay",
		definitions = local_require("scripts/ui/hint_ui/hint_ui_versus_how_to_play_definitions")
	},
	condition_function = function (arg_9_0, arg_9_1, arg_9_2)
		local var_9_0 = Managers.mechanism:current_mechanism_name()
		local var_9_1 = Managers.state.game_mode:game_mode_key()

		if var_9_0 == arg_9_0.mechanism_name and var_9_1 == arg_9_0.game_mode_key then
			local var_9_2 = Managers.player and Managers.player:local_player()

			if var_9_2 then
				local var_9_3 = var_9_2:get_party()
				local var_9_4 = var_9_3 and Managers.state.side.side_by_party[var_9_3]

				if var_9_4 and var_9_4:name() == arg_9_0.side then
					local var_9_5 = Managers.state.entity:system("objective_system")

					if var_9_5 and var_9_5:is_active() and var_9_5:current_objective_type() == "objective_payload" then
						return true
					end
				end
			end
		end

		return false
	end
}
HintTemplates.safe_zone = {
	data = {
		side = "heroes",
		title_text = "vs_hint_safe_zone_title",
		game_mode_key = "versus",
		icon = "objective_safehouse",
		body_text = "vs_hint_safe_zone_body",
		mechanism_name = "versus",
		foot_text = "vs_hint_safe_zone_foot",
		duration = 15,
		class_name = "HintUIVersusHowToPlay",
		definitions = local_require("scripts/ui/hint_ui/hint_ui_versus_how_to_play_definitions")
	},
	condition_function = function (arg_10_0, arg_10_1, arg_10_2)
		local var_10_0 = Managers.mechanism:current_mechanism_name()
		local var_10_1 = Managers.state.game_mode:game_mode_key()

		if var_10_0 == arg_10_0.mechanism_name and var_10_1 == arg_10_0.game_mode_key then
			local var_10_2 = Managers.player and Managers.player:local_player()

			if var_10_2 then
				local var_10_3 = var_10_2:get_party()
				local var_10_4 = var_10_3 and Managers.state.side.side_by_party[var_10_3]

				if var_10_4 and var_10_4:name() == arg_10_0.side then
					local var_10_5 = Managers.state.entity:system("objective_system")

					if var_10_5 and var_10_5:is_active() and var_10_5:current_objective_type() == "objective_safehouse" then
						return true
					end
				end
			end
		end

		return false
	end
}
HintTemplates.socket_objective = {
	data = {
		side = "heroes",
		title_text = "vs_hint_socket_objective_title",
		game_mode_key = "versus",
		icon = "objective_socket",
		body_text = "vs_hint_socket_objective_body",
		mechanism_name = "versus",
		foot_text = "vs_hint_socket_objective_foot",
		duration = 15,
		class_name = "HintUIVersusHowToPlay",
		definitions = local_require("scripts/ui/hint_ui/hint_ui_versus_how_to_play_definitions")
	},
	condition_function = function (arg_11_0, arg_11_1, arg_11_2)
		local var_11_0 = Managers.mechanism:current_mechanism_name()
		local var_11_1 = Managers.state.game_mode:game_mode_key()

		if var_11_0 == arg_11_0.mechanism_name and var_11_1 == arg_11_0.game_mode_key then
			local var_11_2 = Managers.player and Managers.player:local_player()

			if var_11_2 then
				local var_11_3 = var_11_2:get_party()
				local var_11_4 = var_11_3 and Managers.state.side.side_by_party[var_11_3]

				if var_11_4 and var_11_4:name() == arg_11_0.side then
					local var_11_5 = Managers.state.entity:system("objective_system")

					if var_11_5 and var_11_5:is_active() and var_11_5:current_objective_type() == "objective_socket" then
						return true
					end
				end
			end
		end

		return false
	end
}
HintTemplates.target_objective = {
	data = {
		side = "heroes",
		title_text = "vs_hint_target_objective_title",
		game_mode_key = "versus",
		icon = "objective_target",
		body_text = "vs_hint_target_objective_body",
		mechanism_name = "versus",
		foot_text = "vs_hint_target_objective_foot",
		duration = 15,
		class_name = "HintUIVersusHowToPlay",
		definitions = local_require("scripts/ui/hint_ui/hint_ui_versus_how_to_play_definitions")
	},
	condition_function = function (arg_12_0, arg_12_1, arg_12_2)
		local var_12_0 = Managers.mechanism:current_mechanism_name()
		local var_12_1 = Managers.state.game_mode:game_mode_key()

		if var_12_0 == arg_12_0.mechanism_name and var_12_1 == arg_12_0.game_mode_key then
			local var_12_2 = Managers.player and Managers.player:local_player()

			if var_12_2 then
				local var_12_3 = var_12_2:get_party()
				local var_12_4 = var_12_3 and Managers.state.side.side_by_party[var_12_3]

				if var_12_4 and var_12_4:name() == arg_12_0.side then
					local var_12_5 = Managers.state.entity:system("objective_system")

					if var_12_5 and var_12_5:is_active() and var_12_5:current_objective_type() == "objective_target" then
						return true
					end
				end
			end
		end

		return false
	end
}
HintTemplates.survive_event = {
	data = {
		side = "heroes",
		title_text = "vs_hint_survive_event_title",
		game_mode_key = "versus",
		icon = "objective_survive",
		body_text = "vs_hint_survive_event_body",
		mechanism_name = "versus",
		foot_text = "vs_hint_survive_event_foot",
		duration = 15,
		class_name = "HintUIVersusHowToPlay",
		definitions = local_require("scripts/ui/hint_ui/hint_ui_versus_how_to_play_definitions")
	},
	condition_function = function (arg_13_0, arg_13_1, arg_13_2)
		local var_13_0 = Managers.mechanism:current_mechanism_name()
		local var_13_1 = Managers.state.game_mode:game_mode_key()

		if var_13_0 == arg_13_0.mechanism_name and var_13_1 == arg_13_0.game_mode_key then
			local var_13_2 = Managers.player and Managers.player:local_player()

			if var_13_2 then
				local var_13_3 = var_13_2:get_party()
				local var_13_4 = var_13_3 and Managers.state.side.side_by_party[var_13_3]

				if var_13_4 and var_13_4:name() == arg_13_0.side then
					local var_13_5 = Managers.state.entity:system("objective_system")

					if var_13_5 and var_13_5:is_active() and var_13_5:current_objective_type() == "objective_survive" then
						return true
					end
				end
			end
		end

		return false
	end
}
HintTemplates.interact_objective = {
	data = {
		side = "heroes",
		title_text = "vs_hint_interact_objective_title",
		game_mode_key = "versus",
		icon = "objective_interact",
		body_text = "vs_hint_interact_objective_body",
		mechanism_name = "versus",
		foot_text = "vs_hint_interact_objective_foot",
		duration = 15,
		class_name = "HintUIVersusHowToPlay",
		definitions = local_require("scripts/ui/hint_ui/hint_ui_versus_how_to_play_definitions"),
		input_data = {
			input_action = "interact",
			input_service_name = "Player"
		}
	},
	condition_function = function (arg_14_0, arg_14_1, arg_14_2)
		local var_14_0 = Managers.mechanism:current_mechanism_name()
		local var_14_1 = Managers.state.game_mode:game_mode_key()

		if var_14_0 == arg_14_0.mechanism_name and var_14_1 == arg_14_0.game_mode_key then
			local var_14_2 = Managers.player and Managers.player:local_player()

			if var_14_2 then
				local var_14_3 = var_14_2:get_party()
				local var_14_4 = var_14_3 and Managers.state.side.side_by_party[var_14_3]

				if var_14_4 and var_14_4:name() == arg_14_0.side then
					local var_14_5 = Managers.state.entity:system("objective_system")

					if var_14_5 and var_14_5:is_active() and var_14_5:current_objective_type() == "objective_interact" then
						return true
					end
				end
			end
		end

		return false
	end
}
HintTemplates.reach_objective = {
	data = {
		side = "heroes",
		title_text = "vs_hint_reach_objective_title",
		game_mode_key = "versus",
		icon = "objective_reach",
		body_text = "vs_hint_reach_objective_body",
		mechanism_name = "versus",
		foot_text = "vs_hint_reach_objective_foot",
		duration = 15,
		class_name = "HintUIVersusHowToPlay",
		definitions = local_require("scripts/ui/hint_ui/hint_ui_versus_how_to_play_definitions")
	},
	condition_function = function (arg_15_0, arg_15_1, arg_15_2)
		local var_15_0 = Managers.mechanism:current_mechanism_name()
		local var_15_1 = Managers.state.game_mode:game_mode_key()

		if var_15_0 == arg_15_0.mechanism_name and var_15_1 == arg_15_0.game_mode_key then
			local var_15_2 = Managers.player and Managers.player:local_player()

			if var_15_2 then
				local var_15_3 = var_15_2:get_party()
				local var_15_4 = var_15_3 and Managers.state.side.side_by_party[var_15_3]

				if var_15_4 and var_15_4:name() == arg_15_0.side then
					local var_15_5 = Managers.state.entity:system("objective_system")

					if var_15_5 and var_15_5:is_active() then
						local var_15_6 = var_15_5:current_objective_type()
						local var_15_7 = var_15_5:current_objective_index() == 1

						if var_15_6 == "objective_reach" and not var_15_7 then
							return true
						end
					end
				end
			end
		end

		return false
	end
}
