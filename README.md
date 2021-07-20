# Optimal-Triangle-Projection-with-Prescribed-Area-and-Orientation
This is the companion code of "Mean Oriented Riesz Features for Micro Expression ClassificationAn Optimal Triangle Projector with Prescribed Area and Orientation,
Application to Position-Based Dynamics". In this project, we implement an algebraic procedure to find the optimal solution for the problem of finding the closest triangle under prescribed area and orientation. We adapt our method to implement PBD (point based dynamycs), for 2D mesh editing and compare its performance with respect to the existing PBD implementation with linearisation.

## Getting Started
Our algebraic procedure can be found the function "optimal_Area_constr.m". This method was implemented in Matlab although it can be easily adapted to different programming languages. For illustrative purposes, we have also provided the use-cases presented in the paper and an interactive software demo where meshes of different shapes can be edited and deformed interactively with different constraint sets.

## Running demo, step by step
- Download "interactive_opt_area_comp_demo.m", "optimal_Area_constr.m" along with the functions and meshes folders.
- Run "interactive_opt_area_comp_demo.m" in Matlab
- A guide will apear onscreen with the following parameters
  - **Shapes**: select the mesh shape
  - **Additional Constraints**: include additional constraints to the simulation
  - **Method Comparison**: choose if the simulation compare PBD-opt with PBD-lin
  - **Additional Settings**: Select the maximum number of iterations and stop criteria Tc
  <img src="/Images/demo_guide.png" alt="drawing" width="350"/>
- After choosing the parameters click in start and a window with the selected mesh will appear
- Click and drag the external vertices of the mesh as the initial displacement for the deformation
  <img src="/Images/drag_vertices.png" alt="drawing" width="350"/>
- Press the spacebar
- If the option **pin constraint** was selected, click on the vertices to pin on place. Press the spacebar 
  <img src="/Images/pin_vertices.png" alt="drawing" width="350"/>
- After the simulation has finished, press 'z' to reset the mesh or 'q' to quit 

## Authors
- __Carlos Arango Duque__ - *EnCoV, Université Clermont Auvergne*
- **Adrien Bartoli** - *EnCoV, Université Clermont Auvergne*
