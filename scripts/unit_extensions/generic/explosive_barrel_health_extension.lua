-- chunkname: @scripts/unit_extensions/generic/explosive_barrel_health_extension.lua

ExplosiveBarrelHealthExtension = class(ExplosiveBarrelHealthExtension, GenericHealthExtension)

function ExplosiveBarrelHealthExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	ExplosiveBarrelHealthExtension.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)

	arg_1_0.in_hand = arg_1_3.in_hand
	arg_1_0.item_name = arg_1_3.item_name

	local var_1_0 = arg_1_3.health_data

	if var_1_0 then
		arg_1_0.ignited = true
		arg_1_0.explode_time = var_1_0.explode_time
		arg_1_0.fuse_time = var_1_0.fuse_time
		arg_1_0.last_damage_data.attacker_unit_id = var_1_0.attacker_unit_id
		arg_1_0.insta_explode = not arg_1_0.in_hand

		Unit.flow_event(arg_1_2, "exploding_barrel_fuse_init")
	end

	local var_1_1 = arg_1_3.owner_unit

	if var_1_1 then
		arg_1_0.owner_unit = var_1_1
		arg_1_0.owner_unit_health_extension = ScriptUnit.extension(var_1_1, "health_system")
		arg_1_0.ignored_damage_types = arg_1_3.ignored_damage_types
	end
end

