-- chunkname: @scripts/settings/dlcs/geheimnisnacht_2021/action_inspect_geheimnisnacht_2021.lua

ActionInspectGeheimnisnacht2021 = class(ActionInspectGeheimnisnacht2021, ActionDummy)

local var_0_0 = 0.05
local var_0_1 = 0.5
local var_0_2 = 1.05
local var_0_3 = 0
local var_0_4 = 0
local var_0_5 = 1
local var_0_6 = "fx/invisible_screen_distortion_extreme"
local var_0_7 = 0.5
local var_0_8 = 5
local var_0_9 = {
	bw_necromancer = true,
	wh_priest = true,
	we_thornsister = true,
	es_questingknight = true,
	dr_slayer = true
}

function ActionInspectGeheimnisnacht2021.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionInspectGeheimnisnacht2021.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0._first_person_extension = ScriptUnit.extension(arg_1_4, "first_person_system")
	arg_1_0._dialogue_input = ScriptUnit.extension_input(arg_1_4, "dialogue_system")
	arg_1_0._buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
	arg_1_0._career_extension = ScriptUnit.extension(arg_1_4, "career_system")
	arg_1_0._health_extension = ScriptUnit.has_extension(arg_1_4, "health_system")
	arg_1_0._influence_str = 0
	arg_1_0._influence_str_max = 0
	arg_1_0._screen_fx_id = nil
	arg_1_0._is_immune = var_0_9[arg_1_0._career_extension:career_name()]
	arg_1_0._next_curse_time_t = 0
	arg_1_0._take_curse_damage = false
	arg_1_0._buff_system = Managers.state.entity:system("buff_system")
end

function ActionInspectGeheimnisnacht2021.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2)
	ActionInspectGeheimnisnacht2021.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2)

	arg_2_0._influence_str = 0
	arg_2_0._influence_str_max = 0
	arg_2_0._next_curse_time_t = 0
	arg_2_0._take_curse_damage = false

	arg_2_0._first_person_extension:animation_set_variable("influence", arg_2_0._influence_str)
end

function ActionInspectGeheimnisnacht2021.client_owner_post_update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = arg_3_0._influence_str

	if not arg_3_0._is_immune then
		local var_3_1 = Unit.world_rotation(arg_3_0.weapon_unit, 0)
		local var_3_2 = arg_3_0._first_person_extension:current_rotation()
		local var_3_3 = Quaternion.forward(var_3_1)
		local var_3_4 = Quaternion.forward(var_3_2)
		local var_3_5 = Vector3.dot(var_3_3, var_3_4)
		local var_3_6 = var_3_5 > 0.9 and math.max(var_3_5 * var_0_2, var_0_3) or 0
		local var_3_7 = var_0_0 * arg_3_1

		if var_3_6 < arg_3_0._influence_str then
			var_3_7 = var_0_1 * arg_3_1
		end

		local var_3_8 = var_3_6 * var_0_0

		arg_3_0._influence_str = math.min(math.lerp(arg_3_0._influence_str, var_3_6, var_3_7), var_0_5)
	end

	arg_3_0._first_person_extension:animation_set_variable("influence", arg_3_0._influence_str)

	arg_3_0._influence_str_max = math.max(arg_3_0._influence_str_max, arg_3_0._influence_str)

	if var_3_0 < 0.3 and arg_3_0._influence_str >= 0.3 then
		Unit.animation_event(arg_3_0.first_person_unit, "gehemnisnacht_egg_heartbeat_start")
	end

	if var_3_0 > 0.3 and arg_3_0._influence_str <= 0.3 then
		Unit.animation_event(arg_3_0.first_person_unit, "gehemnisnacht_egg_heartbeat_stop")
	end

	if var_3_0 < 0.7 and arg_3_0._influence_str >= 0.7 then
		Unit.animation_event(arg_3_0.first_person_unit, "gehemnisnacht_egg_level2")
		arg_3_0:_create_screen_particles()
		arg_3_0._first_person_extension:set_weapon_sway_settings({
			recentering_lerp_speed = 250,
			lerp_speed = 3,
			sway_range = 1,
			camera_look_sensitivity = 0.03,
			look_sensitivity = 8
		})
	end

	if var_3_0 > 0.7 and arg_3_0._influence_str <= 0.7 then
		Unit.animation_event(arg_3_0.first_person_unit, "gehemnisnacht_egg_level1")
		arg_3_0._first_person_extension:set_weapon_sway_settings({
			recentering_lerp_speed = 0,
			lerp_speed = 10,
			sway_range = 1,
			camera_look_sensitivity = 1,
			look_sensitivity = 1.5
		})
	end

	if var_3_0 < 0.9 and arg_3_0._influence_str >= 0.9 then
		Unit.animation_event(arg_3_0.first_person_unit, "gehemnisnacht_egg_level3")
		arg_3_0._first_person_extension:set_weapon_sway_settings({
			recentering_lerp_speed = 10,
			lerp_speed = 10,
			sway_range = 1,
			camera_look_sensitivity = 1,
			look_sensitivity = 1.5
		})

		arg_3_0._take_curse_damage = true
	end

	if arg_3_0._take_curse_damage and arg_3_2 >= arg_3_0._next_curse_time_t then
		arg_3_0._next_curse_time_t = arg_3_2 + var_0_7

		arg_3_0._health_extension:convert_to_temp(var_0_8)
	end

	if arg_3_0._screen_fx_id then
		local var_3_9 = Managers.player:owner(arg_3_0.owner_unit).viewport_name
		local var_3_10 = ScriptWorld.viewport(arg_3_0.world, var_3_9)
		local var_3_11 = ScriptViewport.camera(var_3_10)
		local var_3_12 = RESOLUTION_LOOKUP.res_w
		local var_3_13 = RESOLUTION_LOOKUP.res_h
		local var_3_14 = var_3_12 / 2
		local var_3_15 = var_3_13 / 2
		local var_3_16 = Unit.world_position(arg_3_0.weapon_unit, 0)
		local var_3_17 = Camera.world_to_screen(var_3_11, var_3_16)
		local var_3_18 = Vector3((var_3_17.x - var_3_14) / var_3_14, 0, (var_3_17.y - var_3_15) / var_3_15)

		World.move_particles(arg_3_0.world, arg_3_0._screen_fx_id, var_3_18)
	end
end

function ActionInspectGeheimnisnacht2021.finish(arg_4_0, arg_4_1)
	ActionInspectGeheimnisnacht2021.super.finish(arg_4_0, arg_4_1)
	arg_4_0:_destroy_screen_particles()
end

function ActionInspectGeheimnisnacht2021._create_screen_particles(arg_5_0)
	if not arg_5_0._screen_fx_id then
		arg_5_0._screen_fx_id = arg_5_0._first_person_extension:create_screen_particles(var_0_6, Vector3(1, 0, 0))
	end
end

function ActionInspectGeheimnisnacht2021._destroy_screen_particles(arg_6_0)
	if arg_6_0._screen_fx_id then
		arg_6_0._first_person_extension:stop_spawning_screen_particles(arg_6_0._screen_fx_id)

		arg_6_0._screen_fx_id = nil
	end
end
