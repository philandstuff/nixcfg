{ config, lib, pkgs, ... }: {
  home =
    let gcloud = pkgs.google-cloud-sdk.withExtraComponents
      (with pkgs.google-cloud-sdk.components; [ gke-gcloud-auth-plugin kubectl ]);
    in {
      activation.gcloud = lib.hm.dag.entryAfter ["writeBoundary"] ''
        # disable telemetry
        ${gcloud}/bin/gcloud config set disable_usage_reporting true
      '';
      packages          = [ gcloud ];
      sessionVariables  = {
        CLOUDSDK_CONFIG = "${config.xdg.configHome}/gcloud";
    };
  };
}
