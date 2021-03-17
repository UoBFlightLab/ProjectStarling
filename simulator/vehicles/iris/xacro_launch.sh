echo "---- xacro_launch.sh START ------------"
# Generate sim_model sdf
src_path="/src/PX4-Autopilot"

echo "Generating ${PX4_SIM_MODEL} instance ${PX4_INSTANCE} sysid ${PX4_SYSID}"
python3 ${src_path}/Tools/sitl_gazebo/scripts/xacro.py ${src_path}/Tools/sitl_gazebo/models/rotors_description/urdf/${PX4_SIM_MODEL}_base.xacro \
    rotors_description_dir:=${src_path}/Tools/sitl_gazebo/models/rotors_description \
    mavlink_tcp_port:=${PX4_SITL_PORT}  \
    -o /tmp/${PX4_SIM_MODEL}_${PX4_SYSID}.urdf

gz sdf -p  /tmp/${PX4_SIM_MODEL}_${PX4_SYSID}.urdf > /tmp/${PX4_SIM_MODEL}_${PX4_SYSID}.sdf

echo "Model TCP Port set to: ${PX4_SITL_PORT}"
echo "Specific SDF saved to /tmp/${PX4_SIM_MODEL}_${PX4_SYSID}.sdf"

# Modifying drone start location based on PX4 INSTANCE
# Drones will start in a spiral starting from (PX4_SIM_INIT_LOC_X, PX4_SIM_INIT_LOC_Y)
seperation_distance=10
x=0
y=0
dx=0
dy=-1
for (( i=0; i<$1; i++))
do  
    if (( x == y || (x < 0 && x == -y) || (x > 0 && x == 1-y ) )); then
        tmp=$dx
        dx=$((-dy))
        dy=$tmp
    fi
    x=$((x+dx))
    y=$((y+dy))
done

export PX4_SIM_INIT_LOC_X=$(( PX4_SIM_INIT_LOC_X + x*seperation_distance ))
export PX4_SIM_INIT_LOC_Y=$(( PX4_SIM_INIT_LOC_Y + y*seperation_distance ))
echo "Starting location set to ($PX4_SIM_INIT_LOC_X, $PX4_SIM_INIT_LOC_Y, $PX4_SIM_INIT_LOC_Z)"

echo "---- xacro_launch.sh END ------------"