function ExplosiveBarrelHealthExtension.update(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0.owner_unit_health_extension

	if var_2_0 then
		local var_2_1, var_2_2 = var_2_0:recent_damages()

		for iter_2_0 = 1, var_2_2 / DamageDataIndex.STRIDE do
			local var_2_3 = (iter_2_0 - 1) * DamageDataIndex.STRIDE
			local var_2_4 = var_2_1[var_2_3 + DamageDataIndex.ATTACKER]
			local var_2_5 = var_2_1[var_2_3 + DamageDataIndex.DAMAGE_AMOUNT]
			local var_2_6 = var_2_1[var_2_3 + DamageDataIndex.DAMAGE_TYPE]
			local var_2_7 = var_2_1[var_2_3 + DamageDataIndex.SOURCE_ATTACKER_UNIT]

			if not arg_2_0.ignored_damage_types[var_2_6] then
				if var_2_6 == "heal" then
					arg_2_0:add_heal(var_2_4, -var_2_5, nil, "n/a")
				else
					local var_2_8 = var_2_1[var_2_3 + DamageDataIndex.HIT_ZONE]
					local var_2_9 = Vector3Aux.unbox(var_2_1[var_2_3 + DamageDataIndex.POSITION])
					local var_2_10 = Vector3Aux.unbox(var_2_1[var_2_3 + DamageDataIndex.DIRECTION])
					local var_2_11 = var_2_1[var_2_3 + DamageDataIndex.DAMAGE_SOURCE_NAME]

					arg_2_0:add_damage(var_2_4, var_2_5, var_2_8, var_2_6, var_2_9, var_2_10, var_2_11, nil, var_2_7, nil, nil, nil, nil, nil, nil, nil, iter_2_0)
				end
			end
		end
	end

	if arg_2_0.ignited and not arg_2_0._dead and not arg_2_0.exploded then
		local var_2_12 = Managers.state.network:network_time()
		local var_2_13 = (arg_2_0.explode_time - var_2_12) / arg_2_0.fuse_time

		Unit.set_data(arg_2_0.unit, "fuse_time_percent", var_2_13)

		if var_2_12 >= arg_2_0.explode_time then
			arg_2_0.insta_explode = true

			arg_2_0:add_damage(arg_2_0.unit, arg_2_0.health, "full", "undefined", Unit.world_position(arg_2_0.unit, 0), Vector3(0, 0, -1), nil, nil, arg_2_0.last_attacker_unit, nil, nil, nil, nil, nil, nil, nil, 1)
		elseif not arg_2_0.in_hand and not arg_2_0.insta_explode and var_2_12 >= arg_2_0.insta_explode_time then
			arg_2_0.insta_explode = true
		elseif not arg_2_0.played_fuse_out and var_2_12 >= arg_2_0.explode_time - 1.2 then
			Unit.flow_event(arg_2_0.unit, "exploding_barrel_fuse_out")

			arg_2_0.played_fuse_out = true
		end
	end
end

function ExplosiveBarrelHealthExtension.apply_client_predicted_damage(arg_3_0, arg_3_1)
	return
end

function ExplosiveBarrelHealthExtension.add_damage(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7, arg_4_8, arg_4_9, arg_4_10, arg_4_11, arg_4_12, arg_4_13, arg_4_14, arg_4_15, arg_4_16, arg_4_17)
	if arg_4_4 and (arg_4_4 == "blade_storm" or arg_4_4 == "life_tap") then
		return
	end

	arg_4_0.last_attacker_unit = arg_4_1

	local var_4_0 = arg_4_2 > 0
	local var_4_1 = arg_4_0.unit
	local var_4_2, var_4_3 = Managers.state.network:game_object_or_level_id(var_4_1)
	local var_4_4 = arg_4_0:_add_to_damage_history_buffer(var_4_1, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7, arg_4_8, arg_4_9, arg_4_10, arg_4_11, nil, nil, nil, nil, arg_4_17)

	StatisticsUtil.register_damage(var_4_1, var_4_4, arg_4_0.statistics_db)
	fassert(arg_4_4, "No damage_type!")

	arg_4_0._recent_damage_type = arg_4_4
	arg_4_0._recent_hit_react_type = arg_4_10

	arg_4_0:save_kill_feed_data(arg_4_1, var_4_4, arg_4_3, arg_4_4, arg_4_7, arg_4_9)
	DamageUtils.handle_hit_indication(arg_4_1, var_4_1, arg_4_2, arg_4_3, arg_4_12)

	if not arg_4_0:get_is_invincible() and not arg_4_0.dead then
		local var_4_5 = var_4_0 and arg_4_0.insta_explode and arg_4_0.health or 0

		arg_4_0.damage = arg_4_0.damage + var_4_5

		if arg_4_0:_should_die() and (arg_4_0.is_server or not var_4_2) then
			Managers.state.entity:system("death_system"):kill_unit(var_4_1, var_4_4)
		end
	end

	arg_4_0:_sync_out_damage(arg_4_1, var_4_2, var_4_3, arg_4_9, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7, arg_4_8, arg_4_10, arg_4_11, arg_4_12, arg_4_13, arg_4_14, arg_4_15, arg_4_16, arg_4_17)

	if var_4_0 and not arg_4_0.ignited then
		local var_4_6 = Managers.state.network:network_time()
		local var_4_7 = Unit.has_data(var_4_1, "fuse_time") and Unit.get_data(var_4_1, "fuse_time") or 4
		local var_4_8 = var_4_6 + 0.2
		local var_4_9 = var_4_6 + var_4_7

		Unit.flow_event(var_4_1, "exploding_barrel_fuse_init")

		arg_4_0.fuse_time = var_4_7
		arg_4_0.explode_time = var_4_9
		arg_4_0.ignited = true
		arg_4_0.insta_explode_time = var_4_8
	elseif var_4_0 and arg_4_0.ignited and arg_4_0.insta_explode and not arg_4_0.exploded then
		arg_4_0.exploded = true

		if arg_4_0.ignited and not arg_4_0.played_fuse_out then
			Unit.flow_event(arg_4_0.unit, "exploding_barrel_remove_fuse")
		end
	end
end

function ExplosiveBarrelHealthExtension.health_data(arg_5_0)
	local var_5_0 = arg_5_0.last_damage_data

	return {
		fuse_time = arg_5_0.fuse_time,
		explode_time = arg_5_0.explode_time,
		attacker_unit_id = var_5_0.attacker_unit_id
	}
end
