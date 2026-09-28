-- chunkname: @scripts/settings/explosion_utils.lua

local ExplosionUtils = ExplosionUtils

ExplosionUtils = not not ExplosionUtils or not not {}
ExplosionUtils = ExplosionUtils

ExplosionUtils.get_template = function (template_name)
	-- function 1
	if not template_name then
		return
	end

	return MechanismOverrides.get(ExplosionTemplates[template_name])
end
