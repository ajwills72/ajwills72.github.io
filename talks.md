---
layout: page
title: Talks
subtitle: Page under construction
---

{% for talk in site.talks reversed %}
  <p>{{ talk.content | markdownify }}
  <div align="right">
  {% unless talk.pdf == "/no-slides" %}
  <a href="{{ talk.pdf }}">Slides</a>
  {% endunless %}
  {% unless talk.osr == "/no-osr" %}
   : <a href="{{ talk.osr }}">Repository</a>
  {% endunless %}
  </div>
  </p>
{% endfor %}
 
