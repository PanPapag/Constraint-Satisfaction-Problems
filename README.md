# Constraint-Satisfaction-Problems

In this session, you can find entirely implemented by me some contraint satisfaction problems (CSPs) using ic and       branch-and-bound ECLiPSe libraries. 

## Getting Started

You can download all solutions to the problems just by typing: 
```
git clone https://github.com/PanPapag/Constraint-Satisfaction-Problems.git
```

### Prerequisites

ECLiPSe environment for constraint programming is mandatory in order to test the solutions to the problems above. You can simply download ECLiPSe here:
```
https://eclipseclp.org/download.html
```

## Problems description 

* [Partition Problem] : One version of the problem of partitioning numbers is as follows. Given a positive integer 𝑁, divide the set 𝑆 = {1, 2, 3, ..., 𝑁} into two subsets 𝑆1 and 𝑆2 (𝑆1 ∩ 𝑆2 = ∅, 𝑆1 ∪ 𝑆2 = 𝑆) such that S1 and S2 have the same number of elements (| 𝑆1 | = | 𝑆2 |), the sum of the elements of 𝑆1 equals the sum of the elements of 𝑆2 (Σ𝑖 ∈𝑆1 𝑖 = Σ𝑗∈𝑆2 𝑗) and the sum of the squares of the elements of 𝑆1 equals the sum of the squares of the elements of 𝑆2 (Σ𝑖 ∈𝑆1 𝑖2 = Σ𝑗∈𝑆2 𝑗2).

* [N Queens] : The N Queen is the problem of placing N chess queens on an N×N chessboard so that no two queens attack each other. 

* [MAXSAT] : In propositional logic, a formula is in conjugate normal form (CNF) when it is a coupling of couplings, where each disjunction, also called a clause, contains literals, that is, propositional symbols or denials propositional symbols. For example, the following formula is in CNF : 
(𝑥1 ∨¬𝑥2 ∨𝑥4)∧(¬𝑥1 ∨𝑥2)∧(¬𝑥1 ∨¬𝑥2 ∨𝑥3)∧(¬𝑥2 ∨¬𝑥4)∧(𝑥2 ∨¬𝑥3)∧(𝑥1 ∨𝑥3)∧(¬𝑥3 ∨𝑥4)
The maximum satisfiability problem (MAXSAT) is to find appropriate assignments (true or false) in proposition symbols to maximize the number of true type sentences. In the above formula, consisting of seven sentences, there is no assignment of values to the propositional symbols to make all the sentences true, but it can be attributed to six of them (by assigning, for example, to all proposition symbols the value true).

* [Scheduling] : Activity/2 events encode activities that should be staffed by individuals. Every activity activity (A, act (S, E)) means that activity A begins at the time S and ends at time E. Suppose that each activity has to be staffed by a single person and that each person can undertake as many activities required, provided that its total working time does not exceed a specified limit. There is also a limitation that not only can a person not take up two overlapping activities, but there must be at least one unit of time between two consecutive activities of each individual.Considering a set of events (activity/2) that encode activities, calling assignment_csp (NP, ST, ASP, ASA), where NP is the number of available individuals and ST is the maximum total time of activities a person can take, assign the given activities to the given individuals in a feasible way, returning to the ASP and ASA variables the representations of the assignment made.

* [Seven-Eleven] : Someone goes to a haberdashery shop to buy four specific products. After asking for what he wants, his shopkeeper gives it to him, he makes the account with the help of a desktop calculator and says: "7,11 euros, please." The customer pays the sum and when the shopkeeper is at the exit he shouts: "Sorry, sir! Instead of adding, I did, by accident, multiply! Come back, please. " After doing the right thing now, he finds with surprise that the result is the same, 7.11 euros. What can be the cost of each product purchased by the customer?
