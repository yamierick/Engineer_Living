This folder is dedicated to a project where I attempted to update the monocentric model to account for 
Dispersed Employers, Highways, and Traffic’s Effect on Urban Form.
Since there is quite a bit of randomness in traffic, this is actually a simulation model that used an RNG to simulate traffic. 
Those results where then applied to the modified monocentric city model.

It was an interesting project for me performed mostly in R. 
The code and report are here.

Traffic_Sim.Rmd
Ran the traffic sim and recorded all the data for each indidvual car at a particular location at a a given time. 
It took 40 hours to run. It could probably be optimzied better.

Traffic_Sim_Data.Rmd
Took all the data from Traffic_Sim formatted so it could be read into the city model and visualized some of the results.

Modeling_City_Sim
Is the actual modified monocentric city model.
It took the outputs from Traffic_Sim_Data and used them to model the city and provide visualizations.


Enjoy.
