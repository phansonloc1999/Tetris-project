---@class RectButton
RectButton = Class{}

function RectButton:init(x, y, width, height, funcOnClick, textures, animations)
    self._hitbox = RectHitbox(x, y, width, height)
    self._textures = textures
    self._animations = animations
    self._funcOnClick = funcOnClick

    if (textures) then
        self._currentTexture = "default"
        assert(self._textures[self._currentTexture], "Default texture must exist!")
    end
end

function RectButton:render()
    self._hitbox:render()

    if (self._textures) then
        love.graphics.draw(self._textures[self._currentTexture], self._hitbox._pos._x, self._hitbox._pos._y)
    end
end

function RectButton:collidesWithMouse()
    local mouse = {
        _pos = {
            _x = love.mouse.getX(),
            _y = love.mouse.getY()
        },
        _width = 1,
        _height = 1
    }
    return self._hitbox:collides(mouse)
end

function RectButton:onClick(params)
    self._funcOnClick(params)
end

function RectButton:setPos(newX, newY)
    self._hitbox._pos._x, self._hitbox._pos._y = newX, newY
end