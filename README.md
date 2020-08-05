This is the answer set program used to generate solution sets for the experiments in:

	Cory Siler and Stephen G. Ware. 
	A good story is one in a million: solution density in narrative generation problems. 
	In AIIDE, 2020. (forthcoming)
	
The program is written for Potassco's Clingo and Asprin software.

A Python-based UI is also provided.


To install the dependencies:

	Download and install Miniconda from the Web. (Testing was done on the Ubuntu-64 version.)
	Change Miniconda to use Python 3.7:
		conda install python=3.7
	Install Asprin's dependency, Clingo 5.4.0:
		conda install -c potassco clingo=5.4.0
	Finally, install Asprin:
		conda install -c potassco asprin
		
For AIIDE artifact evaluation, virtual machine (file too large for GitHub) has been provided with the dependencies preinstalled.
Import the OVA file into virtual-machine software (we used VirtualBox). 
To access the program on the VM (login "user"/"password"), navigate to the "story-generation" folder in Home.
You may need to increase the VM's RAM to solve large instances.

To run, open the "story-generation" folder in the command prompt and run "python generate.py" (use the "-h" argument for details).
This will launch Asprin with the appropriate ASP modules and settings.   
The "optimum" solutions found for the answer set program correspond to solutions.
At the end, the solution-set size is reflected in Asprins "Models/Optimal" output.
