local addonTable = select(2, ...)

local GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit
local Scale = addonTable.Scale

local NamplateMixin = {}

function NamplateMixin:Enable(unit)
  self.unit = unit

  local blizzardNameplate = GetNamePlateForUnit(unit)
  blizzardNameplate.UnitFrame:Hide()

  self:SetPoint("CENTER", blizzardNameplate)
  self:Show()

  self.healthBar:Enable(unit)
  self.nameText:Enable(unit)
end

function NamplateMixin:Disable()
  self.unit = nil

  self:Hide()

  self.healthBar:Disable()
  self.nameText:Disable()
end

local function getFrameLevelFromIndex(index)
  return 1 + 10 * index
end

function addonTable.CreateNameplate(parent, index)
  local nameplate = CreateFrame("Frame", "JPlates_Nameplate_" .. index, parent)
  nameplate:SetFrameLevel(getFrameLevelFromIndex(index))

  nameplate:SetWidth(Scale(150))
  nameplate:SetHeight(Scale(20))

  local healthBar = addonTable.CreateHealthBar(nameplate)
  nameplate.healthBar = healthBar

  local nameText = addonTable.CreateNameText(nameplate)
  nameplate.nameText = nameText

  Mixin(nameplate, NamplateMixin)

  return nameplate
end

