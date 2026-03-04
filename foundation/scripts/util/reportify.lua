-- chunkname: @foundation/scripts/util/reportify.lua

Reportify = Reportify or {}

Reportify.setup = function (arg_1_0)
	arg_1_0.has_setup = true
	arg_1_0.content_revision = script_data.settings.content_revision or ""
	arg_1_0.engine_revision = Application.build_identifier() or ""
	arg_1_0.project = "HON"
end

Reportify.get_data = function (arg_2_0)
	if not arg_2_0.has_setup then
		arg_2_0:setup()
	end

	local var_2_0, var_2_1 = arg_2_0:_get_location()
	local var_2_2 = arg_2_0:_get_player_info()

	Application.console_send({
		type = "reportify",
		project = arg_2_0.project,
		fields = {
			customfield_10031 = arg_2_0.content_revision,
			customfield_10032 = arg_2_0.engine_revision
		},
		custom = {
			level = arg_2_0:_get_level(),
			position = var_2_0,
			rotation = var_2_1,
			archetype = var_2_2.class_name,
			wielded_slot = var_2_2.wielded_slot,
			primary_slot = var_2_2.primary_name,
			secondary_slot = var_2_2.secondary_name
		}
	})
end

Reportify._get_level = function (arg_3_0)
	if not Managers.state.game_mode then
		return ""
	end

	return Managers.state.game_mode:level_key() or ""
end

Reportify._get_location = function (arg_4_0)
	local var_4_0 = arg_4_0:_get_local_player()

	if not var_4_0 or not Managers.state.camera then
		return ""
	end

	return tostring(Managers.state.camera:camera_position(var_4_0.viewport_name)), tostring(Managers.state.camera:camera_rotation(var_4_0.viewport_name))
end

Reportify._get_player_info = function (arg_5_0)
	local var_5_0 = {
		wielded_slot = "",
		primary_name = "",
		class_name = "",
		secondary_name = ""
	}
	local var_5_1 = arg_5_0:_get_local_player()

	if not var_5_1 then
		return var_5_0
	end

	local var_5_2 = var_5_1:profile_index()
	local var_5_3 = SPProfiles[var_5_2]

	if var_5_3 then
		var_5_0.class_name = var_5_3.display_name
	end

	local var_5_4 = ScriptUnit.has_extension(var_5_1.player_unit, "inventory_system")

	if var_5_4 then
		var_5_0.wielded_slot = var_5_4:get_wielded_slot_name() or ""
		var_5_0.primary_name = var_5_4:get_item_name("slot_melee") or ""
		var_5_0.secondary_name = var_5_4:get_item_name("slot_ranged") or ""
	end

	return var_5_0
end

Reportify._get_local_player = function (arg_6_0)
	if not Managers.player then
		return false
	end

	if Managers.player:num_players() == 0 then
		return false
	end

	return Managers.player:local_player(1)
end
