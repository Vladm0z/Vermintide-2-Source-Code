-- chunkname: @scripts/settings/dlcs/shovel/action_career_bw_necromancer_targetting.lua

require("scripts/unit_extensions/weapons/area_damage/liquid/damage_wave_templates")

local var_0_0 = DamageWaveTemplates.templates.necromancer_curse_wave

ActionCareerBWNecromancerTargetting = class(ActionCareerBWNecromancerTargetting, ActionBase)

local var_0_1 = 1
local var_0_2 = 2
local var_0_3 = 0.5
local var_0_4 = 2.5
local var_0_5 = 0.25

function ActionCareerBWNecromancerTargetting.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionCareerBWNecromancerTargetting.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0._ai_navigation_system = Managers.state.entity:system("ai_navigation_system")
	arg_1_0._nav_world = Managers.state.entity:system("ai_system"):nav_world()
	arg_1_0._inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	arg_1_0._talent_extension = ScriptUnit.extension(arg_1_4, "talent_system")
	arg_1_0._first_person_extension = ScriptUnit.has_extension(arg_1_4, "first_person_system")
	arg_1_0._weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
	arg_1_0._local_player = Managers.player:owner(arg_1_4).local_player
	arg_1_0._owner_unit = arg_1_4
	arg_1_0._has_valid_position = false
	arg_1_0._last_valid_cast_direction = Vector3Box()
	arg_1_0._last_valid_cast_position = Vector3Box()
	arg_1_0._decal_unit = nil
	arg_1_0._decal_unit_name = "units/decals/decal_arrow_kerillian"

	function arg_1_0._nav_callback()
		local var_2_0 = Managers.time:time("game")

		arg_1_0:_update_targetting(var_2_0)
	end
end

function ActionCareerBWNecromancerTargetting.client_owner_start_action(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_5 = arg_3_5 or {}

	ActionCareerBWNecromancerTargetting.super.client_owner_start_action(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)

	arg_3_0._round_career_ability = arg_3_0._talent_extension:has_talent("sienna_necromancer_6_3")
	arg_3_0._has_valid_position = false

	arg_3_0._weapon_extension:set_mode(false)

	if arg_3_0._local_player and not arg_3_0._round_career_ability then
		local var_3_0 = arg_3_0._decal_unit_name

		arg_3_0._decal_unit = Managers.state.unit_spawner:spawn_local_unit(var_3_0)
	end

	arg_3_0._ai_navigation_system:add_safe_navigation_callback(arg_3_0._nav_callback)
	arg_3_0._first_person_extension:play_hud_sound_event("Play_career_necro_ability_withering_wave_target", nil, false)
end

function ActionCareerBWNecromancerTargetting.client_owner_post_update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_0._ai_navigation_system:add_safe_navigation_callback(arg_4_0._nav_callback)
end

function ActionCareerBWNecromancerTargetting._get_first_person_position_direction(arg_5_0)
	local var_5_0 = arg_5_0._first_person_extension
	local var_5_1 = var_5_0:current_position()
	local var_5_2 = var_5_0:current_rotation()
	local var_5_3 = math.rad(45)
	local var_5_4 = math.rad(12.5)
	local var_5_5 = Quaternion.yaw(var_5_2)
	local var_5_6 = math.clamp(Quaternion.pitch(var_5_2), -var_5_3, var_5_4)
	local var_5_7 = Quaternion(Vector3.up(), var_5_5)
	local var_5_8 = Quaternion(Vector3.right(), var_5_6)
	local var_5_9 = Quaternion.multiply(var_5_7, var_5_8)
	local var_5_10 = Quaternion.forward(var_5_9)

	return var_5_1, var_5_10
end

function ActionCareerBWNecromancerTargetting._update_targetting(arg_6_0, arg_6_1)
	local var_6_0 = 1
	local var_6_1 = 2
	local var_6_2 = arg_6_0._nav_world
	local var_6_3, var_6_4 = arg_6_0:_get_first_person_position_direction()
	local var_6_5 = Vector3.normalize(Vector3.flat(var_6_4))

	if arg_6_0._decal_unit then
		local var_6_6 = Quaternion.look(var_6_5, Vector3.up())

		Unit.set_local_position(arg_6_0._decal_unit, 0, POSITION_LOOKUP[arg_6_0._owner_unit])
		Unit.set_local_rotation(arg_6_0._decal_unit, 0, var_6_6)
	end

	if arg_6_0._round_career_ability then
		local var_6_7 = POSITION_LOOKUP[arg_6_0.owner_unit]
		local var_6_8 = LocomotionUtils.pos_on_mesh(var_6_2, var_6_7, var_6_0, var_6_1)

		if not var_6_8 then
			arg_6_0._has_valid_position = false

			return
		end

		arg_6_0._has_valid_position = true

		arg_6_0._weapon_extension:set_mode(true)
		arg_6_0._last_valid_cast_position:store(var_6_8)
		arg_6_0._last_valid_cast_direction:store(var_6_5)
	else
		local var_6_9 = POSITION_LOOKUP[arg_6_0.owner_unit] + var_6_5 * var_0_1
		local var_6_10 = LocomotionUtils.pos_on_mesh(var_6_2, var_6_9, var_6_0, var_6_1)

		if not var_6_10 then
			arg_6_0._has_valid_position = false

			return
		end

		local var_6_11 = (var_0_0.max_speed + var_0_0.start_speed * 0.5) * var_0_0.time_of_life * 0.5

		arg_6_0._has_valid_position = true

		arg_6_0._weapon_extension:set_mode(true)
		arg_6_0._last_valid_cast_position:store(var_6_10)
		arg_6_0._last_valid_cast_direction:store(var_6_5)
	end
end

function ActionCareerBWNecromancerTargetting.finish(arg_7_0, arg_7_1)
	if arg_7_0._decal_unit then
		Managers.state.unit_spawner:mark_for_deletion(arg_7_0._decal_unit)

		arg_7_0._decal_unit = nil
	end

	if arg_7_1 == "new_interupting_action" and arg_7_0._has_valid_position then
		arg_7_0._weapon_extension:set_mode(true)

		return {
			position = arg_7_0._last_valid_cast_position,
			direction = arg_7_0._last_valid_cast_direction
		}
	else
		arg_7_0._inventory_extension:wield_previous_non_level_slot()
	end

	return nil
end
