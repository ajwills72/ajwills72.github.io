---
layout: page
title: Topic
subtitle: Object classification
---

Object classification involves synthesis of object representations over time, not analysis of initially holistic forms - such is the conclusion of around 20 years' work in my lab combining a variety of stimuli and methodologies. Wills et al. (2015) is probably the most important single paper in this workl; Wills et al. (2020), which won a Psychonomic Society Best Paper Award, includes a brief summary of the evidence base to date. Wills et al. (2021), currently available as a preprint, describes some of our most recent work on this topic.

## List of publications

{% for paper in site.publications reversed %}
  {% if paper.tag == "objclass" %}
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
