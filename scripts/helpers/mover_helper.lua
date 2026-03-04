-- chunkname: @scripts/helpers/mover_helper.lua

MoverHelper = MoverHelper or {}
Unit._set_mover = Unit._set_mover or Unit.set_mover

Unit.set_mover = function ()
	assert(false, "Use your locomotion-extension's mover functions instead of setting mover directly through Unit.set_mover")
end

MoverHelper.create_collision_state = function (arg_2_0, arg_2_1)
	local var_2_0 = Unit.actor(arg_2_0, arg_2_1)

	return {
		disable_reasons = {},
		actor = var_2_0
	}
end

MoverHelper.create_mover_state = function ()
	return {
		disable_reasons = {}
	}
end

MoverHelper.set_active_mover = function (arg_4_0, arg_4_1, arg_4_2)
	if Unit.mover(arg_4_0) then
		Unit._set_mover(arg_4_0, arg_4_2)
	end

	arg_4_1.active_mover = arg_4_2
end

MoverHelper.set_disable_reason = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	if arg_5_3 == false then
		arg_5_3 = nil
	end

	local var_5_0 = arg_5_1.disable_reasons

	var_5_0[arg_5_2] = arg_5_3

	if next(var_5_0) == nil then
		Unit._set_mover(arg_5_0, arg_5_1.active_mover)
	else
		Unit._set_mover(arg_5_0, nil)
	end
end

MoverHelper.set_collision_disable_reason = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_1.disable_reasons

	var_6_0[arg_6_2] = arg_6_3

	local var_6_1 = arg_6_1.actor

	for iter_6_0, iter_6_1 in pairs(var_6_0) do
		if iter_6_1 then
			Actor.set_scene_query_enabled(var_6_1, false)

			return
		end
	end

	Actor.set_scene_query_enabled(var_6_1, true)
end
