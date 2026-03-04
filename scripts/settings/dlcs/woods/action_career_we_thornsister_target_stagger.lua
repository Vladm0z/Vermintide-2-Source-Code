-- chunkname: @scripts/settings/dlcs/woods/action_career_we_thornsister_target_stagger.lua

ActionCareerWEThornsisterTargetStagger = class(ActionCareerWEThornsisterTargetStagger, ActionBase)

local var_0_0 = "units/decals/decal_arrow_kerillian"

function ActionCareerWEThornsisterTargetStagger.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionCareerWEThornsisterTargetStagger.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0._first_person_extension = ScriptUnit.has_extension(arg_1_4, "first_person_system")
	arg_1_0._decal_unit = nil
	arg_1_0._unit_spawner = Managers.state.unit_spawner
end

function ActionCareerWEThornsisterTargetStagger.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	arg_2_5 = arg_2_5 or {}

	ActionCareerWEThornsisterTargetStagger.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	arg_2_0._is_flat_dir = arg_2_1.is_flat_direction

	if not arg_2_0.is_bot then
		arg_2_0._decal_unit = arg_2_0._unit_spawner:spawn_local_unit(var_0_0)
	end
end

function ActionCareerWEThornsisterTargetStagger.client_owner_post_update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if arg_3_0._decal_unit then
		local var_3_0 = Unit.local_position(arg_3_0.owner_unit, 0)
		local var_3_1 = arg_3_0:_get_direction(true)
		local var_3_2 = Quaternion.look(var_3_1, Vector3.up())

		Unit.set_local_position(arg_3_0._decal_unit, 0, var_3_0)
		Unit.set_local_rotation(arg_3_0._decal_unit, 0, var_3_2)
	end
end

function ActionCareerWEThornsisterTargetStagger.finish(arg_4_0, arg_4_1)
	if arg_4_0._decal_unit then
		arg_4_0._unit_spawner:mark_for_deletion(arg_4_0._decal_unit)

		arg_4_0._decal_unit = nil
	end

	if arg_4_1 == "new_interupting_action" then
		local var_4_0 = arg_4_0:_get_direction()

		return {
			direction = Vector3Box(var_4_0)
		}
	end
end

function ActionCareerWEThornsisterTargetStagger._get_direction(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0._first_person_extension:current_rotation()
	local var_5_1 = Quaternion.forward(var_5_0)

	if arg_5_0._is_flat_dir or arg_5_1 then
		var_5_1 = Vector3.flat(var_5_1)
	end

	return var_5_1
end
