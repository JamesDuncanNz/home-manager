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
      cat = "bat";
            
      # System
      update = "home-manager switch --flake .#duncanjames";
    };
    initExtra = builtins.readFile ./zsh/config.zsh;
  };

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    git = {
      enable = true;
      userName = "James Duncan";
      userEmail = "jdun@google.com";
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
        core.editor = "nano";
        push.autoSetupRemote = true;
        user.signingkey = "~/.ssh/id_ed25519.pub";
        gpg.format = "ssh";
        commit.gpgsign = true;
      };
      delta.enable = true;
    };


    tmux = {
      enable = true;
      shortcut = "a";
      keyMode = "vi";
      baseIndex = 1;
      escapeTime = 0;
      historyLimit = 50000;
      terminal = "screen-256color";
      customPaneNavigationAndResize = true;
      
      extraConfig = ''
        # Enable mouse control
        set -g mouse on

        # Better split pane keys
        bind | split-window -h
        bind - split-window -v
        unbind '"'
        unbind %

        # Easy config reload
        bind r source-file ~/.config/tmux/tmux.conf \; display-message "tmux.conf reloaded."

        # Don't rename windows automatically
        set-option -g allow-rename off

        # Better colors
        set -g default-terminal "screen-256color"
        set -ga terminal-overrides ",xterm-256color:Tc"

        # Status bar
        set -g status-position bottom
        set -g status-style bg=default
        set -g status-left ""
        set -g status-right "#[fg=green]#H #[fg=yellow]%H:%M"
        
        # Window status
        set-window-option -g window-status-style fg=colour244,bg=default
        set-window-option -g window-status-current-style fg=colour222,bg=default

        # Pane borders
        set -g pane-border-style fg=colour238
        set -g pane-active-border-style fg=colour51

        # Activity monitoring
        setw -g monitor-activity on
        set -g visual-activity on

        # Vi copypaste mode
        set-window-option -g mode-keys vi
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi y send-keys -X copy-selection
        bind-key -T copy-mode-vi r send-keys -X rectangle-toggle

        # Smart pane switching with awareness of Vim splits
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R
      '';
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
    PATH = "$HOME/go/bin:$PATH";
    USE_BAZEL_VERSION = "latest";
    
    # Cloud
    USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
    
    # Python
    PYTHONPATH = "";
    POETRY_VIRTUALENVS_IN_PROJECT = "true";
  };
}
