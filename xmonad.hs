import System.Exit

import XMonad
import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers(doFullFloat, doCenterFloat, isFullscreen, isDialog)
import XMonad.Config.Desktop
import XMonad.Config.Azerty
import XMonad.Util.Run(spawnPipe)
import XMonad.Actions.SpawnOn
import XMonad.Actions.UpdatePointer
import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce
import XMonad.Util.Run
import XMonad.Actions.CycleWS
import XMonad.Hooks.UrgencyHook
import qualified Codec.Binary.UTF8.String as UTF8

import XMonad.Layout.Spacing
import XMonad.Layout.Gaps
import XMonad.Layout.ResizableTile
---import XMonad.Layout.NoBorders
import XMonad.Layout.Fullscreen (fullscreenFull)
import XMonad.Layout.Cross(simpleCross)
import XMonad.Layout.Spiral(spiral)
import XMonad.Layout.ThreeColumns
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.IndependentScreens


import XMonad.Layout.CenteredMaster(centerMaster)

import Graphics.X11.ExtraTypes.XF86
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import qualified Data.ByteString as B
import Data.Maybe (fromJust)
import Control.Monad (liftM2)
import qualified DBus as D
import qualified DBus.Client as D


myStartupHook = do
    spawn "$HOME/.xmonad/scripts/autostart.sh"
    spawnOnce "setxkbmap -model pc104,pc105 -layout us,ru -option grp:shifts_toggle"
    spawnOnce "/bin/emacs --daemon"
    setWMName "LG3D"

-- colours
normBord = "#4c566a"
focdBord = "#5e81ac"
fore     = "#DEE3E0"
back     = "#282c34"
winType  = "#c678dd"

--mod4Mask= super key
--mod1Mask= alt key
--controlMask= ctrl key
--shiftMask= shift key

myModMask = mod4Mask
encodeCChar = map fromIntegral . B.unpack
myFocusFollowsMouse = True
myBorderWidth = 2

myWorkspaces    = ["I","II","III","IV","V","VI","VII","VIII","IX","X"]
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)

myBaseConfig = desktopConfig

-- window manipulations
myManageHook = composeAll . concat $
    [ [isDialog --> doCenterFloat]
    , [className =? c --> doCenterFloat | c <- myCFloats]
    , [title =? t --> doFloat | t <- myTFloats]
    , [resource =? r --> doFloat | r <- myRFloats]
    , [resource =? i --> doIgnore | i <- myIgnores]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61612" | x <- my1Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61899" | x <- my2Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61947" | x <- my3Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61635" | x <- my4Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61502" | x <- my5Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61501" | x <- my6Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61705" | x <- my7Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61564" | x <- my8Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\62150" | x <- my9Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61872" | x <- my10Shifts]
    ]
    where
    -- doShiftAndGo = doF . liftM2 (.) W.greedyView W.shift
    myCFloats = ["Arandr", "Arcolinux-calamares-tool.py", "Archlinux-tweak-tool.py", "Arcolinux-welcome-app.py", "Galculator", "feh", "mpv", "Xfce4-terminal", "spectacle"]
    myTFloats = ["Downloads", "Save As..."]
    myRFloats = []
    myIgnores = ["desktop_window"]
    -- my1Shifts = ["Chromium", "Vivaldi-stable", "Firefox"]
    -- my2Shifts = []
    -- my3Shifts = ["Inkscape"]
    -- my4Shifts = []
    -- my5Shifts = ["Gimp", "feh"]
    -- my6Shifts = ["vlc", "mpv"]
    -- my7Shifts = ["Virtualbox"]
    -- my8Shifts = ["Thunar"]
    -- my9Shifts = []
    -- my10Shifts = ["discord"]




myLayout = spacingRaw True (Border 0 5 5 5) True (Border 5 5 5 5) True $ avoidStruts $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) $ tiled ||| Mirror tiled ||| spiral (6/7)  ||| ThreeColMid 1 (3/100) (1/2) ||| Full
    where
        tiled = Tall nmaster delta tiled_ratio
        nmaster = 1
        delta = 3/100
        tiled_ratio = 1/2


myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, 1), (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, 2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, 3), (\w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster))

    ]


