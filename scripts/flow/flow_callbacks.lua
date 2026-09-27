-- chunkname: @scripts/flow/flow_callbacks.lua

require("scripts/flow/flow_callbacks_ai")
require("scripts/flow/flow_callbacks_enemy")
require("scripts/flow/flow_callbacks_progression")
require("core/wwise/lua/wwise_flow_callbacks")
require("core/volumetrics/lua/volumetrics_flow_callbacks")
require("scripts/helpers/nav_tag_volume_utils")
require("scripts/settings/difficulty_settings")
require("scripts/settings/attachment_node_linking")
DLCUtils.dofile("flow_callbacks")

local flow_return_table = Boot.flow_return_table
local alive = Unit.alive

function flow_callback_show_gdc_intro(arg_1_0)
	-- function 1
	local player_unit = Managers.player:local_player(1).player_unit

	if not player_unit and not alive(player_unit) then
		ScriptUnit.extension(player_unit, "hud_system"):gdc_intro_active(true)
	end
end

function flow_callback_animation_callback(self)
	-- function 2
	Managers.state.event:trigger("animation_callback", self.unit, self.callback, self.param1)
end

function flow_callback_disable_animation_state_machine(self)
	-- function 3
	Unit.disable_animation_state_machine(self.unit)
end

function flow_callback_enable_actor_draw(self)
	-- function 4
	local debug = Managers.state.debug

	if not debug then
		debug:enable_actor_draw(self.actor, self.color)
	end
end

function flow_callback_disable_actor_draw(self)
	-- function 5
	local debug = Managers.state.debug

	if not debug then
		debug.debug:disable_actor_draw(self.actor)
	end
end

function flow_callback_set_start_area(self)
	-- function 6
	local entity = Managers.state.entity

	if not entity then
		entity:system("round_started_system"):set_start_area(self.volume_name)
	end
end

function flow_callback_add_coop_spawn_point(self)
	-- function 7
	local game_mode = Managers.state.game_mode

	if not game_mode then
		game_mode:flow_callback_add_spawn_point(self.unit)
	end
end

function flow_callback_add_game_mode_spawn_point(self)
	-- function 8
	local game_mode = Managers.state.game_mode

	if not game_mode then
		game_mode:flow_callback_add_game_mode_specific_spawn_point(self.unit)
	end
end

function flow_callback_set_checkpoint(self)
	-- function 9
	local spawn = Managers.state.spawn

	if not spawn then
		spawn:flow_callback_set_checkpoint(self.no_spawn_volume, self.safe_zone_volume, self.unit1, self.unit2, self.unit3, self.unit4)
	end
end

function flow_callback_activate_spawning(arg_10_0)
	-- function 10
	return
end

function flow_callback_grimoire_destroyed(arg_11_0)
	-- function 11
	return
end

function flow_callback_tome_destroyed(arg_12_0)
	-- function 12
	return
end

function debug_print_random_values()
	-- function 13
	local main_world = Application.main_world()
	local get_data = World.get_data(main_world, "debug_level_seed")

	for i, v in ipairs(get_data) do
		print(v)
	end
end

local function fn(arg_14_0, arg_14_1, arg_14_2)
	-- function 14
	local flow_callback_context_world = Application.flow_callback_context_world()
	local get_data = World.get_data(flow_callback_context_world, "level_seed")

	fassert(get_data, "Trying to use server seeded random without level seed being set. Is this attempted after level_loaded flow has been finished?")

	local next_random, var_14_3 = Math.next_random(get_data, arg_14_0, arg_14_1)

	World.set_data(flow_callback_context_world, "level_seed", next_random)

	if not script_data.debug_server_seeded_random then
		local get_data_2 = World.get_data(flow_callback_context_world, "debug_level_seed")
		local num = #get_data_2 + 1

		get_data_2[num] = string.format("%4.d:%s rnd: %f old seed: %d new seed: %d", num, tostring(arg_14_2), var_14_3, get_data, next_random)
	end

	return var_14_3
end

function flow_callback_query_server_seeded_random_int(self)
	-- function 15
	local var_15_0 = fn
	local min = self.min

	min = min or 0

	local max = self.max

	max = max or 1

	local var_15_3 = var_15_0(min, max, self.debug_name)

	flow_return_table.value = var_15_3

	return flow_return_table
end

function flow_callback_query_server_seeded_random_float(self)
	-- function 16
	local min = self.min

	min = min or 0

	local max = self.max

	max = max or 1

	local var_16_2 = fn(nil, nil, self.debug_name)

	flow_return_table.value = min + var_16_2 * (max - min)

	return flow_return_table
end

function flow_callback_server_seeded_randomize(self)
	-- function 17
	local max = self.max

	max = max or 8

	local var_17_1 = fn(1, max, self.debug_name)

	return {
		[tostring(var_17_1)] = true
	}
end

function flow_callback_switchcase(self)
	-- function 18
	local tbl = {}
	local str = "out"

	if self.case ~= "" then
		for k, v in pairs(self) do
			if not (k == "case" or self.case ~= v) then
				tbl[str .. string.sub(k, -1)] = true
			end
		end
	end

	return tbl
end

function flow_callback_switchcase_special(self)
	-- function 19
	local tbl = {}
	local str = "out"
	local var_19_2

	if self.case ~= "" then
		for k, v in pairs(self) do
			if k ~= "case" then
				local sub = string.sub(k, -1)

				if self.case == tonumber(sub) then
					tbl[str .. sub] = true
					tbl.out_number = tonumber(sub)
				end
			end
		end
	end

	return tbl
end

function flow_callback_switchcase_range(self)
	-- function 20
	local tbl = {}
	local str = "out"

	if self.case ~= "" then
		for k, v in pairs(self) do
			if k ~= "case" then
				local tbl_2 = {}

				for iter_20_2 in string.gmatch(v, "(%d+)") do
					table.insert(tbl_2, tonumber(iter_20_2))
				end

				if not (tbl_2[1] == nil or tbl_2[2] == nil or not (self.case >= tbl_2[1]) or not (self.case <= tbl_2[2])) then
					tbl[str .. string.sub(k, -1)] = true
				end
			end
		end
	end

	return tbl
end

function flow_callback_switchcase_unit(self)
	-- function 21
	local var_21_0

	if self.case ~= "" then
		for k, v in pairs(self) do
			if not (k == "case" or self.case ~= tonumber(string.sub(k, -1))) then
				var_21_0 = self[k]
			end
		end
	end

	flow_return_table.out_unit = var_21_0

	return flow_return_table
end

function flow_callback_switch_event_to_number_0(arg_22_0)
	-- function 22
	return {
		out_number = 0
	}
end

function flow_callback_switch_event_to_number_1(arg_23_0)
	-- function 23
	return {
		out_number = 1
	}
end

function flow_callback_switch_event_to_number_2(arg_24_0)
	-- function 24
	return {
		out_number = 2
	}
end

function flow_callback_switch_event_to_number_3(arg_25_0)
	-- function 25
	return {
		out_number = 3
	}
end

function flow_callback_switch_event_to_number_4(arg_26_0)
	-- function 26
	return {
		out_number = 4
	}
end

function flow_callback_switch_event_to_number_5(arg_27_0)
	-- function 27
	return {
		out_number = 5
	}
end

function flow_callback_switch_event_to_number_6(arg_28_0)
	-- function 28
	return {
		out_number = 6
	}
end

function flow_callback_relay_trigger(arg_29_0)
	-- function 29
	return {
		out = true
	}
end

function flow_callback_randomize_sequential_numbers(self)
	-- function 30
	local max = self.max
	local tbl = {}

	for i = 1, max do
		tbl[i] = i
	end

	for j = 1, 10 do
		local var_30_2 = fn(1, max, self.debug_name)
		local var_30_3 = fn(1, max, self.debug_name)

		tbl[var_30_2], tbl[var_30_3] = tbl[var_30_3], tbl[var_30_2]
	end

	local tbl_2 = {}

	for k = 1, max do
		tbl_2[tostring(k)] = tbl[k]
	end

	return tbl_2
end

