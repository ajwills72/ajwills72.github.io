---
layout: page
title: Topic
subtitle: Human-centered AI
---

Human-centred AI puts human behaviour and experience at the heart of artificial intelligence research. My first publication in this area was in 2025. My work to date mainly centres on the comparison of performance in humans and AI systems across a variety of tasks.

## List of publications

{% for paper in site.publications reversed %}
  {% if paper.tag == "HAI" %}
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
