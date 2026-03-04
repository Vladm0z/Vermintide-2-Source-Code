-- chunkname: @scripts/helpers/effect_helper.lua

local_require("scripts/settings/material_effect_mappings")
require("scripts/helpers/network_utils")

script_data.debug_material_effects = script_data.debug_material_effects or Development.parameter("debug_material_effects")
EffectHelper = EffectHelper or {}
EffectHelper.temporary_material_drawer_mapping = {}

function EffectHelper.play_surface_material_effects(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8, arg_1_9)
	local var_1_0 = MaterialEffectMappingsUtility.get(arg_1_0)
	local var_1_1 = EffectHelper.query_material_surface(arg_1_2, arg_1_3, arg_1_5)
	local var_1_2
	local var_1_3 = true

	if var_1_1 then
		if var_1_1[1] == 0 or var_1_1[1] == nil then
			var_1_3 = false
		end
	else
		var_1_3 = false
	end

	if not var_1_3 then
		var_1_2 = LevelHelper:current_level_settings().default_surface_material or DefaultSurfaceMaterial
	else
		var_1_2 = MaterialIDToName.surface_material[var_1_1[1]]

		if not var_1_2 and script_data.debug_material_effects then
			local var_1_4 = Managers.state.debug:drawer({
				mode = "retained",
				name = "DEBUG_DRAW_IMPACT_DECAL_HIT"
			})
			local var_1_5 = Quaternion.forward(arg_1_4) * MaterialEffectSettings.material_query_depth
			local var_1_6 = arg_1_3 - var_1_5 * 0.5

			var_1_4:vector(var_1_6, var_1_5, Color(255, 255, 0, 0))
		elseif script_data.debug_material_effects then
			table.dump(var_1_1)
		end
	end

	if script_data.debug_material_effects and var_1_2 then
		local var_1_7 = Managers.state.debug:drawer({
			mode = "retained",
			name = "DEBUG_DRAW_IMPACT_DECAL_HIT"
		})
		local var_1_8 = Quaternion.forward(arg_1_4) * MaterialEffectSettings.material_query_depth
		local var_1_9 = arg_1_3 - var_1_8 * 0.5

		var_1_7:vector(var_1_9, var_1_8, Color(255, 0, 255, 0))
		Managers.state.debug_text:output_world_text(var_1_2, 0.1, var_1_9, 30, "material_text", Vector3(0, 255, 0))
	end

	local var_1_10 = Unit.get_data(arg_1_2, "breed")

	fassert(not var_1_10 or var_1_10.is_player or var_1_10.race == "dummy", "Trying to apply surface material effect to unit %q an ai unit.", arg_1_2)
	fassert(not ScriptUnit.has_extension(arg_1_2, "ai_inventory_item_system"), "Trying to apply surface material effect to unit %q with ai_inventory_item extension.", arg_1_2)

	local var_1_11 = var_1_0.decal and var_1_0.decal.settings

	if var_1_11 then
		local var_1_12 = Managers.state.decal

		if var_1_12 ~= nil then
			local var_1_13 = Vector3(var_1_11.height, var_1_11.width, var_1_11.depth)
			local var_1_14 = EffectHelper.create_surface_material_drawer_mapping(arg_1_0)[var_1_2]

			if not var_1_14 or var_1_14 and not Application.can_get("unit", var_1_14) then
				var_1_14 = "units/projection_decals/projection_test_01"

				Application.warning("[EffectHelper] There is no decal_unit_name specified for effect: %q with material: %q--> Using Default: %q", arg_1_0, var_1_2, var_1_14)
			end

			if var_1_11.random_rotation then
				local var_1_15 = math.degrees_to_radians(Math.random(360000) * 0.001)

				arg_1_4 = Quaternion.axis_angle(arg_1_5, var_1_15)
			elseif var_1_11.rotation then
				local var_1_16 = math.degrees_to_radians(var_1_11.rotation)

				arg_1_4 = Quaternion.axis_angle(arg_1_5, var_1_16)
			end

			if var_1_11.random_size_multiplier then
				local var_1_17 = var_1_11.random_size_multiplier
				local var_1_18 = Math.random(1000) * 0.001
				local var_1_19 = math.lerp(var_1_18, math.max(1 - var_1_17, 0.01), 1 + var_1_17)

				var_1_13[1] = var_1_13[1] * var_1_19
				var_1_13[2] = var_1_13[2] * var_1_19
			end

			var_1_12:add_projection_decal(var_1_14, arg_1_2, arg_1_9, arg_1_3, arg_1_4, var_1_13, arg_1_5)
		end

		if script_data.debug_material_effects then
			local var_1_20 = Managers.state.debug:drawer({
				mode = "retained",
				name = "DEBUG_DRAW_IMPACT_DECAL_HIT"
			})
			local var_1_21 = Matrix4x4.from_quaternion_position(arg_1_4, arg_1_3 + Quaternion.forward(arg_1_4) * var_1_11.depth / 2)
			local var_1_22 = Vector3(var_1_11.width / 2, var_1_11.depth / 2, var_1_11.height / 2)

			var_1_20:box(var_1_21, var_1_22, Color(150, 0, 255, 0))
		end
	end

	local var_1_23 = var_1_0.sound and var_1_0.sound[var_1_2]
	local var_1_24 = var_1_0.additional_sound_parameters and var_1_0.additional_sound_parameters.switch_params
	local var_1_25 = var_1_0.additional_sound_parameters and var_1_0.additional_sound_parameters.rtpc_params

	if var_1_23 then
		local var_1_26, var_1_27 = WwiseUtils.make_position_auto_source(arg_1_1, arg_1_3)

		if script_data.debug_material_effects then
			printf("[EffectHelper:play_surface_material_effects()] playing sound %s", var_1_23.event)
		end

		if var_1_23.parameters then
			for iter_1_0, iter_1_1 in pairs(var_1_23.parameters) do
				if script_data.debug_material_effects then
					printf("   sound param: %q, sound_value %q", iter_1_0, iter_1_1)
				end

				WwiseWorld.set_switch(var_1_27, iter_1_0, iter_1_1, var_1_26)
			end
		end

		if arg_1_6 then
			WwiseWorld.set_switch(var_1_27, "character_foley", arg_1_6, var_1_26)
		end

		if var_1_25 then
			for iter_1_2, iter_1_3 in pairs(var_1_25) do
				if script_data.debug_material_effects then
					printf("   sound param: %q, sound_value %q", iter_1_2, iter_1_3)
				end

				WwiseWorld.set_source_parameter(var_1_27, var_1_26, iter_1_2, iter_1_3)
			end
		end

		if var_1_24 then
			for iter_1_4, iter_1_5 in pairs(var_1_24) do
				if script_data.debug_material_effects then
					printf("   sound param: %q, sound_value %q", iter_1_4, iter_1_5)
				end

				WwiseWorld.set_switch(var_1_27, iter_1_4, iter_1_5, var_1_26)
			end
		end

		WwiseWorld.set_switch(var_1_27, "husk", arg_1_7 and "true" or "false", var_1_26)
		WwiseWorld.trigger_event(var_1_27, var_1_23.event, true, var_1_26)
	end

	local var_1_28 = var_1_0.particles and var_1_0.particles[var_1_2]

	if var_1_28 then
		local var_1_29 = Quaternion.look(arg_1_5, Vector3.up())

		World.create_particles(arg_1_1, var_1_28, arg_1_3, var_1_29)

		if script_data.debug_material_effects then
			Managers.state.debug:drawer({
				mode = "retained",
				name = "DEBUG_DRAW_IMPACT_DECAL_HIT"
			}):quaternion(arg_1_3, var_1_29)
			printf("EffectHelper, creating partiles %s, %s", var_1_28, arg_1_0)
		end
	end

	if Unit.alive(arg_1_8) then
		if var_1_0.world_interaction and var_1_0.world_interaction[var_1_2] then
			Managers.state.world_interaction:add_world_interaction(var_1_2, arg_1_8)
		else
			Managers.state.world_interaction:remove_world_interaction(arg_1_8)
		end
	elseif var_1_0.world_interaction and var_1_0.world_interaction[var_1_2] then
		Managers.state.world_interaction:add_simple_effect(var_1_2, arg_1_2, arg_1_3)
	end
