---
layout: page
title: Topic
subtitle: Dual-process theories of learning and categorization
---

I've argued that much of the existing evidence for dual-process theories of learning and categorization is flawed, and I've aimed to develop better procedures and techniques to investigate this issue. In particular, I've focussed on critiques of evidence for the COVIS dual-process theory, and advocated the use of the Shanks-Darby experimental procedure. For an introduction to this topic area, see Wills et al. (2019), below.


## Publications

**Full text** links lead to the full-text of the manuscript, normally as a PDF. **Repository** links lead to a location from which the raw data, analysis scripts, etc. can be publicly accessed. Where the full-text of the paper is open access and contains such links within it, the repository link leads to the paper. If there is no repository link for a paper you're interested in, please request that I add one.

<hr>

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


<hr>

_Papers are ordered by date of online publication (date of last update for preprints). Journals differ in the time between online publication and allocation of an article to a journal issue, which  means that sometimes papers are out of order in terms of the year of publication as expressed in their APA reference._
