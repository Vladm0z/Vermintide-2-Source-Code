-- chunkname: @scripts/unit_extensions/deus/deus_belakor_locus_extension.lua

local var_0_0 = 60
local var_0_1 = 20
local var_0_2 = 10
local var_0_3 = {
	INITIAL = 0,
	DONE = 4,
	ACTIVATED = 3,
	WAITING_TO_SPAWN_CULTISTS = 1,
	WAITING_FOR_ACTIVATION = 2
}
local var_0_4 = 3
local var_0_5 = 5
local var_0_6 = "deus_belakor_locus_pre_crystal"
local var_0_7 = "deus_belakor_locus_with_crystal"
local var_0_8 = "fx/trail_locus"
local var_0_9 = 8
local var_0_10 = 2
local var_0_11 = {
	"SHOW_RUNE_01",
	"SHOW_RUNE_02",
	"SHOW_RUNE_03"
}
local var_0_12 = {
	"belakor_altar_shadow_lieutenant_spawn_01",
	"belakor_altar_shadow_lieutenant_spawn_02",
	"belakor_altar_shadow_lieutenant_spawn_03"
}
local var_0_13 = {
	"units/decals/decal_belakor_arena_01",
	"units/decals/decal_belakor_arena_02",
	"units/decals/decal_belakor_arena_03"
}

