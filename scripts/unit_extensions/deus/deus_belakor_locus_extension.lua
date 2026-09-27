-- chunkname: @scripts/unit_extensions/deus/deus_belakor_locus_extension.lua

local num = 60
local num_2 = 20
local num_3 = 10
local tbl = {
	INITIAL = 0,
	DONE = 4,
	ACTIVATED = 3,
	WAITING_TO_SPAWN_CULTISTS = 1,
	WAITING_FOR_ACTIVATION = 2
}
local num_4 = 3
local num_5 = 5
local str = "deus_belakor_locus_pre_crystal"
local str_2 = "deus_belakor_locus_with_crystal"
local str_3 = "fx/trail_locus"
local num_6 = 8
local num_7 = 2
local tbl_2 = {
	"SHOW_RUNE_01",
	"SHOW_RUNE_02",
	"SHOW_RUNE_03"
}
local tbl_3 = {
	"belakor_altar_shadow_lieutenant_spawn_01",
	"belakor_altar_shadow_lieutenant_spawn_02",
	"belakor_altar_shadow_lieutenant_spawn_03"
}
local tbl_4 = {
	"units/decals/decal_belakor_arena_01",
	"units/decals/decal_belakor_arena_02",
	"units/decals/decal_belakor_arena_03"
}

local function fn(self, arg_1_1)
	-- function 1
	local main_path_info = self.main_path_info
	local main_path_player_info = self.main_path_player_info
	local var_1_2
	local var_1_3 = main_path_player_info[main_path_info.ahead_unit]

	if not var_1_3 then
		return false
	end

	return var_1_3.travel_dist > arg_1_1 - num
end

