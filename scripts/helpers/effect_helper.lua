-- chunkname: @scripts/helpers/effect_helper.lua

local_require("scripts/settings/material_effect_mappings")
require("scripts/helpers/network_utils")

local script_data = script_data
local debug_material_effects = script_data.debug_material_effects

debug_material_effects = debug_material_effects or Development.parameter("debug_material_effects")
script_data.debug_material_effects = debug_material_effects

local EffectHelper = EffectHelper

EffectHelper = EffectHelper or {}
EffectHelper = EffectHelper
EffectHelper.temporary_material_drawer_mapping = {}

EffectHelper.play_surface_material_effects = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8, arg_1_9)
	-- function 1
	local get = MaterialEffectMappingsUtility.get(arg_1_0)
	local query_material_surface = EffectHelper.query_material_surface(arg_1_2, arg_1_3, arg_1_5)
	local var_1_2
	local flag = true

	if not query_material_surface then
		if not (query_material_surface[1] == 0 or query_material_surface[1] ~= nil) then
			flag = false
		end
	else
		flag = false
	end

	if not flag then
		var_1_2 = LevelHelper:current_level_settings().default_surface_material or DefaultSurfaceMaterial
	else
		var_1_2 = MaterialIDToName.surface_material[query_material_surface[1]]

		if var_1_2 or not script_data.debug_material_effects then
			local drawer = Managers.state.debug:drawer({
				mode = "retained",
				name = "DEBUG_DRAW_IMPACT_DECAL_HIT"
			})
			local num = Quaternion.forward(arg_1_4) * MaterialEffectSettings.material_query_depth
			local num_2 = arg_1_3 - num * 0.5

			drawer:vector(num_2, num, Color(255, 255, 0, 0))
		elseif not script_data.debug_material_effects then
			table.dump(query_material_surface)
		end
	end

	if not script_data.debug_material_effects and not var_1_2 then
		local drawer_2 = Managers.state.debug:drawer({
			mode = "retained",
			name = "DEBUG_DRAW_IMPACT_DECAL_HIT"
		})
		local num_3 = Quaternion.forward(arg_1_4) * MaterialEffectSettings.material_query_depth
		local num_4 = arg_1_3 - num_3 * 0.5

		drawer_2:vector(num_4, num_3, Color(255, 0, 255, 0))
		Managers.state.debug_text:output_world_text(var_1_2, 0.1, num_4, 30, "material_text", Vector3(0, 255, 0))
	end

	local get_data = Unit.get_data(arg_1_2, "breed")
	local fassert = fassert
	local is_player

	if not get_data then
		is_player = get_data.is_player

		if not is_player then
			-- Nothing
		end

		if get_data.race ~= "dummy" then
			is_player = false

			goto label_1_0
		end
	end

	is_player = true

	::label_1_0::

	fassert(is_player, "Trying to apply surface material effect to unit %q an ai unit.", arg_1_2)
	fassert(not ScriptUnit.has_extension(arg_1_2, "ai_inventory_item_system"), "Trying to apply surface material effect to unit %q with ai_inventory_item extension.", arg_1_2)

	local decal = get.decal

	decal = not decal and get.decal.settings

	if not decal then
		local decal_2 = Managers.state.decal

		if decal_2 ~= nil then
			local var_1_15 = Vector3(decal.height, decal.width, decal.depth)
			local var_1_16 = EffectHelper.create_surface_material_drawer_mapping(arg_1_0)[var_1_2]

			if not (not var_1_16 and not var_1_16 and Application.can_get("unit", var_1_16)) then
				var_1_16 = "units/projection_decals/projection_test_01"

				Application.warning("[EffectHelper] There is no decal_unit_name specified for effect: %q with material: %q--> Using Default: %q", arg_1_0, var_1_2, var_1_16)
			end

			if not decal.random_rotation then
				local degrees_to_radians = math.degrees_to_radians(Math.random(360000) * 0.001)

				arg_1_4 = Quaternion.axis_angle(arg_1_5, degrees_to_radians)
			elseif not decal.rotation then
				local degrees_to_radians_2 = math.degrees_to_radians(decal.rotation)

				arg_1_4 = Quaternion.axis_angle(arg_1_5, degrees_to_radians_2)
			end

			if not decal.random_size_multiplier then
				local random_size_multiplier = decal.random_size_multiplier
				local num_5 = Math.random(1000) * 0.001
				local lerp = math.lerp(num_5, math.max(1 - random_size_multiplier, 0.01), 1 + random_size_multiplier)

				var_1_15[1] = var_1_15[1] * lerp
				var_1_15[2] = var_1_15[2] * lerp
			end

			decal_2:add_projection_decal(var_1_16, arg_1_2, arg_1_9, arg_1_3, arg_1_4, var_1_15, arg_1_5)
		end

		if not script_data.debug_material_effects then
			local drawer_3 = Managers.state.debug:drawer({
				mode = "retained",
				name = "DEBUG_DRAW_IMPACT_DECAL_HIT"
			})
			local from_quaternion_position = Matrix4x4.from_quaternion_position(arg_1_4, arg_1_3 + Quaternion.forward(arg_1_4) * decal.depth / 2)
			local var_1_24 = Vector3(decal.width / 2, decal.depth / 2, decal.height / 2)

			drawer_3:box(from_quaternion_position, var_1_24, Color(150, 0, 255, 0))
		end
	end

	local sound = get.sound

	sound = not sound and get.sound[var_1_2]

	local additional_sound_parameters = get.additional_sound_parameters

	additional_sound_parameters = not additional_sound_parameters and get.additional_sound_parameters.switch_params

	local additional_sound_parameters_2 = get.additional_sound_parameters

	additional_sound_parameters_2 = not additional_sound_parameters_2 and get.additional_sound_parameters.rtpc_params

	if not sound then
		local make_position_auto_source, var_1_29 = WwiseUtils.make_position_auto_source(arg_1_1, arg_1_3)

		if not script_data.debug_material_effects then
			printf("[EffectHelper:play_surface_material_effects()] playing sound %s", sound.event)
		end

		if not sound.parameters then
			for k, v in pairs(sound.parameters) do
				if not script_data.debug_material_effects then
					printf("   sound param: %q, sound_value %q", k, v)
				end

				WwiseWorld.set_switch(var_1_29, k, v, make_position_auto_source)
			end
		end

		if not arg_1_6 then
			WwiseWorld.set_switch(var_1_29, "character_foley", arg_1_6, make_position_auto_source)
		end

		if not additional_sound_parameters_2 then
			for k_2, v_2 in pairs(additional_sound_parameters_2) do
				if not script_data.debug_material_effects then
					printf("   sound param: %q, sound_value %q", k_2, v_2)
				end

				WwiseWorld.set_source_parameter(var_1_29, make_position_auto_source, k_2, v_2)
			end
		end

		if not additional_sound_parameters then
			for k_3, v_3 in pairs(additional_sound_parameters) do
				if not script_data.debug_material_effects then
					printf("   sound param: %q, sound_value %q", k_3, v_3)
				end

				WwiseWorld.set_switch(var_1_29, k_3, v_3, make_position_auto_source)
			end
		end

		local set_switch = WwiseWorld.set_switch
		local var_1_31 = var_1_29
		local str = "husk"
		local flag_2

		flag_2 = not arg_1_7 and "true" and "false"

		set_switch(var_1_31, str, flag_2, make_position_auto_source)
		WwiseWorld.trigger_event(var_1_29, sound.event, true, make_position_auto_source)
	end

	local particles = get.particles

	particles = not particles and get.particles[var_1_2]

	if not particles then
		local look = Quaternion.look(arg_1_5, Vector3.up())

		World.create_particles(arg_1_1, particles, arg_1_3, look)

		if not script_data.debug_material_effects then
			Managers.state.debug:drawer({
				mode = "retained",
				name = "DEBUG_DRAW_IMPACT_DECAL_HIT"
			}):quaternion(arg_1_3, look)
			printf("EffectHelper, creating partiles %s, %s", particles, arg_1_0)
		end
	end

	local world_interaction = get.world_interaction

	world_interaction = not world_interaction and get.world_interaction[var_1_2]

	if not Unit.alive(arg_1_8) then
		if not world_interaction then
			if not WorldInteractionSettings[var_1_2].use_simple_effects then
				Managers.state.world_interaction:add_simple_effect(var_1_2, arg_1_2, arg_1_3, arg_1_8)
			else
				Managers.state.world_interaction:add_world_interaction(var_1_2, arg_1_8)
			end
		else
			Managers.state.world_interaction:remove_world_interaction(arg_1_8)
		end
	elseif not world_interaction then
		Managers.state.world_interaction:add_simple_effect(var_1_2, arg_1_2, arg_1_3)
	end
