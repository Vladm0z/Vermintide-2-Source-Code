-- chunkname: @scripts/settings/dlcs/shovel/action_career_bw_necromancer_raise_dead.lua

local var_0_0 = 4.5
local var_0_1 = 9
local var_0_2 = 0.75
local var_0_3 = 0.15
local var_0_4 = 0.1
local var_0_5 = math.degrees_to_radians(-60)
local var_0_6 = math.degrees_to_radians(60)

ActionCareerBWNecromancerRaiseDead = class(ActionCareerBWNecromancerRaiseDead, ActionBase)

function ActionCareerBWNecromancerRaiseDead.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionCareerBWNecromancerRaiseDead.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0._career_extension = ScriptUnit.extension(arg_1_4, "career_system")
	arg_1_0._passive_ability = arg_1_0._career_extension:get_passive_ability_by_name("bw_necromancer")
	arg_1_0._inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	arg_1_0._first_person_extension = ScriptUnit.has_extension(arg_1_4, "first_person_system")
	arg_1_0._talent_extension = ScriptUnit.extension(arg_1_4, "talent_system")
	arg_1_0._buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
	arg_1_0._weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
	arg_1_0._owner_unit = arg_1_4
	arg_1_0._is_server = arg_1_3
	arg_1_0._world = arg_1_1
	arg_1_0._ai_navigation_system = Managers.state.entity:system("ai_navigation_system")
	arg_1_0._nav_world = Managers.state.entity:system("ai_system"):nav_world()
	arg_1_0._traverse_logic = Managers.state.entity:system("ai_slot_system"):traverse_logic()
	arg_1_0._seed = math.random_seed()
	arg_1_0.fx_spline_ids = {
		World.find_particles_variable(arg_1_1, "fx/wpnfx_staff_death/curse_spirit", "spline_1"),
		World.find_particles_variable(arg_1_1, "fx/wpnfx_staff_death/curse_spirit", "spline_2"),
		World.find_particles_variable(arg_1_1, "fx/wpnfx_staff_death/curse_spirit", "spline_3")
	}

	function arg_1_0._nav_callback()
		local var_2_0 = Managers.time:time("game")

		arg_1_0:_update_spawning(var_2_0)
	end
end

function ActionCareerBWNecromancerRaiseDead.client_owner_start_action(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_5 = arg_3_5 or {}

	ActionCareerBWNecromancerRaiseDead.super.client_owner_start_action(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)

	arg_3_0._next_spawn_t = arg_3_2

	if arg_3_3 then
		arg_3_0:_play_vo()
	end
end

function ActionCareerBWNecromancerRaiseDead._trigger_spawn(arg_4_0)
	local var_4_0 = arg_4_0:_generate_position()

	if var_4_0 then
		World.create_particles(arg_4_0._world, "fx/necromancer_summon_decal", var_4_0)

		local var_4_1 = NetworkLookup.effects["fx/wpnfx_staff_death/curse_spirit_first"]
		local var_4_2 = POSITION_LOOKUP[arg_4_0._owner_unit] + Vector3.up() * 0.5
		local var_4_3 = arg_4_0._first_person_extension:current_rotation()
		local var_4_4 = Quaternion.right(var_4_3)
		local var_4_5 = var_4_0 - var_4_2
		local var_4_6 = math.sign(Vector3.dot(var_4_5, var_4_4))
		local var_4_7 = math.pi * math.random(0.1, 0.25)
		local var_4_8 = Quaternion.axis_angle(Vector3.up(), var_4_7 * var_4_6)
		local var_4_9 = var_4_2 + Quaternion.rotate(var_4_8, var_4_5) * 0.5 + Vector3.up()
		local var_4_10 = {
			var_4_2,
			var_4_9,
			var_4_0
		}

		Managers.state.network:rpc_play_particle_effect_spline(nil, var_4_1, arg_4_0.fx_spline_ids, var_4_10)
	end

	arg_4_0._passive_ability:spawn_pet(arg_4_0._controlled_unit_template, arg_4_0._breed_to_spawn, var_4_0, NecromancerPositionModes.Absolute)
	arg_4_0._career_extension:reduce_activated_ability_cooldown_percent(-var_0_3)
end

function ActionCareerBWNecromancerRaiseDead.client_owner_post_update(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	arg_5_0._ai_navigation_system:add_safe_navigation_callback(arg_5_0._nav_callback)
end

function ActionCareerBWNecromancerRaiseDead._update_spawning(arg_6_0, arg_6_1)
	if arg_6_0._career_extension:current_ability_cooldown_percentage() >= 1 - var_0_4 then
		arg_6_0._weapon_extension:stop_action("action_complete")
	end

	if arg_6_1 > arg_6_0._next_spawn_t then
		arg_6_0._next_spawn_t = arg_6_0._next_spawn_t + var_0_2

		arg_6_0:_trigger_spawn()
	end
end

function ActionCareerBWNecromancerRaiseDead._play_vo(arg_7_0)
	local var_7_0 = arg_7_0.owner_unit
	local var_7_1 = ScriptUnit.extension_input(var_7_0, "dialogue_system")
	local var_7_2 = FrameTable.alloc_table()

	var_7_1:trigger_networked_dialogue_event("activate_ability", var_7_2)
end

function ActionCareerBWNecromancerRaiseDead._generate_position(arg_8_0)
	local var_8_0 = arg_8_0._position:unbox()
	local var_8_1 = 1
	local var_8_2 = 3
	local var_8_3 = LocomotionUtils.pos_on_mesh(arg_8_0._nav_world, var_8_0, var_8_1, var_8_2)

	if not var_8_3 then
		return nil
	end

	local var_8_4
	local var_8_5
	local var_8_6, var_8_7

	arg_8_0._seed, var_8_6, var_8_7 = math.get_uniformly_random_point_inside_sector_seeded(arg_8_0._seed, var_0_0, var_0_1, var_0_5, var_0_6)

	local var_8_8 = Vector3(var_8_6, var_8_7, 0)
	local var_8_9 = arg_8_0._first_person_extension:current_rotation()
	local var_8_10 = var_8_3 + Quaternion.rotate(var_8_9, var_8_8)
	local var_8_11, var_8_12 = GwNavQueries.raycast(arg_8_0._nav_world, var_8_3, var_8_10, arg_8_0._traverse_logic)

	return var_8_12
end
