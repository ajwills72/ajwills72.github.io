---
layout: page
title: Topic
subtitle: Dual-process theories of categorization
---

I've argued that much of the existing evidence for dual-process theories of learning and categorization is flawed, and I've aimed to develop better procedures and techniques to investigate this issue. 

## Start here

{% for paper in site.publications reversed %}
  {% if paper.highlight == "yes" %}
  {% if paper.tag == "dualproc" %}
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
  {% endif %}
{% endfor %}


## All publications on topic

{% for paper in site.publications reversed %}
  {% if paper.tag == "dualproc" %}
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
