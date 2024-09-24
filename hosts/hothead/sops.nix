{ lib, config, ... }:

{
  sops = let
    isEd25519 = k: k.type == "ed25519";
    getKeyPath = k: k.path;
    keys = builtins.filter isEd25519 config.services.openssh.hostKeys;
  in {
    age.sshKeyPaths = builtins.map getKeyPath keys; 
    defaultSopsFile = ./secrets.yaml;
    secrets.fastboi_key.path = "/etc/nixos/secrets/fastboi.key";
    secrets.bigboi_key.path = "/etc/nixos/secrets/bigboi.key";
    secrets.smolerboi_key.path = "/etc/nixos/secrets/smolerboi.key";
    secrets.gamelib_key.path = "/etc/nixos/secrets/gamelib.key";
  };

}
