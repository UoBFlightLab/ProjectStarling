import math

import rclpy
from rclpy.node import Node

from std_msgs.msg import String
from geometry_msgs.msg import PoseStamped
import mavros_msgs.msg, mavros_msgs.srv

class RateLimiter():
    def __init__(self,min_period,clock):
        self.min_period = rclpy.duration.Duration(seconds=min_period)
        self.clock = clock
        self.time_of_last = None
    
    def call(self,func):
        if self.time_of_last is None:
            self.time_of_last = self.clock.now()
            time_since_last = self.min_period
        else:
            time_since_last = self.clock.now() - self.time_of_last
        
        if time_since_last > self.min_period:
            func()

class DemoController(Node):

    def __init__(self):
        super().__init__('demo_controller')

        self.start_mission_subscriber = self.create_subscription(
            String,
            '/mission_start',
            self.mission_start_callback,
            1)

        self.emergency_stop_subscriber = self.create_subscription(
            String,
            '/emergency_stop',
            self.emergency_stop_callback,
            1)

        self.position_subscriber = self.create_subscription(
            PoseStamped,
            '/mavros/local_position/pose',
            self.position_callback,
            1)
        
        self.state_subscriber = self.create_subscription(
            mavros_msgs.msg.State,
            '/mavros/state',
            self.state_callback,
            1)

        self.setpoint_publisher = self.create_publisher(
            PoseStamped,
            '/mavros/setpoint_position/local',
            1)

        self.offboard_rate_limiter = RateLimiter(1,self.get_clock())
        self.offboard_client = self.create_client(
            mavros_msgs.srv.SetMode,
            '/mavros/set_mode')
        
        self.arm_rate_limiter = RateLimiter(1,self.get_clock())
        self.arming_client = self.create_client(
            mavros_msgs.srv.CommandBool,
            '/mavros/cmd/arming')

        self.command_rate_limiter = RateLimiter(1, self.get_clock())
        self.command_client = self.create_client(
            mavros_msgs.srv.CommandLong,
            '/mavros/cmd/command'
        )
        
        self.takeoff_offset = 0
        self.land_offset = 0
        self.flight_height = 2.5

        self.controller_command = 'Init'

        self.state = 'Init'

        timer_period = 0.02
        self.timer = self.create_timer(timer_period, self.timer_callback)

        self.vehicle_position = PoseStamped()
        self.vehicle_state = mavros_msgs.msg.State()

        self.initial_position = None

        self.angle = 0
    
    def mission_start_callback(self, msg):
        self.controller_command = "Run"
        print('\033[92m' + 'MISSION START RECEIVED: ' + str(msg) + '\033[0m')

    def emergency_stop_callback(self, msg):
        self.controller_command = "eStop"
        print('\033[91m' + 'EMERGENCY: ESTOP PRESS RECEIVED' + '\033[0m')

    def position_callback(self,msg):
        self.vehicle_position = msg

    def state_callback(self,msg):
        self.vehicle_state = msg

    def gps_position_callback(self,msg):
        self.vehicle_gps_position = msg

    def timer_callback(self):
        if self.controller_command == 'eStop':
            # Currently will just land and disarm
            self.eSTOP()
            self.state = 'DEAD'
            

        if self.state == 'Init':
            if self.initial_position == None and self.vehicle_position != None:
                self.initial_position = self.vehicle_position
                print("Got initial position: ({},{},{})".format(
                    self.initial_position.pose.position.x,
                    self.initial_position.pose.position.y,
                    self.initial_position.pose.position.z
                    ))
                print("Going to ModeSwitch")
                self.state = 'ModeSwitch'

        if self.state == 'ModeSwitch':
            if self.vehicle_state.mode != "OFFBOARD":
                modeSetCall = mavros_msgs.srv.SetMode.Request()
                modeSetCall.custom_mode = "OFFBOARD"
                self.offboard_rate_limiter.call(lambda: self.offboard_client.call_async(modeSetCall))
            else:
                print("Going to Arming")
                self.state = 'Arming'

        if self.state == 'Arming':
            if self.vehicle_state.armed != True:
                armingCall = mavros_msgs.srv.CommandBool.Request()
                armingCall.value = True
                self.arm_rate_limiter.call(lambda: self.arming_client.call_async(armingCall))
            else:
                self.state = 'Takeoff'
                print("Going to Takeoff, Waiting for Missin Start")
        
        if self.state == 'Disarming':
            if self.vehicle_state.armed == True:
                armingCall = mavros_msgs.srv.CommandBool.Request()
                armingCall.value = False
                self.arm_rate_limiter.call(lambda: self.arming_client.call_async(armingCall))
            else:
                print("Disarmed, switch off or restart drone")

        setpoint_msg = None
        if self.initial_position != None:
            setpoint_msg = PoseStamped()
            setpoint_msg.header.stamp = self.get_clock().now().to_msg()
            setpoint_msg.pose = self.initial_position.pose

        if self.state == 'Land':
            print(vehicle_position.pose.position.z)
            if self.land_offset < 1.0:
                self.land_offset += 0.05
                setpoint_msg.pose.position.z -= self.land_offset
            else:
                setpoint_msg.pose.position.z -= self.land_offset
                if self.vehicle_position.pose.position.z < 0.2:
                    self.state = 'Disarming'
                    self.takeoff_offset = 0
                    print('Going to Disarming')

        if self.controller_command == 'Run':
            if self.state == 'Takeoff':
                if self.takeoff_offset < 1.0:
                    self.takeoff_offset += 0.05
                    setpoint_msg.pose.position.z += self.takeoff_offset
                else:
                    setpoint_msg.pose.position.z += self.takeoff_offset
                    # Wait for takeoff to be complete
                    if self.vehicle_position.pose.position.z > 0.95 * self.flight_height:
                        print("Going to Land")
                        self.state = 'Land'

            if self.state == 'Flight':
                radius = 1.0
                self.angle = (self.angle + 0.005) % (2*math.pi)
                setpoint_msg.pose.position.x = radius * math.cos(self.angle)
                setpoint_msg.pose.position.y = radius * math.sin(self.angle)
                setpoint_msg.pose.position.z = 1.0

        if setpoint_msg != None:
            self.setpoint_publisher.publish(setpoint_msg)

        
    def eSTOP(self):
        # eStop achieved by sending ARM command (400)
        # with param2 set to 21196
        commandCall = mavros_msgs.srv.CommandLong.Request()
        commandCall.broadcast = False
        commandCall.command = 400
        commandCall.param1 = 0.0
        commandCall.param2 = 21196.0
        commandCall.param3 = 0.0
        commandCall.param4 = 0.0
        commandCall.param5 = 0.0
        commandCall.param6 = 0.0
        commandCall.param7 = 0.0
        self.command_rate_limiter.call(lambda: self.command_client.call_async(commandCall))
        print('\033[91m' + 'EMERGENCY: KILL SIGNAL SENT' + '\033[0m')


def main(args=None):
    rclpy.init(args=args)

    demo_controller = DemoController()

    rclpy.spin(demo_controller)

    demo_controller.destroy_node()
    rclpy.shutdown()

if __name__ == "__main__":
    main()