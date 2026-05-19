-- chunkname: @scripts/helpers/camera_carrier.lua

CameraCarrier = class(CameraCarrier)
CameraCarrier.CAMERA_CARRIER_REEVALUATE_PERIOD = 10

function CameraCarrier.init(arg_1_0)
	arg_1_0._carrier_camera_unit = nil
	arg_1_0._camera_carrier_unique_id = nil
	arg_1_0._camera_carrier_linked = false
	arg_1_0._time_since_reevaluate_camera_carrier = 0
end

function CameraCarrier.destroy(arg_2_0)
	if arg_2_0._carrier_camera_unit ~= nil then
		arg_2_0:_detach_carrier_camera()
		arg_2_0:_destroy_carrier_camera()
	end
end

function CameraCarrier.update(arg_3_0, arg_3_1)
	if not DEDICATED_SERVER then
		return
	end

	arg_3_0._time_since_reevaluate_camera_carrier = arg_3_0._time_since_reevaluate_camera_carrier + arg_3_1

	if arg_3_0._time_since_reevaluate_camera_carrier > CameraCarrier.CAMERA_CARRIER_REEVALUATE_PERIOD then
		arg_3_0:_reevaluate_camera_carrier()
	end
end

function CameraCarrier._reevaluate_camera_carrier(arg_4_0)
	arg_4_0._time_since_reevaluate_camera_carrier = 0

	if not DEDICATED_SERVER then
		return
	end

	local var_4_0 = arg_4_0:_best_suited_camera_carrier()

	if arg_4_0._camera_carrier_linked then
		if Managers.player:player_from_unique_id(arg_4_0._camera_carrier_unique_id) == var_4_0 then
			return
		end

		arg_4_0:_detach_carrier_camera()
	end

	if var_4_0 == nil then
		return
	end

	print(string.format("Switching camera carrier to %s", var_4_0:name()))
	arg_4_0:_attach_carrier_camera(var_4_0)
end

function CameraCarrier._create_carrier_camera(arg_5_0)
	assert(arg_5_0._carrier_camera_unit == nil)
	assert(DEDICATED_SERVER)

	local var_5_0 = DefaultUnits.standard.backlit_camera
	local var_5_1 = Vector3.zero()
	local var_5_2 = Quaternion.identity()

	arg_5_0._carrier_camera_unit = Managers.state.unit_spawner:spawn_local_unit(var_5_0, var_5_1, var_5_2)
end

function CameraCarrier._destroy_carrier_camera(arg_6_0)
	assert(arg_6_0._carrier_camera_unit ~= nil)
	assert(DEDICATED_SERVER)
	Managers.state.unit_spawner:mark_for_deletion(arg_6_0._carrier_camera_unit)

	arg_6_0._carrier_camera_unit = nil
	arg_6_0._camera_carrier_unique_id = nil
end

function CameraCarrier._attach_carrier_camera(arg_7_0, arg_7_1)
	assert(DEDICATED_SERVER)
	assert(arg_7_1 ~= nil)

	if arg_7_1.player_unit == nil then
		print(string.format("Failed to switching camera carrier to %s since there is no unit", arg_7_1:name()))

		return
	end

	if not Unit.alive(arg_7_1.player_unit) then
		print(string.format("Failed to switching camera carrier to %s since the player unit is not alive", arg_7_1:name()))

		return
	end

	if arg_7_0._carrier_camera_unit == nil then
		arg_7_0:_create_carrier_camera()
	end

	local var_7_0 = Unit.world(arg_7_1.player_unit)

	World.link_unit(var_7_0, arg_7_0._carrier_camera_unit, arg_7_1.player_unit)

	arg_7_0._camera_carrier_unique_id = arg_7_1:profile_id()
	arg_7_0._camera_carrier_linked = true
end

function CameraCarrier._detach_carrier_camera(arg_8_0)
	assert(DEDICATED_SERVER)
	assert(arg_8_0._carrier_camera_unit ~= nil)

	if not arg_8_0._camera_carrier_linked then
		return
	end

	local var_8_0 = Unit.world(arg_8_0._carrier_camera_unit)

	World.unlink_unit(var_8_0, arg_8_0._carrier_camera_unit)

	arg_8_0._camera_carrier_linked = false
end

function CameraCarrier._most_ahead_player(arg_9_0)
	local var_9_0 = Managers.state.conflict

	if var_9_0 == nil then
		return nil
	end

	local var_9_1 = var_9_0.main_path_info.ahead_unit

	return Managers.player:unit_owner(var_9_1)
end

function CameraCarrier._best_suited_camera_carrier(arg_10_0)
	local var_10_0 = arg_10_0:_most_ahead_player()

	if var_10_0 ~= nil then
		return var_10_0
	end

	local var_10_1 = Managers.party:leader()
	local var_10_2 = Managers.player:players_at_peer(var_10_1)

	if var_10_2 == nil then
		return nil
	end

	return var_10_2[1]
end
