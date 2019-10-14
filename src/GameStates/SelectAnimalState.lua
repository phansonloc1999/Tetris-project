---@class SelectAnimalState
SelectAnimalState = Class {__includes = BaseState}

ROUND_TIMER = 15

function SelectAnimalState:init()
    self._buttons = {}
    self._emotes = {}

    self._buttons.back =
        RectButton(
        WINDOW_WIDTH / 2 - gTextures.buttons.back.deselected:getWidth() / 2,
        WINDOW_HEIGHT - 70,
        function()
            gStateMachine:change("select-mode")
        end,
        {
            deselected = gTextures.buttons.back.deselected,
            selected = gTextures.buttons.back.selected
        },
        "deselected"
    )

    self._animalTextures = {
        cat = gTextures.animal_emotes.cat,
        dog = gTextures.animal_emotes.dog
    }
end

function SelectAnimalState:render()
    love.graphics.draw(gTextures.background)

    love.graphics.draw(
        gTextures.titles.animalselect,
        WINDOW_WIDTH / 2 - gTextures.titles.animalselect:getWidth() / 2,
        TITLE_TOP_SPACING
    )

    for key, button in pairs(self._buttons) do
        button:render()
    end

    for key, emote in pairs(self._emotes) do
        emote:render()
    end
end

function SelectAnimalState:update(dt)
    for key, button in pairs(self._buttons) do
        if (button:collidesWithMouse()) then
            button:onSelect()
            if (button._emoteMappings) then
                for i = 1, #button._emoteMappings do
                    button._emoteMappings[i]:onSelect()
                end
            end

            if (love.mouse.wasPressed(1)) then
                button:onClick(self)
            end
        elseif (button._selected) then
            button:onDeselect()
            if (button._emoteMappings) then
                for i = 1, #button._emoteMappings do
                    button._emoteMappings[i]:onDeselect()
                end
            end
        end
    end
end