function flow_callback_randomize_strings(arg_31_0)
	-- function 31
	local tbl = {}
	local count = #arg_31_0

	for k, v in pairs(arg_31_0) do
		tbl[#tbl + 1] = v
	end

	local var_31_2 = tbl[math.random(1, #tbl)]

	flow_return_table.out_string = var_31_2

	return flow_return_table
end

function flow_callback_select_output_by_number(self)
	-- function 32
	local num = self.num
	local var_32_1 = self[tostring(num)]

	return {
		["out_" .. tostring(var_32_1)] = true
	}
end

function flow_callback_set_simple_animation_speed(self)
	-- function 33
	Unit.set_simple_animation_speed(self.unit, self.speed, self.group)
end

function flow_callback_get_animation_layer_info(self)
	-- function 34
	flow_return_table.time, flow_return_table.length = Unit.animation_layer_info(self.unit, self.layer)

	return flow_return_table
end

function flow_query_number_of_active_players(arg_35_0)
	-- function 35
	local num = 0
	local side = Managers.state.side

	if not side then
		local PLAYER_UNITS = side:get_side_from_name("heroes").PLAYER_UNITS
		local count = #PLAYER_UNITS

		for i = 1, count do
			local var_35_4 = PLAYER_UNITS[i]

			if not ScriptUnit.extension(var_35_4, "status_system"):is_disabled() then
				num = num + 1
			end
		end
	end

	flow_return_table.value = num

	return flow_return_table
end

function flow_query_number_of_human_players(arg_36_0)
	-- function 36
	local player = Managers.player

	flow_return_table.value = player:num_human_players()

	return flow_return_table
end

function flow_callback_play_music(self)
	-- function 37
	Managers.music:trigger_event(self.event)
end

function flow_callback_idle_camera_dummy_spawned(self)
	-- function 38
	local entity = Managers.state.entity

	if not entity then
		entity:system("camera_system"):idle_camera_dummy_spawned(self.unit)
	end
end

function flow_callback_pickup_gizmo_spawned(self)
	-- function 39
	local entity = Managers.state.entity

	if not entity then
		local system = entity:system("pickup_system")

		if not system then
			system:pickup_gizmo_spawned(self.unit)
		end
	end
end

function flow_callback_weave_item_gizmo_spawned(self)
	-- function 40
	local entity = Managers.state.entity

	if not entity then
		local system = entity:system("objective_item_spawner_system")

		if not system then
			system:item_gizmo_spawned(self.unit)
		end
	end
end

function flow_callback_versus_item_gizmo_spawned(self)
	-- function 41
	if Managers.mechanism:current_mechanism_name() == "versus" then
		local entity = Managers.state.entity

		if not entity then
			local system = entity:system("objective_item_spawner_system")

			if not system then
				system:item_gizmo_spawned(self.unit)
			end
		end
	end
end

function flow_callback_get_current_level_key(arg_42_0)
	-- function 42
	flow_return_table.level_key = Managers.mechanism:get_current_level_keys()

	return flow_return_table
end

function flow_callback_get_deus_post_match(arg_43_0)
	-- function 43
	local game_mechanism = Managers.mechanism:game_mechanism()

	flow_return_table.post_match = game_mechanism:post_match() == true

	return flow_return_table
end

function flow_callback_get_current_current_deus_theme_index(arg_44_0)
	-- function 44
	flow_return_table.theme_index = 1

	local get_current_level_keys = Managers.mechanism:get_current_level_keys()
	local theme = LevelSettings[get_current_level_keys].theme

	for i = 1, #DEUS_THEME_INDEX do
		if DEUS_THEME_INDEX[i] == theme then
			flow_return_table.theme_index = i
		end
	end

	return flow_return_table
end

function flow_callback_boss_gizmo_spawned(self)
	-- function 45
	local conflict = Managers.state.conflict

	if not conflict then
		conflict.level_analysis:boss_gizmo_spawned(self.unit)
	end
end

function flow_callback_generic_ai_node_spawned(self)
	-- function 46
	local conflict = Managers.state.conflict

	if not conflict then
		conflict.level_analysis:generic_ai_node_spawned(self.unit)
	end
end

function flow_callback_respawn_unit_spawned(self)
	-- function 47
	local game_mode = Managers.state.game_mode

	if not game_mode then
		game_mode:respawn_unit_spawned(self.unit)
	end
end

function flow_callback_force_move_dead_players(arg_48_0)
	-- function 48
	local state = Managers.state
	local flag = not state and state.game_mode
	local flag_2 = not flag and flag:game_mode()
	local flag_3 = not flag_2 and flag_2:get_respawn_handler()

	if not flag_3 then
		flag_3:queue_force_move_dead_players()
	end
end

function flow_callback_respawn_gate_unit_spawned(self)
	-- function 49
	local game_mode = Managers.state.game_mode

	if not game_mode then
		game_mode:respawn_gate_unit_spawned(self.unit)
	end
end

function flow_callback_respawn_enabled(self)
	-- function 50
	if not Managers.player.is_server then
		return
	end

	local game_mode = Managers.state.game_mode

	if not game_mode then
		local enabled = self.enabled

		game_mode:set_respawning_enabled(enabled)
	end
end

function flow_callback_force_respawn_dead_players(arg_51_0)
	-- function 51
	if not Managers.player.is_server then
		return
	end

	local game_mode = Managers.state.game_mode

	if not game_mode then
		game_mode:force_respawn_dead_players()
	end
end

function flow_callback_increase_weave_score(self)
	-- function 52
	if not Managers.player.is_server then
		return
	end

	Managers.weave:increase_bar_score(self.amount)
end

function flow_callback_activate_triggered_pickup_spawners(self)
	-- function 53
	local system = Managers.state.entity:system("pickup_system")
	local var_53_1

	if Managers.player.is_server or not LEVEL_EDITOR_TEST then
		var_53_1 = system:activate_triggered_pickup_spawners(self.triggered_spawn_id)
	end

	flow_return_table.spawned_pickup_unit = var_53_1

	return flow_return_table
end

function flow_callback_disable_torch(self)
	-- function 54
	if not Managers.state.game_mode:has_activated_mutator("darkness") then
		return
	end

	local touching_unit = self.touching_unit

	if not Managers.player.is_server then
		Managers.state.entity:system("pickup_system"):disable_teleporting_pickups()
	end

	if not alive(touching_unit) then
		return
	end

	local has_extension = ScriptUnit.has_extension(touching_unit, "inventory_system")

	if not has_extension then
		return
	end

	local get_wielded_slot_name = has_extension:get_wielded_slot_name()
	local get_slot_data = has_extension:get_slot_data(get_wielded_slot_name)

	if not get_slot_data then
		local item_data = get_slot_data.item_data

		if (not item_data and item_data.name) == "torch" then
			CharacterStateHelper.stop_weapon_actions(has_extension, "wield")
			has_extension:destroy_slot("slot_level_event", true)
			has_extension:wield("slot_melee")
		end
	end
end

function flow_wield_slot(self)
	-- function 55
	local unit = self.unit
	local slot_name = self.slot_name
	local has_extension = ScriptUnit.has_extension(unit, "inventory_system")

	if not has_extension then
		has_extension:wield(slot_name)
	end
end

function flow_query_wielded_weapon(self)
	-- function 56
	local null_reference = Unit.null_reference()
	local player_unit = self.player_unit
	local var_56_2

	if not alive(player_unit) then
		flow_return_table.righthandweapon3p = null_reference
		flow_return_table.righthandammo3p = null_reference
		flow_return_table.righthandweapon = null_reference
		flow_return_table.righthandammo1p = null_reference
		flow_return_table.lefthandweapon3p = null_reference
		flow_return_table.lefthandammo3p = null_reference
		flow_return_table.lefthandweapon = null_reference
		flow_return_table.lefthandammo1p = null_reference
		flow_return_table.aliverighthandammo1p = null_reference
		flow_return_table.alivelefthandammo1p = null_reference

		return flow_return_table
	end

	local has_extension = ScriptUnit.has_extension(player_unit, "inventory_system")

	if not has_extension then
		var_56_2 = has_extension:equipment()
	else
		var_56_2 = Unit.get_data(player_unit, "equipment")
	end

	local right_hand_wielded_unit_3p = var_56_2.right_hand_wielded_unit_3p
	local right_hand_ammo_unit_3p = var_56_2.right_hand_ammo_unit_3p
	local right_hand_wielded_unit = var_56_2.right_hand_wielded_unit
	local right_hand_ammo_unit_1p = var_56_2.right_hand_ammo_unit_1p
	local left_hand_wielded_unit_3p = var_56_2.left_hand_wielded_unit_3p
	local left_hand_ammo_unit_3p = var_56_2.left_hand_ammo_unit_3p
	local left_hand_wielded_unit = var_56_2.left_hand_wielded_unit
	local left_hand_ammo_unit_1p = var_56_2.left_hand_ammo_unit_1p

	flow_return_table.righthandweapon3p = right_hand_wielded_unit_3p or null_reference
	flow_return_table.righthandammo3p = right_hand_ammo_unit_3p or null_reference
	flow_return_table.righthandweapon = right_hand_wielded_unit or null_reference
	flow_return_table.righthandammo1p = right_hand_ammo_unit_1p or null_reference
	flow_return_table.lefthandweapon3p = left_hand_wielded_unit_3p or null_reference
	flow_return_table.lefthandammo3p = left_hand_ammo_unit_3p or null_reference
	flow_return_table.lefthandweapon = left_hand_wielded_unit or null_reference
	flow_return_table.lefthandammo1p = left_hand_ammo_unit_1p or null_reference

	if not right_hand_ammo_unit_1p and not Unit.alive(right_hand_ammo_unit_1p) then
		flow_return_table.aliverighthandammo1p = true
	else
		flow_return_table.aliverighthandammo1p = false
	end

	if not left_hand_ammo_unit_1p and not Unit.alive(left_hand_ammo_unit_1p) then
		flow_return_table.alivelefthandammo1p = true
	else
		flow_return_table.alivelefthandammo1p = false
	end

	return flow_return_table
end

function flow_query_ai_wielded_weapons(self)
	-- function 57
	local ai_unit = self.ai_unit
	local has_extension = ScriptUnit.has_extension(ai_unit, "ai_inventory_system")

	if not has_extension then
		flow_return_table.weapon_1 = Unit.null_reference()
		flow_return_table.weapon_2 = Unit.null_reference()

		return flow_return_table
	end

	local inventory_item_units = has_extension.inventory_item_units

	for i = 1, 2 do
		local var_57_3 = flow_return_table
		local str = "weapon" .. i
		local var_57_5 = inventory_item_units[i]

		var_57_5 = var_57_5 or Unit.null_reference()
		var_57_3[str] = var_57_5
	end

	return flow_return_table
end

function flow_query_wielded_weapon_rarity(arg_58_0)
	-- function 58
	flow_return_table.rarity = ""

	local local_player = Managers.player:local_player()

	if not local_player then
		return flow_return_table
	end

	local player_unit = local_player.player_unit

	if not alive(player_unit) then
		return flow_return_table
	end

	local has_extension = ScriptUnit.has_extension(player_unit, "inventory_system")

	if not has_extension then
		return flow_return_table
	end

	local get_wielded_slot_data = has_extension:get_wielded_slot_data()

	if not get_wielded_slot_data then
		return flow_return_table
	end

	local backend_id = get_wielded_slot_data.item_data.backend_id

	if not backend_id then
		return flow_return_table
	end

	local get_item_from_id = Managers.backend:get_interface("items"):get_item_from_id(backend_id)

	if not get_item_from_id then
		return flow_return_table
	end

	local rarity = get_item_from_id.rarity

	flow_return_table.rarity = rarity or ""

	return flow_return_table
end

function flow_show_1p_ammo(self)
	-- function 59
	local local_player = Managers.player:local_player()

	if not local_player then
		return
	end

	local player_unit = local_player.player_unit

	if not alive(player_unit) then
		return
	end

	local has_extension = ScriptUnit.has_extension(player_unit, "first_person_system")

	if not has_extension then
		return
	end

	local show = self.show

	has_extension:show_first_person_ammo(show)
end

function flow_force_use_pickup_for_all_players(self)
	-- function 60
	if not Managers.player.is_server then
		return
	end

	local pickup_name = self.pickup_name
	local var_60_1 = NetworkLookup.pickup_names[pickup_name]

	Managers.state.network.network_transmit:send_rpc_server("rpc_force_use_pickup", var_60_1)
end

function flow_camera_shake(self)
	-- function 61
	DamageUtils.camera_shake_by_distance(self.shake_name, Managers.time:time("game"), self.player_unit, self.shake_unit, self.near_distance, self.far_distance, self.near_shake_scale, self.far_shake_scale)
end

function flow_register_unit_extensions(self)
	-- function 62
	local unit = self.unit
	local get_data = Unit.get_data(unit, "unit_template")

	fassert(get_data, "Missing unit_template!")

	local main_world = Application.main_world()
	local tbl = {
		navgraph_system = {
			nav_world = GLOBAL_AI_NAVWORLD
		}
	}

	Managers.state.unit_spawner:create_unit_extensions(main_world, unit, get_data, tbl)
end

function flow_add_unit_extension(self)
	-- function 63
	local unit = self.unit
	local extension = self.extension

	fassert(extension, "Missing extension")

	local num = 0

	while not Unit.has_data(unit, "extensions", num) do
		num = num + 1
	end

	Unit.set_data(unit, "extensions", num, extension)
end

function flow_callback_debug_print_unit_actor(self)
	-- function 64
	print("FLOW DEBUG: Unit: ", tostring(self.unit), "Actor: ", tostring(self.actor))
end

function flow_callback_trigger_event(self)
	-- function 65
	Unit.flow_event(self.unit, self.event)
end

function flow_callback_play_screen_space_blood(self)
	-- function 66
	local effect = self.effect

	Managers.state.blood:play_screen_space_blood(effect, Vector3.zero())
end

function flow_callback_play_network_synched_particle_effect(self)
	-- function 67
	local effect = self.effect
	local unit = self.unit
	local object = self.object
	local offset = self.offset

	offset = offset or Vector3(0, 0, 0)

	local rotation_offset = self.rotation_offset

	rotation_offset = rotation_offset or Quaternion.identity()

	local linked = self.linked

	linked = linked or false

	local network = Managers.state.network
	local game = network:game()
	local flag = not unit and not linked and network:unit_game_object_id(unit)

	fassert(game, "[flow_callback_play_network_synched_particle_effect] Trying to spawn effect with no network game running.")
	fassert(not unit and not linked and flag, "[flow_callback_play_network_synched_particle_effect] Trying to spawn effect linked to unit not network_synched.")
	fassert(unit or not object, "[flow_callback_play_network_synched_particle_effect] Trying to spawn effect at object in unit without defining unit.")

	local node

	if not unit and not object then
		node = Unit.node(unit, object)

		if not node then
			-- Nothing
		end
	end

	node = 0

	::label_67_0::

	Managers.state.event:trigger("event_play_particle_effect", effect, unit, node, offset, rotation_offset, linked)

	if not (not unit and flag) then
		local world_pose = Unit.world_pose(unit, node)
		local from_quaternion_position = Matrix4x4.from_quaternion_position(rotation_offset, offset)
		local multiply = Matrix4x4.multiply(from_quaternion_position, world_pose)

		offset = Matrix4x4.translation(multiply)
		rotation_offset = Matrix4x4.rotation(multiply)
	end

	if not Managers.player.is_server then
		network.network_transmit:send_rpc_clients("rpc_play_particle_effect", NetworkLookup.effects[effect], flag or 0, node, offset, rotation_offset, linked)
	else
		network.network_transmit:send_rpc_server("rpc_play_particle_effect", NetworkLookup.effects[effect], flag or 0, node, offset, rotation_offset, linked)
	end
end

function flow_callback_output_debug_screen_text(arg_68_0)
	-- function 68
	return
end

function flow_callback_debug_crash_game(self)
	-- function 69
	if not Application.crash then
		local type = self.type

		type = type or "access_violation"

		Application.crash(type)
	end
end

function flow_callback_debug_draw_line(self)
	-- function 70
	local QuickDrawerStay

	if not self.stay then
		QuickDrawerStay = QuickDrawerStay

		if not QuickDrawerStay then
			-- Nothing
		end
	end

	QuickDrawerStay = QuickDrawer

	::label_70_0::

	local from = self.from
	local to = self.to
	local color = self.color

	QuickDrawerStay:line(from, to, color)
end

function flow_callback_debug_draw_vector(self)
	-- function 71
	local QuickDrawerStay

	if not self.stay then
		QuickDrawerStay = QuickDrawerStay

		if not QuickDrawerStay then
			-- Nothing
		end
	end

	QuickDrawerStay = QuickDrawer

	::label_71_0::

	local vector = self.vector
	local color = self.color

	QuickDrawerStay:vector(vector, color)
end

function flow_callback_debug_draw_sphere(self)
	-- function 72
	local QuickDrawerStay

	if not self.stay then
		QuickDrawerStay = QuickDrawerStay

		if not QuickDrawerStay then
			-- Nothing
		end
	end

	QuickDrawerStay = QuickDrawer

	::label_72_0::

	local center = self.center
	local radius = self.radius
	local color = self.color
	local segments = self.segments
	local parts = self.parts

	QuickDrawerStay:sphere(center, radius, color, segments, parts)
end

function flow_callback_debug_draw_capsule(self)
	-- function 73
	local QuickDrawerStay

	if not self.stay then
		QuickDrawerStay = QuickDrawerStay

		if not QuickDrawerStay then
			-- Nothing
		end
	end

	QuickDrawerStay = QuickDrawer

	::label_73_0::

	local from = self.from
	local to = self.to
	local radius = self.radius
	local color = self.color

	QuickDrawerStay:capsule(from, to, radius, color)
end

function flow_callback_debug_draw_box(self)
	-- function 74
	local QuickDrawerStay

	if not self.stay then
		QuickDrawerStay = QuickDrawerStay

		if not QuickDrawerStay then
			-- Nothing
		end
	end

	QuickDrawerStay = QuickDrawer

	::label_74_0::

	local position = self.position
	local rotation = self.rotation
	local extents = self.extents
	local color = self.color
	local from_quaternion_position = Matrix4x4.from_quaternion_position(rotation, position)

	QuickDrawerStay:box(from_quaternion_position, extents, color)
end

function flow_callback_debug_draw_circle(self)
	-- function 75
	local QuickDrawerStay

	if not self.stay then
		QuickDrawerStay = QuickDrawerStay

		if not QuickDrawerStay then
			-- Nothing
		end
	end

	QuickDrawerStay = QuickDrawer

	::label_75_0::

	local center = self.center
	local radius = self.radius
	local normal = self.normal
	local color = self.color
	local segments = self.segments

	QuickDrawerStay:circle(center, radius, normal, color, segments)
end

function flow_callback_reload_level(arg_76_0)
	-- function 76
	if not Managers.player.is_server then
		Managers.state.game_mode:retry_level()
	end
end

function flow_callback_complete_level(arg_77_0)
	-- function 77
	if not Managers.player.is_server then
		print("Level flags level completed.")
		Managers.state.game_mode:complete_level()
	end
end

function flow_callback_fail_level(arg_78_0)
	-- function 78
	if not Managers.player.is_server then
		Managers.state.game_mode:fail_level()
	end
end

function flow_callback_menu_camera_dummy_spawned(self)
	-- function 79
	Managers.state.event:trigger("menu_camera_dummy_spawned", self.camera_name, self.unit)
end

function flow_callback_menu_alignment_dummy_spawned(self)
	-- function 80
	Managers.state.event:trigger("menu_alignment_dummy_spawned", self.alignment_name, self.unit)
end

function flow_callback_block_profile_menu_accept_button(self)
	-- function 81
	local unit = self.unit
	local player_unit = Managers.player:players()[Network.peer_id()].player_unit

	if not (not alive(player_unit) and player_unit ~= unit) then
		global_profile_view:block_accept_button(true)
	end
end

function flow_callback_unblock_profile_menu_accept_button(self)
	-- function 82
	local unit = self.unit
	local player_unit = Managers.player:players()[Network.peer_id()].player_unit

	if not (not alive(player_unit) and player_unit ~= unit) then
		global_profile_view:block_accept_button(false)
	end
end

function flow_callback_event_enable_level_select(arg_83_0)
	-- function 83
	Managers.state.event:trigger("event_enable_level_select")
end

function flow_callback_set_actor_enabled(self)
	-- function 84
	local unit = self.unit

	fassert(unit, "Set Actor Enabled flow node is missing unit")

	local actor = self.actor

	actor = actor or Unit.actor(unit, self.actor_name)

	local fassert = fassert
	local var_84_3 = actor
	local str = "Set Actor Enabled flow node referring to unit %s is missing actor %s"
	local var_84_5 = tostring(unit)
	local tostring = tostring
	local actor_2 = self.actor

	actor_2 = actor_2 or self.actor_name

	fassert(var_84_3, str, var_84_5, tostring(actor_2))
	Actor.set_collision_enabled(actor, self.enabled)
	Actor.set_scene_query_enabled(actor, self.enabled)
end

function flow_callback_set_actor_kinematic(self)
	-- function 85
	local unit = self.unit

	fassert(unit, "Set Actor Kinematic flow node is missing unit")

	local actor = self.actor

	actor = actor or Unit.actor(unit, self.actor_name)

	local fassert = fassert
	local var_85_3 = actor
	local str = "Set Actor Kinematic flow node referring to unit %s is missing actor %s"
	local var_85_5 = tostring(unit)
	local tostring = tostring
	local actor_2 = self.actor

	actor_2 = actor_2 or self.actor_name

	fassert(var_85_3, str, var_85_5, tostring(actor_2))
	Actor.set_kinematic(actor, self.enabled)
end

function flow_callback_spawn_actor(self)
	-- function 86
	local unit = self.unit

	fassert(unit, "Spawn Actor flow node is missing unit")

	local actor_name = self.actor_name

	Unit.create_actor(unit, actor_name)
end

function flow_callback_destroy_actor(self)
	-- function 87
	local unit = self.unit

	fassert(unit, "Destroy Actor flow node is missing unit")

	local actor_name = self.actor_name

	Unit.destroy_actor(unit, actor_name)
end

function flow_callback_set_actor_initial_velocity(self)
	-- function 88
	local unit = self.unit

	fassert(unit, "Set actor initial velocity has no unit")
	Unit.apply_initial_actor_velocities(unit, true)
end

function flow_callback_set_unit_material_variation(self)
	-- function 89
	local unit = self.unit
	local material_variation = self.material_variation

	Unit.set_material_variation(unit, material_variation)
end

function flow_callback_setup_profiling_level_step_1()
	-- function 90
	local pressed = Mouse.pressed

	Mouse.pressed = function (arg_91_0)
		-- function 91
		if arg_91_0 == 0 then
			Mouse.pressed = pressed

			return true
		else
			return false
		end
	end
end

function flow_callback_setup_profiling_level_step_2()
	-- function 92
	local pressed = Keyboard.pressed

	Keyboard.pressed = function (arg_93_0)
		-- function 93
		if arg_93_0 == 120 then
			Keyboard.pressed = pressed

			return true
		else
			return false
		end
	end
end

function flow_callback_setup_profiling_level_step_3()
	-- function 94
	local _cameras = Managers.state.entity:system("cutscene_system")._cameras
	local var_94_1

	for k, v in pairs(_cameras) do
		if k == "profiling_camera" then
			var_94_1 = v
		end
	end

	local _unit = var_94_1._unit
	local world_pose = Unit.world_pose(_unit, 0)
	local main_world = Application.main_world()
	local name = ScriptWorld.name(main_world)
	local global_free_flight_viewport = ScriptWorld.global_free_flight_viewport(main_world, name)
	local camera = ScriptViewport.camera(global_free_flight_viewport)

	ScriptCamera.set_local_pose(camera, world_pose)
	Managers.state.event:trigger("force_close_ingame_menu")
end

function flow_callback_play_footstep_surface_material_effects(self)
	-- function 95
	local flow_cb_play_footstep_surface_material_effects = EffectHelper.flow_cb_play_footstep_surface_material_effects
	local effect_name = self.effect_name
	local unit = self.unit
	local object = self.object
	local foot_direction = self.foot_direction
	local use_occlusion = self.use_occlusion

	use_occlusion = use_occlusion or false

	flow_cb_play_footstep_surface_material_effects(effect_name, unit, object, foot_direction, use_occlusion)
end

function flow_callback_play_surface_material_effect(self)
	-- function 96
	local hit_unit = self.hit_unit
	local var_96_1
	local range = self.range
	local offset = self.offset
	local normal = self.normal
	local look = Quaternion.look(self.normal, Vector3.up())

	EffectHelper.flow_cb_play_surface_material_effect(self.effect_name, hit_unit, self.position, look, normal, var_96_1, self.husk, offset, range)
end

function flow_callback_play_move_particle(self)
	-- function 97
	local particle_id = self.particle_id
	local position = self.position
	local flow_callback_context_world = Application.flow_callback_context_world()

	World.move_particles(flow_callback_context_world, particle_id, position)
end

function flow_callback_play_voice(self)
	-- function 98
	local playing_unit = self.playing_unit
	local event_name = self.event_name
	local use_occlusion = self.use_occlusion

	use_occlusion = use_occlusion or false

	local has_extension_input = ScriptUnit.has_extension_input(playing_unit, "dialogue_system")

	if not has_extension_input then
		has_extension_input:play_voice(event_name, use_occlusion)
	end
end

function flow_callback_foot_step(self)
	-- function 99
	local unit = self.unit
end

function flow_callback_is_local_player(self)
	-- function 100
	local unit = self.unit
	local player_unit = Managers.player:players()[1].player_unit

	if not alive(player_unit) then
		if unit == player_unit then
			flow_return_table.is_player = true
			flow_return_table.is_not_player = false
		else
			flow_return_table.is_player = false
			flow_return_table.is_not_player = true
		end
	else
		flow_return_table.is_player = false
		flow_return_table.is_not_player = true
	end

	return flow_return_table
end

function flow_callback_get_unit_type(self)
	-- function 101
	local unit = self.unit
	local get_data = Unit.get_data(unit, "breed")
	local get_data_2 = Unit.get_data(unit, "bot")

	if get_data or not get_data_2 then
		flow_return_table.is_local_player = false
		flow_return_table.is_remote_player = false
		flow_return_table.is_ai = true
		flow_return_table.is_environment = false
	else
		local owner = Managers.player:owner(unit)

		if owner ~= nil then
			if not owner.remote then
				flow_return_table.is_local_player = true
				flow_return_table.is_remote_player = false
				flow_return_table.is_ai = false
				flow_return_table.is_environment = false
			else
				flow_return_table.is_local_player = false
				flow_return_table.is_remote_player = true
				flow_return_table.is_ai = false
				flow_return_table.is_environment = false
			end
		else
			flow_return_table.is_local_player = false
			flow_return_table.is_remote_player = false
			flow_return_table.is_ai = false
			flow_return_table.is_environment = true
		end
	end

	return flow_return_table
end

function flow_callback_trigger_sound(self)
	-- function 102
	local var_102_0

	if not self.world_name then
		local world = Managers.world:world(self.world_name)

		var_102_0 = Managers.world:wwise_world(world)
	else
		local main_world = Application.main_world()

		var_102_0 = Managers.world:wwise_world(main_world)
	end

	if not self.unit then
		if not self.actor then
			WwiseWorld.trigger_event(var_102_0, self.event, self.use_occlusion, self.unit, Unit.actor(self.unit, self.actor))
		else
			WwiseWorld.trigger_event(var_102_0, self.event, self.use_occlusion, self.unit)
		end
	elseif not self.position then
		WwiseWorld.trigger_event(var_102_0, self.event, self.use_occlusion, self.position)
	else
		WwiseWorld.trigger_event(var_102_0, self.event)
	end
end

function flow_callback_print_variable(self)
	-- function 103
	print(self.string, self.variable)
end

function flow_callback_set_environment(self)
	-- function 104
	local environment_name = self.environment_name
	local time = self.time

	Managers.state.event:trigger("set_environment", environment_name, time)
end

function flow_callback_start_bus_transition(self)
	-- function 105
	Managers.music:start_bus_transition(self.bus_name, self.target_value, self.duration, self.transition_type, self.from_value)
end

function flow_callback_game_mode_event(self)
	-- function 106
	local announcement = self.announcement
	local side = self.side
	local param_1 = self.param_1

	param_1 = param_1 or ""

	local param_2 = self.param_2

	param_2 = param_2 or ""

	Managers.state.game_mode:trigger_event("flow", announcement, side, param_1, param_2)
end

function flow_callback_thrown_projectile_bounce(self)
	-- function 107
	local unit = self.unit

	if not alive(unit) and not ScriptUnit.has_extension(unit, "projectile_system") then
		ScriptUnit.extension(unit, "projectile_system"):flow_cb_bounce(self.hit_unit, self.hit_actor, self.position, self.normal)
	end
end

function flow_callback_projectile_impacts_stopped(self)
	-- function 108
	local unit = self.unit
	local flag = true
	local var_108_2 = ALIVE[unit]

	var_108_2 = not var_108_2 and ScriptUnit.has_extension(unit, "projectile_system")

	if not var_108_2 and not var_108_2.are_impacts_stopped then
		flag = var_108_2:are_impacts_stopped()
	end

	flow_return_table.impacts_stopped = flag

	return flow_return_table
end

function flow_callback_mark_sack_for_linking(self)
	-- function 109
	local unit = self.unit

	Unit.set_data(unit, "link_to_unit", true)
end

function flow_callback_remove_link_mark_for_sack(self)
	-- function 110
	local unit = self.unit

	Unit.set_data(unit, "link_to_unit", nil)
end

function flow_callback_start_network_timer(self)
	-- function 111
	if not Managers.player.is_server then
		local time = self.time

		Managers.state.event:trigger("event_start_network_timer", time)
	end
end

function flow_callback_set_flow_object_set_enabled(self)
	-- function 112
	fassert(self.set, "[Flow Callback : Set Flow Object Set Enabled] No set set.")
	fassert(self.enabled ~= nil, "[Flow Callback : Set Flow Object Set Enabled] No enabled set.")

	if not Managers.state.game_mode then
		Managers.state.game_mode:flow_cb_set_flow_object_set_enabled(self.set, self.enabled)
	else
		Managers.state.event:trigger("set_flow_object_set_enabled", self.set, self.enabled)
	end
end

function flow_callback_set_flow_object_set_particles_enabled(self)
	-- function 113
	fassert(self.set, "[Flow Callback : Set Flow Object Set Particles Enabled] No set set.")
	fassert(self.enabled ~= nil, "[Flow Callback : Set Flow Object Set Particles Enabled] No enabled set.")

	local flow_callback_context_world = Application.flow_callback_context_world()
	local current_level = LevelHelper:current_level(flow_callback_context_world)

	if not self.enabled then
		Level.start_particle_effects_in_object_set(current_level, "flow_" .. self.set)
	else
		Level.stop_particle_effects_in_object_set(current_level, "flow_" .. self.set)
	end
end

flow_cb_set_flow_object_set_enabled = flow_callback_set_flow_object_set_enabled

function flow_callback_create_networked_flow_state(self)
	-- function 114
	local networked_flow_state = Managers.state.networked_flow_state

	if not networked_flow_state then
		local flow_cb_create_state, var_114_2 = networked_flow_state:flow_cb_create_state(self.unit, self.state_name, self.in_value, self.client_state_changed_event, self.client_hot_join_event, self.is_game_object)

		if not flow_cb_create_state then
			flow_return_table.created = flow_cb_create_state
			flow_return_table.out_value = var_114_2

			return flow_return_table
		end
	else
		local flow_state_unit = self.flow_state_unit

		Managers.level_transition_handler:queue_create_networked_flow_state(flow_state_unit)
	end
end

function flow_callback_change_networked_flow_state(self)
	-- function 115
	local networked_flow_state = Managers.state.networked_flow_state

	if not networked_flow_state then
		local flow_cb_change_state, var_115_2 = networked_flow_state:flow_cb_change_state(self.unit, self.state_name, self.in_value)

		if not flow_cb_change_state then
			flow_return_table.changed = flow_cb_change_state
			flow_return_table.out_value = var_115_2

			return flow_return_table
		end
	end
end

function flow_callback_get_networked_flow_state(self)
	-- function 116
	local networked_flow_state = Managers.state.networked_flow_state

	if not networked_flow_state then
		local flow_cb_get_state = networked_flow_state:flow_cb_get_state(self.unit, self.state_name)

		flow_return_table.out_value = flow_cb_get_state

		return flow_return_table
	end
end

function flow_callback_client_networked_flow_state_changed(self)
	-- function 117
	local networked_flow_state = Managers.state.networked_flow_state

	if not networked_flow_state then
		local flow_cb_get_state = networked_flow_state:flow_cb_get_state(self.unit, self.state_name)

		flow_return_table.changed = true
		flow_return_table.out_value = flow_cb_get_state

		return flow_return_table
	end
end

function flow_callback_client_networked_flow_state_set(self)
	-- function 118
	local networked_flow_state = Managers.state.networked_flow_state

	if not networked_flow_state then
		local flow_cb_get_state = networked_flow_state:flow_cb_get_state(self.unit, self.state_name)

		flow_return_table.set = true
		flow_return_table.out_value = flow_cb_get_state

		return flow_return_table
	end
end

function flow_callback_create_networked_story(arg_119_0)
	-- function 119
	local networked_flow_state = Managers.state.networked_flow_state

	if not networked_flow_state then
		return networked_flow_state:flow_cb_create_story(arg_119_0)
	end
end

function flow_callback_networked_story_client_call(arg_120_0)
	-- function 120
	local networked_flow_state = Managers.state.networked_flow_state

	if not networked_flow_state then
		return networked_flow_state:flow_cb_networked_story_client_call(arg_120_0)
	end
end

function flow_callback_has_stopped_networked_story(arg_121_0)
	-- function 121
	local networked_flow_state = Managers.state.networked_flow_state

	if not networked_flow_state then
		return networked_flow_state:flow_cb_has_stopped_networked_story(arg_121_0)
	end
end

function flow_callback_has_played_networked_story(arg_122_0)
	-- function 122
	local networked_flow_state = Managers.state.networked_flow_state

	if not networked_flow_state then
		return networked_flow_state:flow_cb_has_played_networked_story(arg_122_0)
	end
end

function flow_callback_play_networked_story(arg_123_0)
	-- function 123
	local networked_flow_state = Managers.state.networked_flow_state

	if not networked_flow_state then
		return networked_flow_state:flow_cb_play_networked_story(arg_123_0)
	end
end

function flow_callback_stop_networked_story(arg_124_0)
	-- function 124
	local networked_flow_state = Managers.state.networked_flow_state

	if not networked_flow_state then
		return networked_flow_state:flow_cb_stop_networked_story(arg_124_0)
	end
end

function flow_callback_invert_bool(self)
	-- function 125
	flow_return_table.out = true
	flow_return_table.out_value = not self.in_value

	return flow_return_table
end

function flow_callback_projectile_bounce(self)
	-- function 126
	local unit = self.unit
	local touching_unit = self.touching_unit
	local position = self.position
	local normal = self.normal
	local separation_distance = self.separation_distance
	local impulse_force = self.impulse_force

	ScriptUnit.extension(unit, "locomotion_system"):bounce(touching_unit, position, normal, separation_distance, impulse_force)
end

function flow_callback_get_random_player(arg_127_0)
	-- function 127
	local get_random_alive_hero = PlayerUtils.get_random_alive_hero()

	get_random_alive_hero = get_random_alive_hero or Unit.null_reference()
	flow_return_table.playerunit = get_random_alive_hero

	return flow_return_table
end

function flow_callback_get_local_player_unit(arg_128_0)
	-- function 128
	local local_player = Managers.player:local_player()
	local flag = not local_player and local_player.player_unit

	if not flag and not Unit.alive(flag) then
		flow_return_table.localplayer = flag
	else
		flow_return_table.localplayer = Unit.null_reference()
	end

	return flow_return_table
end

local tbl = {}

function flow_callback_get_random_player_or_global_observer(arg_129_0)
	-- function 129
	table.clear(tbl)

	local var_129_0 = tbl
	local num = 0
	local get_random_alive_hero = PlayerUtils.get_random_alive_hero()

	if not get_random_alive_hero then
		var_129_0[1] = get_random_alive_hero
		num = 1
	end

	local global_observers = Managers.state.entity:system("surrounding_aware_system").global_observers

	for k in pairs(global_observers) do
		num = num + 1
		var_129_0[num] = k
	end

	if num > 0 then
		local var_129_4 = var_129_0[math.random(1, num)]

		flow_return_table.unit = var_129_4
	else
		flow_return_table.unit = Unit.null_reference()
	end

	return flow_return_table
end

function flow_callback_get_random_global_observer(arg_130_0)
	-- function 130
	local global_observers = Managers.state.entity:system("surrounding_aware_system").global_observers

	table.clear(tbl)

	local var_130_1 = tbl
	local num = 0

	for k in pairs(global_observers) do
		num = num + 1
		var_130_1[num] = k
	end

	if num > 0 then
		local var_130_3 = var_130_1[math.random(1, num)]

		flow_return_table.unit = var_130_3

		return flow_return_table
	end

	return nil
end

function flow_callback_trigger_dialogue_event(self)
	-- function 131
	local source = self.source

	fassert(source, "Calling flow_callback_trigger_dialogue_event without passing unit")

	if not ScriptUnit.has_extension(source, "dialogue_system") then
		local extension_input = ScriptUnit.extension_input(source, "dialogue_system")
		local alloc_table = FrameTable.alloc_table()

		if not self.argument1_name then
			local argument1_name = self.argument1_name
			local var_131_4 = tonumber(self.argument1)

			var_131_4 = var_131_4 or self.argument1
			alloc_table[argument1_name] = var_131_4
		end

		if not self.argument2_name then
			local argument2_name = self.argument2_name
			local var_131_6 = tonumber(self.argument2)

			var_131_6 = var_131_6 or self.argument2
			alloc_table[argument2_name] = var_131_6
		end

		if not self.argument3_name then
			local argument3_name = self.argument3_name
			local var_131_8 = tonumber(self.argument3)

			var_131_8 = var_131_8 or self.argument3
			alloc_table[argument3_name] = var_131_8
		end

		extension_input:trigger_dialogue_event(self.concept, alloc_table, self.identifier)
	else
		print(string.format("[flow_callback_trigger_dialogue_event] No extension found belonging to system \"dialogue_system\" for unit %s", tostring(source)))
	end
end

function flow_callback_trigger_networked_dialogue_event(self)
	-- function 132
	local source = self.source

	fassert(source, "Calling flow_callback_trigger_dialogue_event without passing unit")

	if not ScriptUnit.has_extension(source, "dialogue_system") then
		local extension_input = ScriptUnit.extension_input(source, "dialogue_system")
		local alloc_table = FrameTable.alloc_table()

		if not self.argument1_name then
			local argument1_name = self.argument1_name
			local var_132_4 = tonumber(self.argument1)

			var_132_4 = var_132_4 or self.argument1
			alloc_table[argument1_name] = var_132_4
		end

		if not self.argument2_name then
			local argument2_name = self.argument2_name
			local var_132_6 = tonumber(self.argument2)

			var_132_6 = var_132_6 or self.argument2
			alloc_table[argument2_name] = var_132_6
		end

		if not self.argument3_name then
			local argument3_name = self.argument3_name
			local var_132_8 = tonumber(self.argument3)

			var_132_8 = var_132_8 or self.argument3
			alloc_table[argument3_name] = var_132_8
		end

		extension_input:trigger_networked_dialogue_event(self.concept, alloc_table, self.identifier)
	else
		print(string.format("[flow_callback_trigger_networked_dialogue_event] No extension found belonging to system \"dialogue_system\" for unit %s", tostring(source)))
	end
end

flow_callback_trigger_ensured_dialogue_event = flow_callback_trigger_dialogue_event

function flow_callback_trigger_dialogue_event_on_players(self)
	-- function 133
	local players = Managers.player:players()

	for k, v in pairs(players) do
		local player_unit = v.player_unit

		if not ALIVE[player_unit] then
			self.source = player_unit

			flow_callback_trigger_dialogue_event(self)
		end
	end
end

flow_callback_trigger_ensured_dialogue_event_on_players = flow_callback_trigger_dialogue_event_on_players

function flow_callback_change_outline_params(self)
	-- function 134
	if not DEDICATED_SERVER then
		return
	end

	local unit = self.unit
	local has_extension = ScriptUnit.has_extension(unit, "outline_system")

	fassert(has_extension, "Trying to change outline params through flow without an outline extension on the unit")

	local method = self.method

	if not method then
		has_extension:update_outline({
			method = method
		}, 0)
	end

	local var_134_3 = OutlineSettings.colors[self.color]

	if not var_134_3 then
		has_extension:update_outline({
			outline_color = var_134_3
		}, 0)
	end
end

function flow_callback_register_transport_navmesh_units(self)
	-- function 135
	local unit = self.unit
	local start_unit = self.start_unit
	local end_unit = self.end_unit

	ScriptUnit.extension(unit, "transportation_system"):register_navmesh_units(start_unit, end_unit)
end

function flow_callback_start_transport(self)
	-- function 136
	local transport_unit = self.transport_unit
	local player_unit = Managers.player:local_player().player_unit

	ScriptUnit.extension(transport_unit, "transportation_system"):interacted_with(player_unit)
end

function flow_callback_set_door_state_and_duration(self)
	-- function 137
	local unit = self.unit
	local new_door_state = self.new_door_state
	local frames = self.frames
	local speed = self.speed

	ScriptUnit.extension(unit, "door_system"):set_door_state_and_duration(new_door_state, frames, speed)
end

function flow_callback_set_door_state(self)
	-- function 138
	local unit = self.unit
	local new_door_state = self.new_door_state
	local extension = ScriptUnit.extension(unit, "door_system")

	extension:set_door_state(new_door_state)

	extension.frames_since_obstacle_update = 0
end

function flow_callback_door_animation_played(self)
	-- function 139
	local unit = self.unit
	local frames = self.frames
	local speed = self.speed

	ScriptUnit.extension(unit, "door_system"):animation_played(frames, speed)
end

function flow_callback_set_valid_ai_target(self)
	-- function 140
	local unit = self.unit
	local valid_target = self.valid_target

	ScriptUnit.extension(unit, "ai_slot_system").valid_target = valid_target
end

function flow_callback_set_ai_aggro_modifier(self)
	-- function 141
	local unit = self.unit
	local aggro_modifier = self.aggro_modifier

	ScriptUnit.extension(unit, "aggro_system").aggro_modifier = aggro_modifier * -1
end

function flow_callback_objective_entered_socket_zone(self)
	-- function 142
	print("[flow_callback_objective_entered_socket_zone]", self.socket_unit, self.objective_unit)

	if not Managers.player.is_server then
		local socket_unit = self.socket_unit
		local objective_unit = self.objective_unit
		local get_data = Unit.get_data(socket_unit, "socket_type")

		get_data = get_data or "none"

		local get_data_2 = Unit.get_data(objective_unit, "socket_type")

		get_data_2 = get_data_2 or "none"

		if get_data == get_data_2 then
			ScriptUnit.extension(socket_unit, "objective_socket_system"):objective_entered_zone_server(objective_unit)
		else
			print("[flow_callback_objective_entered_socket_zone] Socket type doesn't match", self.socket_unit, self.objective_unit)
		end
	end
end

function flow_callback_ussingen_barrel_challenge(self)
	-- function 143
	print("[flow_callback_ussingen_barrel_challenge]", self.barrel_unit)

	if not Managers.player.is_server then
		local barrel_unit = self.barrel_unit
		local num_valid_barrels = self.num_valid_barrels

		if not ScriptUnit.has_extension(barrel_unit, "limited_item_track_system") then
			flow_return_table.is_valid_barrel = 1

			return flow_return_table
		end
	end

	flow_return_table.is_valid_barrel = 0

	return flow_return_table
end

function flow_callback_ussingen_barrel_challenge_completed(self)
	-- function 144
	print("[flow_callback_ussingen_barrel_challenge_completed]")

	if not Managers.player.is_server then
		local tbl = {
			"ussingen_used_no_barrels",
			"ussingen_used_no_barrels_cata"
		}

		for i = 1, #tbl do
			local get_difficulty = Managers.state.difficulty:get_difficulty()

			if not (not QuestSettings.allowed_difficulties[tbl[i]][get_difficulty] and not (self.num_valid_barrels >= 3)) then
				Managers.player:statistics_db():increment_stat_and_sync_to_clients(tbl[i])
			end
		end
	end
end

function flow_callback_occupied_sockets_query(self)
	-- function 145
	local socket_unit = self.socket_unit
	local num_closed_sockets = ScriptUnit.extension(socket_unit, "objective_socket_system").num_closed_sockets

	flow_return_table.sockets = num_closed_sockets

	return flow_return_table
end

function flow_callback_register_environment_volume(self)
	-- function 146
	local particle_light_intensity = self.particle_light_intensity

	particle_light_intensity = particle_light_intensity or 1

	if not self.shading_environment then
		Managers.state.event:trigger("register_environment_volume", self.volume_name, self.shading_environment, self.priority, self.blend_time, self.override_sun_snap, particle_light_intensity)
	end
end

function flow_callback_enable_environment_volume(self)
	-- function 147
	fassert(self.volume_name, "[flow_callbacks] No volume name provided [required]")
	Managers.state.event:trigger("enable_environment_volume", self.volume_name, self.enable)
end

function flow_callback_volume_system_register_damage_volume(self)
	-- function 148
	Managers.state.entity:system("volume_system"):register_volume(self.volume_name, "damage_volume", self)
end

function flow_callback_volume_system_register_movement_volume(self)
	-- function 149
	Managers.state.entity:system("volume_system"):register_volume(self.volume_name, "movement_volume", self)
end

function flow_callback_volume_system_register_location_volume(self)
	-- function 150
	local system = Managers.state.entity:system("volume_system")

	fassert(NetworkLookup.locations[self.location], "Volume location named [\"%s\"] needs to be added to NetworkLookup.locations", self.location)
	system:register_volume(self.volume_name, "location_volume", self)
end

function flow_callback_volume_system_register_trigger_volume(self)
	-- function 151
	Managers.state.entity:system("volume_system"):register_volume(self.volume_name, "trigger_volume", self)
end

function flow_callback_volume_system_register_despawn_volume(self)
	-- function 152
	Managers.state.entity:system("volume_system"):register_volume(self.volume_name, "despawn_volume", self)
end

function flow_callback_volume_system_unregister_volume(self)
	-- function 153
	Managers.state.entity:system("volume_system"):unregister_volume(self.volume_name)
end

function flow_callback_intro_cutscene_show_location(self)
	-- function 154
	fassert(self.location, "No location set")

	local player_unit = Managers.player:local_player().player_unit

	fassert(alive(player_unit), "Tried showing location with no player unit spawned")
	ScriptUnit.extension(player_unit, "hud_system"):set_current_location(self.location)
end

function flow_callback_local_player_profile_switch(arg_155_0)
	-- function 155
	local profile_index = Managers.player:local_player():profile_index()
	local display_name = SPProfiles[profile_index].display_name

	return {
		witch_hunter = display_name == "witch_hunter",
		bright_wizard = display_name == "bright_wizard",
		dwarf_ranger = display_name == "dwarf_ranger",
		wood_elf = display_name == "wood_elf",
		empire_soldier = display_name == "empire_soldier"
	}
end

function flow_callback_local_player_profile_check(arg_156_0)
	-- function 156
	local profile_index = Managers.player:local_player():profile_index()
	local display_name = SPProfiles[profile_index].display_name

	return {
		player_profile = display_name
	}
end

function flow_callback_local_player_profile_available(arg_157_0)
	-- function 157
	local local_player_safe = Managers.player:local_player_safe()

	if not local_player_safe then
		return {
			is_available = false
		}
	end

	local profile_index = local_player_safe:profile_index()
	local var_157_2 = SPProfiles[profile_index]
	local flag = not var_157_2 and var_157_2.display_name

	return {
		is_available = flag ~= nil
	}
end

function flow_callback_compare_string(self)
	-- function 158
	local a = self.a
	local b = self.b

	return {
		equals = a == b,
		not_equals = a ~= b
	}
end

function flow_callback_set_allowed_nav_tag_volume_layer(self)
	-- function 159
	local layer = self.layer
	local allowed = self.allowed

	Managers.state.entity:system("ai_system"):set_allowed_layer(layer, allowed)
end

function flow_callback_register_spline_properties(self)
	-- function 160
	local spline_name = self.spline_name
	local despawn_patrol_at_end_of_spline = self.despawn_patrol_at_end_of_spline

	Managers.state.entity:system("ai_group_system"):register_spline_properties(spline_name, {
		despawn_patrol_at_end_of_spline = despawn_patrol_at_end_of_spline
	})
end

function flow_callback_register_sound_environment(self)
	-- function 161
	if not DEDICATED_SERVER then
		return
	end

	local volume_name = self.volume_name
	local prio = self.prio
	local ambient_sound_event = self.ambient_sound_event
	local fade_time = self.fade_time
	local aux_bus_name = self.aux_bus_name
	local environment_state = self.environment_state

	Managers.state.entity:system("sound_environment_system"):register_sound_environment(volume_name, prio, ambient_sound_event, fade_time, aux_bus_name, environment_state)
end

function flow_callback_trigger_wwise_event_for_target_player(self)
	-- function 162
	if not self.ai_unit then
		return
	end

	local var_162_0 = BLACKBOARDS[self.ai_unit]
	local flag = not var_162_0 and var_162_0.target_unit
	local local_player = Managers.player:local_player()
	local flag_2 = not local_player and local_player.player_unit

	if not (not flag and flag == flag_2) then
		return
	end

	if not (DEDICATED_SERVER or Managers.state.entity) then
		flow_return_table.playing_id = 1
		flow_return_table.source_id = 1

		return flow_return_table
	end

	local name = self.name
	local wwise_world = Managers.state.entity:system("sound_environment_system").wwise_world
	local trigger_event = WwiseWorld.trigger_event(wwise_world, name)

	flow_return_table.playing_id = trigger_event

	return flow_return_table
end

function flow_callback_wwise_trigger_event_with_environment(self)
	-- function 163
	if not (DEDICATED_SERVER or Managers.state.entity) then
		flow_return_table.playing_id = 1
		flow_return_table.source_id = 1

		return flow_return_table
	end

	local position = self.position
	local unit = self.unit
	local unit_node = self.unit_node
	local name = self.name
	local use_occlusion = self.use_occlusion

	use_occlusion = use_occlusion or false

	local system = Managers.state.entity:system("sound_environment_system")
	local wwise_world = system.wwise_world
	local existing_source_id

	if not self.existing_source_id and not WwiseWorld.has_source(wwise_world, self.existing_source_id) then
		existing_source_id = self.existing_source_id

		if not existing_source_id then
			-- Nothing
		end
	end

	existing_source_id = nil

	::label_163_0::

	local var_163_8

	if not (not unit and not unit_node and unit_node == "") then
		local node = Unit.node(unit, unit_node)

		fassert(node, "Node %s doesn't exist in unit %s", unit, unit_node)

		var_163_8 = existing_source_id or WwiseWorld.make_auto_source(wwise_world, unit, node)
		position = Unit.world_position(unit, node)
	elseif not unit then
		var_163_8 = existing_source_id or WwiseWorld.make_auto_source(wwise_world, unit)
		position = Unit.world_position(unit, 0)
	elseif not position then
		var_163_8 = existing_source_id or WwiseWorld.make_auto_source(wwise_world, position)
	else
		ferror("Missing unit or position in wwise trigger even with environment flow node in unit %s", unit)
	end

	if not Vector3.is_valid(position) then
		system:set_source_environment(var_163_8, position)
	end

	local trigger_event = WwiseWorld.trigger_event(wwise_world, name, use_occlusion, var_163_8)

	flow_return_table.playing_id = trigger_event
	flow_return_table.source_id = var_163_8

	return flow_return_table
end

function flow_callback_wwise_create_environment_sampled_source(self)
	-- function 164
	local system = Managers.state.entity:system("sound_environment_system")
	local wwise_world = system.wwise_world
	local position = self.position
	local unit = self.unit
	local unit_node = self.unit_node
	local var_164_5

	if not (not unit and not unit_node and unit_node == "") then
		node = Unit.node(unit, unit_node)

		fassert(node, "Node %s doesn't exist in unit %s", unit, unit_node)

		var_164_5 = WwiseWorld.make_manual_source(wwise_world, unit, node)
		position = Unit.world_position(unit, node)
	elseif not unit then
		var_164_5 = WwiseWorld.make_manual_source(wwise_world, unit)
		position = Unit.world_position(unit, 0)
	elseif not position then
		var_164_5 = WwiseWorld.make_manual_source(wwise_world, position)
	else
		ferror("Missing unit or position in wwise environment sampled source creation flow node in unit %s", unit)
	end

	system:set_source_environment(var_164_5, position)

	flow_return_table.source_id = var_164_5

	return flow_return_table
end

function flow_callback_wwise_register_source_environment_update(self)
	-- function 165
	fassert(self.source_id, "Missing SourceId in \"Register source for environment sample update\"")
	fassert(self.unit, "Missing Unit in \"Register source for environment sample update\"")
	Managers.state.entity:system("sound_environment_system"):register_source_environment_update(self.source_id, self.unit)
end

function flow_callback_wwise_unregister_source_environment_update(self)
	-- function 166
	fassert(self.source_id, "Missing SourceId in \"Unregister source for environment sample update\"")
	Managers.state.entity:system("sound_environment_system"):unregister_source_environment_update(self.source_id)
end

function flow_callback_clear_linked_projectiles(self)
	-- function 167
	local unit = self.unit

	Managers.state.entity:system("projectile_linker_system"):clear_linked_projectiles(unit)
end

function flow_callback_activate_cutscene_camera(self)
	-- function 168
	local transition = self.transition
	local transition_length = self.transition_length

	fassert(transition == "NONE" or transition_length ~= nil, "Transition Length must be set in flow node for cutscene camera with transition %q ", transition)

	local camera = self.camera
	local tbl = {
		transition = transition,
		transition_start_time = self.transition_start_time,
		transition_length = transition_length,
		allow_controls = self.allow_controls,
		max_yaw_angle = self.max_yaw_angle,
		max_pitch_angle = self.max_pitch_angle
	}
	local flag = not not self.ingame_hud_enabled
	local flag_2 = not self.letterbox_disabled

	Managers.state.entity:system("cutscene_system"):flow_cb_activate_cutscene_camera(camera, tbl, flag, flag_2)
end

function flow_callback_deactivate_cutscene_cameras(arg_169_0)
	-- function 169
	Managers.state.entity:system("cutscene_system"):flow_cb_deactivate_cutscene_cameras()
end

function flow_callback_activate_cutscene_logic(self)
	-- function 170
	local flag = not not self.player_input_enabled
	local event_on_activate = self.event_on_activate
	local event_on_skip = self.event_on_skip

	Managers.state.entity:system("cutscene_system"):flow_cb_activate_cutscene_logic(flag, event_on_activate, event_on_skip)
end

function flow_callback_deactivate_cutscene_logic(self)
	-- function 171
	local event_on_deactivate = self.event_on_deactivate

	Managers.state.entity:system("cutscene_system"):flow_cb_deactivate_cutscene_logic(event_on_deactivate)
end

function flow_callback_cutscene_fx_fade(arg_172_0)
	-- function 172
	Managers.state.entity:system("cutscene_system"):flow_cb_cutscene_effect("fx_fade", arg_172_0)
end

function flow_callback_cutscene_fx_text_popup(arg_173_0)
	-- function 173
	Managers.state.entity:system("cutscene_system"):flow_cb_cutscene_effect("fx_text_popup", arg_173_0)
end

function flow_callback_start_tutorial_intro_text(arg_174_0)
	-- function 174
	local var_174_0 = local_require("scripts/ui/cutscene_overlay_templates/cutscene_template_tutorial")

	Managers.state.event:trigger("event_start_cutscene_overlay", var_174_0)
end

function flow_callback_start_mission(self)
	-- function 175
	if not (not Managers.state.network and Managers.state.network:game()) then
		return
	end

	local mission_name = self.mission_name

	fassert(mission_name, "[flow_callback_start_mission] No mission name passed")
	fassert(Missions[mission_name], "[flow_callback_start_mission] There is no mission by the name %q", mission_name)

	if not Missions[mission_name].is_tutorial_input then
		Managers.state.event:trigger("event_add_tutorial_input", mission_name, self.unit)
	else
		Managers.state.entity:system("mission_system"):flow_callback_start_mission(mission_name, self.unit, self.client_may_start, self.only_once)
	end
end

function flow_callback_update_mission(self)
	-- function 176
	local mission_name = self.mission_name

	fassert(mission_name, "[flow_callback_update_mission] No mission name passed")
	fassert(Missions[mission_name], "[flow_callback_start_mission] There is no mission by the name %q", mission_name)

	if not Missions[mission_name].is_tutorial_input then
		Managers.state.event:trigger("event_update_tutorial_input", mission_name)
	else
		Managers.state.entity:system("mission_system"):flow_callback_update_mission(mission_name)
	end
end

function flow_callback_reset_mission(self)
	-- function 177
	local mission_name = self.mission_name

	fassert(mission_name, "[flow_callback_reset_mission] No mission name passed")
	fassert(Missions[mission_name], "[flow_callback_start_mission] There is no mission by the name %q", mission_name)

	if not Missions[mission_name].is_tutorial_input then
		Managers.state.event:trigger("event_update_tutorial_input", mission_name)
	else
		Managers.state.entity:system("mission_system"):flow_callback_reset_mission(mission_name)
	end
end

function flow_callback_end_mission(self)
	-- function 178
	local mission_name = self.mission_name

	fassert(mission_name, "[flow_callback_end_mission] No mission name passed")
	fassert(Missions[mission_name], "[flow_callback_start_mission] There is no mission by the name %q", mission_name)

	if not Missions[mission_name].is_tutorial_input then
		Managers.state.event:trigger("event_remove_tutorial_input", mission_name)
	else
		Managers.state.entity:system("mission_system"):flow_callback_end_mission(mission_name)
	end
end

function flow_callback_show_health_bar(self)
	-- function 179
	fassert(self.unit, "[flow_callback_show_health_bar] No unit passed")
	Managers.state.entity:system("tutorial_system"):flow_callback_show_health_bar(self.unit, self.show)
end

function flow_callback_spawn_tutorial_bot(self)
	-- function 180
	local profile_index = self.profile_index
	local num = 1

	Managers.state.game_mode:game_mode():add_bot(profile_index, num)
end

function flow_callback_set_bot_ready_for_assisted_respawn(self)
	-- function 181
	local unit = self.unit
	local respawn_unit = self.respawn_unit

	Managers.state.entity:system("play_go_tutorial_system"):set_bot_ready_for_assisted_respawn(unit, respawn_unit)
end

function flow_callback_enable_tutorial_player_ammo_refill(arg_182_0)
	-- function 182
	Managers.state.entity:system("play_go_tutorial_system"):enable_player_ammo_refill()
end

function flow_callback_remove_player_ammo(arg_183_0)
	-- function 183
	Managers.state.entity:system("play_go_tutorial_system"):remove_player_ammo()
end

function flow_callback_check_player_ammo(arg_184_0)
	-- function 184
	flow_return_table.has_ammo = Managers.state.entity:system("play_go_tutorial_system"):check_player_ammo()

	return flow_return_table
end

function flow_callback_give_player_potion_from_bot(self)
	-- function 185
	local player_unit = self.player_unit
	local bot_unit = self.bot_unit

	Managers.state.entity:system("play_go_tutorial_system"):give_player_potion_from_bot(player_unit, bot_unit)
end

function flow_callback_get_players_and_bots(arg_186_0)
	-- function 186
	local human_and_bot_players = Managers.player:human_and_bot_players()

	table.clear(tbl)

	local var_186_1 = tbl
	local num = 0

	for k, v in pairs(human_and_bot_players) do
		local player_unit = v.player_unit

		if not HEALTH_ALIVE[player_unit] then
			num = num + 1
			var_186_1[v:profile_index()] = player_unit
		end
	end

	if num > 0 then
		flow_return_table.profile1 = var_186_1[1]
		flow_return_table.profile2 = var_186_1[2]
		flow_return_table.profile3 = var_186_1[3]
		flow_return_table.profile4 = var_186_1[4]
		flow_return_table.profile5 = var_186_1[5]

		return flow_return_table
	end

	return nil
end

function flow_callback_add_group_buff(self)
	-- function 187
	if not Managers.player.is_server then
		return
	end

	local group_buff_template = self.group_buff_template
	local var_187_1 = NetworkLookup.group_buff_templates[group_buff_template]

	Managers.state.entity:system("buff_system"):rpc_add_group_buff(nil, var_187_1, 1)

	return nil
end

function flow_callback_set_career_voice_parameter_value(self)
	-- function 188
	local profile_index = Managers.player:local_player():profile_index()
	local career_voice_parameter = SPProfiles[profile_index].career_voice_parameter
	local world = Managers.state.spawn.world
	local wwise_world = Wwise.wwise_world(world)
	local career_voice_parameter_value = self.career_voice_parameter_value

	WwiseWorld.set_global_parameter(wwise_world, career_voice_parameter, career_voice_parameter_value)
end

function flow_is_carrying_explosive_barrel(self)
	-- function 189
	local player_unit = self.player_unit

	if not alive(player_unit) then
		flow_return_table.has_barrel = false

		return flow_return_table
	end

	local var_189_1
	local has_extension = ScriptUnit.has_extension(player_unit, "inventory_system")

	if not has_extension then
		var_189_1 = has_extension:equipment()
	else
		var_189_1 = Unit.get_data(player_unit, "equipment")
	end

	local left_hand_wielded_unit = var_189_1.left_hand_wielded_unit

	left_hand_wielded_unit = left_hand_wielded_unit or var_189_1.right_hand_wielded_unit

	if not left_hand_wielded_unit then
		local extension = ScriptUnit.extension(left_hand_wielded_unit, "weapon_system")

		if not (extension.item_name == "explosive_barrel_objective" or extension.item_name ~= "explosive_barrel") then
			flow_return_table.has_barrel = true
		end
	end

	return flow_return_table
end

function flow_is_carrying_torch(self)
	-- function 190
	local player_unit = self.player_unit

	if not alive(player_unit) then
		flow_return_table.has_torch = false

		return flow_return_table
	end

	local var_190_1
	local has_extension = ScriptUnit.has_extension(player_unit, "inventory_system")

	if not has_extension then
		var_190_1 = has_extension:equipment()
	else
		var_190_1 = Unit.get_data(player_unit, "equipment")
	end

	local left_hand_wielded_unit = var_190_1.left_hand_wielded_unit

	left_hand_wielded_unit = left_hand_wielded_unit or var_190_1.right_hand_wielded_unit

	if not left_hand_wielded_unit then
		local item_name = ScriptUnit.extension(left_hand_wielded_unit, "weapon_system").item_name

		if not (item_name == "torch" or item_name ~= "shadow_torch") then
			flow_return_table.has_torch = true
		end
	end

	return flow_return_table
end

function flow_callback_teleport_unit(self)
	-- function 191
	local unit = self.unit
	local position = self.position
	local rotation = self.rotation

	if not alive(unit) then
		return
	end

	if not Managers.state.network.is_server then
		local get_data = Unit.get_data(unit, "breed")

		if not (not get_data and get_data.is_player) then
			return
		end
	end

	local extension = ScriptUnit.extension(unit, "locomotion_system")

	if not extension.teleport_to then
		extension:teleport_to(position, rotation)
	end

	if not Unit.get_data(unit, "bot") then
		ScriptUnit.extension(unit, "ai_navigation_system"):teleport(position)
	end
end

function flow_callback_unspawn_all_ais(arg_192_0)
	-- function 192
	Managers.state.conflict:destroy_all_units()
end

function flow_query_slots_status(self)
	-- function 193
	local player_unit = self.player_unit

	if not alive(player_unit) then
		flow_return_table.healthkit = false
		flow_return_table.grenade = false
		flow_return_table.potion = false

		return flow_return_table
	end

	local var_193_1
	local has_extension = ScriptUnit.has_extension(player_unit, "inventory_system")

	if not has_extension then
		var_193_1 = has_extension:equipment()
	else
		var_193_1 = Unit.get_data(player_unit, "equipment")
	end

	local slot_healthkit = var_193_1.slots.slot_healthkit
	local slot_grenade = var_193_1.slots.slot_grenade
	local slot_potion = var_193_1.slots.slot_potion

	flow_return_table.healthkit = slot_healthkit ~= nil
	flow_return_table.grenade = slot_grenade ~= nil
	flow_return_table.potion = slot_potion ~= nil

	return flow_return_table
end

function flow_callback_damage_player_bot_ai(self)
	-- function 194
	local unit = self.unit
	local attacker_unit

	if not Unit.alive(self.attacker_unit) then
		attacker_unit = self.attacker_unit

		if not attacker_unit then
			-- Nothing
		end
	end

	attacker_unit = unit

	::label_194_0::

	local damage = self.damage

	if not alive(unit) then
		fassert(ScriptUnit.has_extension(unit, "health_system"), "Tried to kill unit %s from flow but the unit has no health extension", unit)

		local str = "full"
		local str_2 = "level"
		local world_position = Unit.world_position(unit, 0)
		local up = Vector3.up()
		local max = NetworkConstants.damage.max
		local extension = ScriptUnit.extension(unit, "health_system")
		local min = math.min(damage, extension:current_health())
		local ceil = math.ceil(min / max)

		for i = 0, ceil - 1 do
			local min_2 = math.min(min - ceil * i, ceil)

			DamageUtils.add_damage_network(unit, attacker_unit, min_2, str, str_2, world_position, up, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, i)
		end
	end
end

function flow_callback_get_health_player_bot_ai(self)
	-- function 195
	if not Managers.player.is_server then
		return
	end

	local unit = self.unit
	local num = 0

	if not alive(unit) then
		fassert(ScriptUnit.has_extension(unit, "health_system"), "Tried to get unit %s health from flow but the unit has no health extension", unit)

		local extension = ScriptUnit.extension(unit, "health_system")
		local has_extension = ScriptUnit.has_extension(unit, "status_system")

		if not (not has_extension and has_extension:is_knocked_down() and has_extension:is_ready_for_assisted_respawn()) then
			num = extension:current_health()
		end
	end

	flow_return_table.currenthealth = num

	return flow_return_table
end

function flow_callback_clear_slot(self)
	-- function 196
	local player_unit = self.player_unit
	local slot_name = self.slot_name

	if not alive(player_unit) then
		return
	end

	local has_extension = ScriptUnit.has_extension(player_unit, "inventory_system")

	if not has_extension then
		return
	end

	has_extension:destroy_slot(slot_name)
end

function flow_callback_set_wwise_elevation_alignment(self)
	-- function 197
	local z = self.position.z
	local scale = self.scale
	local min = self.min
	local max = self.max
	local camera = Managers.state.camera

	if not camera then
		camera:set_elevation_offset(z, scale, min, max)
	end
end

function flow_callback_kill_player_bot_ai(self)
	-- function 198
	if not Managers.player.is_server then
		return
	end

	local unit = self.unit

	if not alive(unit) then
		fassert(ScriptUnit.has_extension(unit, "health_system"), "Tried to kill unit %s from flow but the unit has no health extension", unit)
		ScriptUnit.extension(unit, "health_system"):die()
	end
end

function flow_callback_overcharge_heal_unit(self)
	-- function 199
	if not Managers.player.is_server then
		return
	end

	local unit = self.unit
	local health = self.health

	if not alive(unit) then
		fassert(ScriptUnit.has_extension(unit, "health_system"), "Tried to heal overcharge unit %s from flow but the unit has no health extension", unit)

		local extension = ScriptUnit.extension(unit, "health_system")

		extension:add_heal(unit, health, nil, "n/a")

		local current_health = extension:current_health()
		local get_damage_taken = extension:get_damage_taken()

		flow_return_table.current_health = current_health
		flow_return_table.current_damage = get_damage_taken

		return flow_return_table
	end
end

function flow_callback_overcharge_init_unit(self)
	-- function 200
	local unit = self.unit
	local init_damage = self.init_damage

	if not alive(unit) then
		fassert(ScriptUnit.has_extension(unit, "health_system"), "Tried to damage overcharge unit %s from flow but the unit has no health extension", unit)

		local extension = ScriptUnit.extension(unit, "health_system")
		local str = "full"
		local world_position = Unit.world_position(unit, 0)
		local up = Vector3.up()

		extension:add_damage(unit, init_damage, str, "destructible_level_object_hit", world_position, up, "wounded_degen", nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
	end
end

function flow_callback_overcharge_sync_damage(self)
	-- function 201
	local unit = self.unit
	local damage = self.damage
	local str = "full"
	local world_position = Unit.world_position(unit, 0)
	local extension = ScriptUnit.extension(unit, "health_system")
	local up = Vector3.up()

	extension:add_damage(unit, damage, str, "destructible_level_object_hit", world_position, up, "wounded_degen", nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
end

function flow_callback_overcharge_damage_unit(self)
	-- function 202
	if not Managers.player.is_server then
		return
	end

	local unit = self.unit
	local damage = self.damage

	if not alive(unit) then
		fassert(ScriptUnit.has_extension(unit, "health_system"), "Tried to damage overcharge unit %s from flow but the unit has no health extension", unit)

		local str = "full"
		local world_position = Unit.world_position(unit, 0)
		local up = Vector3.up()

		ScriptUnit.extension(unit, "health_system"):add_damage(unit, damage, str, "destructible_level_object_hit", world_position, up, "wounded_degen", nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
	end
end

function flow_callback_overcharge_reset_unit(self)
	-- function 203
	local unit = self.unit
	local maxhealth = self.maxhealth

	if not alive(unit) then
		fassert(ScriptUnit.has_extension(unit, "health_system"), "Tried to reset health and damage on overcharge unit %s from flow but the unit has no health extension", unit)

		local extension = ScriptUnit.extension(unit, "health_system")
		local num = 0

		extension:set_current_damage(num)
		extension:set_max_health(maxhealth)

		local network = Managers.state.network

		if not network.is_server then
			local get_network_safe_damage_hotjoin_sync = NetworkUtils.get_network_safe_damage_hotjoin_sync(num)
			local state = extension.state
			local var_203_7 = NetworkLookup.health_statuses[state]
			local network_transmit = Managers.state.network.network_transmit
			local game_object_or_level_id, var_203_10 = network:game_object_or_level_id(unit)

			network_transmit:send_rpc_clients("rpc_sync_damage_taken", game_object_or_level_id, var_203_10, false, get_network_safe_damage_hotjoin_sync, var_203_7)
		end
	end
end

local num = math.pi * 2

function flow_callback_fire_light_weight_projectile(self)
	-- function 204
	if not Managers.player.is_server then
		return
	end

	local unit = self.unit
	local shots_to_fire = self.shots_to_fire

	shots_to_fire = shots_to_fire or 1

	local light_weight_projectile_template_name = self.light_weight_projectile_template_name
	local var_204_3 = LightWeightProjectiles[light_weight_projectile_template_name]
	local str = "skaven_ratling_gunner"
	local world_position = Unit.world_position(unit, 0)

	for i = 1, shots_to_fire do
		local num_2 = Math.random() * var_204_3.spread
		local forward = Quaternion.forward(Unit.world_rotation(unit, 0))
		local var_204_8 = Quaternion(Vector3.right(), num_2)
		local var_204_9 = Quaternion(Vector3.forward(), Math.random() * num)
		local look = Quaternion.look(forward, Vector3.up())
		local multiply = Quaternion.multiply(Quaternion.multiply(look, var_204_9), var_204_8)
		local forward_2 = Quaternion.forward(multiply)
		local str_2 = "filter_enemy_player_afro_ray_projectile"
		local get_difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
		local var_204_15 = var_204_3.attack_power_level[get_difficulty_rank]

		var_204_15 = var_204_15 or var_204_3.attack_power_level[2]

		local tbl = {
			power_level = var_204_15,
			damage_profile = var_204_3.damage_profile,
			hit_effect = var_204_3.hit_effect,
			player_push_velocity = Vector3Box(forward * var_204_3.impact_push_speed),
			projectile_linker = var_204_3.projectile_linker,
			first_person_hit_flow_events = var_204_3.first_person_hit_flow_events
		}
		local system = Managers.state.entity:system("projectile_system")
		local peer_id = Network.peer_id()

		system:create_light_weight_projectile(str, unit, world_position, forward_2, var_204_3.projectile_speed, nil, nil, var_204_3.projectile_max_range, str_2, tbl, var_204_3.light_weight_projectile_effect, peer_id)
	end
end

function flow_callback_trigger_explosion(self)
	-- function 205
	if not Managers.player.is_server then
		return
	end

	local unit = self.unit
	local explosion_template_name = self.explosion_template_name

	fassert(explosion_template_name, "Trigger Explosion unit flow node is missing explosion_template_name")

	local get_template = ExplosionUtils.get_template(explosion_template_name)

	fassert(get_template.explosion.level_unit_damage, "The explosion_template must have level_unit_damage set to true when using this flow node")

	local world_position = Unit.world_position(unit, 0)
	local world_rotation = Unit.world_rotation(unit, 0)
	local num = 1
	local str = "grenade_frag_01"

	Managers.state.entity:system("area_damage_system"):create_explosion(unit, world_position, world_rotation, explosion_template_name, num, str, nil, false)
end

function flow_callback_enable_climb_unit(self)
	-- function 206
	local unit = self.unit

	if not alive(unit) then
		Managers.state.entity:system("nav_graph_system"):init_nav_graph_from_flow(unit)
	end
end

function flow_callback_add_nav_graph_on_climb_unit(self)
	-- function 207
	local unit = self.unit

	if not alive(unit) then
		Managers.state.entity:system("nav_graph_system"):queue_add_nav_graph_from_flow(unit)
	end
end

function flow_callback_remove_nav_graph_on_climb_unit(self)
	-- function 208
	local unit = self.unit

	if not alive(unit) then
		Managers.state.entity:system("nav_graph_system"):queue_remove_nav_graph_from_flow(unit)
	end
end

function flow_callback_create_permanent_box_obstacle_from_unit(self)
	-- function 209
	local unit = self.unit

	if not alive(unit) then
		return
	end

	local GLOBAL_AI_NAVWORLD = GLOBAL_AI_NAVWORLD
	local create_exclusive_box_obstacle_from_unit_data, var_209_3 = NavigationUtils.create_exclusive_box_obstacle_from_unit_data(GLOBAL_AI_NAVWORLD, unit)

	GwNavBoxObstacle.add_to_world(create_exclusive_box_obstacle_from_unit_data)
	GwNavBoxObstacle.set_transform(create_exclusive_box_obstacle_from_unit_data, var_209_3)
	GwNavBoxObstacle.set_does_trigger_tagvolume(create_exclusive_box_obstacle_from_unit_data, true)
end

function flow_callback_limited_item_spawner_group_register(self)
	-- function 210
	if not Managers.player.is_server then
		return
	end

	local name = self.name
	local pool_size = self.pool_size

	Managers.state.entity:system("limited_item_track_system"):register_group(name, pool_size)
end

function flow_callback_limited_item_spawner_group_decrease_pool_size(self)
	-- function 211
	if not Managers.player.is_server then
		return
	end

	local name = self.name
	local pool_size = self.pool_size

	Managers.state.entity:system("limited_item_track_system"):decrease_group_pool_size(name, pool_size)
end

function flow_callback_limited_item_spawner_group_activate(self)
	-- function 212
	if not Managers.player.is_server then
		return
	end

	local name = self.name
	local pool_size = self.pool_size

	Managers.state.entity:system("limited_item_track_system"):activate_group(name, pool_size)
end

function flow_callback_limited_item_spawner_group_deactivate(self)
	-- function 213
	if not Managers.player.is_server then
		return
	end

	local name = self.name

	Managers.state.entity:system("limited_item_track_system"):deactivate_group(name)
end

function flow_callback_decal_set_sort_order(self)
	-- function 214
	local unit = self.unit
	local sort_order = self.sort_order

	if not sort_order then
		Unit.set_sort_order(unit, sort_order)
	end
end

function flow_callback_blood_collision(self)
	-- function 215
	if Managers.state.decal ~= nil then
		local blood_ball_actor = self.blood_ball_actor
		local unit = Actor.unit(blood_ball_actor)
		local position = self.position
		local normal = self.normal
		local velocity = Actor.velocity(blood_ball_actor)
		local num = 1000

		if not (num < velocity.x or velocity.x < -num or num < velocity.y or velocity.y < -num or num < velocity.z or not (velocity.z < -num)) then
			velocity = Vector3(0, 0, -1)
		end

		local dot = Vector3.dot(normal, Vector3.normalize(velocity))
		local normalize = Vector3.normalize(Vector3.normalize(velocity) - dot * normal)
		local look = Quaternion.look(normalize, normal)
		local hit_unit = self.hit_unit
		local hit_actor = self.hit_actor

		if not Unit.alive(hit_unit) then
			local game_object_or_level_id, var_215_12 = Managers.state.network:game_object_or_level_id(hit_unit)

			if not var_215_12 then
				hit_unit = nil
				hit_actor = nil
			end
		end

		local str = "units/decals/projection_blood_" .. string.format("%02d", tostring(Math.random(1, 17)))
		local var_215_14 = Vector3(BloodSettings.blood_decals.scale, BloodSettings.blood_decals.scale, 1)

		Managers.state.decal:add_projection_decal(str, hit_unit, hit_actor, position, look, var_215_14, normal)
		Managers.state.blood:despawn_blood_ball(unit)
	end
end

function flow_callback_move_decals(self)
	-- function 216
	if not Managers.state.decal then
		local from_unit = self.from_unit
		local to_unit = self.to_unit

		Managers.state.decal:move_decals(from_unit, to_unit)
	end
end

function flow_callback_blood_ball_despawn(self)
	-- function 217
	if Managers.state.decal ~= nil then
		local unit = self.unit

		Managers.state.blood:despawn_blood_ball(unit)
	end
end

function flow_callback_blood_enabled()
	-- function 218
	if not Managers.state.blood then
		flow_return_table.enabled = Managers.state.blood:get_blood_enabled()
	else
		flow_return_table.enabled = false
	end

	return flow_return_table
end

function flow_callback_enable_poison_wind(self)
	-- function 219
	local unit = self.unit
	local enable = self.enable

	Managers.state.entity:system("area_damage_system"):enable_area_damage(unit, enable)
end

function flow_callback_objective_unit_set_active(self)
	-- function 220
	if not Managers.player.is_server then
		return
	end

	local unit = self.unit

	ScriptUnit.extension(unit, "tutorial_system"):set_active(self.active)
end

function flow_callback_objective_unit_set_active_generic(self)
	-- function 221
	if not Managers.player.is_server then
		return
	end

	local unit = self.unit
	local system_name = self.system_name

	ScriptUnit.extension(unit, system_name):set_active(self.active, self.unit)
end

local function fn_2()
	-- function 222
	return Managers.state.entity:system("objective_system")
end

function flow_callback_objective_get_num_current_main_objectives(arg_223_0)
	-- function 223
	local var_223_0 = fn_2()

	if not var_223_0 then
		return
	end

	flow_return_table.out_value = #var_223_0:active_objectives()

	return flow_return_table
end

function flow_callback_objective_get_total_main_objectives(arg_224_0)
	-- function 224
	local var_224_0 = fn_2()

	if not var_224_0 then
		return
	end

	flow_return_table.out_value = var_224_0:num_main_objectives()

	return flow_return_table
end

function flow_callback_objective_get_num_completed_main_objectives(arg_225_0)
	-- function 225
	local var_225_0 = fn_2()

	if not var_225_0 then
		return
	end

	flow_return_table.out_value = var_225_0:num_completed_main_objectives()

	return flow_return_table
end

function flow_callback_objective_get_current_completed_sub_objectives(arg_226_0)
	-- function 226
	local var_226_0 = fn_2()

	if not var_226_0 then
		return
	end

	flow_return_table.out_value = var_226_0:num_current_completed_sub_objectives()

	return flow_return_table
end

function flow_callback_objective_complete_current_objective_by_name(self)
	-- function 227
	if not Managers.player.is_server then
		return
	end

	local var_227_0 = fn_2()

	if not var_227_0 then
		return
	end

	var_227_0:complete_objective(self.name)
end

function flow_callback_umbra_set_gate_closed(self)
	-- function 228
	local unit = self.unit
	local world = Unit.world(unit)

	if not World.umbra_available(world) then
		local closed = self.closed

		World.umbra_set_gate_closed(world, unit, closed)
	end
end

local tbl_2 = {}

function flow_callback_external_broadphase_unit_event(self)
	-- function 229
	local source_unit = self.source_unit
	local radius = self.radius
	local target_breed = self.target_breed
	local event_name = self.event_name
	local value = self.value
	local broadphase_query = AiUtils.broadphase_query(Unit.world_position(source_unit, 0), radius or 5, tbl_2)
	local BLACKBOARDS = BLACKBOARDS

	for i = 1, broadphase_query do
		local var_229_7 = BLACKBOARDS[tbl_2[i]]

		if not (not var_229_7 and var_229_7.breed.name ~= target_breed) then
			var_229_7.external_event_name = event_name
			var_229_7.external_event_value = value
		end
	end

	table.clear(tbl_2)
end

function flow_callback_force_unit_animation(self)
	-- function 230
	local source_unit = self.source_unit
	local radius = self.radius
	local target_breed = self.target_breed
	local animation_event_name = self.animation_event_name
	local broadphase_query = AiUtils.broadphase_query(Unit.world_position(source_unit, 0), radius or 5, tbl_2)
	local BLACKBOARDS = BLACKBOARDS

	for i = 1, broadphase_query do
		local var_230_6 = tbl_2[i]
		local var_230_7 = BLACKBOARDS[var_230_6]

		if not (not var_230_7 and var_230_7.breed.name ~= target_breed) then
			Managers.state.network:anim_event(var_230_6, animation_event_name)
		end
	end

	table.clear(tbl_2)
end

function flow_callback_synced_animation(self)
	-- function 231
	local game = Managers.state.network:game()

	if not game then
		local unit = self.unit
		local animation_event = self.animation_event
		local unit_storage = Managers.state.unit_storage
		local go_id = unit_storage:go_id(unit)
		local game_object_field = GameSession.game_object_field(game, go_id, "animation_synced_unit_id")
		local unit_2 = unit_storage:unit(game_object_field)

		if not unit_2 and not animation_event and not Unit.has_animation_event(unit_2, animation_event) then
			Unit.animation_event(unit_2, animation_event)
		end
	end
end

function flow_callback_player_animation(self)
	-- function 232
	local character_type = self.character_type
	local animation_event = self.animation_event
	local human_and_bot_players = Managers.player:human_and_bot_players()

	for k, v in pairs(human_and_bot_players) do
		local display_name = SPProfiles[v:profile_index()].display_name
		local player_unit = v.player_unit

		if not player_unit and display_name ~= character_type or not Unit.has_animation_event(player_unit, animation_event) then
			Unit.animation_event(player_unit, animation_event)
		end
	end
end

function flow_callback_trigger_dialogue_story(self)
	-- function 233
	local unit = self.unit

	Managers.state.entity:system("dialogue_system"):trigger_story_dialogue(unit)
end

function flow_callback_trigger_cutscene_subtitles(self)
	-- function 234
	local subtitle_event = self.subtitle_event
	local speaker = self.speaker
	local end_delay = self.end_delay

	Managers.state.entity:system("dialogue_system"):trigger_cutscene_subtitles(subtitle_event, speaker, end_delay)
end

function flow_callback_trigger_event_with_subtitles(self)
	-- function 235
	local sound_event = self.sound_event
	local subtitle_event = self.subtitle_event
	local speaker = self.speaker

	Managers.state.entity:system("dialogue_system"):trigger_sound_event_with_subtitles(sound_event, subtitle_event, speaker)
end

function flow_callback_trigger_event_with_unit_and_subtitles(self)
	-- function 236
	local sound_event = self.sound_event
	local subtitle_event = self.subtitle_event
	local speaker = self.speaker
	local source_unit = self.source_unit
	local unit_node = self.unit_node

	Managers.state.entity:system("dialogue_system"):trigger_sound_event_with_subtitles(sound_event, subtitle_event, speaker, source_unit, unit_node)
end

function flow_callback_trigger_random_event_with_unit_and_subtitles(self)
	-- function 237
	local tbl = {
		self.sound_event01,
		self.sound_event02,
		self.sound_event03,
		self.sound_event04,
		self.sound_event05,
		self.sound_event06,
		self.sound_event07,
		self.sound_event08,
		self.sound_event09,
		self.sound_event10,
		self.sound_event11,
		self.sound_event12,
		self.sound_event13,
		self.sound_event14,
		self.sound_event15,
		self.sound_event16,
		self.sound_event17,
		self.sound_event18,
		self.sound_event19,
		self.sound_event20
	}
	local var_237_1 = tbl[math.random(#tbl)]
	local var_237_2 = var_237_1
	local speaker = self.speaker
	local source_unit = self.source_unit
	local unit_node = self.unit_node

	Managers.state.entity:system("dialogue_system"):trigger_sound_event_with_subtitles(var_237_1, var_237_2, speaker, source_unit, unit_node)
end

function flow_callback_override_start_dialogue_system()
	-- function 238
	Managers.state.entity:system("dialogue_system").players_ready = true
end

function flow_callback_override_stop_dialogue_system()
	-- function 239
	Managers.state.entity:system("dialogue_system").players_ready = false
end

function flow_callback_override_start_delay()
	-- function 240
	DialogueSettings.dialogue_level_start_delay = 0
end

function flow_callback_damage_unit(self)
	-- function 241
	if not Managers.player.is_server then
		return
	end

	local unit = self.unit
	local damage = self.damage

	if not alive(unit) then
		fassert(ScriptUnit.has_extension(unit, "health_system"), "Tried to damage unit %s from flow but the unit has no health extension", unit)

		local str = "full"
		local world_position = Unit.world_position(unit, 0)
		local up = Vector3.up()

		ScriptUnit.extension(unit, "health_system"):add_damage(unit, damage, str, "destructible_level_object_hit", world_position, up, "wounded_degen", nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
	end
end

function flow_callback_set_material_property_scalar_all(self)
	-- function 242
	local unit = self.unit
	local variable = self.variable
	local value = self.value
	local index_offset = Script.index_offset()
	local num = 1 - index_offset
	local num_meshes = Unit.num_meshes(unit)

	for i = index_offset, num_meshes - num do
		local mesh = Unit.mesh(unit, i)
		local num_materials = Mesh.num_materials(mesh)

		for j = index_offset, num_materials - num do
			local material = Mesh.material(mesh, j)

			Material.set_scalar(material, variable, value)
		end
	end
end

function flow_callback_material_scalar_set_chr_inventory(self)
	-- function 243
	fassert(self.unit, "[flow_callback_material_scalar_set_chr_inventory] You need to specify the Unit")
	fassert(self.variable, "[flow_callback_material_scalar_set_chr_inventory] You need to specify variable value")
	fassert(self.value, "[flow_callback_material_scalar_set_chr_inventory] You need to specify variable name")

	local unit = self.unit
	local has_extension = ScriptUnit.has_extension(unit, "ai_inventory_system")

	if has_extension ~= nil then
		for i = 1, #has_extension.inventory_item_units do
			self.unit = has_extension.inventory_item_units[i]

			flow_callback_set_material_property_scalar_all(self)
		end
	end
end

function do_material_dissolve(arg_244_0, arg_244_1, arg_244_2, arg_244_3, arg_244_4)
	-- function 244
	Material.set_scalar(arg_244_0, arg_244_3, arg_244_4)
	Material.set_vector2(arg_244_0, arg_244_1, arg_244_2)
end

function flow_callback_material_dissolve(self)
	-- function 245
	fassert(self.unit, "[flow_callback_material_dissolve] You need to specify the Unit")
	fassert(self.duration, "[flow_callback_material_dissolve] You need to specify duration")

	local timer_var_name = self.timer_var_name

	timer_var_name = timer_var_name or "dissolve_timer"

	local time = World.time(Application.main_world())
	local var_245_2 = Vector2(time, time + self.duration)
	local dissolve_start_state_var_name = self.dissolve_start_state_var_name

	dissolve_start_state_var_name = dissolve_start_state_var_name or "dissolve_start_value"

	local floor = math.floor
	local num = 0.5 + self.dissolve_start_state

	num = num or 1

	local var_245_6 = floor(num)
	local unit = self.unit
	local var_245_8
	local mesh_name = self.mesh_name

	if not mesh_name then
		fassert(Unit.has_mesh(unit, mesh_name), string.format("[flow_callback_material_dissolve] The mesh %s doesn't exist in unit %s", mesh_name, tostring(unit)))

		var_245_8 = Unit.mesh(unit, mesh_name)
	end

	local var_245_10
	local material_name = self.material_name

	if not var_245_8 and not material_name then
		fassert(Mesh.has_material(var_245_8, material_name), string.format("[flow_callback_material_dissolve] The material %s doesn't exist for mesh %s", mesh_name, material_name))

		var_245_10 = Mesh.material(var_245_8, material_name)
	end

	if not var_245_8 and not var_245_10 then
		do_material_dissolve(var_245_10, timer_var_name, var_245_2, dissolve_start_state_var_name, var_245_6)
	elseif not var_245_8 then
		local num_materials = Mesh.num_materials(var_245_8)

		for i = 0, num_materials - 1 do
			do_material_dissolve(Mesh.material(var_245_8, i), timer_var_name, var_245_2, dissolve_start_state_var_name, var_245_6)
		end
	elseif not material_name then
		local num_meshes = Unit.num_meshes(unit)

		for j = 0, num_meshes - 1 do
			local mesh = Unit.mesh(unit, j)

			if not Mesh.has_material(mesh, material_name) then
				do_material_dissolve(Mesh.material(mesh, material_name), timer_var_name, var_245_2, dissolve_start_state_var_name, var_245_6)
			end
		end
	else
		local num_meshes_2 = Unit.num_meshes(unit)

		for k = 0, num_meshes_2 - 1 do
			local mesh_2 = Unit.mesh(unit, k)
			local num_materials_2 = Mesh.num_materials(mesh_2)

			for l = 0, num_materials_2 - 1 do
				do_material_dissolve(Mesh.material(mesh_2, l), timer_var_name, var_245_2, dissolve_start_state_var_name, var_245_6)
			end
		end
	end
end

function flow_callback_material_dissolve_chr(self)
	-- function 246
	fassert(self.unit, "[flow_callback_material_dissolve_chr] You need to specify the Unit")
	fassert(self.duration, "[flow_callback_material_dissolve_chr] You need to specify duration")
	flow_callback_material_dissolve(self)

	local unit = self.unit
	local has_extension = ScriptUnit.has_extension(unit, "ai_inventory_system")

	if has_extension ~= nil then
		for i = 1, #has_extension.stump_items do
			self.unit = has_extension.stump_items[i]

			flow_callback_material_dissolve(self)
		end

		for j = 1, #has_extension.inventory_item_outfit_units do
			self.unit = has_extension.inventory_item_outfit_units[j]

			flow_callback_material_dissolve(self)
		end

		for k = 1, #has_extension.inventory_item_helmet_units do
			self.unit = has_extension.inventory_item_helmet_units[k]

			flow_callback_material_dissolve(self)
		end

		if has_extension.inventory_item_skin_unit ~= nil then
			self.unit = has_extension.inventory_item_skin_unit

			flow_callback_material_dissolve(self)
		end
	end
end

function flow_callback_material_dissolve_chr_inventory(self)
	-- function 247
	fassert(self.unit, "[flow_callback_material_dissolve_chr_inventory] You need to specify the Unit")
	fassert(self.duration, "[flow_callback_material_dissolve_chr_inventory] You need to specify duration")
	fassert(self.inventory_type, "[flow_callback_material_dissolve_chr_inventory] You need to specify inventory type")

	local unit = self.unit
	local has_extension = ScriptUnit.has_extension(unit, "ai_inventory_system")

	if has_extension ~= nil then
		if self.inventory_type == "outfit" then
			for i = 1, #has_extension.inventory_item_outfit_units do
				self.unit = has_extension.inventory_item_outfit_units[i]

				flow_callback_material_dissolve(self)
			end
		elseif self.inventory_type == "stump" then
			for j = 1, #has_extension.stump_items do
				self.unit = has_extension.stump_items[j]

				flow_callback_material_dissolve(self)
			end
		elseif self.inventory_type == "helmet" then
			for k = 1, #has_extension.inventory_item_helmet_units do
				self.unit = has_extension.inventory_item_helmet_units[k]

				flow_callback_material_dissolve(self)
			end
		elseif self.inventory_type == "weapon" then
			for l = 1, #has_extension.inventory_item_weapon_units do
				self.unit = has_extension.inventory_item_weapon_units[l]

				flow_callback_material_dissolve(self)
			end
		elseif not (self.inventory_type ~= "skin" or has_extension.inventory_item_skin_unit == nil) then
			self.unit = has_extension.inventory_item_skin_unit

			flow_callback_material_dissolve(self)
		end
	end
end

function do_material_fade(arg_248_0, arg_248_1, arg_248_2, arg_248_3, arg_248_4)
	-- function 248
	Material.set_vector2(arg_248_0, arg_248_3, arg_248_4)
	Material.set_vector2(arg_248_0, arg_248_1, arg_248_2)
end

function flow_callback_material_fade(self)
	-- function 249
	fassert(self.unit, "[flow_callback_material_fade] You need to specify the Unit")
	fassert(self.duration, "[flow_callback_material_fade] You need to specify duration")

	local timer_var_name = self.timer_var_name

	timer_var_name = timer_var_name or "fade_timer"

	local time = World.time(Application.main_world())
	local var_249_2 = Vector2(time, time + self.duration)
	local fade_range_var_name = self.fade_range_var_name

	fade_range_var_name = fade_range_var_name or "fade_interval"

	local Vector2 = Vector2
	local fade_range_from = self.fade_range_from

	fade_range_from = fade_range_from or 1

	local fade_range_to = self.fade_range_to

	fade_range_to = fade_range_to or 0

	local var_249_7 = Vector2(fade_range_from, fade_range_to)
	local unit = self.unit
	local var_249_9
	local mesh_name = self.mesh_name

	if not mesh_name then
		fassert(Unit.has_mesh(unit, mesh_name), string.format("[flow_callback_material_fade] The mesh %s doesn't exist in unit %s", mesh_name, tostring(unit)))

		var_249_9 = Unit.mesh(unit, mesh_name)
	end

	local var_249_11
	local material_name = self.material_name

	if not var_249_9 and not material_name then
		fassert(Mesh.has_material(var_249_9, material_name), string.format("[flow_callback_material_fade] The material %s doesn't exist for mesh %s", mesh_name, material_name))

		var_249_11 = Mesh.material(var_249_9, material_name)
	end

	if not var_249_9 and not var_249_11 then
		do_material_fade(var_249_11, timer_var_name, var_249_2, fade_range_var_name, var_249_7)
	elseif not var_249_9 then
		local num_materials = Mesh.num_materials(var_249_9)

		for i = 0, num_materials - 1 do
			do_material_fade(Mesh.material(var_249_9, i), timer_var_name, var_249_2, fade_range_var_name, var_249_7)
		end
	elseif not material_name then
		local num_meshes = Unit.num_meshes(unit)

		for j = 0, num_meshes - 1 do
			local mesh = Unit.mesh(unit, j)

			if not Mesh.has_material(mesh, material_name) then
				do_material_fade(Mesh.material(mesh, material_name), timer_var_name, var_249_2, fade_range_var_name, var_249_7)
			end
		end
	else
		local num_meshes_2 = Unit.num_meshes(unit)

		for k = 0, num_meshes_2 - 1 do
			local mesh_2 = Unit.mesh(unit, k)
			local num_materials_2 = Mesh.num_materials(mesh_2)

			for l = 0, num_materials_2 - 1 do
				do_material_fade(Mesh.material(mesh_2, l), timer_var_name, var_249_2, fade_range_var_name, var_249_7)
			end
		end
	end
end

function flow_callback_material_fade_chr(self)
	-- function 250
	fassert(self.unit, "[flow_callback_material_fade_chr] You need to specify the Unit")
	fassert(self.duration, "[flow_callback_material_fade_chr] You need to specify duration")
	flow_callback_material_fade(self)

	local unit = self.unit

	self.mesh_name = nil

	local has_extension = ScriptUnit.has_extension(unit, "ai_inventory_system")

	if has_extension ~= nil then
		for i = 1, #has_extension.stump_items do
			self.unit = has_extension.stump_items[i]

			flow_callback_material_fade(self)
		end

		for j = 1, #has_extension.inventory_item_outfit_units do
			self.unit = has_extension.inventory_item_outfit_units[j]

			flow_callback_material_fade(self)
		end

		for k = 1, #has_extension.inventory_item_helmet_units do
			self.unit = has_extension.inventory_item_helmet_units[k]

			flow_callback_material_fade(self)
		end

		if has_extension.inventory_item_skin_unit ~= nil then
			self.unit = has_extension.inventory_item_skin_unit

			flow_callback_material_fade(self)
		end
	end
end

function flow_callback_material_fade_chr_inventory(self)
	-- function 251
	fassert(self.unit, "[flow_callback_material_fade_chr_inventory] You need to specify the Unit")
	fassert(self.duration, "[flow_callback_material_fade_chr_inventory] You need to specify duration")
	fassert(self.inventory_type, "[flow_callback_material_fade_chr_inventory] You need to specify inventory type")

	local unit = self.unit

	self.mesh_name = nil

	local has_extension = ScriptUnit.has_extension(unit, "ai_inventory_system")

	if has_extension ~= nil then
		if self.inventory_type == "outfit" then
			for i = 1, #has_extension.inventory_item_outfit_units do
				self.unit = has_extension.inventory_item_outfit_units[i]

				flow_callback_material_fade(self)
			end
		elseif self.inventory_type == "weapon" then
			for j = 1, #has_extension.inventory_item_weapon_units do
				self.unit = has_extension.inventory_item_weapon_units[j]

				flow_callback_material_fade(self)
			end
		elseif self.inventory_type == "stump" then
			for k = 1, #has_extension.stump_items do
				self.unit = has_extension.stump_items[k]

				flow_callback_material_fade(self)
			end
		elseif self.inventory_type == "helmet" then
			for l = 1, #has_extension.inventory_item_helmet_units do
				self.unit = has_extension.inventory_item_helmet_units[l]

				flow_callback_material_fade(self)
			end
		elseif not (self.inventory_type ~= "skin" or has_extension.inventory_item_skin_unit == nil) then
			self.unit = has_extension.inventory_item_skin_unit

			flow_callback_material_fade(self)
		end
	end
end

function flow_callback_visibility_chr_inventory(self)
	-- function 252
	fassert(self.unit, "[flow_callback_visibility_chr_inventory] You need to specify the Unit")

	local unit = self.unit
	local visibility = self.visibility
	local has_extension = ScriptUnit.has_extension(unit, "ai_inventory_system")

	if has_extension ~= nil then
		for i = 1, #has_extension.inventory_item_outfit_units do
			local var_252_3 = has_extension.inventory_item_outfit_units[i]

			Unit.set_unit_visibility(var_252_3, visibility)
			print("Hide " .. Unit.debug_name(var_252_3))
		end

		for j = 1, #has_extension.inventory_item_weapon_units do
			local var_252_4 = has_extension.inventory_item_weapon_units[j]

			Unit.set_unit_visibility(var_252_4, visibility)
			print("Hide " .. Unit.debug_name(var_252_4))
		end

		for k = 1, #has_extension.stump_items do
			local var_252_5 = has_extension.stump_items[k]

			Unit.set_unit_visibility(var_252_5, visibility)
			print("Hide " .. Unit.debug_name(var_252_5))
		end

		for l = 1, #has_extension.inventory_item_helmet_units do
			local var_252_6 = has_extension.inventory_item_helmet_units[l]

			Unit.set_unit_visibility(var_252_6, visibility)
			print("Hide " .. Unit.debug_name(var_252_6))
		end

		if has_extension.inventory_item_skin_unit ~= nil then
			local inventory_item_skin_unit = has_extension.inventory_item_skin_unit

			Unit.set_unit_visibility(inventory_item_skin_unit, visibility)
		end
	end
end

function flow_callback_get_chr_inventory_skin_unit(self)
	-- function 253
	fassert(self.unit, "[flow_callback_get_chr_inventory_skin_unit] You need to specify the Unit")

	local unit = self.unit
	local has_extension = ScriptUnit.has_extension(unit, "ai_inventory_system")
	local var_253_2

	if not (has_extension == nil or has_extension.inventory_item_skin_unit == nil) then
		var_253_2 = has_extension.inventory_item_skin_unit
	end

	fassert(var_253_2, "[flow_callback_get_chr_inventory_skin_unit] No skin found for unit ", tostring(unit))

	flow_return_table.skin_unit = var_253_2

	return flow_return_table
end

function start_material_fade(arg_254_0, arg_254_1, arg_254_2, arg_254_3, arg_254_4, arg_254_5, arg_254_6, arg_254_7, arg_254_8)
	-- function 254
	if not arg_254_5 and not arg_254_6 then
		Material.set_scalar(arg_254_0, arg_254_5, arg_254_6)
	end

	if not arg_254_7 and not arg_254_8 then
		Material.set_scalar(arg_254_0, arg_254_7, arg_254_8)
	end

	Material.set_scalar(arg_254_0, arg_254_1, arg_254_2)
	Material.set_vector2(arg_254_0, arg_254_3, arg_254_4)
end

function flow_callback_start_fade(self)
	-- function 255
	fassert(self.unit, "[flow_callback_start_fade] You need to specify the Unit")
	fassert(self.duration, "[flow_callback_start_fade] You need to specify duration")
	fassert(self.fade_switch, "[flow_callback_start_fade] You need to specify whether to fade in or out (0 or 1)")

	local time = World.time(Application.main_world())
	local var_255_1 = Vector2(time, time + self.duration)
	local floor = math.floor(self.fade_switch + 0.5)
	local fade_switch_name = self.fade_switch_name

	fade_switch_name = fade_switch_name or "fade_switch"

	local start_end_time_name = self.start_end_time_name

	start_end_time_name = start_end_time_name or "start_end_time"

	local unit = self.unit
	local var_255_6
	local mesh_name = self.mesh_name
	local start_fade_value_name = self.start_fade_value_name

	start_fade_value_name = start_fade_value_name or nil

	local start_fade_value = self.start_fade_value

	start_fade_value = start_fade_value or nil

	local end_fade_value_name = self.end_fade_value_name

	end_fade_value_name = end_fade_value_name or nil

	local end_fade_value = self.end_fade_value

	end_fade_value = end_fade_value or nil

	if not mesh_name then
		fassert(Unit.has_mesh(unit, mesh_name), string.format("[flow_callback_start_fade] The mesh %s doesn't exist in unit %s", mesh_name, tostring(unit)))

		var_255_6 = Unit.mesh(unit, mesh_name)
	end

	local var_255_12
	local material_name = self.material_name

	if not var_255_6 and not material_name then
		fassert(Mesh.has_material(var_255_6, material_name), string.format("[flow_callback_start_fade] The material %s doesn't exist for mesh %s", mesh_name, material_name))

		var_255_12 = Mesh.material(var_255_6, material_name)
	end

	if not var_255_6 and not var_255_12 then
		start_material_fade(var_255_12, fade_switch_name, floor, start_end_time_name, var_255_1, start_fade_value_name, start_fade_value, end_fade_value_name, end_fade_value)
	elseif not var_255_6 then
		local num_materials = Mesh.num_materials(var_255_6)

		for i = 0, num_materials - 1 do
			local material = Mesh.material(var_255_6, i)

			start_material_fade(material, fade_switch_name, floor, start_end_time_name, var_255_1, start_fade_value_name, start_fade_value, end_fade_value_name, end_fade_value)
		end
	elseif not material_name then
		local num_meshes = Unit.num_meshes(unit)

		for j = 0, num_meshes - 1 do
			local mesh = Unit.mesh(unit, j)

			if not Mesh.has_material(mesh, material_name) then
				local material_2 = Mesh.material(mesh, material_name)

				start_material_fade(material_2, fade_switch_name, floor, start_end_time_name, var_255_1, start_fade_value_name, start_fade_value, end_fade_value_name, end_fade_value)
			end
		end
	else
		local num_meshes_2 = Unit.num_meshes(unit)

		for k = 0, num_meshes_2 - 1 do
			local mesh_2 = Unit.mesh(unit, k)
			local num_materials_2 = Mesh.num_materials(mesh_2)

			for l = 0, num_materials_2 - 1 do
				local material_3 = Mesh.material(mesh_2, l)

				start_material_fade(material_3, fade_switch_name, floor, start_end_time_name, var_255_1, start_fade_value_name, start_fade_value, end_fade_value_name, end_fade_value)
			end
		end
	end
end

function flow_callback_force_death_end(self)
	-- function 256
	if not Managers.state.network.is_server and not ScriptUnit.has_extension(self.unit, "death_system") then
		ScriptUnit.extension(self.unit, "death_system"):force_end()
	end
end

function flow_callback_chr_editor_inventory_spawn(arg_257_0)
	-- function 257
	return {
		spawn = true
	}
end

function flow_callback_chr_editor_inventory_unspawn(arg_258_0)
	-- function 258
	return {
		unspawn = true
	}
end

function flow_callback_chr_editor_inventory_drop(arg_259_0)
	-- function 259
	return {
		dropped = true
	}
end

function flow_callback_chr_enemy_inventory_send_event(self)
	-- function 260
	fassert(self.unit, "[flow_callback_chr_enemy_inventory_send_event] You need to specify the Unit")
	fassert(self.event, "[flow_callback_chr_enemy_inventory_send_event] You need to specify an event name")

	local unit = self.unit
	local event = self.event
	local has_extension = ScriptUnit.has_extension(unit, "ai_inventory_system")

	if has_extension ~= nil then
		for i = 1, #has_extension.stump_items do
			Unit.flow_event(has_extension.stump_items[i], event)
		end

		for j = 1, #has_extension.inventory_item_units do
			Unit.flow_event(has_extension.inventory_item_units[j], event)
		end
	end
end

function flow_callback_unit_spawner_spawn_local_unit(self)
	-- function 261
	local unit = self.unit
	local position = self.position

	position = position or Vector3(0, 0, 0)

	local rotation = self.rotation

	rotation = rotation or Quaternion.identity()

	local scale = self.scale

	scale = scale or Vector3(1, 1, 1)

	local from_quaternion_position = Matrix4x4.from_quaternion_position(rotation, position)

	Matrix4x4.set_scale(from_quaternion_position, scale)

	local spawn_local_unit = Managers.state.unit_spawner:spawn_local_unit(unit, from_quaternion_position)

	return {
		spawned = true,
		spawned_unit = spawn_local_unit
	}
end

function flow_callback_unit_spawner_mark_for_deletion(self)
	-- function 262
	if not alive(self.unit) then
		return
	end

	local fassert = fassert
	local is_server = Managers.state.network.is_server

	is_server = is_server or not NetworkUnit.is_network_unit(self.unit)

	fassert(is_server, "'flow_callback_unit_spawner_mark_for_deletion' can only delete units spawned locally on client")
	Managers.state.unit_spawner:mark_for_deletion(self.unit)
end

function flow_callback_breakable_object_destroyed(self)
	-- function 263
	local unit = self.unit

	if not alive(unit) then
		if not Unit.get_data(unit, "destroyed_dynamic") then
			return
		end

		local statistics_db = Managers.player:statistics_db()
		local local_player = Managers.player:local_player()

		if not local_player then
			return
		end

		local stats_id = local_player:stats_id()

		statistics_db:increment_stat(stats_id, "dynamic_objects_destroyed")
		Unit.set_data(unit, "destroyed_dynamic", true)
	end
end

function flow_callback_send_local_system_message(self)
	-- function 264
	local message = self.message
	local flag = true

	Managers.chat:add_local_system_message(1, message, flag)
end

function flow_callback_localize_string(self)
	-- function 265
	flow_return_table.value = Localize(self.string)

	return flow_return_table
end

function flow_callback_increment_player_stat(self)
	-- function 266
	local local_player = Managers.player:local_player()

	if not local_player then
		return
	end

	local statistics_db = Managers.player:statistics_db()
	local stats_id = local_player:stats_id()
	local stat_name = self.stat_name
	local split = string.split(stat_name, "|")

	statistics_db:increment_stat(stats_id, unpack(split))
end

local tbl_3 = {
	"rpc_increment_stat",
	"rpc_increment_stat_2",
	"rpc_increment_stat_3"
}

function flow_callback_increment_all_players_stats(self)
	-- function 267
	local local_player = Managers.player:local_player()

	if not local_player then
		return
	end

	local statistics_db = Managers.player:statistics_db()
	local stats_id = local_player:stats_id()
	local stat_name = self.stat_name
	local split, var_267_5 = string.split(stat_name, "|")

	statistics_db:increment_stat(stats_id, unpack(split))

	local var_267_6 = tbl_3[var_267_5]

	fassert(var_267_6, "Syncing incrementing stat with %s number of arguments is not supported")

	for i = 1, var_267_5 do
		split[i] = NetworkLookup.statistics[stat_name]
	end

	Managers.state.network.network_transmit:send_rpc_clients("rpc_increment_stat", unpack(split))
end

function flow_callback_set_player_stat(self)
	-- function 268
	local local_player = Managers.player:local_player()

	if not local_player then
		return
	end

	local statistics_db = Managers.player:statistics_db()
	local stats_id = local_player:stats_id()
	local stat_name = self.stat_name
	local stat_value = self.stat_value
	local split, var_268_6 = string.split(stat_name, "|")

	split[var_268_6 + 1] = stat_value

	statistics_db:set_stat(stats_id, unpack(split))
end

function flow_callback_add_subtitle(self)
	-- function 269
	local speaker = self.speaker
	local subtitle = self.subtitle

	Managers.state.entity:system("hud_system"):add_subtitle(speaker, subtitle)
end

function flow_callback_remove_subtitle(self)
	-- function 270
	local speaker = self.speaker

	Managers.state.entity:system("hud_system"):remove_subtitle(speaker)
end

function flow_callback_fade_in_game_logo(self)
	-- function 271
	local time = self.time
	local system = Managers.state.entity:system("cutscene_system")

	if not system then
		system:fade_game_logo(true, time)
	end
end

function flow_callback_fade_out_game_logo(self)
	-- function 272
	local time = self.time
	local system = Managers.state.entity:system("cutscene_system")

	if not system then
		system:fade_game_logo(false, time)
	end
end

function flow_callback_register_main_path_obstacle(self)
	-- function 273
	local conflict = Managers.state.conflict

	if not conflict then
		local unit = self.unit
		local unit_node = self.unit_node
		local world_position = Unit.world_position(unit, Unit.node(unit, unit_node))
		local box, var_273_5 = Unit.box(unit)
		local distance_squared = Vector3.distance_squared(Vector3(0, 0, 0), var_273_5)

		conflict:register_main_path_obstacle(Vector3Box(world_position), distance_squared)
	end
end

function flow_callback_enter_post_game(arg_274_0)
	-- function 274
	local network_server = Managers.state.network.network_server

	if not network_server then
		network_server:enter_post_game()
		print("flow_callback_enter_post_game")
	end
end

function flow_query_settings_data(self)
	-- function 275
	local setting = self.setting

	if not GameSettingsDevelopment then
		print("No GameSettingsDevelopment, running in editor")

		return
	end

	local var_275_1 = GameSettingsDevelopment[setting]

	flow_return_table.value = var_275_1

	return flow_return_table
end

function flow_callback_survival_handler(self)
	-- function 276
	fassert(self.name, "[flow_callback_survival_handler] You need to specify the name of the waves preset found in survival settings")
	fassert(SurvivalSettings[self.name], "Could not find the waves preset you specified, you sure it's the same as in survival settings?")

	local num = SurvivalSettings.wave + 1
	local memory = SurvivalSettings.memory
	local templates = SurvivalSettings.templates
	local var_276_3 = SurvivalSettings[self.name].waves[num]
	local var_276_4
	local flag = true
	local flag_2 = false

	if var_276_3 ~= nil then
		for i, v in ipairs(var_276_3) do
			local random = math.random(1, #templates[v])

			if memory[templates[v][random]] ~= true then
				memory[templates[v][random]] = true
				var_276_4 = templates[v][random]
			else
				flag = false

				for k = 1, #templates[v] do
					if k ~= random then
						flag = true
						memory[templates[v][k]] = true
						var_276_4 = templates[v][k]

						break
					end
				end
			end
		end

		if var_276_3.reset ~= nil then
			for i_2, v_2 in ipairs(var_276_3.reset) do
				for i5 = 1, #templates[v_2] do
					memory[templates[v_2][i5]] = nil
				end
			end
		end

		if not flag and Managers.player.is_server and not LEVEL_EDITOR_TEST then
			TerrorEventMixer.start_random_event(var_276_4)
		end
	end

	local var_276_8 = num
	local count = #SurvivalSettings[self.name].waves

	if num >= #SurvivalSettings[self.name].waves then
		SurvivalSettings.memory = {}
		num = SurvivalSettings.re_loop_wave
	end

	SurvivalSettings.wave = num

	return {
		current_wave = var_276_8,
		total_num_waves = count,
		last_wave = flag_2
	}
end

function flow_callback_survival_handler_reset(self)
	-- function 277
	local tbl = {}
	local difficulty = self.difficulty
	local var_277_2 = SurvivalStartWaveByDifficulty[difficulty]

	SurvivalSettings.initial_wave = var_277_2
	SurvivalSettings.wave = var_277_2
	SurvivalSettings.memory = tbl

	return {
		initial_wave = var_277_2 + 1
	}
end

function flow_callback_set_difficulty(self)
	-- function 278
	Managers.state.difficulty:set_difficulty(self.difficulty, 0)
end

function flow_callback_show_difficulty(self)
	-- function 279
	fassert(self.difficulty, "No difficulty set")

	local player_unit = Managers.player:local_player().player_unit

	if not alive(player_unit) then
		ScriptUnit.extension(player_unit, "hud_system"):set_current_location(Localize("dlc1_2_survival_difficulty_increase") .. " " .. Localize("difficulty_" .. self.difficulty))
	end
end

function flow_callback_get_difficulty(arg_280_0)
	-- function 280
	local var_280_0
	local var_280_1
	local var_280_2
	local var_280_3
	local var_280_4
	local var_280_5
	local var_280_6
	local var_280_7
	local get_difficulty = Managers.state.difficulty:get_difficulty()

	if get_difficulty == "easy" then
		var_280_0 = true
	end

	if get_difficulty == "normal" then
		var_280_1 = true
	end

	if get_difficulty == "hard" then
		var_280_2 = true
	end

	if get_difficulty == "cataclysm" then
		var_280_3 = true
	end

	if get_difficulty == "harder" then
		var_280_4 = true
	end

	if get_difficulty == "cataclysm_2" then
		var_280_6 = true
	end

	if get_difficulty == "hardest" then
		var_280_5 = true
	end

	if get_difficulty == "cataclysm_3" then
		var_280_7 = true
	end

	flow_return_table.easy = var_280_0
	flow_return_table.normal = var_280_1
	flow_return_table.hard = var_280_2
	flow_return_table.cataclysm = var_280_3
	flow_return_table.harder = var_280_4
	flow_return_table.cataclysm_2 = var_280_6
	flow_return_table.hardest = var_280_5
	flow_return_table.cataclysm_3 = var_280_7
	flow_return_table.difficulty = get_difficulty

	return flow_return_table
end

function flow_callback_enable_end_level_area(self)
	-- function 281
	local game_mode = Managers.state.game_mode

	if not game_mode.is_server then
		local unit = self.unit
		local object = self.object
		local num = -self.left_back_down_extents
		local right_forward_up_extents = self.right_forward_up_extents

		game_mode:activate_end_level_area(unit, object, num, right_forward_up_extents)
	end
end

function flow_callback_debug_end_level_area(self)
	-- function 282
	local game_mode = Managers.state.game_mode

	if not game_mode.is_server then
		local unit = self.unit
		local object = self.object
		local num = -self.left_back_down_extents
		local right_forward_up_extents = self.right_forward_up_extents

		game_mode:debug_end_level_area(unit, object, num, right_forward_up_extents)
	end
end

function flow_callback_disable_end_level_area(self)
	-- function 283
	local game_mode = Managers.state.game_mode

	if not game_mode.is_server then
		game_mode:disable_end_level_area(self.unit)
	end
end

function flow_callback_disable_lose_condition()
	-- function 284
	Managers.state.game_mode:disable_lose_condition()
end

local tbl_4 = {}

function flow_callback_broadphase_deal_damage(self)
	-- function 285
	fassert(Managers.state.network.is_server, "Only deal damage on server.")

	local str = "torso"
	local var_285_1
	local position = self.position
	local radius = self.radius
	local attacker_unit = self.attacker_unit
	local hazard_type = self.hazard_type
	local var_285_6

	if not alive(attacker_unit) then
		local world_rotation = Unit.world_rotation(attacker_unit, 0)
		local direction = self.direction

		var_285_6 = Quaternion.right(world_rotation) * direction.x + Quaternion.forward(world_rotation) * direction.y + Quaternion.up(world_rotation) * direction.z
	else
		var_285_6 = self.direction
	end

	local var_285_9 = EnvironmentalHazards[hazard_type]

	if not self.hits_enemies then
		local time = Managers.time:time("game")
		local var_285_11 = hazard_type
		local get_difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
		local var_285_13 = var_285_9.enemy.difficulty_power_level[get_difficulty_rank]

		if not var_285_13 then
			var_285_13 = var_285_9.enemy.difficulty_power_level[2]
			var_285_13 = var_285_13 or DefaultPowerLevel
		end

		local damage_profile = var_285_9.enemy.damage_profile

		damage_profile = damage_profile or "default"

		local var_285_15 = DamageProfileTemplates[damage_profile]
		local var_285_16
		local num = 0
		local flag = false
		local can_damage = var_285_9.enemy.can_damage
		local can_stagger = var_285_9.enemy.can_stagger
		local flag_2 = false
		local flag_3 = false
		local broadphase_query = AiUtils.broadphase_query(position, radius, tbl_4)

		for i = 1, broadphase_query do
			local var_285_24 = tbl_4[i]

			DamageUtils.server_apply_hit(time, attacker_unit, var_285_24, str, nil, Vector3.normalize(var_285_6), var_285_1, var_285_11, var_285_13, var_285_15, var_285_16, num, flag, can_damage, can_stagger, flag_2, flag_3)
		end
	end

	local hits_human_players = self.hits_human_players
	local hits_bot_players = self.hits_bot_players

	if hits_human_players or not hits_bot_players or not var_285_9.player then
		local player = var_285_9.player
		local action_data = player.action_data
		local get_difficulty = Managers.state.difficulty:get_difficulty()
		local var_285_30 = player.difficulty_damage[get_difficulty]

		for k, v in pairs(Managers.player:players()) do
			local is_player_controlled = v:is_player_controlled()
			local player_unit = v.player_unit

			if not ((not hits_bot_players and is_player_controlled or not hits_human_players) and not is_player_controlled and not alive(player_unit) and not (radius > Vector3.distance(position, POSITION_LOOKUP[player_unit]))) then
				AiUtils.damage_target(player_unit, attacker_unit, action_data, var_285_30, hazard_type)
			end
		end
	end
end

function flow_callback_broadphase_deal_damage_debug(self)
	-- function 286
	local hits_enemies = self.hits_enemies
	local hits_human_players = self.hits_human_players
	local hits_bot_players = self.hits_bot_players

	if not hits_enemies then
		QuickDrawerStay:sphere(self.position, self.radius, Color(255, 0, 0))
	end

	if not hits_human_players then
		QuickDrawerStay:sphere(self.position, self.radius + 0.01, Color(0, 255, 0))
	end

	if not hits_bot_players then
		QuickDrawerStay:sphere(self.position, self.radius + 0.02, Color(0, 0, 255))
	end
end

function flow_callback_set_particles_light_intensity_exponent(self)
	-- function 287
	local exponent = self.exponent
	local id = self.id
	local flow_callback_context_world = Application.flow_callback_context_world()

	World.set_particles_light_intensity_exponent(flow_callback_context_world, id, exponent)
end

function flow_callback_set_camera_far_range(self)
	-- function 288
	if not DEDICATED_SERVER then
		return
	end

	local world_name = self.world_name
	local viewport_name = self.viewport_name
	local far_range = self.far_range
	local world = Managers.world:world(world_name)

	fassert(world, "[flow_callback_set_camera_far_range] There is currently no world called %s", world_name)

	local var_288_4 = World.get_data(world, "viewports")[viewport_name]

	fassert(world, "[flow_callback_set_camera_far_range] There is currently no viewport called %s in world %s", viewport_name, world_name)
	fassert(far_range, "[flow_callback_set_camera_far_range] No far range provided", far_range)

	local camera = ScriptViewport.camera(var_288_4)

	Camera.set_data(camera, "far_range", far_range)
end

function flow_callback_barrel_explode(self)
	-- function 289
	local unit = self.unit
	local extension = ScriptUnit.extension(unit, "health_system")

	extension:set_max_health(1)
	extension:add_damage(unit, 1, "full", "grenade", Unit.world_position(unit, 0), Vector3(1, 0, 0), nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
end

function flow_callback_kill_unit(self)
	-- function 290
	local unit = self.unit
	local extension = ScriptUnit.extension(unit, "health_system")

	extension:set_max_health(1)
	extension:add_damage(unit, 1, "full", "forced", Unit.local_position(unit, 0), Vector3(0, 0, 1), nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
end

function flow_callback_set_mutator_active(self)
	-- function 291
	local mutator = self.mutator
	local active = self.active
	local _mutator_handler = Managers.state.game_mode._mutator_handler

	if not active then
		_mutator_handler:initialize_mutators({
			mutator
		})
		_mutator_handler:activate_mutator(mutator, nil, "activated_by_flow")
	else
		_mutator_handler:deactivate_mutator(mutator)
	end
end

function flow_callback_set_deus_curse_active(self)
	-- function 292
	if not Managers.player.is_server then
		return
	end

	local game_mechanism = Managers.mechanism:game_mechanism()
	local get_current_node_curse = game_mechanism.get_current_node_curse

	get_current_node_curse = not get_current_node_curse and game_mechanism:get_current_node_curse()

	if not get_current_node_curse then
		return
	end

	local active = self.active
	local _mutator_handler = Managers.state.game_mode._mutator_handler

	if active == _mutator_handler:has_activated_mutator(get_current_node_curse) then
		return
	end

	if not active then
		_mutator_handler:initialize_mutators({
			get_current_node_curse
		})
		_mutator_handler:activate_mutator(get_current_node_curse, nil, "activated_by_flow")
	else
		_mutator_handler:deactivate_mutator(get_current_node_curse)
	end
end

function flow_callback_set_game_mode_variable(self)
	-- function 293
	local variable = self.variable
	local value = self.value

	Managers.state.game_mode:game_mode()[variable] = value
end

function flow_callback_print_callstack(arg_294_0)
	-- function 294
	return
end

function flow_callback_activate_payload(self)
	-- function 295
	local payload_unit = self.payload_unit

	ScriptUnit.extension(payload_unit, "payload_system"):activate()
end

function flow_callback_deactivate_payload(self)
	-- function 296
	local payload_unit = self.payload_unit
	local extension = ScriptUnit.extension(payload_unit, "payload_system")
	local force_stop = self.force_stop

	extension:deactivate(force_stop)
end

function flow_callback_activate_end_zone(self)
	-- function 297
	local unit = self.unit
	local activate = self.activate

	ScriptUnit.extension(unit, "end_zone_system"):activation_allowed(activate)
end

function flow_callback_tutorial_restrict_camera_rotation(self)
	-- function 298
	local angle = self.angle
	local restrict = self.restrict
	local local_player = Managers.player:local_player()

	fassert(local_player, "[flow_callback_restrict_camera_rotation] The local player is not available")

	local player_unit = local_player.player_unit

	fassert(alive(player_unit), "[flow_callback_restrict_camera_rotation] The local player unit hasn't spawned yet or has been removed")

	local extension = ScriptUnit.extension(player_unit, "first_person_system")

	if not restrict then
		fassert(angle, "[flow_callback_restrict_camera_rotation] You need to specify an angle when turning on rotation restriction")
	end

	extension:tutorial_restrict_camera_rotation(restrict, angle)
end

function flow_callback_prioritize_objective_tooltips(self)
	-- function 299
	local objective_tooltip_name = self.objective_tooltip_name
	local reset = self.reset

	fassert(objective_tooltip_name or reset, "[flow_callback_prioritize_objective_tooltips] You need to provide objective_tooltip_name and/or reset")
	Managers.state.entity:system("tutorial_system"):prioritize_objective_tooltip(objective_tooltip_name, reset)
end

local function fn_3(self, arg_300_1)
	-- function 300
	arg_300_1 = arg_300_1 or "\n"

	local tbl = {}
	local num = 1

	while true do
		local find, var_300_3 = self:find(arg_300_1, num)

		if not find then
			table.insert(tbl, self:sub(num))

			break
		end

		table.insert(tbl, self:sub(num, find - 1))

		num = var_300_3 + 1
	end

	return tbl
end

function flow_callback_link_objects_in_units_and_store(self)
	-- function 301
	local parent_unit = self.parent_unit
	local child_unit = self.child_unit
	local var_301_2 = fn_3(self.parent_nodes, ";")
	local var_301_3 = fn_3(self.child_nodes, ";")
	local world = Unit.world(parent_unit)
	local index_offset = Script.index_offset()

	for i = 1, #var_301_2 - 1 do
		local node = Unit.node(parent_unit, var_301_2[i])
		local var_301_7 = var_301_3[i]
		local var_301_8

		if not string.find(var_301_7, "Index(.)") then
			var_301_8 = tonumber(string.match(var_301_7, "%d+") + index_offset)
		else
			var_301_8 = Unit.node(child_unit, var_301_7)
		end

		World.link_unit(world, child_unit, var_301_8, parent_unit, node)

		if not self.parent_lod_object and not self.child_lod_object and not Unit.has_lod_object(parent_unit, self.parent_lod_object) and not Unit.has_lod_object(child_unit, self.child_lod_object) then
			local lod_object = Unit.lod_object(parent_unit, self.parent_lod_object)
			local lod_object_2 = Unit.lod_object(child_unit, self.child_lod_object)

			LODObject.set_bounding_volume(lod_object_2, LODObject.bounding_volume(lod_object))
			World.link_unit(world, child_unit, LODObject.node(lod_object_2), parent_unit, LODObject.node(lod_object))
		end
	end

	local get_data = Unit.get_data(parent_unit, "flow_unit_attachments")

	get_data = get_data or {}

	table.insert(get_data, child_unit)
	Unit.set_data(parent_unit, "flow_unit_attachments", get_data)

	return {
		linked = true
	}
end

function flow_callback_unlink_objects_in_units_and_remove(self)
	-- function 302
	local parent_unit = self.parent_unit
	local child_unit = self.child_unit
	local world = Unit.world(parent_unit)

	World.unlink_unit(world, child_unit)

	local get_data = Unit.get_data(parent_unit, "flow_unit_attachments")

	get_data = get_data or {}

	local find = table.find(get_data, child_unit)

	if not find then
		table.remove(get_data, find)
	end

	Unit.set_data(parent_unit, "flow_unit_attachments", get_data)

	return {
		unlinked = true
	}
end

function flow_callback_attach_unit(self)
	-- function 303
	local AttachmentNodeLinking = AttachmentNodeLinking
	local var_303_1 = fn_3(self.node_link_template, "/")

	if not var_303_1 then
		print("No attachment node linking defined in flow!")

		return
	end

	for i, v in ipairs(var_303_1) do
		AttachmentNodeLinking = AttachmentNodeLinking[v]
	end

	if type(AttachmentNodeLinking) ~= "table" then
		print("No attachment node linking with name %s", tostring(self.node_link_template))

		return
	end

	local parent_unit = self.parent_unit
	local child_unit = self.child_unit
	local index_offset = Script.index_offset()
	local world = Unit.world(parent_unit)

	for i_2, v_2 in ipairs(AttachmentNodeLinking) do
		local source = v_2.source
		local target = v_2.target
		local node

		if type(source) == "string" then
			node = Unit.node(parent_unit, source)

			if not node then
				-- Nothing
			end
		end

		node = source + index_offset

		do
			local node_2
		end

		::label_303_0::

		if type(target) == "string" then
			node_2 = Unit.node(child_unit, target)

			if not node_2 then
				-- Nothing
			end
		end

		node_2 = target + index_offset

		::label_303_1::

		World.link_unit(world, child_unit, node_2, parent_unit, node)
	end

	if not (not self.link_lod_groups and Unit.num_lod_objects(parent_unit) == 0 or Unit.num_lod_objects(child_unit) == 0) then
		local lod_object = Unit.lod_object(parent_unit, index_offset)
		local lod_object_2 = Unit.lod_object(child_unit, index_offset)

		LODObject.set_bounding_volume(lod_object_2, LODObject.bounding_volume(lod_object))
		World.link_unit(world, child_unit, LODObject.node(lod_object_2), parent_unit, LODObject.node(lod_object))
	end

	if not self.store_in_parent then
		local get_data = Unit.get_data(parent_unit, "flow_unit_attachments")

		get_data = get_data or {}

		table.insert(get_data, child_unit)
		Unit.set_data(parent_unit, "flow_unit_attachments", get_data)
	end

	return {
		linked = true
	}
end

function flow_callback_unattach_unit(self)
	-- function 304
	local parent_unit = self.parent_unit
	local child_unit = self.child_unit
	local world = Unit.world(parent_unit)

	World.unlink_unit(world, child_unit)

	local get_data = Unit.get_data(parent_unit, "flow_unit_attachments")

	get_data = get_data or {}

	local find = table.find(get_data, child_unit)

	if not find then
		table.remove(get_data, find)
	end

	Unit.set_data(parent_unit, "flow_unit_attachments", get_data)

	return {
		unlinked = true
	}
end

function flow_callback_attach_player_item(arg_305_0)
	-- function 305
	return
end

function flow_callback_remove_player_items(arg_306_0)
	-- function 306
	return
end

function flow_callback_attach_weapon_display(arg_307_0)
	-- function 307
	return
end

function flow_callback_trigger_event_on_attachments(self)
	-- function 308
	local get_data = Unit.get_data(self.unit, "flow_unit_attachments")

	get_data = get_data or {}

	for i = 1, #get_data do
		Unit.flow_event(get_data[i], self.event)
	end

	return {
		triggered = true
	}
end

function flow_callback_is_character_alive(self)
	-- function 309
	local unit = self.unit

	if not HEALTH_ALIVE[unit] then
		flow_return_table.out_value = true

		return flow_return_table
	end

	flow_return_table.out_value = false

	return flow_return_table
end

function flow_callback_is_leader(arg_310_0)
	-- function 310
	local leader = Managers.party:leader()
	local flag = Network.peer_id() == leader

	return {
		yes = flag,
		no = not flag
	}
end

function flow_callback_enforce_player_positions(self)
	-- function 311
	if not Managers.player.is_server then
		print("flow_callback_enforce_player_positions() run on client, doing nothing")

		return
	end

	local volume_name = self.volume_name
	local force = self.force
	local var_311_2

	if force == "inside" then
		var_311_2 = true
	elseif force == "outside" then
		var_311_2 = false
	else
		ferror("Trying to enforce players position with unknown state %s", tostring(force))
	end

	local flow_callback_context_world = Application.flow_callback_context_world()
	local current_level = LevelHelper:current_level(flow_callback_context_world)
	local player = Managers.player
	local system = Managers.state.entity:system("health_system")
	local var_311_7
	local get_side_from_name = Managers.state.side:get_side_from_name("heroes")
	local PLAYER_UNITS = get_side_from_name.PLAYER_UNITS
	local PLAYER_POSITIONS = get_side_from_name.PLAYER_POSITIONS

	for k, v in pairs(PLAYER_UNITS) do
		local var_311_11 = PLAYER_POSITIONS[k]

		if not (Level.is_point_inside_volume(current_level, volume_name, var_311_11) == var_311_2) then
			var_311_7 = var_311_11
		else
			local extension = ScriptUnit.extension(v, "status_system")

			if not (not extension:is_disabled() and extension:is_ready_for_assisted_respawn() or extension:is_dead()) then
				system:suicide(v)
			end
		end
	end

	local PLAYER_AND_BOT_UNITS = get_side_from_name.PLAYER_AND_BOT_UNITS
	local PLAYER_AND_BOT_POSITIONS = get_side_from_name.PLAYER_AND_BOT_POSITIONS

	for k_2, v_2 in pairs(PLAYER_AND_BOT_UNITS) do
		local owner = player:owner(v_2)

		if not (not owner and owner:is_player_controlled()) then
			local var_311_16 = PLAYER_AND_BOT_POSITIONS[k_2]

			if not (Level.is_point_inside_volume(current_level, volume_name, var_311_16) == var_311_2) then
				local extension_2 = ScriptUnit.extension(v_2, "status_system")
				local is_disabled = extension_2:is_disabled()
				local is_ready_for_assisted_respawn = extension_2:is_ready_for_assisted_respawn()
				local is_dead = extension_2:is_dead()

				if not (not is_disabled and is_ready_for_assisted_respawn or is_dead) then
					system:suicide(v_2)
				elseif is_ready_for_assisted_respawn or is_dead or not var_311_7 then
					local extension_3 = ScriptUnit.extension(v_2, "locomotion_system")
					local current_rotation = extension_3:current_rotation()

					extension_3:teleport_to(var_311_7, current_rotation)
				end
			end
		end
	end

	if not var_311_7 then
		Managers.state.game_mode:teleport_despawned_players(var_311_7)
	end
end

function flow_callback_tutorial_enable_equipment(self)
	-- function 312
	local enable = self.enable
	local wield_anim = self.wield_anim
	local local_player = Managers.player:local_player()

	fassert(local_player, "[flow_callback_tutorial_enable_equipment] The local player is not available")

	local player_unit = local_player.player_unit

	fassert(alive(player_unit), "[flow_callback_tutorial_enable_equipment ]gloThe local player unit hasn't spawned yet or has been removed")

	local extension = ScriptUnit.extension(player_unit, "first_person_system")

	extension:tutorial_show_first_person_units(enable)

	local tbl = {
		action_two_release = true,
		action_inspect = true,
		action_three = true,
		action_one_hold = true,
		action_inspect_hold = true,
		action_one_release = true,
		action_three_hold = true,
		character_inspecting = true,
		action_three_release = true,
		action_two = true,
		action_one = true,
		action_two_hold = true
	}
	local extension_2 = ScriptUnit.extension(player_unit, "input_system")

	if not enable then
		if not wield_anim then
			local get_first_person_unit = extension:get_first_person_unit()

			Unit.animation_event(get_first_person_unit, wield_anim)
		end

		local disallowed_input_table = extension_2:disallowed_input_table()

		for k, v in pairs(tbl) do
			disallowed_input_table[k] = nil
		end

		Managers.state.game_mode:game_mode():disable_hud(false)
	else
		local disallowed_input_table_2 = extension_2:disallowed_input_table()

		table.merge(disallowed_input_table_2, tbl)
		extension_2:set_disallowed_inputs(disallowed_input_table_2)
		Managers.state.game_mode:game_mode():disable_hud(true)
	end
end

function flow_callbacks_add_tutorial_animation_hook(self)
	-- function 313
	local animation_hook = self.animation_hook
	local animation_hook_free_text = self.animation_hook_free_text

	animation_hook = animation_hook_free_text == "" or not animation_hook_free_text or animation_hook

	fassert(not animation_hook and PauseEvents.animation_hook_templates[animation_hook], "[flow_callbacks] There is no animation hook called: %s", tostring(animation_hook))

	local clone = table.clone(PauseEvents.animation_hook_templates[animation_hook])

	Managers.state.entity:system("play_go_tutorial_system"):add_animation_hook(clone)
end

function flow_callbacks_trigger_pause_event(self)
	-- function 314
	local pause_event_name = self.pause_event_name
	local look_position = self.look_position

	fassert(not pause_event_name and PauseEvents.pause_events[pause_event_name], "[flow_callbacks] There is not pause events called: %s", tostring(pause_event_name))

	local clone = table.clone(PauseEvents.pause_events[pause_event_name])

	Managers.state.entity:system("play_go_tutorial_system"):trigger_pause_event(clone, look_position)
end

function flow_callbacks_add_tutorial_equipment(self)
	-- function 315
	local slot_name = self.slot_name
	local item_name = self.item_name
	local floor

	if not self.starting_ammo then
		floor = math.floor(self.starting_ammo)

		if not floor then
			-- Nothing
		end
	end

	floor = 0

	::label_315_0::

	fassert(not item_name and ItemMasterList[item_name], "[flow_callbacks_add_tutorial_equipment] There is no item called %s in ItemMasterList", tostring(item_name))

	local var_315_3 = ItemMasterList[item_name]
	local player_unit = Managers.player:local_player().player_unit
	local extension = ScriptUnit.extension(player_unit, "inventory_system")

	extension:add_equipment(slot_name, var_315_3, nil, nil, floor)

	if slot_name == "slot_melee" then
		extension:wield("slot_melee")
	else
		extension:wield("slot_ranged")
	end
end

local function fn_4(self, arg_316_1, arg_316_2)
	-- function 316
	if not arg_316_2 then
		local disallowed_input_table = self:disallowed_input_table()

		for k, v in pairs(arg_316_1) do
			disallowed_input_table[k] = nil
		end

		self:set_disallowed_inputs(disallowed_input_table)
		self:set_allowed_inputs(arg_316_1)
	else
		local disallowed_input_table_2 = self:disallowed_input_table()

		table.merge(disallowed_input_table_2, arg_316_1)
		self:set_disallowed_inputs(disallowed_input_table_2)
	end
end

function flow_callbacks_tutorial_inputs_enabled(self)
	-- function 317
	local local_player = Managers.player:local_player()

	fassert(local_player, "[flow_callbacks_tutorial_inputs_enabled] The local player is not available")

	local player_unit = local_player.player_unit

	fassert(alive(player_unit), "[flow_callbacks_tutorial_inputs_enabled] The local player unit hasn't spawned yet or has been removed")

	local move = self.move
	local jump_dodge = self.jump_dodge
	local attack = self.attack
	local block = self.block
	local career_ability = self.career_ability
	local weapon_switch = self.weapon_switch
	local tbl = {
		move_back_pressed = true,
		move_forward_pressed = true,
		move_right = true,
		move_controller = true,
		move_right_pressed = true,
		move_left = true,
		move_forward = true,
		move_back = true,
		move_left_pressed = true
	}
	local tbl_2 = {
		jump_only = true,
		dodge = true,
		jump_1 = true,
		dodge_hold = true,
		jump_2 = true
	}
	local tbl_3 = {
		action_one_softbutton_gamepad = true,
		action_one_mouse = true,
		action_one_hold = true,
		action_one_release = true,
		action_one = true
	}
	local tbl_4 = {
		action_two_hold = true,
		action_two = true
	}
	local tbl_5 = {
		action_career_release = true,
		action_career = true,
		action_career_hold = true
	}
	local tbl_6 = {
		wield_switch = true,
		wield_2 = true,
		wield_next = true,
		wield_5 = true,
		wield_prev = true,
		wield_0 = true,
		wield_8 = true,
		wield_3 = true,
		wield_switch_2 = true,
		wield_6 = true,
		wield_switch_1 = true,
		wield_1 = true,
		wield_9 = true,
		wield_4 = true,
		wield_scroll = true,
		wield_7 = true
	}
	local extension = ScriptUnit.extension(player_unit, "input_system")

	fn_4(extension, tbl, move)
	fn_4(extension, tbl_2, jump_dodge)
	fn_4(extension, tbl_3, attack)
	fn_4(extension, tbl_4, block)
	fn_4(extension, tbl_5, career_ability)
	fn_4(extension, tbl_6, weapon_switch)
end

function flow_callbacks_tutorial_enable_weapon_switching(self)
	-- function 318
	local enable = self.enable
	local local_player = Managers.player:local_player()

	fassert(local_player, "[flow_callbacks_tutorial_enable_weapon_switching] The local player is not available")

	local player_unit = local_player.player_unit

	fassert(alive(player_unit), "[flow_callbacks_tutorial_enable_weapon_switching] The local player unit hasn't spawned yet or has been removed")

	local tbl = {
		wield_switch = true,
		wield_2 = true,
		wield_next = true,
		wield_5 = true,
		wield_prev = true,
		wield_0 = true,
		wield_8 = true,
		wield_3 = true,
		wield_switch_2 = true,
		wield_6 = true,
		wield_switch_1 = true,
		wield_1 = true,
		wield_9 = true,
		wield_4 = true,
		wield_scroll = true,
		wield_7 = true
	}
	local extension = ScriptUnit.extension(player_unit, "input_system")

	if not enable then
		local disallowed_input_table = extension:disallowed_input_table()

		for k, v in pairs(tbl) do
			disallowed_input_table[k] = nil
		end
	else
		local disallowed_input_table_2 = extension:disallowed_input_table()

		table.merge(disallowed_input_table_2, tbl)
		extension:set_disallowed_inputs(disallowed_input_table_2)
	end
end

function flow_callbacks_tutorial_enable_career_skill(self)
	-- function 319
	local enable = self.enable
	local player_unit = Managers.player:local_player().player_unit
	local extension = ScriptUnit.extension(player_unit, "career_system")

	if not enable then
		extension:start_activated_ability_cooldown(1, 0)
		extension:set_activated_ability_cooldown_paused(1)
	else
		extension:set_activated_ability_cooldown_unpaused(1)
		extension:reduce_activated_ability_cooldown_percent(1, 1)
	end
end

function flow_callback_enable_bot_loot(self)
	-- function 320
	local enable = self.enable
	local system = Managers.state.entity:system("play_go_tutorial_system")

	if not system then
		system:enable_bot_loot(enable)
	end
end

function flow_callback_enable_bot_portrait(self)
	-- function 321
	local bot_display_name = self.bot_display_name

	Managers.state.entity:system("play_go_tutorial_system"):set_bot_portrait_enabled(bot_display_name)
end

function flow_callback_set_player_invincibility(self)
	-- function 322
	if not Managers.player.is_server then
		return
	end

	local player_unit = self.player_unit
	local invincible = self.invincible

	if not alive(player_unit) then
		local has_extension = ScriptUnit.has_extension(player_unit, "health_system")

		fassert(has_extension, "Tried to set invincibility on unit %s from flow but the unit has no health extension", player_unit)

		has_extension.is_invincible = invincible
	end
end

function flow_callback_switch_player_class(self)
	-- function 323
	local player_unit = self.player_unit
	local profile_name = self.profile_name

	if not profile_name then
		local unit_owner = Managers.player:unit_owner(player_unit)
		local network_id = unit_owner:network_id()
		local local_player_id = unit_owner:local_player_id()
		local get_party_from_player_id = Managers.party:get_party_from_player_id(network_id, local_player_id)
		local available_profiles = Managers.state.side.side_by_party[get_party_from_player_id].available_profiles

		available_profiles = available_profiles or PROFILES_BY_AFFILIATION.heroes

		for i = 1, #available_profiles do
			profile_name = available_profiles[i]

			break
		end
	end

	if not profile_name then
		local var_323_7 = FindProfileIndex(profile_name)
		local careers = SPProfiles[var_323_7].careers
		local var_323_9 = careers[script_data.wanted_career_index]

		var_323_9 = var_323_9 or careers[1]

		local flag = true

		if var_323_9.display_name == "vs_undecided" then
			return
		end

		Managers.state.network:request_profile(1, profile_name, var_323_9.display_name, flag)
	end
end

function flow_callback_switch_player_party(self)
	-- function 324
	local party_id = self.party_id

	if not party_id then
		local var_324_1 = tonumber(party_id)
		local get_party = Managers.party:get_party(var_324_1)

		if not (not get_party and not (get_party.num_open_slots + get_party.num_bots > 0)) then
			print("Debug switching wanted party to:", var_324_1)

			local local_player = Managers.player:local_player()
			local local_player_id = local_player:local_player_id()
			local network_id = local_player:network_id()
			local current_mechanism_name = Managers.mechanism:current_mechanism_name()
			local var_324_7 = Managers.state.side.side_by_party[get_party]

			Managers.party:request_join_party(network_id, local_player_id, var_324_1)

			if not local_player and not local_player:needs_despawn() then
				Managers.state.spawn:delayed_despawn(local_player)
			end

			local system = Managers.state.entity:system("camera_system")

			if get_party.name == "spectators" then
				local spectator = PROFILES_BY_NAME.spectator

				system:initialize_camera_states(local_player, spectator.index, 1)
			else
				local var_324_10 = FindProfileIndex("witch_hunter")

				system:initialize_camera_states(local_player, var_324_10, 1)
			end

			local sides = Managers.state.side:sides()
			local var_324_12
			local var_324_13

			for i = 1, #sides do
				local var_324_14 = sides[i]
				local format = string.format("%s_%s", current_mechanism_name, var_324_14:name())
				local flag = var_324_14 == var_324_7

				Managers.state.game_mode:set_object_set_enabled(format, flag)
			end
		end
	end
end

function flow_callback_set_player_in_hanging_cage(self)
	-- function 325
	local idle_animation = self.idle_animation
	local falling_animation = self.falling_animation
	local landing_animation = self.landing_animation
	local player_unit = self.player_unit
	local cage_unit = self.cage_unit
	local state = self.state

	if not alive(player_unit) then
		local has_extension = ScriptUnit.has_extension(player_unit, "status_system")

		fassert(has_extension, "Tried to set in_hanging_cage status on unit %s from flow but the unit has no status extension", player_unit)
		fassert(state, "Need to set in_hanging_cage state!")

		local in_hanging_cage_animations = has_extension.in_hanging_cage_animations

		in_hanging_cage_animations = in_hanging_cage_animations or {
			idle = idle_animation,
			falling = falling_animation,
			landing = landing_animation
		}

		has_extension:set_in_hanging_cage(true, cage_unit, state, in_hanging_cage_animations)
	end
end

function flow_callback_set_player_fall_height(self)
	-- function 326
	local unit = self.unit
	local has_extension = ScriptUnit.has_extension(unit, "status_system")

	if not has_extension then
		if not has_extension.is_husk then
			if BUILD == "release" then
				Crashify.print_exception("flow_callbacks", "Trying to set falling height on unit not owned")
			else
				ferror("Trying to set falling height on unit not owned")
			end
		else
			has_extension:set_falling_height(true)
		end
	end
end

function flow_callback_set_local_player_gravity_scale(self)
	-- function 327
	local gravity_scale = self.gravity_scale

	gravity_scale = gravity_scale or 1

	local human_and_bot_players = Managers.player:human_and_bot_players()

	for k, v in pairs(human_and_bot_players) do
		if v.local_player or not v.bot_player or not v.is_server then
			local player_unit = v.player_unit
			local has_extension = ScriptUnit.has_extension(player_unit, "locomotion_system")

			if not has_extension and not has_extension.set_script_driven_gravity_scale then
				has_extension:set_script_driven_gravity_scale(gravity_scale)
			end
		end
	end
end

function flow_callback_enable_generic_unit_aim_extension(self)
	-- function 328
	local unit = self.unit
	local enable = self.enable
	local has_extension = ScriptUnit.has_extension(unit, "aim_system")

	if not has_extension then
		has_extension:set_enabled(enable)
	end
end

function flow_callbacks_players_not_in_end_zone()
	-- function 329
	flow_return_table.witch_hunter = false
	flow_return_table.bright_wizard = false
	flow_return_table.dwarf_ranger = false
	flow_return_table.wood_elf = false
	flow_return_table.empire_soldier = false
	flow_return_table.empire_soldier_tutorial = false

	local num = 0
	local human_and_bot_players = Managers.player:human_and_bot_players()

	for k, v in pairs(human_and_bot_players) do
		local player_unit = v.player_unit

		if not Unit.alive(player_unit) then
			local is_in_end_zone = ScriptUnit.extension(player_unit, "status_system"):is_in_end_zone()
			local profile_display_name = v:profile_display_name()

			if is_in_end_zone or not profile_display_name then
				num = num + 1
				flow_return_table[profile_display_name] = true
			end
		end
	end

	flow_return_table.outside_count = num

	return flow_return_table
end

function flow_callback_store_parent(self)
	-- function 330
	local parent_unit = self.parent_unit
	local child_unit = self.child_unit

	Unit.set_data(child_unit, "parent_ref", parent_unit)
end

function flow_callback_stored_parent(self)
	-- function 331
	local child_unit = self.child_unit
	local get_data = Unit.get_data(child_unit, "parent_ref")

	return {
		parent_unit = get_data
	}
end

function flow_callback_set_unit_enabled(self)
	-- function 332
	local unit = self.unit

	if not alive(unit) then
		Crashify.print_exception("Deleted Unit", "referenced in flow")

		return
	end

	if not self.enabled then
		Unit.set_unit_visibility(unit, true)
		Unit.enable_physics(unit)
		Unit.enable_animation_state_machine(unit)
	else
		Unit.set_unit_visibility(unit, false)

		local system = Managers.state.entity:system("projectile_linker_system")

		if system ~= nil then
			system:clear_linked_projectiles(unit)
		end

		Unit.disable_physics(unit)

		if not Unit.has_animation_state_machine(unit) then
			Unit.disable_animation_state_machine(unit)
		end
	end
end

function flow_callback_register_looping_event_timer(self)
	-- function 333
	Managers.state.game_mode:register_looping_event_timer(self.unique_id, self.time, self.level_event_name)
end

function flow_callback_unregister_looping_event_timer(self)
	-- function 334
	Managers.state.game_mode:unregister_looping_event_timer(self.unique_id)
end

function flow_callback_rpc_clients_level_event(self)
	-- function 335
	if not Managers.state.game_mode then
		Managers.state.network.network_transmit:send_rpc_clients("rpc_trigger_level_event", self.level_event_name)
	end
end

function flow_callback_set_unit_physics(self)
	-- function 336
	if not self.physics then
		Unit.enable_physics(self.unit)
	else
		Unit.disable_physics(self.unit)
	end
end

function flow_callback_specific_pickup_gizmo_spawned(self)
	-- function 337
	local system = Managers.state.entity:system("pickup_system")

	if not system then
		system:specific_pickup_gizmo_spawned(self.unit)
	end
end

function flow_callback_set_unit_faded_status(self)
	-- function 338
	local unit = self.unit
	local faded = self.faded
	local extension = ScriptUnit.extension(unit, "status_system")

	if not extension then
		extension:set_invisible(faded, nil, "flow_faded")
	end
end

function flow_callback_get_level_seed(arg_339_0)
	-- function 339
	return {
		seed = Managers.mechanism:get_level_seed()
	}
end

function flow_callback_predict_hitscan(self)
	-- function 340
	local player_unit = self.player_unit
	local range = self.range

	range = range or 10

	local spread = self.spread

	spread = spread or 0

	local tbl = {
		success = false
	}
	local world = Managers.world

	if not world then
		world = Managers.world:has_world(LevelHelper.INGAME_WORLD_NAME)
		world = not world and Managers.world:world(LevelHelper.INGAME_WORLD_NAME)
	end

	if not world then
		return tbl
	end

	local get_data = World.get_data(world, "physics_world")

	if not get_data then
		return tbl
	end

	local network = Managers.state.network
	local game = network:game()
	local unit_game_object_id = network:unit_game_object_id(player_unit)

	if not game and not unit_game_object_id then
		local game_object_field = GameSession.game_object_field(game, unit_game_object_id, "aim_direction")
		local game_object_field_2 = GameSession.game_object_field(game, unit_game_object_id, "aim_position")
		local num = math.random() * math.rad(spread)
		local num_2 = math.random() * math.rad(spread)
		local rotate = Quaternion.rotate(Quaternion(Vector3.up(), num), game_object_field)
		local rotate_2 = Quaternion.rotate(Quaternion(Vector3.right(), num_2), rotate)
		local immediate_raycast_actors = PhysicsWorld.immediate_raycast_actors(get_data, game_object_field_2, rotate_2, range, "static_collision_filter", "filter_player_ray_projectile_static_only", "dynamic_collision_filter", "filter_player_ray_projectile_hitbox_only")
		local num_3 = 1
		local num_4 = 2
		local var_340_18

		if not immediate_raycast_actors then
			var_340_18 = immediate_raycast_actors[1][num_3]

			if not var_340_18 then
				-- Nothing
			end
		end

		var_340_18 = game_object_field_2 + rotate_2 * range

		::label_340_0::

		tbl.end_position = var_340_18
		tbl.success = true

		local var_340_19

		if not immediate_raycast_actors then
			var_340_19 = immediate_raycast_actors[1][num_4]

			if not var_340_19 then
				-- Nothing
			end
		end

		var_340_19 = range

		::label_340_1::

		tbl.distance = var_340_19
	end

	return tbl
end

function flow_callback_spawn_defenders_ward(self)
	-- function 341
	Managers.state.event:trigger("spawn_defenders", self.num_defenders)
end

function flow_callback_cog_collision(self)
	-- function 342
	local touching_actor = self.touching_actor
	local velocity = Actor.velocity(touching_actor)

	if not touching_actor then
		return
	end

	if Vector3.length(velocity) <= 0.1 then
		return
	end

	local touching_unit = self.touching_unit
	local unit = self.unit
	local owner_peer_id = ScriptUnit.extension(unit, "pickup_system").owner_peer_id
	local peer_id = Network.peer_id()

	if owner_peer_id == Network.peer_id() then
		Managers.state.achievement:trigger_event("on_trail_cog_strike", touching_unit)
	end

	if not Managers.state.network.is_server then
		local var_342_6 = touching_unit
		local var_342_7 = POSITION_LOOKUP[unit]
		local flat = Vector3.flat(var_342_7)
		local var_342_9 = POSITION_LOOKUP[var_342_6]
		local flat_2 = Vector3.flat(var_342_9)
		local str = "torso"
		local str_2 = "trail_cog"
		local var_342_13 = EnvironmentalHazards[str_2]
		local var_342_14 = str_2
		local var_342_15
		local normalize = Vector3.normalize(flat_2 - flat)
		local damage_profile = var_342_13.enemy.damage_profile

		damage_profile = damage_profile or "default"

		local var_342_18 = DamageProfileTemplates[damage_profile]
		local var_342_19
		local num = 0
		local flag = false
		local flag_2 = true
		local flag_3 = true
		local flag_4 = false
		local flag_5 = false
		local get_difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
		local var_342_27 = var_342_13.enemy.difficulty_power_level[get_difficulty_rank]

		if not var_342_27 then
			var_342_27 = var_342_13.enemy.difficulty_power_level[2]
			var_342_27 = var_342_27 or DefaultPowerLevel
		end

		local time = Managers.time:time("game")

		DamageUtils.server_apply_hit(time, unit, var_342_6, str, nil, normalize, var_342_15, var_342_14, var_342_27, var_342_18, var_342_19, num, flag, flag_2, flag_3, flag_4, flag_5)
	end
end

function flow_callback_reset_cog_collision_stat()
	-- function 343
	local is_server = Managers.state.network.is_server

	Managers.state.achievement:trigger_event("on_trail_cog_reset_stat")
end

function flow_callback_environment_hazard_damage_collision(self)
	-- function 344
	if not Managers.state.network.is_server then
		local touching_unit = self.touching_unit
		local unit = self.unit
		local hazard_type = self.hazard_type
		local var_344_3 = POSITION_LOOKUP[unit]

		var_344_3 = var_344_3 or Unit.world_position(unit, 0)

		local flat = Vector3.flat(var_344_3)
		local var_344_5 = POSITION_LOOKUP[touching_unit]
		local flat_2 = Vector3.flat(var_344_5)
		local str = "full"
		local var_344_8 = EnvironmentalHazards[hazard_type]
		local var_344_9 = hazard_type
		local flag = true
		local normalize = Vector3.normalize(flat_2 - flat)
		local damage_profile = var_344_8.enemy.damage_profile

		damage_profile = damage_profile or "default"

		local var_344_13 = DamageProfileTemplates[damage_profile]
		local var_344_14
		local num = 0
		local flag_2 = false
		local flag_3 = true
		local flag_4 = true
		local flag_5 = false

		if not self.shield_breaking_hit then
			local flag_6 = true
		end

		local get_difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
		local var_344_22 = var_344_8.enemy.difficulty_power_level[get_difficulty_rank]

		if not var_344_22 then
			var_344_22 = var_344_8.enemy.difficulty_power_level[2]
			var_344_22 = var_344_22 or DefaultPowerLevel
		end

		local time = Managers.time:time("game")
		local extension = ScriptUnit.extension(touching_unit, "health_system")
		local var_344_25 = var_344_8.enemy.difficulty_damage[get_difficulty_rank]

		var_344_25 = var_344_25 or var_344_8.enemy.difficulty_damage[2]

		extension:add_damage(touching_unit, var_344_25, str, "cutting", var_344_5, normalize, "wounded_degen", nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)

		if not extension:is_dead() then
			local var_344_26 = ({
				"dismember_torso",
				"dismember_head",
				"explode_body"
			})[math.random(1, 3)]

			Unit.flow_event(touching_unit, var_344_26)
		else
			DamageUtils.stagger_ai(time, var_344_13, var_344_14, var_344_22, touching_unit, unit, str, normalize, num, flag_2, flag_5, var_344_9)
		end
	end
end

function flow_callback_hazard_push_damage_player_and_husks(self)
	-- function 345
	if not Managers.player.is_server and not DamageUtils.is_player_unit(self.touching_unit) then
		local unit = self.unit
		local touching_unit = self.touching_unit
		local push_multiplier = self.push_multiplier
		local damage = self.damage
		local var_345_4 = POSITION_LOOKUP[unit]

		var_345_4 = var_345_4 or Unit.world_position(unit, 0)

		local flat = Vector3.flat(var_345_4)
		local var_345_6 = POSITION_LOOKUP[touching_unit]
		local flat_2 = Vector3.flat(var_345_6)

		if not alive(touching_unit) and not damage then
			local str = "full"
			local str_2 = "forced"
			local up = Vector3.up()

			ScriptUnit.extension(touching_unit, "health_system"):add_damage(touching_unit, damage, str, str_2, var_345_6, up, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end

		local num = Vector3.normalize(flat_2 - flat) * push_multiplier

		ScriptUnit.extension(touching_unit, "locomotion_system"):add_external_velocity(num)
	end
end

function flow_callback_push_nearby_players(self)
	-- function 346
	local source_unit = self.source_unit
	local local_position = Unit.local_position(source_unit, 0)
	local range = self.range

	range = range or 5

	local num = range^2
	local force = self.force

	force = force or 5

	local local_player_only = self.local_player_only
	local num_2 = Quaternion.forward(Unit.local_rotation(source_unit, 0)) * force

	if not local_player_only then
		local local_player = Managers.player:local_player()
		local flag = not local_player and local_player.player_unit

		if not (not flag and not (num > Vector3.distance_squared(POSITION_LOOKUP[flag], local_position))) then
			ScriptUnit.extension(flag, "locomotion_system"):add_external_velocity(num_2, force)
		end
	else
		local players = Managers.player:players()

		for k, v in pairs(players) do
			local player_unit = v.player_unit

			if not (not player_unit and not (num > Vector3.distance_squared(POSITION_LOOKUP[player_unit], local_position))) then
				ScriptUnit.extension(player_unit, "locomotion_system"):add_external_velocity(num_2, force)
			end
		end
	end
end

function flow_callback_start_disrupt_ritual(self)
	-- function 347
	fassert(self.unit, "[flow_callbacks] DISRUPT RITUAL: No level unit name provided [required]")
	fassert(self.volume_name, "[flow_callbacks] DISRUPT RITUAL: No volume name provided [required]")
	fassert(self.num_progression_events > 1, "[flow_callbacks] DISRUPT RITUAL: num_progession_events have to be atleast 2: one for start and one for end [required]")
	fassert(self.num_progression_events, "[flow_callbacks] DISRUPT RITUAL: No num progression events provided [required]")
	fassert(self.tick_length, "[flow_callbacks] DISRUPT RITUAL: No tick length provided [required]")
	fassert(self.damage_per_tick, "[flow_callbacks] DISRUPT RITUAL: No damage per tick provided [required]")
	fassert(self.heal_per_tick, "[flow_callbacks] DISRUPT RITUAL: No heal per tick provided [required]")
	Managers.state.event:trigger("start_disrupt_ritual", self.unit, self.volume_name, self.volume_type, self.num_progression_events, self.tick_length, self.damage_per_tick, self.heal_per_tick)
end

function flow_callback_spawn_sofia_defenders(self)
	-- function 348
	if not Managers.player.is_server then
		return
	end

	local unit = self.unit
	local tbl = {
		self.spawn_position1,
		self.spawn_position2,
		self.spawn_position3
	}

	ScriptUnit.extension(unit, "ward_system"):spawn_sofia_defenders(tbl)
end

function flow_callback_spawn_skulls_tower_end(self)
	-- function 349
	if not Managers.player.is_server then
		return
	end

	local num_skulls = self.num_skulls
	local tbl = {}
	local world_position = Unit.world_position(self.sofia_unit, 0)

	tbl.sofia_unit_pos = Vector3Box(world_position)

	tbl.spawned_func = function (arg_350_0, arg_350_1, arg_350_2)
		-- function 350
		local var_350_0 = BLACKBOARDS[arg_350_0]

		if not var_350_0 then
			var_350_0.sofia_unit_pos = arg_350_2.sofia_unit_pos
		end
	end

	tbl.prepare_func = function (self, arg_351_1)
		-- function 351
		local flag = false

		self.modify_extension_init_data(self, flag, arg_351_1)
	end

	local up = Vector3.up()
	local right = Vector3.right()
	local identity = Quaternion.identity()
	local var_349_6 = Vector3(0, 0, 3)
	local num = 0.1
	local num_2 = math.pi * 2 / num_skulls

	for i = 1, num_skulls do
		local num_3 = Quaternion.rotate(Quaternion(up, num_2 * i), right) * num + var_349_6
		local num_4 = world_position + var_349_6
		local str = "fx/ethereal_skulls_teleport_01"

		if not str then
			local var_349_12 = NetworkLookup.effects[str]
			local num_5 = 0
			local identity_2 = Quaternion.identity()

			Managers.state.network:rpc_play_particle_effect(nil, var_349_12, NetworkConstants.invalid_game_object_id, num_5, num_4, identity_2, false)
		end

		Managers.state.conflict:spawn_queued_unit(Breeds.tower_homing_skull, Vector3Box(num_4), QuaternionBox(identity), nil, "spawn_idle", nil, tbl)
	end
end

function flow_callback_trigger_sofia_explosion(self)
	-- function 352
	local tbl = {
		enemy_damage = self.enemy_damage
	}

	Managers.state.event:trigger("on_failed_guardians_event", tbl)
end

function flow_callback_spawn_magic_missile_two_targets(self)
	-- function 353
	local unit = self.unit
	local first_character = self.first_character
	local second_character = self.second_character

	assert(first_character, "[flow_callback_spawn_two_targets_vfx_projectile_tower] assign a first_character")

	local var_353_3

	if not Unit.get_data(first_character, "visible") then
		var_353_3 = first_character
	else
		assert(second_character, "[flow_callback_spawn_two_targets_vfx_projectile_tower] first_character is not visible and second_character is not assigned")

		var_353_3 = second_character
	end

	local spawn_node_name = self.spawn_node_name
	local target_node_name = self.target_node_name
	local optional_second_target = self.optional_second_target
	local optional_second_target_node_name = self.optional_second_target_node_name
	local speed = self.speed
	local trajectory_template_name = self.trajectory_template_name
	local impact_with_last_target = self.impact_with_last_target
	local character_name = self.character_name

	assert(trajectory_template_name, "[flow_callback_spawn_two_targets_vfx_projectile_tower] needs a trajectory_template_name choosen")
	assert(var_353_3, "[flow_callback_spawn_two_targets_vfx_projectile_tower] assign a target")
	assert(character_name, "[flow_callback_spawn_two_targets_vfx_projectile_tower] assign character name")

	local vfx_scripted_projectile_unit = Projectiles.vfx_scripted_projectile_unit
	local name = vfx_scripted_projectile_unit.name
	local gravity_settings = vfx_scripted_projectile_unit.gravity_settings
	local angle = vfx_scripted_projectile_unit.angle
	local impact_template_name = vfx_scripted_projectile_unit.impact_template_name
	local impact_collision_filter = vfx_scripted_projectile_unit.impact_collision_filter
	local radius = vfx_scripted_projectile_unit.radius
	local only_one_impact = vfx_scripted_projectile_unit.only_one_impact
	local var_353_20

	if character_name == "sofia" then
		var_353_20 = ProjectileUnits.sofia_vfx_scripted_projectile_unit
	else
		var_353_20 = ProjectileUnits.olesya_vfx_scripted_projectile_unit
	end

	local projectile_unit_name = var_353_20.projectile_unit_name
	local node = Unit.node(unit, spawn_node_name)

	node = node or 0

	local world_position = Unit.world_position(unit, node)
	local local_rotation = Unit.local_rotation(unit, 0)
	local node_2 = Unit.node(var_353_3, target_node_name)

	node_2 = node_2 or 0

	local world_position_2 = Unit.world_position(var_353_3, node_2)
	local normalize = Vector3.normalize(world_position_2 - world_position)
	local num = world_position + normalize * 0.25
	local tbl = {
		(Vector3Box(world_position_2))
	}
	local tbl_2 = {
		var_353_3
	}

	if not Unit.alive(optional_second_target) then
		local node_3 = Unit.node(optional_second_target, optional_second_target_node_name)

		node_3 = node_3 or 0

		local world_position_3 = Unit.world_position(optional_second_target, node_3)

		tbl[2] = Vector3Box(world_position_3)
		tbl_2[2] = optional_second_target
	end

	local tbl_3 = {
		projectile_locomotion_system = {
			angle = angle,
			speed = speed,
			target_vector = normalize,
			target_positions = tbl,
			target_units = tbl_2,
			initial_position = num,
			trajectory_template_name = trajectory_template_name,
			gravity_settings = gravity_settings,
			impact_with_last_target = impact_with_last_target
		},
		projectile_impact_system = {
			sphere_radius = radius,
			only_one_impact = only_one_impact,
			collision_filter = impact_collision_filter
		},
		projectile_system = {
			impact_template_name = impact_template_name
		}
	}

	Managers.state.unit_spawner:spawn_local_unit_with_extensions(projectile_unit_name, name, tbl_3, num, local_rotation)
end

function flow_callback_set_rotating_hazard_state(self)
	-- function 354
	if not Managers.state.network.is_server then
		return
	end

	local unit = self.unit
	local has_extension = ScriptUnit.has_extension(unit, "props_system")

	if not has_extension then
		local state = self.state

		if state == "start" then
			has_extension:start(false)
		elseif state == "restart" then
			has_extension:start(true)
		elseif state == "pause" then
			has_extension:pause()
		elseif state == "stop" then
			has_extension:stop()
		end
	end
end

function flow_callback_trigger_event_on_all_sub_levels(self)
	-- function 355
	local event_name = self.event_name

	if not event_name then
		return
	end

	local flow_callback_context_level = Application.flow_callback_context_level()

	if not flow_callback_context_level then
		return
	end

	local get_data = Level.get_data(flow_callback_context_level, "sub_levels")

	if not get_data then
		for k, v in pairs(get_data) do
			Level.trigger_event(v, event_name)
		end
	end
end

function flow_callback_trigger_event_on_sub_level(self)
	-- function 356
	local event_name = self.event_name

	if not event_name then
		return
	end

	local flow_callback_context_level = Application.flow_callback_context_level()

	if not flow_callback_context_level then
		return
	end

	local get_data = Level.get_data(flow_callback_context_level, "sub_levels")

	if not get_data then
		local var_356_3 = get_data[self.sub_level_name]

		if not var_356_3 then
			Level.trigger_event(var_356_3, event_name)
		end
	end
end

function flow_callback_trigger_event_of_parent_level(self)
	-- function 357
	local event_name = self.event_name

	if not event_name then
		return
	end

	local flow_callback_context_level = Application.flow_callback_context_level()

	if not flow_callback_context_level then
		return
	end

	local get_data = Level.get_data(flow_callback_context_level, "parent_level")

	if not get_data then
		return
	end

	Level.trigger_event(get_data, event_name)
end

function flow_callback_trigger_event_on_context_level(self)
	-- function 358
	local event_name = self.event_name

	if not event_name then
		return
	end

	local flow_callback_context_level = Application.flow_callback_context_level()

	if not flow_callback_context_level then
		return
	end

	Level.trigger_event(flow_callback_context_level, event_name)
end

function flow_callback_get_intro_wwise_id(arg_359_0)
	-- function 359
	local flow_callback_context_level = Application.flow_callback_context_level()

	if not flow_callback_context_level then
		return
	end

	local var_359_1 = flow_return_table
	local get_data = Level.get_data(flow_callback_context_level, "intro_wwise_id")

	get_data = get_data or 0
	var_359_1.wwise_id = get_data

	return flow_return_table
end

function flow_callback_on_tower_skull_found(arg_360_0)
	-- function 360
	Managers.state.achievement:trigger_event("on_tower_skull_found")
end

function flow_callback_tower_wall_illusion_found(self)
	-- function 361
	Managers.state.achievement:trigger_event("tower_wall_illusion_found", self.index)
end

function flow_callback_update_tower_invisible_bridge_challenge(self)
	-- function 362
	Managers.state.achievement:trigger_event("update_tower_invisible_bridge_challenge", self.succeeded)
end

function flow_callback_note_puzzle_solved(arg_363_0)
	-- function 363
	Managers.state.achievement:trigger_event("tower_note_puzzle")
end

function flow_callback_tower_potion_created(self)
	-- function 364
	Managers.state.achievement:trigger_event("tower_potion_created", self.type)
end

function flow_callback_tower_time_challenge_done(arg_365_0)
	-- function 365
	return
end

function tower_guardian_of_lustria_challenge_done(arg_366_0)
	-- function 366
	Managers.state.achievement:trigger_event("tower_enable_guardian_of_lustria")
end

function flow_callback_tower_skulls_set_target(self)
	-- function 367
	Managers.state.event:trigger("set_tower_skulls_target", self.unit, true)
end

function flow_callback_tower_barrel_achievement(self)
	-- function 368
	local event_name = self.event_name

	Managers.state.achievement:trigger_event("tower_barrels", event_name, self.unit)
end

function flow_callback_tower_barrel_challenge_done(arg_369_0)
	-- function 369
	Managers.state.achievement:trigger_event("tower_barrels", "done")
end

function flow_callback_once_in_play_session(self)
	-- function 370
	local key = self.key
	local script_data = script_data
	local once_in_play_session = script_data.once_in_play_session

	once_in_play_session = once_in_play_session or {}
	script_data.once_in_play_session = once_in_play_session
	flow_return_table.out = not script_data.once_in_play_session[key]
	script_data.once_in_play_session[key] = true

	return flow_return_table
end

function flow_callback_trigger_gameplay_start(arg_371_0)
	-- function 371
	Managers.state.achievement:trigger_event("gameplay_start")
end

function flow_callback_dwarf_emote_achievement(self)
	-- function 372
	Managers.state.achievement:trigger_event("dwarf_valaya_emote", self.is_inside)
end

function flow_callback_complete_dwarf_barrel_challenge(arg_373_0)
	-- function 373
	Managers.state.achievement:trigger_event("dwarf_barrel_carry", true)
end

function flow_callback_complete_dwarf_rune_challenge(arg_374_0)
	-- function 374
	Managers.state.achievement:trigger_event("dwarf_rune")
end

function flow_callback_complete_dwarf_bell_challenge(arg_375_0)
	-- function 375
	Managers.state.achievement:trigger_event("dwarf_bells")
end

function flow_callback_update_dwarf_pressure_challenge(self)
	-- function 376
	Managers.state.achievement:trigger_event("dwarf_pressure", self.start_timer)
end

function flow_callback_progress_dwarf_towers_challenge(arg_377_0)
	-- function 377
	Managers.state.achievement:trigger_event("progress_dwarf_towers_challenge")
end

function flow_callback_progress_dwarf_chain_speed_challenge(arg_378_0)
	-- function 378
	Managers.state.achievement:trigger_event("progress_dwarf_chain_speed_challenge")
end

function flow_callback_complete_dwarf_jump_puzzle_challenge(arg_379_0)
	-- function 379
	Managers.state.achievement:trigger_event("complete_dwarf_jump_puzzle_challenge")
end

function flow_callback_update_dwarf_pressure_pad_challenge(self)
	-- function 380
	Managers.state.achievement:trigger_event("dwarf_pressure_pad", self.unit, self.is_on_pad, self.complete_challenge)
end

function flow_callback_complete_dwarf_crows_challenge(arg_381_0)
	-- function 381
	Managers.state.achievement:trigger_event("dwarf_crows")
end

function flow_callback_update_big_jump_challenge(self)
	-- function 382
	Managers.state.achievement:trigger_event("dwarf_big_jump", self.is_landing)
end

function flow_callback_complete_dwarf_speedrun_challenge(arg_383_0)
	-- function 383
	Managers.state.achievement:trigger_event("dwarf_speedrun_end")
end

function flow_callback_start_dwarf_speedrun_challenge(arg_384_0)
	-- function 384
	Managers.state.achievement:trigger_event("dwarf_speedrun_start")
end

function flow_callback_carousel_set_time(self)
	-- function 385
	if not Managers.player.is_server then
		return
	end

	Managers.mechanism:game_mechanism():win_conditions():set_time(self.time)
end

function flow_callback_carousel_get_current_set(arg_386_0)
	-- function 386
	assert(Managers.mechanism:current_mechanism_name() == "versus", "[flow_callback_carousel_get_current_set]: current mechanism has to be 'versus' ")

	return {
		set = Managers.mechanism:game_mechanism():get_current_set()
	}
end

function flow_callback_carousel_force_start_round(arg_387_0)
	-- function 387
	assert(Managers.mechanism:current_mechanism_name() == "versus", "[flow_callback_carousel_force_start_round]: current mechanism has to be 'versus' ")

	local entity = Managers.state.entity

	if not entity and not entity:system("round_started_system") then
		entity:system("round_started_system"):force_start_round()
	end
end

function flow_set_numeric_flow_variable(self)
	-- function 388
	local unit = self.unit
	local name = self.name
	local value = self.value

	Unit.set_flow_variable(unit, name, value)
end

function flow_callback_set_faction_memory(self)
	-- function 389
	Managers.state.entity:system("dialogue_system"):set_faction_memory(self.faction, self.key, self.value)
end

function flow_callback_set_user_memory(self)
	-- function 390
	Managers.state.entity:system("dialogue_system"):set_user_memory(self.unit, self.key, self.value)
end

function flow_callback_set_user_context(self)
	-- function 391
	Managers.state.entity:system("dialogue_system"):set_user_context(self.unit, self.key, self.value)
end

function flow_callback_set_global_context(self)
	-- function 392
	Managers.state.entity:system("dialogue_system"):set_global_context(self.key, self.value)
end

function flow_callback_run_faction_op(self)
	-- function 393
	local unit = self.unit
	local faction = self.faction
	local argument_name = self.argument_name
	local op = self.op
	local optional_argument_value = self.optional_argument_value

	Managers.state.entity:system("dialogue_system"):force_faction_op(unit, faction, argument_name, op, optional_argument_value)
end

function flow_callback_lock_available_hero(arg_394_0)
	-- function 394
	local lock_available_hero = Managers.state.game_mode:lock_available_hero()

	assert(lock_available_hero, "[flow_callback_lock_available_hero] Couldn't find any available hero")

	flow_return_table.locked_profile_index = lock_available_hero

	return flow_return_table
end

function flow_callback_whaling_village_buboes_destroyed(arg_395_0)
	-- function 395
	Managers.state.achievement:trigger_event("dwarf_feculent_buboes")
end

function flow_callback_whaling_village_statue_emote(self)
	-- function 396
	Managers.state.achievement:trigger_event("dwarf_statue_emote", self.is_inside)
end

function flow_callback_whaling_village_go_fish(arg_397_0)
	-- function 397
	Managers.state.achievement:trigger_event("dwarf_go_fish")
end

function flow_callback_whaling_village_elevator_speedrun(arg_398_0)
	-- function 398
	Managers.state.achievement:trigger_event("dwarf_elevator_speedrun")
end

function flow_callback_termite_part_1_skaven_markings_challenge(arg_399_0)
	-- function 399
	Managers.state.achievement:trigger_event("termite1_skaven_markings_challenge")
end

function flow_callback_termite_part_1_bell_challenge(arg_400_0)
	-- function 400
	Managers.state.achievement:trigger_event("termite1_bell_challenge")
end

function flow_callback_termite_part_1_towers_challenge(arg_401_0)
	-- function 401
	Managers.state.achievement:trigger_event("termite1_towers_challenge")
end

function flow_callback_termite_part_1_waystone_timer_challenge_easy(arg_402_0)
	-- function 402
	Managers.state.achievement:trigger_event("termite1_waystone_timer_challenge_easy")
end

function flow_callback_termite_part_1_waystone_timer_challenge_hard(arg_403_0)
	-- function 403
	Managers.state.achievement:trigger_event("termite1_waystone_timer_challenge_hard")
end

function flow_callback_termite_part_2_mushroom_challenge(arg_404_0)
	-- function 404
	Managers.state.achievement:trigger_event("termite2_mushroom_challenge")
end

function flow_callback_termite_part_2_timer_challenge(arg_405_0)
	-- function 405
	Managers.state.achievement:trigger_event("termite2_timer_challenge")
end

function flow_callback_termite_part_3_collectible_challenge(arg_406_0)
	-- function 406
	Managers.state.achievement:trigger_event("termite3_collectible_challenge")
end

function flow_callback_termite_part_3_searchlight_challenge(arg_407_0)
	-- function 407
	Managers.state.achievement:trigger_event("termite3_searchlight_challenge")
end

function flow_callback_termite_part_3_generator_challenge(arg_408_0)
	-- function 408
	Managers.state.achievement:trigger_event("termite3_generator_challenge")
end

function flow_callback_termite_part_3_portal_challenge(arg_409_0)
	-- function 409
	Managers.state.achievement:trigger_event("termite3_portal_challenge")
end

function flow_callback_divine_sink_ships_challenge(self)
	-- function 410
	Managers.state.achievement:trigger_event("divine_sink_ships_challenge", self.challenge_start)
end

function flow_callback_divine_anchor_attached(arg_411_0)
	-- function 411
	Managers.state.achievement:trigger_event("divine_anchor_attached")
end

function flow_callback_divine_anchor_destroyed(arg_412_0)
	-- function 412
	Managers.state.achievement:trigger_event("divine_anchor_destroyed")
end

function flow_callback_divine_anchor_completed(arg_413_0)
	-- function 413
	Managers.state.achievement:trigger_event("divine_anchor_challenge_completed")
end

function flow_callback_divine_nautical_miles_challenge(arg_414_0)
	-- function 414
	Managers.state.achievement:trigger_event("divine_nautical_miles_challenge")
end

function flow_callback_divine_cannon_challenge(arg_415_0)
	-- function 415
	Managers.state.achievement:trigger_event("divine_cannon_challenge")
end

function flow_callback_register_combination_puzzle(self)
	-- function 416
	local puzzle_group = self.puzzle_group
	local puzzle_name = self.puzzle_name

	puzzle_name = puzzle_name or ""

	local puzzle_combination = self.puzzle_combination
	local ordered = self.ordered
	local completed_level_event = self.completed_level_event
	local hot_join_sync_completion = self.hot_join_sync_completion

	if not (not puzzle_group and puzzle_combination) then
		return
	end

	local entity = Managers.state.entity
	local flag = not entity and entity:system("puzzle_system")

	if not flag then
		flag:register_puzzle(puzzle_group, puzzle_name, puzzle_combination, ordered, completed_level_event, hot_join_sync_completion)
	else
		ferror("Puzzle '%s' was registered before systems were created", puzzle_group)
	end
end

function flow_callback_register_random_match_puzzle(self)
	-- function 417
	local puzzle_group = self.puzzle_group
	local puzzle_name = self.puzzle_name

	puzzle_name = puzzle_name or ""

	local possible_values = self.possible_values
	local num_needed_matches = self.num_needed_matches
	local completed_level_event = self.completed_level_event
	local hot_join_sync_completion = self.hot_join_sync_completion

	if not (not puzzle_group and not possible_values and num_needed_matches) then
		return
	end

	local num = 6
	local split_deprecated = string.split_deprecated(possible_values, ",")
	local num_2 = Managers.mechanism:get_level_seed() + HashUtils.fnv32_hash(puzzle_group) + HashUtils.fnv32_hash(puzzle_name)
	local alloc_table = FrameTable.alloc_table()

	for i = 1, math.min(num_needed_matches, num) do
		local var_417_10
		local var_417_11

		num_2, var_417_11 = Math.next_random(num_2, 1, #split_deprecated)

		local var_417_12

		if not table.contains(alloc_table, split_deprecated[var_417_11]) then
			local var_417_13 = var_417_11

			repeat
				var_417_11 = math.index_wrapper(var_417_11 + 1, #split_deprecated)
			until not (not table.contains(alloc_table, split_deprecated[var_417_11]) and var_417_11 ~= var_417_13)
		end

		alloc_table[i] = split_deprecated[var_417_11]
		flow_return_table["chosen_value" .. i] = split_deprecated[var_417_11]
	end

	for j = num_needed_matches + 1, num do
		flow_return_table["chosen_value" .. j] = ""
	end

	local concat = table.concat(alloc_table, ",")
	local flag = false
	local entity = Managers.state.entity
	local flag_2 = not entity and entity:system("puzzle_system")

	if not flag_2 then
		flag_2:register_puzzle(puzzle_group, puzzle_name, concat, flag, completed_level_event, hot_join_sync_completion)
	end

	return flow_return_table
end

function flow_callback_string_to_numeric(self)
	-- function 418
	local var_418_0 = tonumber(self.string)

	flow_return_table.value = var_418_0 or 0
	flow_return_table.success = not not var_418_0

	return flow_return_table
end

local tbl_5 = {
	True = true,
	TRUE = true,
	["true"] = true,
	False = false,
	["false"] = false,
	FALSE = false
}

function flow_callback_string_to_bool(self)
	-- function 419
	local var_419_0 = tbl_5[self.string]

	flow_return_table.value = var_419_0 or false
	flow_return_table.success = var_419_0 ~= nil

	return flow_return_table
end

function flow_callback_string_to_bool(self)
	-- function 420
	local var_420_0 = tbl_5[self.string]

	flow_return_table.value = var_420_0 or false
	flow_return_table.success = var_420_0 ~= nil

	return flow_return_table
end

function flow_callback_get_mechanism_name(arg_421_0)
	-- function 421
	local current_mechanism_name = Managers.mechanism:current_mechanism_name()

	flow_return_table.name = current_mechanism_name

	return flow_return_table
end

function flow_callbacks_flow_helper_register_check_unit_line_of_sight(self)
	-- function 422
	if not Managers.state.network then
		return
	end

	local owner_unit = self.owner_unit
	local raycast_from_unit = self.raycast_from_unit
	local node

	if not self.raycast_from_node and not Unit.alive(raycast_from_unit) then
		node = Unit.node(raycast_from_unit, self.raycast_from_node)

		if not node then
			-- Nothing
		end
	end

	node = 0

	::label_422_0::

	local unit_to_check = self.unit_to_check
	local ignore_if_invisible = self.ignore_if_invisible
	local flow_event_enter = self.flow_event_enter
	local flow_event_leave = self.flow_event_leave
	local collision_filter = self.collision_filter
	local debug_draw = self.debug_draw

	Managers.state.flow_helper:register_line_of_sight_check(owner_unit, raycast_from_unit, node, unit_to_check, ignore_if_invisible, flow_event_enter, flow_event_leave, collision_filter, debug_draw)
end

function flow_callbacks_flow_helper_unregister_check_unit_line_of_sight(self)
	-- function 423
	if not Managers.state.network then
		return
	end

	local owner_unit = self.owner_unit
	local unit_to_check = self.unit_to_check

	Managers.state.flow_helper:unregister_line_of_sight_check(owner_unit, unit_to_check)
end

function flow_force_abort_interactable(self)
	-- function 424
	if not (not Managers.state.network and Managers.state.network.is_server) then
		return
	end

	local interactable_unit = self.interactable_unit
	local is_being_interacted_with = ScriptUnit.extension(interactable_unit, "interactable_system"):is_being_interacted_with()

	if not is_being_interacted_with then
		return
	end

	InteractionHelper:complete_interaction(is_being_interacted_with, interactable_unit, InteractionResult.FAILURE)
end

function flow_callbacks_get_local_player_team_data(arg_425_0)
	-- function 425
	flow_return_table.party_name = "undecided"
	flow_return_table.team_name = "undecided"

	local local_player = Managers.player:local_player()

	if not local_player then
		return flow_return_table
	end

	local get_party_from_unique_id = Managers.party:get_party_from_unique_id(local_player:unique_id())

	if not get_party_from_unique_id then
		return flow_return_table
	end

	flow_return_table.party_name = get_party_from_unique_id.name

	local var_425_2 = Managers.state.game_mode:setting("party_names_lookup_by_id")[get_party_from_unique_id.party_id]

	flow_return_table.team_name = var_425_2

	return flow_return_table
end

function flow_callbacks_get_death_reaction_attacker_unit(arg_426_0)
	-- function 426
	local flow_get_killing_blow_attacker_unit = Managers.state.entity:system("death_system"):flow_get_killing_blow_attacker_unit()

	flow_return_table.attacker_unit = not Unit.alive(flow_get_killing_blow_attacker_unit) and flow_get_killing_blow_attacker_unit and Unit.null_reference()

	return flow_return_table
end

function flow_callbacks_get_owner_of_unit_that_occupied_objective_socket(self)
	-- function 427
	local get_owner_of_unit_that_occupied_socket = Managers.state.entity:system("objective_socket_system"):get_owner_of_unit_that_occupied_socket(self.socket_unit, self.socket_name)

	flow_return_table.owner_unit = not Unit.alive(get_owner_of_unit_that_occupied_socket) and get_owner_of_unit_that_occupied_socket and Unit.null_reference()

	return flow_return_table
end

function flow_query_is_special_event_active(arg_428_0)
	-- function 428
	flow_return_table.is_event_active = false

	local get_interface = Managers.backend:get_interface("live_events")

	if not get_interface and not get_interface.get_active_events then
		local get_active_events = get_interface:get_active_events()

		if not (not get_active_events and #get_active_events == 0) then
			flow_return_table.is_event_active = true
		end
	end

	return flow_return_table
end

function flow_query_global_listener(self)
	-- function 429
	local dialogue_profile = self.dialogue_profile

	if not Managers.state.entity then
		local system = Managers.state.entity:system("surrounding_aware_system")
		local var_429_2 = flow_return_table
		local query_global_listener = system:query_global_listener(dialogue_profile)

		query_global_listener = query_global_listener or Unit.null_reference()
		var_429_2.unit = query_global_listener
	else
		flow_return_table.unit = Unit.null_reference()
	end

	return flow_return_table
end

function flow_callbacks_set_story_trigger_frozen(self)
	-- function 430
	local frozen = self.frozen
	local entity = Managers.state.entity

	if not entity then
		local system = entity:system("dialogue_system")

		if not frozen then
			system:freeze_story_trigger()
		else
			system:unfreeze_story_trigger()
		end
	end
end

function flow_callbacks_teleport_non_character_elevator_units(self)
	-- function 431
	local transport_unit = self.transport_unit
	local has_extension = ScriptUnit.has_extension(transport_unit, "transportation_system")

	if not has_extension then
		local to_reference_unit = self.to_reference_unit

		if not Unit.alive(to_reference_unit) then
			has_extension:teleport_non_character_elevator_units(to_reference_unit)
		end
	end
end

function flow_query_is_level_unit(self)
	-- function 432
	local unit = self.unit
	local flow_callback_context_world = Application.flow_callback_context_world()
	local current_level = LevelHelper:current_level(flow_callback_context_world)
	local unit_index = Level.unit_index(current_level, unit)

	flow_return_table.is_level_unit = not not unit_index

	return flow_return_table
end

function flow_query_is_game_object_unit(self)
	-- function 433
	local unit = self.unit
	local flow_callback_context_world = Application.flow_callback_context_world()
	local current_level = LevelHelper:current_level(flow_callback_context_world)
	local unit_index = Level.unit_index(current_level, unit)

	flow_return_table.is_game_object_unit = not unit_index

	return flow_return_table
end

function flow_wwise_set_state_synced(self)
	-- function 434
	if not Managers.music then
		local music_player = self.music_player
		local group = self.group
		local state = self.state

		Managers.music:set_music_group_state(music_player, group, state)
	end
end

function flow_callback_string_or_default(self)
	-- function 435
	local string = self.string
	local default = self.default

	if not (not string and string ~= "") then
		flow_return_table.out_string = default
	else
		flow_return_table.out_string = string
	end

	return flow_return_table
end

function flow_callback_actor_has_collision_filter(self)
	-- function 436
	local actor = self.actor
	local collision_filter = self.collision_filter

	flow_return_table.result = Actor.has_collision_filter(actor, collision_filter)

	return flow_return_table
end

local tbl_6 = {}

function flow_callback_once_by_unit(self)
	-- function 437
	local unit = self.unit
	local flow_callback_context_level = Application.flow_callback_context_level()

	if not flow_callback_context_level then
		flow_return_table.out = false

		return flow_return_table
	end

	if not tbl_6[flow_callback_context_level] then
		table.clear(tbl_6)

		tbl_6[flow_callback_context_level] = {}
	end

	if unit == Unit.null_reference() then
		flow_return_table.out = false
	else
		flow_return_table.out = not tbl_6[flow_callback_context_level][unit]
		tbl_6[flow_callback_context_level][unit] = true
	end

	return flow_return_table
end