end

EffectHelper.play_skinned_surface_material_effects = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8, arg_2_9, arg_2_10, arg_2_11, arg_2_12)
	-- function 2
	local get = MaterialEffectMappingsUtility.get(arg_2_0)

	if not get then
		return
	end

	local var_2_1
	local flag = false
	local str

	if arg_2_10 == "ward" then
		str = "ward"
	elseif not arg_2_9 then
		str = "armored"
	else
		flag = not BloodSettings.enemy_blood.enabled
		str = not arg_2_12 and arg_2_12.flesh_material and "flesh"
	end

	if not arg_2_11 then
		if not (arg_2_7 == "skaven_storm_vermin_with_shield" or arg_2_7 ~= "chaos_marauder_with_shield") then
			str = "shield_metal"
		elseif arg_2_7 == "skaven_clan_rat_with_shield" then
			str = "shield"
		end
	end

	local sound = get.sound

	sound = not sound and get.sound[str]

	if not sound then
		local wwise_world = Managers.world:wwise_world(arg_2_1)
		local make_auto_source = WwiseWorld.make_auto_source(wwise_world, arg_2_3)

		if not sound.parameters then
			for k, v in pairs(sound.parameters) do
				WwiseWorld.set_switch(wwise_world, make_auto_source, k, v)
			end
		end

		if not arg_2_7 then
			WwiseWorld.set_switch(wwise_world, "enemy_type", arg_2_7, make_auto_source)
		end

		if not arg_2_8 then
			WwiseWorld.set_switch(wwise_world, "damage_sound", arg_2_8, make_auto_source)
		end

		if not arg_2_10 then
			WwiseWorld.set_switch(wwise_world, "hit_zone", arg_2_10, make_auto_source)
		end

		local flag_2

		flag_2 = not arg_2_6 and "true" and "false"

		WwiseWorld.set_switch(wwise_world, "husk", flag_2, make_auto_source)

		local no_damage_event

		if not arg_2_9 then
			no_damage_event = sound.no_damage_event

			if not no_damage_event then
				-- Nothing
			end
		end

		no_damage_event = sound.event

		::label_2_0::

		if not script_data.debug_material_effects then
			print("playing event ", no_damage_event)
			print("\tenemy_type ", arg_2_7)
			print("\tdamage_sound ", arg_2_8)
			print("\thit_zone ", arg_2_10)
			print("\thusk ", flag_2)

			if not sound.parameters then
				for k_2, v_2 in pairs(sound.parameters) do
					print("\t" .. k_2 .. " ", v_2)
				end
			end
		end

		WwiseWorld.trigger_event(wwise_world, sound.event, make_auto_source)
	end

	if not flag then
		if not arg_2_12 then
			-- Nothing
		end

		::label_2_1::

		local blocking_hit_effect = arg_2_12.blocking_hit_effect

		blocking_hit_effect = not blocking_hit_effect and arg_2_11

		::label_2_2::

		local var_2_10

		if not blocking_hit_effect then
			var_2_10 = arg_2_12.blocking_hit_effect
		else
			var_2_10 = not get.particles and get.particles[str]
		end

		if not var_2_10 then
			local look = Quaternion.look(arg_2_5, Vector3.up())

			World.create_particles(arg_2_1, var_2_10, arg_2_3, look)
		end
	end

	local flow_event = get.flow_event

	flow_event = not flow_event and get.flow_event[str]

	if not flow_event and not arg_2_2 then
		Unit.flow_event(arg_2_2, flow_event)
	end
