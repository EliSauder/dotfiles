{config, pkgs, ... }: {
  programs.obs-studio = {
      enable = true;
      #plugins = with pkgs.obs-studio-plugins; [
      #    wlrobs
      #    obs-pipewire-audio-capture
      #    obs-vkcapture
      #    obs-vaapi
      #    obs-vintage-filter
      #    obs-tuna
      #    input-overlay
      #    obs-backgroundremoval
      #];
  };
}
