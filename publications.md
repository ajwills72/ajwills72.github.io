---
layout: page
title: Papers
subtitle: Full list of my academic writing
---

At the end of this page, you'll find a full list of the papers I've co-authored during my academic career. If you're looking for my work on a particular topic, you may want to look at one of the topic lists instead, which also include a summary of the work I've done.

## Topics

I work on the psychology and neuroscience of learning and categorization. More specifically, I have published on the following topics within this area:

- [Computational modelling of categorization](pub-compcat.md)

- [Theories of object classification](pub-objclass.md)

- [Attention and learning from errors](pub-attlearn.md)

- [Dual-process theories](pub-dualproc.md)

- [Free classification and perceptual learning](pub-freecatPL.md)

## Publications

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

<hr>


**Full text** links lead to the full-text of the manuscript, normally as a PDF. **Repository** links lead to a location from which the raw data, analysis scripts, etc. can be publicly accessed. Where the full text of the paper is open access and contains such links within it, the repository link leads to the paper. If there is no repository link for a paper you're interested in, please request that I add one.

_Papers are ordered by date of online publication (date of last update for preprints). Journals differ in the time between online publication and allocation of an article to a journal issue, which  means that sometimes papers are out of order in terms of the year of publication as expressed in their APA reference._
