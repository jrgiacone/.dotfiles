import XMonad
import qualified XMonad.StackSet as W

-- Layouts

import XMonad.Layout.Grid
import XMonad.Layout.NoBorders
import XMonad.Layout.SimpleFloat
import XMonad.Layout.ThreeColumns
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Spacing
import XMonad.Layout.Renamed
import XMonad.Layout.Gaps
import XMonad.Layout.Spacing
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.MultiToggle
import qualified XMonad.Layout.Magnifier as Mag

-- Hooks

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.WindowSwallowing

-- Utils

import XMonad.Util.EZConfig
import XMonad.Util.Loggers
import XMonad.Util.Ungrab
import XMonad.Util.SpawnOnce
import XMonad.Util.NamedScratchpad
import XMonad.Util.ClickableWorkspaces
import qualified XMonad.Util.Hacks as Hacks

-- Actions

import XMonad.Actions.Promote
import XMonad.Actions.CycleWS

-- Datas

import Data.Maybe (fromJust)
import Data.Maybe (isJust)

-- Default Programs

myTerminal :: String
myTerminal = "alacritty"

myEmacs :: String
myEmacs = "emacsclient -c -a 'emacs' "

myNormColor :: String
myNormColor = "#3b4252"

myFocusColor :: String
myFocusColor = "#88c0d0"

-- Main

main :: IO ()
main = xmonad
     . ewmhFullscreen
     . ewmh
     . dynamicEasySBs barSpawner
     $ myConfig

-- Keybindings

myKeys :: [(String, X())]
myKeys =
        [ ("M-<Return>", spawn (myTerminal))
        , ("M-S-z", spawn "xscreensaver-command -lock")
        , ("M-S-=", unGrab *> spawn "scrot -s ~/Pictures/screenShots/%Y-%m-%d-%T-screenshot.png")
        , ("M-]"  , spawn "firefox"                   )
        , ("M-["  , spawn "chromium"                  )
        --, ("M-S-<Return>" , spawn "dmenu_run -i -p \"Run: \"")
        , ("M-S-<Return>" , spawn "rofi -show drun")
        , ("M1-<Tab>" , spawn "rofi -show window")
        --, ("M-p q",  spawn  "dmpower")
        , ("M-p q", spawn "rofi -show power-menu -modi power-menu:/home/jrgiacone/.config/xmonad/rpower")
        , ("M-<Backspace>", promote)
        , ("M-b", sendMessage ToggleStruts)
        , ("M-p d", spawn "/home/jrgiacone/.config/xmonad/dual.sh")
        , ("M-p s", spawn "/home/jrgiacone/.config/xmonad/single.sh")
        , ("M-p o", spawn "xset dpms force off")
        , ("C-e t", namedScratchpadAction myScratchpads "terminal")
        , ("M-p c", spawn "picom")
        , ("M-p x", spawn "pkill picom")
        , ("M-g",  toggleGaps)
        , ("M-f", toggleFullScreen)
        , ("M-C-r", spawn "xmonad --recompile")
        , ("M-S-r", spawn "xmonad --restart")
        , ("C-e e", spawn (myEmacs ))
        , ("C-e i", spawn "alacritty -e sh -c 'sleep 0.1 && $(which nvim) $*'")
        , ("C-e f", spawn "alacritty -e vifm")
        , ("C-s s", spawn "steam")
        , ("C-e u" , spawn "alacritty --working-directory ~/.config/xmonad/ -e ./update.sh")
        , ("C-S-l", spawn "locate.sh")
        , ("C-m .", spawn "playerctl -p ncspot next")
        , ("C-m ,", spawn "playerctl -p ncspot previous")
        , ("C-m <Space>", spawn "playerctl -p ncspot play-pause")
        , ("C-e m", namedScratchpadAction myScratchpads "ncspot")
        , ("C-g u", spawn "sudo undervolt")
        , ("C-g r", spawn "sudo resetGpu")
        ]

-- Xxmobar Definitions/Callouts

xmobar1 = statusBarProp "xmobar -x 0 ~/.config/xmonad/.xmobarrc" (myXmobarPP) 
xmobar2 = statusBarProp "xmobar -x 1 ~/.config/xmonad/.xmobarrc1" (myXmobarPP)

-- Dynamic Xmobars

barSpawner :: ScreenId -> IO StatusBarConfig
barSpawner 0 = pure (xmobar1) <> trayerSB
barSpawner 1 = pure xmobar2


staticStatusBar cmd = pure $ def { sbStartupHook = spawnStatusBar cmd
                                 , sbCleanupHook = killStatusBar cmd
                                 } 

trayerSB :: IO StatusBarConfig
trayerSB = staticStatusBar
  (unwords
    ["trayer"
    , "--edge top"
    , "--align right"
    , "--widthtype request"
    , "--expand true"
    , "--monitor primary"
    , "--transparent true"
    , "--alpha 0"
    , "--tint 0x282c34"
    , "--height 20"
    , "-l"
    , "--padding 6"
    , "--SetDockType true"
    , "--SetPartialStrut true"
    ]
  )

