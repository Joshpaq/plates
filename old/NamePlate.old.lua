local addonTable = select(2, ...)


local CreateFrame = CreateFrame
local GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit
local Mixin = Mixin

--
-- MIXIN
--

local PlateMixin = {}

-- called on NAME_PLATE_UNIT_ADDED
function PlateMixin:Initialize(unit)
  local blizzardNameplate = GetNamePlateForUnit(unit)

  if blizzardNameplate then 
    self.healthBar:Initialize(unit)
    self.healthBarBorder:Initialize(unit)
    self.unitNameText:Initialize(unit)

    self:Show()
    blizzardNameplate.UnitFrame:Hide()
  end
end

-- called on NAME_PLATE_UNIT_REMOVED
function PlateMixin:Deinitialize()
  self:Hide()

  self.healthBar:Deinitialize()
  self.unitNameText:Deinitialize()
end

--
-- CREATE
--

local globalFrameLevel = 1

function addonTable.CreateNamePlate(parent)
  local plate = CreateFrame("Frame")

  local frameLevel = globalFrameLevel
  plate:SetFrameLevel(frameLevel)
  globalFrameLevel = globalFrameLevel + 10

  --plate:SetParent(parent)
  plate:SetIgnoreParentScale(true)
  plate:EnableMouse(false)
  plate:Show()

  --plate:SetParent(parent) -- TODO: either make it's parent the blizz frame or use SetPOint("Center", blizzFrame)
  plate:SetPoint("CENTER", parent)

  PixelUtil.SetWidth(plate, 150, 1)
  PixelUtil.SetHeight(plate, 20, 1)


  local healthBar = addonTable.CreateHealthBar(plate)
  healthBar:SetFrameLevel(frameLevel + 1)
  plate.healthBar = healthBar

  local healthBarBorder = addonTable.CreateHealthBarBorder(plate)
  healthBar:SetFrameLevel(frameLevel + 2)
  plate.healthBarBorder = healthBarBorder

  local unitNameText = addonTable.CreateUnitNameText(plate)
  unitNameText:SetFrameLevel(frameLevel + 3)
  plate.unitNameText = unitNameText

  Mixin(plate, PlateMixin)

  return plate
end