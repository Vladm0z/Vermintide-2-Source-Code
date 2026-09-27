-- chunkname: @scripts/ui/hint_ui/hint_templates.lua

local var_0_0 = dofile("scripts/settings/objective_templates_vs")
local HintTemplates = HintTemplates

HintTemplates = HintTemplates or {}
HintTemplates = HintTemplates
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
	condition_function = function (self, arg_1_1, arg_1_2)
		-- function 1
		local current_mechanism_name = Managers.mechanism:current_mechanism_name()
		local game_mode_key = Managers.state.game_mode:game_mode_key()

		if not (current_mechanism_name ~= self.mechanism_name or game_mode_key ~= self.game_mode_key) then
			local player = Managers.player

			player = not player and Managers.player:local_player()

			if not player then
				local get_party = player:get_party()
				local flag = not get_party and Managers.state.side.side_by_party[get_party]

				if not flag then
					local name = flag:name()
					local player_unit = player.player_unit
					local has_extension = ScriptUnit.has_extension(player_unit, "ghost_mode_system")
					local flag_2 = not has_extension and has_extension:is_in_ghost_mode()

					if not (not name and name == self.side) and not flag_2 then
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
	condition_function = function (self, arg_2_1, arg_2_2)
		-- function 2
		local current_mechanism_name = Managers.mechanism:current_mechanism_name()
		local game_mode_key = Managers.state.game_mode:game_mode_key()

		if not (current_mechanism_name ~= self.mechanism_name or game_mode_key ~= self.game_mode_key) then
			local player = Managers.player

			player = not player and Managers.player:local_player()

			if not player then
				local get_party = player:get_party()
				local flag = not get_party and Managers.state.side.side_by_party[get_party]

				if not (not flag and flag:name() ~= self.side) then
					local player_unit = player.player_unit

					if not ALIVE[player_unit] then
						local has_extension = ScriptUnit.has_extension(player_unit, "versus_horde_ability_system")

						if not has_extension then
							local get_ability_charge = has_extension:get_ability_charge(arg_2_2)
							local cooldown = has_extension:cooldown()

							if not (not get_ability_charge and not (cooldown <= get_ability_charge)) then
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
	condition_function = function (self, arg_3_1, arg_3_2)
		-- function 3
		local current_mechanism_name = Managers.mechanism:current_mechanism_name()
		local game_mode_key = Managers.state.game_mode:game_mode_key()

		if not (current_mechanism_name ~= self.mechanism_name or game_mode_key ~= self.game_mode_key) then
			local player = Managers.player

			player = not player and Managers.player:local_player()

			if not player then
				local get_party = player:get_party()
				local flag = not get_party and Managers.state.side.side_by_party[get_party]

				if not (not flag and flag:name() ~= self.side) then
					local player_unit = player.player_unit

					if not ALIVE[player_unit] then
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
	condition_function = function (self, arg_4_1, arg_4_2)
		-- function 4
		local current_mechanism_name = Managers.mechanism:current_mechanism_name()
		local game_mode_key = Managers.state.game_mode:game_mode_key()

		if not (current_mechanism_name ~= self.mechanism_name or game_mode_key ~= self.game_mode_key) then
			local player = Managers.player

			player = not player and Managers.player:local_player()

			if not player then
				local get_party = player:get_party()
				local flag = not get_party and Managers.state.side.side_by_party[get_party]

				if not (not flag and flag:name() ~= self.side) then
					local player_unit = player.player_unit

					if not ALIVE[player_unit] then
						local extension = ScriptUnit.extension(player_unit, "status_system")
						local extension_2 = ScriptUnit.extension(player_unit, "health_system")
						local get_slot_data = ScriptUnit.extension(player_unit, "inventory_system"):get_slot_data("slot_healthkit")
						local flag_2

						flag_2 = not (not extension and extension:is_dead()) and 0 and extension_2:current_health_percent()

						if not (flag_2 <= 0.2) or not get_slot_data then
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
	condition_function = function (self, arg_5_1, arg_5_2)
		-- function 5
		local current_mechanism_name = Managers.mechanism:current_mechanism_name()
		local game_mode_key = Managers.state.game_mode:game_mode_key()

		if not (current_mechanism_name ~= self.mechanism_name or game_mode_key ~= self.game_mode_key) then
			local player = Managers.player

			player = not player and Managers.player:local_player()

			if not player then
				local get_party = player:get_party()
				local flag = not get_party and Managers.state.side.side_by_party[get_party]

				if not (not flag and flag:name() ~= self.side) then
					local player_unit = player.player_unit

					if not ALIVE[player_unit] and not ScriptUnit.extension(player_unit, "inventory_system"):get_slot_data("slot_grenade") then
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
	condition_function = function (self, arg_6_1, arg_6_2)
		-- function 6
		local current_mechanism_name = Managers.mechanism:current_mechanism_name()
		local game_mode_key = Managers.state.game_mode:game_mode_key()

		if not (current_mechanism_name ~= self.mechanism_name or game_mode_key ~= self.game_mode_key) then
			local player = Managers.player

			player = not player and Managers.player:local_player()

			if not player then
				local get_party = player:get_party()
				local flag = not get_party and Managers.state.side.side_by_party[get_party]

				if not (not flag and flag:name() ~= self.side) then
					local player_unit = player.player_unit

					if not ALIVE[player_unit] and not ScriptUnit.extension(player_unit, "status_system"):wounded_and_on_last_wound() then
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
	condition_function = function (self, arg_7_1, arg_7_2)
		-- function 7
		if not Managers.input:is_device_active("gamepad") then
			return false
		end

		local current_mechanism_name = Managers.mechanism:current_mechanism_name()
		local game_mode_key = Managers.state.game_mode:game_mode_key()

		if not ((current_mechanism_name ~= self.mechanism_name or game_mode_key ~= self.game_mode_key or not Managers.chat:chat_is_focused()) and Managers.chat:current_view_and_color() ~= "All") then
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
	condition_function = function (self, arg_8_1, arg_8_2)
		-- function 8
		local current_mechanism_name = Managers.mechanism:current_mechanism_name()
		local game_mode_key = Managers.state.game_mode:game_mode_key()

		if not (current_mechanism_name ~= self.mechanism_name or game_mode_key ~= self.game_mode_key) then
			local player = Managers.player

			player = not player and Managers.player:local_player()

			if not player then
				local get_party = player:get_party()
				local flag = not get_party and Managers.state.side.side_by_party[get_party]

				if not (not flag and flag:name() ~= self.side) then
					local system = Managers.state.entity:system("objective_system")

					if not (not system and not system:is_active() and system:current_objective_type() ~= "objective_capture_point") then
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
	condition_function = function (self, arg_9_1, arg_9_2)
		-- function 9
		local current_mechanism_name = Managers.mechanism:current_mechanism_name()
		local game_mode_key = Managers.state.game_mode:game_mode_key()

		if not (current_mechanism_name ~= self.mechanism_name or game_mode_key ~= self.game_mode_key) then
			local player = Managers.player

			player = not player and Managers.player:local_player()

			if not player then
				local get_party = player:get_party()
				local flag = not get_party and Managers.state.side.side_by_party[get_party]

				if not (not flag and flag:name() ~= self.side) then
					local system = Managers.state.entity:system("objective_system")

					if not (not system and not system:is_active() and system:current_objective_type() ~= "objective_payload") then
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
	condition_function = function (self, arg_10_1, arg_10_2)
		-- function 10
		local current_mechanism_name = Managers.mechanism:current_mechanism_name()
		local game_mode_key = Managers.state.game_mode:game_mode_key()

		if not (current_mechanism_name ~= self.mechanism_name or game_mode_key ~= self.game_mode_key) then
			local player = Managers.player

			player = not player and Managers.player:local_player()

			if not player then
				local get_party = player:get_party()
				local flag = not get_party and Managers.state.side.side_by_party[get_party]

				if not (not flag and flag:name() ~= self.side) then
					local system = Managers.state.entity:system("objective_system")

					if not (not system and not system:is_active() and system:current_objective_type() ~= "objective_safehouse") then
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
	condition_function = function (self, arg_11_1, arg_11_2)
		-- function 11
		local current_mechanism_name = Managers.mechanism:current_mechanism_name()
		local game_mode_key = Managers.state.game_mode:game_mode_key()

		if not (current_mechanism_name ~= self.mechanism_name or game_mode_key ~= self.game_mode_key) then
			local player = Managers.player

			player = not player and Managers.player:local_player()

			if not player then
				local get_party = player:get_party()
				local flag = not get_party and Managers.state.side.side_by_party[get_party]

				if not (not flag and flag:name() ~= self.side) then
					local system = Managers.state.entity:system("objective_system")

					if not (not system and not system:is_active() and system:current_objective_type() ~= "objective_socket") then
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
	condition_function = function (self, arg_12_1, arg_12_2)
		-- function 12
		local current_mechanism_name = Managers.mechanism:current_mechanism_name()
		local game_mode_key = Managers.state.game_mode:game_mode_key()

		if not (current_mechanism_name ~= self.mechanism_name or game_mode_key ~= self.game_mode_key) then
			local player = Managers.player

			player = not player and Managers.player:local_player()

			if not player then
				local get_party = player:get_party()
				local flag = not get_party and Managers.state.side.side_by_party[get_party]

				if not (not flag and flag:name() ~= self.side) then
					local system = Managers.state.entity:system("objective_system")

					if not (not system and not system:is_active() and system:current_objective_type() ~= "objective_target") then
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
	condition_function = function (self, arg_13_1, arg_13_2)
		-- function 13
		local current_mechanism_name = Managers.mechanism:current_mechanism_name()
		local game_mode_key = Managers.state.game_mode:game_mode_key()

		if not (current_mechanism_name ~= self.mechanism_name or game_mode_key ~= self.game_mode_key) then
			local player = Managers.player

			player = not player and Managers.player:local_player()

			if not player then
				local get_party = player:get_party()
				local flag = not get_party and Managers.state.side.side_by_party[get_party]

				if not (not flag and flag:name() ~= self.side) then
					local system = Managers.state.entity:system("objective_system")

					if not (not system and not system:is_active() and system:current_objective_type() ~= "objective_survive") then
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
	condition_function = function (self, arg_14_1, arg_14_2)
		-- function 14
		local current_mechanism_name = Managers.mechanism:current_mechanism_name()
		local game_mode_key = Managers.state.game_mode:game_mode_key()

		if not (current_mechanism_name ~= self.mechanism_name or game_mode_key ~= self.game_mode_key) then
			local player = Managers.player

			player = not player and Managers.player:local_player()

			if not player then
				local get_party = player:get_party()
				local flag = not get_party and Managers.state.side.side_by_party[get_party]

				if not (not flag and flag:name() ~= self.side) then
					local system = Managers.state.entity:system("objective_system")

					if not (not system and not system:is_active() and system:current_objective_type() ~= "objective_interact") then
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
	condition_function = function (self, arg_15_1, arg_15_2)
		-- function 15
		local current_mechanism_name = Managers.mechanism:current_mechanism_name()
		local game_mode_key = Managers.state.game_mode:game_mode_key()

		if not (current_mechanism_name ~= self.mechanism_name or game_mode_key ~= self.game_mode_key) then
			local player = Managers.player

			player = not player and Managers.player:local_player()

			if not player then
				local get_party = player:get_party()
				local flag = not get_party and Managers.state.side.side_by_party[get_party]

				if not (not flag and flag:name() ~= self.side) then
					local system = Managers.state.entity:system("objective_system")

					if not system and not system:is_active() then
						local current_objective_type = system:current_objective_type()
						local flag_2 = system:current_objective_index() == 1

						if not (current_objective_type ~= "objective_reach" or flag_2) then
							return true
						end
					end
				end
			end
		end

		return false
	end
}
