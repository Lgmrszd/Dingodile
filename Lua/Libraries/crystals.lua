local maxhp=30
Crystal = {}

function Crystal:New()
  local obj = {}
  obj.hp = maxhp
  obj.sprite = 'crystal'
  setmetatable(obj, self)
  self.__index = self
  return obj
end

function Crystal:SetSprite(spritename)
  self.sprite = spritename
end

ShadowCrystal = {}
