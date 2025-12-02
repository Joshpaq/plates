local addonTable = select(2, ...)

local GetNearestPixelSize = PixelUtil.GetNearestPixelSize
local GetPhysicalScreenSize = GetPhysicalScreenSize

local _, vertical = GetPhysicalScreenSize()
local pixelPerfectScale
if vertical then
  pixelPerfectScale = 768 / vertical
else
  pixelPerfectScale = 1
end

function addonTable.GetPixelPerfectScale()
  return pixelPerfectScale
end

function addonTable.Scale(desiredPixels)
  return GetNearestPixelSize(desiredPixels, pixelPerfectScale)
end


