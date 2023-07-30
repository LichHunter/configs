import qualified Codec.Binary.UTF8.String as UTF8
import Control.Monad (liftM2)
import qualified DBus as D
import qualified DBus.Client as D
import qualified Data.ByteString as B
import qualified Data.Map as M
import Graphics.X11.ExtraTypes.XF86
import System.Exit
import System.IO
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.SpawnOn
import XMonad.Config.Azerty
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers (doCenterFloat, doFullFloat, isDialog, isFullscreen)
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.CenteredMaster (centerMaster)
import XMonad.Layout.Cross (simpleCross)
import XMonad.Layout.Fullscreen (fullscreenFull)
import XMonad.Layout.Gaps
import XMonad.Layout.IndependentScreens
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.ResizableTile
import XMonad.Layout.Spacing
import XMonad.Layout.Spiral (spiral)
import XMonad.Layout.ThreeColumns
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig (additionalKeys, additionalMouseBindings)
import XMonad.Util.Run (spawnPipe)

myStartupHook = do
  spawn "$HOME/.xmonad/scripts/autostart.sh"
  spawn "setxkbmap us,ru,ua -option grp:alt_shift_toggle"
  setWMName "LG3D"

normBord = "#4c566a"

focdBord = "#5e81ac"

fore = "#DEE3E0"

back = "#282c34"

winType = "#c678dd"

myModMask = mod4Mask

encodeCChar = map fromIntegral . B.unpack

myFocusFollowsMouse = True

myBorderWidth = 2

myWorkspaces = ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X"]

myBaseConfig = desktopConfig

-- window manipulations
myManageHook =
  composeAll . concat $
    [ [isDialog --> doCenterFloat],
      [className =? c --> doCenterFloat | c <- myCFloats],
      [title =? t --> doFloat | t <- myTFloats],
      [resource =? r --> doFloat | r <- myRFloats],
      [resource =? i --> doIgnore | i <- myIgnores]
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
    myCFloats = ["Arandr", "Arcolinux-calamares-tool.py", "Archlinux-tweak-tool.py", "Arcolinux-welcome-app.py", "Galculator", "feh", "mpv", "Xfce4-terminal"]
    myTFloats = ["Downloads", "Save As..."]
    myRFloats = []
    myIgnores = ["desktop_window"]

-- my1Shifts = ["Chromium", "Vivaldi-stable", "Firefox"]

myLayout = spacingRaw True (Border 0 5 5 5) True (Border 5 5 5 5) True $ avoidStruts $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) $ tiled ||| Mirror tiled ||| spiral (6 / 7) ||| ThreeColMid 1 (3 / 100) (1 / 2) ||| Full
  where
    tiled = Tall nmaster delta tiled_ratio
    nmaster = 1
    delta = 3 / 100
    tiled_ratio = 1 / 2

myMouseBindings (XConfig {XMonad.modMask = modMask}) =
  M.fromList $
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, 1), \w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster),
      -- mod-button2, Raise the window to the top of the stack
      ((modMask, 2), \w -> focus w >> windows W.shiftMaster),
      -- mod-button3, Set the window to floating mode and resize by dragging
      ((modMask, 3), \w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster)
    ]

-- keys config

