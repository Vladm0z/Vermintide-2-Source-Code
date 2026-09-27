-- chunkname: @scripts/entity_system/systems/status/status_system.lua

require("scripts/unit_extensions/generic/generic_status_extension")

StatusSystem = class(StatusSystem, ExtensionSystemBase)

local tbl = {
	"rpc_status_change_bool",
	"rpc_status_change_int",
	"rpc_status_change_int_and_unit",
	"rpc_set_catapulted",
	"rpc_leap_start",
	"rpc_leap_finished",
	"rpc_set_blocking",
	"rpc_set_charge_blocking",
	"rpc_player_blocked_attack",
	"rpc_set_wounded",
	"rpc_hooked_sync",
	"rpc_hot_join_sync_health_status",
	"rpc_replenish_fatigue",
	"rpc_replenish_fatigue_other_players",
	"rpc_set_stagger",
	"rpc_set_action_data",
	"rpc_set_override_blocking",
	"rpc_set_fatigue_points"
}
local tbl_2 = {
	"GenericStatusExtension"
}

DLCUtils.map_list("status_extensions", function (arg_1_0)
	-- function 1
	tbl_2[#tbl_2 + 1] = require(arg_1_0)
end)

StatusSystem.init = function (self, arg_2_1, arg_2_2)
	-- function 2
	StatusSystem.super.init(self, arg_2_1, arg_2_2, tbl_2)

	local network_event_delegate = arg_2_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))
end

StatusSystem.destroy = function (self)
	-- function 3
	self.network_event_delegate:unregister(self)
end

StatusSystem.rpc_hooked_sync = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local unit = self.unit_storage:unit(arg_4_3)

	if not (not unit and Unit.alive(unit)) then
		return
	end

	local extension = ScriptUnit.extension(unit, "status_system")
	local time = Managers.time:time("game")
	local var_4_3 = NetworkLookup.statuses[arg_4_2]

	if var_4_3 == "pack_master_dropping" then
		extension.release_falling_time = time + arg_4_4
	elseif var_4_3 == "pack_master_unhooked" then
		extension.release_unhook_time_left = time + arg_4_4
	end
end

StatusSystem.rpc_set_action_data = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local unit = self.unit_storage:unit(arg_5_2)

	if not (not unit and Unit.alive(unit)) then
		return
	end

	local extension = ScriptUnit.extension(unit, "status_system")
	local var_5_2 = NetworkLookup.breeds[arg_5_3]
	local var_5_3 = NetworkLookup.bt_action_names[arg_5_4]

	extension:set_breed_action(var_5_2, var_5_3)
end

