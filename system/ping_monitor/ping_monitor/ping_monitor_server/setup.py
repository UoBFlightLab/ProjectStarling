from setuptools import setup

package_name = 'ping_monitor_server'

setup(
    name=package_name,
    version='0.0.0',
    packages=[package_name],
    data_files=[
        ('share/ament_index/resource_index/packages',
            ['resource/' + package_name]),
        ('share/' + package_name, ['package.xml']),
    ],
    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='mickey li',
    maintainer_email='mickey.li@bristol.ac.uk',
    description='Ping Monitor Server',
    license='MIT License @ mickey li 2022',
    tests_require=['pytest'],
    entry_points={
        'console_scripts': [
            'controller = ping_monitor_server.main:main'
        ],
    },
)
