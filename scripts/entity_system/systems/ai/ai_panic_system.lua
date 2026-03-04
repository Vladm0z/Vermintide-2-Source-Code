-- chunkname: @scripts/entity_system/systems/ai/ai_panic_system.lua

require("scripts/unit_extensions/human/ai_player_unit/ai_utils")

local var_0_0 = {
	"AIPanicExtension",
	"AIFearExtension"
}

AIPanicSystem = class(AIPanicSystem, ExtensionSystemBase)

function AIPanicSystem.init(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = arg_1_1.entity_manager

	var_1_0:register_system(arg_1_0, arg_1_2, var_0_0)

	arg_1_0.entity_manager = var_1_0
	arg_1_0.is_server = arg_1_1.is_server
	arg_1_0.world = arg_1_1.world
	arg_1_0.unit_storage = arg_1_1.unit_storage
	arg_1_0.nav_world = Managers.state.entity:system("ai_system"):nav_world()
	arg_1_0.unit_extension_data = {}
	arg_1_0.panic_zones = {}
	arg_1_0.panic_units = {}
	arg_1_0.fear_units = {}
	arg_1_0.panic_zone_id = 1
	arg_1_0.current_fear_unit_index = 1
	arg_1_0.current_panic_unit_index = 1
end

function AIPanicSystem.destroy(arg_2_0)
	return
end

local var_0_1 = {}

function AIPanicSystem.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = {}

	ScriptUnit.set_extension(arg_3_2, "ai_panic_system", var_3_0, var_0_1)

	arg_3_0.unit_extension_data[arg_3_2] = var_3_0

	if arg_3_3 == "AIPanicExtension" then
		arg_3_0.panic_units[#arg_3_0.panic_units + 1] = arg_3_2
	end

	if arg_3_3 == "AIFearExtension" then
		local var_3_1 = arg_3_4.fear_active_on_spawn
		local var_3_2 = arg_3_4.fear_radius

		arg_3_0.fear_units[#arg_3_0.fear_units + 1] = arg_3_2
		var_3_0.fear_radius = var_3_2

		if var_3_1 then
			arg_3_0:activate_fear(arg_3_2)
		end
	end

	return var_3_0
end

function AIPanicSystem.on_remove_extension(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0.unit_extension_data[arg_4_1]

	if arg_4_2 == "AIPanicExtension" then
		local var_4_1 = arg_4_0.panic_units
		local var_4_2 = #var_4_1

		for iter_4_0 = 1, var_4_2 do
			if var_4_1[iter_4_0] == arg_4_1 then
				var_4_1[iter_4_0] = var_4_1[var_4_2]
				var_4_1[var_4_2] = nil

				break
			end
		end
	end

	if arg_4_2 == "AIFearExtension" then
		local var_4_3 = arg_4_0.fear_units
		local var_4_4 = #var_4_3

		for iter_4_1 = 1, var_4_4 do
			if var_4_3[iter_4_1] == arg_4_1 then
				local var_4_5 = arg_4_0.unit_extension_data[arg_4_1].panic_zone

				if var_4_5 then
					arg_4_0:deregister_panic_zone(var_4_5)
				end

				var_4_3[iter_4_1] = var_4_3[var_4_4]
				var_4_3[var_4_4] = nil

				break
			end
		end
	end

	arg_4_0.unit_extension_data[arg_4_1] = nil

	ScriptUnit.remove_extension(arg_4_1, arg_4_0.NAME)
end

function AIPanicSystem.hot_join_sync(arg_5_0, arg_5_1, arg_5_2)
	return
end

function AIPanicSystem.activate_fear(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.unit_extension_data[arg_6_1]
	local var_6_1 = POSITION_LOOKUP[arg_6_1]
	local var_6_2 = var_6_0.fear_radius

	var_6_0.panic_zone = arg_6_0:register_panic_zone(var_6_1, var_6_2)
	var_6_0.active = true
end

function AIPanicSystem.register_panic_zone(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = {
		position = Vector3Box(arg_7_1),
		radius_squared = arg_7_2 * arg_7_2,
		radius = arg_7_2
	}
	local var_7_1 = arg_7_0.panic_zones

	var_7_1[#var_7_1 + 1] = var_7_0

	return var_7_0
end

function AIPanicSystem.deregister_panic_zone(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.panic_zones
	local var_8_1 = #var_8_0

	for iter_8_0 = 1, var_8_1 do
		if var_8_0[iter_8_0] == arg_8_1 then
			var_8_0[iter_8_0] = var_8_0[var_8_1]
			var_8_0[var_8_1] = nil

			return
		end
	end

	assert("trying to deregister_panic_zone which hasnt been registered: %q", deregister_panic_zone)
end

function AIPanicSystem.set_panic_zone_position(arg_9_0, arg_9_1, arg_9_2)
	arg_9_1.position:store(arg_9_2)
end

function AIPanicSystem.inside_panic_zone(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0.panic_zones
	local var_10_1 = #var_10_0

	for iter_10_0 = 1, var_10_1 do
		repeat
			local var_10_2 = var_10_0[iter_10_0]
			local var_10_3 = var_10_2.position:unbox()

			if var_10_2.radius_squared >= Vector3.distance_squared(arg_10_1, var_10_3) then
				return var_10_2
			end
		until true
	end

	return nil
end

local var_0_2 = 1

function AIPanicSystem.update_fear_units(arg_11_0)
	local var_11_0 = arg_11_0.fear_units
	local var_11_1 = #var_11_0

	if var_11_1 < arg_11_0.current_fear_unit_index then
		arg_11_0.current_fear_unit_index = 1
	end

	local var_11_2 = arg_11_0.current_fear_unit_index
	local var_11_3 = math.min(var_11_2 + var_0_2 - 1, var_11_1)

	for iter_11_0 = var_11_2, var_11_3 do
		repeat
			local var_11_4 = var_11_0[iter_11_0]
			local var_11_5 = arg_11_0.unit_extension_data[var_11_4]

			if not var_11_5.active then
				break
			end

			local var_11_6 = var_11_5.panic_zone
			local var_11_7 = POSITION_LOOKUP[var_11_4]

			arg_11_0:set_panic_zone_position(var_11_6, var_11_7)
		until true
	end

	arg_11_0.current_fear_unit_index = var_11_3 + 1
end

local var_0_3 = 1

function AIPanicSystem.update_panic_units(arg_12_0)
	local var_12_0 = arg_12_0.panic_units
	local var_12_1 = #var_12_0

	if var_12_1 < arg_12_0.current_panic_unit_index then
		arg_12_0.current_panic_unit_index = 1
	end

	local var_12_2 = arg_12_0.current_panic_unit_index
	local var_12_3 = math.min(var_12_2 + var_0_3 - 1, var_12_1)

	for iter_12_0 = var_12_2, var_12_3 do
		local var_12_4 = var_12_0[iter_12_0]
		local var_12_5 = POSITION_LOOKUP[var_12_4]
		local var_12_6 = arg_12_0:inside_panic_zone(var_12_5)

		ScriptUnit.extension(var_12_4, "ai_system"):blackboard().panic_zone = var_12_6
	end

	arg_12_0.current_panic_unit_index = var_12_3 + 1
end

function AIPanicSystem.update(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	arg_13_0:update_fear_units()
	arg_13_0:update_panic_units()

	if script_data.ai_debug_panic_zones then
		arg_13_0:debug_draw_panic_zones()
	end
end

function AIPanicSystem.debug_draw_panic_zones(arg_14_0)
	local var_14_0 = Managers.state.debug:drawer({
		mode = "immediate",
		name = "AIPanicSystem"
	})
	local var_14_1 = arg_14_0.panic_zones
	local var_14_2 = #var_14_1

	for iter_14_0 = 1, var_14_2 do
		local var_14_3 = var_14_1[iter_14_0]
		local var_14_4 = var_14_3.radius
		local var_14_5 = var_14_3.position:unbox()

		var_14_0:sphere(var_14_5, var_14_4, Colors.get("red"))
	end
end
