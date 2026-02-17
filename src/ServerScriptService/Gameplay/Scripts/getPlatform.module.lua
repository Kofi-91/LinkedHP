--[[
	getPlatform - A utility function to get the main platform being used for a moving platform.
--]]

local function getPlatform(platformContainer: Instance): BasePart
	local platform = platformContainer:FindFirstChild("Platform")
	assert(platform, `No Platform in {platformContainer:GetFullName()}`)

	return platform
end

return getPlatform