---
layout: post
title: How hard is cognitive science?
subtitle: Very, very hard
cover-img: /assets/img/cogscihard.png
thumbnail-img: /assets/img/cogscihard.png
share-img: /assets/img/cogscihard.png
gh-repo: daattali/beautiful-jekyll
tags: [theory]
comments: true
---

Patricia Rich and colleagues [(Rich et al., 2021)](https://psyarxiv.com/k79nv) ask us to imagine what, for most theorists in cognitive science, would seem to be an ideal working environment. It's a world where there is no uncertainty about observations (no replication crisis). It's also a world where there is no problem of induction (cf. Goodman)  - the theorist has full, automatic access to all observations, past and future. And it's a world where we somehow knew that there was only one theory that was consistent with the data (cf. Kuhn). 

Surely, then, coming up with the right theory would be something we could definitely do, given sufficient time and resources? The answer, they argue, is "no". Finding the correct theory is computationally intractable - meaning that even if we could use every atom in the universe as a computer and used all the time that has so far passed in the universe on this universe-computer, that would still not be enough to be sure of finding the right theory.

The basic problem is that the space of theories one would have to check against the data are astronomically large, even if you're only looking for an approximate explanation (say, 50% of the facts) of a subset of behaviour (e.g. the ones you think are important), using the subset of theories you are interested in (e.g. connectionist accounts).

The consolation Patricia and colleagues leave us with is that, if we hit the correct explanation by sheer luck, we'd be able to recognise that it was the right explanation. Not much of a consolation.

This is all very much my first impression of this interesting paper. One thing that I definitely need to think some more about is that the proofs of these claims seem to be specific to certain types of 'languages' in which the theories are expressed (hence e.g. "for some Lf" in Theorem 3). The supplementary materials seem to show that finite-state automata, ACT-R, and some other, more recent, languages are among that set. What is less clear to me is if there exists, or could exist, a language for which this would not apply. And, if so, whether the problem of finding such a langauge would in itself be intractable.

Another thing is that I wonder whether the assumption there is exactly one correct theory makes the problem particularly difficult. If there are in fact a large number of reasonably adequate theories, finding one of them should not be so hard. 

A related point - I think the authors are relying on calculating the amoutn of time to be sure of finding the correct answer. Would this therefore be a type of worst-case scenario, where it could take that long, but we'd be extraordinarily unlucky for it to do so? For example, do the conclusions differ if we estimate the time elapsed before finding the solution 50% of the time?

So, to emphasize, these are initial thoughts on a fascinating paper, and it's very possible the authors have already thought about and addressed these thoughts. Either way, thanks Patricia, Ronald, Todd, and Iris, great work!


Image by Rich et al. (2021)

### UPDATE: 2020-05-19

The tweet of this blog post reached around 10K impressions within 20 hours - clearly Rich and colleagues are saying something people are interested in here, and I'm happy to have helped bring it to a slightly wider audience. 

In other news, I talked to my wife (a Head Teacher of an [SEN school](https://www.millfordschool.co.uk/welcome/staff/senior-leader-ship-team)) about this paper last night, which prompted another couple of random thoughts that might be worth sharing:

- Is cognitive science particularly hard? For example, compared to explaining the set of phenomena encompassed by Newtonian laws? If it is not harder than other sciences, how do we explain the (apparent?) success of theories in other fields?

- If this particular goal of cognitive science is indeed intractable, how should we respond? For example, do we change the goal? Having the wrong goal doesn't necessarily preclude progress. For example, transmutation of base metals into gold (alchemy) isn't possible, but the pursuit of that goal did seem to advance chemistry. However, once we know a goal is unachievable, what is to be gained by keeping the same goal?

### UPDATE: 2020-05-19, part 2

Starting to read the Supplementary Materials, a key point seems to be that if a problem is NP-hard, then it is intractable by the authors' definition. A famous example of an NP-hard problem is the [Travelling Salesperson Problem](https://en.wikipedia.org/wiki/Travelling_salesman_problem), yet humans quickly find near-optimal solutions to these problems (e.g. [MacGregor & Omerod, 1996](https://core.ac.uk/download/pdf/193094737.pdf)). So, intractable by this definition does not mean that humans are unable to make progress on a solution. 
 
