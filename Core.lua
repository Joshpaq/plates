local addonTable = select(2, ...)

---
--- MARK: Parent Frame
---

local parentFrame = CreateFrame("Frame", "JPlates_ParentFrame", UIParent)
parentFrame:SetAllPoints()
parentFrame:SetIgnoreParentScale(true)
parentFrame:SetScale(addonTable.GetPixelPerfectScale())

---
--- MARK: Event Frame
---

local GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit

local nameplateIndex = 0
local nameplates = {}

local eventFrame = CreateFrame("Frame", "JPlates_EventFrame")

eventFrame:RegisterEvent("NAME_PLATE_CREATED")
local function OnNamePlateCreated(blizzardNameplate)
  print("NAME_PLATE_CREATED", blizzardNameplate, nameplateIndex)

  local nameplate = addonTable.CreateNameplate(blizzardNameplate, nameplateIndex)
  nameplates[blizzardNameplate] = nameplate

  blizzardNameplate:Hide()
  
  nameplateIndex = nameplateIndex + 1
end

eventFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
local function OnNamePlateUnitAdded(unit)
  print("NAME_PLATE_UNIT_ADDED", unit)

  local blizzardNameplate = GetNamePlateForUnit(unit)
  local nameplate = nameplates[blizzardNameplate]

  nameplate:Enable(unit)
end

eventFrame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
local function OnNamePlateUnitRemoved(unit)
  print("NAME_PLATE_UNIT_REMOVED", unit)

  local blizzardNameplate = GetNamePlateForUnit(unit)
  local nameplate = nameplates[blizzardNameplate]

  nameplate:Disable()
end

local function OnEvent(_, event, ...)
  if event == "NAME_PLATE_CREATED" then
    OnNamePlateCreated(...)
  elseif event == "NAME_PLATE_UNIT_ADDED" then
    OnNamePlateUnitAdded(...)
  elseif event == "NAME_PLATE_UNIT_REMOVED" then
    OnNamePlateUnitRemoved(...)
  else
    print("UNHANDLED EVENT", event)
  end
end

eventFrame:SetScript("OnEvent", OnEvent)





