---
layout: page
title: Papers
subtitle: Dual-process theories of categorizatiojn
---

## List of publications

{% for paper in site.publications reversed %}
  {% if paper.tag == "dualproc" %}
  <p>{{ paper.content | markdownify }}
  <div align="right">
  <a href="{{ paper.pdf }}">Full-text (PDF)</a> - <a href="{{ paper.osr }}">Open-access repository</a>
  </div>
  </p>
  {% endif %}
{% endfor %}