myKeys conf@(XConfig {XMonad.modMask = modMask}) =
  M.fromList $
    ----------------------------------------------------------------------
    -- SUPER + FUNCTION KEYS

    [ ((modMask, xK_f), sendMessage $ Toggle NBFULL),
      ((modMask, xK_h), spawn $ "urxvt 'htop task manager' -e htop"),
      ((modMask, xK_m), spawn $ "pragha"),
      ((modMask, xK_r), spawn $ "rofi-theme-selector"),
      ((modMask, xK_v), spawn $ "pavucontrol"),
      ((modMask, xK_x), spawn $ "archlinux-logout"),
      ((modMask, xK_Escape), spawn $ "xkill"),
      ((modMask, xK_Return), spawn $ "alacritty"),
      ((modMask .|. shiftMask, xK_Return), spawn $ "thunar"),
      ((modMask .|. shiftMask, xK_d), spawn $ "dmenu_run -i -nb '#191919' -nf '#fea63c' -sb '#fea63c' -sf '#191919' -fn 'NotoMonoRegular:bold:pixelsize=14'"),
      ((modMask, xK_p), spawn $ "~/.config/polybar/colorblocks/scripts/launcher.sh"),
      ((modMask .|. shiftMask, xK_r), spawn $ "xmonad --recompile && xmonad --restart"),
      ((modMask .|. shiftMask, xK_q), kill),
      ((controlMask .|. shiftMask, xK_Escape), spawn $ "xfce4-taskmanager"),
      --SCREENSHOTS

      ((0, xK_Print), spawn $ "scrot 'ArcoLinux-%Y-%m-%d-%s_screenshot_$wx$h.jpg' -e 'mv $f $$(xdg-user-dir PICTURES)'"),
      ((controlMask, xK_Print), spawn $ "xfce4-screenshooter"),
      ((controlMask .|. shiftMask, xK_Print), spawn $ "gnome-screenshot -i"),
      ((controlMask .|. modMask, xK_Print), spawn $ "flameshot gui"),
      --MULTIMEDIA KEYS

      -- Mute volume
      ((0, xF86XK_AudioMute), spawn $ "amixer -q set Master toggle"),
      -- Decrease volume
      ((0, xF86XK_AudioLowerVolume), spawn $ "amixer -q set Master 5%-"),
      -- Increase volume
      ((0, xF86XK_AudioRaiseVolume), spawn $ "amixer -q set Master 5%+"),
      -- Increase brightness
      ((0, xF86XK_MonBrightnessUp), spawn $ "xbacklight -inc 5"),
      -- Decrease brightness
      ((0, xF86XK_MonBrightnessDown), spawn $ "xbacklight -dec 5"),
      ((0, xF86XK_AudioPlay), spawn $ "playerctl play-pause"),
      ((0, xF86XK_AudioNext), spawn $ "playerctl next"),
      ((0, xF86XK_AudioPrev), spawn $ "playerctl previous"),
      ((0, xF86XK_AudioStop), spawn $ "playerctl stop"),
      --------------------------------------------------------------------
      --  XMONAD LAYOUT KEYS

      -- Cycle through the available layout algorithms.
      ((modMask, xK_space), sendMessage NextLayout),
      --Focus selected desktop
      ((modMask, xK_Tab), nextWS),
      --Focus selected desktop
      ((controlMask .|. mod1Mask, xK_Left), prevWS),
      --Focus selected desktop
      ((controlMask .|. mod1Mask, xK_Right), nextWS),
      --  Reset the layouts on the current workspace to default.
      ((modMask .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf),
      -- Move focus to the next window.
      ((modMask, xK_j), windows W.focusDown),
      -- Move focus to the previous window.
      ((modMask, xK_k), windows W.focusUp),
      -- Move focus to the master window.
      ((modMask .|. shiftMask, xK_m), windows W.focusMaster),
      -- Swap the focused window with the next window.
      ((modMask .|. shiftMask, xK_j), windows W.swapDown),
      -- Swap the focused window with the next window.
      ((controlMask .|. modMask, xK_Down), windows W.swapDown),
      -- Swap the focused window with the previous window.
      ((modMask .|. shiftMask, xK_k), windows W.swapUp),
      -- Swap the focused window with the previous window.
      ((controlMask .|. modMask, xK_Up), windows W.swapUp),
      -- Shrink the master area.
      ((controlMask .|. shiftMask, xK_h), sendMessage Shrink),
      -- Expand the master area.
      ((controlMask .|. shiftMask, xK_l), sendMessage Expand),
      -- Push window back into tiling.
      ((controlMask .|. shiftMask, xK_t), withFocused $ windows . W.sink),
      -- Increment the number of windows in the master area.
      ((controlMask .|. modMask, xK_Left), sendMessage (IncMasterN 1)),
      -- Decrement the number of windows in the master area.
      ((controlMask .|. modMask, xK_Right), sendMessage (IncMasterN (-1)))
    ]
      ++
      -- mod-[1..9], Switch to workspace N
      -- mod-shift-[1..9], Move client to workspace N
      [ ((m .|. modMask, k), windows $ onCurrentScreen f i)
        | (i, k) <- zip (workspaces' conf) [xK_1 .. xK_9],
          (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
      ]
      ++
      -- ctrl-shift-{w,e,r}, Move client to screen 1, 2, or 3
      [ ((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_t, xK_y, xK_u] [0 ..],
          (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
      ]

main :: IO ()
main = do
  dbus <- D.connectSession
  -- Request access to the DBus name
  D.requestName
    dbus
    (D.busName_ "org.xmonad.Log")
    [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

  xmonad . ewmh $
    --Keyboard layouts
    --qwerty users use this line
    myBaseConfig
      { startupHook = myStartupHook,
        layoutHook = gaps [(U, 5), (D, 5), (R, 5), (L, 5)] $ myLayout ||| layoutHook myBaseConfig,
        manageHook = manageSpawn <+> myManageHook <+> manageHook myBaseConfig,
        modMask = myModMask,
        borderWidth = myBorderWidth,
        handleEventHook = handleEventHook myBaseConfig,
        focusFollowsMouse = myFocusFollowsMouse,
        workspaces = withScreens 3 myWorkspaces,
        focusedBorderColor = focdBord,
        normalBorderColor = normBord,
        keys = myKeys,
        mouseBindings = myMouseBindings
      }
