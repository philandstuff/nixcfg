{ config, lib, pkgs, ... }: {
  home =
    let gcloud = pkgs.google-cloud-sdk.withExtraComponents
      (with pkgs.google-cloud-sdk.components; [ gke-gcloud-auth-plugin pubsub-emulator ]);
    in {
      activation.gcloud = lib.hm.dag.entryAfter ["writeBoundary"] ''
        # disable telemetry
        ${gcloud}/bin/gcloud config set disable_usage_reporting true
      '';
      packages          = [ gcloud ];
      sessionVariables  = {
        CLOUDSDK_CONFIG = "${config.xdg.configHome}/gcloud";
        # https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke
        USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
    };
  };
}
