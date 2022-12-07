# Lekking as collective behaviour

Code and data for agent based model and preliminary blackbuck data analysis for the paper: Akanksha Rathore, Kavita Isvaran, Vishwesha Guttal, Lekking as Collective Behaviour, In Revision. 

# Figure 2: Agent-based model results.

To reproduce results of agent-based model shown in Figure 2A and 2B of the paper, please download and run the code Figure2.R. You need to have installed R and RStudio on your computer and must be familiar about using R. Since the simulations are based on a stochastic agent-based model, you will not see figure identical to those shown in the figure. There will be variation in the figure, especially in Figure 2B, between each run. 

## Lek formation

At the beginning of lekking season, males are attracted towards the breeding ground, leading to the formation of the lek. We can model this process with a few basic rules of movement in a continuous two-dimensional landscape, where individuals update their velocities and positions at discrete time steps. The first rule is that individuals move towards the breeding centre at a constant speed, with some error (or noise) in the direction of motion. Without loss of generality, we assume the centre of the breeding ground to be the origin of our spatial coordinates. The second rule is that individuals repel from each other when they are within a short distance $R_r$ of each other. Between these two rules, the repulsion rule is of higher priority, i.e. when an individual is trying to move towards the breeding centre but encounters another within a distance $R_r$, only the repulsion rule is implemented. 

We place individuals randomly in a landscape and simulate the above rules over many discrete time steps. Animation below illustrates the initial state and the steady state of these simulations, clearly demonstrating that the formation of a lek requires a few basic local interaction rules. 

<br>
<img src="https://github.com/aakanksharathore/Lekking-Perspective/blob/main/lek_formation.gif" alt="Alt text" title="Lek formation model">
<br>

## Foraging departures

We model one of the emergent patterns i.e. (Coordinated) male  departure for foraging. We consider the lek thus formed from the above set of rules. We assume that each individual on the lek can temporarily switch to a foraging state, with a probability $p_f$ at each discrete time step. An individual in the foraging state is attracted towards a nearby foraging site (or a water hole). After reaching the foraging site, the individual switches back to the lekking state and thus returns to the lek arena. For the purpose of this exercise, we do not model within lek spatial fidelity of individuals. 

We now consider two possible ways foraging departures from the lek may happen: A first possibility is where each individual switches to a foraging state independent of the foraging state of other males on the lek. A second possibility invokes social behaviour; specifically, we assume that, at each discrete time step, each individual in the lekking state may switch to the foraging state at a probability that is proportional to the number of neighbours in the foraging state. Once it switches to the foraging state, individuals move towards the foraging site and return to the lekking site, as described above without any further social interactions. 

In the below animations, we display sample trajectories for these possibilities, demonstrating that in the case of the social interaction model, we are likely to observe clustered departures towards the foraging site.

### Without social interactions -- random departures

<br>
<img src="https://github.com/aakanksharathore/Lekking-Perspective/blob/main/rs0.gif" alt="Alt text" title="Random departures - no social interation">
<br>

### With social coying interaction -- synchronized departures

<br>
<img src="https://github.com/aakanksharathore/Lekking-Perspective/blob/main/rs1.gif" alt="Alt text" title="Synchronised departures - copying among neighbours">
<br>


