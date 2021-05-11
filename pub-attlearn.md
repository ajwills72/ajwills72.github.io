---
layout: page
title: Papers
subtitle: Attention, errors, and learning
---

## List of publications

{% for paper in site.publications reversed %}
  {% if paper.tag == "attlearn" %}
  <p>{{ paper.content | markdownify }}
  <div align="right">
  <a href="{{ paper.pdf }}">Full-text (PDF)</a> - <a href="{{ paper.osr }}">Open-access repository</a>
  </div>
  </p>
  {% endif %}
{% endfor %}
