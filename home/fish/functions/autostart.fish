function autostart
    pypr & \
    wpaperd & \
    waybar & \
    poweralertd & \
    wl-paste --watch cliphist store & \
    systemctl --user start psi-notify & \
    swayidle -w & \
    nm-applet --indicator &
end
