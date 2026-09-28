-- chunkname: @scripts/entity_system/systems/fade/fade_system_dummy.lua

require("foundation/scripts/util/api_verification")
require("scripts/entity_system/systems/fade/fade_system")

FadeSystemDummy = class(FadeSystemDummy, ExtensionSystemBase)

local extensions = {
	"PlayerUnitFadeExtension",
	"AIUnitFadeExtension"
}

FadeSystemDummy.init = function (self, entity_system_creation_context, system_name)
	-- function 1
	FadeSystemDummy.super.init(self, entity_system_creation_context, system_name, extensions)
end

FadeSystemDummy.destroy = function (self)
	-- function 2
	return
end

FadeSystemDummy.on_add_extension = function (self, world, unit, extension_name, extension_init_data)
	-- function 3
	return {}
end

FadeSystemDummy.freeze = function (self, unit, extension_name, reason)
	-- function 4
	return
end

FadeSystemDummy.unfreeze = function (self, unit)
	-- function 5
	return
end

FadeSystemDummy.set_min_fade = function (self, unit, min_fade)
	-- function 6
	return
end

FadeSystemDummy.new_linked_units = function (self, unit, new_linked_units)
	-- function 7
	return
end

FadeSystemDummy.on_remove_extension = function (self, unit, extension_name)
	-- function 8
	return
end

FadeSystemDummy.local_player_created = function (self, player)
	-- function 9
	return
end

FadeSystemDummy.update = function (self, context, t)
	-- function 10
	return
end

ApiVerification.ensure_public_api(FadeSystem, FadeSystemDummy)
