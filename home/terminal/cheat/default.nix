{ ...
}: {
  home.file = {
    ".config/cheat/conf.yml".source = ./conf.yml;
    ".config/cheat/cheatsheets/personal" = {
      source = ./personal;
      recursive = true;
    };
  };
}
