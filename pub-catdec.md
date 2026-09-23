---
layout: page
title: Publications
subtitle: Categorical decisions
---

{% for paper in site.publications reversed %}
  {% if paper.tag == "catdec" %}
  <p>{{ paper.content | markdownify }}
  <div align="right">
  {% if paper.pdf and paper.pdf != "" and paper.pdf != "/no-text" and paper.pdf != "NA" %}
  <a href="{{ paper.pdf }}">Full-text (PDF)</a>
  {% endif %}
  {% if paper.osr and paper.osr != "" and paper.osr != "/no-osr" and paper.osr != "NA" %}
  <a href="{{ paper.osr }}">Open-access repository</a>
  {% endif %}
  </div>
  </p>
  {% endif %}
{% endfor %}
