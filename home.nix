{ config, pkgs, ... }:

{
  home.username = "duncanjames";
  home.homeDirectory = "/usr/local/google/home/duncanjames";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # Cloud and Kubernetes
    google-cloud-sdk
    kubectl
    k9s
    kustomize
    kubernetes-helm
    kubectx
    stern
    argocd
    fluxcd
    kind
    minikube

    # Infrastructure tools
    tenv
    terraform-docs
    terrascan
    infracost

    # Go Development
    go
    golangci-lint
    gopls
    go-tools
    delve

    # Python Development
    python311
    python311Packages.pip
    python311Packages.virtualenv
    poetry
    uv
    ruff
    black
    mypy
    pre-commit

    # Build tools
    bazelisk
    gnumake

    # Data processing
    jq
    yq-go

    # System and CLI tools
    git
    gh
    nano
    bat
    eza
    fd
    ripgrep
    delta
    fzf
    htop
    tmux
    tree
    curl
    wget
    direnv
    shellcheck
    watch
    which
    fio
  ];

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    shellAliases = {
      # File operations
      ll = "eza -l";
      la = "eza -la";
            
      # System
      update = "home-manager switch --flake .#duncanjames";
    };
    initExtra = builtins.readFile ./modules/zsh/config.zsh;
    envExtra = ''
      export PATH=$HOME/.nix-profile/bin:$PATH
      export XDG_CONFIG_HOME="$HOME/.config"
      export XDG_DATA_HOME="$HOME/.local/share"
      export XDG_STATE_HOME="$HOME/.local/state"
      export KUBECACHEDIR=$HOME/$LOGNAME/.kube/cache
    '';
  };

  programs = {
    #direnv = {
      #enable = true;
      #nix-direnv.enable = true;
    #};

    

    git = {
      enable = true;
      userName = "James Duncan";
      userEmail = "jdun@google.com";
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
        core.editor = "nano";
        push.autoSetupRemote = true;
        user.signingkey = "/usr/local/google/home/duncanjames/.ssh/id_ed25519.pub";
        gpg.format = "ssh";
        commit.gpgsign = true;
        merge.conflictstyle = "zdiff3";
        rebase.autosquash = true;
        rebase.autostash = true;
        commit.verbose = true;
        diff.colorMoved = true;
        diff.algorithm = "histogram";
        feature.experimental = true;
        branch.sort = "committerdate";
        column.ui = "auto";
      };
      delta.enable = true;
    };
  };

  home.sessionVariables = {
    EDITOR = "nano";
    VISUAL = "nano";
    KUBE_EDITOR = "nano";
    PAGER = "less";
    MANPAGER = "sh -c '\''col -bx | bat -l man -p'\''";
    
    # Locale
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    
    # Development
    GOPATH = "$HOME/go";
    USE_BAZEL_VERSION = "latest";    
    # Cloud
    USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
    
    # Python
    PYTHONPATH = "";
    POETRY_VIRTUALENVS_IN_PROJECT = "true";

    TERM = "xterm-256color";
    COLORTERM = "truecolor";

    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
  };
}
