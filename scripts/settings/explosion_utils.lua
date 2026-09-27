-- chunkname: @scripts/settings/explosion_utils.lua

local ExplosionUtils = ExplosionUtils

ExplosionUtils = ExplosionUtils or {}
ExplosionUtils = ExplosionUtils

ExplosionUtils.get_template = function (arg_1_0)
	-- function 1
	if not arg_1_0 then
		return
	end

	return MechanismOverrides.get(ExplosionTemplates[arg_1_0])
end