-- Start Up Hooks

myStartupHook :: X()
myStartupHook = do
    spawnOnce "picom"
    spawnOnce "nitrogen --restore"
    spawnOnce "udiskie -t"
    spawnOnce "nm-applet"
    spawnOnce "dunst"
    spawnOnce "easyeffects --gapplication-service"
    spawnOnce "polychromatic-tray-applet"
    --spawnOnce "/usr/bin/emacs --daemon &"

-- Application  Management

myManageHook :: ManageHook
myManageHook = composeAll
    [ className =? "Gimp" --> doFloat
    , isDialog            --> doFloat
    , isFullscreen        --> doFullFloat
    ] <+> namedScratchpadManageHook myScratchpads

-- Custom Functions

toggleGaps :: X ()
toggleGaps = do
  sendMessage ToggleGaps
  toggleWindowSpacingEnabled

toggleFullScreen :: X ()
toggleFullScreen = do
  sendMessage ToggleStruts
  sendMessage $ Toggle NBFULL
  toggleGaps

-- Scratch Pads

myScratchpads :: [NamedScratchpad]
myScratchpads = [ NS "ncspot" "alacritty -t ncspot -e ncspot" (title =? "ncspot")
                      (customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3)),
                  NS "terminal" "alacritty -t scratchpad" (title =? "scratchpad")
                      (customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3))]

-- myScratchpads :: [NamedScratchpad]
-- myScratchpads = [ NS "terminal" spawnTerm findTerm manageTerm ]
--   where
--     spawnTerm = myTerminal ++ " -t scratchpad"
--     findTerm = title =? "scratchpad"
--     manageTerm = customFloating $ W.RationalRect l t w h
--                where
--                  h = 0.9
--                  w = 0.9
--                  t = 0.95 -h
--                  l = 0.95 -w
-- Layouts

myLayout = 
    renamed [KeepWordsRight 1]
    .   spacingRaw False (Border 0 0 0 0) True (Border 15 0 15 0) True
    .   gaps [(U, 0), (R, 0), (L, 15), (D, 15)]
    .   mkToggle (single NBFULL)
    .   smartBorders 
    $   tiled 
    ||| mtiled
    ||| Full 
    ||| threeCol
  where
    mtiled   = renamed [Replace "Mirror"]
               $ Mirror tiled
    threeCol = renamed [Replace "Centered"]
               $ Mag.magnifiercz' 1.3 
               $ ThreeColMid nmaster delta ratio
    tiled    = renamed [Replace "Tiled"]
               $ Tall nmaster delta ratio
    nmaster  = 1      -- Default number of windows in the master pane
    ratio    = 1/2    -- Default proportion of screen occupied by master pane
    delta    = 3/100  -- Percent of screen to increment by when resizing panes



-- Xmobar Settings

myXmobarPP :: X PP
myXmobarPP = clickablePP . filterOutWsPP [scratchpadWorkspaceTag] $ def
    { ppSep             = nordaurora5 " • "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = wrap " " "" . xmobarBorder "Top" "#88c0d0" 2
    , ppHidden          = nordfrost4 . wrap " " ""
    , ppHiddenNoWindows = nordfrost1 . wrap " " ""
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
    , ppExtras          = [logTitles formatFocused formatUnfocused]
    , ppVisible         = wrap "[" "]"
    }
  where
    formatFocused   = wrap (lowWhite    "[") (lowWhite    "]") . nordsnow1 . ppWindow
    formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . nordfrost1    . ppWindow

    -- | Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30
    blue, lowWhite, magenta, red, white, yellow :: String -> String

-- Colors

    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#bd93f9" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""
    nordfrost1 = xmobarColor "#8fbcbb" ""
    nordfrost3 = xmobarColor "#81a1c1" ""
    nordfrost4 = xmobarColor "#5e91ac" ""
    nordsnow1 = xmobarColor "#d8dee9" ""
    nordsnow2 = xmobarColor "#e5e9f0" ""
    nordsnow3 = xmobarColor "#eceff4" ""
    nordnight4 = xmobarColor "4c566a" ""
    nordaurora5 = xmobarColor "#b48ead" ""

-- Config Default Definitions

myConfig = def
    { modMask     = mod4Mask      -- Rebind Mod to the Super key
    , layoutHook  = myLayout      -- Use custom layouts
    , borderWidth = 2
    , manageHook  = myManageHook  -- Match on certain windows
    , terminal    = myTerminal
    , startupHook = myStartupHook
    , focusedBorderColor = myFocusColor
    , handleEventHook = Hacks.trayerAboveXmobarEventHook -- <> Hacks.windowedFullscreenFixEventHook
                        <> swallowEventHook (className =? "Alacritty")
                                             (return True)
    , normalBorderColor = myNormColor
    }
  `additionalKeysP` myKeys
