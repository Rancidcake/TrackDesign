🏎️ F1 Track Simulation and Safety Analysis

Welcome to the F1 Track Design and Safety Analysis MATLAB project!
This simulation models a section of an F1 race track using cubic curves, and evaluates it for danger zones, curvature, and safe driving speeds — including a dynamic crash simulation and a simple animation showing the car moving on the track.

📂 Contents

main_script.m: The entire simulation in one script.

car.png: Image file representing the car in the animation (must be present in the same folder).

README.md: You're reading it!

🚀 Features
✅ Track Generation

The track is modeled using a cubic polynomial:

𝑓
(
𝑥
)
=
𝐴
3
𝑥
3
+
𝐴
2
𝑥
2
+
𝐴
1
𝑥
+
𝐴
0
f(x)=A
3
	​

x
3
+A
2
	​

x
2
+A
1
	​

x+A
0
	​


Realistic scaling is applied to convert units from simulation space to real-world kilometers.

📏 Track Analysis

Track length is calculated using numerical integration.

Critical points (extrema of the curve) are identified using the first derivative.

Curvature (radius of curvature) is computed to detect sharp turns.

⚠️ Danger Zone Detection

Any point on the track with a curve radius less than 100 meters is flagged as dangerous.

These points are visualized with yellow markers.

🏁 Speed & Safety Analysis

Calculates maximum safe speed at every sampled point on the track.

Considers friction coefficient and banking angle to simulate realistic limits.

💥 Crash Simulation

Tests different speeds (150–300 km/h) to estimate where crashes might occur.

Reports the percentage of the track where a crash would happen at each test speed.

🎬 Animation (Optional)

An animated car image (car.png) moves along the track at a given test speed.

Highlights danger zones dynamically if the car exceeds safe speed at any point.

📸 Sample Output
🏁 F1 Track Design and Analysis
===============================
Track length: 1.263 km
Critical Points:
  Point 1: (6.58, 7.39)
  Point 2: (7.42, 6.61)

Danger Zones (radius < 100m): 12 points found
First danger point: (6.58, 7.39)
Last danger point: (7.42, 6.61)

=== SAFETY ANALYSIS SUMMARY ===
Minimum curve radius: 76.4 m
Maximum safe speed: 269.2 km/h
Minimum safe speed: 221.4 km/h
Average safe speed: 243.6 km/h

=== CRASH SIMULATION ===
Speed 150 km/h: ✅ Safe driving
Speed 200 km/h: ✅ Safe driving
Speed 250 km/h: ⚠️  5 crash points (17.2% of track)
Speed 300 km/h: ⚠️  25 crash points (86.2% of track)

📦 Requirements

MATLAB (Tested on R2021a or newer)

car.png image file in the project directory

🧠 How to Use

Run the script: Open main_script.m in MATLAB and run it.

Review output: Check the command window and plots.

Crash Simulation: Read the results for different speeds.

Optional Animation: When prompted, type y to see the car move along the track using an image.

Modify Parameters: Adjust friction, banking angle, or car speed to test different conditions.

📌 Customization Tips

Change Car Image: Replace car.png with any transparent PNG for a custom look.

Adjust Track Shape: Modify the cubic coefficients to change track curvature.

Speed Test Range: Add or remove speeds from test_speeds array.

🙌 Acknowledgments

Created as a MATLAB simulation project to demonstrate:

Curve modeling

Physics-based driving constraints

Basic animation and visualization

Ideal for students learning numerical methods, vehicle dynamics, or just fans of Formula 1!

🧑‍💻 Author

Mayank Hete
