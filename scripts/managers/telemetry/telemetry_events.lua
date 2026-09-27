-- chunkname: @scripts/managers/telemetry/telemetry_events.lua

require("scripts/managers/telemetry/telemetry_settings")
require("scripts/managers/telemetry/telemetry_rpc_listener")
require("scripts/managers/telemetry/telemetry_event")

local remove_empty_values = table.remove_empty_values(TelemetrySettings.source)

TelemetryEvents = class(TelemetryEvents)

TelemetryEvents.init = function (self, arg_1_1)
	-- function 1
	self._manager = arg_1_1
	self.rpc_listener = TelemetryRPCListener:new(self)
	self._subject = {}

	if not script_data.testify then
		local _subject = self._subject
		local machine_id = Application.machine_id

		machine_id = not machine_id and Application.machine_id()
		_subject.machine_id = machine_id
		self._subject.machine_name = script_data.machine_name
	end

	self._session = {
		game = Application.guid()
	}
	self._context = {}

	if not IS_XB1 then
		remove_empty_values.console_type = XboxOne.console_type_string()
	elseif not IS_PS4 then
		local var_1_2 = remove_empty_values
		local flag

		flag = not PS4.is_pro() and "pro" and "not_pro"
		var_1_2.console_type = flag
	end

	self:game_startup()
end

TelemetryEvents.destroy = function (self)
	-- function 2
	self:game_shutdown()
end

TelemetryEvents.game_startup = function (self)
	-- function 3
	local _create_event = self:_create_event("game_startup")

	self._manager:register_event(_create_event)
end

