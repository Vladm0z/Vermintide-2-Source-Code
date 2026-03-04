-- chunkname: @scripts/unit_extensions/wizards/shockwave_spell_extension.lua

ShockwaveSpellExtension = class(ShockwaveSpellExtension)

ShockwaveSpellExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._unit = arg_1_2
	arg_1_0._position = Vector3Box(Unit.local_position(arg_1_2, 0))
	arg_1_0._shockwave_radius_min = Unit.get_data(arg_1_2, "wave_distance") or 2
	arg_1_0._shockwave_radius_max = Unit.get_data(arg_1_2, "wave_distance") or 30
	arg_1_0._vfx = Unit.get_data(arg_1_2, "spell_vfx") or "fx/wizard_tower_end_sofia_explosion"
	arg_1_0._spell_triggerd = false
	arg_1_0._world = arg_1_1.world
	arg_1_0._start_time = 0
	arg_1_0._time_to_broadphase = 0.15
	arg_1_0._enemy_damage = 0
	arg_1_0._players = Managers.player:players()

	Managers.state.event:register(arg_1_0, "on_failed_guardians_event", "setup_shockwave")
end

local var_0_0 = 1.5
local var_0_1 = {}
local var_0_2 = {}
local var_0_3 = 0
local var_0_4 = 0
local var_0_5 = 0
local var_0_6 = 0.25

ShockwaveSpellExtension.update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	if not arg_2_0._spell_triggerd then
		return
	end

	var_0_6 = var_0_6 + arg_2_3

	local var_2_0 = var_0_6 >= arg_2_0._time_to_broadphase
	local var_2_1 = (arg_2_5 - arg_2_0._start_time) / var_0_0
	local var_2_2 = math.clamp(var_2_1, 0, 1)
	local var_2_3 = math.lerp(arg_2_0._shockwave_radius_min, arg_2_0._shockwave_radius_max, var_2_2)
	local var_2_4 = arg_2_0._position:unbox()

	if not (var_2_2 >= 1) and var_2_0 then
		var_0_5 = AiUtils.broadphase_query(var_2_4, var_2_3, var_0_1)
		var_0_6 = 0
	end

	arg_2_0:damage_player(var_2_4, var_2_3)
	arg_2_0:damage_enemies(var_2_4, arg_2_5)

	if var_2_2 >= 1 and var_0_5 <= 0 then
		arg_2_0:reset_shockwave()
	end
end

ShockwaveSpellExtension.damage_enemies = function (arg_3_0, arg_3_1, arg_3_2)
	if var_0_5 > 0 then
		local var_3_0 = math.min(var_0_5, 3)

		for iter_3_0 = 1, var_3_0 do
			local var_3_1 = var_0_1[iter_3_0]

			if ALIVE[var_3_1] or not var_0_2[var_3_1] then
				local var_3_2 = POSITION_LOOKUP[var_3_1]
				local var_3_3 = Vector3.normalize(var_3_2 - arg_3_1)
				local var_3_4 = ScriptUnit.extension(var_3_1, "health_system")

				var_0_2[var_3_1] = true

				local var_3_5 = "torso"
				local var_3_6
				local var_3_7 = arg_3_0._unit
				local var_3_8 = "grenade"

				DamageUtils.add_damage_network(var_3_1, var_3_7, 240, var_3_5, var_3_8, var_3_2, var_3_3, var_3_6, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
			end
		end

		for iter_3_1 = var_3_0, 1, -1 do
			table.swap_delete(var_0_1, iter_3_1)
		end

		var_0_5 = #var_0_1
	end
end

ShockwaveSpellExtension.damage_player = function (arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0._players
	local var_4_1 = arg_4_2 * arg_4_2
	local var_4_2 = 1

	for iter_4_0, iter_4_1 in pairs(var_4_0) do
		local var_4_3 = iter_4_1.player_unit

		if ALIVE[var_4_3] and not var_0_2[var_4_3] then
			local var_4_4 = POSITION_LOOKUP[var_4_3]

			if var_4_1 > Vector3.distance_squared(arg_4_1, var_4_4) then
				local var_4_5 = "torso"
				local var_4_6 = "forced"
				local var_4_7 = Vector3.normalize(var_4_4 - arg_4_1)
				local var_4_8 = ScriptUnit.extension(var_4_3, "health_system")
				local var_4_9 = var_4_8:current_health() / 2

				var_4_8:add_damage(var_4_3, var_4_9, var_4_5, var_4_6, var_4_4, var_4_7, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, var_4_2)

				var_0_2[var_4_3] = true

				local var_4_10 = 10
				local var_4_11 = (var_4_7 + Vector3.up() * 3) * var_4_10

				ScriptUnit.extension(var_4_3, "locomotion_system"):add_external_velocity(var_4_11)

				var_4_2 = var_4_2 + 1
			end
		end
	end
end

ShockwaveSpellExtension.setup_shockwave = function (arg_5_0, arg_5_1)
	arg_5_0._enemy_damage = arg_5_1.enemy_damage
	arg_5_0._start_time = Managers.time:time("game")
	arg_5_0._spell_triggerd = true

	World.create_particles(arg_5_0._world, arg_5_0._vfx, arg_5_0._position:unbox())
end

ShockwaveSpellExtension.reset_shockwave = function (arg_6_0)
	arg_6_0._spell_triggerd = false

	table.clear(var_0_2)
end

ShockwaveSpellExtension.destroy = function (arg_7_0)
	Managers.state.event:unregister("on_failed_guardians_event", arg_7_0)
end
