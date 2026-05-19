-- chunkname: @scripts/settings/dlcs/shovel/action_career_bw_necromancer_raise_dead_targeting.lua

local var_0_0 = "fx/bw_necromancer_ability_indicator"
local var_0_1 = 15
local var_0_2 = -12

ActionCareerBWNecromancerRaiseDeadTargeting = class(ActionCareerBWNecromancerRaiseDeadTargeting, ActionBase)

function ActionCareerBWNecromancerRaiseDeadTargeting.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionCareerBWNecromancerRaiseDeadTargeting.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0._ai_navigation_system = Managers.state.entity:system("ai_navigation_system")
	arg_1_0._first_person_extension = ScriptUnit.has_extension(arg_1_4, "first_person_system")
	arg_1_0._inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	arg_1_0._weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
	arg_1_0._career_extension = ScriptUnit.extension(arg_1_4, "career_system")
	arg_1_0._buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
	arg_1_0._world = arg_1_1
	arg_1_0._owner_unit = arg_1_4
	arg_1_0._last_valid_spawn_position = Vector3Box()
	arg_1_0._fp_rotation = QuaternionBox()
	arg_1_0._decal_diameter_id = World.find_particles_variable(arg_1_0._world, var_0_0, "diameter")
	arg_1_0._unit_spawner = Managers.state.unit_spawner
	arg_1_0._buff_unit_params = {
		is_husk = true
	}

	function arg_1_0._nav_callback()
		local var_2_0 = Managers.time:time("game")

		arg_1_0:_update_targeting(var_2_0)
	end
end

