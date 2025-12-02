local addonTable = select(2, ...)

local Scale = addonTable.Scale
local UnitGetTotalAbsorbs = UnitGetTotalAbsorbs
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax

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

  local totalAbsorbs = 2500000 -- UnitGetTotalAbsorbs(self.unit)

  if  totalAbsorbs > 0 then
    local maxHealth = UnitHealthMax(self.unit)
    local shieldPercent = totalAbsorbs / maxHealth
    --local currentHealth = UnitHealth(self.unit)
    --local healthPercent = currentHealth / maxHealth
    -- used to figure out if we need a glow because shield + health > 100%
    local width = shieldPercent * self:GetWidth()

    self.shieldTexture:SetWidth(width)
    self.shieldTexture:Show()
  else
    self.shieldTexture:Hide()
  end
end

function HealthBarMixin:Enable(unit)
  self.unit = unit;

  self:RegisterUnitEvent("UNIT_HEALTH", self.unit)
  self:RegisterUnitEvent("UNIT_MAXHEALTH", self.unit)
  self:RegisterUnitEvent("UNIT_ABSORB_AMOUNT_CHANGED", self.unit)

  self:UpdateMaxHealth()
  self:UpdateHealth()
  self:UpdateShield()
end

function HealthBarMixin:Disable()
  self.unit = nil;

  self:UnregisterEvent("UNIT_HEALTH")
  self:UnregisterEvent("UNIT_MAXHEALTH")
  self:UnregisterEvent("UNIT_ABSORB_AMOUNT_CHANGED")
end


function HealthBarMixin:OnEvent(event)
  print(self.unit .. "HealthBar.OnEvent")

  if event == "UNIT_HEALTH" then
    self:UpdateHealth()
    self:UpdateShield()
  elseif event == "UNIT_MAXHEALTH" then
    self:UpdateMaxHealth()
    self:UpdateShield()
  elseif event == "UNIT_ABSORB_AMOUNT_CHANGED" then
    self:UpdateShield()
  else 
    print("Unhandled HealthBar Event", self.unit, event)
  end
end

function addonTable.CreateHealthBar(nameplate)
  local healthBar = CreateFrame("StatusBar", nil, nameplate) -- TODO: name? JPlates_Nameplate_{{index}}_HealthBar
  healthBar:SetAllPoints()
  healthBar:SetClipsChildren(true)

  -- HEALTH TEXTURE
  local healthTexture = healthBar:CreateTexture(nil, "ARTWORK", nil, 1)
  --healthTexture:SetTexture(addonTable.constants.TEXTURES.SOLID)
  healthTexture:SetTexture("Interface\\Buttons\\WHITE8X8")
  healthTexture:SetAllPoints()
  healthTexture:SetVertexColor(1, 0, 0)
  healthTexture:SetSnapToPixelGrid(false)
  healthTexture:SetTexelSnappingBias(0)

  healthBar:SetStatusBarTexture(healthTexture)
  healthBar.healthTexture = healthTexture

  -- SHIELD TEXTURE
  --local shieldBar = CreateFrame("Frame", nil, nameplate)
  --shieldBar:SetPoint("LEFT", healthTexture, "RIGHT")

  --local shieldTexture = shieldBar:CreateTexture(nil, "ARTWORK", nil, 2)
  local shieldTexture = healthBar:CreateTexture(nil, "ARTWORK", nil, 2)
  shieldTexture:SetTexture("Interface\\AddOns\\Plates\\Media\\shield", "REPEAT", "REPEAT")
  shieldTexture:SetHorizTile(true)
  shieldTexture:SetVertTile(true)
  shieldTexture:SetVertexColor(1, 1, 1)
  shieldTexture:SetPoint("LEFT", healthTexture, "RIGHT", Scale(0), Scale(0))
  shieldTexture:SetSnapToPixelGrid(false)
  shieldTexture:SetTexelSnappingBias(0)
  shieldTexture:Hide()

  healthBar.shieldTexture = shieldTexture

  -- BACKGROUND TEXTTURE
  local backgroundTexture = healthBar:CreateTexture(nil, "ARTWORK", nil, -6)
  backgroundTexture:SetTexture("Interface\\Buttons\\WHITE8X8")
  backgroundTexture:SetVertexColor(0, 0, 0, .8)
  backgroundTexture:SetAllPoints()

  healthBar.backgroundTexture = backgroundTexture

  Mixin(healthBar, HealthBarMixin)
  
  healthBar:SetScript("OnEvent", healthBar.OnEvent)

  return healthBar
end