WINDOW_WIDTH, WINDOW_HEIGHT = 500, 500

math.randomseed(os.time())

gFonts = {
    small = love.graphics.newFont(12),
    medium = love.graphics.newFont(20),
    large = love.graphics.newFont(30),
    default = love.graphics.setNewFont("assets/font/ARCADECLASSIC.ttf", 36)
}

gTextures = {
    buttons = {
        go = {
            selected = love.graphics.newImage("assets/buttons/title screen/go selected.png"),
            deselected = love.graphics.newImage("assets/buttons/title screen/go deselected.png")
        },
        quit = {
            selected = love.graphics.newImage("assets/buttons/title screen/quit selected.png"),
            deselected = love.graphics.newImage("assets/buttons/title screen/quit deselected.png")
        },
        start = {
            selected = love.graphics.newImage("assets/buttons/start selected.png"),
            deselected = love.graphics.newImage("assets/buttons/start deselected.png")
        },
        about = {
            selected = love.graphics.newImage("assets/buttons/about selected.png"),
            deselected = love.graphics.newImage("assets/buttons/about deselected.png")
        },
        option = {
            selected = love.graphics.newImage("assets/buttons/option selected.png"),
            deselected = love.graphics.newImage("assets/buttons/option deselected.png")
        },
        menu_quit = {
            selected = love.graphics.newImage("assets/buttons/quit selected.png"),
            deselected = love.graphics.newImage("assets/buttons/quit deselected.png")
        },
        oneplayer = {
            deselected = love.graphics.newImage("assets/buttons/1 player deselected.png"),
            selected = love.graphics.newImage("assets/buttons/1 player selected.png")
        },
        twoplayer = {
            deselected = love.graphics.newImage("assets/buttons/2 players deselected.png"),
            selected = love.graphics.newImage("assets/buttons/2 players selected.png")
        },
        back = {
            deselected = love.graphics.newImage("assets/buttons/back deselected.png"),
            selected = love.graphics.newImage("assets/buttons/back selected.png")
        },
        dog = {
            deselected = love.graphics.newImage("assets/buttons/dog deselected.png"),
            selected = love.graphics.newImage("assets/buttons/dog selected.png")
        },
        cat = {
            deselected = love.graphics.newImage("assets/buttons/cat deselected.png"),
            selected = love.graphics.newImage("assets/buttons/cat selected.png")
        },
        next = {
            deselected = love.graphics.newImage("assets/buttons/next deselected.png"),
            selected = love.graphics.newImage("assets/buttons/next selected.png")
        },
        prev = {
            deselected = love.graphics.newImage("assets/buttons/previous deselected.png"),
            selected = love.graphics.newImage("assets/buttons/previous selected.png")
        },
        ok = {
            deselected = love.graphics.newImage("assets/buttons/ok deselected.png"),
            selected = love.graphics.newImage("assets/buttons/ok selected.png")
        },
        reset = {
            deselected = love.graphics.newImage("assets/buttons/reset deselected.png"),
            selected = love.graphics.newImage("assets/buttons/reset selected.png")
        },
        pause = {
            deselected = love.graphics.newImage("assets/buttons/pause deselected.png"),
            selected = love.graphics.newImage("assets/buttons/pause selected.png")
        }
    },
    titles = {
        menu = love.graphics.newImage("assets/titles/menu.png"),
        mode = love.graphics.newImage("assets/titles/game mode.png"),
        animalselect = love.graphics.newImage("assets/titles/animal select.png")
    },
    pet_emotes = {
        pet1 = {
            selected = love.graphics.newImage("assets/menu/pet 1 selected.png"),
            deselected = love.graphics.newImage("assets/menu/pet 1 deselected.png")
        },
        pet2 = {
            selected = love.graphics.newImage("assets/menu/pet 2 selected.png"),
            deselected = love.graphics.newImage("assets/menu/pet 2 deselected.png")
        }
    },
    mode_emotes = {
        oneplayer = {
            deselected = love.graphics.newImage("assets/select mode/1 player deselected.png"),
            selected = love.graphics.newImage("assets/select mode/1 player selected.png")
        },
        twoplayer = {
            deselected = love.graphics.newImage("assets/select mode/2 players deselected.png"),
            selected = love.graphics.newImage("assets/select mode/2 players selected.png")
        }
    },
    animal_emotes = {
        dog = {
            deselected = love.graphics.newImage("assets/select animal/1 player pet 1 deselected.png"),
            selected = love.graphics.newImage("assets/select animal/1 player pet 1 selected.png")
        },
        cat = {
            deselected = love.graphics.newImage("assets/select animal/1 player pet 2 deselected.png"),
            selected = love.graphics.newImage("assets/select animal/1 player pet 2 selected.png")
        }
    },
    blocks = {
        cat = {
            L1 = love.graphics.newImage("assets/blocks/cat/L.png"),
            L2 = love.graphics.newImage("assets/blocks/cat/L.png"),
            I = love.graphics.newImage("assets/blocks/cat/I.png"),
            O = love.graphics.newImage("assets/blocks/cat/O.png"),
            T = love.graphics.newImage("assets/blocks/cat/T.png"),
            Z1 = love.graphics.newImage("assets/blocks/cat/Z.png"),
            Z2 = love.graphics.newImage("assets/blocks/cat/Z.png")
        },
        dog = {
            L1 = love.graphics.newImage("assets/blocks/dog/L.png"),
            L2 = love.graphics.newImage("assets/blocks/dog/L.png"),
            I = love.graphics.newImage("assets/blocks/dog/I.png"),
            O = love.graphics.newImage("assets/blocks/dog/O.png"),
            T = love.graphics.newImage("assets/blocks/dog/T.png"),
            Z = love.graphics.newImage("assets/blocks/dog/Z.png"),
            Z1 = love.graphics.newImage("assets/blocks/dog/Z.png"),
            Z2 = love.graphics.newImage("assets/blocks/dog/Z.png")
        }
    },
    preview_blocks = {
        L = love.graphics.newImage("assets/preview blocks/L.png"),
        I = love.graphics.newImage("assets/preview blocks/I.png"),
        O = love.graphics.newImage("assets/preview blocks/O.png"),
        T = love.graphics.newImage("assets/preview blocks/T.png"),
        Z = love.graphics.newImage("assets/preview blocks/O.png")
    },
    score_boards = {
        one_player = love.graphics.newImage("assets/score boards/one player.png"),
        p1 = love.graphics.newImage("assets/score boards/P1.png"),
        p2 = love.graphics.newImage("assets/score boards/P2.png")
    },
    ["background"] = love.graphics.newImage("assets/background.png"),
    ["title-screen"] = love.graphics.newImage("assets/title screen.png"),
    ["pause-background"] = love.graphics.newImage("assets/pause/pause background.png"),
    ["background-large"] = love.graphics.newImage("assets/background large.png"),
    ["screenplay-border"] = love.graphics.newImage("assets/screenplay border.png"),
    ["preview-board"] = love.graphics.newImage("assets/preview board.png"),
    ["preview-board-2-players"] = love.graphics.newImage("assets/preview board 2 players.png"),
    ["time_board"] = love.graphics.newImage("assets/time board.png")
}

gSounds = {
    hover = love.audio.newSource("sounds/hover.ogg", "static"),
    scoring = love.audio.newSource("sounds/scoring 1.wav", "static")
}

TITLE_TOP_SPACING = 20
CAPPED_FPS = 60
