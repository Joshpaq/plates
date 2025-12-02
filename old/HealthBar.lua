local addonTable = select(2, ...)

local CreateFrame = CreateFrame
local Mixin = Mixin
local print = print
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax

----------------------------------------------------------------------
-- MARK: MIXIN
----------------------------------------------------------------------

local HealthBarMixin = {}

function HealthBarMixin:UpdateHealth()
  print(self.unit .. ".HealthBar.UpdateHealth")
  self:SetValue(UnitHealth(self.unit))
end

function HealthBarMixin:UpdateMaxHealth()
  print(self.unit .. ".HealthBar.UpdateMaxHealth")
  self:SetMinMaxValues(0, UnitHealthMax(self.unit))
end

function HealthBarMixin:UpdateShield()
  print(self.unit .. ".HealthBar.UpdateShield")

  local totalAbsorbs = UnitGetTotalAbsorbs(self.unit)
  local shieldPercent = 20--totalAbsorbs / UnitHealthMax(unit)
  local healthPercent = 100 --UnitHealth(unit) / UnitHealthMax(unit)

  self.shield:SetWidth(40)-- :SetValue(shieldPercent, healthPercent)

  if totalAbsorbs > 0 then
    print("HAS ABSORBS")
  end

end

function HealthBarMixin:OnEvent(event)
  print(self.unit .. "HealthBar.OnEvent")

  if event == "UNIT_HEALTH" then
    self:UpdateHealth()
  elseif event == "UNIT_MAXHEALTH" then
    self:UpdateMaxHealth()
  elseif event == "UNIT_ABSORB_AMOUNT_CHANGED" then
    self:UpdateShield()
  else 
    print("Unhandled HealthBar Event", self.unit, event)
  end
end

function HealthBarMixin:Initialize(unit)
  self.unit = unit

  self:RegisterUnitEvent("UNIT_HEALTH", self.unit)
  self:RegisterUnitEvent("UNIT_MAXHEALTH", self.unit)
  self:RegisterUnitEvent("UNIT_ABSORB_AMOUNT_CHANGED", self.unit)

  self:UpdateMaxHealth()
  self:UpdateHealth()
  self:UpdateShield()
end

function HealthBarMixin:Deinitialize()
  self:UnregisterAllEvents()

  self:SetMinMaxValues(0, 1)
  self:SetValue(1)
end

----------------------------------------------------------------------
-- MARK: CREATE
----------------------------------------------------------------------

function addonTable.CreateHealthBar(plate)
  local healthBar = CreateFrame("StatusBar", nil, plate)
  healthBar:SetAllPoints()
  healthBar:SetClipsChildren(true)

  -- HEALTH TEXTURE
  local health = healthBar:CreateTexture(nil, "ARTWORK", nil, 1)
  health:SetTexture(addonTable.constants.TEXTURES.SOLID)
  health:SetAllPoints()
  health:SetVertexColor(1, 0, 0)
  health:SetSnapToPixelGrid(false)
  health:SetTexelSnappingBias(0)
  healthBar:SetStatusBarTexture(health)
  healthBar.health = health

  -- SHIELD TEXTURE
  local shield = healthBar:CreateTexture(nil, "ARTWORK", nil, 2)
  shield:SetTexture(addonTable.constants.TEXTURES.SHIELD, "REPEAT", "REPEAT")
  shield:SetPoint("LEFT", health, "RIGHT", -50, 0)
  shield:SetSnapToPixelGrid(false)
  shield:SetTexelSnappingBias(0)
  healthBar.shield = shield

  -- BACKGROUND TEXTURE
  local background = healthBar:CreateTexture(nil, "ARTWORK", nil, -6)
  background:SetColorTexture(0, 0, 0, .8)
  background:SetAllPoints()
  healthBar.background = background
  
  Mixin(healthBar, HealthBarMixin)
  healthBar:SetScript("OnEvent", healthBar.OnEvent)

  return healthBar
end