end

EffectHelper.player_critical_hit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	if not HEALTH_ALIVE[arg_3_3] then
		return
	end

	if not arg_3_1 then
		return
	end

	local owner = Managers.player:owner(arg_3_2)

	if not owner then
		return
	end

	local local_player = owner.local_player

	local_player = not local_player and not owner.bot_player

	if not local_player then
		return
	end

	local str = "Play_player_combat_crit_hit_2D"

	ScriptUnit.extension(arg_3_2, "first_person_system"):play_hud_sound_event(str, nil, false)

	local str_2 = "Play_player_combat_crit_hit_3D"

	WwiseUtils.trigger_position_event(arg_3_0, str_2, arg_3_4)
end

EffectHelper.player_melee_hit_particles = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local look = Quaternion.look(arg_4_3)

	World.create_particles(arg_4_0, arg_4_1, arg_4_2, look)

	if not (not arg_4_4 and arg_4_4 == "no_damage") then
		Managers.state.blood:add_blood_ball(arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	end
end

EffectHelper.player_ranged_block_hit_particles = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local look = Quaternion.look(arg_5_3)

	World.create_particles(arg_5_0, arg_5_1, arg_5_2, look)
end

EffectHelper.play_melee_hit_effects = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	local make_position_auto_source, var_6_1 = WwiseUtils.make_position_auto_source(arg_6_1, arg_6_2)
	local owner = Managers.player:owner(arg_6_5)

	if not owner then
		local local_player = owner.local_player

		WwiseWorld.set_switch(var_6_1, "target_is_local_player", tostring(local_player or false), make_position_auto_source)
	else
		local get_data = Unit.get_data(arg_6_5, "breed")

		if not get_data then
			local name = get_data.name

			WwiseWorld.set_switch(var_6_1, "enemy_type", name, make_position_auto_source)
		end
	end

	WwiseWorld.set_switch(var_6_1, "damage_sound", arg_6_3, make_position_auto_source)
	WwiseWorld.set_switch(var_6_1, "husk", tostring(arg_6_4 or false), make_position_auto_source)
	WwiseWorld.trigger_event(var_6_1, arg_6_0, make_position_auto_source)
end

local enum_safe = table.enum_safe("burn", "burn_sniper", "burn_shotgun", "burn_carbine", "burn_machinegun", "burninating", "bleed", "burning_tank", "heavy_burning_tank", "light_burning_linesman", "burning_linesman", "burning_smiter", "burning_stab_fencer", "warpfire_ground", "vs_bw_skullstaff_fireball", "vs_bw_skullstaff_beam", "vs_bw_skullstaff_geiser", "vs_bw_skullstaff_spear", "vs_bw_skullstaff_flamethrower")
local enum_safe_2 = table.enum_safe("projectile", "instant_projectile", "heavy_instant_projectile")

EffectHelper.vs_play_hit_sound = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	local owner = Managers.player:owner(arg_7_1)
	local remote = owner.remote

	if not remote then
		remote = owner.bot_player
		remote = remote or false
	end

	local var_7_2
	local str

	if not (enum_safe[arg_7_3] or arg_7_3 ~= "grenade" or arg_7_4 ~= "grenade_fire_01") then
		str = "fire"
	elseif not enum_safe_2[arg_7_2] then
		str = "bullet"
	elseif not (arg_7_3 == "gas" or arg_7_3 == "arrow_poison_dot" or arg_7_3 ~= "vomit_face") then
		str = "gas"
	else
		str = "sword"
	end

	if not str then
		local make_unit_auto_source, var_7_5 = WwiseUtils.make_unit_auto_source(arg_7_0, arg_7_1)

		WwiseWorld.set_switch(var_7_5, "husk", tostring(remote or false), make_unit_auto_source)
		WwiseWorld.set_switch(var_7_5, "enemy_hit_sound", str, make_unit_auto_source)
		WwiseWorld.trigger_event(var_7_5, "enemy_hit_versus", make_unit_auto_source)
	end
end

local tbl = {
	skaven_poison_wind_globadier = "Play_player_hit_globadier_gas",
	vs_poison_wind_globadier = "Play_player_hit_globadier_gas"
}

EffectHelper.play_local_damage_taken_sound = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	local var_8_0 = tbl[arg_8_2]

	if not var_8_0 then
		return
	end

	local has_extension = ScriptUnit.has_extension(arg_8_1, "first_person_system")

	if not has_extension then
		has_extension:play_hud_sound_event(var_8_0)
	end
end

EffectHelper.play_melee_hit_effects_enemy = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	-- function 9
	local make_unit_auto_source, var_9_1 = WwiseUtils.make_unit_auto_source(arg_9_2, arg_9_3)

	WwiseWorld.set_switch(var_9_1, "husk", tostring(arg_9_5 or false), make_unit_auto_source)
	WwiseWorld.set_switch(var_9_1, "enemy_hit_sound", arg_9_1, make_unit_auto_source)
	WwiseWorld.trigger_event(var_9_1, arg_9_0, make_unit_auto_source)
end

EffectHelper.remote_play_surface_material_effects = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7)
	-- function 10
	local network = Managers.state.network
	local current_level = LevelHelper:current_level(arg_10_1)
	local unit_index = Level.unit_index(current_level, arg_10_2)
	local unit_game_object_id = network:unit_game_object_id(arg_10_2)
	local var_10_4 = NetworkLookup.surface_material_effects[arg_10_0]

	if not NetworkUtils.network_safe_position(arg_10_3) then
		return
	end

	local num = -1

	if not Actor.is_dynamic(arg_10_7) then
		num = Actor.node(arg_10_7)
	end

	if not unit_game_object_id then
		if not arg_10_6 then
			network.network_transmit:send_rpc_clients("rpc_surface_mtr_fx", var_10_4, unit_game_object_id, arg_10_3, arg_10_4, Vector3.normalize(arg_10_5), num)
		else
			network.network_transmit:send_rpc_server("rpc_surface_mtr_fx", var_10_4, unit_game_object_id, arg_10_3, arg_10_4, Vector3.normalize(arg_10_5), num)
		end
	elseif not unit_index then
		if not arg_10_6 then
			network.network_transmit:send_rpc_clients("rpc_surface_mtr_fx_lvl_unit", var_10_4, unit_index, arg_10_3, arg_10_4, Vector3.normalize(arg_10_5), num)
		else
			network.network_transmit:send_rpc_server("rpc_surface_mtr_fx_lvl_unit", var_10_4, unit_index, arg_10_3, arg_10_4, Vector3.normalize(arg_10_5), num)
		end
	end
