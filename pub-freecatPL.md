---
layout: page
title: Papers
subtitle: Free classification and perceptual learning
---

Most laboratory studies of category learning focus on situations where accurate information about category membership is available for every object observed by the learner; such situations are likely to be rare outside the laboratory. Studies of free classification, and of percpetual learning, consider how we classify, and what we learn, without such information. 

**Perceptual learning is not categorization** - this is because exposure to stimuli can lead to either an enhancement, or a retardation, of subsequent category learning, dependent on the category structure (Wills & McLaren, 1998; Wills et al., 2004). 

**Perceptual learning is automatic unitization and salience modulation** - such is the account of McLaren & Mackintosh (2000, 2002); a variety of work I've done supports this conclusion (Wills & McLaren, 1998; Wills et al., 2004; Welham & Wills, 2011). 

**How to analyse free classification data**: When people are asked to classify objects into as many groups as they like and are not given feedback on their decisions, analyzing the resulting data can be quite complex. I've developed some techniques that have helped analyze a range of free classification data (Haslam et al., 2007; Lawson et al., 2017; Wills & McLaren, 1998). I've released some open-source [software](/software) to support such analyses.


## Selected publications

{% for paper in site.publications reversed %}
  {% if paper.tag == "freecatPL" %}
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
