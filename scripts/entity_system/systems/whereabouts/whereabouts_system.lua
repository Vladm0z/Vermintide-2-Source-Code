-- chunkname: @scripts/entity_system/systems/whereabouts/whereabouts_system.lua

WhereaboutsSystem = class(WhereaboutsSystem, ExtensionSystemBase)

local extensions = {
	"PlayerWhereaboutsExtension",
	"LureWhereaboutsExtension"
}

WhereaboutsSystem.init = function (self, context, system_name)
	-- function 1
	WhereaboutsSystem.super.init(self, context, system_name, extensions)

	local world = context.world
end

WhereaboutsSystem.destroy = function (self)
	-- function 2
	return
end

WhereaboutsSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data)
	-- function 3
	local extension = WhereaboutsSystem.super.on_add_extension(self, world, unit, extension_name, extension_init_data)

	return extension
end

WhereaboutsSystem.extensions_ready = function (self, world, unit, extension_name)
	-- function 4
	return
end

WhereaboutsSystem.hot_join_sync = function (self, sender, player)
	-- function 5
	return
end

WhereaboutsSystem.update = function (self, context, t)
	-- function 6
	WhereaboutsSystem.super.update(self, context, t)
end
