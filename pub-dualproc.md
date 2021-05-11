---
layout: page
title: Topic
subtitle: Dual-process theories of learning and categorization
---

I've argued that much of the existing evidence for dual-process theories of learning and categorization is flawed, and I've aimed to develop better procedures and techniques to investigate this issue. In particular, I've focussed on critiques of evidence for the COVIS dual-process theory, and advocated the use of the Shanks-Darby experimental procedure. For an introduction to this topic area, see Wills et al. (2019), below.


## Selected publications


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

