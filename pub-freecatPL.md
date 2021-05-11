---
layout: page
title: Papers
subtitle: Free classification and perceptual learning
---

## List of publications

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