local function var_0_14(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_0.main_path_info
	local var_1_1 = arg_1_0.main_path_player_info
	local var_1_2
	local var_1_3 = var_1_1[var_1_0.ahead_unit]

	if not var_1_3 then
		return false
	end

	return var_1_3.travel_dist > arg_1_1 - var_0_0
end

local function var_0_15(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0
	local var_2_1
	local var_2_2 = math.huge

	for iter_2_0 = 1, #arg_2_3 do
		local var_2_3 = arg_2_3[iter_2_0]
		local var_2_4 = POSITION_LOOKUP[var_2_3]
		local var_2_5 = Vector3.distance(arg_2_2, var_2_4)

		if not var_2_0 or var_2_5 < var_2_2 then
			var_2_2 = var_2_5
			var_2_0 = var_2_4
			var_2_1 = var_2_3
		end
	end

	if not var_2_0 then
		return false
	end

	if var_2_2 > var_0_1 then
		return false
	end

	local var_2_6 = arg_2_2 + Vector3(0, 0, 1.5)
	local var_2_7 = var_2_0 + Vector3(0, 0, 1.5)
	local var_2_8 = not World.umbra_available(arg_2_0) or World.umbra_has_line_of_sight(arg_2_0, var_2_6, var_2_7)

	if not var_2_8 then
		return var_2_8
	else
		return var_2_8, var_2_1
	end
end

DeusBelakorLocusExtension = class(DeusBelakorLocusExtension)

function DeusBelakorLocusExtension.init(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_0._unit = arg_3_2
	arg_3_0._is_server = Managers.player.is_server
	arg_3_0._world = arg_3_1.world
	arg_3_0._hero_side = Managers.state.side:get_side_from_name("heroes")
	arg_3_0._arena_mode = Managers.mechanism:game_mechanism():get_deus_run_controller():get_current_node().base_level == "arena_belakor"

	if not arg_3_0._is_server then
		return
	end

	arg_3_0._prev_state = var_0_3.INITIAL
end

function DeusBelakorLocusExtension.game_object_initialized(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0:_set_state(var_0_3.WAITING_TO_SPAWN_CULTISTS)
end

function DeusBelakorLocusExtension.extensions_ready(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0._interactable_extension = ScriptUnit.extension(arg_5_2, "interactable_system")
end

function DeusBelakorLocusExtension.destroy(arg_6_0)
	if arg_6_0._statue_beam then
		World.destroy_particles(arg_6_0._world, arg_6_0._statue_beam)

		arg_6_0._statue_beam = nil
	end
end

function DeusBelakorLocusExtension.connect_to_statue(arg_7_0, arg_7_1, arg_7_2)
	if arg_7_0:_get_state() ~= var_0_3.DONE then
		arg_7_0._statue_unit = arg_7_1

		local var_7_0 = arg_7_0._world
		local var_7_1 = Unit.local_position(arg_7_0._unit, 0) + Vector3(0, 0, var_0_10)
		local var_7_2 = Matrix4x4.translation(arg_7_2)
		local var_7_3 = var_7_1 + Vector3(0, 0, 2)
		local var_7_4 = var_7_2 - var_7_1

		var_7_4.z = 0

		local var_7_5 = var_7_2 + Vector3.normalize(var_7_4) * 2
		local var_7_6 = World.create_particles(var_7_0, var_0_8, Vector3.zero(), Quaternion.identity())

		arg_7_0._statue_beam = var_7_6

		local var_7_7 = World.find_particles_variable(var_7_0, var_0_8, 1)

		World.set_particles_variable(var_7_0, var_7_6, var_7_7, var_7_1)

		local var_7_8 = World.find_particles_variable(var_7_0, var_0_8, 2)

		World.set_particles_variable(var_7_0, var_7_6, var_7_8, var_7_3)

		local var_7_9 = World.find_particles_variable(var_7_0, var_0_8, 3)

		World.set_particles_variable(var_7_0, var_7_6, var_7_9, var_7_5)

		local var_7_10 = World.find_particles_variable(var_7_0, var_0_8, 4)

		World.set_particles_variable(var_7_0, var_7_6, var_7_10, var_7_2)

		local var_7_11 = var_7_2
		local var_7_12 = Matrix4x4.rotation(arg_7_2)

		arg_7_0._statue_decal = Managers.state.unit_spawner:spawn_local_unit(var_0_13[arg_7_0._locus_type], var_7_11, var_7_12, "units/materials/d/decal/decal_belakor_arena_01")
	end
end

function DeusBelakorLocusExtension.update(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	if not arg_8_0._go_id then
		arg_8_0._go_id = Managers.state.unit_storage:go_id(arg_8_0._unit)

		if arg_8_0._go_id then
			local var_8_0 = HashUtils.fnv32_hash(arg_8_0._go_id)
			local var_8_1 = DeusGenUtils.create_random_generator(var_8_0)

			arg_8_0._locus_type = var_8_1(1, var_0_4)
			arg_8_0._random_generator = var_8_1

			local var_8_2 = var_0_11[arg_8_0._locus_type]

			if var_8_2 then
				Unit.flow_event(arg_8_0._unit, var_8_2)
			end
		end
	end

	if arg_8_0._paused then
		return
	end

	if arg_8_0._is_server then
		local var_8_3 = Unit.local_position(arg_8_1, 0)

		if not arg_8_0._already_played_vo and arg_8_0._random_generator then
			local var_8_4 = arg_8_0._hero_side.PLAYER_AND_BOT_UNITS
			local var_8_5 = arg_8_0._world
			local var_8_6, var_8_7 = var_0_15(var_8_5, arg_8_1, var_8_3, var_8_4)

			if var_8_6 then
				local var_8_8 = LevelHelper:find_dialogue_unit(var_8_5, "ferry_lady")
				local var_8_9 = var_8_8 and ScriptUnit.has_extension(var_8_8, "dialogue_system") and ScriptUnit.extension_input(var_8_8, "dialogue_system")
				local var_8_10 = ScriptUnit.has_extension(var_8_7, "dialogue_system") and ScriptUnit.extension_input(var_8_7, "dialogue_system")
				local var_8_11 = {}

				if var_8_9 then
					var_8_11[#var_8_11 + 1] = var_8_9
				end

				var_8_11[#var_8_11 + 1] = var_8_10

				local var_8_12 = var_8_11[arg_8_0._random_generator(1, #var_8_11)]
				local var_8_13 = FrameTable.alloc_table()

				var_8_12:trigger_dialogue_event("shadow_curse_worship_site_nearby", var_8_13)

				arg_8_0._already_played_vo = true
			end
		end

		if arg_8_0:_get_state() == var_0_3.WAITING_TO_SPAWN_CULTISTS then
			local var_8_14 = Managers.state.conflict

			if not arg_8_0._altar_main_path_distance then
				local var_8_15 = var_8_14.level_analysis:get_main_paths()
				local var_8_16, var_8_17 = MainPathUtils.closest_pos_at_main_path(var_8_15, var_8_3)

				arg_8_0._altar_main_path_distance = var_8_17
			end

			if var_0_14(var_8_14, arg_8_0._altar_main_path_distance) then
				local var_8_18 = Managers.mechanism:get_level_seed()

				arg_8_0._cultist_terror_event_id = Managers.state.conflict:start_terror_event("belakor_altar_cultists_spawn", var_8_18, arg_8_1)

				arg_8_0:_set_state(var_0_3.WAITING_FOR_ACTIVATION)
			end
		end
	end

	local var_8_19 = arg_8_0:_get_state()

	if var_8_19 == arg_8_0._prev_state or var_8_19 == var_0_3.WAITING_TO_SPAWN_CULTISTS then
		-- block empty
	elseif var_8_19 == var_0_3.WAITING_FOR_ACTIVATION then
		arg_8_0._interactable_extension:set_interactable_type(var_0_6)
	elseif var_8_19 == var_0_3.ACTIVATED then
		Unit.flow_event(arg_8_1, "lieutenant_spawned")
		Managers.state.achievement:trigger_event("register_lieutenant_spawned")
		arg_8_0._interactable_extension:set_interactable_type(var_0_7)

		if arg_8_0._statue_beam then
			World.destroy_particles(arg_8_0._world, arg_8_0._statue_beam)

			arg_8_0._statue_beam = nil
		end

		if arg_8_0._statue_decal then
			Managers.state.unit_spawner:mark_for_deletion(arg_8_0._statue_decal)

			arg_8_0._statue_decal = nil
		end

		if arg_8_0._is_server then
			local var_8_20 = Managers.mechanism:get_level_seed()
			local var_8_21 = var_0_12[arg_8_0._locus_type] or "belakor_shadow_lieutenant_spawn"

			Managers.state.conflict:start_terror_event(var_8_21, var_8_20, arg_8_1)
		end
	elseif var_8_19 == var_0_3.DONE then
		Unit.flow_event(arg_8_1, "deactivated")

		if arg_8_0._arena_mode then
			Managers.state.achievement:trigger_event("register_locus_destroyed")
		end

		if not arg_8_0._arena_mode then
			Managers.ui:get_hud_component("DeusCurseUI"):show_special_message("belakor", "deus_belakor_locus_arena_unlock_title", "deus_belakor_locus_arena_unlock_description", var_0_2)

			local var_8_22 = Managers.world:wwise_world(arg_8_0._world)

			WwiseWorld.trigger_event(var_8_22, "belakor_shadow_locus_arena_unlocked")

			if arg_8_0._is_server then
				local var_8_23 = Managers.mechanism:game_mechanism()
				local var_8_24 = var_8_23.get_deus_run_controller and var_8_23:get_deus_run_controller()

				if var_8_24 then
					var_8_24:unlock_arena_belakor()
				end
			end
		end
	end

	arg_8_0._prev_state = var_8_19
end

function DeusBelakorLocusExtension.activate(arg_9_0)
	arg_9_0._paused = false
end

function DeusBelakorLocusExtension.deactivate(arg_10_0)
	arg_10_0._paused = true
end

function DeusBelakorLocusExtension.is_complete(arg_11_0)
	return arg_11_0:_get_state() == var_0_3.DONE
end

function DeusBelakorLocusExtension._get_state(arg_12_0)
	local var_12_0 = Managers.state.network:game()
	local var_12_1 = Managers.state.unit_storage:go_id(arg_12_0._unit)

	if not var_12_0 or not var_12_1 then
		return var_0_3.INITIAL
	end

	return GameSession.game_object_field(var_12_0, var_12_1, "deus_belakor_locus_state")
end

function DeusBelakorLocusExtension._set_state(arg_13_0, arg_13_1)
	local var_13_0 = Managers.state.network:game()
	local var_13_1 = Managers.state.unit_storage:go_id(arg_13_0._unit)

	fassert(var_13_0 and var_13_1, "setting state without network setup done")
	GameSession.set_game_object_field(var_13_0, var_13_1, "deus_belakor_locus_state", arg_13_1)
end

function DeusBelakorLocusExtension.can_interact_validate(arg_14_0, arg_14_1)
	local var_14_0 = ScriptUnit.has_extension(arg_14_1, "inventory_system")

	if var_14_0 and var_14_0:has_inventory_item("slot_level_event", "belakor_crystal") then
		return true
	end

	return false
end

function DeusBelakorLocusExtension.can_interact(arg_15_0)
	local var_15_0 = arg_15_0:_get_state()

	if var_15_0 == var_0_3.WAITING_FOR_ACTIVATION then
		return true
	end

	if var_15_0 == var_0_3.ACTIVATED then
		local var_15_1 = Managers.player
		local var_15_2 = var_15_1:local_player().player_unit

		if ScriptUnit.extension(var_15_2, "inventory_system"):has_inventory_item("slot_level_event", "belakor_crystal") then
			return true
		end

		local var_15_3 = Managers.state.entity:get_entities("DeusBelakorCrystalExtension")

		if not table.is_empty(var_15_3) then
			return false, "deus_belakor_locus_throw_crystal_impeded_hud_desc"
		end

		local var_15_4 = var_15_1:human_players()

		for iter_15_0, iter_15_1 in pairs(var_15_4) do
			local var_15_5 = iter_15_1.player_unit
			local var_15_6 = var_15_5 and ScriptUnit.extension(var_15_5, "inventory_system")

			if var_15_6 and var_15_6:has_inventory_item("slot_level_event", "belakor_crystal") then
				return false, "deus_belakor_locus_throw_crystal_impeded_hud_desc"
			end
		end

		return false
	end

	return false
end

function DeusBelakorLocusExtension.get_interaction_length(arg_16_0)
	local var_16_0 = arg_16_0:_get_state()

	if var_16_0 == var_0_3.WAITING_FOR_ACTIVATION or var_16_0 == var_0_3.ACTIVATED then
		local var_16_1 = arg_16_0._unit
		local var_16_2 = Unit.get_data(var_16_1, "interaction_data", "interaction_length")

		fassert(var_16_2, "Interacting with %q that has no interaction length", var_16_1)

		return var_16_2
	else
		return 0
	end
end

function DeusBelakorLocusExtension.get_interaction_action(arg_17_0)
	if arg_17_0:_get_state() == var_0_3.ACTIVATED then
		local var_17_0 = Managers.player
		local var_17_1 = var_17_0:local_player().player_unit

		if ScriptUnit.extension(var_17_1, "inventory_system"):has_inventory_item("slot_level_event", "belakor_crystal") then
			return "deus_belakor_locus_throw_crystal_hud_desc"
		end

		local var_17_2 = Managers.state.entity:get_entities("DeusBelakorCrystalExtension")

		if not table.is_empty(var_17_2) then
			return "deus_belakor_locus_throw_crystal_impeded_hud_desc"
		end

		local var_17_3 = var_17_0:human_players()

		for iter_17_0, iter_17_1 in pairs(var_17_3) do
			local var_17_4 = iter_17_1.player_unit
			local var_17_5 = var_17_4 and ScriptUnit.extension(var_17_4, "inventory_system")

			if var_17_5 and var_17_5:has_inventory_item("slot_level_event", "belakor_crystal") then
				return "deus_belakor_locus_throw_crystal_impeded_hud_desc"
			end
		end
	end

	return "deus_belakor_locus_deactivate_hud_desc"
end

function DeusBelakorLocusExtension.on_server_interact(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7)
	local var_18_0 = arg_18_0:_get_state()

	if var_18_0 == var_0_3.WAITING_FOR_ACTIVATION then
		arg_18_0:_set_state(var_0_3.ACTIVATED)
	end

	if var_18_0 == var_0_3.ACTIVATED then
		arg_18_0:_set_state(var_0_3.DONE)
	end
end

function DeusBelakorLocusExtension.on_client_interact(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7)
	if arg_19_0:_get_state() == var_0_3.ACTIVATED then
		local var_19_0 = ScriptUnit.extension(arg_19_2, "inventory_system")

		var_19_0:destroy_slot("slot_level_event")
		var_19_0:wield_previous_weapon()
	end
end

function DeusBelakorLocusExtension.on_server_start_interact(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6)
	local var_20_0 = POSITION_LOOKUP[arg_20_3]
	local var_20_1 = var_0_5
	local var_20_2 = FrameTable.alloc_table()
	local var_20_3 = AiUtils.broadphase_query(var_20_0, var_20_1, var_20_2)

	for iter_20_0 = 1, var_20_3 do
		local var_20_4 = var_20_2[iter_20_0]

		if ALIVE[var_20_4] then
			local var_20_5 = ScriptUnit.has_extension(var_20_4, "ai_group_system")

			if var_20_5 and var_20_5.template == "deus_belakor_locus_cultists" then
				AIGroupTemplates[var_20_5.template].wake_up_group(var_20_5.group, arg_20_2)
			end
		end
	end
end
