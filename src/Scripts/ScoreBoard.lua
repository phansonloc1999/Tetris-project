---@class ScoreBoard
ScoreBoard = Class {}

function ScoreBoard:init(x, y, texture)
    self._pos = Vector2(x, y, 0, 0)
    self._texture = texture
    self._scoreValue = 0
    self._scoreText = love.graphics.newText(love.graphics.newFont(30), tostring(self._scoreValue))
end

function ScoreBoard:render()
    love.graphics.draw(self._texture, self._pos._x, self._pos._y)
    love.graphics.draw(
        self._scoreText,
        self._pos._x + self._texture:getWidth() / 2 - self._scoreText:getHeight() / 2 - 10,
        self._pos._y + self._texture:getHeight() / 2 - self._scoreText:getHeight() / 2 + 10
    )
end

function ScoreBoard:increase(ammount)
    self._scoreValue = self._scoreValue + ammount
    self._scoreText = love.graphics.newText(love.graphics.newFont(30), tostring(self._scoreValue))
end