function SelectAnimalState:enter(params)
    self._numOfPlayer = params.numOfPlayers

    if (self._numOfPlayer == 1) then
        self._buttons.cat =
            RectButton(
            WINDOW_WIDTH / 2 - gTextures.buttons.cat.deselected:getWidth() - 50,
            WINDOW_HEIGHT / 2 + 50,
            function()
                gStateMachine:change("play", {numOfPlayers = 1, animal = "cat", timer = ROUND_TIMER})
            end,
            {
                deselected = gTextures.buttons.cat.deselected,
                selected = gTextures.buttons.cat.selected
            },
            "deselected"
        )

        self._buttons.dog =
            RectButton(
            WINDOW_WIDTH / 2 + 50,
            WINDOW_HEIGHT / 2 + 50,
            function()
                gStateMachine:change("play", {numOfPlayers = 1, animal = "dog", timer = ROUND_TIMER})
            end,
            {
                deselected = gTextures.buttons.dog.deselected,
                selected = gTextures.buttons.dog.selected
            },
            "deselected"
        )

        self._emotes = {}

        self._emotes.cat =
            RectButton(
            self._buttons.cat:getX() + self._buttons.cat:getWidth() / 2 -
                gTextures.animal_emotes.cat.deselected:getWidth() / 2,
            self._buttons.cat:getY() - 20 - gTextures.animal_emotes.cat.deselected:getHeight(),
            function()
            end,
            {
                deselected = gTextures.animal_emotes.cat.deselected,
                selected = gTextures.animal_emotes.cat.selected
            },
            "deselected"
        )

        self._emotes.dog =
            RectButton(
            self._buttons.dog:getX() + self._buttons.dog:getWidth() / 2 -
                gTextures.animal_emotes.dog.deselected:getWidth() / 2,
            self._buttons.dog:getY() - 20 - gTextures.animal_emotes.dog.deselected:getHeight(),
            function()
            end,
            {
                deselected = gTextures.animal_emotes.dog.deselected,
                selected = gTextures.animal_emotes.dog.selected
            },
            "deselected"
        )

        self._buttons.cat._emoteMappings = {self._emotes.cat}
        self._buttons.dog._emoteMappings = {self._emotes.dog}
    else
        local NEXT_PREV_BUTTONS_SPACING = 20

        self._player1Animal, self._player2Animal = "cat", "cat"

        self._emotes.player1Animal =
            RectButton(
            WINDOW_WIDTH / 2 - gTextures.buttons.oneplayer.deselected:getWidth() - 50 +
                gTextures.buttons.oneplayer.deselected:getWidth() / 2 -
                gTextures.mode_emotes.oneplayer.deselected:getWidth() / 2,
            WINDOW_HEIGHT / 2 + 30 - gTextures.mode_emotes.oneplayer.deselected:getHeight(),
            function()
            end,
            gTextures.animal_emotes.cat,
            "deselected"
        )

        self._emotes.player2Animal =
            RectButton(
            WINDOW_WIDTH / 2 + 50 + gTextures.buttons.twoplayer.deselected:getWidth() / 2 -
                gTextures.mode_emotes.twoplayer.deselected:getWidth() / 2,
            self._emotes.player1Animal:getY(),
            function()
            end,
            gTextures.animal_emotes.cat,
            "deselected"
        )

        self._buttons.player1Prev =
            RectButton(
            self._emotes.player1Animal:getX() + self._emotes.player1Animal:getWidth() / 2 -
                NEXT_PREV_BUTTONS_SPACING / 2 -
                gTextures.buttons.next.deselected:getWidth(),
            self._emotes.player1Animal:getY() + self._emotes.player1Animal:getHeight() + 10,
            function(thisGameState)
                thisGameState._emotes.player1Animal._textures =
                    thisGameState._emotes.player1Animal._textures == gTextures.animal_emotes.cat and
                    gTextures.animal_emotes.dog or
                    gTextures.animal_emotes.cat
                thisGameState._player1Animal = thisGameState._player1Animal == "cat" and "dog" or "cat"
            end,
            gTextures.buttons.prev,
            "deselected"
        )

        self._buttons.player1Next =
            RectButton(
            self._emotes.player1Animal:getX() + self._emotes.player1Animal:getWidth() / 2 +
                NEXT_PREV_BUTTONS_SPACING / 2,
            self._emotes.player1Animal:getY() + self._emotes.player1Animal:getHeight() + 10,
            function(thisGameState)
                thisGameState._emotes.player1Animal._textures =
                    thisGameState._emotes.player1Animal._textures == gTextures.animal_emotes.cat and
                    gTextures.animal_emotes.dog or
                    gTextures.animal_emotes.cat
                thisGameState._player1Animal = thisGameState._player1Animal == "cat" and "dog" or "cat"
            end,
            gTextures.buttons.next,
            "deselected"
        )

        self._buttons.player2Prev =
            RectButton(
            self._emotes.player2Animal:getX() + self._emotes.player2Animal:getWidth() / 2 -
                NEXT_PREV_BUTTONS_SPACING / 2 -
                gTextures.buttons.next.deselected:getWidth(),
            self._emotes.player2Animal:getY() + self._emotes.player2Animal:getHeight() + 10,
            function(thisGameState)
                thisGameState._emotes.player2Animal._textures =
                    thisGameState._emotes.player2Animal._textures == gTextures.animal_emotes.cat and
                    gTextures.animal_emotes.dog or
                    gTextures.animal_emotes.cat
                thisGameState._player2Animal = thisGameState._player2Animal == "cat" and "dog" or "cat"
            end,
            gTextures.buttons.prev,
            "deselected"
        )

        self._buttons.player2Next =
            RectButton(
            self._emotes.player2Animal:getX() + self._emotes.player2Animal:getWidth() / 2 +
                NEXT_PREV_BUTTONS_SPACING / 2,
            self._emotes.player2Animal:getY() + self._emotes.player2Animal:getHeight() + 10,
            function(thisGameState)
                thisGameState._emotes.player2Animal._textures =
                    thisGameState._emotes.player2Animal._textures == gTextures.animal_emotes.cat and
                    gTextures.animal_emotes.dog or
                    gTextures.animal_emotes.cat
                thisGameState._player2Animal = thisGameState._player2Animal == "cat" and "dog" or "cat"
            end,
            gTextures.buttons.next,
            "deselected"
        )

        self._buttons.ok =
            RectButton(
            self._buttons.back:getX(),
            self._buttons.back:getY() - 10 - gTextures.buttons.ok.deselected:getHeight(),
            function()
                gStateMachine:change(
                    "play",
                    {
                        numOfPlayers = 2,
                        player1Animal = self._player1Animal,
                        player2Animal = self._player2Animal,
                        timer = ROUND_TIMER
                    }
                )
            end,
            gTextures.buttons.ok,
            "deselected"
        )

        self._buttons.ok._emoteMappings = {
            self._emotes.player1Animal,
            self._emotes.player2Animal
        }
    end
end
