-- chunkname: @scripts/helpers/mover_helper.lua

local MoverHelper = MoverHelper

MoverHelper = MoverHelper or {}
MoverHelper = MoverHelper

local Unit = Unit
local _set_mover = Unit._set_mover

_set_mover = _set_mover or Unit.set_mover
Unit._set_mover = _set_mover

Unit.set_mover = function ()
	-- function 1
	assert(false, "Use your locomotion-extension's mover functions instead of setting mover directly through Unit.set_mover")
end

MoverHelper.create_collision_state = function (arg_2_0, arg_2_1)
	-- function 2
	local actor = Unit.actor(arg_2_0, arg_2_1)

	return {
		disable_reasons = {},
		actor = actor
	}
end

MoverHelper.create_mover_state = function ()
	-- function 3
	return {
		disable_reasons = {}
	}
end

MoverHelper.set_active_mover = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	if not Unit.mover(arg_4_0) then
		Unit._set_mover(arg_4_0, arg_4_2)
	end

	arg_4_1.active_mover = arg_4_2
end

MoverHelper.set_disable_reason = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	if arg_5_3 == false then
		arg_5_3 = nil
	end

	local disable_reasons = arg_5_1.disable_reasons

	disable_reasons[arg_5_2] = arg_5_3

	if next(disable_reasons) == nil then
		Unit._set_mover(arg_5_0, arg_5_1.active_mover)
	else
		Unit._set_mover(arg_5_0, nil)
	end
end

MoverHelper.set_collision_disable_reason = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local disable_reasons = arg_6_1.disable_reasons

	disable_reasons[arg_6_2] = arg_6_3

	local actor = arg_6_1.actor

	for k, v in pairs(disable_reasons) do
		if not v then
			Actor.set_scene_query_enabled(actor, false)

			return
		end
	end

	Actor.set_scene_query_enabled(actor, true)
end
