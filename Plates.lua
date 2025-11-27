local addonTable = select(2, ...)

local GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit

local eventHandler = CreateFrame("Frame")

--print(768 / select(2, GetPhysicalScreenSize()))

--UIParent:SetScale(768 / select(2, GetPhysicalScreenSize()))

eventHandler:RegisterEvent("NAME_PLATE_CREATED")
local function onNamePlateCreated(frame)
  local plate = addonTable.CreateNamePlate(frame)
  frame.plate = plate
end

eventHandler:RegisterEvent("NAME_PLATE_UNIT_ADDED")
local function onNamePlateUnitAdded(unit)
  local blizzardNamePlate = GetNamePlateForUnit(unit)
  local plate = blizzardNamePlate.plate
  plate:Initialize(unit)
end

eventHandler:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
local function onNamePlatUnitRemoved(unit)
  local blizzardNamePlate = GetNamePlateForUnit(unit)
  local plate = blizzardNamePlate.plate
  plate:Deinitialize()
end

eventHandler:SetScript("OnEvent", function (self, event, ...)
  if event == "NAME_PLATE_CREATED" then
    onNamePlateCreated(...)
  elseif event == "NAME_PLATE_UNIT_ADDED" then
    onNamePlateUnitAdded(...)
  elseif event == "NAME_PLATE_UNIT_REMOVED" then
    onNamePlatUnitRemoved(...)
  end
end)