local function fn_2(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local var_2_0
	local var_2_1
	local huge = math.huge

	for i = 1, #arg_2_3 do
		local var_2_3 = arg_2_3[i]
		local var_2_4 = POSITION_LOOKUP[var_2_3]
		local distance = Vector3.distance(arg_2_2, var_2_4)

		if not (not var_2_0 and not (distance < huge)) then
			huge = distance
			var_2_0 = var_2_4
			var_2_1 = var_2_3
		end
	end

	if not var_2_0 then
		return false
	end

	if huge > num_2 then
		return false
	end

	local num = arg_2_2 + Vector3(0, 0, 1.5)
	local num_3 = var_2_0 + Vector3(0, 0, 1.5)
	local flag = not World.umbra_available(arg_2_0) and World.umbra_has_line_of_sight(arg_2_0, num, num_3)

	if not flag then
		return flag
	else
		return flag, var_2_1
	end
end

DeusBelakorLocusExtension = class(DeusBelakorLocusExtension)

DeusBelakorLocusExtension.init = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	self._unit = arg_3_2
	self._is_server = Managers.player.is_server
	self._world = arg_3_1.world
	self._hero_side = Managers.state.side:get_side_from_name("heroes")
	self._arena_mode = Managers.mechanism:game_mechanism():get_deus_run_controller():get_current_node().base_level == "arena_belakor"

	if not self._is_server then
		return
	end

	self._prev_state = tbl.INITIAL
end

DeusBelakorLocusExtension.game_object_initialized = function (self, arg_4_1, arg_4_2)
	-- function 4
	self:_set_state(tbl.WAITING_TO_SPAWN_CULTISTS)
end

DeusBelakorLocusExtension.extensions_ready = function (self, arg_5_1, arg_5_2)
	-- function 5
	self._interactable_extension = ScriptUnit.extension(arg_5_2, "interactable_system")
end

DeusBelakorLocusExtension.destroy = function (self)
	-- function 6
	if not self._statue_beam then
		World.destroy_particles(self._world, self._statue_beam)

		self._statue_beam = nil
	end
end

DeusBelakorLocusExtension.connect_to_statue = function (self, arg_7_1, arg_7_2)
	-- function 7
	if self:_get_state() ~= tbl.DONE then
		self._statue_unit = arg_7_1

		local _world = self._world
		local num = Unit.local_position(self._unit, 0) + Vector3(0, 0, num_7)
		local translation = Matrix4x4.translation(arg_7_2)
		local num_2 = num + Vector3(0, 0, 2)
		local num_3 = translation - num

		num_3.z = 0

		local num_4 = translation + Vector3.normalize(num_3) * 2
		local create_particles = World.create_particles(_world, str_3, Vector3.zero(), Quaternion.identity())

		self._statue_beam = create_particles

		local find_particles_variable = World.find_particles_variable(_world, str_3, 1)

		World.set_particles_variable(_world, create_particles, find_particles_variable, num)

		local find_particles_variable_2 = World.find_particles_variable(_world, str_3, 2)

		World.set_particles_variable(_world, create_particles, find_particles_variable_2, num_2)

		local find_particles_variable_3 = World.find_particles_variable(_world, str_3, 3)

		World.set_particles_variable(_world, create_particles, find_particles_variable_3, num_4)

		local find_particles_variable_4 = World.find_particles_variable(_world, str_3, 4)

		World.set_particles_variable(_world, create_particles, find_particles_variable_4, translation)

		local var_7_11 = translation
		local rotation = Matrix4x4.rotation(arg_7_2)

		self._statue_decal = Managers.state.unit_spawner:spawn_local_unit(tbl_4[self._locus_type], var_7_11, rotation, "units/materials/d/decal/decal_belakor_arena_01")
	end
end

DeusBelakorLocusExtension.update = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	if not self._go_id then
		self._go_id = Managers.state.unit_storage:go_id(self._unit)

		if not self._go_id then
			local fnv32_hash = HashUtils.fnv32_hash(self._go_id)
			local create_random_generator = DeusGenUtils.create_random_generator(fnv32_hash)

			self._locus_type = create_random_generator(1, num_4)
			self._random_generator = create_random_generator

			local var_8_2 = tbl_2[self._locus_type]

			if not var_8_2 then
				Unit.flow_event(self._unit, var_8_2)
			end
		end
	end

	if not self._paused then
		return
	end

	if not self._is_server then
		local local_position = Unit.local_position(arg_8_1, 0)

		if self._already_played_vo or not self._random_generator then
			local PLAYER_AND_BOT_UNITS = self._hero_side.PLAYER_AND_BOT_UNITS
			local _world = self._world
			local var_8_6, var_8_7 = fn_2(_world, arg_8_1, local_position, PLAYER_AND_BOT_UNITS)

			if not var_8_6 then
				local find_dialogue_unit = LevelHelper:find_dialogue_unit(_world, "ferry_lady")
				local flag = not (not find_dialogue_unit and ScriptUnit.has_extension(find_dialogue_unit, "dialogue_system")) and ScriptUnit.extension_input(find_dialogue_unit, "dialogue_system")
				local flag_2 = not ScriptUnit.has_extension(var_8_7, "dialogue_system") and ScriptUnit.extension_input(var_8_7, "dialogue_system")
				local tbl_4 = {}

				if not flag then
					tbl_4[#tbl_4 + 1] = flag
				end

				tbl_4[#tbl_4 + 1] = flag_2

				local var_8_12 = tbl_4[self._random_generator(1, #tbl_4)]
				local alloc_table = FrameTable.alloc_table()

				var_8_12:trigger_dialogue_event("shadow_curse_worship_site_nearby", alloc_table)

				self._already_played_vo = true
			end
		end

		if self:_get_state() == tbl.WAITING_TO_SPAWN_CULTISTS then
			local conflict = Managers.state.conflict

			if not self._altar_main_path_distance then
				local get_main_paths = conflict.level_analysis:get_main_paths()
				local closest_pos_at_main_path, var_8_17 = MainPathUtils.closest_pos_at_main_path(get_main_paths, local_position)

				self._altar_main_path_distance = var_8_17
			end

			if not fn(conflict, self._altar_main_path_distance) then
				local get_level_seed = Managers.mechanism:get_level_seed()

				self._cultist_terror_event_id = Managers.state.conflict:start_terror_event("belakor_altar_cultists_spawn", get_level_seed, arg_8_1)

				self:_set_state(tbl.WAITING_FOR_ACTIVATION)
			end
		end
	end

	local _get_state = self:_get_state()

	if not (_get_state == self._prev_state or _get_state ~= tbl.WAITING_TO_SPAWN_CULTISTS) then
		-- Nothing
	elseif _get_state == tbl.WAITING_FOR_ACTIVATION then
		self._interactable_extension:set_interactable_type(str)
	elseif _get_state == tbl.ACTIVATED then
		Unit.flow_event(arg_8_1, "lieutenant_spawned")
		Managers.state.achievement:trigger_event("register_lieutenant_spawned")
		self._interactable_extension:set_interactable_type(str_2)

		if not self._statue_beam then
			World.destroy_particles(self._world, self._statue_beam)

			self._statue_beam = nil
		end

		if not self._statue_decal then
			Managers.state.unit_spawner:mark_for_deletion(self._statue_decal)

			self._statue_decal = nil
		end

		if not self._is_server then
			local get_level_seed_2 = Managers.mechanism:get_level_seed()
			local var_8_21 = tbl_3[self._locus_type]

			var_8_21 = var_8_21 or "belakor_shadow_lieutenant_spawn"

			Managers.state.conflict:start_terror_event(var_8_21, get_level_seed_2, arg_8_1)
		end
	elseif _get_state == tbl.DONE then
		Unit.flow_event(arg_8_1, "deactivated")

		if not self._arena_mode then
			Managers.state.achievement:trigger_event("register_locus_destroyed")
		end

		if not self._arena_mode then
			Managers.ui:get_hud_component("DeusCurseUI"):show_special_message("belakor", "deus_belakor_locus_arena_unlock_title", "deus_belakor_locus_arena_unlock_description", num_3)

			local wwise_world = Managers.world:wwise_world(self._world)

			WwiseWorld.trigger_event(wwise_world, "belakor_shadow_locus_arena_unlocked")

			if not self._is_server then
				local game_mechanism = Managers.mechanism:game_mechanism()
				local get_deus_run_controller = game_mechanism.get_deus_run_controller

				get_deus_run_controller = not get_deus_run_controller and game_mechanism:get_deus_run_controller()

				if not get_deus_run_controller then
					get_deus_run_controller:unlock_arena_belakor()
				end
			end
		end
	end

	self._prev_state = _get_state
end

DeusBelakorLocusExtension.activate = function (self)
	-- function 9
	self._paused = false
end

DeusBelakorLocusExtension.deactivate = function (self)
	-- function 10
	self._paused = true
end

DeusBelakorLocusExtension.is_complete = function (self)
	-- function 11
	return self:_get_state() == tbl.DONE
end

DeusBelakorLocusExtension._get_state = function (self)
	-- function 12
	local game = Managers.state.network:game()
	local go_id = Managers.state.unit_storage:go_id(self._unit)

	if not (not game and go_id) then
		return tbl.INITIAL
	end

	return GameSession.game_object_field(game, go_id, "deus_belakor_locus_state")
end

DeusBelakorLocusExtension._set_state = function (self, arg_13_1)
	-- function 13
	local game = Managers.state.network:game()
	local go_id = Managers.state.unit_storage:go_id(self._unit)

	fassert(not game and go_id, "setting state without network setup done")
	GameSession.set_game_object_field(game, go_id, "deus_belakor_locus_state", arg_13_1)
end

DeusBelakorLocusExtension.can_interact_validate = function (arg_14_0, arg_14_1)
	-- function 14
	local has_extension = ScriptUnit.has_extension(arg_14_1, "inventory_system")

	if not has_extension and not has_extension:has_inventory_item("slot_level_event", "belakor_crystal") then
		return true
	end

	return false
end

DeusBelakorLocusExtension.can_interact = function (self)
	-- function 15
	local _get_state = self:_get_state()

	if _get_state == tbl.WAITING_FOR_ACTIVATION then
		return true
	end

	if _get_state == tbl.ACTIVATED then
		local player = Managers.player
		local player_unit = player:local_player().player_unit

		if not ScriptUnit.extension(player_unit, "inventory_system"):has_inventory_item("slot_level_event", "belakor_crystal") then
			return true
		end

		local get_entities = Managers.state.entity:get_entities("DeusBelakorCrystalExtension")

		if not table.is_empty(get_entities) then
			return false, "deus_belakor_locus_throw_crystal_impeded_hud_desc"
		end

		local human_players = player:human_players()

		for k, v in pairs(human_players) do
			local player_unit_2 = v.player_unit
			local flag = not player_unit_2 and ScriptUnit.extension(player_unit_2, "inventory_system")

			if not flag and not flag:has_inventory_item("slot_level_event", "belakor_crystal") then
				return false, "deus_belakor_locus_throw_crystal_impeded_hud_desc"
			end
		end

		return false
	end

	return false
end

DeusBelakorLocusExtension.get_interaction_length = function (self)
	-- function 16
	local _get_state = self:_get_state()

	if not (_get_state == tbl.WAITING_FOR_ACTIVATION or _get_state ~= tbl.ACTIVATED) then
		local _unit = self._unit
		local get_data = Unit.get_data(_unit, "interaction_data", "interaction_length")

		fassert(get_data, "Interacting with %q that has no interaction length", _unit)

		return get_data
	else
		return 0
	end
end

DeusBelakorLocusExtension.get_interaction_action = function (self)
	-- function 17
	if self:_get_state() == tbl.ACTIVATED then
		local player = Managers.player
		local player_unit = player:local_player().player_unit

		if not ScriptUnit.extension(player_unit, "inventory_system"):has_inventory_item("slot_level_event", "belakor_crystal") then
			return "deus_belakor_locus_throw_crystal_hud_desc"
		end

		local get_entities = Managers.state.entity:get_entities("DeusBelakorCrystalExtension")

		if not table.is_empty(get_entities) then
			return "deus_belakor_locus_throw_crystal_impeded_hud_desc"
		end

		local human_players = player:human_players()

		for k, v in pairs(human_players) do
			local player_unit_2 = v.player_unit
			local flag = not player_unit_2 and ScriptUnit.extension(player_unit_2, "inventory_system")

			if not flag and not flag:has_inventory_item("slot_level_event", "belakor_crystal") then
				return "deus_belakor_locus_throw_crystal_impeded_hud_desc"
			end
		end
	end

	return "deus_belakor_locus_deactivate_hud_desc"
end

DeusBelakorLocusExtension.on_server_interact = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7)
	-- function 18
	local _get_state = self:_get_state()

	if _get_state == tbl.WAITING_FOR_ACTIVATION then
		self:_set_state(tbl.ACTIVATED)
	end

	if _get_state == tbl.ACTIVATED then
		self:_set_state(tbl.DONE)
	end
end

DeusBelakorLocusExtension.on_client_interact = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7)
	-- function 19
	if self:_get_state() == tbl.ACTIVATED then
		local extension = ScriptUnit.extension(arg_19_2, "inventory_system")

		extension:destroy_slot("slot_level_event")
		extension:wield_previous_weapon()
	end
end

DeusBelakorLocusExtension.on_server_start_interact = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6)
	-- function 20
	local var_20_0 = POSITION_LOOKUP[arg_20_3]
	local var_20_1 = num_5
	local alloc_table = FrameTable.alloc_table()
	local broadphase_query = AiUtils.broadphase_query(var_20_0, var_20_1, alloc_table)

	for i = 1, broadphase_query do
		local var_20_4 = alloc_table[i]

		if not ALIVE[var_20_4] then
			local has_extension = ScriptUnit.has_extension(var_20_4, "ai_group_system")

			if not (not has_extension and has_extension.template ~= "deus_belakor_locus_cultists") then
				AIGroupTemplates[has_extension.template].wake_up_group(has_extension.group, arg_20_2)
			end
		end
	end
end