local tbl_3 = {
	pushed = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7)
		-- function 6
		local time = Managers.time:time("game")

		self:set_pushed(arg_6_3, time)

		return true
	end,
	pounced_down = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7)
		-- function 7
		self:set_pounced_down(arg_7_3, arg_7_6)

		return true
	end,
	dead = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7)
		-- function 8
		self:set_dead(arg_8_3)

		return true
	end,
	knocked_down = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7)
		-- function 9
		self:set_knocked_down(arg_9_3)

		return true
	end,
	revived = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7)
		-- function 10
		self:set_revived(arg_10_3, arg_10_6)

		return true
	end,
	reviving = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7)
		-- function 11
		self:set_reviving(arg_11_3, arg_11_6)

		return true
	end,
	pack_master_pulling = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6, arg_12_7)
		-- function 12
		local set_pack_master, var_12_1, var_12_2 = self:set_pack_master("pack_master_pulling", arg_12_3, arg_12_6)

		return set_pack_master, var_12_1, var_12_2
	end,
	pack_master_dragging = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7)
		-- function 13
		local set_pack_master, var_13_1, var_13_2 = self:set_pack_master("pack_master_dragging", arg_13_3, arg_13_6)

		return set_pack_master, var_13_1, var_13_2
	end,
	pack_master_hoisting = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6, arg_14_7)
		-- function 14
		local set_pack_master, var_14_1, var_14_2 = self:set_pack_master("pack_master_hoisting", arg_14_3, arg_14_6)

		return set_pack_master, var_14_1, var_14_2
	end,
	pack_master_hanging = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7)
		-- function 15
		local set_pack_master, var_15_1, var_15_2 = self:set_pack_master("pack_master_hanging", arg_15_3, arg_15_6)

		return set_pack_master, var_15_1, var_15_2
	end,
	pack_master_dropping = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7)
		-- function 16
		local set_pack_master, var_16_1, var_16_2 = self:set_pack_master("pack_master_dropping", arg_16_3, arg_16_6)

		return set_pack_master, var_16_1, var_16_2
	end,
	pack_master_released = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7)
		-- function 17
		local set_pack_master, var_17_1, var_17_2 = self:set_pack_master("pack_master_released", arg_17_3, arg_17_6)

		return set_pack_master, var_17_1, var_17_2
	end,
	pack_master_unhooked = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7)
		-- function 18
		local set_pack_master, var_18_1, var_18_2 = self:set_pack_master("pack_master_unhooked", arg_18_3, arg_18_6)

		return set_pack_master, var_18_1, var_18_2
	end,
	chaos_corruptor_grabbed = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7)
		-- function 19
		self:set_grabbed_by_corruptor(arg_19_1, arg_19_3, arg_19_6)

		return true
	end,
	chaos_corruptor_dragging = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6, arg_20_7)
		-- function 20
		self:set_grabbed_by_corruptor(arg_20_1, arg_20_3, arg_20_6)

		return true
	end,
	chaos_corruptor_released = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7)
		-- function 21
		self:set_grabbed_by_corruptor(arg_21_1, arg_21_3, arg_21_6)

		return true
	end,
	crouching = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7)
		-- function 22
		self:set_crouching(arg_22_3)

		return true
	end,
	pulled_up = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6, arg_23_7)
		-- function 23
		self:set_pulled_up(arg_23_3, arg_23_6)

		return true
	end,
	ladder_climbing = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6, arg_24_7)
		-- function 24
		local unit_by_index = Level.unit_by_index(arg_24_2, arg_24_7)

		self:set_is_on_ladder(arg_24_3, unit_by_index)

		return true
	end,
	ledge_hanging = function (self, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6, arg_25_7)
		-- function 25
		local unit_by_index = Level.unit_by_index(arg_25_2, arg_25_7)

		self:set_is_ledge_hanging(arg_25_3, unit_by_index)

		return true
	end,
	ready_for_assisted_respawn = function (self, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6, arg_26_7)
		-- function 26
		local unit_by_index = Level.unit_by_index(arg_26_2, arg_26_7)

		Managers.state.game_mode:player_respawned(self.unit)
		self:set_ready_for_assisted_respawn(arg_26_3, unit_by_index)

		return true
	end,
	assisted_respawning = function (self, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6, arg_27_7)
		-- function 27
		self:set_assisted_respawning(arg_27_3, arg_27_6)

		return true
	end,
	respawned = function (self, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6, arg_28_7)
		-- function 28
		self:set_respawned(arg_28_3)

		return true
	end,
	overcharge_exploding = function (self, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6, arg_29_7)
		-- function 29
		self:set_overcharge_exploding(arg_29_3)

		return true
	end,
	dodging = function (self, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5, arg_30_6, arg_30_7)
		-- function 30
		self:set_is_dodging(arg_30_3)

		return true
	end,
	grabbed_by_tentacle = function (self, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5, arg_31_6, arg_31_7)
		-- function 31
		self:set_grabbed_by_tentacle(arg_31_3, arg_31_6)

		local has_extension = ScriptUnit.has_extension(arg_31_6, "ai_supplementary_system")

		if not Unit.alive(arg_31_6) then
			has_extension:set_target_unit(arg_31_4)
		end

		return true
	end,
	grabbed_by_chaos_spawn = function (self, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6, arg_32_7)
		-- function 32
		self:set_grabbed_by_chaos_spawn(arg_32_3, arg_32_6)

		return true
	end,
	in_vortex = function (self, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5, arg_33_6, arg_33_7)
		-- function 33
		self:set_in_vortex(arg_33_3, arg_33_6)

		return true
	end,
	near_vortex = function (self, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5, arg_34_6, arg_34_7)
		-- function 34
		self:set_near_vortex(arg_34_3, arg_34_6)

		return true
	end,
	invisible = function (self, arg_35_1, arg_35_2, arg_35_3, arg_35_4, arg_35_5, arg_35_6, arg_35_7)
		-- function 35
		self:set_invisible(arg_35_3)

		return true
	end,
	in_end_zone = function (self, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6, arg_36_7)
		-- function 36
		self:set_in_end_zone(arg_36_3, arg_36_6)

		return true
	end,
	in_liquid = function (self, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5, arg_37_6, arg_37_7)
		-- function 37
		self:set_in_liquid(arg_37_3, arg_37_6)

		return true
	end,
	charged = function (self, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5, arg_38_6, arg_38_7)
		-- function 38
		local time = Managers.time:time("game")

		self:set_charged(arg_38_3, time)

		return true
	end,
	block_broken = function (self, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6, arg_39_7)
		-- function 39
		local time = Managers.time:time("game")

		self:set_block_broken(arg_39_3, time, arg_39_6)

		return true
	end,
	gutter_runner_leaping = function (self, arg_40_1, arg_40_2, arg_40_3, arg_40_4, arg_40_5, arg_40_6, arg_40_7)
		-- function 40
		self:set_gutter_runner_leaping(arg_40_3)

		return true
	end
}

