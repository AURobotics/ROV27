# CV
this is the folder to add the CV codes before integrating with ros2 \
the code should be in the form of classes/function that can be imported in another file then used. \
REMEBER to put your code inside a folder here with a descriptive name of the feature the code is implementing. 
> you may divide you implementation into multiple files if needed - inside the folder

## Intergation with ROS2
inside the ros2 package is the path: `station/src/<package name>` \
ros2 nodes are written inside: `station/src/<package name>/<package name>` \
your cv code - inside your folder - should be copied from here to `station/src/<package name>/<package name>/cv` \
inside the ros2 nodes import your code from the cv folder and use your classes/functions to implement the cv feature you are working on.