TelemetryEvents.game_shutdown = function (self)
	-- function 4
	local _create_event = self:_create_event("game_shutdown")

	_create_event:set_data({
		time_in_game = Application.time_since_launch()
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.game_started = function (self, arg_5_1)
	-- function 5
	local _create_event = self:_create_event("game_started")
	local tbl = {}

	table.keys(arg_5_1.mutators, tbl)
	table.sort(tbl)
	_create_event:set_data({
		peer_type = arg_5_1.peer_type,
		country_code = arg_5_1.country_code,
		quick_game = arg_5_1.quick_game,
		game_mode = arg_5_1.game_mode,
		level_key = arg_5_1.level_key,
		difficulty = arg_5_1.difficulty,
		mutators = table.concat(tbl, ","),
		realm = arg_5_1.realm
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.versus_round_started = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6)
	-- function 6
	local _create_event = self:_create_event("versus_round_started")

	_create_event:set_data({
		player_id = arg_6_1,
		game_round = arg_6_2,
		match_id = arg_6_3,
		slot_melee = arg_6_4,
		slot_ranged = arg_6_5,
		talents = arg_6_6
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.versus_custom_game_settings = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
	local _create_event = self:_create_event("versus_custom_game_settings")

	_create_event:set_data({
		player_id = arg_7_1,
		match_id = arg_7_2,
		settings = arg_7_3,
		is_default_ruleset = arg_7_4,
		modified_settings = arg_7_5
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.versus_round_ended = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local _create_event = self:_create_event("versus_round_end")

	_create_event:set_data({
		score = arg_8_1,
		game_round = arg_8_2,
		match_id = arg_8_3
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.versus_match_ended = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local _create_event = self:_create_event("versus_match_ended")

	_create_event:set_data({
		match_id = arg_9_1,
		is_draw = arg_9_2,
		winning_team = arg_9_3
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.versus_pactsworn_picking = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7)
	-- function 10
	local _create_event = self:_create_event("versus_pactsworn_picking")

	_create_event:set_data({
		match_id = arg_10_1,
		player_id = arg_10_2,
		career_options = arg_10_3,
		selected_career = arg_10_4,
		career_selection_time_elapsed = arg_10_5,
		platform = arg_10_6,
		build = arg_10_7
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.versus_objective_started = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	local _create_event = self:_create_event("versus_objective_started")

	_create_event:set_data({
		match_id = arg_11_1,
		objective_id = arg_11_2,
		round_id = arg_11_3,
		objective_name = arg_11_4
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.versus_objective_section_completed = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
	-- function 12
	local _create_event = self:_create_event("versus_objective_section_completed")

	_create_event:set_data({
		match_id = arg_12_1,
		objective_id = arg_12_2,
		round_id = arg_12_3,
		objective_name = arg_12_4,
		num_sections_completed = arg_12_5,
		total_num_sections = arg_12_6
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.versus_activated_ability = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	-- function 13
	local _create_event = self:_create_event("versus_activated_ability")

	_create_event:set_data({
		match_id = arg_13_1,
		game_round = arg_13_2,
		player_id = arg_13_3,
		ability_name = arg_13_4
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.weave_activated = function (self, arg_14_1, arg_14_2)
	-- function 14
	local _create_event = self:_create_event("weave_activated")

	_create_event:set_data({
		wind = arg_14_1,
		tier = arg_14_2
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.round_started = function (self)
	-- function 15
	local _create_event = self:_create_event("round_started")

	self._manager:register_event(_create_event)
end

TelemetryEvents.objective_captured = function (self, arg_16_1)
	-- function 16
	local _create_event = self:_create_event("objective_captured")

	_create_event:set_data({
		remaining_time = arg_16_1
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.badge_gained = function (self, arg_17_1)
	-- function 17
	local _create_event = self:_create_event("badge_gained")

	_create_event:set_data({
		badge_name = arg_17_1
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.node_climb = function (self, arg_18_1, arg_18_2)
	-- function 18
	local _create_event = self:_create_event("node_climb")

	_create_event:set_data({
		breed_name = arg_18_1,
		node_position = arg_18_2
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.left_ghost_mode = function (self, arg_19_1, arg_19_2)
	-- function 19
	local _create_event = self:_create_event("left_ghost_mode")

	_create_event:set_data({
		breed_name = arg_19_1,
		position = arg_19_2
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.game_ended = function (self, arg_20_1)
	-- function 20
	local _create_event = self:_create_event("game_ended")

	_create_event:set_data({
		end_reason = arg_20_1
	})
	self._manager:register_event(_create_event)

	self._session.server = nil
end

TelemetryEvents.client_session_id = function (arg_21_0, arg_21_1)
	-- function 21
	arg_21_0._session.client = arg_21_1
end

TelemetryEvents.server_session_id = function (arg_22_0, arg_22_1)
	-- function 22
	arg_22_0._session.server = arg_22_1
end

TelemetryEvents.ai_died = function (self, arg_23_1, arg_23_2, arg_23_3)
	-- function 23
	local _create_event = self:_create_event("ai_died")

	_create_event:set_data({
		id = arg_23_1,
		breed = arg_23_2,
		position = arg_23_3
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.ai_spawned = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	-- function 24
	local _create_event = self:_create_event("ai_spawned")
	local tbl = {}

	if not arg_24_4 then
		for i = 1, #arg_24_4 do
			tbl[arg_24_4[i].name] = true
		end
	end

	_create_event:set_data({
		id = arg_24_1,
		breed = arg_24_2,
		position = arg_24_3,
		enhancements = tbl
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.ai_despawned = function (self, arg_25_1, arg_25_2, arg_25_3)
	-- function 25
	local _create_event = self:_create_event("ai_despawned")

	_create_event:set_data({
		breed = arg_25_1,
		position = arg_25_2,
		reason = arg_25_3 or "unknown"
	})
	self._manager:register_event(_create_event)
end

local function fn()
	-- function 26
	local var_26_0
	local get_local_player_party = Managers.party:get_local_player_party()

	if not get_local_player_party then
		local occupied_slots = get_local_player_party.occupied_slots

		var_26_0 = table.select_array(occupied_slots, function (arg_27_0, arg_27_1)
			-- function 27
			local peer_id = arg_27_1.peer_id
			local local_player_id = arg_27_1.local_player_id

			if not peer_id and not local_player_id then
				return PlayerUtils.unique_player_id(peer_id, local_player_id)
			end
		end)
	end

	return var_26_0 or {}
end

TelemetryEvents.matchmaking_search = function (self, arg_28_1, arg_28_2)
	-- function 28
	if not arg_28_1 and not arg_28_1.remote then
		return
	end

	local _create_event = self:_create_event("matchmaking")

	_create_event:set_data(table.merge({
		state = "search",
		party_peers = fn()
	}, arg_28_2))
	self._manager:register_event(_create_event)
end

TelemetryEvents.matchmaking_search_timeout = function (self, arg_29_1, arg_29_2, arg_29_3)
	-- function 29
	if not arg_29_1 and not arg_29_1.remote then
		return
	end

	local _create_event = self:_create_event("matchmaking")

	_create_event:set_data(table.merge({
		state = "search_timeout",
		time_taken = arg_29_2,
		party_peers = fn()
	}, arg_29_3))
	self._manager:register_event(_create_event)
end

TelemetryEvents.matchmaking_cancelled = function (self, arg_30_1, arg_30_2, arg_30_3)
	-- function 30
	if not arg_30_1 and not arg_30_1.remote then
		return
	end

	local _create_event = self:_create_event("matchmaking")

	_create_event:set_data(table.merge({
		state = "cancelled",
		time_taken = arg_30_2,
		party_peers = fn()
	}, arg_30_3))
	self._manager:register_event(_create_event)
end

TelemetryEvents.matchmaking_hosting = function (self, arg_31_1, arg_31_2, arg_31_3)
	-- function 31
	if not arg_31_1 and not arg_31_1.remote then
		return
	end

	local _create_event = self:_create_event("matchmaking")

	_create_event:set_data(table.merge({
		state = "hosting",
		time_taken = arg_31_2,
		party_peers = fn()
	}, arg_31_3))
	self._manager:register_event(_create_event)
end

TelemetryEvents.matchmaking_starting_game = function (self, arg_32_1, arg_32_2, arg_32_3)
	-- function 32
	if not arg_32_1 and not arg_32_1.remote then
		return
	end

	local _create_event = self:_create_event("matchmaking")

	_create_event:set_data(table.merge({
		state = "starting_game",
		time_taken = arg_32_2,
		party_peers = fn()
	}, arg_32_3))
	self._manager:register_event(_create_event)
end

TelemetryEvents.matchmaking_player_joined = function (self, arg_33_1, arg_33_2, arg_33_3)
	-- function 33
	if not arg_33_1 and not arg_33_1.remote then
		return
	end

	local _create_event = self:_create_event("matchmaking")

	_create_event:set_data(table.merge({
		state = "player_joined",
		time_taken = arg_33_2,
		party_peers = fn()
	}, arg_33_3))
	self._manager:register_event(_create_event)
end

TelemetryEvents.pickup_spawned = function (self, arg_34_1, arg_34_2, arg_34_3)
	-- function 34
	local _create_event = self:_create_event("pickup_spawned")

	_create_event:set_data({
		pickup_name = arg_34_1,
		spawn_type = arg_34_2,
		position = arg_34_3
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.pickup_destroyed = function (self, arg_35_1, arg_35_2, arg_35_3)
	-- function 35
	local _create_event = self:_create_event("pickup_destroyed")

	_create_event:set_data({
		pickup_name = arg_35_1,
		spawn_type = arg_35_2,
		position = arg_35_3
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.player_ammo_depleted = function (self, arg_36_1, arg_36_2, arg_36_3)
	-- function 36
	if not arg_36_1 and not arg_36_1.remote then
		return
	end

	local var_36_0 = TelemetryEvent:new(remove_empty_values, {
		id = arg_36_1:telemetry_id()
	}, "player_ammo_depleted", self._session)

	var_36_0:set_data({
		weapon_name = arg_36_2,
		position = arg_36_3
	})
	self._manager:register_event(var_36_0)
end

TelemetryEvents.player_ammo_refilled = function (self, arg_37_1, arg_37_2, arg_37_3)
	-- function 37
	if not arg_37_1 and not arg_37_1.remote then
		return
	end

	local var_37_0 = TelemetryEvent:new(remove_empty_values, {
		id = arg_37_1:telemetry_id()
	}, "player_ammo_refilled", self._session)

	var_37_0:set_data({
		weapon_name = arg_37_2,
		position = arg_37_3
	})
	self._manager:register_event(var_37_0)
end

TelemetryEvents.player_damaged = function (self, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5)
	-- function 38
	if not arg_38_1 and not arg_38_1.remote then
		return
	end

	local var_38_0 = TelemetryEvent:new(remove_empty_values, {
		id = arg_38_1:telemetry_id()
	}, "player_damaged", self._session)

	var_38_0:set_data({
		damage_type = arg_38_2,
		damage_source = arg_38_3,
		damage_amount = arg_38_4,
		position = arg_38_5
	})
	self._manager:register_event(var_38_0)
end

TelemetryEvents.local_player_damaged_player = function (self, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5)
	-- function 39
	if not arg_39_1 and not arg_39_1.remote then
		return
	end

	local var_39_0 = TelemetryEvent:new(remove_empty_values, {
		id = arg_39_1:telemetry_id()
	}, "local_player_damaged_player", self._session)

	var_39_0:set_data({
		target_breed = arg_39_2,
		damage_amount = arg_39_3,
		attacker_position = arg_39_4,
		target_position = arg_39_5
	})
	self._manager:register_event(var_39_0)
end

TelemetryEvents.player_died = function (self, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
	-- function 40
	if not arg_40_1 and not arg_40_1.remote then
		return
	end

	local var_40_0 = TelemetryEvent:new(remove_empty_values, {
		id = arg_40_1:telemetry_id()
	}, "player_died", self._session)

	var_40_0:set_data({
		damage_type = arg_40_2,
		damage_source = arg_40_3,
		position = arg_40_4
	})
	self._manager:register_event(var_40_0)
end

TelemetryEvents.local_player_killed_player = function (self, arg_41_1, arg_41_2, arg_41_3)
	-- function 41
	if not arg_41_1 and not arg_41_1.remote then
		return
	end

	local var_41_0 = TelemetryEvent:new(remove_empty_values, {
		id = arg_41_1:telemetry_id()
	}, "local_player_killed_player", self._session)

	var_41_0:set_data({
		position = arg_41_2,
		target_position = arg_41_3
	})
	self._manager:register_event(var_41_0)
end

TelemetryEvents.player_killed_ai = function (self, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5, arg_42_6, arg_42_7)
	-- function 42
	if not arg_42_1 and not arg_42_1.remote then
		return
	end

	local var_42_0 = TelemetryEvent:new(remove_empty_values, {
		id = arg_42_1:telemetry_id()
	}, "player_killed_ai", self._session)

	var_42_0:set_data({
		player_position = arg_42_2,
		victim_position = arg_42_3,
		breed = arg_42_4,
		weapon_name = arg_42_5,
		damage_type = arg_42_6,
		hit_zone = arg_42_7
	})
	self._manager:register_event(var_42_0)
end

TelemetryEvents.player_knocked_down = function (self, arg_43_1, arg_43_2, arg_43_3)
	-- function 43
	if not arg_43_1 and not arg_43_1.remote then
		return
	end

	local var_43_0 = TelemetryEvent:new(remove_empty_values, {
		id = arg_43_1:telemetry_id()
	}, "player_knocked_down", self._session)

	var_43_0:set_data({
		damage_type = arg_43_2,
		position = arg_43_3
	})
	self._manager:register_event(var_43_0)
end

TelemetryEvents.player_pickup = function (self, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
	-- function 44
	if not arg_44_1 and not arg_44_1.remote then
		return
	end

	local var_44_0 = TelemetryEvent:new(remove_empty_values, {
		id = arg_44_1:telemetry_id()
	}, "player_pickup", self._session)

	var_44_0:set_data({
		pickup_name = arg_44_2,
		pickup_spawn_type = arg_44_3,
		position = arg_44_4
	})
	self._manager:register_event(var_44_0)
end

TelemetryEvents.player_revived = function (self, arg_45_1, arg_45_2, arg_45_3)
	-- function 45
	if not arg_45_1.remote then
		local var_45_0 = TelemetryEvent:new(remove_empty_values, {
			id = arg_45_1:telemetry_id()
		}, "player_revived_another_player", self._session)

		var_45_0:set_data({
			position = arg_45_3
		})
		self._manager:register_event(var_45_0)
	end

	if not arg_45_2.remote then
		local var_45_1 = TelemetryEvent:new(remove_empty_values, {
			id = arg_45_2:telemetry_id()
		}, "player_revived", self._session)

		var_45_1:set_data({
			position = arg_45_3
		})
		self._manager:register_event(var_45_1)
	end
end

TelemetryEvents.player_spawned = function (self, arg_46_1)
	-- function 46
	if not arg_46_1 and not arg_46_1.remote then
		return
	end

	local extension = ScriptUnit.extension(arg_46_1.player_unit, "career_system")
	local equipment = ScriptUnit.extension(arg_46_1.player_unit, "inventory_system"):equipment()
	local slot_melee = equipment.slots.slot_melee
	local slot_ranged = equipment.slots.slot_ranged
	local get_cosmetic_slot = CosmeticUtils.get_cosmetic_slot(arg_46_1, "slot_melee")
	local get_cosmetic_slot_2 = CosmeticUtils.get_cosmetic_slot(arg_46_1, "slot_ranged")
	local get_cosmetic_slot_3 = CosmeticUtils.get_cosmetic_slot(arg_46_1, "slot_hat")
	local get_cosmetic_slot_4 = CosmeticUtils.get_cosmetic_slot(arg_46_1, "slot_skin")
	local get_cosmetic_slot_5 = CosmeticUtils.get_cosmetic_slot(arg_46_1, "slot_frame")
	local tbl = {}

	if not ScriptUnit.has_extension(arg_46_1.player_unit, "talent_system") then
		tbl = ScriptUnit.extension(arg_46_1.player_unit, "talent_system"):get_talent_names()
	end

	local var_46_10 = TelemetryEvent:new(remove_empty_values, {
		id = arg_46_1:telemetry_id()
	}, "player_spawned", self._session)
	local var_46_11 = var_46_10
	local set_data = var_46_10.set_data
	local tbl_2 = {
		hero = arg_46_1:profile_display_name(),
		career = arg_46_1:career_name(),
		human = arg_46_1.local_player == true,
		power_level = extension:get_career_power_level(),
		slot_melee = not slot_melee and slot_melee.item_data.name
	}
	local skin_name

	if not get_cosmetic_slot then
		skin_name = get_cosmetic_slot.skin_name

		if not skin_name then
			-- Nothing
		end
	end

	skin_name = "default"

	::label_46_0::

	tbl_2.slot_melee_skin = skin_name
	tbl_2.slot_ranged = not slot_ranged and slot_ranged.item_data.name

	local skin_name_2

	if not get_cosmetic_slot_2 then
		skin_name_2 = get_cosmetic_slot_2.skin_name

		if not skin_name_2 then
			-- Nothing
		end
	end

	skin_name_2 = "default"

	::label_46_1::

	tbl_2.slot_ranged_skin = skin_name_2
	tbl_2.slot_hat = not get_cosmetic_slot_3 and get_cosmetic_slot_3.item_name
	tbl_2.slot_skin = not get_cosmetic_slot_4 and get_cosmetic_slot_4.item_name
	tbl_2.slot_frame = not get_cosmetic_slot_5 and get_cosmetic_slot_5.item_name
	tbl_2.talents = tbl

	set_data(var_46_11, tbl_2)
	self._manager:register_event(var_46_10)
end

TelemetryEvents.player_despawned = function (self, arg_47_1)
	-- function 47
	if not arg_47_1 and not arg_47_1.remote then
		return
	end

	local var_47_0 = TelemetryEvent:new(remove_empty_values, {
		id = arg_47_1:telemetry_id()
	}, "player_despawned", self._session)

	self._manager:register_event(var_47_0)
end

TelemetryEvents.player_used_item = function (self, arg_48_1, arg_48_2, arg_48_3)
	-- function 48
	if not arg_48_1 and not arg_48_1.remote then
		return
	end

	local var_48_0 = TelemetryEvent:new(remove_empty_values, {
		id = arg_48_1:telemetry_id()
	}, "player_used_item", self._session)

	var_48_0:set_data({
		item_name = arg_48_2,
		position = arg_48_3
	})
	self._manager:register_event(var_48_0)
end

TelemetryEvents.ping_used = function (self, arg_49_1, arg_49_2, arg_49_3, arg_49_4)
	-- function 49
	if not arg_49_1 and not arg_49_1.remote then
		return
	end

	local var_49_0 = TelemetryEvent:new(remove_empty_values, {
		id = arg_49_1:telemetry_id()
	}, "ping_used", self._session)

	var_49_0:set_data({
		ping_type = arg_49_2,
		ping_target = arg_49_3,
		player_position = arg_49_4
	})
	self._manager:register_event(var_49_0)
end

TelemetryEvents.tech_settings = function (self, arg_50_1, arg_50_2, arg_50_3, arg_50_4)
	-- function 50
	local _create_event = self:_create_event("tech_settings")

	_create_event:set_data({
		resolution = arg_50_1,
		graphics_quality = arg_50_2,
		screen_mode = arg_50_3,
		rendering_backend = arg_50_4
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.tech_system = function (self, arg_51_1, arg_51_2)
	-- function 51
	local _create_event = self:_create_event("tech_system")

	_create_event:set_data({
		system_info = arg_51_1,
		adapter_index = arg_51_2
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.ui_settings = function (self, arg_52_1)
	-- function 52
	local _create_event = self:_create_event("ui_menu_layout")

	_create_event:set_data({
		use_pc_menu_layout = arg_52_1
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.vo_event_played = function (self, arg_53_1, arg_53_2, arg_53_3, arg_53_4)
	-- function 53
	local _create_event = self:_create_event("vo_event_played")

	_create_event:set_data({
		category = arg_53_1,
		dialogue = arg_53_2,
		sound_event = arg_53_3,
		unit_name = arg_53_4
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.terror_event_started = function (self, arg_54_1)
	-- function 54
	local _create_event = self:_create_event("terror_event_started")

	_create_event:set_data({
		event_name = arg_54_1
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.level_progression = function (self, arg_55_1)
	-- function 55
	local _create_event = self:_create_event("level_progression")

	_create_event:set_data({
		percent = arg_55_1
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.memory_statistics = function (self, arg_56_1, arg_56_2, arg_56_3)
	-- function 56
	local _create_event = self:_create_event("memory_statistics")

	_create_event:set_data({
		memory_tree = arg_56_1,
		arg_56_2,
		tag = arg_56_3
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.player_stuck = function (self, arg_57_1, arg_57_2)
	-- function 57
	if not arg_57_1 and not arg_57_1.remote then
		return
	end

	local var_57_0 = TelemetryEvent:new(remove_empty_values, {
		id = arg_57_1:telemetry_id()
	}, "player_stuck", self._session)

	var_57_0:set_data({
		level_key = arg_57_2,
		position = Unit.local_position(arg_57_1.player_unit, 0),
		rotation = Unit.local_rotation(arg_57_1.player_unit, 0)
	})
	self._manager:register_event(var_57_0)
end

TelemetryEvents.fps = function (self, arg_58_1, arg_58_2)
	-- function 58
	local _create_event = self:_create_event("fps")

	_create_event:set_data({
		avg_fps = arg_58_1,
		histogram = arg_58_2
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.fps_at_point = function (self, arg_59_1, arg_59_2, arg_59_3, arg_59_4)
	-- function 59
	local _create_event = self:_create_event("fps_at_point")

	_create_event:set_data({
		point_id = arg_59_1,
		cam_pos = arg_59_2,
		cam_rot = arg_59_3,
		avg_fps = arg_59_4
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.end_of_game_rewards = function (self, arg_60_1)
	-- function 60
	local _create_event = self:_create_event("end_of_game_rewards")

	_create_event:set_data({
		rewards = arg_60_1
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.magic_item_level_upgraded = function (self, arg_61_1, arg_61_2, arg_61_3)
	-- function 61
	local _create_event = self:_create_event("magic_item_level_upgraded")

	_create_event:set_data({
		item_id = arg_61_1,
		essence_cost = arg_61_2,
		new_magic_level = arg_61_3
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.store_opened = function (self)
	-- function 62
	local _create_event = self:_create_event("store_opened")

	self._manager:register_event(_create_event)
end

TelemetryEvents.store_closed = function (self)
	-- function 63
	local _create_event = self:_create_event("store_closed")

	self._manager:register_event(_create_event)
end

TelemetryEvents.store_breadcrumbs_changed = function (self, arg_64_1, arg_64_2)
	-- function 64
	local tbl = {}
	local tbl_2 = {}

	for i, v in ipairs(arg_64_1) do
		tbl[#tbl + 1] = v.content.page_name
		tbl_2[#tbl_2 + 1] = v.content.text
	end

	if not (not arg_64_2 and tbl[#tbl] ~= "item_details") then
		tbl[#tbl] = arg_64_2.product_id
	end

	local _create_event = self:_create_event("store_breadcrumbs_changed")

	_create_event:set_data({
		path = tbl,
		path_localized = tbl_2
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.store_product_purchased = function (self, arg_65_1)
	-- function 65
	local product_item = arg_65_1.product_item

	product_item = product_item or arg_65_1.item

	local str = "SM"
	local flag = not product_item and product_item.regular_prices
	local flag_2 = not product_item and product_item.current_prices

	for k, v in pairs(DLCSettings.store.currency_ui_settings) do
		local var_65_4 = flag[k]
		local var_65_5 = flag_2[k]

		if not var_65_4 and not var_65_5 then
			str = k

			break
		end
	end

	local var_65_6 = flag_2[str]
	local var_65_7 = flag[str]
	local tbl = {
		id = arg_65_1.product_id,
		type = product_item.data.item_type,
		current_price = var_65_6 or var_65_7,
		regular_price = var_65_7,
		currency = str
	}

	self:_store_product_purchased(tbl)
end

local function fn_2(self)
	-- function 66
	local var_66_0 = tonumber(self.item.steam_price)
	local steam_data = self.item.steam_data
	local discount_prices

	if not steam_data.discount_is_active then
		discount_prices = steam_data.discount_prices

		if not discount_prices then
			-- Nothing
		end
	end

	discount_prices = steam_data.regular_prices
	discount_prices = discount_prices or {}

	::label_66_0::

	for k, v in pairs(discount_prices) do
		if var_66_0 == v then
			return k
		end
	end
end

local function fn_3(self)
	-- function 67
	local var_67_0 = fn_2(self)

	return self.item.steam_data.regular_prices[var_67_0]
end

TelemetryEvents.steam_store_product_purchased = function (self, arg_68_1)
	-- function 68
	local steam_data = arg_68_1.item.steam_data
	local tbl = {
		id = arg_68_1.item.id,
		type = arg_68_1.item.data.item_type,
		current_price = tonumber(arg_68_1.item.steam_price)
	}
	local var_68_2

	if not steam_data then
		var_68_2 = fn_2(arg_68_1)

		if not var_68_2 then
			-- Nothing
		end
	end

	var_68_2 = "?"

	::label_68_0::

	tbl.currency = var_68_2

	if not steam_data and not steam_data.discount_is_active then
		tbl.discounted = true
		tbl.regular_price = fn_3(arg_68_1)
	end

	self:_store_product_purchased(tbl)
end

TelemetryEvents._store_product_purchased = function (self, arg_69_1)
	-- function 69
	local _create_event = self:_create_event("store_product_purchased")

	_create_event:set_data(arg_69_1)
	self._manager:register_event(_create_event)
end

TelemetryEvents.store_rewards_claimed = function (self, arg_70_1, arg_70_2)
	-- function 70
	local _create_event = self:_create_event("store_rewards_claimed")
	local var_70_1 = arg_70_1

	if var_70_1.event_type == "personal_time_strike" then
		local total_claims = var_70_1.total_claims

		total_claims = total_claims or 0
		var_70_1.reward_index = total_claims
	else
		var_70_1.reward_index = #var_70_1.rewards + (arg_70_2 or 0)
	end

	_create_event:set_data(var_70_1)
	self._manager:register_event(_create_event)
end

TelemetryEvents.player_joined = function (self, arg_71_1, arg_71_2)
	-- function 71
	local var_71_0 = TelemetryEvent:new(remove_empty_values, {
		id = arg_71_1:telemetry_id()
	}, "player_joined", self._session)

	var_71_0:set_data({
		num_human_players = arg_71_2
	})
	self._manager:register_event(var_71_0)
end

TelemetryEvents.player_left = function (self, arg_72_1, arg_72_2)
	-- function 72
	local var_72_0 = TelemetryEvent:new(remove_empty_values, {
		id = arg_72_1:telemetry_id()
	}, "player_left", self._session)

	var_72_0:set_data({
		num_human_players = arg_72_2
	})
	self._manager:register_event(var_72_0)
end

TelemetryEvents.deus_run_started = function (self, arg_73_1, arg_73_2, arg_73_3, arg_73_4, arg_73_5, arg_73_6, arg_73_7, arg_73_8)
	-- function 73
	local _create_event = self:_create_event("deus_run_started")

	_create_event:set_data({
		run_id = arg_73_1,
		journey_name = arg_73_2,
		run_seed = arg_73_3,
		dominant_god = arg_73_4,
		difficulty = arg_73_5,
		is_weekly_expedition = arg_73_6,
		event_mutators = arg_73_7,
		event_boons = arg_73_8
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.deus_run_ended = function (self, arg_74_1)
	-- function 74
	local _create_event = self:_create_event("deus_run_ended")

	_create_event:set_data(arg_74_1)
	self._manager:register_event(_create_event)
end

TelemetryEvents.deus_level_started = function (self, arg_75_1)
	-- function 75
	local _create_event = self:_create_event("deus_level_started")

	_create_event:set_data(arg_75_1)
	self._manager:register_event(_create_event)
end

TelemetryEvents.deus_level_ended = function (self, arg_76_1)
	-- function 76
	local _create_event = self:_create_event("deus_level_ended")

	_create_event:set_data(arg_76_1)
	self._manager:register_event(_create_event)
end

TelemetryEvents.deus_coins_changed = function (self, arg_77_1, arg_77_2, arg_77_3, arg_77_4)
	-- function 77
	local var_77_0 = TelemetryEvent:new(remove_empty_values, {
		id = arg_77_1
	}, "deus_coins_changed", self._session)

	var_77_0:set_data({
		run_id = arg_77_2,
		player_id = arg_77_1,
		coin_delta = arg_77_3,
		coin_description = arg_77_4
	})
	self._manager:register_event(var_77_0)
end

TelemetryEvents.deus_altar_passed = function (self, arg_78_1)
	-- function 78
	local _create_event = self:_create_event("deus_altar_passed")

	_create_event:set_data(arg_78_1)
	self._manager:register_event(_create_event)
end

TelemetryEvents.cursed_chest_passed = function (self, arg_79_1)
	-- function 79
	local _create_event = self:_create_event("cursed_chest_passed")

	_create_event:set_data(arg_79_1)
	self._manager:register_event(_create_event)
end

TelemetryEvents.store_node_traversed = function (self, arg_80_1)
	-- function 80
	local _create_event = self:_create_event("store_node_traversed")

	_create_event:set_data(arg_80_1)
	self._manager:register_event(_create_event)
end

TelemetryEvents.network_ping = function (self, arg_81_1, arg_81_2, arg_81_3, arg_81_4, arg_81_5, arg_81_6, arg_81_7, arg_81_8, arg_81_9)
	-- function 81
	local _create_event = self:_create_event("network_ping")

	_create_event:set_data({
		avg = arg_81_1,
		std_dev = arg_81_2,
		p99 = arg_81_3,
		p95 = arg_81_4,
		p90 = arg_81_5,
		p75 = arg_81_6,
		p50 = arg_81_7,
		p25 = arg_81_8,
		observations = arg_81_9
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.memory_usage = function (self, arg_82_1, arg_82_2)
	-- function 82
	local _create_event = self:_create_event("memory_usage")

	_create_event:set_data({
		index = arg_82_1,
		memory_usage = arg_82_2
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.chat_message = function (self, arg_83_1)
	-- function 83
	local local_player = Managers.player:local_player()

	if not local_player then
		return
	end

	local var_83_1 = TelemetryEvent:new(remove_empty_values, {
		id = local_player:telemetry_id()
	}, "chat_message", self._session)
	local var_83_2 = var_83_1
	local set_data = var_83_1.set_data
	local tbl = {}
	local count

	if not arg_83_1 then
		count = #arg_83_1

		if not count then
			-- Nothing
		end
	end

	count = 0

	::label_83_0::

	tbl.message_length = count

	set_data(var_83_2, tbl)
	self._manager:register_event(var_83_1)
end

TelemetryEvents.twitch_mode_activated = function (self)
	-- function 84
	local _create_event = self:_create_event("twitch_mode_activated")

	self._manager:register_event(_create_event)
end

TelemetryEvents.twitch_poll_completed = function (self, arg_85_1)
	-- function 85
	local _create_event = self:_create_event("twitch_poll_completed")

	_create_event:set_data({
		type = arg_85_1.vote_type,
		templates = arg_85_1.vote_templates,
		winning_template = arg_85_1.winning_template_name,
		votes_cast = arg_85_1.options
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.breed_position_desync = function (self, arg_86_1, arg_86_2, arg_86_3, arg_86_4)
	-- function 86
	local _create_event = self:_create_event("breed_position_desync")

	_create_event:set_data({
		source_position = arg_86_1,
		destination_position = arg_86_2,
		distance_sq = arg_86_3,
		breed = arg_86_4
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.heartbeat = function (self)
	-- function 87
	local _create_event = self:_create_event("heartbeat")

	self._manager:register_event(_create_event)
end

TelemetryEvents.player_authenticated = function (self, arg_88_1)
	-- function 88
	self._subject.id = arg_88_1

	local _create_event = self:_create_event("player_authenticated")

	self._manager:register_event(_create_event)
end

TelemetryEvents._create_event = function (self, arg_89_1)
	-- function 89
	return TelemetryEvent:new(remove_empty_values, self._subject, arg_89_1, self._session)
end

TelemetryEvents.necromancer_used_command_item = function (self, arg_90_1, arg_90_2)
	-- function 90
	if not (not arg_90_1 and arg_90_1.local_player) then
		return
	end

	local var_90_0 = TelemetryEvent:new(remove_empty_values, {
		id = arg_90_1:telemetry_id()
	}, "necromancer_used_command_item", self._session)

	var_90_0:set_data({
		command_name = arg_90_2
	})
	self._manager:register_event(var_90_0)
end

TelemetryEvents.geheimnisnacht_hard_mode_toggled = function (self, arg_91_1)
	-- function 91
	local _create_event = self:_create_event("geheimnisnacht_hard_mode_toggled")
	local flag

	flag = not arg_91_1 and "activated" and "deactivated"

	_create_event:set_data({
		state = flag
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.loadout_created = function (self, arg_92_1, arg_92_2)
	-- function 92
	local _create_event = self:_create_event("loadout_created")

	_create_event:set_data({
		num_loadouts = arg_92_1,
		max_num_loadouts = arg_92_2
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.loadout_deleted = function (self, arg_93_1, arg_93_2)
	-- function 93
	local _create_event = self:_create_event("loadout_deleted")

	_create_event:set_data({
		num_loadouts = arg_93_1,
		max_num_loadouts = arg_93_2
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.loadout_equipped = function (self)
	-- function 94
	local _create_event = self:_create_event("loadout_equipped")

	self._manager:register_event(_create_event)
end

TelemetryEvents.default_loadout_equipped = function (self)
	-- function 95
	local _create_event = self:_create_event("default_loadout_equipped")

	self._manager:register_event(_create_event)
end

TelemetryEvents.start_versus_experience = function (self, arg_96_1, arg_96_2)
	-- function 96
	local _create_event = self:_create_event("start_versus_experience")

	_create_event:set_data({
		start_experience = arg_96_2,
		start_level = arg_96_1
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.versus_experience_gained = function (self, arg_97_1)
	-- function 97
	local _create_event = self:_create_event("versus_experience_gained")

	_create_event:set_data({
		versus_experience_gained = arg_97_1
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.versus_level_gained = function (self, arg_98_1, arg_98_2)
	-- function 98
	local _create_event = self:_create_event("versus_level_gained")

	_create_event:set_data({
		old_versus_level = arg_98_1,
		new_versus_level = arg_98_2
	})
	self._manager:register_event(_create_event)
end

TelemetryEvents.versus_currency_gained = function (self, arg_99_1)
	-- function 99
	local _create_event = self:_create_event("versus_currency_gained")

	_create_event:set_data({
		currency_gained = arg_99_1
	})
	self._manager:register_event(_create_event)
end