StatusSystem.rpc_status_change_bool = function (self, arg_41_1, arg_41_2, arg_41_3, arg_41_4, arg_41_5)
	-- function 41
	local unit = self.unit_storage:unit(arg_41_4)

	if not (not unit and Unit.alive(unit)) then
		return
	end

	local unit_2 = self.unit_storage:unit(arg_41_5)
	local extension = ScriptUnit.extension(unit, "status_system")
	local var_41_3 = NetworkLookup.statuses[arg_41_2]
	local current_level = LevelHelper:current_level(self.world)

	fassert(tbl_3[var_41_3], "Unhandled status %s", var_41_3)

	local var_41_5, var_41_6, var_41_7 = tbl_3[var_41_3](extension, var_41_3, current_level, arg_41_3, unit, arg_41_4, unit_2, arg_41_5)

	if not Managers.player.is_server then
		local var_41_8 = CHANNEL_TO_PEER_ID[arg_41_1]

		if not var_41_5 then
			Managers.state.network.network_transmit:send_rpc_clients_except("rpc_status_change_bool", var_41_8, arg_41_2, arg_41_3, arg_41_4, arg_41_5)
		else
			arg_41_5 = self.unit_storage:go_id(var_41_7) or NetworkConstants.invalid_game_object_id

			Managers.state.network.network_transmit:send_rpc("rpc_status_change_bool", var_41_8, arg_41_2, var_41_6, arg_41_4, arg_41_5)
		end
	end
end

StatusSystem.rpc_status_change_int = function (self, arg_42_1, arg_42_2, arg_42_3, arg_42_4)
	-- function 42
	local unit = self.unit_storage:unit(arg_42_4)

	if not (not unit and Unit.alive(unit)) then
		return
	end

	local extension = ScriptUnit.extension(unit, "status_system")
	local var_42_2 = NetworkLookup.statuses[arg_42_2]

	if var_42_2 == "grabbed_by_tentacle" then
		local var_42_3 = NetworkLookup[var_42_2][arg_42_3]

		extension:set_grabbed_by_tentacle_status(var_42_3)
	elseif var_42_2 == "grabbed_by_chaos_spawn" then
		local var_42_4 = NetworkLookup[var_42_2][arg_42_3]

		extension:set_grabbed_by_chaos_spawn_status(var_42_4)
	else
		assert("Unhandled status %s", tostring(var_42_2))
	end

	if not Managers.player.is_server then
		local var_42_5 = CHANNEL_TO_PEER_ID[arg_42_1]

		Managers.state.network.network_transmit:send_rpc_clients_except("rpc_status_change_int", var_42_5, arg_42_2, arg_42_3, arg_42_4)
	end