end

function EffectHelper.play_skinned_surface_material_effects(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8, arg_2_9, arg_2_10, arg_2_11, arg_2_12)
	local var_2_0 = MaterialEffectMappingsUtility.get(arg_2_0)

	if not var_2_0 then
		return
	end

	local var_2_1
	local var_2_2 = false
	local var_2_3

	if arg_2_10 == "ward" then
		var_2_3 = "ward"
	elseif arg_2_9 then
		var_2_3 = "armored"
	else
		var_2_2 = not BloodSettings.enemy_blood.enabled
		var_2_3 = arg_2_12 and arg_2_12.flesh_material or "flesh"
	end

	if arg_2_11 then
		if arg_2_7 == "skaven_storm_vermin_with_shield" or arg_2_7 == "chaos_marauder_with_shield" then
			var_2_3 = "shield_metal"
		elseif arg_2_7 == "skaven_clan_rat_with_shield" then
			var_2_3 = "shield"
		end
	end

	local var_2_4 = var_2_0.sound and var_2_0.sound[var_2_3]

	if var_2_4 then
		local var_2_5 = Managers.world:wwise_world(arg_2_1)
		local var_2_6 = WwiseWorld.make_auto_source(var_2_5, arg_2_3)

		if var_2_4.parameters then
			for iter_2_0, iter_2_1 in pairs(var_2_4.parameters) do
				WwiseWorld.set_switch(var_2_5, var_2_6, iter_2_0, iter_2_1)
			end
		end

		if arg_2_7 then
			WwiseWorld.set_switch(var_2_5, "enemy_type", arg_2_7, var_2_6)
		end

		if arg_2_8 then
			WwiseWorld.set_switch(var_2_5, "damage_sound", arg_2_8, var_2_6)
		end

		if arg_2_10 then
			WwiseWorld.set_switch(var_2_5, "hit_zone", arg_2_10, var_2_6)
		end

		local var_2_7 = arg_2_6 and "true" or "false"

		WwiseWorld.set_switch(var_2_5, "husk", var_2_7, var_2_6)

		local var_2_8 = arg_2_9 and var_2_4.no_damage_event or var_2_4.event

		if script_data.debug_material_effects then
			print("playing event ", var_2_8)
			print("\tenemy_type ", arg_2_7)
			print("\tdamage_sound ", arg_2_8)
			print("\thit_zone ", arg_2_10)
			print("\thusk ", var_2_7)

			if var_2_4.parameters then
				for iter_2_2, iter_2_3 in pairs(var_2_4.parameters) do
					print("\t" .. iter_2_2 .. " ", iter_2_3)
				end
			end
		end

		WwiseWorld.trigger_event(var_2_5, var_2_4.event, var_2_6)
	end

	if not var_2_2 then
		local var_2_9 = arg_2_12 and arg_2_12.blocking_hit_effect and arg_2_11
		local var_2_10

		if var_2_9 then
			var_2_10 = arg_2_12.blocking_hit_effect
		else
			var_2_10 = var_2_0.particles and var_2_0.particles[var_2_3]
		end

		if var_2_10 then
			local var_2_11 = Quaternion.look(arg_2_5, Vector3.up())

			World.create_particles(arg_2_1, var_2_10, arg_2_3, var_2_11)
		end
	end

	local var_2_12 = var_2_0.flow_event and var_2_0.flow_event[var_2_3]

	if var_2_12 and arg_2_2 then
		Unit.flow_event(arg_2_2, var_2_12)
	end
