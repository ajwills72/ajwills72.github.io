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
  {% if paper.pdf and paper.pdf != "" and paper.pdf != "/no-text" and paper.pdf != "NA" %}
  <a href="{{ paper.pdf }}">Full text</a>
  {% endif %}
  {% if paper.osr and paper.osr != "" and paper.osr != "/no-osr" and paper.osr != "NA" %}
   : <a href="{{ paper.osr }}">Repository</a>
  {% endif %}
  </div>
  </p>
  {% endif %} 
{% endfor %}
