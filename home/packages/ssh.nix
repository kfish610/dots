{ ... }:

{
  programs = {
    ssh = {
      enable = true;
      enableDefaultConfig = false; # Remove once this is deprecated
      settings = {
        "lambda" = {
          HostName = "lambda.cs.illinois.edu";
          User = "kfish";
          ForwardAgent = true;
        };
        "icc" = {
          HostName = "cc-login.campuscluster.illinois.edu";
          User = "kf23";
          ForwardAgent = true;
          ControlMaster = "auto";
          ControlPath = "~/.ssh/control-%r@%h:%p";
          ControlPersist = "10m";
        };
        "unity" = {
          HostName = "unity.rc.umass.edu";
          User = "kfisher_access-ci_org";
          ForwardAgent = true;
        };
        "*.unity.rc.umass.edu" = {
          User = "kfisher_access-ci_org";
          ForwardAgent = true;
          ProxyJump = "unity";
        };
        "unity-cpu" = {
          User = "kfisher_access-ci_org";
          ForwardAgent = true;
          ProxyCommand = "ssh unity './vscode.sh cpu'";
          StrictHostKeyChecking = "no";
        };
        "unity-gpu" = {
          User = "kfisher_access-ci_org";
          ForwardAgent = true;
          ProxyCommand = "ssh unity './vscode.sh gpu'";
          StrictHostKeyChecking = "no";
        };
        "unity-gpu-preempt" = {
          User = "kfisher_access-ci_org";
          ForwardAgent = true;
          ProxyCommand = "ssh unity './vscode.sh gpu-preempt'";
          StrictHostKeyChecking = "no";
        };
      };
    };

    keychain = {
      enable = true;
      keys = [ "id_ed25519" ];
    };
  };
}
