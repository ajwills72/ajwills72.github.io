---
layout: page
title: Quotes
subtitle: "Bite-size wisdom"
---

{% for quote in site.quotes reversed %}
  <p>{{ quote.content | markdownify }}
  <div align="right">
  - {{ quote.attrib }} ({{ quote.year }}) 
  {% if quote.source and quote.source != "" and quote.source != "/no-source" and quote.source != "no_source" and quote.source != "NA" %}
   : <a href="{{ quote.source }}">source</a>
  {% endif %}
  </div>
  </p>
{% endfor %}
 
