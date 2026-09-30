-- chunkname: @scripts/settings/dlcs/morris/deus_default_graph_settings.lua

DeusDefaultGraphs = DeusDefaultGraphs
DeusDebugShrineNodeGraph = DeusDebugShrineNodeGraph
DeusDebugSpecificNodeGraph = DeusDebugSpecificNodeGraph

for seed, graph in pairs(DeusDefaultGraphs) do
	for id, node_data in pairs(graph) do
		node_data.key = id
	end
end
