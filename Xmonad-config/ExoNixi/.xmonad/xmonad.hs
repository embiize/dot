import XMonad
import XMonad.Actions.GridSelect
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.Script
import XMonad.Hooks.SetWMName
import XMonad.Layout.Circle
import XMonad.Layout.Spiral
import XMonad.Layout.Spacing
import XMonad.Layout.Fullscreen
import XMonad.Layout.Grid
import XMonad.Layout.NoBorders
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Util.SpawnOnce
import XMonad.Util.Loggers
import Control.Monad
import System.IO
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import qualified GHC.IO.Handle.Types as H

myLogHook h = do
	dynamicLogWithPP $ tryPP h
tryPP :: Handle -> PP
tryPP h = defaultPP
	{ ppOutput = hPutStrLn h
	, ppSep	   = ""
	, ppTitle  = wrap vtitle vtitle_end . shorten 50 . ( \t -> 
		if t == [] 
		then "Another My Fail Desktop" 
		else t 
	)
	, ppLayout = wrap lay_start lay_end .
	( \t -> case t of
	"Spacing 10 Grid"		-> "grid.xbm)" ++ space ++ "Grid"
	"Spacing 10 Spiral"		-> "spiral.xbm)" ++ space ++ "Spiral"
	"Spacing 10 Circle"		-> "circle.xbm)" ++ space ++ "Circle"
	"Spacing 10 Tall"		-> "sptall.xbm)" ++ space ++ "Tile"
	"Mirror Spacing 10 Tall"	-> "mptall.xbm)" ++ space ++ "Mirror Tile"
	"Full"						-> "full.xbm)" ++ space ++ "Full"
	)					
	, ppOrder  = \(ws:l:t:_) -> [l,t]
	}
myLogHook2 h = do
	dynamicLogWithPP $ tryPP2 h
tryPP2 :: Handle -> PP
tryPP2 h = defaultPP
	{ ppOutput	    = hPutStrLn h
	, ppCurrent	    = dzenColor col5 col3 . pad . wrap space space
	, ppVisible	    = dzenColor col6 col3 . pad . wrap space space
	, ppHidden	    = dzenColor col6 col3 . pad . wrap space space
	, ppHiddenNoWindows = dzenColor col6 col3 . pad . wrap space space
	, ppWsSep	    = ""
	, ppSep		    = ""
	, ppTitle	    = \t -> "^bg(" ++ col2 ++ ")^fg(" ++ col3 ++ ")^i(/home/crucia/.xmonad/icons/mr1.xbm)^fg()"
	, ppLayout	    = \l -> "^bg(" ++ col3 ++ ")^fg(" ++ col4 ++ ")^i(/home/crucia/.xmonad/icons/mr1.xbm)^fg()"
	, ppOrder	    = \(ws:l:t:_) -> [l,ws,t]
	}
myWorkspace :: [String]
myWorkspace = clickable $ [ "Net"
	, "Term"
	, "Web"
	, "Edit"
	, "Other"
	]
	where clickable l = [ "^ca(1,xdotool key alt+" ++ show (n) ++ ")" ++ ws ++ "^ca()" |
		(i,ws) <- zip [1..] l,
		let n = i ]

myKeys = [ ((mod1Mask, xK_p), spawn "dmenu_run -b") 
		, ((mod1Mask, xK_q), spawn "killall dzen2; xmonad --recompile; xmonad --restart")]

startup = do
	spawnOnce "sh /home/crucia/.xmonad/scripts/autostart.sh"
myLayout = avoidStruts $ smartBorders (  sGrid ||| sSpiral ||| sCircle ||| sTall ||| Mirror sTall ||| Full )
	where 
	 sTall = spacing 10 $ Tall 1 (1/2) (1/2)
	 sGrid = spacing 10 $ Grid
	 sCircle = spacing 10 $ Circle
	 sSpiral = spacing 10 $ spiral (toRational (2/(1+sqrt(5)::Double)))

myApps = composeAll 
	[ className =? "Gimp" --> doFloat
	, className =? "mplayer2" --> doFloat 
	, className =? "Oblogout" --> doFullFloat
	, className =? "Viewnior" --> doFullFloat 
	]

main = do
	barAtas <- spawnPipe bar1
	barAtasKanan <- spawnPipe bar2
	barBawah <- spawnPipe bar3
	barBawahKanan <- spawnPipe bar4
	barMenu <- spawnPipe bar5
	xmonad $ defaultConfig
	 { manageHook = myApps <+> manageDocks <+> manageHook defaultConfig
	 , layoutHook = myLayout
	 , modMask = mod1Mask
	 , workspaces = myWorkspace
	 , terminal = "urxvtc"
	 , focusedBorderColor = "#4c4c4c"
	 , normalBorderColor = col2
	 , borderWidth = 3
	 , startupHook = startup <+> setWMName "LG3D"
	 , logHook = myLogHook barAtas <+> myLogHook2 barBawah
	 } `additionalKeys` myKeys

space = "   "
col1 = "#fcfcfc"
col2 = "#2d2d2d"
col3 = "#d2d2d2"
col4 = "#ff4660"
col5 = "#010101"
col6 = "#4d4d4d"
bar1 = "dzen2 -p -ta l -e 'button3=' -fn 'Exo 2-8' -fg '" ++ col1 ++ "' -bg '" ++ col2 ++ "' -h 24 -w 750"
bar2 = "sh /home/crucia/.xmonad/scripts/dzen_info_1.sh"
bar3 = "dzen2 -p -ta l -e 'button3=' -fn 'Exo 2-8' -fg '" ++ col1 ++ "' -bg '" ++ col2 ++ "' -h 24 -w 750 -y 750 -x 60"
bar4 = "sh /home/crucia/.xmonad/scripts/dzen_info_2.sh"
bar5 = "sh /home/crucia/.xmonad/scripts/dzen_menu.sh"
dir_icon = "^ca(1,xdotool key alt+space)^i(/home/crucia/.xmonad/icons/"
vtitle = "^bg(" ++ col3 ++ ")^fg(" ++ col2 ++ ")" ++ space
vtitle_end = space ++ "^bg()^fg(" ++ col3 ++ ")^i(/home/crucia/.xmonad/icons/mt1.xbm)^fg()"
lay_start ="^bg(" ++ col4 ++ ")" ++ space ++ dir_icon
lay_end = "^ca()^bg(" ++ col3 ++ ")^fg(" ++ col4 ++ ")^i(/home/crucia/.xmonad/icons/mt1.xbm)^fg()"