end

EffectHelper.remote_play_skinned_surface_material_effects = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8, arg_11_9)
	-- function 11
	local network = Managers.state.network
	local var_11_1 = NetworkLookup.surface_material_effects[arg_11_0]

	if not NetworkUtils.network_safe_position(arg_11_2) then
		return
	end

	if not arg_11_9 then
		network.network_transmit:send_rpc_clients("rpc_skinned_surface_mtr_fx", var_11_1, arg_11_2, arg_11_3, Vector3.normalize(arg_11_4))
	else
		network.network_transmit:send_rpc_server("rpc_skinned_surface_mtr_fx", var_11_1, arg_11_2, arg_11_3, Vector3.normalize(arg_11_4))
	end
end

EffectHelper.create_surface_material_drawer_mapping = function (arg_12_0)
	-- function 12
	local material_drawer_mapping = MaterialEffectMappingsUtility.get(arg_12_0).decal.material_drawer_mapping

	for i, v in ipairs(MaterialEffectSettings.material_contexts.surface_material) do
		local var_12_1

		if type(material_drawer_mapping[v]) == "string" then
			var_12_1 = material_drawer_mapping[v]
		elseif type(material_drawer_mapping[v]) == "table" then
			local count = #material_drawer_mapping[v]
			local random = math.random(1, count)

			var_12_1 = material_drawer_mapping[v][random]
		else
			var_12_1 = nil
		end

		EffectHelper.temporary_material_drawer_mapping[v] = var_12_1
	end

	return EffectHelper.temporary_material_drawer_mapping
