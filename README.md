# simple-pick-and-place-planning
---

### Installation

``` bash
cd /path/to/catkin_ws/src
git clone https://github.com/furushchev/simple-pick-and-place-planning
wstool merge simple-pick-and-place-planning/xdot.rosinstall # bugfix for smach_viewer
wstool up xdot
rosdep install --from-paths . --ignore-src -r -n -y
cd ../
catkin_make # or catkin build
```

### Demo

``` bash
$ roslaunch simple_pick_and_place_planning 0-basic.launch
$ roslaunch simple_pick_and_place_planning 1-with_failure.launch
```

