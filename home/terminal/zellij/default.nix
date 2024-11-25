{
  ...
}:
{
  xdg.configFile."zellij/config.kdl".source = ./config.kdl;
  # https://github.com/zellij-org/zellij/issues/2814
  programs.zellij = {
    enable = true;
  };
}
