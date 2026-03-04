-- chunkname: @scripts/settings/explosion_utils.lua

ExplosionUtils = ExplosionUtils or {}

ExplosionUtils.get_template = function (arg_1_0)
	if not arg_1_0 then
		return
	end

	return MechanismOverrides.get(ExplosionTemplates[arg_1_0])
end
