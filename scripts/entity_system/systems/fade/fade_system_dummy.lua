-- chunkname: @scripts/entity_system/systems/fade/fade_system_dummy.lua

require("foundation/scripts/util/api_verification")
require("scripts/entity_system/systems/fade/fade_system")

FadeSystemDummy = class(FadeSystemDummy, ExtensionSystemBase)

local tbl = {
	"PlayerUnitFadeExtension",
	"AIUnitFadeExtension"
}

FadeSystemDummy.init = function (arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	FadeSystemDummy.super.init(arg_1_0, arg_1_1, arg_1_2, tbl)
end

FadeSystemDummy.destroy = function (arg_2_0)
	-- function 2
	return
end

FadeSystemDummy.on_add_extension = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	return {}
end

FadeSystemDummy.freeze = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	return
end

FadeSystemDummy.unfreeze = function (arg_5_0, arg_5_1)
	-- function 5
	return
end

FadeSystemDummy.set_min_fade = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	return
end

FadeSystemDummy.new_linked_units = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	return
end

FadeSystemDummy.on_remove_extension = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	return
end

FadeSystemDummy.local_player_created = function (arg_9_0, arg_9_1)
	-- function 9
	return
end

FadeSystemDummy.update = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	return
end

ApiVerification.ensure_public_api(FadeSystem, FadeSystemDummy)
