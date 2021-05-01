---
layout: page
title: Publications
subtitle: Categorical decisions
---

{% for paper in site.publications reversed %}
  {% if paper.tag == "catdec" %}
  <p>{{ paper.content | markdownify }}
  <div align="right">
  <a href="{{ paper.pdf }}">Full-text (PDF)</a> - <a href="{{ paper.osr }}">Open-access repository</a>
  </div>
  </p>
  {% endif %}
{% endfor %}
