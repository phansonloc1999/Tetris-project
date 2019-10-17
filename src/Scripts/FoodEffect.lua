---@class FoodEffect
FoodEffect = Class {}

AVATAR_FOOD_SPACING = 5

function FoodEffect:init(x, y, avatarTextures, foodTexture)
    self._pos = Vector2(x, y, 0, 0)
    self._avatarTextures = avatarTextures
    self._currentAvatarTexture = "normal"
    self._foodTexture = foodTexture
    self._isTriggered = false
end

function FoodEffect:render()
    love.graphics.draw(self._avatarTextures[self._currentAvatarTexture], self._pos._x, self._pos._y)

    if (self._isTriggered) then
        love.graphics.draw(
            self._foodTexture,
            self._pos._x + self._avatarTextures[self._currentAvatarTexture]:getWidth() / 2 -
                self._foodTexture:getWidth() / 2,
            self._pos._y - AVATAR_FOOD_SPACING - self._foodTexture:getHeight()
        )
    end
end

function FoodEffect:update(dt)
    if (self._isTriggered) then
        self._duration = math.max(0, self._duration - dt)
    end
end

function FoodEffect:start()
    local EFFECT_FRAME_DURATION = 0.4
    Chain(
        function(go)
            self._isTriggered = true
            self._currentAvatarTexture = "happy"
            Timer.after(EFFECT_FRAME_DURATION, go)
        end,
        function(go)
            self._isTriggered = false
            self._currentAvatarTexture = "normal"
            Timer.after(EFFECT_FRAME_DURATION, go)
        end,
        function(go)
            self._isTriggered = true
            self._currentAvatarTexture = "happy"
            Timer.after(EFFECT_FRAME_DURATION, go)
        end,
        function(go)
            self._isTriggered = false
            self._currentAvatarTexture = "normal"
            Timer.after(EFFECT_FRAME_DURATION, go)
        end
    )()
end

function FoodEffect:setPos(newX, newY)
    self._pos:setPos(newX, newY)
end
