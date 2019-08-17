---@class SelectAnimalState
SelectAnimalState = Class {__includes = BaseState}

local DOG_TEXTURE = love.graphics.newImage("assets/dog.png")
local CAT_TEXTURE = love.graphics.newImage("assets/cat.png")

local ANIMALS = {CAT = 1, DOG = 2}

local ARROW_BUTTON_WIDTH, ARROW_BUTTON_HEIGHT = 20, 20

function SelectAnimalState:init()
    self._player1 = {
        animal = ANIMALS.CAT,
        textureX = WINDOW_WIDTH / 4 - DOG_TEXTURE:getWidth() / 2,
        textureY = WINDOW_HEIGHT / 2 - DOG_TEXTURE:getHeight() / 2 - 50
    }
    self._player2 = {
        animal = ANIMALS.CAT,
        textureX = 3 * WINDOW_WIDTH / 4 - DOG_TEXTURE:getWidth() / 2,
        textureY = WINDOW_HEIGHT / 2 - DOG_TEXTURE:getHeight() / 2 - 50
    }

    self._buttons = {}

    self._buttons.player1Left =
        RectButton(
        self._player1.textureX + DOG_TEXTURE:getWidth() / 2 - 10 - ARROW_BUTTON_WIDTH,
        self._player1.textureY + DOG_TEXTURE:getHeight() + 10,
        ARROW_BUTTON_WIDTH,
        ARROW_BUTTON_HEIGHT,
        function(params)
            params._player1.animal = params._player1.animal == ANIMALS.CAT and ANIMALS.DOG or ANIMALS.CAT
        end
    )
    self._buttons.player1Right =
        RectButton(
        self._player1.textureX + DOG_TEXTURE:getWidth() / 2 + 10,
        self._player1.textureY + DOG_TEXTURE:getHeight() + 10,
        ARROW_BUTTON_WIDTH,
        ARROW_BUTTON_HEIGHT,
        function(params)
            params._player1.animal = params._player1.animal == ANIMALS.CAT and ANIMALS.DOG or ANIMALS.CAT
        end
    )

    self._buttons.player2Left =
        RectButton(
        self._player2.textureX + DOG_TEXTURE:getWidth() / 2 - 10 - ARROW_BUTTON_WIDTH,
        self._player2.textureY + DOG_TEXTURE:getHeight() + 10,
        ARROW_BUTTON_WIDTH,
        ARROW_BUTTON_HEIGHT,
        function(params)
            params._player2.animal = params._player2.animal == ANIMALS.CAT and ANIMALS.DOG or ANIMALS.CAT
        end
    )
    self._buttons.player2Right =
        RectButton(
        self._player2.textureX + DOG_TEXTURE:getWidth() / 2 + 10,
        self._player2.textureY + DOG_TEXTURE:getHeight() + 10,
        ARROW_BUTTON_WIDTH,
        ARROW_BUTTON_HEIGHT,
        function(params)
            params._player2.animal = params._player2.animal == ANIMALS.CAT and ANIMALS.DOG or ANIMALS.CAT
        end
    )

    self._buttons.ok =
        RectButton(
        WINDOW_WIDTH / 2 - 40,
        self._buttons.player1Left:getY() + self._buttons.player1Left:getHeight() + 60,
        80,
        30,
        function(params)
            gStateMachine:change("play", {numOfPlayers = params._numOfPlayer})
        end
    )

    self._buttons.back =
        RectButton(
        self._buttons.ok:getX(),
        self._buttons.ok:getY() + self._buttons.ok:getHeight() + 20,
        80,
        30,
        function()
            gStateMachine:change("select-mode")
        end
    )
end

function SelectAnimalState:render()
    if (self._player1.animal == ANIMALS.CAT) then
        love.graphics.draw(CAT_TEXTURE, self._player1.textureX, self._player1.textureY)
    else
        love.graphics.draw(DOG_TEXTURE, self._player1.textureX, self._player1.textureY)
    end

    if (self._numOfPlayer == 2) then
        if (self._player2.animal == ANIMALS.CAT) then
            love.graphics.draw(CAT_TEXTURE, self._player2.textureX, self._player2.textureY)
        else
            love.graphics.draw(DOG_TEXTURE, self._player2.textureX, self._player2.textureY)
        end
    end

    for key, button in pairs(self._buttons) do
        button:render()
    end
end

function SelectAnimalState:update(dt)
    if (love.mouse.wasPressed(1)) then
        for key, button in pairs(self._buttons) do
            if (button:collidesWithMouse()) then
                button:onClick(self)
            end
        end
    end
end

function SelectAnimalState:enter(params)
    self._numOfPlayer = params.numOfPlayers

    if (self._numOfPlayer == 1) then
        self._player1.textureX, self._player1.textureY =
            WINDOW_WIDTH / 2 - DOG_TEXTURE:getWidth() / 2,
            WINDOW_HEIGHT / 2 - 100

        self._buttons.player2Left, self._buttons.player2Right = nil, nil
        self._buttons.player1Left:setPos(
            WINDOW_WIDTH / 2 - ARROW_BUTTON_WIDTH - 10,
            self._player1.textureY + DOG_TEXTURE:getHeight()
        )
        self._buttons.player1Right:setPos(WINDOW_WIDTH / 2 + 10, self._player1.textureY + DOG_TEXTURE:getHeight())
    end
end
