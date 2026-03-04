-- chunkname: @scripts/unit_extensions/health/target_health_extension.lua

TargetHealthExtension = class(TargetHealthExtension)

function TargetHealthExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.unit = arg_1_2
	arg_1_0.is_server = Managers.player.is_server
	arg_1_0._dead = false
	arg_1_0._out_of_combat_timer = 0
	arg_1_0._health_regen_timer = 0
	arg_1_0._damage_per_hit = arg_1_3.damage_per_hit or 1
	arg_1_0._health = arg_1_3.health or Unit.get_data(arg_1_2, "health") or 1
	arg_1_0._max_health = arg_1_0._health
	arg_1_0._health_regen = {
		interval = 1,
		out_of_combat_only = false,
		out_of_combat_delay = 0,
		amount = 0
	}

	for iter_1_0, iter_1_1 in pairs(arg_1_3.health_regen or {}) do
		arg_1_0._health_regen[iter_1_0] = iter_1_1
	end

	arg_1_0.damage_buffers = {
		pdArray.new(),
		pdArray.new()
	}
end

function TargetHealthExtension.update(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_0._health_regen.amount
	local var_2_1 = arg_2_0._health_regen.interval

	if var_2_0 <= 0 or var_2_1 < 0 then
		return
	end

	local var_2_2 = arg_2_0._health_regen.out_of_combat_only
	local var_2_3 = arg_2_0._health_regen.out_of_combat_delay

	arg_2_0._out_of_combat_timer = math.min(arg_2_0._out_of_combat_timer + arg_2_1, var_2_3)

	if var_2_2 and var_2_3 > arg_2_0._out_of_combat_timer then
		return
	end

	if var_2_1 <= arg_2_0._health_regen_timer then
		arg_2_0:add_heal(var_2_0)

		arg_2_0._health_regen_timer = 0
	else
		arg_2_0._health_regen_timer = math.min(arg_2_0._health_regen_timer + arg_2_1, var_2_1)
	end
end

function TargetHealthExtension.add_damage(arg_3_0, ...)
	if not arg_3_0:is_dead() then
		arg_3_0._health = math.max(arg_3_0._health - arg_3_0._damage_per_hit, 0)
		arg_3_0._out_of_combat_timer = 0

		if arg_3_0:_should_die() then
			arg_3_0:set_dead()
		end
	end
end

function TargetHealthExtension.add_heal(arg_4_0, arg_4_1)
	if not arg_4_0:is_dead() then
		arg_4_0._health = math.min(arg_4_0._health + arg_4_1, arg_4_0._max_health)
	end
end

function TargetHealthExtension.is_dead(arg_5_0)
	return arg_5_0._dead
end

function TargetHealthExtension.is_alive(arg_6_0)
	return not arg_6_0._dead
end

function TargetHealthExtension.set_dead(arg_7_0)
	arg_7_0._dead = true
	arg_7_0._health = 0
	HEALTH_ALIVE[arg_7_0.unit] = nil
end

function TargetHealthExtension._should_die(arg_8_0)
	return arg_8_0._health <= 0
end

function TargetHealthExtension.current_health(arg_9_0)
	return arg_9_0._health
end

function TargetHealthExtension.current_health_percent(arg_10_0)
	return 1
end

function TargetHealthExtension.current_max_health_percent(arg_11_0)
	return 1
end

function TargetHealthExtension.get_is_invincible(arg_12_0)
	return false
end

function TargetHealthExtension.has_assist_shield(arg_13_0)
	return false
end

function TargetHealthExtension.get_damage_taken(arg_14_0)
	return arg_14_0._max_health - arg_14_0._health
end

function TargetHealthExtension.get_health_regen(arg_15_0)
	return arg_15_0._health_regen
end

function TargetHealthExtension.client_predicted_is_alive(arg_16_0)
	return not arg_16_0:is_dead()
end

function TargetHealthExtension.apply_client_predicted_damage(arg_17_0, arg_17_1)
	return
end

function TargetHealthExtension.get_max_health(arg_18_0)
	return arg_18_0._max_health
end