end

EffectHelper.flow_cb_play_surface_material_effect = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7, arg_13_8)
	-- function 13
	local flag = arg_13_7 or 0.6
	local num = -arg_13_4
	local num_2 = arg_13_2 + arg_13_4 * flag
	local flag_2 = arg_13_8 or 3
	local debug_material_effects = script_data.debug_material_effects
	local world = Managers.world:world("level_world")
	local get_data = World.get_data(world, "physics_world")
	local immediate_raycast, var_13_8, var_13_9, var_13_10, var_13_11 = PhysicsWorld.immediate_raycast(get_data, num_2, num, flag_2, "closest", "types", "both", "collision_filter", "filter_ground_material_check")

	if not immediate_raycast then
		local unit = Actor.unit(var_13_11)
		local world_rotation = Unit.world_rotation(arg_13_1, 0)
		local up = Quaternion.up(world_rotation)
		local forward = Quaternion.forward(world_rotation)
		local look = Quaternion.look(forward, up)

		EffectHelper.play_surface_material_effects(arg_13_0, world, unit, var_13_8, look, var_13_10, arg_13_5, arg_13_6, arg_13_1, var_13_11)
	end
end

EffectHelper.flow_cb_play_footstep_surface_material_effects = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	-- function 14
	local has_extension = ScriptUnit.has_extension(arg_14_1, "ghost_mode_system")

	if not has_extension and not has_extension:is_husk() and not has_extension:is_in_ghost_mode() then
		return
	end

	local node = Unit.node(arg_14_1, arg_14_2)
	local footstep_raycast_offset = MaterialEffectSettings.footstep_raycast_offset
	local num = Unit.world_position(arg_14_1, node) + Vector3(0, 0, footstep_raycast_offset)
	local var_14_4 = Vector3(0, 0, -1)
	local footstep_raycast_max_range = MaterialEffectSettings.footstep_raycast_max_range
	local get_data = Unit.get_data(arg_14_1, "sound_character")
	local world = Managers.world:world("level_world")
	local get_data_2 = World.get_data(world, "physics_world")
	local immediate_raycast, var_14_10, var_14_11, var_14_12, var_14_13 = PhysicsWorld.immediate_raycast(get_data_2, num, var_14_4, footstep_raycast_max_range, "closest", "types", "both", "collision_filter", "filter_ground_material_check")
	local owner = Managers.player:owner(arg_14_1)
	local remote

	if not owner then
		remote = owner.remote

		if not remote then
			remote = owner.bot_player
		end

		if false then
			remote = false
		end
	else
		remote = true
	end

	if not immediate_raycast then
		local unit = Actor.unit(var_14_13)
		local world_rotation = Unit.world_rotation(arg_14_1, 0)
		local up = Quaternion.up(world_rotation)
		local forward = Quaternion.forward(world_rotation)
		local look = Quaternion.look(forward, up)

		EffectHelper.play_surface_material_effects(arg_14_0, world, unit, var_14_10, look, var_14_12, get_data, remote, arg_14_1)
	else
		local get = MaterialEffectMappingsUtility.get(arg_14_0)
		local default_surface_material = LevelHelper:current_level_settings().default_surface_material

		default_surface_material = default_surface_material or DefaultSurfaceMaterial

		local additional_sound_parameters = get.additional_sound_parameters

		additional_sound_parameters = not additional_sound_parameters and get.additional_sound_parameters.switch_params

		local additional_sound_parameters_2 = get.additional_sound_parameters

		additional_sound_parameters_2 = not additional_sound_parameters_2 and get.additional_sound_parameters.rtpc_params

		local sound = get.sound

		sound = not sound and get.sound[default_surface_material]

		if not sound then
			local make_position_auto_source, var_14_27 = WwiseUtils.make_position_auto_source(world, num + var_14_4 * footstep_raycast_max_range)
			local set_switch = WwiseWorld.set_switch
			local var_14_29 = var_14_27
			local str = "husk"
			local flag

			flag = not remote and "true" and "false"

			set_switch(var_14_29, str, flag, make_position_auto_source)

			if not sound.parameters then
				for k, v in pairs(sound.parameters) do
					WwiseWorld.set_switch(var_14_27, k, v, make_position_auto_source)
				end
			end

			if not get_data then
				WwiseWorld.set_switch(var_14_27, "character_foley", get_data, make_position_auto_source)
			end

			if not additional_sound_parameters_2 then
				for k_2, v_2 in pairs(additional_sound_parameters_2) do
					WwiseWorld.set_source_parameter(var_14_27, make_position_auto_source, k_2, v_2)
				end
			end

			if not additional_sound_parameters then
				for k_3, v_3 in pairs(additional_sound_parameters) do
					WwiseWorld.set_switch(var_14_27, k_3, v_3, make_position_auto_source)
				end
			end

			WwiseWorld.trigger_event(var_14_27, sound.event, arg_14_4, make_position_auto_source)
		end
	end
end

local tbl_2 = {
	"surface_material"
}
local tbl_3 = {}

EffectHelper.query_material_surface = function (arg_15_0, arg_15_1, arg_15_2)
	-- function 15
	local num = arg_15_2 * MaterialEffectSettings.material_query_depth
	local num_2 = arg_15_1 + num / 2
	local num_3 = arg_15_1 - num / 2

	return Unit.query_material(arg_15_0, num_2, num_3, tbl_2, tbl_3)
end