end

function EffectHelper.player_critical_hit(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	if not HEALTH_ALIVE[arg_3_3] then
		return
	end

	if not arg_3_1 then
		return
	end

	local var_3_0 = Managers.player:owner(arg_3_2)

	if not var_3_0 then
		return
	end

	if not (var_3_0.local_player and not var_3_0.bot_player) then
		return
	end

	local var_3_1 = "Play_player_combat_crit_hit_2D"

	ScriptUnit.extension(arg_3_2, "first_person_system"):play_hud_sound_event(var_3_1, nil, false)

	local var_3_2 = "Play_player_combat_crit_hit_3D"

	WwiseUtils.trigger_position_event(arg_3_0, var_3_2, arg_3_4)
end

function EffectHelper.player_melee_hit_particles(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = Quaternion.look(arg_4_3)

	World.create_particles(arg_4_0, arg_4_1, arg_4_2, var_4_0)

	if arg_4_4 and arg_4_4 ~= "no_damage" then
		Managers.state.blood:add_blood_ball(arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	end
end

function EffectHelper.player_ranged_block_hit_particles(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = Quaternion.look(arg_5_3)

	World.create_particles(arg_5_0, arg_5_1, arg_5_2, var_5_0)
end

function EffectHelper.play_melee_hit_effects(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	local var_6_0, var_6_1 = WwiseUtils.make_position_auto_source(arg_6_1, arg_6_2)
	local var_6_2 = Managers.player:owner(arg_6_5)

	if var_6_2 then
		local var_6_3 = var_6_2.local_player

		WwiseWorld.set_switch(var_6_1, "target_is_local_player", tostring(var_6_3 or false), var_6_0)
	else
		local var_6_4 = Unit.get_data(arg_6_5, "breed")

		if var_6_4 then
			local var_6_5 = var_6_4.name

			WwiseWorld.set_switch(var_6_1, "enemy_type", var_6_5, var_6_0)
		end
	end

	WwiseWorld.set_switch(var_6_1, "damage_sound", arg_6_3, var_6_0)
	WwiseWorld.set_switch(var_6_1, "husk", tostring(arg_6_4 or false), var_6_0)
	WwiseWorld.trigger_event(var_6_1, arg_6_0, var_6_0)
end

local var_0_0 = table.enum_safe("burn", "burn_sniper", "burn_shotgun", "burn_carbine", "burn_machinegun", "burninating", "bleed", "burning_tank", "heavy_burning_tank", "light_burning_linesman", "burning_linesman", "burning_smiter", "burning_stab_fencer", "warpfire_ground", "vs_bw_skullstaff_fireball", "vs_bw_skullstaff_beam", "vs_bw_skullstaff_geiser", "vs_bw_skullstaff_spear", "vs_bw_skullstaff_flamethrower")
local var_0_1 = table.enum_safe("projectile", "instant_projectile", "heavy_instant_projectile")

function EffectHelper.vs_play_hit_sound(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = Managers.player:owner(arg_7_1)
	local var_7_1 = var_7_0.remote or var_7_0.bot_player or false
	local var_7_2
	local var_7_3 = (var_0_0[arg_7_3] or arg_7_3 == "grenade" and arg_7_4 == "grenade_fire_01") and "fire" or var_0_1[arg_7_2] and "bullet" or (arg_7_3 == "gas" or arg_7_3 == "arrow_poison_dot" or arg_7_3 == "vomit_face") and "gas" or "sword"

	if var_7_3 then
		local var_7_4, var_7_5 = WwiseUtils.make_unit_auto_source(arg_7_0, arg_7_1)

		WwiseWorld.set_switch(var_7_5, "husk", tostring(var_7_1 or false), var_7_4)
		WwiseWorld.set_switch(var_7_5, "enemy_hit_sound", var_7_3, var_7_4)
		WwiseWorld.trigger_event(var_7_5, "enemy_hit_versus", var_7_4)
	end
end

local var_0_2 = {
	skaven_poison_wind_globadier = "Play_player_hit_globadier_gas",
	vs_poison_wind_globadier = "Play_player_hit_globadier_gas"
}

function EffectHelper.play_local_damage_taken_sound(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = var_0_2[arg_8_2]

	if not var_8_0 then
		return
	end

	local var_8_1 = ScriptUnit.has_extension(arg_8_1, "first_person_system")

	if var_8_1 then
		var_8_1:play_hud_sound_event(var_8_0)
	end
end

function EffectHelper.play_melee_hit_effects_enemy(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	local var_9_0, var_9_1 = WwiseUtils.make_unit_auto_source(arg_9_2, arg_9_3)

	WwiseWorld.set_switch(var_9_1, "husk", tostring(arg_9_5 or false), var_9_0)
	WwiseWorld.set_switch(var_9_1, "enemy_hit_sound", arg_9_1, var_9_0)
	WwiseWorld.trigger_event(var_9_1, arg_9_0, var_9_0)
end

function EffectHelper.remote_play_surface_material_effects(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7)
	local var_10_0 = Managers.state.network
	local var_10_1 = LevelHelper:current_level(arg_10_1)
	local var_10_2 = Level.unit_index(var_10_1, arg_10_2)
	local var_10_3 = var_10_0:unit_game_object_id(arg_10_2)
	local var_10_4 = NetworkLookup.surface_material_effects[arg_10_0]

	if not NetworkUtils.network_safe_position(arg_10_3) then
		return
	end

	local var_10_5 = -1

	if Actor.is_dynamic(arg_10_7) then
		var_10_5 = Actor.node(arg_10_7)
	end

	if var_10_3 then
		if arg_10_6 then
			var_10_0.network_transmit:send_rpc_clients("rpc_surface_mtr_fx", var_10_4, var_10_3, arg_10_3, arg_10_4, Vector3.normalize(arg_10_5), var_10_5)
		else
			var_10_0.network_transmit:send_rpc_server("rpc_surface_mtr_fx", var_10_4, var_10_3, arg_10_3, arg_10_4, Vector3.normalize(arg_10_5), var_10_5)
		end
	elseif var_10_2 then
		if arg_10_6 then
			var_10_0.network_transmit:send_rpc_clients("rpc_surface_mtr_fx_lvl_unit", var_10_4, var_10_2, arg_10_3, arg_10_4, Vector3.normalize(arg_10_5), var_10_5)
		else
			var_10_0.network_transmit:send_rpc_server("rpc_surface_mtr_fx_lvl_unit", var_10_4, var_10_2, arg_10_3, arg_10_4, Vector3.normalize(arg_10_5), var_10_5)
		end
	end
end

function EffectHelper.remote_play_skinned_surface_material_effects(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8, arg_11_9)
	local var_11_0 = Managers.state.network
	local var_11_1 = NetworkLookup.surface_material_effects[arg_11_0]

	if not NetworkUtils.network_safe_position(arg_11_2) then
		return
	end

	if arg_11_9 then
		var_11_0.network_transmit:send_rpc_clients("rpc_skinned_surface_mtr_fx", var_11_1, arg_11_2, arg_11_3, Vector3.normalize(arg_11_4))
	else
		var_11_0.network_transmit:send_rpc_server("rpc_skinned_surface_mtr_fx", var_11_1, arg_11_2, arg_11_3, Vector3.normalize(arg_11_4))
	end
end

function EffectHelper.create_surface_material_drawer_mapping(arg_12_0)
	local var_12_0 = MaterialEffectMappingsUtility.get(arg_12_0).decal.material_drawer_mapping

	for iter_12_0, iter_12_1 in ipairs(MaterialEffectSettings.material_contexts.surface_material) do
		local var_12_1

		if type(var_12_0[iter_12_1]) == "string" then
			var_12_1 = var_12_0[iter_12_1]
		elseif type(var_12_0[iter_12_1]) == "table" then
			local var_12_2 = #var_12_0[iter_12_1]
			local var_12_3 = math.random(1, var_12_2)

			var_12_1 = var_12_0[iter_12_1][var_12_3]
		else
			var_12_1 = nil
		end

		EffectHelper.temporary_material_drawer_mapping[iter_12_1] = var_12_1
	end

	return EffectHelper.temporary_material_drawer_mapping
end

function EffectHelper.flow_cb_play_surface_material_effect(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7, arg_13_8)
	local var_13_0 = arg_13_7 or 0.6
	local var_13_1 = -arg_13_4
	local var_13_2 = arg_13_2 + arg_13_4 * var_13_0
	local var_13_3 = arg_13_8 or 3
	local var_13_4 = script_data.debug_material_effects
	local var_13_5 = Managers.world:world("level_world")
	local var_13_6 = World.get_data(var_13_5, "physics_world")
	local var_13_7, var_13_8, var_13_9, var_13_10, var_13_11 = PhysicsWorld.immediate_raycast(var_13_6, var_13_2, var_13_1, var_13_3, "closest", "types", "both", "collision_filter", "filter_ground_material_check")

	if var_13_7 then
		local var_13_12 = Actor.unit(var_13_11)
		local var_13_13 = Unit.world_rotation(arg_13_1, 0)
		local var_13_14 = Quaternion.up(var_13_13)
		local var_13_15 = Quaternion.forward(var_13_13)
		local var_13_16 = Quaternion.look(var_13_15, var_13_14)

		EffectHelper.play_surface_material_effects(arg_13_0, var_13_5, var_13_12, var_13_8, var_13_16, var_13_10, arg_13_5, arg_13_6, arg_13_1, var_13_11)
	end
end

function EffectHelper.flow_cb_play_footstep_surface_material_effects(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	local var_14_0 = ScriptUnit.has_extension(arg_14_1, "ghost_mode_system")

	if var_14_0 and var_14_0:is_husk() and var_14_0:is_in_ghost_mode() then
		return
	end

	local var_14_1 = Unit.node(arg_14_1, arg_14_2)
	local var_14_2 = MaterialEffectSettings.footstep_raycast_offset
	local var_14_3 = Unit.world_position(arg_14_1, var_14_1) + Vector3(0, 0, var_14_2)
	local var_14_4 = Vector3(0, 0, -1)
	local var_14_5 = MaterialEffectSettings.footstep_raycast_max_range
	local var_14_6 = Unit.get_data(arg_14_1, "sound_character")
	local var_14_7 = Managers.world:world("level_world")
	local var_14_8 = World.get_data(var_14_7, "physics_world")
	local var_14_9, var_14_10, var_14_11, var_14_12, var_14_13 = PhysicsWorld.immediate_raycast(var_14_8, var_14_3, var_14_4, var_14_5, "closest", "types", "both", "collision_filter", "filter_ground_material_check")
	local var_14_14 = Managers.player:owner(arg_14_1)
	local var_14_15 = not var_14_14 or var_14_14.remote or var_14_14.bot_player

	if var_14_9 then
		local var_14_16 = Actor.unit(var_14_13)
		local var_14_17 = Unit.world_rotation(arg_14_1, 0)
		local var_14_18 = Quaternion.up(var_14_17)
		local var_14_19 = Quaternion.forward(var_14_17)
		local var_14_20 = Quaternion.look(var_14_19, var_14_18)

		EffectHelper.play_surface_material_effects(arg_14_0, var_14_7, var_14_16, var_14_10, var_14_20, var_14_12, var_14_6, var_14_15, arg_14_1)
	else
		local var_14_21 = MaterialEffectMappingsUtility.get(arg_14_0)
		local var_14_22 = LevelHelper:current_level_settings().default_surface_material or DefaultSurfaceMaterial
		local var_14_23 = var_14_21.additional_sound_parameters and var_14_21.additional_sound_parameters.switch_params
		local var_14_24 = var_14_21.additional_sound_parameters and var_14_21.additional_sound_parameters.rtpc_params
		local var_14_25 = var_14_21.sound and var_14_21.sound[var_14_22]

		if var_14_25 then
			local var_14_26, var_14_27 = WwiseUtils.make_position_auto_source(var_14_7, var_14_3 + var_14_4 * var_14_5)

			WwiseWorld.set_switch(var_14_27, "husk", var_14_15 and "true" or "false", var_14_26)

			if var_14_25.parameters then
				for iter_14_0, iter_14_1 in pairs(var_14_25.parameters) do
					WwiseWorld.set_switch(var_14_27, iter_14_0, iter_14_1, var_14_26)
				end
			end

			if var_14_6 then
				WwiseWorld.set_switch(var_14_27, "character_foley", var_14_6, var_14_26)
			end

			if var_14_24 then
				for iter_14_2, iter_14_3 in pairs(var_14_24) do
					WwiseWorld.set_source_parameter(var_14_27, var_14_26, iter_14_2, iter_14_3)
				end
			end

			if var_14_23 then
				for iter_14_4, iter_14_5 in pairs(var_14_23) do
					WwiseWorld.set_switch(var_14_27, iter_14_4, iter_14_5, var_14_26)
				end
			end

			WwiseWorld.trigger_event(var_14_27, var_14_25.event, arg_14_4, var_14_26)
		end
	end
end

local var_0_3 = {
	"surface_material"
}
local var_0_4 = {}

function EffectHelper.query_material_surface(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_2 * MaterialEffectSettings.material_query_depth
	local var_15_1 = arg_15_1 + var_15_0 / 2
	local var_15_2 = arg_15_1 - var_15_0 / 2

	return Unit.query_material(arg_15_0, var_15_1, var_15_2, var_0_3, var_0_4)
end
