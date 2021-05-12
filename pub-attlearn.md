---
layout: page
title: Topic
subtitle: Attention, errors, and learning
---

When we make an error, fast neural processes re-distribute visual attention in a way that avoids future errors and generally speeds learning (Wills et al., 2007). However, the same processes can also lead to irrational generalizations, perhaps most notably the inverse base-rate effect (Wills et al., 2014). Le Pelley et al. (2016) provides a fairly comprehensive review of work in this area.


## List of publications

{% for paper in site.publications reversed %}
  {% if paper.tag == "attlearn" %}
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
