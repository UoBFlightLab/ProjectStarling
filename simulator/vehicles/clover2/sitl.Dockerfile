FROM ros:foxy as cloverconfig

# Get the Clover config files
RUN git clone --depth 1 -j4 \
    -b v1.10.1-clever https://github.com/CopterExpress/Firmware /src/PX4-Autopilot

FROM starling-sim-px4-sitl

# Copy over clover specific configuration
COPY --from=cloverconfig /src/PX4-Autopilot/ROMFS/px4fmu_common/init.d-posix/4500_clover /src/PX4-Autopilot/ROMFS/px4fmu_common/init.d-posix/4500_clover
COPY --from=cloverconfig /src/PX4-Autopilot/ROMFS/px4fmu_common/init.d/airframes/4500_clover4 /src/PX4-Autopilot/ROMFS/px4fmu_common/init.d/airframes/4500_clover4
COPY --from=cloverconfig /src/PX4-Autopilot/ROMFS/px4fmu_common/init.d/rc.clever /src/PX4-Autopilot/ROMFS/px4fmu_common/init.d/rc.clever

# Set estimator
ENV PX4_ESTIMATOR ekf2

# Set default model
ENV PX4_SIM_MODEL clover
