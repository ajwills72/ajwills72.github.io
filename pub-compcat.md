---
layout: page
title: Topic
subtitle: Computational modelling of categorization
---

**Categorical decisions**: I started my academic career working to improve formal models of categorical decisions, the main conclusions from this work being (a) the ratio rule (aka Luce choice axiom) is an inadequate model of categorical decisions (e.g. Wills et al., 2000), and (b) there is a level of representation intermediate betweem stimulus representations and category-label representations (Wills et al., 2006).

**Approaches to model comparison**: Since around 2008, I've been thinking a lot about the problem of formal model comparison, leading to a fairly strong statement of the problem (Wills & Pothos, 2012), followed by some proactive attempts to begin to solve the problem (Wills et al., 2017), including a range of open-source [software](/software).

**The CAL model**: One of the unexpected side benefits of this thinking about model comparison is that it brought me into contact with René Schlegelmilch, who started developing the CAL model of category learning during a visit to my lab in 2017, and which we've worked on together ever since. CAL is a fascinating and sophisticated new model of category learning, which you can read about in preprint form below (Schlegelmilch et al., 2020).  

## Selected publications

{% for paper in site.publications reversed %}
  {% if paper.tag == "compcat" %}
  <p>{{ paper.content | markdownify }}
  <div align="right">
  {% unless paper.pdf == "/no-text" %}
  <a href="{{ paper.pdf }}">Full text</a>
  {% endunless %}
  {% unless paper.osr == "/no-osr" %}
   : <a href="{{ paper.osr }}">Repository</a>
  {% endunless %}
  </div>
  </p>
  {% endif %} 
{% endfor %}
