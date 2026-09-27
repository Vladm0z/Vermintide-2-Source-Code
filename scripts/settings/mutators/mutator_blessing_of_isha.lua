-- chunkname: @scripts/settings/mutators/mutator_blessing_of_isha.lua

require("scripts/settings/dlcs/morris/deus_blessing_settings")

local num = 5
local str = "blessing_of_isha_stagger"
local tbl = {
	player_resurrected = "Play_blessing_of_isha_activate"
}
local tbl_2 = {
	pack_master_grab = true,
	assassin_pounced = true,
	corruptor_grab = true
}

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	arg_1_3 = arg_1_3 or POSITION_LOOKUP[arg_1_1]

	local main_world = Application.main_world()
	local identity = Quaternion.identity()
	local has_extension = ScriptUnit.has_extension(arg_1_1, "career_system")
	local flag = not has_extension and has_extension:get_career_power_level()
	local get_template = ExplosionUtils.get_template(arg_1_2)

	get_template.explosion.radius = arg_1_0

	DamageUtils.create_explosion(main_world, arg_1_1, arg_1_3, identity, get_template, 1, "buff", true, false, arg_1_1, flag, false)
end

local function fn_2(arg_2_0)
	-- function 2
	local get_deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()

	if not get_deus_run_controller then
		get_deus_run_controller:remove_blessing(arg_2_0)
	end

	local game_mode = Managers.state.game_mode

	if not game_mode:has_activated_mutator(arg_2_0) then
		game_mode:deactivate_mutator(arg_2_0)
	end
end

local function fn_3(arg_3_0)
	-- function 3
	for k, v in pairs(arg_3_0) do
		local has_extension = ScriptUnit.has_extension(k, "buff_system")

		if not has_extension then
			has_extension:remove_buff(v)
		end
	end

	table.clear(arg_3_0)
end

local function fn_4(arg_4_0)
	-- function 4
	local has_extension = ScriptUnit.has_extension(arg_4_0, "status_system")

	if not has_extension then
		has_extension:healed("healing_draught")
	end
end

local function fn_5(arg_5_0, arg_5_1)
	-- function 5
	for i, v in ipairs(arg_5_0) do
		local var_5_0 = ALIVE[v]

		var_5_0 = not var_5_0 and ScriptUnit.has_extension(v, "status_system")

		if not var_5_0 then
			local is_dead = var_5_0:is_dead()
			local is_knocked_down = var_5_0:is_knocked_down()
			local is_grabbed_by_corruptor = var_5_0:is_grabbed_by_corruptor()
			local is_grabbed_by_pack_master = var_5_0:is_grabbed_by_pack_master()
			local is_pounced_down = var_5_0:is_pounced_down()

			if not (is_dead or is_knocked_down or is_grabbed_by_corruptor or is_grabbed_by_pack_master or is_pounced_down) then
				table.insert(arg_5_1, v)
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
		-- function 6
		arg_6_1.hero_side = Managers.state.side:get_side_from_name("heroes")
		arg_6_1.buff_ids = {}
	end,
	try_activate_blessing = function (arg_7_0, arg_7_1, arg_7_2)
		-- function 7
		if not ALIVE[arg_7_2] then
			fn(num, arg_7_2, str)
			fn_3(arg_7_1.buff_ids)
			fn_4(arg_7_2)
			ScriptUnit.extension(arg_7_2, "health_system"):reset()

			local extension_input = ScriptUnit.extension_input(arg_7_2, "dialogue_system")
			local alloc_table = FrameTable.alloc_table()

			extension_input:trigger_networked_dialogue_event("blessing_isha_resurrected", alloc_table)
			Managers.state.entity:system("audio_system"):play_2d_audio_event(tbl.player_resurrected)
			fn_2("blessing_of_isha")

			local player = Managers.player
			local owner = player:owner(arg_7_2)
			local flag = owner == player:local_player()
			local str_2 = "collected_isha_reward"

			Managers.state.event:trigger("add_coop_feedback", owner:stats_id(), flag, str_2, owner, owner)
			Managers.state.network.network_transmit:send_rpc_clients("rpc_coop_feedback", owner:network_id(), owner:local_player_id(), NetworkLookup.coop_feedback[str_2], owner:network_id(), owner:local_player_id())

			return true
		end

		return false
	end,
	server_player_disabled_function = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
		-- function 8
		if arg_8_3 ~= arg_8_1.blessed_unit then
			return
		end

		if not tbl_2[arg_8_2] then
			return
		end

		if not arg_8_1.hero_side then
			return
		end

		if not (not arg_8_1.template.try_activate_blessing(arg_8_0, arg_8_1, arg_8_3) and arg_8_2 ~= "corruptor_grab") then
			local var_8_0 = POSITION_LOOKUP[arg_8_4]
			local num = 1

			fn(num, arg_8_3, str, var_8_0)
		end
	end,
	server_player_hit_function = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
		-- function 9
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
		-- function 10
		if not arg_10_1.hero_side then
			return
		end

		local temp_not_disabled_units = arg_10_1.template.temp_not_disabled_units

		table.clear(temp_not_disabled_units)
		fn_5(arg_10_1.hero_side.PLAYER_AND_BOT_UNITS, temp_not_disabled_units)

		if #temp_not_disabled_units == 1 then
			local var_10_1 = temp_not_disabled_units[1]

			if arg_10_1.blessed_unit ~= var_10_1 then
				fn_3(arg_10_1.buff_ids)
			end

			local extension = ScriptUnit.extension(var_10_1, "buff_system")

			if not extension:has_buff_type("blessing_of_isha_invincibility") then
				local add_buff = extension:add_buff("blessing_of_isha_invincibility")

				arg_10_1.buff_ids[var_10_1] = add_buff
			end

			arg_10_1.buff_active = true
			arg_10_1.blessed_unit = var_10_1
		else
			fn_3(arg_10_1.buff_ids)

			arg_10_1.buff_active = false
			arg_10_1.blessed_unit = nil
		end
	end
}
