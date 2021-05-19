---
layout: page
title: Quotes
subtitle: Well, one quote for now...
---

{% for quote in site.quotes reversed %}
  <p>{{ quote.content | markdownify }}
  <div align="right">
  - {{ quote.attrib }} ({{ quote.year }}) 
  {% unless quote.source == "/no-source" %}
   : <a href="{{ quote.source }}">source</a>
  {% endunless %}
  </div>
  </p>
{% endfor %}
 