-- keys config

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  [
    ((modMask .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf)
  ]
  ++

  [((m .|. modMask, k), windows $ onCurrentScreen f i)
        | (i, k) <- zip (workspaces' conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

  ++
  [((m .|. modMask .|. controlMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
      | (key, sc) <- zip [xK_h, xK_l] [0..]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

myAditionalKeys :: [(String, X ())]
myAditionalKeys =  [
    ("M-S-r", spawn $ "xmonad --recompile && xmonad --restart")
    ,("M-S-q", kill)
    ,("M-h", spawn $ "urxvt 'htop task manager' -e htop")
    ,("M-r", spawn $ "rofi-theme-selector")
    ,("M-t", spawn $ "urxvt")
    ,("M-v", spawn $ "pavucontrol")
    ,("M-x", spawn $ "archlinux-logout")
    ,("M-<Return>", spawn $ "alacritty")
    ,("M-S-<Return>", spawn $ "thunar")

    ,("M-S-f", spawn $ "firefox")
    ,("M-S-o", spawn $ "emacsclient -c -a 'emacs'")

    -- Menu
    ,("M-p", spawn $ "rofi -show run")
    ,("M-d", spawn $ "rofi -show drun")
    ,("<KP_F12>", spawn $ "xfce4-terminal --drop-down")
    ,("M-S-d", spawn $ "dmenu_run -i -nb '#191919' -nf '#fea63c' -sb '#fea63c' -sf '#191919' -fn 'NotoMonoRegular:bold:pixelsize=14'")

    -- Screenshot
    ,("<Print>", spawn $ "spectacle")
    ,("<Control_L>-<Print>", spawn $ "scrot 'ArcoLinux-%Y-%m-%d-%s_screenshot_$wx$h.jpg' -e 'mv $f $$(xdg-user-dir PICTURES)'")

    -- Audio
    ,("<XF86AudioLowerVolume>", spawn $ "amixer -q set Master 5%-")
    ,("<XF86AudioRaiseVolume>", spawn $ "amixer -q set Master 5%+")
    ,("<XF86AudioMute>", spawn $ "amixer -q set Master toggle")

    -- Brightness
    ,("<XF86MonBrightnessUp>", spawn $ "brightnessctl s 5%+")
    ,("<XF86MonBrightnessDown>", spawn $ "brightnessctl s 5%-")

    -- Layout
    ,("M-<Space>", sendMessage NextLayout)
    ,("M-<Tab>", nextWS)
    ,("C-M1-<Left>", prevWS)
    ,("C-M1-<Right>", nextWS)
    -- ,("M-S-<Space>", setLayout $ XMonad.layoutHook conf)
    ,("M-j", windows W.focusDown)
    ,("M-k", windows W.focusUp  )
    ,("M-S-m", windows W.focusMaster  )
    ,("M-S-j", windows W.swapDown  )
    ,("M-C-<Down>", windows W.swapDown  )
    ,("M-S-k", windows W.swapUp    )
    ,("M-C-<Up>", windows W.swapUp  )
    ,("C-S-h", sendMessage Shrink)
    ,("C-S-l", sendMessage Expand)
    ,("C-S-t", withFocused $ windows . W.sink)
    ,("M-C-<Left>", sendMessage (IncMasterN 1))
    ,("M-C-<Right>", sendMessage (IncMasterN (-1)))
  ]

main :: IO ()
main = do

    dbus <- D.connectSession
    -- Request access to the DBus name
    D.requestName dbus (D.busName_ "org.xmonad.Log")
        [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]
    xmonad . ewmh $ myBaseConfig
      {startupHook = myStartupHook
      , layoutHook = gaps [(U,35), (D,5), (R,5), (L,5)] $ myLayout ||| layoutHook myBaseConfig
      , manageHook = manageSpawn <+> myManageHook <+> manageHook myBaseConfig
      , modMask = myModMask
      , borderWidth = myBorderWidth
      , handleEventHook    = handleEventHook myBaseConfig
      , focusFollowsMouse = myFocusFollowsMouse
      , workspaces = withScreens 2 myWorkspaces
      , focusedBorderColor = focdBord
      , normalBorderColor = normBord
      , keys = myKeys
      , mouseBindings = myMouseBindings
      , logHook = updatePointer (0.5, 0.5) (0, 0)
      } `additionalKeysP` myAditionalKeys

