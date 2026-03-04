-- chunkname: @scripts/settings/mutators/mutator_blessing_of_isha.lua

require("scripts/settings/dlcs/morris/deus_blessing_settings")

local var_0_0 = 5
local var_0_1 = "blessing_of_isha_stagger"
local var_0_2 = {
	player_resurrected = "Play_blessing_of_isha_activate"
}
local var_0_3 = {
	pack_master_grab = true,
	assassin_pounced = true,
	corruptor_grab = true
}

local function var_0_4(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_3 = arg_1_3 or POSITION_LOOKUP[arg_1_1]

	local var_1_0 = Application.main_world()
	local var_1_1 = Quaternion.identity()
	local var_1_2 = ScriptUnit.has_extension(arg_1_1, "career_system")
	local var_1_3 = var_1_2 and var_1_2:get_career_power_level()
	local var_1_4 = ExplosionUtils.get_template(arg_1_2)

	var_1_4.explosion.radius = arg_1_0

	DamageUtils.create_explosion(var_1_0, arg_1_1, arg_1_3, var_1_1, var_1_4, 1, "buff", true, false, arg_1_1, var_1_3, false)
end

local function var_0_5(arg_2_0)
	local var_2_0 = Managers.mechanism:game_mechanism():get_deus_run_controller()

	if var_2_0 then
		var_2_0:remove_blessing(arg_2_0)
	end

	local var_2_1 = Managers.state.game_mode

	if var_2_1:has_activated_mutator(arg_2_0) then
		var_2_1:deactivate_mutator(arg_2_0)
	end
end

local function var_0_6(arg_3_0)
	for iter_3_0, iter_3_1 in pairs(arg_3_0) do
		local var_3_0 = ScriptUnit.has_extension(iter_3_0, "buff_system")

		if var_3_0 then
			var_3_0:remove_buff(iter_3_1)
		end
	end

	table.clear(arg_3_0)
end

local function var_0_7(arg_4_0)
	local var_4_0 = ScriptUnit.has_extension(arg_4_0, "status_system")

	if var_4_0 then
		var_4_0:healed("healing_draught")
	end
end

local function var_0_8(arg_5_0, arg_5_1)
	for iter_5_0, iter_5_1 in ipairs(arg_5_0) do
		local var_5_0 = ALIVE[iter_5_1] and ScriptUnit.has_extension(iter_5_1, "status_system")

		if var_5_0 then
			local var_5_1 = var_5_0:is_dead()
			local var_5_2 = var_5_0:is_knocked_down()
			local var_5_3 = var_5_0:is_grabbed_by_corruptor()
			local var_5_4 = var_5_0:is_grabbed_by_pack_master()
			local var_5_5 = var_5_0:is_pounced_down()

			if not var_5_1 and not var_5_2 and not var_5_3 and not var_5_4 and not var_5_5 then
				table.insert(arg_5_1, iter_5_1)
			end
		end
	end
end

return {
	display_name = DeusBlessingSettings.blessing_of_isha.display_name,
	description = DeusBlessingSettings.blessing_of_isha.description,
	icon = DeusBlessingSettings.blessing_of_isha.icon,
	temp_not_disabled_units = {},
	server_start_function = function (arg_6_0, arg_6_1, arg_6_2)
		arg_6_1.hero_side = Managers.state.side:get_side_from_name("heroes")
		arg_6_1.buff_ids = {}
	end,
	try_activate_blessing = function (arg_7_0, arg_7_1, arg_7_2)
		if ALIVE[arg_7_2] then
			var_0_4(var_0_0, arg_7_2, var_0_1)
			var_0_6(arg_7_1.buff_ids)
			var_0_7(arg_7_2)
			ScriptUnit.extension(arg_7_2, "health_system"):reset()

			local var_7_0 = ScriptUnit.extension_input(arg_7_2, "dialogue_system")
			local var_7_1 = FrameTable.alloc_table()

			var_7_0:trigger_networked_dialogue_event("blessing_isha_resurrected", var_7_1)
			Managers.state.entity:system("audio_system"):play_2d_audio_event(var_0_2.player_resurrected)
			var_0_5("blessing_of_isha")

			local var_7_2 = Managers.player
			local var_7_3 = var_7_2:owner(arg_7_2)
			local var_7_4 = var_7_3 == var_7_2:local_player()
			local var_7_5 = "collected_isha_reward"

			Managers.state.event:trigger("add_coop_feedback", var_7_3:stats_id(), var_7_4, var_7_5, var_7_3, var_7_3)
			Managers.state.network.network_transmit:send_rpc_clients("rpc_coop_feedback", var_7_3:network_id(), var_7_3:local_player_id(), NetworkLookup.coop_feedback[var_7_5], var_7_3:network_id(), var_7_3:local_player_id())

			return true
		end

		return false
	end,
	server_player_disabled_function = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
		if arg_8_3 ~= arg_8_1.blessed_unit then
			return
		end

		if not var_0_3[arg_8_2] then
			return
		end

		if not arg_8_1.hero_side then
			return
		end

		if arg_8_1.template.try_activate_blessing(arg_8_0, arg_8_1, arg_8_3) and arg_8_2 == "corruptor_grab" then
			local var_8_0 = POSITION_LOOKUP[arg_8_4]
			local var_8_1 = 1

			var_0_4(var_8_1, arg_8_3, var_0_1, var_8_0)
		end
	end,
	server_player_hit_function = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
		if arg_9_2 ~= arg_9_1.blessed_unit then
			return
		end

		if not arg_9_1.hero_side then
			return
		end

		if ScriptUnit.extension(arg_9_2, "health_system"):current_health() == 1 then
			arg_9_1.template.try_activate_blessing(arg_9_0, arg_9_1, arg_9_2)
		end
	end,
	server_update_function = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
		if not arg_10_1.hero_side then
			return
		end

		local var_10_0 = arg_10_1.template.temp_not_disabled_units

		table.clear(var_10_0)
		var_0_8(arg_10_1.hero_side.PLAYER_AND_BOT_UNITS, var_10_0)

		if #var_10_0 == 1 then
			local var_10_1 = var_10_0[1]

			if arg_10_1.blessed_unit ~= var_10_1 then
				var_0_6(arg_10_1.buff_ids)
			end

			local var_10_2 = ScriptUnit.extension(var_10_1, "buff_system")

			if not var_10_2:has_buff_type("blessing_of_isha_invincibility") then
				local var_10_3 = var_10_2:add_buff("blessing_of_isha_invincibility")

				arg_10_1.buff_ids[var_10_1] = var_10_3
			end

			arg_10_1.buff_active = true
			arg_10_1.blessed_unit = var_10_1
		else
			var_0_6(arg_10_1.buff_ids)

			arg_10_1.buff_active = false
			arg_10_1.blessed_unit = nil
		end
	end
}
