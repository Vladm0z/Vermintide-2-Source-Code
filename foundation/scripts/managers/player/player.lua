-- chunkname: @foundation/scripts/managers/player/player.lua

Player = class(Player)
Player._allowed_transitions = {
	despawned = {
		spawned = true
	},
	queued_for_despawn = {
		despawned = true
	},
	spawned = {
		queued_for_despawn = true,
		despawned = true
	}
}

function Player.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	arg_1_0.network_manager = arg_1_1
	arg_1_0.input_source = arg_1_2
	arg_1_0.viewport_name = arg_1_3
	arg_1_0.viewport_world_name = arg_1_4
	arg_1_0.owned_units = {}
	arg_1_0.is_server = arg_1_5
	arg_1_0.camera_follow_unit = nil
	arg_1_0._spawn_state = "despawned"
end

function Player.destroy(arg_2_0)
	arg_2_0.network_manager = nil
end

function Player.set_camera_follow_unit(arg_3_0, arg_3_1)
	arg_3_0.camera_follow_unit = arg_3_1
end

function Player.needs_despawn(arg_4_0)
	return arg_4_0._spawn_state == "spawned"
end

function Player.mark_as_queued_for_despawn(arg_5_0)
	arg_5_0:_set_spawn_state("queued_for_despawn")
end

function Player._set_spawn_state(arg_6_0, arg_6_1)
	fassert(arg_6_1 == "spawned" or arg_6_1 == "queued_for_despawn" or arg_6_1 == "despawned", "Invalid spawn state %s", arg_6_1)
	fassert(Player._allowed_transitions[arg_6_0._spawn_state][arg_6_1], "Spawn state transition from %s to %s is not allowed", arg_6_0._spawn_state, arg_6_1)

	arg_6_0._spawn_state = arg_6_1
end

function Player.spawn_state(arg_7_0)
	return arg_7_0._spawn_state
end
