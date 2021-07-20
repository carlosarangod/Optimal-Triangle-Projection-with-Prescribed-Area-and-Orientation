# Optimal-Triangle-Projection-with-Prescribed-Area-and-Orientation
This is the companion code of "Mean Oriented Riesz Features for Micro Expression ClassificationAn Optimal Triangle Projector with Prescribed Area and Orientation,
Application to Position-Based Dynamics". In this project, we implement an algebraic procedure to find the optimal solution for the problem of finding the closest triangle under prescribed area and orientation. We adapt our method to implement PBD (point based dynamycs), for 2D mesh editing and compare its performance with respect to the existing PBD implementation with linearisation.

## Getting Started
Our algebraic procedure can be found the function "optimal_Area_constr.m". This method was implemented in Matlab although it can be easily adapted to different programming languages.  For illustrative purposes, we have also provided an interactive software demo where meshes of different shapes can be edited and deformed interactively with different constraint sets.

### Running demo, step by step
- Download all the code including the function and meshes folders.
- Run "interactive_opt_area_comp_demo.m" in Matlab
- A guide will apear onscreen 
- 

## Authors
- __Carlos Arango Duque__ - *EnCoV, Université Clermont Auvergne*
- **Adrien Bartoli** - *EnCoV, Université Clermont Auvergne*