function ActionCareerBWNecromancerRaiseDeadTargeting.client_owner_start_action(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_5 = arg_3_5 or {}

	ActionCareerBWNecromancerRaiseDeadTargeting.super.client_owner_start_action(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_0._weapon_extension:set_mode(true)

	local var_3_0 = arg_3_1.breed_to_spawn
	local var_3_1 = ScriptUnit.has_extension(arg_3_0._owner_unit, "talent_system")

	if var_3_1 and var_3_1:has_talent("sienna_necromancer_6_3_2") then
		var_3_0 = arg_3_1.faster_breed_to_spawn
	end

	arg_3_0._spawn_data = {
		cooldown_leeway = arg_3_1.cooldown_leeway,
		cooldown_per_spawn_percent = arg_3_1.cooldown_per_spawn_percent,
		controlled_unit_template = arg_3_1.controlled_unit_template,
		breed_to_spawn = var_3_0,
		spawns_per_second = arg_3_1.spawns_per_second,
		target_center = Vector3Box()
	}

	local var_3_2 = arg_3_0._owner_unit

	arg_3_0._first_person_extension:play_unit_sound_event("Play_career_necro_ability_raise_dead_target", var_3_2, 0, false)

	arg_3_0._valid = false
	arg_3_0._diameter = arg_3_1.radius * 2

	arg_3_0:_start_targeting()
	arg_3_0._ai_navigation_system:add_safe_navigation_callback(arg_3_0._nav_callback)
end

function ActionCareerBWNecromancerRaiseDeadTargeting.client_owner_post_update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_0._ai_navigation_system:add_safe_navigation_callback(arg_4_0._nav_callback)
end

function ActionCareerBWNecromancerRaiseDeadTargeting._start_targeting(arg_5_0)
	local var_5_0 = arg_5_0._world

	arg_5_0._spawn_decal_id = World.create_particles(var_5_0, var_0_0, Vector3(0, 0, -600))

	World.set_particles_variable(var_5_0, arg_5_0._spawn_decal_id, arg_5_0._decal_diameter_id, Vector3(arg_5_0._diameter, arg_5_0._diameter, 1))

	local var_5_1 = POSITION_LOOKUP[arg_5_0._owner_unit]

	arg_5_0._last_valid_spawn_position:store(var_5_1)
end

function ActionCareerBWNecromancerRaiseDeadTargeting._update_targeting(arg_6_0, arg_6_1)
	local var_6_0, var_6_1 = arg_6_0:_get_projectile_position(var_0_1)
	local var_6_2 = arg_6_0._world

	if var_6_0 then
		arg_6_0._valid = true

		arg_6_0._spawn_data.target_center:store(var_6_1)
		World.move_particles(var_6_2, arg_6_0._spawn_decal_id, var_6_1)
	end
end

function ActionCareerBWNecromancerRaiseDeadTargeting._get_projectile_position(arg_7_0)
	local var_7_0 = arg_7_0._world
	local var_7_1 = World.get_data(var_7_0, "physics_world")
	local var_7_2 = "filter_adept_teleport"
	local var_7_3, var_7_4 = arg_7_0:_get_first_person_position_direction()
	local var_7_5 = var_7_4 * var_0_1
	local var_7_6 = Vector3(0, 0, var_0_2)
	local var_7_7, var_7_8 = WeaponHelper:ground_target(var_7_1, arg_7_0._owner_unit, var_7_3, var_7_5, var_7_6, var_7_2)

	if var_7_7 then
		local var_7_9 = Managers.state.entity:system("ai_system"):nav_world()
		local var_7_10 = 1
		local var_7_11 = 1
		local var_7_12 = LocomotionUtils.pos_on_mesh(var_7_9, var_7_8, var_7_10, var_7_11)

		if not var_7_12 then
			local var_7_13 = 3
			local var_7_14 = 0.5

			var_7_12 = GwNavQueries.inside_position_from_outside_position(var_7_9, var_7_8, var_7_10, var_7_11, var_7_13, var_7_14)
		end

		var_7_7 = not not var_7_12
		var_7_8 = var_7_12
	end

	return var_7_7, var_7_8
end

function ActionCareerBWNecromancerRaiseDeadTargeting._get_first_person_position_direction(arg_8_0)
	local var_8_0 = arg_8_0._first_person_extension
	local var_8_1 = var_8_0:current_position()
	local var_8_2 = var_8_0:current_rotation()
	local var_8_3 = math.rad(45)
	local var_8_4 = math.rad(12.5)
	local var_8_5 = Quaternion.yaw(var_8_2)
	local var_8_6 = math.clamp(Quaternion.pitch(var_8_2), -var_8_3, var_8_4)
	local var_8_7 = Quaternion(Vector3.up(), var_8_5)
	local var_8_8 = Quaternion(Vector3.right(), var_8_6)
	local var_8_9 = Quaternion.multiply(var_8_7, var_8_8)
	local var_8_10 = Quaternion.forward(var_8_9)

	return var_8_1, var_8_10
end

function ActionCareerBWNecromancerRaiseDeadTargeting.finish(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0._world
	local var_9_1 = arg_9_0._spawn_decal_id

	World.destroy_particles(var_9_0, var_9_1)

	if arg_9_1 == "new_interupting_action" and arg_9_0._valid and arg_9_2.new_sub_action == "spawn_summon_area" then
		local var_9_2 = arg_9_0._spawn_data.target_center:unbox()
		local var_9_3 = arg_9_0._buff_extension:create_shared_lifetime_buff_unit(var_9_2)
		local var_9_4 = FrameTable.alloc_table()

		var_9_4.source_attacker_unit = arg_9_0._owner_unit

		local var_9_5 = Managers.state.entity:system("buff_system"):add_buff_synced(var_9_3, "raise_dead_ability", BuffSyncType.All, var_9_4)

		ScriptUnit.extension(var_9_3, "buff_system"):get_buff_by_id(var_9_5).spawn_data = arg_9_0._spawn_data

		local var_9_6 = arg_9_0._owner_unit
		local var_9_7 = ScriptUnit.extension_input(var_9_6, "dialogue_system")
		local var_9_8 = FrameTable.alloc_table()

		var_9_7:trigger_networked_dialogue_event("activate_ability", var_9_8)

		local var_9_9 = Managers.state.network.network_transmit
		local var_9_10 = "career_necro_skeleton_spawn"

		Managers.state.entity:system("audio_system"):play_audio_position_event(var_9_10, var_9_2)
		arg_9_0._first_person_extension:play_unit_sound_event("Play_career_necro_ability_raise_dead_cast", var_9_6, 0, false)
		arg_9_0._first_person_extension:play_remote_unit_sound_event("Play_career_necro_ability_raise_dead_cast_husk", var_9_6, 0)

		local var_9_11 = arg_9_0._is_server
		local var_9_12 = "sienna_necromancer_ability_stagger"
		local var_9_13 = ScriptUnit.has_extension(arg_9_0._owner_unit, "talent_system")

		if var_9_13 and var_9_13:has_talent("sienna_necromancer_6_2") then
			var_9_12 = "sienna_necromancer_ability_stagger_improved"
		end

		local var_9_14 = arg_9_0._world
		local var_9_15 = ExplosionUtils.get_template(var_9_12)
		local var_9_16 = 1
		local var_9_17 = "career_ability"
		local var_9_18 = false
		local var_9_19 = Quaternion.identity()
		local var_9_20 = arg_9_0._career_extension:get_career_power_level()

		DamageUtils.create_explosion(var_9_14, var_9_6, var_9_2, var_9_19, var_9_15, var_9_16, var_9_17, var_9_11, var_9_18, var_9_6, var_9_20, false, var_9_6)

		local var_9_21 = NetworkLookup.explosion_templates[var_9_12]
		local var_9_22 = NetworkLookup.damage_sources[var_9_17]
		local var_9_23 = Managers.state.unit_storage:go_id(var_9_6)

		if var_9_11 then
			var_9_9:send_rpc_clients("rpc_create_explosion", var_9_23, false, var_9_2, var_9_19, var_9_21, var_9_16, var_9_22, var_9_20, false, var_9_23)
		else
			var_9_9:send_rpc_server("rpc_create_explosion", var_9_23, false, var_9_2, var_9_19, var_9_21, var_9_16, var_9_22, var_9_20, false, var_9_23)
		end

		local var_9_24 = "fx/necromancer_wave_round"
		local var_9_25 = NetworkLookup.effects[var_9_24]
		local var_9_26 = 0
		local var_9_27 = false

		var_9_9:send_rpc_server("rpc_play_particle_effect_no_rotation", var_9_25, NetworkConstants.invalid_game_object_id, var_9_26, var_9_2, var_9_27)
		arg_9_0._career_extension:start_activated_ability_cooldown()
		arg_9_0._career_extension:get_passive_ability_by_name("bw_necromancer"):store_buff_unit(var_9_3)
	end

	return nil
end
