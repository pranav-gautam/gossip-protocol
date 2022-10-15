# gossip-protocol
The goal of this project was to determine the convergence of gossip algorithms through a simulator based on the actors. Gossip type algorithms can be used both for group communication and aggregate for aggregate computation.

In this implementation of the gossip algorithm, a node ends after hearing a rumor 10 times, stopping the transmission of the rumor to a random neighbor. When every node in the network has ended, the gossip implementation's convergence is assessed. We round the number of nodes for 2D grid and imperfect 2D grid topologies to the closest perfect square.

Every node in our implementation of the Push-Sum algorithm is started with the settings of s = i and w = 1, which are recommended in the project handout. For 2D grid and Imperfect 2D grid topologies, the number of nodes is rounded to the next perfect square, much as in our gossip implementation. The primary process starts by requesting the start of a random node, which then sends a message to a random neighbor that contains the tuple (s/2, w/2) while maintaining the values of s/2 and w/2 as its state. An actor adds a message tuple to its state, maintains half of its value, and passes the other half to a random node when it gets a message tuple. The actor terminates, or stops delivering a tuple to a random neighbor, when its s/w ratio does not change by more than 1.0e-10 for three consecutive iterations. The technique converges when the sum estimates, or s/w, converge to the average of the sum.

For gossip algorithm:
![unnamed](https://user-images.githubusercontent.com/64377125/195962036-fb0d8c74-5726-47f9-98e9-11e32599c794.png)

For push-sum algorithm:
![unnamed (1)](https://user-images.githubusercontent.com/64377125/195962051-f51782fb-d4f3-45e2-a737-7d8186e74e7d.png)

The largest network these topologies run on are given in the below table:

Gossip Algorithm:
Line Topology - 10000
Full Topology - 15000
2D Grid Topology - 10000
Imperfect 3D Topology - 10000

Push-Sum Algorithm:
Line Topology - 8000
Full Topology - 12000
2D Grid Topology - 10000
Imperfect 3D Topology - 10000


Second project as a UF Grad student ;)




