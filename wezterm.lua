local wezterm = require "wezterm";

return {
  font = wezterm.font("FiraMono Nerd Font"),
  color_scheme = "Dracula",
  leader = {key="l", mods="CTRL", timeout_milleseconds=500},
  exit_behavior = "Close",
  enable_scroll_bar = true,
  keys = {
  {key="%", mods="LEADER", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
  {key="\"", mods="LEADER", action=wezterm.action{SplitVertical={Domain="CurrentPaneDomain"}}},
  {key="[", mods="CTRL", action=wezterm.action{ActivateTabRelative=-1}},
  {key="]", mods="CTRL", action=wezterm.action{ActivateTabRelative=1}},
  {key="LeftArrow", mods="ALT", action=wezterm.action{AdjustPaneSize={"Left", 2}}},
  {key="RightArrow", mods="ALT", action=wezterm.action{AdjustPaneSize={"Right", 2}}},
  {key="UpArrow", mods="ALT", action=wezterm.action{AdjustPaneSize={"Up", 1}}},
  {key="DownArrow", mods="ALT", action=wezterm.action{AdjustPaneSize={"Down", 1}}},
  {key="c", mods="LEADER", action="ActivateCopyMode"},
  {key="c", mods="CTRL", action="Copy"}
  }
}