end

StatusSystem.rpc_status_change_int_and_unit = function (self, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5)
	-- function 43
	local unit = self.unit_storage:unit(arg_43_4)

	if not (not unit and Unit.alive(unit)) then
		return
	end

	local unit_2 = self.unit_storage:unit(arg_43_5)
	local extension = ScriptUnit.extension(unit, "status_system")
	local var_43_3 = NetworkLookup.statuses[arg_43_2]

	if var_43_3 == "overpowered" then
		local flag = arg_43_3 ~= 0
		local flag_2 = not flag and NetworkLookup.overpowered_templates[arg_43_3]

		extension:set_overpowered(flag, not flag and flag_2 and arg_43_3, unit_2)
	else
		assert("Unhandled status %s", tostring(var_43_3))
	end

	if not Managers.player.is_server then
		local var_43_6 = CHANNEL_TO_PEER_ID[arg_43_1]

		Managers.state.network.network_transmit:send_rpc_clients_except("rpc_status_change_int", var_43_6, arg_43_2, arg_43_3, arg_43_4, arg_43_5)
	end
end

StatusSystem.rpc_set_wounded = function (self, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
	-- function 44
	local unit = self.unit_storage:unit(arg_44_2)

	if not (not unit and Unit.alive(unit)) then
		return
	end

	local extension = ScriptUnit.extension(unit, "status_system")
	local var_44_2 = NetworkLookup.set_wounded_reasons[arg_44_4]

	extension:set_wounded(arg_44_3, var_44_2)
end

StatusSystem.rpc_set_catapulted = function (self, arg_45_1, arg_45_2, arg_45_3, arg_45_4)
	-- function 45
	local unit = self.unit_storage:unit(arg_45_2)

	if not (not unit and Unit.alive(unit)) then
		return
	end

	ScriptUnit.extension(unit, "status_system"):set_catapulted(arg_45_3, arg_45_4)

	if Managers.player.is_server or not DEDICATED_SERVER then
		local var_45_1 = CHANNEL_TO_PEER_ID[arg_45_1]

		Managers.state.network.network_transmit:send_rpc_clients_except("rpc_set_catapulted", var_45_1, arg_45_2, arg_45_3, arg_45_4)
	end
end

StatusSystem.rpc_set_override_blocking = function (self, arg_46_1, arg_46_2, arg_46_3)
	-- function 46
	local unit = self.unit_storage:unit(arg_46_2)

	if not (not unit and Unit.alive(unit)) then
		return
	end

	ScriptUnit.extension(unit, "status_system"):set_override_blocking(arg_46_3 or nil)
end

StatusSystem.rpc_leap_start = function (self, arg_47_1, arg_47_2)
	-- function 47
	local unit = self.unit_storage:unit(arg_47_2)

	if not (not unit and Unit.alive(unit)) then
		return
	end

	ScriptUnit.extension(unit, "status_system"):leap_start(unit)
end

StatusSystem.rpc_leap_finished = function (self, arg_48_1, arg_48_2)
	-- function 48
	local unit = self.unit_storage:unit(arg_48_2)

	if not (not unit and Unit.alive(unit)) then
		return
	end

	ScriptUnit.extension(unit, "status_system"):leap_finished(unit)
end

StatusSystem.rpc_set_blocking = function (self, arg_49_1, arg_49_2, arg_49_3)
	-- function 49
	local unit = self.unit_storage:unit(arg_49_2)

	if not (not unit and Unit.alive(unit)) then
		return
	end

	ScriptUnit.extension(unit, "status_system"):set_blocking(arg_49_3)

	if not self.is_server then
		local var_49_1 = CHANNEL_TO_PEER_ID[arg_49_1]

		self.network_transmit:send_rpc_clients_except("rpc_set_blocking", var_49_1, arg_49_2, arg_49_3)
	end
end

StatusSystem.rpc_set_charge_blocking = function (self, arg_50_1, arg_50_2, arg_50_3)
	-- function 50
	local unit = self.unit_storage:unit(arg_50_2)

	if not (not unit and Unit.alive(unit)) then
		return
	end

	ScriptUnit.extension(unit, "status_system"):set_charge_blocking(arg_50_3)

	if not self.is_server then
		local var_50_1 = CHANNEL_TO_PEER_ID[arg_50_1]

		self.network_transmit:send_rpc_clients_except("rpc_set_charge_blocking", var_50_1, arg_50_2, arg_50_3)
	end
end

StatusSystem.rpc_player_blocked_attack = function (self, arg_51_1, arg_51_2, arg_51_3, arg_51_4, arg_51_5, arg_51_6, arg_51_7, arg_51_8)
	-- function 51
	local unit = self.unit_storage:unit(arg_51_2)
	local game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(arg_51_4, arg_51_8)

	if not (not unit and Unit.alive(unit)) then
		return
	end

	local var_51_2 = NetworkLookup.fatigue_types[arg_51_3]

	ScriptUnit.extension(unit, "status_system"):blocked_attack(var_51_2, game_object_or_level_unit, arg_51_5, arg_51_6, arg_51_7)

	if not self.is_server then
		local var_51_3 = CHANNEL_TO_PEER_ID[arg_51_1]

		self.network_transmit:send_rpc_clients_except("rpc_player_blocked_attack", var_51_3, arg_51_2, arg_51_3, arg_51_4, arg_51_5, arg_51_6, arg_51_7, arg_51_8)
	end
end

StatusSystem.rpc_hot_join_sync_health_status = function (self, arg_52_1, arg_52_2, arg_52_3, arg_52_4, arg_52_5)
	-- function 52
	local unit = self.unit_storage:unit(arg_52_2)
	local extension = ScriptUnit.extension(unit, "status_system")

	extension.wounds = arg_52_3

	if not arg_52_4 then
		extension:set_ready_for_assisted_respawn(arg_52_4, self.unit_storage:unit(arg_52_5))
	end
end

StatusSystem.rpc_replenish_fatigue = function (self, arg_53_1, arg_53_2, arg_53_3)
	-- function 53
	print("rpc_replenish_fatigue")

	local unit = self.unit_storage:unit(arg_53_2)
	local var_53_1 = NetworkLookup.fatigue_types[arg_53_3]

	StatusUtils.replenish_stamina_local_players(nil, var_53_1)
end

StatusSystem.rpc_replenish_fatigue_other_players = function (self, arg_54_1, arg_54_2)
	-- function 54
	if not self.is_server then
		local var_54_0 = CHANNEL_TO_PEER_ID[arg_54_1]

		self.network_transmit:send_rpc_clients_except("rpc_replenish_fatigue_other_players", var_54_0, arg_54_2)
	end

	local var_54_1 = NetworkLookup.fatigue_types[arg_54_2]

	StatusUtils.replenish_stamina_local_players(nil, var_54_1)
end

StatusSystem.rpc_set_stagger = function (self, arg_55_1, arg_55_2, arg_55_3, arg_55_4, arg_55_5, arg_55_6, arg_55_7, arg_55_8, arg_55_9)
	-- function 55
	local unit = self.unit_storage:unit(arg_55_2)
	local extension = ScriptUnit.extension(unit, "status_system")

	fassert(extension.set_stagger_values)
	extension:set_stagger_values(arg_55_3, arg_55_4, arg_55_5, arg_55_6, arg_55_7, arg_55_8, arg_55_9, false)
end

StatusSystem.rpc_set_fatigue_points = function (self, arg_56_1, arg_56_2, arg_56_3, arg_56_4)
	-- function 56
	local unit = self.unit_storage:unit(arg_56_2)

	if not unit then
		local flag = true
		local extension = ScriptUnit.extension(unit, "status_system")
		local var_56_3 = NetworkLookup.fatigue_types[arg_56_4]

		extension:set_fatigue_points(arg_56_3, var_56_3, flag)

		if not self.is_server then
			local var_56_4 = CHANNEL_TO_PEER_ID[arg_56_1]

			self.network_transmit:send_rpc_clients_except("rpc_set_fatigue_points", var_56_4, arg_56_2, arg_56_3, arg_56_4)
		end
	end
end
