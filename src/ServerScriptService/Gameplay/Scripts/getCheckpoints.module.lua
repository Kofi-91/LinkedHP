--[[
	getCheckpoints - A utility function to get all the checkpoints for a moving platform and
	ensure they are all in order.
--]]

local function getCheckpoints(platformContainer: Instance): { BasePart }
	local checkpointsFolder = platformContainer:FindFirstChild("Checkpoints")
	assert(checkpointsFolder, `No Checkpoints in {platformContainer:GetFullName()}`)

	-- Make sure all the checkpoints exist
	local checkpoints = {}
	local numCheckpoints = #checkpointsFolder:GetChildren()
	for i = 1, numCheckpoints do
		local checkpoint = checkpointsFolder:FindFirstChild(`Checkpoint{i}`)
		assert(checkpoint, `{platformContainer:GetFullName()} missing checkpoint: Checkpoint{i}`)
		table.insert(checkpoints, checkpoint)
	end

	return checkpoints
end

return getCheckpoints