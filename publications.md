---
layout: page
title: Publications
subtitle: Full list of my academic writing
---

_Full text_ links lead to the full-text of the manuscript, normally as a PDF. _Repository_ links lead to a location from which the raw data, analysis scripts, etc. can be publicly accessed. Where the full-text of the paper is open access and contains such links within it, the _repository_ link leads to the paper. If there is no _repository_ link for a paper you're interested in, please request that I add one.

{% for paper in site.publications reversed %}
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
{% endfor %}
 

_Publications are ordered by date of first publication (usually online publication). In some cases, this results in them being out of order in terms of the year the journal issue was published_.
