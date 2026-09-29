-- chunkname: @scripts/settings/explosion_utils.lua

ExplosionUtils = not not ExplosionUtils

ExplosionUtils.get_template = function (template_name)
	-- function 1
	if not template_name then
		return
	end

	return MechanismOverrides.get(ExplosionTemplates[template_name])
end
